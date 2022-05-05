outliers_pval<-function(neutraldata, genicdata, desiredcolumn, method){
  ## made by Alicia Mastretta-Yanes, May 2022
  ## This function estimates the P-value of each genic position 
  ## from the results of Bayescan or SweeD programs,
  ## by calculating the empirical percentile according to the distribution of 
  ## likelihood values for the neutral regions, and P-value correction for multiple testing.
  ## The output is a dataframe with the original genetic data (see arguments below)
  ## with two more columns with the pvalue and the adjusted pvalue.
  
  ### Arguments
  ## neutraldata: data frame with the output results of BayeScan, SweeD 
  ##                or similar program ran with NEUTRAL data.  
  ##                Will be used to generate the empirical distribution.
  ## genicdata: data frame with the output results of BayeScan, SweeD 
  ##                  or similar program ran with GENIC data.
  ##                  pvalues of this data will be estimated.
  ## desiredcolumn: column with the data for which pvalues will be estimated.
  ##                  eg Likelihood, alpha, etc.
  ##                  Must be provided as a number. E.g. is Likelikood is the 
  ##                  3rd column, this argument shouldbe desiredcolumn = 3
  ## method: correction method to run the p.adjust() function. 
  ##           See its documentation for details.  
  
  
  ### Function 
  # Estimate the empirical cummulative distribution function of the neutral data
  Likelihood_Function <- ecdf(neutraldata[, desiredcolumn])
  
  ## run the resulting function with the genetic data
  x<-Likelihood_Function(genicdata[, desiredcolumn])
  
  # The difference is the p-value
  Likelihood_PVAL<-1-x
  
  ## Adjust pvalue with the desired method
  Likelihood_FDR=p.adjust(Likelihood_PVAL, method)
  
  # copy original genetic data
  results<- genicdata
  
  # add pvalue results:
  results$pval<-Likelihood_PVAL
  results$pval.adjust<-Likelihood_FDR
  
  # return results
  return(results)
}