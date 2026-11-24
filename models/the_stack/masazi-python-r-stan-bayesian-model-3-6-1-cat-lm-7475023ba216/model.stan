data {
    int N;
    vector[N] sales;
    array[N] int weather_rainy;
    array[N] int weather_sunny;

    int N_pred;
    array[N_pred] int weather_rainy_pred;
    array[N_pred] int weather_sunny_pred;
}

parameters {
    real Intercept;
    real beta_weather_rainy;
    real beta_weather_sunny;
    real<lower=0> sigma;
}

model {
    for (i in 1:N) {
        real mu = Intercept + beta_weather_rainy*weather_rainy[i] + beta_weather_sunny*weather_sunny[i];
        sales[i] ~ normal(mu, sigma);
    }
}

generated quantities {
    vector[N_pred] mu_pred;
    vector[N_pred] sales_pred;

    for (i in 1:N_pred) {
        mu_pred[i] = Intercept + beta_weather_rainy*weather_rainy_pred[i] + beta_weather_sunny*weather_sunny_pred[i];
        sales_pred[i] = normal_rng(mu_pred[i], sigma);
    }
}