# Greanhouse gasses emission around the world since 1750 and until 2017

### Intro
This project is an analysis and visualization of greenhouse gasses emission data.
Original data file is [here](https://github.com/msusz/Greenhouse_Gasses_Emission/blob/main/Suszczyk_dane_surowe.csv).
This file contains a series of measurments of greenhouse gasses emission by every country in the world.

### Data preparation
First 50 years covered by the data are mostly zeros, as not many countries were collecting such data since 1750. First column in the data file is filled with countries.The most useful data preparation will include creating a data frame containing first column (countries names) and measures since 1800 and until 2017.
Prepared data are stored in another CSV file - [here](https://github.com/msusz/Greenhouse_Gasses_Emission/blob/main/Suszczyk_dane_przeksztalcone.csv).

### United Kingdom data
United Kingdom emission stands out from the rest of the world. Data were collected way before other countries started to take measurments. Lets look at the plot of emission over the years.  
![UK plot](UK_emission_plot.jpeg)  
As you can see, emission level was increasing at a steady pace in the examined peroid of time.
