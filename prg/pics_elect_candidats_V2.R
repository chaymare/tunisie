# =============================================
# pics_elect_candidats.R
# 
# objectif: définir des paramères spatiaux de répartition des votes par candidat
# auteur  : Claude GRASLAND
# date    : Dec. 2016 
# ===============================================

# ===================================
# 1. Choisir le dossier
# ===================================


setwd("/Users/claudegrasland1/Documents/cg/data/tunisie-master/data")
list.files()


# ===================================
# 2. Charger les  packages utilesة
# ===================================

library(maptools)
library(cartography)
library(vcd)
library(ineq)

# ===================================
# 3. Import et jointure
# ===================================

# 3.1 Importation du fonds de carte
load("geometriesTN.RData")
del1<-delegations.spdf
gouv1<-gouvernorats.spdf
del2<-readShapeSpatial("delegations_pop2014.shp")



# Réglage des marges la fenêtre d'affichage
par(mfrow=c(1,2), mar=c(0,0,1.2,0))
plot(del1,col="lightyellow",border="gray60",lwd=0.1)
plot(gou1,add=T,border="gray20",lwd=0.5)
title("Carte vide",cex.main=1)
plot(del2,col="lightyellow",border="gray60",lwd=0.1)
title("Carte vide",cex.main=1)




# 3.2 Importation des données
list.files()

stat1<-read.csv( "VoteByDeleg.csv",
                header=TRUE,
                sep=",",
                dec=".",
                encoding="UTF8",stringsAsFactors = F)
head(stat1)

stat2<-read.csv( "data_admin_2014.csv",
                 header=TRUE,
                 sep=",",
                 dec=",",
                 encoding="UTF8",stringsAsFactors = F)
head(stat2)


stat<-merge(stat2,stat1,by="id",all.x=T,all.y=T)

# vérification de l'identifiant des données statistiques
head(stat)
dim(stat)

# 3.3 Selection des variables utiles (choix du candidat)

tab<-stat[,c(1,3,14,15,16,13)]
names(tab)<-c("code","nom","urb","dtun","dlit","dgou")
tab$P<-stat$Votants
tab$V<-stat$V_nuls+stat$V_blancs
tab$Z<-tab$V/tab$P
moypond<-sum(tab$V)/sum(tab$P)
maximum<-max(tab$Z)
tab$Z100<-100*tab$Z/moypond
nameZ<-"Votes blancs & nuls"
head(tab)
str(tab)

# ===================================
# 4. Analyse cartographique
# ===================================




######################################################

# (4.1) Création d'une carte en symboles proportionnels
par(mfrow=c(1,2), mar=c(0,0,1,0))
plot(del1,col="lightyellow",border="gray60",lwd=0.1)
plot(gou1,add=T,border="gray20",lwd=0.5)
propSymbolsLayer(spdf=del1,
                 df = tab,
                 var = "V",
                 inches=0.1,
                 legend.pos="bottomleft",
                 legend.title.txt = "nb.votes",
                 legend.style = "e",
                 legend.values.rnd = 0)
layoutLayer(title = nameZ,
            author = "",
            col = "grey",
            south = F,
            sources = "")
plot(del2,col="lightyellow",border="gray60",lwd=0.1)
plot(gou2,add=T,border="gray20",lwd=0.5)
propSymbolsLayer(spdf=del2,
                 df = tab,
                 var = "V",
                 inches=0.1,
                 legend.pos="bottomleft",
                 legend.title.txt = "nb.votes",
                 legend.style = "e",
                 legend.values.rnd = 0)
layoutLayer(title = nameZ,
            author = "",
            col = "grey",
            south = F,
            sources = "",
            scale=NULL)


######################################################


# (4.2) Création d'une Carte Choroplèthe ("zonale")

# définit un indice 100


cols <- carto.pal(pal1 = "blue.pal", n1 = 3, pal2 = "red.pal", n2 = 3)


par(mfrow=c(1,2), mar=c(0,0,1,0))
choroLayer(spdf = del1,
           df = tab,
           var = "Z100", 
           breaks = c(0,25,50,100,200,400,100000),
           col = cols,
           border = "grey60",
           lwd=0.1,
           add = FALSE,
           legend.pos = "bottomleft",
           legend.title.txt = "100=moy",
           legend.values.rnd = 2)
plot(gou1,add=T,border="gray20",lwd=0.5)
layoutLayer(title = nameZ,
            author = "",
            col = "grey",
            south = F,
            sources = "")
choroLayer(spdf = del2,
           df = tab,
           var = "Z100", 
           breaks = c(0,25,50,100,200,400,100000),
           col = cols,
           border = "grey60",
           lwd=0.1,
           add = FALSE,
           legend.pos = "bottomleft",
           legend.title.txt = "100=moy",
           legend.values.rnd = 2)
plot(gou2,add=T,border="gray20",lwd=0.5)
layoutLayer(title = nameZ,
            author = "",
            col = "grey",
            south = F,
            sources = "",
            scale=NULL)


# ========================================
# 5. Vote et marginalité
# =======================================

library(vcd)
par(mfrow=c(2,2),mar=c(2,1,3,1))
cols <- carto.pal(pal1 = "blue.pal", n1 = 3, pal2 = "red.pal", n2 = 3)

# (5.0) Distribution des votes en 6 classes (CF. carte)
vote<-tab$Z100
vote6<-cut(vote,breaks=c(0,25,50,100,200,400,100000))
levels(vote6)<-c("V1","V2","V3","V4","V5","V6")
table(vote6)


# (5.1) Votes / hiérarchie urbaine
urb<-as.factor(tab$urb)
levels(urb)<-c("<10","10-20","20-50","50-100","+100","Tunis")

x<-table(urb,vote6)
x<-x[,apply(x,FUN="sum",2)!=0]
t<-chisq.test(x,)

titre<-paste("Chi2 = ",round(t$statistic,1)," / p-value =",round(t$p.value,4))
mosaicplot(urb~vote6,color=cols, main=NULL,
           xlab=titre, ylab=NULL,cex.axis=0.8)
title("Niveau urbain (1000 h.)")



# (5.2)  Votes / distance à Tunis

dist<-tab$dtun
quantile(dist, prob=c(0,0.167,0.33,0.5,0.667,0.833,1))
lim<-c(1,10,30,60,120,240,1000)
dist6<-cut(dist,breaks=lim)
levels(dist6)<-c("10<","10-30","30-60","60-120","120-240",">240")

x<-table(dist6,vote6)
x<-x[,apply(x,FUN="sum",2)!=0]
t<-chisq.test(x)

titre<-paste("Chi2 = ",round(t$statistic,1)," / p-value =",round(t$p.value,4))
mosaicplot(dist6~vote6,color=cols, main=NULL,
           xlab=titre, ylab=NULL,cex.axis=0.8)
title("Distance à Tunis (km)")


# (5.3) Votes / distance au littoral
dist<-tab$dlit
quantile(dist, prob=c(0,0.167,0.33,0.5,0.667,0.833,1))
lim<-c(1,10,20,40,80,160,1000)
dist6<-cut(dist,breaks=lim)
levels(dist6)<-c("10<","10-20","20-40","40-80","80-160",">160")


x<-table(dist6,vote6)
x<-x[,apply(x,FUN="sum",2)!=0]
t<-chisq.test(x)

titre<-paste("Chi2 = ",round(t$statistic,1)," / p-value =",round(t$p.value,4))
mosaicplot(dist6~vote6,color=cols, main=NULL,
           xlab=titre, ylab=NULL,cex.axis=0.8)
title("Distance à un grand port (km)")

# (5.4) Votes / distance au chef-lieu
dist<-tab$dgou
quantile(dist, prob=c(0,0.167,0.33,0.5,0.667,0.833,1))
lim<-c(1,10,20,30,40,50,1000)
dist6<-cut(dist,breaks=lim)
levels(dist6)<-c("10<","10-20","20-30","30-40","40-50",">50")


x<-table(dist6,vote6)
x<-x[,apply(x,FUN="sum",2)!=0]
t<-chisq.test(x)

titre<-paste("Chi2 = ",round(t$statistic,1)," / p-value =",round(t$p.value,4))
mosaicplot(dist6~vote6,color=cols, main=NULL,
           xlab=titre, ylab=NULL,cex.axis=0.8)
title("Distance au chef-lieu (km)")

# ========================================
# 6. Concentration territoriale des votes
# =======================================


# (5.1) Concentration des votes par délégation



par(mfrow=c(1,1),mar=c(4,4,4,4))
## compute the Lorenz curves
Lc.var <- Lc(tab$V)
Lc.tot <- Lc(tab$P)
In.var<-ineq(tab$V)
In.tot<-ineq(tab$P)
## plot both Lorenz curves
plot(Lc.tot,
     lwd=1,
     col="blue",
     cex.main=1,
     main=paste("Indice de Gini = ",round(In.var,3),sep=""),
     xlab="part des délégations",
     ylab="part des votes",
     asp=1,
     lty=2)
lines(Lc.var, col="red",lwd=2,lty=1)
abline(h=c(0.1,0.2,0.3,0.4,0.5,0.6,0.7,0.8,0.9),lwd=0.3,lty=2)
abline(v=c(0.1,0.2,0.3,0.4,0.5,0.6,0.7,0.8,0.9),lwd=0.3,lty=2)

legend(0.1, 0.9, c("Ensemble des votes", nameZ), col = c("blue","red"),
       lty = c(2, 1),lwd=c(1,2),cex=0.5)

