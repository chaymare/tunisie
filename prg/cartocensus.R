library("cartography")

# [1] Chargement du fichier de données

load("data/geometriesTN.RData")

# [2] Import de données correctement formatées (code SNUTS)

my.df<-read.csv( "data/data_carto_census2014.csv",header=TRUE,sep=";",dec=",",encoding="utf-8")

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
                 inches = 0.1,
                 symbols = "circle", col =  "red",
                 border = "white",
                 legend.pos = "right",
                 legend.title.txt = "Population totale, 2014", # Changer ici le titre de la l?gende
                 legend.style = "e")



# [3] Creation d'une carte de choroplèthe

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


