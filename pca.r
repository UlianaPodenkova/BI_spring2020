install.packages('factoextra')
install.packages("dummies")
install.packages("FactoMineR")
#import files
meta <- as.data.frame(read.table(file="/path_to_file/id81source", sep="\t",stringsAsFactors = F,header = T))
rownames(meta) <- meta$id
meta$id <- NULL
df <- as.data.frame(read.table(file="/path_to_file/variable1", sep ="\t", stringsAsFactors = F, header = T))
rownames(df) <- df$Locus
df$Locus <- NULL
df_2 <- as.data.frame(t(df))
df_2$id <- rownames(df_2)

df_2 <- merge(meta, df_2, by="id", all.y = T)
head(colnames(df_2))
groups <- df_2$source

df_3 <- df_2[,3:500]
colnames(df_2)
#### PCA
library(dummies)
df=as.matrix(dummy.data.frame(data = df_3))
### pca
library(FactoMineR)
library(factoextra)
res.famd <- FAMD(df_2, graph = FALSE)
fviz_screeplot(res.famd)
fviz_contrib(res.famd, "var", axes = 2)
quali.var <- get_famd_var(res.famd, "quali.var")
quali.var

res.pca <- prcomp(df)
fviz_eig(res.pca)
dimdesc(PCA(df)) ## Correlation of variables with measurements (more - better)
## groups by which we will paint clusters
#fviz_pca_var(res.pca)
#fviz_pca_biplot(res.pca)
fviz_pca_ind(res.pca, habillage = df_2$SPNE00321, labels=F)