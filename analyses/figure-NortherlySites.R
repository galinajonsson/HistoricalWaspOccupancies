### Annual most northerly grid cells
#Here, we summarise the five most northerly grid cells recorded each year per species and plot the annual range of these grid cells' latitude

# Load packages
require(dplyr)
require(plyr)
require(boot)
library("sparta")

# Load required functions
source("./analyses/function-readRDS_multi.R")


# Load all model files
readRDS_multi("./outputs/modelOutputs")


# Load the formatted data used in analyses
spp_vis <- read.csv('./outputs/formattedData/spp_vis_merged_1kmgrid_date_year.csv', header=T, na.strings=c("","NA"))


# Subset each species into separate data frames
spp_vis_crabro <- subset(spp_vis, Vespa.crabro == "TRUE")
spp_vis_crabro$species <- c("Vespa crabro")
spp_vis_germanica <- subset(spp_vis, Vespula.germanica == "TRUE")
spp_vis_germanica$species <- c("Vespula germanica")
spp_vis_vulgaris <- subset(spp_vis, Vespula.vulgaris == "TRUE")
spp_vis_vulgaris$species <- c("Vespula vulgaris")


# Subset the first six characters of the "visit" column, which corresponds to the grid cell
spp_vis_crabro$gridcell <- substr(spp_vis_crabro$visit, start = 1, stop = 6)
spp_vis_germanica$gridcell <- substr(spp_vis_germanica$visit, start = 1, stop = 6)
spp_vis_vulgaris$gridcell <- substr(spp_vis_vulgaris$visit, start = 1, stop = 6)


# Subset the characters of the "visit" column, which corresponds to year
spp_vis_crabro$year <- as.factor(substr(spp_vis_crabro$visit, start = 14, stop = 17))
spp_vis_germanica$year <- as.factor(substr(spp_vis_germanica$visit, start = 14, stop = 17))
spp_vis_vulgaris$year <- as.factor(substr(spp_vis_vulgaris$visit, start = 14, stop = 17))


# For each species, go through each row and enter the latitude
x <- spp_vis_crabro
x$latitude <- as.numeric(NA)
nrow <- nrow(x)
years <- unique(x$year)

for(i in 1:nrow){
  x[i, "latitude"] <- (gr2gps_latlon(x[i, "gridcell"]))$LATITUDE
}


# Subset the five most northerly grid cells 
df.max <- ddply(x, c("year"), subset, order(latitude,decreasing=TRUE) <= 5)

df.max <- df.max[-2,]
df.max <- df.max[-21,]
df.max <- df.max[-92,]


df.max$Year <- as.numeric(as.character(df.max$year))

df.max$Latitude <- df.max$latitude

df.max$year <- as.factor(df.max$year)

y <- aggregate(df.max[, 8], list(df.max$year), mean)

y$Year <- as.numeric(as.character(y$Group.1))

y$Latitude <- y$x

ggplot(df.max, aes(Year, Latitude)) + 
  geom_point(data = y, stat = "identity") +
  geom_smooth(method = "loess", se = TRUE, span=1, level = 0.95) +
  scale_y_continuous(name="Latitude (degrees)", limits=c(50,55)) +
  theme(text = element_text(size=15))