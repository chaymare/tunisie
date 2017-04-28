# *********
# Lissage *
# *********

library("cartography")

# [1] Chargement du fichier de données

load("data/geometriesTN.RData")

# [2] Import de données éléctorales par délégation (voir programme BVtoDEL.R)

my.df<-read.csv( "data/VoteByDeleg.csv",header=TRUE,sep=",",dec=".",encoding="utf-8")

# [3] Choix d'un candidat et calcul du score électoral

candidat <- "CAND_24"
tab.df <- my.df[,c("id","name",candidat,"V_exprm")]
tab.df$nb <- tab.df[,candidat]*100
tab.df$score <- tab.df$nb/tab.df$V_exprm

# [4] Lissage

span <- 20000

breaks <-  getBreaks(tab.df$score,6)
breaks <- c(4,10,15,20,30,40,50,91)
cols <-  carto.pal(pal1 = "green.pal",n1=7)
mask<- rgeos::gBuffer(delegations.spdf,byid=F,width=1)
plot(delegations.spdf, border = NA, col = NA, bg = "#A6CAE0")
plot(countries.spdf,border="white",col="#eadac1", lwd=0.6, add=T)
plot(shadow.spdf,col="#2D3F4580",border="NA",add=T)
smoothLayer(spdf = delegations.spdf, df = tab.df, 
            var = 'nb', var2 = 'V_exprm',
            span = span, beta = 2, 
            breaks = breaks,
            col = cols,
            legend.title.txt = paste("lissage : ",span),
            legend.pos = "topleft", legend.values.rnd = 0,add=T) 
plot(gouvernorats.spdf, border = "white", col = NA,lwd=0.4,add=T)
plot(coastlines.sp,col="#0e7aa5", lwd=1, add=T)
plot(others.spdf,col="#15629630",border=NA, add=T)
layoutLayer(title = candidat, # Changer ici le titre de la carte
            author = "UMS RIATE / Université de Sfax, 2017", 
            sources = "Sources : Instance Supérieure\nIndépendante pour les Élections, 2017", 
            scale = 100, theme = "taupe.pal", north = TRUE, frame = TRUE)  # add a south arrow
