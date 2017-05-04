# *****************************************
# Cartographie des données du recensement *
# *****************************************

library("cartography")

# [1] Chargement du fichier de données

load("data/geometriesTN.RData")

# [2] Import de données correctement formatées (code SNUTS)

my.df<-read.csv( "data/data_carto_census2014.csv",header=TRUE,sep=",",dec=".",encoding="utf-8")
head(my.df)
# [3] Creation d'une carte de stock

opar <- par(mar = c(0, 0, 1.2, 0))

# Template
plot(delegations.spdf, border = NA, col = NA, bg = "#A6CAE0")
plot(countries.spdf,border="white",col="#eadac1", lwd=0.6, add=T)
plot(shadow.spdf,col="#2D3F4580",border="NA",add=T)
plot(delegations.spdf, border = "white", col = "#cca992",lwd=0.2,add=T)
plot(gouvernorats.spdf, border = "white", col = NA,lwd=0.4,add=T)
plot(coastlines.sp,col="#0e7aa5", lwd=1, add=T)
plot(others.spdf,col="#15629630",border=NA, add=T)
layoutLayer(title = "Population totale, 2014",  # Changer ici le titre de la carte
            author = "UMS RIATE / Universit? de Sfax", 
            sources = "sources : INS, 2014", # Changer ici les sources utilis?es 
            scale = 100, theme = "taupe.pal", 
            north = TRUE, frame = TRUE)  # add a south arrow

# Cartographie des stocks
propSymbolsLayer(spdf = delegations.spdf, df = my.df,
                 var = "pop_t_2014", # Changer ici le nom de la variable ? cartographier 
                 fixmax = max(my.df$pop_t_2014),
                 inches = 0.07,
                 symbols = "circle", col =  "red",
                 border = "white",
                 lwd=0.5,
                 legend.pos = "topleft",
                 legend.title.txt = "Population totale, 2014", # Changer ici le titre de la l?gende
                 legend.style = "e")


# [3] Creation d'une carte de choroplèthe


# analyse de la distribution
var <- my.df$log_hosp_2k._2014
par(opar)
dev.off()
hist(var, probability = TRUE, nclass = 20)
rug(var)
moy <- mean(var)
med <- median(var)
abline(v = moy, col = "red", lwd = 3)
abline(v = med, col = "blue", lwd = 3)

# choix de la discretisation, choix des bornes
breaks <- getBreaks(var,nclass=6, method="q6")
breaks <- round(breaks,1)
breaks

# choix des couleurs
display.carto.all(n = 6)
cols <- carto.pal(pal1 = "pink.pal",n1 = 6)

# cart choroplethe

choroLayer(spdf = delegations.spdf, df = my.df, spdfid = "id", dfid = "id",
           var = "log_hosp_2k._2014", method = "q6", nclass = 6,
           col = cols)


choroLayer(spdf = cartogram_pop2014.spdf, df = my.df, spdfid = "id", dfid = "id",
           var = "log_hosp_2k._2014", method = "q6", nclass = 6,
           col = cols)


opar <- par(mar = c(0, 0, 1.2, 0))
#pdf(file = "../outputs/template.pdf", width = 15, height = 20)
#postscript(file='../outputs/template.eps',paper='special',width=10,height=10,horizontal=FALSE) 

# Mise en page (dessous)
plot(delegations.spdf, border = NA, col = NA, bg = "#A6CAE0")
plot(countries.spdf,border="white",col="#eadac1", lwd=0.6, add=T)
plot(shadow.spdf,col="#2D3F4580",border="NA",add=T)
# Cartographie d'un ratio (attention discretisation !!)
choroLayer(spdf = delegations.spdf,
           df = my.df,
           var = "log_hosp_2k._2014",
           method = "quantile", # Changer ici la m?thode de discr?tisation 
           nclass = 6, # Changer ici le nombre de classes
           col = carto.pal(pal1 = "red.pal", n1 = 6),
           border = NA,
           add = TRUE,
           legend.pos = "topleft",
           legend.title.txt = "Part des logements localisés à plus de 2 km d'un hopital local (%)", # Changer ici le titre de la l?gende
           legend.values.rnd = 1)

# Mise en page (dessus)
plot(gouvernorats.spdf, border = "white", col = NA,lwd=0.4,add=T)
plot(coastlines.sp,col="#0e7aa5", lwd=1, add=T)
plot(others.spdf,col="#15629630",border=NA, add=T)

layoutLayer(title = "Distances aux hôpitaux", # Changer ici le titre de la carte
            author = "UMS RIATE / Universit? de Sfax", 
            sources = "sources : INS, 2014", 
            scale = 100, theme = "taupe.pal", north = TRUE, frame = TRUE)  # add a south arrow

delegations.spdf@data
head(my.df)
# Faire une carte sur le taux d'occupation des logements

# Etape 1 : créer ma nouvelle variable
head(my.df)

my.df$txocc <- my.df$pop_t_2014 / my.df$log_t_2014
my.df$txocc <- round(my.df$txocc,2)
head(my.df)
summary(my.df$txocc)
hist(my.df$txocc)


lesbornes <- getBreaks(v = my.df$txocc, method = "msd", k = 1, middle = TRUE)
lesbornes

length(breaks) - 1


lescouleurs <- carto.pal(pal1 = "wine.pal", n1 = 3, 
                  pal2 = "turquoise.pal", n2 = 3, middle = T)
my.df[1:2,]

delegations.spdf[substr(delegations.spdf@data$id,1,3)=="TN1",]

plot(delegations.spdf[substr(delegations.spdf@data$id,1,3)=="TN1",])

choroLayer(spdf = delegations.spdf, df = my.df, breaks = lesbornes,
           col = lescouleurs, 
           var = "txocc", legend.values.rnd = 2, border = NA, add=T)


# EXERCICE : Creer une carte dans le template avec :
# des symbols proportionnels gradués
# Deux variables : population totale & tx d'occupation des logements

# Etape 1 (si ca n'ets pas déjà fait) : chargement des données
load("data/geometriesTN.RData")
my.df<-read.csv( "data/data_carto_census2014.csv",header=TRUE,sep=",",dec=".",encoding="utf-8")

# Etape 2 : créer ma vriable txocc
head(my.df)
my.df$txocc <- round(my.df$pop_t_2014/my.df$log_t_2014,2)
head(my.df)

# Etape 3 : analyse des données (choix de discretisation, choix de couleurs, etc.)
dev.off()
summary(my.df$txocc) # résumé statistique de la serie
boxplot(x = my.df$txocc)
hist(my.df$txocc, nclass = 30,col="green")
rug(my.df$txocc)
moy <- mean(my.df$txocc)
med <- median(my.df$txocc)
sdev <- sd(my.df$txocc)
abline(v = moy, col = "red", lwd = 3)
abline(v = med, col = "blue", lwd = 3)
abline(v = moy + 0.5*sdev, col = "grey", lwd = 3)
abline(v = moy - 0.5*sdev, col = "grey", lwd = 3)

mesbornes <- getBreaks(v = my.df$txocc, method = "msd", k = 1, middle = TRUE)
mesbornes <- round(mesbornes,2)
mesbornes <- mesbornes[c(1,3,4,5,6,8)]

hist(my.df$txocc, probability = TRUE, breaks = mesbornes, col = "green")
abline(v = moy, col = "blue", lwd = 3)
?cartography

display.carto.all(5)
mescouleurs <- carto.pal(pal1 = "orange.pal", n1 = 5)
mescouleurs2 <- carto.pal(pal1 = "blue.pal", n1 = 2,pal2 = "red.pal", n2 = 2,middle = T)

hist(my.df$txocc, probability = TRUE, breaks = mesbornes, col = mescouleurs2)
abline(v = moy, col = "blue", lwd = 3)

# Etape 4 : Afficher le template
plot(delegations.spdf, border = NA, col = NA, bg = "#A6CAE0")
plot(countries.spdf,border="white",col="#eadac1", lwd=0.6, add=T)
plot(shadow.spdf,col="#2D3F4580",border="NA",add=T)
plot(delegations.spdf, border = "white", col = "#cca992",lwd=0.2,add=T)
plot(gouvernorats.spdf, border = "white", col = NA,lwd=0.4,add=T)
plot(coastlines.sp,col="#0e7aa5", lwd=1, add=T)
plot(others.spdf,col="#15629630",border=NA, add=T)
layoutLayer(title = "Taux d'occupation en 2014",  # Changer ici le titre de la carte
            author = "UMS RIATE / Université de Sfax", 
            sources = "sources : INS, 2014", # Changer ici les sources utilis?es 
            scale = NULL, theme = "taupe.pal", 
            north = TRUE, frame = TRUE)  # add a south arrow

locator(1)
barscale(size = 100, lwd = 1.5, cex = 0.6, pos = c(181642.3,3508593), style = "pretty")
# Etape 4 : Trouver la fonction qui permet de faire un symbole prop gradué et lire la doc
propSymbolsChoroLayer(spdf = delegations.spdf, df = my.df, 
                      var = "pop_t_2014", var2 = "txocc", 
                      breaks = mesbornes, col = mescouleurs2,
                      inches = 0.1, symbols="square",
                      legend.var.style = "e")
                      
# Etape 5 : La parametrer.



