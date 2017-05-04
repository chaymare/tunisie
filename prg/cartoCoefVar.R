# ************************************
# Cartographie des coef de variation *
# ************************************

# setwd(".......")
getwd()
library("cartography")

# [1] Chargement du fichier de données

load("data/geometriesTN.RData")

# [2] Import de données éléctorales par délégation (voir programme BVtoDEL.R)

my.df<-read.csv( "data/CvByDeleg.csv",header=TRUE,sep=",",dec=".",encoding="utf-8")
head(my.df)

# [3] Choix d'un candidat et calcul du score électoral

myvar <- "CV_CAND_27"

# [4] Analyse de la distribution

var <- my.df[,myvar]
summary(var)

hist(var, probability = TRUE, nclass = 30,col = "lightgreen")
rug(var)
moy <- mean(var)
med <- median(var)
abline(v = moy, col = "red", lwd = 3)
abline(v = med, col = "blue", lwd = 3)

# [5] Choix de la discretisation
breaks <- getBreaks(v = var, nclass = 8, method = "quantile")
hist(var, probability = TRUE, breaks = breaks, col = "lightgreen")
rug(var)
med <- median(var)
abline(v = med, col = "blue", lwd = 3)

# [5] Cartographie

dev.off()
opar <- par(mar = c(0, 0, 1.2, 0), mfrow = c(1, 2))

cols = carto.pal(pal1 = "red.pal", n1 = 8)
cols = carto.pal(pal1 = "blue.pal", n1 = 4,pal2 = "red.pal", n2 = 4)

choroLayer(spdf = delegations.spdf,
           df = my.df,
           var = myvar,
           breaks = breaks,
           col = cols,
           border = "white",
           lwd=0.4,
           add = FALSE,
           legend.pos = "topleft",
           legend.title.txt = myvar, # Changer ici le titre de la l?gende
           legend.values.rnd = 3)
plot(gouvernorats.spdf, border = "white", col = NA,lwd=1,add=T)

layoutLayer(title = paste("Coef de variation",myvar), # Changer ici le titre de la carte
            author = "UMS RIATE / Université de Sfax, 2017", 
            sources = "Sources : Instance Supérieure\nIndépendante pour les Élections, 2017", 
            scale = 100, theme = "taupe.pal", north = TRUE, frame = TRUE)  # add a south arrow

# Version 2


choroLayer(spdf = cartogram_pop2014.spdf,
           df = my.df,
           var = myvar,
           breaks = breaks,
           col = cols,
           border = "white",
           lwd=0.4,
           add = FALSE,
           legend.pos = "topleft",
           legend.title.txt = myvar, # Changer ici le titre de la l?gende
           legend.values.rnd = 3)
layoutLayer(title = paste("Coef de variation de",myvar), # Changer ici le titre de la carte
            author = "UMS RIATE / Université de Sfax, 2017", 
            sources = "Sources : Instance Supérieure\nIndépendante pour les Élections, 2017", 
            scale = NULL, theme = "taupe.pal", north = TRUE, frame = TRUE)  # add a south arrow

opar <- par(mar = c(0, 0, 1.2, 0), mfrow = c(1, 1))

