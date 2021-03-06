library(metatest)
library(plyr)

args <- commandArgs(trailingOnly = TRUE)
file_in <- args[1]

file_in <- '/home/cheng/Dissertation/MetaDiff/fpkm.mat'
data_mat <- read.table(file_in, header=T, sep = '\t')[1:640,]

run_metatest<-function(mat){
  meta_obj <- metatest(formula = y~factor(C_1)+R1, variance = variance, data=mat)
  res_vec <- c(meta_obj$convergence, meta_obj$coefficients, meta_obj$se, meta_obj$tval, meta_obj$dfttest, meta_obj$pttest, meta_obj$LLR, meta_obj$pLLR, meta_obj$bartLLR, meta_obj$bartscale, meta_obj$pBartlett, meta_obj$ppermtest)
  cov_name <- dimnames(meta_obj$coefficients)[[1]]
  names_vec <- c('Convergence', paste('coef_',cov_name,sep=''), paste('se_',cov_name,sep=''), paste('tval_',cov_name,sep=''), 'dfttest', paste('pttest_',cov_name,sep=''),paste('LLR_',cov_name,sep=''), paste('pLLR_',cov_name,sep=''), paste('bartLLR_',cov_name,sep=''), paste('bartscale',cov_name,sep=''), paste('pBartlett_',cov_name,sep=''), paste('ppermtest_',cov_name,sep=''))
  names(res_vec)<-names_vec
  return(res_vec)
}

df_res <- ddply(data_mat, .(Isoform), .fun = run_metatest)

write.table(df_res, file = "", row.names = F, quote=F, sep='\t')
