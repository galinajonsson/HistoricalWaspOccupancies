# Load required packages
require(dplyr)
require(plyr)
require(BRCmap)
require(grDevices)

# Load spp_vis data (any would do), which contain all visits and whether or not each of the three species have been observed at that visit
spp_vis <- read.csv('./outputs/formattedData/spp_vis_merged_1kmgrid_date_year.csv', header=T, na.strings=c("","NA"))

# Load occDetdata giving each visits' site ID (grid cell), list length (numper of species observed) and time period (in this case year)
occDetdata_merged_1kmgrid_date_year <- read.csv('./outputs/formattedData/occDetdata_merged_1kmgrid_date_year.csv', 
                                                header=T, na.strings=c("","NA"))

# Merge by visit
spp_vis <- merge(spp_vis, occDetdata_merged_1kmgrid_date_year, by="visit")

# Find unique visits
spp_vis <- unique(spp_vis)

# Create a species column
spp_vis$species <- as.factor(c("NA"))

# Subset each species' records into frames nand specify species idetity
spp_vis_crabro <- subset(spp_vis, Vespa.crabro == "TRUE")
spp_vis_crabro$species <- c("Vespa crabro")
spp_vis_germanica <- subset(spp_vis, Vespula.germanica == "TRUE")
spp_vis_germanica$species <- c("Vespula germanica")
spp_vis_vulgaris <- subset(spp_vis, Vespula.vulgaris == "TRUE")
spp_vis_vulgaris$species <- c("Vespula vulgaris")

# row bind each subsetted species' dataframe with the original spp_vis dataframe
spp_vis <- rbind(spp_vis_crabro, spp_vis_germanica)
spp_vis <- rbind(spp_vis, spp_vis_vulgaris)

# Rename site column to grid1km, as it shows the 1x1km gridref
spp_vis$grid1km <- as.character(spp_vis$site)

# create a new 10x10 km grid cell column
spp_vis$grid10km <- reformat_gr(spp_vis$grid1km, prec_out = 10000, precision = NULL, pad_gr = FALSE)

# Create a new data frame and populate it with the number of visits to each 10x10 grid throughout the time series
spp_vis_10km_grids <- spp_vis %>% 
  group_by(grid10km) %>% 
  tally()
colnames(spp_vis_10km_grids)[colnames(spp_vis_10km_grids)=="n"] <- "nVisits"

# Add a column with the number of species observed at each 10x10 grid throughout the time series
spp_vis_10km_grids <- merge(spp_vis_10km_grids, (unique(spp_vis[,c('grid10km','species')]) %>% 
                                                     group_by(grid10km) %>% 
                                                     tally()) , by="grid10km",all.x=TRUE)
colnames(spp_vis_10km_grids)[colnames(spp_vis_10km_grids)=="n"] <- "nSpecies"


# Create range categories
spp_vis_10km_grids$nVisitsCat <- cut(spp_vis_10km_grids$nVisits, 
                                     breaks=c(0, 2, 5, 10, 20, 50, Inf), 
                                     labels=c("2", "3-5", "6-10", "11-20", 
                                              "21-50", "51-190"))

# Make number of species a factor
spp_vis_10km_grids$nSpecies <- as.factor(spp_vis_10km_grids$nSpecies)

# Load UK data
data(UK)

### Plot spatial distribution of wasp records at 10 km2 by number of species and save
dpi = 600
pdf(file="./figs/Figure_3a.pdf",width=6.68*dpi,height=3.94*dpi)
plot_GIS(UK$britain, main = "", xlab = NA, ylab = NA, 
         xlim = c(100000,700000), ylim = c(0,700000), 
         new.window = TRUE, show.grid = FALSE, show.axis = FALSE)
BRCmap::plotUK_gr_cats(gridref = spp_vis_10km_grids$grid10km, 
                       att = spp_vis_10km_grids$nSpecies, 
                       att_col = c("#FDE725FF", "#21908CFF","#440154FF"),
                       border = FALSE, legend= FALSE)
legend("topright", legend = c("1", "2", "3"),
       fill = c("#FDE725FF", "#21908CFF","#440154FF"),
       title = "Species")
dev.off()


### Plot spatial distribution of wasp records at 10 km2 by number of visits and save
dpi = 600
pdf(file="./figs/Figure_3b.pdf",width=6.68*dpi,height=3.94*dpi)
plot_GIS(UK$britain, main = "", xlab = NA, ylab = NA, 
         xlim = c(100000,700000), ylim = c(0,700000), 
         new.window = TRUE, show.grid = FALSE, show.axis = FALSE)
BRCmap::plotUK_gr_cats(gridref = spp_vis_10km_grids$grid10km, 
                       att = spp_vis_10km_grids$nVisitsCat, 
                       att_col = c("#FDE725FF","#7AD151FF","#22A884FF", "#2A788EFF", 
                                   "#414487FF","#440154FF"),
                       border = FALSE, legend= FALSE)
legend("topright", legend = c("2", "3-5", "6-10", "11-20", "21-50", "51-190"),
         fill = c("#FDE725FF","#7AD151FF","#22A884FF", "#2A788EFF", "#414487FF","#440154FF"),
         title = "Records")
dev.off()

