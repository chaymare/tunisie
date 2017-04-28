# *********************
# Regression linéaire *
# *********************

# [1] IMPORT

load("data/geometriesTN.RData")
elec.df<-read.csv( "data/VoteByDeleg.csv",header=TRUE,sep=",",dec=".",encoding="utf-8")
census.df<-read.csv( "data/data_carto_census2014.csv",header=TRUE,sep=";",dec=",",encoding="utf-8")

# [2] PREPARATION DES DONNES

tmp.df <- data.frame(elec.df, census.df[match(elec.df[,"id"], census.df[,"id"]),])
tmp.df$txabs <-  100-round(tmp.df$Votants/tmp.df$Inscrits*100,1)
tmp.df$txocc <-  round(tmp.df$pop_t_2014/tmp.df$log_t_2014,1)
mydata.df <- tmp.df[,c("id","name","txabs","txocc")]

# [3] REGRESSION LINEAIRE

lm <- (lm(mydata.df$txabs ~ mydata.df$txocc))
summary.lm(lm)
plot(mydata.df$txabs,mydata.df$txocc,
     ylab = "Nombre de personnes par logement",
     ylim = c(1,5),
     xlab = "Taux d'abstention",
     xlim = c(20,65),
     pch = 20, col="blue")
abline((lm(mydata.df$txocc ~ mydata.df$txabs)), col = "red", lwd =2)

# NB : c'est pas corrélé... 

# mydata.df$residus <- rstudent(lm)
# A poursuivre...