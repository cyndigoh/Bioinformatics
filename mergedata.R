files <- list.files(path="/Volumes/cyndi/pool2flustrep", pattern="*.tsv")
#fullfiles <- paste("/Volumes/cyndi/pool2flustrep", files, sep='/')
fullfiles <- file.path("/Volumes/cyndi/pool2flustrep", files)

res_ls <- lapply(fullfiles, function(x){
  df <- read.delim(file=x, header=T, row.names=1, stringsAsFactors=F)
  samples <- gsub(".*WTCHG",'WTCHG', x, perl=T)
  samples <- gsub(".tsv",'', samples, perl=T)
  data.frame(reference=rownames(df), mappedreads=df$mappedreads, samples=rep(samples,nrow(df)), stringsAsFactors=F)
})
res_df <- do.call(rbind, res_ls)

#########################################
rnames <- sort(unique(res_df$reference))
cnames <- sort(unique(res_df$samples))
r_ind <- match(res_df$reference, rnames)
c_ind <- match(res_df$samples, cnames)
res_mat <- matrix(0, nrow=length(rnames), ncol=length(cnames))
for(i in 1:length(r_ind)){
  res_mat[r_ind[i],c_ind[i]] <- res_df[i,2]
}
colnames(res_mat) <- cnames
rownames(res_mat) <- rnames
########################################


library(XGR)
res_mat <- as.matrix(xSparseMatrix(input.file=res_df[,c(1,3,2)]))
