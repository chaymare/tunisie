# *************************************
# Analyse Territioriale Multiscalaire *
# *************************************

library("cartography")
library("MTA")

# [1] Chargement du fichier de données

load("data/geometriesTN.RData")

# [2] Import de données correctement formatées (code SNUTS)

my.df<-read.csv( "data/data_carto_census2014.csv",header=TRUE,sep=";",dec=",",encoding="utf-8")

# [3] Deviation globale

my.df$globaldev <- gdev(my.df, "log_t_2014", "pop_t_2014", type = "rel")

# [3] Deviation territoriale
my.df$idgouv <- substr(my.df$id,1,4)
my.df$territorialdev <- tdev(my.df, "log_t_2014", "pop_t_2014", type = "rel",key="idgouv")

# [4] Déviation locale
my.df$localdev <- sdev(my.df, "log_t_2014", "pop_t_2014", type = "rel", delegations.spdf, spdfid = "del_id", xid = "id", order = 1)
bks <- c(min(my.df$localdev),75,100,125,150,max(my.df$localdev))

# [5] typologie multicalaire
seuil <- 110
synthesis <- mst(spdf = delegations.spdf,
                 x = my.df,
                 spdfid = "del_id",
                 xid = "id",
                 var1 = "log_t_2014", 
                 var2 = "pop_t_2014",
                 dist = NULL,
                 key = "idgouv",
                 order = 1,
                 mat = NULL,
                 threshold = seuil,
                 superior = TRUE)
synthesis

# [6] Réalisation d'un plancjhe cartographique

opar <- par(mar = c(0, 0, 1.2, 0), mfrow = c(2, 2))

  # carte 1
  
  bks <- c(min(synthesis$gdevrel),75,100,125,150,max(synthesis$gdevrel))
  bks <- sort(bks)
  cols <- carto.pal(pal1 = "blue.pal", n1 = 2,pal2 = "wine.pal", n2 = 3)
  
  plot(delegations.spdf, border = NA, col = NA, bg = "#A6CAE0")
  plot(countries.spdf,border="white",col="#eadac1", lwd=0.6, add=T)
  plot(shadow.spdf,col="#2D3F4580",border="NA",add=T)
  plot(delegations.spdf, border = "white", col = "#cca992",lwd=0.2,add=T)
  choroLayer(spdf = delegations.spdf, df = synthesis, var = "gdevrel",
             legend.pos = "bottomleft",
             legend.title.txt = "Ecart à la\nmoyenne\nnationale",
             breaks = bks, border = "white",lwd=0.2,
             col = cols, add=T)
  plot(gouvernorats.spdf, border = "white", col = NA,lwd=0.4,add=T)
  plot(coastlines.sp,col="#0e7aa5", lwd=1, add=T)
  plot(others.spdf,col="#15629630",border=NA, add=T)
  layoutLayer(title = "Population totale, 2014",  # Changer ici le titre de la carte
              author = "UMS RIATE / Universit? de Sfax", 
              sources = "sources : INS, 2014", # Changer ici les sources utilis?es 
              scale = 100, theme = "taupe.pal", 
              north = TRUE, frame = TRUE)  # add a south arrow
  
  # carte 2
  head(synthesis)
  bks <- c(min(synthesis$tdevrel),75,100,125,150,max(synthesis$tdevrel))
  bks <- sort(bks)
  plot(delegations.spdf, border = NA, col = NA, bg = "#A6CAE0")
  plot(countries.spdf,border="white",col="#eadac1", lwd=0.6, add=T)
  plot(shadow.spdf,col="#2D3F4580",border="NA",add=T)
  plot(delegations.spdf, border = "white", col = "#cca992",lwd=0.2,add=T)
  choroLayer(spdf = delegations.spdf, df = synthesis, var = "tdevrel",
             legend.pos = "bottomleft",
             legend.title.txt = "Ecart à la\nmoyenne\nrégionale\n(gouvernorats)",
             breaks = bks, border = "white",lwd=0.2,
             col = cols, add=T)
  plot(gouvernorats.spdf, border = "black", col = NA,lwd=0.4,add=T)
  plot(coastlines.sp,col="#0e7aa5", lwd=1, add=T)
  plot(others.spdf,col="#15629630",border=NA, add=T)
  layoutLayer(title = "Population totale, 2014",  # Changer ici le titre de la carte
              author = "UMS RIATE / Universit? de Sfax", 
              sources = "sources : INS, 2014", # Changer ici les sources utilis?es 
              scale = 100, theme = "taupe.pal", 
              north = TRUE, frame = TRUE)  # add a south arrow
  
  # carte 3
  bks <- c(min(synthesis$sdevrel),75,100,125,150,max(synthesis$sdevrel))
  bks <- sort(bks)
  
  plot(delegations.spdf, border = NA, col = NA, bg = "#A6CAE0")
  plot(countries.spdf,border="white",col="#eadac1", lwd=0.6, add=T)
  plot(shadow.spdf,col="#2D3F4580",border="NA",add=T)
  plot(delegations.spdf, border = "white", col = "#cca992",lwd=0.2,add=T)
  choroLayer(spdf = delegations.spdf, df = synthesis, var = "sdevrel",
             legend.pos = "bottomleft",
             legend.title.txt = "Ecart à la\nmoyenne\nlocale\n(contiguité)",
             breaks = bks, border = "white",lwd=0.2,
             col = cols, add=T)
  plot(gouvernorats.spdf, border = "white", col = NA,lwd=0.4,add=T)
  plot(coastlines.sp,col="#0e7aa5", lwd=1, add=T)
  plot(others.spdf,col="#15629630",border=NA, add=T)
  layoutLayer(title = "Population totale, 2014",  # Changer ici le titre de la carte
              author = "UMS RIATE / Universit? de Sfax", 
              sources = "sources : INS, 2014", # Changer ici les sources utilis?es 
              scale = 100, theme = "taupe.pal", 
              north = TRUE, frame = TRUE)  # add a south arrow
  
  # carte 4
  
  cols <- c("#f0f0f0", "#fdc785","#ffffab","#fba9b0","#addea6","#ffa100","#fff226","#e30020")
  rVal<-c(" .     .   . ",
          "[X]   .   . ",
          " .   [X]  . ",
          "[X] [X]  . ",
          " .    .   [X]",
          "[X]  .   [X]",
          " .   [X] [X]",
          "[X] [X] [X]")

  plot(delegations.spdf, border = NA, col = NA, bg = "#A6CAE0")
  plot(countries.spdf,border="white",col="#eadac1", lwd=0.6, add=T)
  plot(shadow.spdf,col="#2D3F4580",border="NA",add=T)
  plot(delegations.spdf, border = "white", col = "#cca992",lwd=0.2,add=T)
  unique(synthesis$mst)
  typoLayer(spdf = delegations.spdf, df = synthesis, var = "mst",
            border = "#D9D9D9",legend.values.order = c(0,1,2,3,4,5,7), 
            col = cols,
            lwd = 0.25,
            legend.pos = "n",
            add=T)

  legendTypo(col = cols, categ = rVal,
             title.txt = paste("Typologie\nmultiscalaire\n(>",seuil,")"),
             nodata = FALSE, pos = "bottomleft")  
  
  
