# *******************************
# Bureux de vote -> Délégations *
# *******************************

# [1] Chargement du fichier de données

load("data/geometriesTN.RData")

# [2] Import de données correctement formatées

BV.df<-read.csv( "data/BV_v3.csv",header=TRUE,sep=",",dec=".",encoding="utf-8")
head(BV.df)

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


# Pour l'exercice, on ne selectionne que les BV sans erreurs

# choix des variables à sommer

stocks <- colnames(BV.df)[17:length(BV.df)-2]

# Aggrégation

VoteByDeleg.df <- aggregate(BV.df[,stocks], by = list(BV.df$del_id, BV.df$del_fr), FUN=sum)
names(VoteByDeleg.df) <- c("id","name",stocks)

head(VoteByDeleg.df)

# Export
write.csv(VoteByDeleg.df,"data/VoteByDeleg.csv",row.names = F)

