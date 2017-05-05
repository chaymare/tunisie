# *******************************************************
# Création d'une carte en PDF  des scores des candidats *
# *******************************************************

# ------------------------------ PARAMETRES A CHANGER -----
id_candidat <- "CAND_27"
label_candidat <- "Nom du candidat 27"
outputfile <- "outputs/carteChoro_CAND27_base100.pdf"
# ---------------------------------------------------------

# Chargement du package

library("cartography")

# Import des données

load("data/geometriesTN.RData")
stats <- read.csv( "data/VoteByDeleg.csv",
                 header=TRUE,
                 sep=",",
                 dec=".",
                 encoding="UTF8",stringsAsFactors = F)

# Calcul du score electoral

tab <- stats[,c("id",id_candidat,"V_exprm")]
tab$score <- tab[,id_candidat]/tab[,"V_exprm"]*100
tab$score <- round(tab$score,2)

# Score en base 100

moypond<-(sum(tab[,id_candidat])/sum(tab[,"V_exprm"]))*100
tab$score100 <- 100 * tab$score/moypond
tab$score100 <- round(tab$score100,2)

# Discretisation et couleurs

bornes <- c(0,25,50,100,200,400,100000)
couleurs <- carto.pal(pal1 = "blue.pal", n1 = 3, pal2 = "red.pal", n2 = 3)  

# Parametrage de la taille de la carte

k <- 0.393701 # cm to inches
widthcm <- 15
heightcm <- 20  
pdf(file = outputfile, width = widthcm*k, height = heightcm*k,pointsize=15)
opar <- par(mar = c(0, 0, 1, 0), mfrow = c(1, 1))

# Affichage de la carte

plot(delegations.spdf, border = NA, col = NA, bg = "#A6CAE0")
plot(countries.spdf,border="white",col="#eadac1", lwd=0.6, add=T)
plot(shadow.spdf,col="#2D3F4580",border="NA",add=T)

choroLayer(spdf = delegations.spdf,
           df = tab,
           var = "score100", 
           breaks = bornes,
           col = couleurs,
           border = "#FFFFFF50",
           lwd=0.1,
           add = TRUE,
           legend.pos = "left",
           legend.title.txt = "100=moy",
           legend.values.rnd = 2)

#plot(delegations.spdf, border = "#FFFFFF50", col = "#cca992",lwd=0.1,add=T)
plot(gouvernorats.spdf, border = "white", col = NA,lwd=0.6,add=T)
plot(coastlines.sp,col="#0e7aa5", lwd=1.3, add=T)
plot(others.spdf,col="#15629630",border=NA, add=T)
layoutLayer(title = label_candidat, author = "UMS RIATE / Université de Sfax", sources = "sources : xxx, year", 
            scale = NULL, theme = "taupe.pal", north = TRUE, frame = TRUE)  # add a south arrow
barscale(size = 100, lwd = 1.5, cex = 0.6, pos = NULL,
         style = "pretty")
text("ALGERIE",x=322630,y=3436484,cex = 1.5,col="#cca99280")
text("LIBYE",x=800292.7,y=3477594,cex = 1.5,col="#cca99280")

# Fin
dev.off()