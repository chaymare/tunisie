# ****************************
# Introduction à R - RAPPELS *
# ****************************

# variables, affectations, opérations

a <- 5
b <- 6
a + b
toto <- "Monsieur et madame doeuf ont un fils américain"
toto

# Les vecteurs

c(1,2,3,4,5,6)
chiffres <- c(1,4,8,9,12,3,7,6,11,5,10,2)
class(chiffres)
chiffres
chiffres <- sort(chiffres,decreasing = F)
chiffres

animaux <- c("Chien","Chat","Lapin","Grenouille","Crocodile","Serpent")
class(animaux)
length(animaux)
animaux[3]
animaux[2:5]
animaux[c(3,5)]
animaux[c(1,length(animaux))]

rep( c(1,3), c(2,3) )
seq(2,10,2)

# Les dataframe
tableau.df <- data.frame(prénom=c("Herbie","Miles","Julien","Thelonious"),nom=c("Hancock","Davis","Lourau","Monk"))
tableau.df
dim(tableau.df)
str(tableau.df)
rownames(tableau.df)
colnames(tableau.df)

tableau.df[1,]  # Sélectionner une ligne
tableau.df[,2] # Sélectionner une colonne
tableau.df$prénom # Sélectionner une colonne
tableau.df[1,1] # Sélectionner une valeur
tableau.df[4,2] # Sélectionner une valeur


# Ouvrir un ficher de données

my.df<-read.csv( "data/data_carto_census2014.csv",header=TRUE,sep=";",dec=",",encoding = "UTF-8")
head(my.df,8)
dim(my.df)
my.df$log_t_2014
summary(my.df$log_t_2014)

# Extraire un vecteur
myvecteur <- my.df$id
myvecteur

# Ajouter une colonne

my.df$txlgt <- (my.df$log_t_2014 /  my.df$pop_t_2014) *100
head(my.df,4)
my.df$txlgt<- round(my.df$txlgt,1)
head(my.df,4)

# Sauvegarder le fichier

write.csv(x = my.df,file = "nouveaufichier.csv")

# Ajouter des données géométriques

#install.packages("rgdal") #executer une seule fois
library("rgdal")

# Importer un shapfile
# monFondDeCarte <-readOGR(dsn ="/repertoire-de-travail",layer = "nom-de-la-couche")

# Importer un ficher json
delegations.spdf <- readOGR(dsn = "data/TN-delegations.geojson", layer = "OGRGeoJSON")

# Explorer le ficher
class(delegations.spdf)
proj4string(delegations.spdf)
head(delegations.spdf@data)

# Afficher
plot(delegations.spdf)
plot(delegations.spdf,col="red",border="white",lwd=0.6)

# Faire une jointure

fonddecarte <- delegations.spdf
données <- my.df

head(fonddecarte@data)
head(données)

fonddecarte@data <- data.frame(fonddecarte@data, données[match(fonddecarte@data[,"del_id"], données[,"id"]),])
head(fonddecarte@data )

# Exporter au format shapfile
#writeOGR(obj=fonddecarte, dsn="outputs", layer="monshapfile", driver="ESRI Shapefile") # this is in equal area projection

