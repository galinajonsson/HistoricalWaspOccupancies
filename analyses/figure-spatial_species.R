# Load required packages
require(dplyr)
require(plyr)
require(BRCmap)
require(grDevices)
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

# V. vulgaris -> make a data frame with all sites with records of this species and the records' source (list length = L)
spp_vis_vulgaris_source <- unique(spp_vis_vulgaris[,c('site','L')])
# Tally list length by site
spp_vis_vulgaris_source <- spp_vis_vulgaris_source %>%
  group_by(site) %>%
  tally(L)
# Rename column n (tally of L to source) and make it a character
spp_vis_vulgaris_source$source <- spp_vis_vulgaris_source$n
spp_vis_vulgaris_source$source <- as.factor(as.character(spp_vis_vulgaris_source$source))

# Revalue sources: 10 is NHM, less than 10 is BWARS and more thna 10 is both NHM and BWARS
spp_vis_vulgaris_source$source <- revalue(spp_vis_vulgaris_source$source, c("1"="BWARS", 
                                                                            "10"="NHM", 
                                                                            "11"="NHM+BWARS", 
                                                                            "13"="NHM+BWARS", 
                                                                            "16"="NHM+BWARS", 
                                                                            "2"="BWARS", 
                                                                            "3"="BWARS", 
                                                                            "4"="BWARS", 
                                                                            "6"="BWARS"))

# V. germanica -> Same as for V. vulgaris
spp_vis_germanica_source <- unique(spp_vis_germanica[,c('site','L')])
spp_vis_germanica_source <- spp_vis_germanica_source %>%
  group_by(site) %>%
  tally(L)
spp_vis_germanica_source$source <- spp_vis_germanica_source$n
spp_vis_germanica_source$source <- as.factor(as.character(spp_vis_germanica_source$source))
spp_vis_germanica_source$source <- revalue(spp_vis_germanica_source$source, c("1"="BWARS", 
                                                                              "10"="NHM", 
                                                                              "11"="NHM+BWARS", 
                                                                              "13"="NHM+BWARS", 
                                                                              "2"="BWARS", 
                                                                              "3"="BWARS", 
                                                                              "4"="BWARS", 
                                                                              "5"="BWARS", 
                                                                              "6"="BWARS"))

# V. crabro -> Same as for V. vulgaris
spp_vis_crabro_source <- unique(spp_vis_crabro[,c('site','L')])
spp_vis_crabro_source <- spp_vis_crabro_source %>%
  group_by(site) %>%
  tally(L)
spp_vis_crabro_source$source <- spp_vis_crabro_source$n
spp_vis_crabro_source$source <- as.factor(as.character(spp_vis_crabro_source$source))
spp_vis_crabro_source$source <- revalue(spp_vis_crabro_source$source, c("1"="BWARS", 
                                                                        "10"="NHM", 
                                                                        "11"="NHM+BWARS", 
                                                                        "13"="NHM+BWARS", 
                                                                        "14"="NHM+BWARS", 
                                                                        "2"="BWARS", 
                                                                        "3"="BWARS", 
                                                                        "4"="BWARS", 
                                                                        "5"="BWARS", 
                                                                        "6"="BWARS"))

# Load UK data
data(UK)

### Plot spatial distribution of Vespula vulgaris records at 10 km2 grid cells by source
dpi = 600
pdf(file="./figs/Figure_S1_2a.pdf",width=6.68*dpi,height=3.94*dpi)
plot_GIS(UK$britain, main = "", xlab = NA, ylab = NA, 
         xlim = c(100000,700000), ylim = c(0,700000), 
         new.window = TRUE, show.grid = FALSE, show.axis = FALSE)
BRCmap::plotUK_gr_cats(gridref = reformat_gr(spp_vis_vulgaris_source$site, prec_out = 10000, 
                                   precision = NULL, pad_gr = FALSE), 
                       att = spp_vis_vulgaris_source$source, 
                       att_col = (colorblind_pal()(3)), 
                       border = FALSE, legend= FALSE)
dev.off()


### Plot spatial distribution of Vespula germanica records at 10 km2 grid cells by source
dpi = 600
pdf(file="./figs/Figure_S1_2b.pdf",width=6.68*dpi,height=3.94*dpi)
plot_GIS(UK$britain, main = "", xlab = NA, ylab = NA, 
         xlim = c(100000,700000), ylim = c(0,700000), 
         new.window = TRUE, show.grid = FALSE, show.axis = FALSE)
BRCmap::plotUK_gr_cats(gridref = reformat_gr(spp_vis_germanica_source$site, prec_out = 10000, 
                                             precision = NULL, pad_gr = FALSE), 
                       att = spp_vis_germanica_source$source, 
                       att_col = (colorblind_pal()(3)), 
                       border = FALSE, legend= FALSE)
dev.off()



### Plot spatial distribution of Vespa crabro records at 10 km2 grid cells by source
dpi = 600
pdf(file="./figs/Figure_S1_2c.pdf",width=6.68*dpi,height=3.94*dpi)
plot_GIS(UK$britain, main = "", xlab = NA, ylab = NA, 
         xlim = c(100000,700000), ylim = c(0,700000), 
         new.window = TRUE, show.grid = FALSE, show.axis = FALSE)
BRCmap::plotUK_gr_cats(gridref = reformat_gr(spp_vis_crabro_source$site, prec_out = 10000, 
                                             precision = NULL, pad_gr = FALSE), 
                       att = spp_vis_crabro_source$source, 
                       att_col = (colorblind_pal()(3)), 
                       border = FALSE, legend= FALSE)
legend("topright", legend = c("BWARS", "NHM", "NHM+BWARS"),
       fill = (colorblind_pal()(3)),
       title = "Source")
dev.off()
