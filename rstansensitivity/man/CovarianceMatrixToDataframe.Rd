% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/result_processing_lib.R
\name{CovarianceMatrixToDataframe}
\alias{CovarianceMatrixToDataframe}
\title{Convert a covariance matrix to a dataframe.}
\usage{
CovarianceMatrixToDataframe(cov_mat, remove_repeats = FALSE)
}
\arguments{
\item{cov_mat}{The covariance matrix.}

\item{remove_repeats}{Optional.  If TRUE, and if cov_mat
is symmetric, include only the upper triangular part of cov_mat.
Default value = FALSE.}
}
\value{
A data frame with columns row_variable, column_variable, and
value, where value is the specificed covariance.
}
\description{
Convert a covariance matrix to a dataframe.
}
