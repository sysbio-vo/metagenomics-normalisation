# get the table with taxonomy for all species present in the otutable

library("taxize")

ftable <- read.table("data/otutable.csv",
                     sep = ",", header = TRUE, row.names = 1)
df <- cbind(classification(rownames(ftable), db = 'ncbi'))
rownames(df) <- df$query
colSums(is.na(df))
unique(df$class)
write.csv(df, "data/metaspecies.csv")
