# [1] Chargement du fichier de données

load("data/geometriesTN.RData")

# [2] Mise en forme du template

opar <- par(mar = c(0, 0, 1.2, 0))

#pdf(file = "../outputs/template.pdf", width = 15, height = 20)
#postscript(file='../outputs/template.eps',paper='special',width=10,height=10,horizontal=FALSE) 

library("cartography")

plot(delegations.spdf, border = NA, col = NA, bg = "#A6CAE0")
plot(countries.spdf,border="white",col="#eadac1", lwd=0.6, add=T)
plot(shadow.spdf,col="#2D3F4580",border="NA",add=T)
plot(delegations.spdf, border = "white", col = "#cca992",lwd=0.2,add=T)
plot(gouvernorats.spdf, border = "white", col = NA,lwd=0.4,add=T)
plot(coastlines.sp,col="#0e7aa5", lwd=1, add=T)
plot(others.spdf,col="#15629630",border=NA, add=T)
layoutLayer(title = "Template cartographique de la Tunisie", author = "UMS RIATE / Université de Sfax", sources = "sources : xxx, year", 
            scale = 100, theme = "taupe.pal", north = TRUE, frame = TRUE)  # add a south arrow

