# *******************************
# Bureux de vote -> Délégations *
# *******************************

# [1] Chargement du fichier de données

load("data/geometriesTN.RData")

# [2] Import de données correctement formatées

BV.df<-read.csv( "data/BV_v3.csv",header=TRUE,sep=",",dec=".",encoding="utf-8")
head(BV.df)

# [3] Calcul des variables en %

head(BV.df)


# [4] Aggregation des données par delegation
colnames(BV.df)
colnames(BV.df)

BV2 <- BV.df[,c("Code_BV","del_id")]
BV2$CV_participation <- round((BV.df$Votants/BV.df$Inscrits)*100,2)
BV2$CV_exprimes <- round((BV.df$V_exprm/BV.df$Votants)*100,2)
BV2$CV_nuls <- round((BV.df$V_nuls/BV.df$Votants)*100,2)
BV2$CV_blancs <- round((BV.df$V_blancs/BV.df$Votants)*100,2)
colnames(BV2)
 

for (i in 20:46){
  j <- length(BV2)+1
  BV2[,j] <- round(BV.df[,i]/BV.df$V_exprm*100,2)
  colnames(BV2)[j] <- paste("CV_",colnames(BV.df)[i],sep="")
}
head(BV2)

# Aggrégation
cv <- function(x){sd(x)/mean(x)}
CvByDeleg.df <- aggregate(BV2[,c(3:33)], by = list(BV2$del_id), FUN=cv)
head(CvByDeleg.df)
colnames(CvByDeleg.df)[1] <- "id"
# Export
write.csv(CvByDeleg.df,"data/CvByDeleg.csv",row.names = F)

