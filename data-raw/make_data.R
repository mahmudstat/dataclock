# Temperature data
# Dhaka, Sylhet, Chittagong
# All divisions to be added later
# Source: https://www.weatherbase.com/weather/weather.php3?s=032914&refer=/
# https://www.ncei.noaa.gov/data/oceans/archive/arc0216/0253808/4.4/data/0-data/Region-2-WMO-Normals-9120/Bangladesh/CSV/Dhaka_41923.csv

library(stringr)

dhktmp <- c(18.4, 22.1, 26.4, 28.6, 28.9, 29.1, 28.9, 29.0, 28.7, 27.5, 24.0, 19.9)
syltmp <- c(18.4, 20.8, 24.3, 26.0, 26.8, 27.6, 28.0, 28.2, 27.9, 26.7, 23.3, 19.7)
chttmp <- c(19.8, 22.5, 26.1, 28.2, 28.8, 28.6, 28.1, 28.2, 28.4, 27.8, 24.9, 21.2)
dftmp <- data.frame(Temperature = c(dhktmp, syltmp),
                    Month = factor(rep(month.name, 2), month.name),
                    City = rep(c("Dhaka", "Sylhet"), each = 12))
bdtemp <- data.frame(Temperature = c(dhktmp, syltmp, chttmp),
                    Month = factor(rep(month.name, 3), month.name),
                    City = rep(c("Dhaka", "Sylhet", "Chittagong"), each = 12))

usethis::use_data(bdtemp, overwrite = TRUE)


## Quake data

bdquake <- read.csv("data-raw/bdquake.csv")

head(bdquake)
str(bdquake)

timex <- strsplit(bdquake$time ,"T")
hms <- unlist(lapply(timex, '[[', 2))
hms <- substr(hms, start = 1, stop = 8)

bdquake$hms <- hms

View(bdquake)

bdquake <- bdquake[-c(1,6:22)]

usethis::use_data(bdquake, overwrite = TRUE)

# Train data

brintcity <- read.csv("data-raw/brintcity.csv")

View(brintcity)

# Correct departure and arrival time (add SS)

brintcity <- brintcity %>%
  mutate(Departure = hms::parse_hm(Departure),
         Arrival = hms::parse_hm(Departure))

head(brintcity)

usethis::use_data(brintcity, overwrite = TRUE)

## Commit

gitcommit <- read.csv("data-raw/gitcommit.csv")

usethis::use_data(gitcommit, overwrite = TRUE)


# US Accidents

acdt <- read.csv("https://raw.githubusercontent.com/mahmudstat/open-analysis/main/data/usacc.csv")

acdt <- acdt %>% select(c("Start_Time", "Start_Lat", "Start_Lng",
                          "City", "County", "State", "Weather_Timestamp",
                          "Temperature.F.", "Humidity...", "Weather_Condition"))


acdt <- acdt %>% mutate(
  Time = unlist(lapply(strsplit(Start_Time ," "), '[[', 2)),
  Wether_Time <- unlist(lapply(strsplit(Weather_Timestamp ," "), '[[', 2))
)

write.csv(acdt, file = "../acdt.csv")

