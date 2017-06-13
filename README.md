# StanSensitivity

This repo contains a (very early) draft of some tools that allow users
to automatically generate local sensitivity measures to hyperparameters in
[Stan](http://mc-stan.org/), specifically in [RStan](http://mc-stan.org/interfaces/rstan.html).

A Stan model's data block typically consists of both data and hyperparameters.
Local sensitivity of a posterior mean to the hyperparameters can be
computed as the posterior covariance of a log derivative with with parameter[1].
These tools allow you to
easily specify which hyperparameters you're intersted in and automatically
calculate the necessary local sensitivity.

Here are the current steps to use it.  Some examples can be found in
```example_models```, which are based on their namesakes in the
[Stan examples](https://github.com/stan-dev/example-models).  An R script
using these examples can be found in ```examples/run_examples.R```.

1. Install the R pacakge using the command
```
library(devtools)
install_github("rgiordan/StanSensitivity", subdir="rstansensitivity")
```
1. Start with an existing Stan model and dataset containing hyperparameters (e.g. ```example_models/negative_binomial/negative_binomial_original.stan``` and
```example_models/negative_binomial.data.R```).
1. Split your ```data``` block into a data block containing parameters that
you want to keep fixed and a new ```hyperparameters``` block containing the
parameters whose sensitivity you want to evaluate.  For example, the original
data block in ```negative_binomial_original.stan``` was:
```
data {
    int<lower=1> N;
    int<lower=0> y[N];
    real weights[N];
    real cauchy_loc_alpha;
    real cauchy_loc_beta;
    real cauchy_scale_alpha;
    real cauchy_scale_beta;
}
```
and in ```negative_binomial.stan``` this is split into
```
data {
    int<lower=1> N;
    int<lower=0> y[N];
}
hyperparameters {
    real weights[N];
    real cauchy_loc_alpha;
    real cauchy_loc_beta;
    real cauchy_scale_alpha;
    real cauchy_scale_beta;
}
```
**Note: hyperparameters must be real-valued and unconstrained.**  There are
currently no checks for this -- the sensitivity analysis will simply crash
or not make sense!  (If there are constraints, it will silently report
sensitivity to the unconstrained value, not the constrained value.)
**Also note: The parser is currently rough and naive.**  Some ordinary stan features
(like comments outside of program blocks) may not be supported.
1. Run ```generate_models.py``` pointing to the script with the
```hyperparameters``` block defined:
```
python/generate_models.py --base_model=example_models/negative_binomial/negative_binomial.stan
```
This will produce three new models with the suffixes ```_generated.stan```,
```_sensitivity.stan```, and ```_sensitivity_parameters.stan```.
The first should be the same as your original
model, and the latter two will give you the necessary derivatives for sensitivity
analysis.
1. Run an R script similar to ```R/run_examples.R```, setting the ```model_name``` variable
to the full path of your original model without the ```.stan``` suffix, e.g.
```
model_name <- file.path(example_directory, "negative_binomial/negative_binomial")
```
1. Hopefully, if everything works, you will have your local sensitivity measures
in the matrix ```sens_mat```, which you can graph or interpret as you see fit.

This is currently just a sketch, so no guarantees that
it's working yet.  Please contact me with questions or comments.

[1]: [Fast Measurements of Robustness to Changing Priors in Variational Bayes](https://arxiv.org/abs/1611.07469)
