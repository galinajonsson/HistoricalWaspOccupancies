# Load required packages
require(dplyr)
require(plyr)
require(ggplot2)
require(viridis)
require(BRCmap)
require(ggthemes)

# Load spp_vis data (any would do), which contain all visits and whether or not each of the three species have been observed at that visit
spp_vis <- read.csv('./outputs/formattedData/spp_vis_merged_1kmgrid_date_year.csv', header=T, na.strings=c("","NA"))

# Load occDetdata giving each visits' site ID (grid cell), list length (numper of species observed) and time period (in this case year)
occDetdata_merged_1kmgrid_date_year <- read.csv('./outputs/formattedData/occDetdata_merged_1kmgrid_date_year.csv', header=T, na.strings=c("","NA"))

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

# Make a column collapsing the content of the first three logical columns
spp_vis$speciesID <-  as.factor(paste(spp_vis$Vespa.crabro , spp_vis$Vespula.germanica, spp_vis$Vespula.vulgaris))
# Rename levels to make sense
spp_vis$speciesID <- revalue(spp_vis$speciesID, c("FALSE FALSE TRUE"="V. vulgaris", 
                                                  "FALSE TRUE FALSE"="V. germanica", 
                                                  "FALSE TRUE TRUE"="V. vulgaris + V. germanica", 
                                                  "TRUE FALSE FALSE"="V. crabro", 
                                                  "TRUE FALSE TRUE"="V. crabro + V. vulgaris", 
                                                  "TRUE TRUE FALSE"="V. crabro + V. germanica", 
                                                  "TRUE TRUE TRUE"="V. crabro + V. vulgaris + V. germanica"))



# Make LL column a source column
spp_vis$L <- as.factor(spp_vis$L)
spp_vis$L <- revalue(spp_vis$L, c("1"="BWARS", "2"="BWARS", "3"="BWARS", "10"="NHM"))
colnames(spp_vis)[colnames(spp_vis)=="L"] <- "Source"



# 10 km grid cells
require(BRCmap)
spp_vis$grid10km <- reformat_gr(spp_vis$grid1km, prec_out = 10000, precision = NULL, pad_gr = FALSE)

spp_vis_10km_grids2 <- spp_vis %>% 
  group_by(grid10km) %>% 
  tally()
colnames(spp_vis_10km_grids2)[colnames(spp_vis_10km_grids2)=="n"] <- "nVisits"


spp_vis_10km_grids2 <- merge(spp_vis_10km_grids2, (unique(spp_vis[,c('grid10km','species')]) %>% 
                                                     group_by(grid10km) %>% 
                                                     tally()) , by="grid10km",all.x=TRUE)
colnames(spp_vis_10km_grids2)[colnames(spp_vis_10km_grids2)=="n"] <- "nSpecies"

spp_vis_10km_grids <- merge(spp_vis_10km_grids2, (unique(spp_vis[,c('grid10km','TP')]) %>% 
                                                    group_by(grid10km) %>% 
                                                    tally()) , by="grid10km",all.x=TRUE)
colnames(spp_vis_10km_grids)[colnames(spp_vis_10km_grids)=="n"] <- "nYears"

# Create range categories
spp_vis_10km_grids$nVisitsCat <- cut(spp_vis_10km_grids$nVisits, breaks=c(0, 2, 5, 10, 20, 50, Inf), labels=c("2", "3-5", "6-10", "11-20", "21-50", "51-190"))
spp_vis_10km_grids$nYearsCat <- cut(spp_vis_10km_grids$nYears, breaks=c(0, 2, 3, 5, 10, 15, 20, Inf), labels=c("2", "3", "4-5", "6-10", "11-15", "16-20", "21-40"))
# Make number of species a factor
spp_vis_10km_grids$nSpecies <- as.factor(spp_vis_10km_grids$nSpecies)

library(grid)
library(gridExtra)

plot_GIS(UK$britain, xlab = NA, ylab = NA, xlim = c(100000,700000), ylim = c(0,700000), new.window = FALSE, show.grid = FALSE, show.axis = FALSE)


# Load UK data
data(UK)

### Plot spatial distribution of wasp records at 10 km2 by number of species
# Plot UK outline
plot_GIS(UK$britain, main = "", xlim = c(100000,700000), ylim = c(0,700000), new.window = FALSE, show.grid = FALSE, show.axis = FALSE)
# Add squares to map colouring by number of species
BRCmap::plotUK_gr_cats(spp_vis_10km_grids$grid10km, spp_vis_10km_grids$nSpecies, att_col = c("#FDE725FF", "#21908CFF","#440154FF"), border = FALSE) + legend(title = "Number of species")

legend("bottomleft", inset=.02, title="Number of Cylinders",
       c("4","6","8"), fill=topo.colors(3), horiz=TRUE, cex=0.8)



grid.draw(a)

library(gridGraphics)
library(grid)
grid.echo()
a <- grid.grab()

grid.newpage()
a <- editGrob(a, BRCmap::plotUK_gr_cats(spp_vis_10km_grids$grid10km, spp_vis_10km_grids$nSpecies, att_col = c("#FDE725FF", "#21908CFF","#440154FF"), border = FALSE))
grid.draw(a)


grid.newpage()
a <- editGrob(a, vp=viewport(width=unit(2,"in")), gp=gpar(fontsize=10))
grid.draw(a)


map_nz = tm_shape(plot_GIS(UK$britain, main = "", xlim = c(100000,700000), ylim = c(0,700000), new.window = FALSE, show.grid = FALSE, show.axis = FALSE)) + tm_polygons()


z.plot1<-function(){plot_GIS(UK$britain, main = "", xlim = c(100000,700000), ylim = c(0,700000), new.window = FALSE, show.grid = FALSE, show.axis = FALSE)
  # Add squares to map colouring by number of species
  BRCmap::plotUK_gr_cats(spp_vis_10km_grids$grid10km, spp_vis_10km_grids$nVisitsCat, att_col = c("#FDE725FF","#7AD151FF","#22A884FF", "#2A788EFF", "#414487FF","#440154FF"), border = FALSE)
}

z.plot1()

### Plot spatial distribution of wasp records at 10 km2 by number of records
# Plot UK outline
plot_GIS(UK$britain, main = "", xlim = c(100000,700000), ylim = c(0,700000), new.window = FALSE, show.grid = FALSE, show.axis = FALSE)
# Add squares to map colouring by number of species
BRCmap::plotUK_gr_cats(spp_vis_10km_grids$grid10km, spp_vis_10km_grids$nVisitsCat, att_col = c("#FDE725FF","#7AD151FF","#22A884FF", "#2A788EFF", "#414487FF","#440154FF"), border = FALSE)

dpi = 600
png(file="./figs/Figure3test.png",width=6.68*dpi,height=3.94*dpi,res=600)
plot_GIS(UK$britain, main = "", xlab = NA, ylab = NA, xlim = c(100000,700000), ylim = c(0,700000), new.window = FALSE, show.grid = FALSE, show.axis = FALSE)
BRCmap::plotUK_gr_cats(spp_vis_10km_grids$grid10km, spp_vis_10km_grids$nVisitsCat, att_col = c("#FDE725FF","#7AD151FF","#22A884FF", "#2A788EFF", "#414487FF","#440154FF"), border = FALSE, legend_pos="topright")
dev.off()

legend.args = list(text = 'Elevation (m)')
                   
                   
dev.copy(png,"sample.png",width=6.68*dpi,height=3.94*dpi, units="in",res=600)
dev.off()


width=0.668,height=0.394,

ggsave(filename = "Figure_3a.pdf", plot = grid.draw(a), width = 180, height = 100, 
       dpi = 600, units = "mm", device='pdf', path = "./figs")