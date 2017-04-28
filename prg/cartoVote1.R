# ****************************************
# Cartographie des scores d'un candidats *
# ****************************************

# [1] Chargement du fichier de données

load("data/geometriesTN.RData")

# [2] Import de données éléctorales par délégation (voir programme BVtoDEL.R)

my.df<-read.csv( "data/VoteByDeleg.csv",header=TRUE,sep=",",dec=".",encoding="utf-8")
head(my.df)

# [3] Choix d'un candidat et calcul du score électoral

candidat <- "CAND_24"
tab.df <- my.df[,c("id","name",candidat,"V_exprm")]
tab.df$score <- (tab.df[,candidat]/tab.df$V_exprm)*100
tab.df$score <- round(tab.df$score,1)

# [4] Analyse de la distribution

var <- tab.df$score

summary(var)

hist(var, probability = TRUE, nclass = 30,col = "lightgreen")
rug(var)
moy <- mean(var)
med <- median(var)
abline(v = moy, col = "red", lwd = 3)
abline(v = med, col = "blue", lwd = 3)

# [5] Choix de la discretisation
breaks <- getBreaks(v = var, nclass = 7, method = "quantile")
hist(var, probability = TRUE, breaks = breaks, col = "lightgreen")
rug(var)
med <- median(var)
abline(v = med, col = "blue", lwd = 3)

# [5] Cartographie

cols = carto.pal(pal1 = "red.pal", n1 = 7)
cols = carto.pal(pal1 = "blue.pal", n1 = 3,pal2 = "red.pal", n2 = 3,middle = T)
 
plot(delegations.spdf, border = NA, col = NA, bg = "#A6CAE0")
plot(countries.spdf,border="white",col="#eadac1", lwd=0.6, add=T)
plot(shadow.spdf,col="#2D3F4580",border="NA",add=T)
choroLayer(spdf = delegations.spdf,
           df = tab.df,
           var = "score",
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
