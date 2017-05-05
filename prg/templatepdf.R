# ********************************************
# Création d'un template cartographique PDF  *
# ********************************************

#setwd("repertoire-de-travail")

# [1] Chargement du fichier de données

load("data/geometriesTN.RData")

# [2] Mise en forme du template

library("cartography")




opar <- par(mar = c(0, 0, 1.2, 0), mfrow = c(1, 1))
#sizes <- getFigDim(spdf = delegations.spdf, width = 15, mar = c(0, 0, 1.2, 0))
k <- 0.5
widthcm <- 15
heightcom <- 18  
pdf(file = "outputs/template.pdf", width = widthcm*k, height = heightcom*k,pointsize=15)

plot(delegations.spdf, border = NA, col = NA, bg = "#A6CAE0")
plot(countries.spdf,border="white",col="#eadac1", lwd=0.6, add=T)
plot(shadow.spdf,col="#2D3F4580",border="NA",add=T)
plot(delegations.spdf, border = "#FFFFFF50", col = "#cca992",lwd=0.1,add=T)
plot(gouvernorats.spdf, border = "white", col = NA,lwd=0.6,add=T)
plot(coastlines.sp,col="#0e7aa5", lwd=1, add=T)
plot(others.spdf,col="#15629630",border=NA, add=T)
layoutLayer(title = "Template cartographique de la Tunisie", author = "UMS RIATE / Université de Sfax", sources = "sources : xxx, year", 
            scale = NULL, theme = "taupe.pal", north = TRUE, frame = TRUE)  # add a south arrow
barscale(size = 100, lwd = 1.5, cex = 0.6, pos = NULL,
         style = "pretty")


#locator(1)
text("ALGERIE",x=322630,y=3436484,cex = 1.5,col="#cca99280")
text("LIBYE",x=800292.7,y=3477594,cex = 1.5,col="#cca99280")

dev.off()
