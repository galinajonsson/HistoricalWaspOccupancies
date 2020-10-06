# Load required packages
require(dplyr)
require(plyr)
require(ggplot2)
require(viridis)

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

# Subset each species' records into dataframes and specify species identity
spp_vis_crabro <- subset(spp_vis, Vespa.crabro == "TRUE")
spp_vis_crabro$species <- c("Vespa crabro")
spp_vis_germanica <- subset(spp_vis, Vespula.germanica == "TRUE")
spp_vis_germanica$species <- c("Vespula germanica")
spp_vis_vulgaris <- subset(spp_vis, Vespula.vulgaris == "TRUE")
spp_vis_vulgaris$species <- c("Vespula vulgaris")

# row bind each subsetted species' dataframe with the original spp_vis dataframe
spp_vis <- rbind(spp_vis_crabro, spp_vis_germanica)
spp_vis <- rbind(spp_vis, spp_vis_vulgaris)

# Duplicate spp_vis and call tep
temp <- spp_vis
# Rename all species names to "Total"
temp$species <- "Total"
temp <- droplevels(temp)
# row bind the temp data frame with the spp_vis dataframe
spp_vis <- rbind(spp_vis, temp)

# Make L column a source column
spp_vis$L <- as.factor(spp_vis$L)
spp_vis$L <- revalue(spp_vis$L, c("1"="BWARS", "2"="BWARS", "3"="BWARS", "10"="NHM"))
colnames(spp_vis)[colnames(spp_vis)=="L"] <- "Source"

# Rename species column to make spp. names in italics
spp_vis$species <- revalue(spp_vis$species, c("Vespa crabro"="italic('V. crabro')", 
                                              "Vespula germanica"="italic('V. germanica')", 
                                              "Vespula vulgaris"="italic('V. vulgaris')", 
                                              "Total"="textstyle('Total')"))
# Order species and total plotting
spp_vis$speciesOrdered = factor(spp_vis$species, levels=c("italic('V. vulgaris')",
                                                          "italic('V. germanica')", 
                                                          "italic('V. crabro')", 
                                                          "textstyle('Total')" , "NA"))

# first year is formatted to 1 so add 1899 to each year as 1900 is the first year
spp_vis$year <- spp_vis$TP+1899

# Plot
p <- ggplot(spp_vis, aes(x=year, fill=Source, color=Source)) + 
  scale_fill_manual(values = c("#999999", viridis(1))) +
  scale_color_manual(values = c("#999999", viridis(1))) +
  facet_grid(~ speciesOrdered, labeller=label_parsed) + # facet grid by species
  geom_bar(position="identity", alpha=0.5) + labs(y="Number of Records", x = "Year") +
  theme_bw() +
  theme(panel.grid.major = element_blank(),
        panel.grid.minor = element_blank()) +
  scale_y_sqrt() +
  theme(text = element_text(size=18),
        axis.text.x = element_text(angle=90, hjust=1))

ggsave(filename = "Figure_2.pdf", plot = p, width = 180, height = 100, 
       dpi = 600, units = "mm", device='pdf', path = "./figs")