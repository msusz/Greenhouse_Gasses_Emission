library(tidyverse)
library(lattice)
library(forecast)
library(ggplot2)
library(plotly)
#import data from csv file
emission_data <- read.csv("Suszczyk_raw_data.csv", comment.char="#");
#how does the data look like?
head(emission_data)
glimpse(emission_data)
#a great majority of data at the beginning is filled with zeros,
#so I decided to cut data and use measurments from years 1917-2017
emission_data_filtred<-emission_data[,168:268]
countries<-emission_data[,1]
emission_data_processed<-data.frame(emission_data_filtred, row.names=countries)
write.csv(emission_data_processed, "Suszczyk_prepared_data.csv")


#choosing data for the UK (graphics package)
ed_UK<-data.frame(c(1917:2017), t(emission_data_processed["United Kingdom",  ]))
colnames(ed_UK)<-c("year", "emission")
plot(ed_UK$year, ed_UK$emission,
     type="l", col="springgreen", xlab="Year", 
     ylab="Tonnes")
title("Greenhouse gasses emission in United Kingdom")

#data for Poland (ggplot2)
ed_PL<-data.frame(c(1917:2017), t(emission_data_processed["Poland",  ]))
colnames(ed_PL)<-c("year", "emission")
ggplot(ed_PL, aes(year, emission))+labs(x="Year", y="Tonnes")+
  theme_gray()+geom_line()+ggtitle("Greenhouse gasses emission in Poland")

# top 5 countries with the biggest emission in 2017 (lattice)
ed_sorted <- arrange(emission_data_processed, desc(X2017))
rownames(ed_sorted[1:5,])
#some rows from top 5 are summary data, such as World and EU
#so we need to choose specific countries by name
rownames(ed_sorted[1:10,])
top5 <- ed_sorted[c("United States", "China", "Russia", "Germany", "United Kingdom"),]
top5 <- data.frame(c(1917:2017), t(top5) )
colnames(top5)<-c("year", "US", "CHN", "RUS", "DE", "UK")
xyplot(US~year, data=top5, main="United States")
xyplot(CHN~year, data=top5, main="China")
xyplot(RUS~year, data=top5, main="Russia")
xyplot(DE~year, data=top5, main="Germany")
xyplot(UK~year, data=top5, main="United Kingdom")

#map of the most polluting countries in 2017 (plotly)
top5_2017<-top5["X2017",]
top5_2017<-t(top5_2017)
top5_2017<-data.frame(c("year", "US", "China", "Russia", "Germany", "United Kingdom"), top5_2017)
top5_2017<-top5_2017[2:6,]
colnames(top5_2017)<- c("country", "emission")

l <- list(color = toRGB("grey"), width = 0.5)
g <- list(
  showframe = FALSE,
  showland = TRUE,
  projection = list(type = "Mercator")
)
fig <- plot_geo(top5_2017,locationmode = "country names")
fig <- fig %>% add_trace(
  z = ~emission, locations=~country,
  text = ~country, marker = list(line = l)
  )
fig <- fig %>% layout(
  title = "TOP5 countries with the highest emission in 2017",
  geo = g
)
fig

#forecasting world emission (forecast)
world<-emission_data_processed["World",]
world<-t(world)
world<-data.frame(c(1917:2017), world)
colnames(world)<- c("year", "emission")
world_ts<-ts(world, start=1917, frequency=1)
plot(forecast(world_ts), main="World emission forecast", 
     xlab="Year", ylab="Tonnes")
