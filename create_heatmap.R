conc_deaths <- read.csv("Accidental_Drug_Related_Deaths_January_2012-Sept_2015.csv")
head(conc_deaths)

hist(conc_deaths$Age)

loc_data <- gsub(pattern = "\n", replacement = ";", x = conc_deaths$DeathLoc)
loc_data <- strsplit(loc_data, ";")
head(loc_data)

for(i in 1:length(loc_data)){
        conc_deaths$town[i] <- loc_data[[i]][1]
        conc_deaths$coord[i] <- loc_data[[i]][2]
}

loc_data <- NULL
conc_deaths$DeathLoc <- NULL
conc_deaths$coord <- gsub(pattern = "\\(", replacement = "", x = conc_deaths$coord)
conc_deaths$coord <- gsub(pattern = ")", replacement = "", x = conc_deaths$coord)

loc_data <- strsplit(conc_deaths$coord, split = ", ")

for(i in 1:length(loc_data)){
        conc_deaths$lat[i] <- loc_data[[i]][1]
        conc_deaths$lon[i] <- loc_data[[i]][2]
}

loc_data <- NULL
conc_deaths$coord <- NULL
conc_deaths$lat <- as.numeric(conc_deaths$lat)
conc_deaths$lon <- as.numeric(conc_deaths$lon)

library(ggplot2)
library(ggmap) 

con <- get_map(location = "Conneticut", maptype = "roadmap", zoom = 8)
con1 <- get_map(location = "Conneticut", maptype = "terrain-labels", zoom = 9)
con2 <- get_map(location = "Conneticut", maptype = "terrain-lines", zoom = 9)

map1 <- ggmap(con, extent = "device") + geom_density2d(data = conc_deaths, 
                                                        aes(x = lon, y = lat)) + 
        stat_density2d(data = conc_deaths, aes(fill = ..level.., alpha = ..level..),
                       size = 0.01, geom = "polygon") + 
        scale_fill_gradient(low = "green", high = "red", guide = FALSE) + 
        scale_alpha(range = c(0, 0.3), guide = FALSE)