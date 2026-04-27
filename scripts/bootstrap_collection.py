#!/usr/bin/env python3
"""Materialize the Stan/SafeStan regression model corpus.

This script copies selected Stan example-models files and writes the ForestDB
translations used by this repository. It expects a local clone of
stan-dev/example-models; by default it uses /tmp/stan-example-models.
"""

from __future__ import annotations

import argparse
import json
import os
import shutil
import stat
import textwrap
from pathlib import Path
from typing import Any


ROOT = Path(__file__).resolve().parents[1]
EXAMPLE_MODELS_COMMIT = "e5b7d9e2e9ecc375805c7e49e4a4d4c1882b5e3b"
EXAMPLE_MODELS_BASE = f"https://github.com/stan-dev/example-models/blob/{EXAMPLE_MODELS_COMMIT}"
FORESTDB_BASE = "https://forestdb.org/models"

DEFAULT_RUN = {
    "chains": 4,
    "iter_warmup": 250,
    "iter_sampling": 250,
    "seed": 12345,
}


def stan(code: str) -> str:
    return textwrap.dedent(code).strip() + "\n"


STAN_TUTORIALS = [
    {
        "id": "bernoulli",
        "title": "Bernoulli Estimator",
        "difficulty": "easy",
        "description": "One-parameter Bernoulli model for binary outcomes.",
        "source_path": "basic_estimators/bernoulli",
    },
    {
        "id": "normal-location",
        "title": "Normal Location",
        "difficulty": "easy",
        "description": "Normal mean estimator with data in transformed data.",
        "source_path": "basic_estimators/normal_loc",
        "data": {},
    },
    {
        "id": "truncated-normal",
        "title": "Truncated Normal",
        "difficulty": "easy",
        "description": "Normal estimator with truncation in the likelihood.",
        "source_path": "basic_estimators/normal_truncated",
    },
    {
        "id": "censored-normal",
        "title": "Censored Normal",
        "difficulty": "medium",
        "description": "Normal estimator with censored observations.",
        "source_path": "basic_estimators/normal_censored",
    },
    {
        "id": "multivariate-normal",
        "title": "Multivariate Normal",
        "difficulty": "medium",
        "description": "Multivariate normal mean/covariance estimator.",
        "source_path": "basic_estimators/normal_multi",
    },
    {
        "id": "negative-binomial",
        "title": "Negative Binomial",
        "difficulty": "easy",
        "description": "Count model using the negative binomial distribution.",
        "source_path": "basic_estimators/negative_binomial",
    },
    {
        "id": "negative-binomial2",
        "title": "Negative Binomial 2",
        "difficulty": "easy",
        "description": "Alternative mean/precision parameterization for counts.",
        "source_path": "basic_estimators/negative_binomial2",
    },
    {
        "id": "normal-mixture",
        "title": "Normal Mixture",
        "difficulty": "medium",
        "description": "Two-component normal mixture model.",
        "source_path": "basic_estimators/normal_mixture",
    },
    {
        "id": "k-component-normal-mixture",
        "title": "K-Component Normal Mixture",
        "difficulty": "medium",
        "description": "Finite normal mixture with configurable component count.",
        "source_path": "basic_estimators/normal_mixture_k",
    },
    {
        "id": "k-component-normal-mixture-simplex",
        "title": "K-Component Normal Mixture with Simplex Weights",
        "difficulty": "medium",
        "description": "Finite mixture using simplex-valued component weights.",
        "source_path": "basic_estimators/normal_mixture_k_prop",
    },
    {
        "id": "simple-regression",
        "title": "Simple Regression",
        "difficulty": "easy",
        "description": "Introductory linear regression from the Stan chapter material.",
        "source_path": "knitr/chapter1/simplest-regression",
    },
    {
        "id": "vector-regression",
        "title": "Vector Regression",
        "difficulty": "easy",
        "description": "Vectorized linear regression from the Stan chapter material.",
        "source_path": "knitr/chapter1/vector-regression",
    },
    {
        "id": "two-parameter-logistic-irt",
        "title": "Two-Parameter Logistic IRT",
        "difficulty": "medium",
        "description": "Two-parameter item-response model from Stan education material.",
        "source_path": "education/tutorial_twopl/twopl",
    },
    {
        "id": "two-pl-regression-centered",
        "title": "2PL Regression Centered",
        "difficulty": "advanced",
        "description": "Centered hierarchical 2PL regression model.",
        "source_path": "education/tutorial_twopl/reg_centered",
    },
    {
        "id": "two-pl-regression-noncentered",
        "title": "2PL Regression Noncentered",
        "difficulty": "advanced",
        "description": "Non-centered hierarchical 2PL regression model.",
        "source_path": "education/tutorial_twopl/reg_noncentered",
    },
]


STAN_CASE_STUDIES = [
    {
        "id": "golf-putting-logistic",
        "title": "Golf Putting Logistic",
        "difficulty": "easy",
        "description": "Logistic model for golf putting success by distance.",
        "source_path": "knitr/golf/golf1",
    },
    {
        "id": "worldcup-first-try",
        "title": "World Cup First Try",
        "difficulty": "medium",
        "description": "Initial World Cup scoring model.",
        "source_path": "knitr/world-cup/worldcup_first_try",
    },
    {
        "id": "worldcup-no-sqrt",
        "title": "World Cup No Square Root",
        "difficulty": "medium",
        "description": "World Cup model variant without square-root transform.",
        "source_path": "knitr/world-cup/worldcup_no_sqrt",
    },
    {
        "id": "worldcup-fixed",
        "title": "World Cup Fixed",
        "difficulty": "medium",
        "description": "Revised World Cup scoring model with fixed issues.",
        "source_path": "knitr/world-cup/worldcup_fixed",
    },
    {
        "id": "worldcup-replication",
        "title": "World Cup with Replication",
        "difficulty": "advanced",
        "description": "World Cup scoring model with generated replications.",
        "source_path": "knitr/world-cup/worldcup_with_replication",
    },
    {
        "id": "worldcup-no-prior",
        "title": "World Cup No Prior",
        "difficulty": "medium",
        "description": "World Cup model variant without explicit prior.",
        "source_path": "knitr/world-cup/worldcup_first_try_noprior",
    },
    {
        "id": "binary-trials-no-pool",
        "title": "Binary Trials No Pooling",
        "difficulty": "easy",
        "description": "Independent binomial rates for pooled binary-trial case study.",
        "source_path": "knitr/pool-binary-trials/no-pool",
    },
    {
        "id": "binary-trials-complete-pool",
        "title": "Binary Trials Complete Pooling",
        "difficulty": "easy",
        "description": "Complete pooling binomial model for binary trials.",
        "source_path": "knitr/pool-binary-trials/pool",
    },
    {
        "id": "binary-trials-hierarchical",
        "title": "Binary Trials Hierarchical",
        "difficulty": "medium",
        "description": "Hierarchical binomial model for binary trials.",
        "source_path": "knitr/pool-binary-trials/hier",
    },
    {
        "id": "binary-trials-hier-logit",
        "title": "Binary Trials Hierarchical Logit",
        "difficulty": "medium",
        "description": "Hierarchical logistic parameterization for binary trials.",
        "source_path": "knitr/pool-binary-trials/hier-logit",
    },
    {
        "id": "binary-trials-hier-logit-centered",
        "title": "Binary Trials Hierarchical Logit Centered",
        "difficulty": "medium",
        "description": "Centered hierarchical logistic model for binary trials.",
        "source_path": "knitr/pool-binary-trials/hier-logit-centered",
    },
    {
        "id": "sir-ode",
        "title": "SIR ODE",
        "difficulty": "advanced",
        "description": "Susceptible-infected-recovered ODE model.",
        "source_path": "knitr/convert-odes/sir",
    },
    {
        "id": "one-compartment-mm-ode",
        "title": "One-Compartment Michaelis-Menten ODE",
        "difficulty": "advanced",
        "description": "One-compartment pharmacokinetic ODE with Michaelis-Menten elimination.",
        "source_path": "knitr/convert-odes/one_comp_mm_elim_abs",
    },
    {
        "id": "soil-incubation-ode",
        "title": "Soil Incubation ODE",
        "difficulty": "advanced",
        "description": "Two-pool soil carbon incubation ODE model.",
        "source_path": "knitr/soil-carbon/soil_incubation",
        "data_path": "knitr/soil-carbon/AK_T25.data.json",
        "data_keys": ["totalC_t0", "t0", "N_t", "ts", "eCO2mean"],
    },
    {
        "id": "bym2-spatial-poisson",
        "title": "BYM2 Spatial Poisson",
        "difficulty": "advanced",
        "description": "Spatial Poisson BYM2 model with ICAR component.",
        "source_path": "knitr/car-iar-poisson/update_2021_02/bym2",
        "data_path": "knitr/car-iar-poisson/update_2021_02/scotland_connected.data.json",
    },
]


FOREST_MODELS = [
    {
        "id": "binomial-inference",
        "title": "Inferences with Binomials",
        "difficulty": "easy",
        "description": "Beta-binomial update for a binomial observation.",
        "source_url": f"{FORESTDB_BASE}/binomial-inference.html",
        "translation_note": "Direct continuous-parameter translation.",
        "data": {"N": 20, "y": 13},
        "stan": stan(
            """
            data {
              int<lower=0> N;
              int<lower=0, upper=N> y;
            }
            parameters {
              real<lower=0, upper=1> theta;
            }
            model {
              theta ~ beta(1, 1);
              y ~ binomial(N, theta);
            }
            generated quantities {
              int y_rep = binomial_rng(N, theta);
              real log_lik = binomial_lpmf(y | N, theta);
            }
            """
        ),
    },
    {
        "id": "gaussian-inference",
        "title": "Inferences with Gaussians",
        "difficulty": "easy",
        "description": "Normal model with unknown mean and standard deviation.",
        "source_url": f"{FORESTDB_BASE}/gaussian-inference.html",
        "translation_note": "Direct continuous-parameter translation.",
        "data": {"N": 8, "y": [1.2, 0.7, 1.9, 1.4, 1.1, 0.8, 1.6, 1.3]},
        "stan": stan(
            """
            data {
              int<lower=1> N;
              vector[N] y;
            }
            parameters {
              real mu;
              real<lower=0> sigma;
            }
            model {
              mu ~ normal(0, 5);
              sigma ~ lognormal(0, 1);
              y ~ normal(mu, sigma);
            }
            generated quantities {
              real y_rep = normal_rng(mu, sigma);
            }
            """
        ),
    },
    {
        "id": "gaussian-gamma",
        "title": "1D Gaussian with Gaussian/Gamma Hyperparameters",
        "difficulty": "medium",
        "description": "Normal likelihood with normal-gamma prior structure.",
        "source_url": f"{FORESTDB_BASE}/gaussian-gamma.html",
        "translation_note": "Uses precision parameterization for the gamma prior.",
        "data": {
            "N": 10,
            "y": [-0.3, 0.1, 0.4, 0.2, -0.1, 0.6, 0.0, 0.3, 0.5, 0.2],
            "mu0": 0.0,
            "lambda0": 1.0,
            "alpha0": 2.0,
            "beta0": 2.0,
        },
        "stan": stan(
            """
            data {
              int<lower=1> N;
              vector[N] y;
              real mu0;
              real<lower=0> lambda0;
              real<lower=0> alpha0;
              real<lower=0> beta0;
            }
            parameters {
              real mu;
              real<lower=0> tau;
            }
            transformed parameters {
              real<lower=0> sigma = inv_sqrt(tau);
            }
            model {
              tau ~ gamma(alpha0, beta0);
              mu ~ normal(mu0, inv_sqrt(lambda0 * tau));
              y ~ normal(mu, sigma);
            }
            generated quantities {
              real y_rep = normal_rng(mu, sigma);
            }
            """
        ),
    },
    {
        "id": "linear-regression",
        "title": "Bayesian Linear Regression",
        "difficulty": "easy",
        "description": "Gaussian linear regression with weakly informative priors.",
        "source_url": f"{FORESTDB_BASE}/linear-regression.html",
        "translation_note": "Direct regression translation.",
        "data": {
            "N": 12,
            "K": 2,
            "X": [[1.0, -1.0], [1.0, -0.7], [1.0, -0.4], [1.0, -0.1], [1.0, 0.0], [1.0, 0.2], [1.0, 0.4], [1.0, 0.6], [1.0, 0.8], [1.0, 1.0], [1.0, 1.2], [1.0, 1.5]],
            "y": [0.3, 0.7, 0.8, 1.1, 1.2, 1.5, 1.7, 1.9, 2.2, 2.4, 2.5, 3.0],
        },
        "stan": stan(
            """
            data {
              int<lower=1> N;
              int<lower=1> K;
              matrix[N, K] X;
              vector[N] y;
            }
            parameters {
              vector[K] beta;
              real<lower=0> sigma;
            }
            model {
              beta ~ normal(0, 5);
              sigma ~ lognormal(0, 1);
              y ~ normal(X * beta, sigma);
            }
            generated quantities {
              vector[N] mu = X * beta;
            }
            """
        ),
    },
    {
        "id": "logistic-regression",
        "title": "Bayesian Logistic Regression",
        "difficulty": "easy",
        "description": "Bernoulli-logit regression for binary outcomes.",
        "source_url": f"{FORESTDB_BASE}/logistic-regression.html",
        "translation_note": "Direct regression translation.",
        "data": {
            "N": 14,
            "K": 2,
            "X": [[1.0, -2.0], [1.0, -1.5], [1.0, -1.2], [1.0, -0.8], [1.0, -0.5], [1.0, -0.2], [1.0, 0.1], [1.0, 0.3], [1.0, 0.6], [1.0, 0.9], [1.0, 1.2], [1.0, 1.5], [1.0, 1.8], [1.0, 2.0]],
            "y": [0, 0, 0, 0, 0, 1, 0, 1, 1, 1, 1, 1, 1, 1],
        },
        "stan": stan(
            """
            data {
              int<lower=1> N;
              int<lower=1> K;
              matrix[N, K] X;
              array[N] int<lower=0, upper=1> y;
            }
            parameters {
              vector[K] beta;
            }
            model {
              beta ~ normal(0, 3);
              y ~ bernoulli_logit(X * beta);
            }
            generated quantities {
              vector[N] p = inv_logit(X * beta);
            }
            """
        ),
    },
    {
        "id": "finite-mixture",
        "title": "Finite Mixture Model",
        "difficulty": "medium",
        "description": "Two-component Bernoulli mixture marginalized over labels.",
        "source_url": f"{FORESTDB_BASE}/finite-mixture.html",
        "translation_note": "Discrete component labels are marginalized with log_mix.",
        "data": {"N": 16, "y": [0, 0, 1, 0, 1, 1, 1, 0, 1, 1, 1, 1, 0, 1, 1, 1]},
        "stan": stan(
            """
            data {
              int<lower=1> N;
              array[N] int<lower=0, upper=1> y;
            }
            parameters {
              simplex[2] theta;
              ordered[2] logit_p;
            }
            transformed parameters {
              vector<lower=0, upper=1>[2] p = inv_logit(logit_p);
            }
            model {
              theta ~ dirichlet(rep_vector(1.0, 2));
              logit_p ~ normal(0, 2);
              for (n in 1 : N) {
                target += log_mix(theta[1],
                                  bernoulli_lpmf(y[n] | p[1]),
                                  bernoulli_lpmf(y[n] | p[2]));
              }
            }
            generated quantities {
              int z_rep = categorical_rng(theta);
              int y_rep = bernoulli_rng(p[z_rep]);
            }
            """
        ),
    },
    {
        "id": "finite-gaussian-mixture",
        "title": "Finite Gaussian Mixture",
        "difficulty": "medium",
        "description": "Two-component Gaussian mixture with ordered locations.",
        "source_url": f"{FORESTDB_BASE}/finite-gaussian-mixture.html",
        "translation_note": "Discrete component labels are marginalized with log_mix.",
        "data": {"N": 12, "y": [-2.2, -1.9, -2.4, -1.6, -2.1, 1.2, 1.5, 1.8, 2.0, 1.1, 1.7, 2.2]},
        "stan": stan(
            """
            data {
              int<lower=1> N;
              vector[N] y;
            }
            parameters {
              simplex[2] theta;
              ordered[2] mu;
              vector<lower=0>[2] sigma;
            }
            model {
              theta ~ dirichlet(rep_vector(1.0, 2));
              mu ~ normal(0, 5);
              sigma ~ lognormal(0, 0.5);
              for (n in 1 : N) {
                target += log_mix(theta[1],
                                  normal_lpdf(y[n] | mu[1], sigma[1]),
                                  normal_lpdf(y[n] | mu[2], sigma[2]));
              }
            }
            generated quantities {
              int z_rep = categorical_rng(theta);
              real y_rep = normal_rng(mu[z_rep], sigma[z_rep]);
            }
            """
        ),
    },
    {
        "id": "dirichlet-multinomial-mixture",
        "title": "Finite Dirichlet-Multinomial Mixture",
        "difficulty": "advanced",
        "description": "Mixture of count vectors with Dirichlet-multinomial components.",
        "source_url": f"{FORESTDB_BASE}/dm-mixture.html",
        "translation_note": "Discrete document clusters are marginalized with log_sum_exp.",
        "data": {
            "N": 8,
            "C": 3,
            "K": 2,
            "y": [[8, 1, 1], [7, 2, 1], [9, 1, 0], [6, 3, 1], [1, 7, 2], [2, 6, 2], [1, 8, 1], [2, 7, 1]],
        },
        "stan": stan(
            """
            functions {
              real dm_lpmf(array[] int y, vector alpha) {
                int total_count = 0;
                real lp = lgamma(sum(alpha));
                for (c in 1 : size(y)) {
                  total_count += y[c];
                  lp += lgamma(y[c] + alpha[c]) - lgamma(alpha[c]);
                }
                return lp - lgamma(sum(alpha) + total_count);
              }
            }
            data {
              int<lower=1> N;
              int<lower=2> C;
              int<lower=2> K;
              array[N, C] int<lower=0> y;
            }
            parameters {
              simplex[K] theta;
              array[K] simplex[C] phi;
              real<lower=0> concentration;
            }
            model {
              theta ~ dirichlet(rep_vector(1.0, K));
              concentration ~ lognormal(0, 0.5);
              for (k in 1 : K) {
                phi[k] ~ dirichlet(rep_vector(1.0, C));
              }
              for (n in 1 : N) {
                vector[K] lp;
                for (k in 1 : K) {
                  lp[k] = log(theta[k]) + dm_lpmf(y[n] | concentration * phi[k]);
                }
                target += log_sum_exp(lp);
              }
            }
            """
        ),
    },
    {
        "id": "markov-model",
        "title": "Markov Model",
        "difficulty": "medium",
        "description": "Categorical first-order Markov chain with learned transition matrix.",
        "source_url": f"{FORESTDB_BASE}/markov.html",
        "translation_note": "Direct finite-state Markov-chain translation.",
        "data": {"T": 14, "S": 3, "y": [1, 1, 2, 2, 3, 3, 2, 2, 1, 1, 2, 3, 3, 2]},
        "stan": stan(
            """
            data {
              int<lower=2> T;
              int<lower=2> S;
              array[T] int<lower=1, upper=S> y;
            }
            parameters {
              simplex[S] pi;
              array[S] simplex[S] A;
            }
            model {
              pi ~ dirichlet(rep_vector(1.0, S));
              for (s in 1 : S) {
                A[s] ~ dirichlet(rep_vector(1.0, S));
              }
              target += categorical_lpmf(y[1] | pi);
              for (t in 2 : T) {
                target += categorical_lpmf(y[t] | A[y[t - 1]]);
              }
            }
            """
        ),
    },
    {
        "id": "hidden-markov-model",
        "title": "Discrete-Time Hidden Markov Model",
        "difficulty": "advanced",
        "description": "Hidden Markov model with marginalized latent states.",
        "source_url": f"{FORESTDB_BASE}/hmm.html",
        "translation_note": "Hidden states are marginalized with the forward algorithm.",
        "data": {"T": 12, "S": 2, "K": 3, "y": [1, 1, 2, 2, 2, 3, 3, 2, 1, 1, 2, 3]},
        "stan": stan(
            """
            data {
              int<lower=2> T;
              int<lower=2> S;
              int<lower=2> K;
              array[T] int<lower=1, upper=K> y;
            }
            parameters {
              simplex[S] pi;
              array[S] simplex[S] A;
              array[S] simplex[K] omega;
            }
            model {
              matrix[T, S] log_alpha;
              pi ~ dirichlet(rep_vector(1.0, S));
              for (s in 1 : S) {
                A[s] ~ dirichlet(rep_vector(1.0, S));
                omega[s] ~ dirichlet(rep_vector(1.0, K));
              }
              for (s in 1 : S) {
                log_alpha[1, s] = log(pi[s]) + categorical_lpmf(y[1] | omega[s]);
              }
              for (t in 2 : T) {
                for (s in 1 : S) {
                  vector[S] acc;
                  for (prev in 1 : S) {
                    acc[prev] = log_alpha[t - 1, prev] + log(A[prev][s]);
                  }
                  log_alpha[t, s] = categorical_lpmf(y[t] | omega[s]) + log_sum_exp(acc);
                }
              }
              {
                vector[S] last;
                for (s in 1 : S) {
                  last[s] = log_alpha[T, s];
                }
                target += log_sum_exp(last);
              }
            }
            """
        ),
    },
    {
        "id": "rat-growth",
        "title": "Rat Growth",
        "difficulty": "advanced",
        "description": "Hierarchical linear growth curves for repeated rat weights.",
        "source_url": f"{FORESTDB_BASE}/rat-growth.html",
        "translation_note": "Continuous hierarchical regression translation.",
        "data": {
            "N": 5,
            "T": 5,
            "time": [0.0, 1.0, 2.0, 3.0, 4.0],
            "y": [[50, 58, 65, 72, 81], [48, 55, 61, 69, 76], [52, 61, 68, 75, 83], [47, 53, 59, 66, 72], [51, 59, 67, 73, 80]],
        },
        "stan": stan(
            """
            data {
              int<lower=1> N;
              int<lower=1> T;
              vector[T] time;
              matrix[N, T] y;
            }
            parameters {
              real mu_alpha;
              real mu_beta;
              real<lower=0> sigma_alpha;
              real<lower=0> sigma_beta;
              real<lower=0> sigma_y;
              vector[N] alpha_raw;
              vector[N] beta_raw;
            }
            transformed parameters {
              vector[N] alpha = mu_alpha + sigma_alpha * alpha_raw;
              vector[N] beta = mu_beta + sigma_beta * beta_raw;
            }
            model {
              mu_alpha ~ normal(50, 20);
              mu_beta ~ normal(7, 5);
              sigma_alpha ~ normal(0, 10);
              sigma_beta ~ normal(0, 5);
              sigma_y ~ normal(0, 5);
              alpha_raw ~ normal(0, 1);
              beta_raw ~ normal(0, 1);
              for (n in 1 : N) {
                for (t in 1 : T) {
                  y[n, t] ~ normal(alpha[n] + beta[n] * time[t], sigma_y);
                }
              }
            }
            """
        ),
    },
    {
        "id": "geometric-distribution",
        "title": "Geometric Distribution",
        "difficulty": "easy",
        "description": "Geometric likelihood for trials until first success.",
        "source_url": f"{FORESTDB_BASE}/geometric.html",
        "translation_note": "Stan's geometric distribution counts failures, so data are shifted by one.",
        "data": {"N": 10, "y": [1, 2, 1, 4, 3, 1, 2, 5, 2, 1]},
        "stan": stan(
            """
            data {
              int<lower=1> N;
              array[N] int<lower=1> y;
            }
            transformed data {
              array[N] int<lower=0> y_failures;
              for (n in 1 : N) {
                y_failures[n] = y[n] - 1;
              }
            }
            parameters {
              real<lower=0, upper=1> theta;
            }
            model {
              theta ~ beta(1, 1);
              y_failures ~ neg_binomial_2((1 - theta) / theta, 1);
            }
            generated quantities {
              int y_rep = 1 + neg_binomial_2_rng((1 - theta) / theta, 1);
            }
            """
        ),
    },
    {
        "id": "medical-diagnosis",
        "title": "Medical Diagnosis",
        "difficulty": "medium",
        "description": "Bayes-net-style diagnostic model with latent disease marginalized.",
        "source_url": f"{FORESTDB_BASE}/medical-bayesnet.html",
        "translation_note": "The binary disease state is marginalized analytically.",
        "data": {"T": 3, "test_pos": [1, 1, 0]},
        "stan": stan(
            """
            data {
              int<lower=1> T;
              array[T] int<lower=0, upper=1> test_pos;
            }
            parameters {
              real<lower=0, upper=1> prevalence;
              vector<lower=0, upper=1>[T] sensitivity;
              vector<lower=0, upper=1>[T] specificity;
            }
            model {
              prevalence ~ beta(2, 8);
              sensitivity ~ beta(8, 2);
              specificity ~ beta(9, 1.5);
              {
                real lp_disease = log(prevalence);
                real lp_no_disease = log1m(prevalence);
                for (t in 1 : T) {
                  lp_disease += bernoulli_lpmf(test_pos[t] | sensitivity[t]);
                  lp_no_disease += bernoulli_lpmf(test_pos[t] | 1 - specificity[t]);
                }
                target += log_sum_exp(lp_disease, lp_no_disease);
              }
            }
            generated quantities {
              real posterior_disease_prob;
              {
                real lp_disease = log(prevalence);
                real lp_no_disease = log1m(prevalence);
                for (t in 1 : T) {
                  lp_disease += bernoulli_lpmf(test_pos[t] | sensitivity[t]);
                  lp_no_disease += bernoulli_lpmf(test_pos[t] | 1 - specificity[t]);
                }
                posterior_disease_prob = exp(lp_disease - log_sum_exp(lp_disease, lp_no_disease));
              }
            }
            """
        ),
    },
    {
        "id": "burglary-bayesnet",
        "title": "Burglary Bayesnet",
        "difficulty": "advanced",
        "description": "Classic burglary/earthquake/alarm network with calls observed.",
        "source_url": f"{FORESTDB_BASE}/burglary.html",
        "translation_note": "Binary burglary, earthquake, and alarm nodes are marginalized.",
        "data": {
            "calls": [1, 1],
            "p_alarm": [[0.001, 0.29], [0.94, 0.95]],
            "p_john_alarm": 0.90,
            "p_john_no_alarm": 0.05,
            "p_mary_alarm": 0.70,
            "p_mary_no_alarm": 0.01,
        },
        "stan": stan(
            """
            data {
              array[2] int<lower=0, upper=1> calls;
              array[2, 2] real<lower=0, upper=1> p_alarm;
              real<lower=0, upper=1> p_john_alarm;
              real<lower=0, upper=1> p_john_no_alarm;
              real<lower=0, upper=1> p_mary_alarm;
              real<lower=0, upper=1> p_mary_no_alarm;
            }
            parameters {
              real<lower=0, upper=1> p_burglary;
              real<lower=0, upper=1> p_earthquake;
            }
            model {
              p_burglary ~ beta(1, 20);
              p_earthquake ~ beta(1, 50);
              {
                vector[4] lp;
                int idx = 1;
                for (b in 0 : 1) {
                  for (e in 0 : 1) {
                    real pa = p_alarm[b + 1, e + 1];
                    real lp_calls_if_alarm = bernoulli_lpmf(calls[1] | p_john_alarm)
                                             + bernoulli_lpmf(calls[2] | p_mary_alarm);
                    real lp_calls_if_no_alarm = bernoulli_lpmf(calls[1] | p_john_no_alarm)
                                                + bernoulli_lpmf(calls[2] | p_mary_no_alarm);
                    real lp_alarm = log_sum_exp(bernoulli_lpmf(1 | pa) + lp_calls_if_alarm,
                                                bernoulli_lpmf(0 | pa) + lp_calls_if_no_alarm);
                    lp[idx] = bernoulli_lpmf(b | p_burglary)
                              + bernoulli_lpmf(e | p_earthquake)
                              + lp_alarm;
                    idx += 1;
                  }
                }
                target += log_sum_exp(lp);
              }
            }
            generated quantities {
              real posterior_burglary_prob;
              {
                vector[4] lp;
                int idx = 1;
                for (b in 0 : 1) {
                  for (e in 0 : 1) {
                    real pa = p_alarm[b + 1, e + 1];
                    real lp_calls_if_alarm = bernoulli_lpmf(calls[1] | p_john_alarm)
                                             + bernoulli_lpmf(calls[2] | p_mary_alarm);
                    real lp_calls_if_no_alarm = bernoulli_lpmf(calls[1] | p_john_no_alarm)
                                                + bernoulli_lpmf(calls[2] | p_mary_no_alarm);
                    real lp_alarm = log_sum_exp(bernoulli_lpmf(1 | pa) + lp_calls_if_alarm,
                                                bernoulli_lpmf(0 | pa) + lp_calls_if_no_alarm);
                    lp[idx] = bernoulli_lpmf(b | p_burglary)
                              + bernoulli_lpmf(e | p_earthquake)
                              + lp_alarm;
                    idx += 1;
                  }
                }
                posterior_burglary_prob = exp(log_sum_exp(lp[3], lp[4]) - log_sum_exp(lp));
              }
            }
            """
        ),
    },
    {
        "id": "model-selection",
        "title": "Model Selection",
        "difficulty": "advanced",
        "description": "Mixture over linear and quadratic regression models.",
        "source_url": f"{FORESTDB_BASE}/model-selection.html",
        "translation_note": "The discrete model indicator is marginalized over the whole data set.",
        "data": {
            "N": 10,
            "x": [-1.5, -1.1, -0.8, -0.4, 0.0, 0.3, 0.7, 1.0, 1.3, 1.6],
            "y": [2.7, 1.7, 1.3, 0.8, 0.6, 0.7, 1.1, 1.6, 2.3, 3.1],
        },
        "stan": stan(
            """
            data {
              int<lower=1> N;
              vector[N] x;
              vector[N] y;
            }
            parameters {
              real alpha_linear;
              real beta_linear;
              real<lower=0> sigma_linear;
              real alpha_quad;
              real beta_quad;
              real gamma_quad;
              real<lower=0> sigma_quad;
              real<lower=0, upper=1> p_linear;
            }
            model {
              alpha_linear ~ normal(0, 5);
              beta_linear ~ normal(0, 5);
              sigma_linear ~ lognormal(0, 1);
              alpha_quad ~ normal(0, 5);
              beta_quad ~ normal(0, 5);
              gamma_quad ~ normal(0, 5);
              sigma_quad ~ lognormal(0, 1);
              p_linear ~ beta(1, 1);
              {
                real lp_linear = log(p_linear);
                real lp_quad = log1m(p_linear);
                for (n in 1 : N) {
                  lp_linear += normal_lpdf(y[n] | alpha_linear + beta_linear * x[n], sigma_linear);
                  lp_quad += normal_lpdf(y[n] | alpha_quad + beta_quad * x[n]
                                                + gamma_quad * square(x[n]), sigma_quad);
                }
                target += log_sum_exp(lp_linear, lp_quad);
              }
            }
            generated quantities {
              real posterior_linear_prob;
              {
                real lp_linear = log(p_linear);
                real lp_quad = log1m(p_linear);
                for (n in 1 : N) {
                  lp_linear += normal_lpdf(y[n] | alpha_linear + beta_linear * x[n], sigma_linear);
                  lp_quad += normal_lpdf(y[n] | alpha_quad + beta_quad * x[n]
                                                + gamma_quad * square(x[n]), sigma_quad);
                }
                posterior_linear_prob = exp(lp_linear - log_sum_exp(lp_linear, lp_quad));
              }
            }
            """
        ),
    },
]


RUN_PY = """#!/usr/bin/env python3
from pathlib import Path
import sys

ROOT = Path(__file__).resolve().parents[3]
sys.path.insert(0, str(ROOT))

from scripts.run_cmdstan_model import main

if __name__ == "__main__":
    raise SystemExit(main(["--model-dir", str(Path(__file__).resolve().parent), *sys.argv[1:]]))
"""


def write_json(path: Path, value: Any) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    with path.open("w", encoding="utf-8") as handle:
        json.dump(value, handle, indent=2)
        handle.write("\n")


def write_text(path: Path, value: str) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text(value, encoding="utf-8")


def copy_example_model(model: dict[str, Any], group_dir: str, group_label: str, examples_root: Path) -> dict[str, Any]:
    source_path = model["source_path"]
    source_stan = examples_root / f"{source_path}.stan"
    if not source_stan.exists():
        raise FileNotFoundError(source_stan)

    target_dir = ROOT / "models" / group_dir / model["id"]
    target_dir.mkdir(parents=True, exist_ok=True)
    shutil.copy2(source_stan, target_dir / "model.stan")

    if "data" in model:
        data = model["data"]
    else:
        data_path = examples_root / model.get("data_path", f"{source_path}.data.json")
        with data_path.open("r", encoding="utf-8") as handle:
            data = json.load(handle)
        if "data_keys" in model:
            data = {key: data[key] for key in model["data_keys"]}
    write_json(target_dir / "data.json", data)

    source_url = f"{EXAMPLE_MODELS_BASE}/{source_path}.stan"
    data_source = model.get("data_path", f"{source_path}.data.json" if "data" not in model else None)
    metadata = {
        "id": model["id"],
        "title": model["title"],
        "source_group": group_dir,
        "source_group_label": group_label,
        "difficulty": model["difficulty"],
        "description": model["description"],
        "source_url": source_url,
        "source_path": source_path,
        "data_source": data_source,
        "stan_file": "model.stan",
        "data_file": "data.json",
        "method": "sample",
        "default_run": DEFAULT_RUN,
    }
    write_json(target_dir / "metadata.json", metadata)
    write_text(
        target_dir / "source.md",
        "\n".join(
            [
                f"# {model['title']}",
                "",
                f"- Upstream Stan file: [{source_path}.stan]({source_url})",
                f"- Upstream data: {data_source or 'inline/transformed data'}",
                f"- Source group: {group_label}",
                "- License note: copied from stan-dev/example-models; see the upstream directory for any model-specific terms.",
                "",
            ]
        ),
    )
    write_run_py(target_dir)
    return manifest_entry(metadata, target_dir)


def write_forest_model(model: dict[str, Any]) -> dict[str, Any]:
    target_dir = ROOT / "models" / "forestdb" / model["id"]
    target_dir.mkdir(parents=True, exist_ok=True)
    write_text(target_dir / "model.stan", model["stan"])
    write_json(target_dir / "data.json", model["data"])
    metadata = {
        "id": model["id"],
        "title": model["title"],
        "source_group": "forestdb",
        "source_group_label": "ForestDB translations",
        "difficulty": model["difficulty"],
        "description": model["description"],
        "source_url": model["source_url"],
        "translation_note": model["translation_note"],
        "stan_file": "model.stan",
        "data_file": "data.json",
        "method": "sample",
        "default_run": DEFAULT_RUN,
    }
    write_json(target_dir / "metadata.json", metadata)
    write_text(
        target_dir / "source.md",
        "\n".join(
            [
                f"# {model['title']}",
                "",
                f"- ForestDB source: [{model['title']}]({model['source_url']})",
                f"- Translation note: {model['translation_note']}",
                "- License note: this Stan translation was written for this regression suite from the linked ForestDB model description.",
                "",
            ]
        ),
    )
    write_run_py(target_dir)
    return manifest_entry(metadata, target_dir)


def write_run_py(target_dir: Path) -> None:
    run_py = target_dir / "run.py"
    write_text(run_py, RUN_PY)
    run_py.chmod(run_py.stat().st_mode | stat.S_IXUSR | stat.S_IXGRP | stat.S_IXOTH)


def manifest_entry(metadata: dict[str, Any], target_dir: Path) -> dict[str, Any]:
    entry = dict(metadata)
    entry["path"] = str(target_dir.relative_to(ROOT))
    return entry


def escape_cell(value: str) -> str:
    return value.replace("|", "\\|").replace("\n", " ")


def write_model_list(models: list[dict[str, Any]]) -> None:
    lines = [
        "# Model List",
        "",
        "The `Same result?` column is intentionally empty for recording SafeStan regression outcomes.",
        "",
        "| Source | Difficulty | Model | Description | Upstream source | Same result? |",
        "|---|---|---|---|---|---|",
    ]
    for model in models:
        model_link = f"[{escape_cell(model['title'])}]({model['path']}/)"
        source_link = f"[source]({model['source_url']})"
        lines.append(
            "| "
            + " | ".join(
                [
                    escape_cell(model["source_group_label"]),
                    escape_cell(model["difficulty"]),
                    model_link,
                    escape_cell(model["description"]),
                    source_link,
                    "",
                ]
            )
            + " |"
        )
    write_text(ROOT / "MODEL_LIST.md", "\n".join(lines) + "\n")


def write_readme() -> None:
    write_text(
        ROOT / "README.md",
        textwrap.dedent(
            """
            # Stan/SafeStan Regression Model Collection

            This repository contains a small, uniform corpus of Stan models for comparing original Stan programs with SafeStan translations through a CmdStan-compatible runner such as `cmdsafestan`.

            ## Layout

            Each model directory contains:

            - `model.stan`: the Stan model to compile.
            - `data.json`: the default data set for the model.
            - `metadata.json`: source, difficulty, and default run settings.
            - `source.md`: upstream link and translation notes.
            - `run.py`: thin wrapper around `scripts/run_cmdstan_model.py`.

            Model groups live under `models/stan_tutorials`, `models/stan_case_studies`, and `models/forestdb`.

            ## Running One Model

            ```sh
            python3 models/forestdb/binomial-inference/run.py --cmdstan /path/to/cmdsafestan
            ```

            You can also set `CMDSAFESTAN` or `CMDSTAN`:

            ```sh
            CMDSAFESTAN=/path/to/cmdsafestan python3 models/forestdb/binomial-inference/run.py
            ```

            By default each model uses 4 chains, 250 warmup iterations, and 250 sampling iterations. Override these with `--chains`, `--iter-warmup`, and `--iter-sampling`.

            ## Running a Suite

            ```sh
            python3 scripts/run_suite.py --cmdstan /path/to/cmdsafestan --source forestdb
            python3 scripts/run_suite.py --cmdstan /path/to/cmdsafestan --difficulty advanced --limit 5
            ```

            Use `--dry-run` to inspect compile and run commands without executing them.

            ## Comparing Runs

            After running a Stan baseline and a SafeStan candidate into separate output roots:

            ```sh
            python3 scripts/compare_outputs.py runs/baseline runs/safestan --json-output runs/comparison.json
            ```

            The comparison script summarizes common CmdStan CSV columns and checks mean and standard-deviation differences with configurable `--atol` and `--rtol`.

            ## SafeStan Translation Workflow

            A simple workflow is to keep the original `model.stan`, add a translated SafeStan file such as `model_safe.stan` in the same directory, and run:

            ```sh
            python3 models/forestdb/binomial-inference/run.py --cmdstan /path/to/cmdsafestan --stan-file model_safe.stan --output-dir runs/safestan/forestdb/binomial-inference
            ```

            If your SafeStan compiler expects a different extension, pass that filename with `--stan-file`; the runner compiles the executable target by stripping the file suffix.
            """
        ).strip()
        + "\n",
    )


def write_gitignore() -> None:
    write_text(
        ROOT / ".gitignore",
        textwrap.dedent(
            """
            __pycache__/
            *.pyc
            runs/
            models/*/*/runs/
            models/*/*/model
            models/*/*/*.d
            models/*/*/*.hpp
            models/*/*/*.o
            models/*/*/*.csv
            """
        ).lstrip(),
    )


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument(
        "--examples-root",
        default=os.environ.get("STAN_EXAMPLE_MODELS", "/tmp/stan-example-models"),
        help="Path to a stan-dev/example-models clone.",
    )
    parser.add_argument("--force", action="store_true", help="Replace existing generated models directory.")
    return parser.parse_args()


def main() -> int:
    args = parse_args()
    examples_root = Path(args.examples_root).expanduser().resolve()
    if not examples_root.exists():
        raise SystemExit(f"example-models clone not found: {examples_root}")
    models_root = ROOT / "models"
    if models_root.exists():
        if not args.force:
            raise SystemExit("models/ already exists; pass --force to replace it.")
        shutil.rmtree(models_root)

    manifest_models: list[dict[str, Any]] = []
    for model in STAN_TUTORIALS:
        manifest_models.append(copy_example_model(model, "stan_tutorials", "Stan tutorials", examples_root))
    for model in STAN_CASE_STUDIES:
        manifest_models.append(copy_example_model(model, "stan_case_studies", "Stan case studies", examples_root))
    for model in FOREST_MODELS:
        manifest_models.append(write_forest_model(model))

    write_json(
        ROOT / "model_manifest.json",
        {
            "stan_example_models_commit": EXAMPLE_MODELS_COMMIT,
            "default_run": DEFAULT_RUN,
            "models": manifest_models,
        },
    )
    write_model_list(manifest_models)
    write_readme()
    write_gitignore()
    print(f"Wrote {len(manifest_models)} models.")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
