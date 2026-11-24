import json
from pathlib import Path
import sys
import tempfile
import unittest

sys.path.insert(0, str(Path(__file__).resolve().parent))
from smoke_test_stack_models import classify, inspect_csv
from summarize_stack_smoke import sha, summarize


class SmokeOutputTests(unittest.TestCase):
    def inspect(self, text, samples=2):
        with tempfile.TemporaryDirectory() as temp:
            path = Path(temp) / "chain.csv"
            path.write_text(text)
            return inspect_csv(path, samples)

    def test_requires_actual_complete_draws_not_just_a_csv_header(self):
        self.assertFalse(self.inspect("# CmdStan\nlp__,x\n")["valid"])
        self.assertFalse(self.inspect("lp__,x\n-1,2\n")["valid"])

    def test_rejects_nonfinite_log_probability(self):
        for value in ["nan", "-inf", "inf"]:
            result = self.inspect(f"lp__,x\n-1,2\n{value},3\n")
            self.assertFalse(result["valid"])

    def test_retains_short_chain_diagnostics_without_claiming_convergence(self):
        result = self.inspect("# settings\nlp__,divergent__,treedepth__,yrep\n-1,1,4,nan\n-2,0,2,3\n# elapsed\n")
        self.assertTrue(result["valid"])
        self.assertEqual(result["divergent_draws"], 1)
        self.assertEqual(result["max_treedepth"], 4)
        self.assertEqual(result["nonfinite_columns"], ["yrep"])
        json.dumps(result, allow_nan=False)

    def test_distinguishes_build_and_data_failures(self):
        self.assertEqual(classify("Semantic error in model.stan", "build"), "stanc_error")
        self.assertEqual(classify("Undefined symbols for architecture arm64", "build"), "cpp_or_link_error")
        self.assertEqual(classify("mismatch in dimension declared", "run"), "data_shape_or_missing")


class SmokeSummaryTests(unittest.TestCase):
    def setUp(self):
        self.temp = tempfile.TemporaryDirectory()
        self.addCleanup(self.temp.cleanup)
        self.root = Path(self.temp.name)
        self.model = self.root / "models/the_stack/example"
        self.model.mkdir(parents=True)
        (self.model / "model.stan").write_text("parameters { real x; } model { x ~ normal(0, 1); }")
        (self.model / "data.json").write_text("{}")
        self.run = self.root / "run"
        self.run.mkdir()
        self.record = {
            "model": "models/the_stack/example", "status": "passed",
            "source_sha256": sha(self.model / "model.stan"), "data_sha256": sha(self.model / "data.json"),
            "started": "start", "completed": "end",
            "build": {"returncode": 0, "timed_out": False},
            "run": {"returncode": 0, "timed_out": False},
            "output": {"draws": 5, "valid": True, "finite_log_probability": True,
                       "divergent_draws": 1, "nonfinite_columns": ["yrep"]},
        }
        self.state = {"state": "complete", "planned": 1, "completed": 1, "counts": {"passed": 1},
                      "settings": {"warmup": 5, "samples": 5, "seed": 12345, "adaptation": False,
                                   "stepsize": 0.01, "max_depth": 4, "build_timeout": 180, "run_timeout": 30}}
        self.save()

    def save(self):
        (self.run / "status.json").write_text(json.dumps(self.state))
        (self.run / "results.jsonl").write_text(json.dumps(self.record) + "\n")

    def test_complete_coverage_reports_diagnostics_separately(self):
        result = summarize([self.run], self.root)
        self.assertEqual(result["counts"], {"passed": 1})
        self.assertEqual(result["completed_with_divergences"], 1)
        self.assertEqual(result["completed_with_nonfinite_outputs"], 1)
        self.assertEqual(result["completed_without_recorded_divergences_or_nonfinite_outputs"], 0)

    def test_rejects_duplicate_unfinished_and_missing_coverage(self):
        with self.assertRaisesRegex(ValueError, "Duplicate"):
            summarize([self.run, self.run], self.root)
        self.state["state"] = "running"
        self.save()
        with self.assertRaisesRegex(ValueError, "not finished"):
            summarize([self.run], self.root)
        self.state["state"] = "complete"
        self.save()
        extra = self.root / "models/the_stack/untested"
        extra.mkdir()
        (extra / "model.stan").write_text("model {}")
        with self.assertRaisesRegex(ValueError, "Expected 2 results"):
            summarize([self.run], self.root)

    def test_rejects_changed_inputs_and_incorrect_success(self):
        (self.model / "data.json").write_text('{"changed": true}')
        with self.assertRaisesRegex(ValueError, "differ from checked-in"):
            summarize([self.run], self.root)
        self.record["data_sha256"] = sha(self.model / "data.json")
        self.record["output"]["draws"] = 4
        self.save()
        with self.assertRaisesRegex(ValueError, "does not satisfy"):
            summarize([self.run], self.root)


if __name__ == "__main__":
    unittest.main()
