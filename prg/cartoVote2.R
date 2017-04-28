# *********************************************************
# Cartographie des scores des tous les candidats (boucle) *
# *********************************************************

# [1] Chargement du fichier de données

load("data/geometriesTN.RData")

# [2] Import de données éléctorales par délégation (voir programme BVtoDEL.R)

my.df<-read.csv( "data/VoteByDeleg.csv",header=TRUE,sep=",",dec=".",encoding="utf-8")
head(my.df)

# [3] Création d'un tableau des scores des candidats
head(my.df)
scores.df <- my.df
for (i in 9:34){
  scores.df[,i] <- (scores.df[,i]/scores.df[,"V_exprm"])*100
  scores.df[,i] <- round(scores.df[,i],1)
}
head(scores.df)

# [4] Deux choix de discretisation possibles

# 4.1 : Une discrétisation unique
summary(scores.df)
breaks <- c(0,2,5,10,15,20,25,30,34,40,91)
cols <- carto.pal(pal1 = "wine.pal",n1 = length(breaks)-1)

# 4.2 : Les quantiles
nclass <- 8
cols <- carto.pal(pal1 = "wine.pal",n1 = nclass)
# -> A calculer pour chaque variable

# [5] Cartographie


# Etape 1 : Création d'un fonction

PlotMap <- function(candidat){
breaks <- getBreaks(v = scores.df[,candidat], nclass = 7, method = "quantile")

plot(delegations.spdf, border = NA, col = NA, bg = "#A6CAE0")
plot(countries.spdf,border="white",col="#eadac1", lwd=0.6, add=T)
plot(shadow.spdf,col="#2D3F4580",border="NA",add=T)
choroLayer(spdf = delegations.spdf,
           df = scores.df,
           var = candidat,
           breaks = breaks,
           col = cols,
           border = "white",
           lwd=0.4,
           add = TRUE,
           legend.pos = "topleft",
           legend.title.txt = paste("Score de",candidat,"\nen % des\nsuffrages\nexprimés",sep=" "), # Changer ici le titre de la l?gende
           legend.values.rnd = 1)
plot(gouvernorats.spdf, border = "white", col = NA,lwd=0.4,add=T)
plot(coastlines.sp,col="#0e7aa5", lwd=1, add=T)
plot(others.spdf,col="#15629630",border=NA, add=T)
layoutLayer(title = candidat, # Changer ici le titre de la carte
            author = "UMS RIATE / Université de Sfax, 2017", 
            sources = "Sources : Instance Supérieure\nIndépendante pour les Élections, 2017", 
            scale = 100, theme = "taupe.pal", north = TRUE, frame = TRUE)  # add a south arrow
}

# Etape 2 : Appel de la fonction



# Pour appliquer cette fonction à tous les candidats, on fait une boucle
ListeCandidats <- names(scores.df[,8:34])
for (i in ListeCandidats){
  PlotMap(i)
}

