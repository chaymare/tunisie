library("cartography")

# [1] Chargement du fichier de données

load("data/geometriesTN.RData")

# [2] Import de données correctement formatées

BV.df<-read.csv( "data/BV_version1.csv",header=TRUE,sep=",",dec=".",encoding="utf-8")

# [3] Construire une table de passage entre le tableau de données et le fond de carte

tbl_BV.df <- unique(BV.df[,c("Code_Del","Délégation")])
tbl_basemaps.df <- delegations.spdf@data[]

write.csv(tbl_BV.df,file = "tbl_BV.csv")
write.csv(tbl_basemaps.df,file = "tbl_basemaps.csv")




head(tbl_basemaps.df)
tblDePassage.df <- data.frame(tbl_basemaps.df, tbl_BV.df[match(tbl_basemaps.df[,"del_fr"], tbl_BV.df[,"Délégation"]),])
head(tblDePassage.df)

# [4] Quelques resumés statistiques

summary(BV.df)

var <- BV.df$Total_T1
hist(var, probability = TRUE, nclass = 30, col="lightgreen")
rug(var)
moy <- mean(var)
med <- median(var)
abline(v = moy, col = "red", lwd = 3)
abline(v = med, col = "blue", lwd = 3)

head(BV.df)



# [4] Aggregation des données par delegation

# choix du candidat
candidat <- "CAND_24"
vars <- c(candidat,"V_exprm")
VoteByDeleg.df <- aggregate(BV.df[,vars], by = list(BV.df$Code_Del), FUN=sum)
names(VoteByDeleg.df)[1] <- "id"
VoteByDeleg.df$tx<- (VoteByDeleg.df[2]/VoteByDeleg.df[3])*100
VoteByDeleg.df$tx <- round(VoteByDeleg.df$tx,2)



head(delegations.spdf@data)
