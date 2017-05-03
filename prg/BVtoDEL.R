# *******************************
# Bureux de vote -> Délégations *
# *******************************

# [1] Chargement du fichier de données

load("data/geometriesTN.RData")

# [2] Import de données correctement formatées

BV.df<-read.csv( "data/Tableau Final_Avrl2017.csv",header=TRUE,sep=",",dec=".",encoding="utf-8")

# [3] Quelques resumés statistiques


var <- BV.df$Total_T1
hist(var, probability = TRUE, nclass = 30, col="lightgreen")
rug(var)
moy <- mean(var)
med <- median(var)
abline(v = moy, col = "red", lwd = 3)
abline(v = med, col = "blue", lwd = 3)

# [4] Aggregation des données par delegation
colnames(BV.df)
# choix des variables à sommer
stocks <- colnames(BV.df)[15:length(BV.df)]
stocks
head(BV.df)

# Aggrégation
VoteByDeleg.df <- aggregate(BV.df[,stocks], by = list(BV.df$del_id, BV.df$del_fr), FUN=sum)
names(VoteByDeleg.df) <- c("id","name",stocks)


# Export
write.csv(VoteByDeleg.df,"data/VoteByDeleg.csv",row.names = F)
