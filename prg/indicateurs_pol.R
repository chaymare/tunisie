# ***************************************
# QUelques indicateurs cartographiables *
# ***************************************

# [1] IMPORT

load("data/geometriesTN.RData")
my.df<-read.csv( "data/VoteByDeleg.csv",header=TRUE,sep=",",dec=".",encoding="utf-8")

# [2] INDICATEURS 

head(my.df,2)

# taux de participation
results.df <- my.df[,c("id")]
results.df$txparticipation <- round(my.df$Votants/my.df$Inscrits*100,1)

# taux d'abstention
results.df$txabstention <- 100-round(my.df$Votants/my.df$Inscrits*100,1)

# Part des blancs et nuls
results.df$txblancnul <- ((my.df$V_nuls + my.df$V_blancs) / my.df$Votants)*100
results.df$txblancnul <- round(results.df$txblancnul,1) 
head(results.df)

# Taux de vote utile

util <- c("CAND_07","CAND_24")
results.df$txvoteutile <- ((my.df[,util[1]]+my.df[,util[2]])/my.df$V_exprm)*100
results.df$txvoteutile <- round(results.df$txvoteutile,1)


# [3] CARTOGRAPHIE


