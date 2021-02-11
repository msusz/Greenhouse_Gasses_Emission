library(tidyverse)
library(lattice)
library(forecast)
library(ggplot2)
library(plotly)
#import danych
emission_data <- read.csv("~/AGHS3/R/Projekt R/Suszczyk_dane_surowe.csv", comment.char="#");
#sprawdzenie danych
head(emission_data)
glimpse(emission_data)
#widzimy, ze wiekszosc wartosci z poczatku danych to 0, dlatego ucinamy dane do 1917r
emission_data_filtred<-emission_data[,168:268]
countries<-emission_data[,1]
emission_data_processed<-data.frame(emission_data_filtred, row.names=countries)
write.csv(emission_data_processed, 'Suszczyk_dane_przeksztalcone.csv')


#wybranie danych dla Wielkiej Brytanii (pakiet graphics)
ed_UK<-data.frame(c(1917:2017), t(emission_data_processed["United Kingdom",  ]))
colnames(ed_UK)<-c("year", "emission")
plot(ed_UK$year, ed_UK$emission,
     type="l", col="springgreen", xlab="Rok", 
     ylab="Emisja gazów cieplarnianych w tonach")
title("Emisja gazów cieplarnianych Wielkiej Brytanii")

#dane dla Polski (ggplot2)
ed_PL<-data.frame(c(1917:2017), t(emission_data_processed["Poland",  ]))
colnames(ed_PL)<-c("year", "emission")
ggplot(ed_PL, aes(year, emission))+labs(x="Rok", y="Emisja gazów cieplarnianych w tonach")+
  theme_gray()+geom_line()

# top 5 najbardziej zanieczyszczajacych krajow (lattice)
ed_sorted <- arrange(emission_data_processed, desc(X2017))
rownames(ed_sorted[1:5,])
#widzimy, ze czesc z top5 danych to dane zbiorowe, swiat, EU itd.
#dlatego trzeba wybrac konkretne kraje
rownames(ed_sorted[1:10,])
top5 <- ed_sorted[c("United States", "China", "Russia", "Germany", "United Kingdom"),]
top5 <- data.frame(c(1917:2017), t(top5) )
colnames(top5)<-c("year", "US", "CHN", "RUS", "DE", "UK")
xyplot(US~year, data=top5)
xyplot(CHN~year, data=top5)
xyplot(RUS~year, data=top5)
xyplot(DE~year, data=top5)
xyplot(UK~year, data=top5)

#mapa najbardziej zanieczyszczajacych krajow 2017 (plotly)
top5_2017<-top5["X2017",]
top5_2017<-t(top5_2017)
top5_2017<-data.frame(c("year", "US", "China", "Russia", "Germany", "United Kingdom"), top5_2017)
top5_2017<-top5_2017[2:6,]
colnames(top5_2017)<- c("country", "emission")

l <- list(color = toRGB("grey"), width = 0.5)
g <- list(
  showframe = FALSE,
  showland = TRUE,
  projection = list(type = 'Mercator')
)
fig <- plot_geo(top5_2017,locationmode = 'country names')
fig <- fig %>% add_trace(
  z = ~emission, locations=~country,
  text = ~country, marker = list(line = l)
  )
fig <- fig %>% layout(
  title = 'TOP5 krajów z najwieksza emisja 2017',
  geo = g
)
fig

#przewidywania dla swiata (forecast)
world<-emission_data_processed["World",]
world<-t(world)
world<-data.frame(c(1917:2017), world)
colnames(world)<- c("year", "emission")
world_ts<-ts(world, start=1917, frequency=1)
plot(forecast(world_ts), main="Prognozy emisji dla swiata", 
     xlab="rok", ylab="emisja w tonach")
