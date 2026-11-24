import json
from pathlib import Path
import sys
import tempfile
import unittest
from unittest.mock import patch

sys.path.insert(0, str(Path(__file__).resolve().parent))
import import_stack_stan_models as importer
from dataclasses import asdict


def record(original, modernize=False):
    transformed, changes = importer.modernize_text(original.decode())
    model = transformed.encode() if modernize else original
    return {"id": "test", "repository": "owner/project", "repository_path": "examples/model.stan",
            "source_url": "https://github.com/owner/project/blob/" + "a" * 40 + "/examples/model.stan",
            "commit": "a" * 40, "licenses": ["MIT"],
            "source_sha256": importer.sha256(original), "model_sha256": importer.sha256(model),
            "compile_status": "modernized_pass" if modernize else "original_pass",
            "modernization_edits": asdict(changes), "pedantic_warning_free": True, "review_flags": []}


class ImportTests(unittest.TestCase):
    def test_modernization_preserves_original_and_existing_layout(self):
        original = b"data { int N; real y[N]; } parameters { real mu; } model { y ~ normal(mu, 1); }\n"
        row = record(original, modernize=True)
        with tempfile.TemporaryDirectory() as temp:
            dest = importer.import_one(row, original, Path(temp))
            self.assertEqual((dest / "model_original.stan").read_bytes(), original)
            self.assertEqual(importer.sha256((dest / "model.stan").read_bytes()), row["model_sha256"])
            self.assertEqual(set(p.name for p in dest.iterdir()), {"model.stan", "model_original.stan", "data.json", "metadata.json", "run.py", "source.md"})
            self.assertTrue(json.loads((dest / "metadata.json").read_text())["data_placeholder"])
            with self.assertRaises(FileExistsError):
                importer.import_one(row, original, Path(temp))

    def test_unchanged_source_is_byte_exact_without_duplicate_original(self):
        original = b"data { int N; }\nparameters { real x; } model { x ~ normal(0, N); }"
        with tempfile.TemporaryDirectory() as temp:
            dest = importer.import_one(record(original), original, Path(temp))
            self.assertEqual((dest / "model.stan").read_bytes(), original)
            self.assertFalse((dest / "model_original.stan").exists())

    def test_source_and_model_drift_are_rejected_before_directory_creation(self):
        original = b"parameters { real x; } model { x ~ normal(0, 1); }\n"
        with tempfile.TemporaryDirectory() as temp:
            for field in ["source_sha256", "model_sha256"]:
                row = record(original)
                row[field] = "0" * 64
                with self.assertRaises(ValueError):
                    importer.import_one(row, original, Path(temp))
                self.assertFalse(list(Path(temp).iterdir()))

    def test_partial_synthetic_data_remains_an_explicit_placeholder(self):
        original = b"data { int N; } parameters { real x; } model { x ~ normal(0, N); }\n"
        with tempfile.TemporaryDirectory() as temp:
            dest = importer.import_one(record(original), original, Path(temp))
            with patch.object(importer.subprocess, "Popen") as popen:
                popen.return_value.communicate.return_value = ("", "")
                popen.return_value.returncode = 0
                result = importer.generate_one(dest, None, ["N"], 1)
            self.assertEqual(result["data_status"], "synthetic_generation_failed")
            metadata = json.loads((dest / "metadata.json").read_text())
            self.assertTrue(metadata["data_placeholder"])
            self.assertEqual(json.loads((dest / "data.json").read_text()), {})

    def test_timed_out_generator_is_reaped_and_recorded(self):
        original = b"data { int N; } parameters { real x; } model { x ~ normal(0, N); }\n"
        with tempfile.TemporaryDirectory() as temp:
            dest = importer.import_one(record(original), original, Path(temp))
            with patch.object(importer.subprocess, "Popen") as popen, patch.object(importer.os, "killpg") as kill:
                popen.return_value.communicate.side_effect = [importer.subprocess.TimeoutExpired("generator", 1), ("", "")]
                popen.return_value.pid = 123
                result = importer.generate_one(dest, None, ["N"], 1)
            kill.assert_called_once_with(123, importer.signal.SIGKILL)
            self.assertEqual(result["data_status"], "synthetic_generation_failed")


if __name__ == "__main__":
    unittest.main()
