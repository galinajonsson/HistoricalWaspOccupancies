# Produce figure for DIC

# Load readRDS_multi function
source("./analyses/function-readRDS_multi.R")
# Load all model files
readRDS_multi("./outputs/modelOutputs")

###################################### Vulgaris 
# Make a list of all models' BUGSotput (where DIC is given) called cand.set
cand.set <- list(results_1kmgrid_date_year_vv$BUGSoutput, results_2kmgrid_date_year_vv$BUGSoutput, results_5kmgrid_date_year_vv$BUGSoutput, results_10kmgrid_date_year_vv$BUGSoutput, results_1kmgrid_date_5years_vv$BUGSoutput, results_2kmgrid_date_5years_vv$BUGSoutput, results_5kmgrid_date_5years_vv$BUGSoutput, results_10kmgrid_date_5years_vv$BUGSoutput, results_1kmgrid_date_10years_vv$BUGSoutput, results_2kmgrid_date_10years_vv$BUGSoutput, results_5kmgrid_date_10years_vv$BUGSoutput, results_10kmgrid_date_10years_vv$BUGSoutput)

# Run function that gives DIC, pD, Deviance etc for each model and give models useful names 
require(AICcmodavg)
DICResults_Vvulgaris <- data.frame(dictab(cand.set, modnames = c("1kmgrid_year_vv", "2kmgrid_year_vv", "5kmgrid_year_vv", "10kmgrid_year_vv", "1kmgrid_5years_vv", "2kmgrid_5years_vv", "5kmgrid_5years_vv", "10kmgrid_5years_vv", "1kmgrid_10years_vv", "2kmgrid_10years_vv", "5kmgrid_10years_vv", "10kmgrid_10years_vv"), sort = TRUE))

# Add informative columns 
DICResults_Vvulgaris$Modnames <- as.character(DICResults_Vvulgaris$Modnames)
DICResults_Vvulgaris$spatialRes <- sub("[g][r].*", "", as.character(DICResults_Vvulgaris$Modnames))
DICResults_Vvulgaris$closurePer <- sub("[[:digit:]].*[i][d][_]", "", as.character(DICResults_Vvulgaris$Modnames))
DICResults_Vvulgaris$closurePer <- sub("[_][v][v]", "", as.character(DICResults_Vvulgaris$closurePer))
DICResults_Vvulgaris$species <- "Vespula vulgaris"


###################################### Vespula germanica
# Make a list of models called cand.set
cand.set <- list(results_1kmgrid_date_5years_vg$BUGSoutput, results_2kmgrid_date_5years_vg$BUGSoutput, results_5kmgrid_date_5years_vg$BUGSoutput, results_10kmgrid_date_5years_vg$BUGSoutput, results_1kmgrid_date_10years_vg$BUGSoutput, results_2kmgrid_date_10years_vg$BUGSoutput, results_5kmgrid_date_10years_vg$BUGSoutput, results_10kmgrid_date_10years_vg$BUGSoutput)

# Run function and give models useful names 
require(AICcmodavg)
DICResults_Vgermanica <- data.frame(dictab(cand.set, modnames = c("1kmgrid_5years_vg", "2kmgrid_5years_vg", "5kmgrid_5years_vg", "10kmgrid_5years_vg", "1kmgrid_10years_vg", "2kmgrid_10years_vg", "5kmgrid_10years_vg", "10kmgrid_10years_vg"), sort = TRUE))

# Add informative columns 
DICResults_Vgermanica$Modnames <- as.character(DICResults_Vgermanica$Modnames)
DICResults_Vgermanica$spatialRes <- sub("[g][r].*", "", as.character(DICResults_Vgermanica$Modnames))
DICResults_Vgermanica$closurePer <- sub("[[:digit:]].*[i][d][_]", "", as.character(DICResults_Vgermanica$Modnames))
DICResults_Vgermanica$closurePer <- sub("[_][v][g]", "", as.character(DICResults_Vgermanica$closurePer))
DICResults_Vgermanica$species <- "Vespula germanica"



###################################### Vespa crabro
# Make a list of models called cand.set
cand.set <- list(results_1kmgrid_date_year_vc$BUGSoutput, results_2kmgrid_date_year_vc$BUGSoutput, results_5kmgrid_date_year_vc$BUGSoutput, results_10kmgrid_date_year_vc$BUGSoutput, results_1kmgrid_date_5years_vc$BUGSoutput, results_2kmgrid_date_5years_vc$BUGSoutput, results_5kmgrid_date_5years_vc$BUGSoutput, results_10kmgrid_date_5years_vc$BUGSoutput, results_1kmgrid_date_10years_vc$BUGSoutput, results_2kmgrid_date_10years_vc$BUGSoutput, results_5kmgrid_date_10years_vc$BUGSoutput, results_10kmgrid_date_10years_vc$BUGSoutput)

# Run function and give models useful names 
require(AICcmodavg)
DICResults_Vcrabro <- data.frame(dictab(cand.set, modnames = c("1kmgrid_year_vc", "2kmgrid_year_vc", "5kmgrid_year_vc", "10kmgrid_year_vc", "1kmgrid_5years_vc", "2kmgrid_5years_vc", "5kmgrid_5years_vc", "10kmgrid_5years_vc", "1kmgrid_10years_vc", "2kmgrid_10years_vc", "5kmgrid_10years_vc", "10kmgrid_10years_vc"), sort = TRUE))

# Add informative columns 
DICResults_Vcrabro$Modnames <- as.character(DICResults_Vcrabro$Modnames)
DICResults_Vcrabro$spatialRes <- sub("[g][r].*", "", as.character(DICResults_Vcrabro$Modnames))
DICResults_Vcrabro$closurePer <- sub("[[:digit:]].*[i][d][_]", "", as.character(DICResults_Vcrabro$Modnames))
DICResults_Vcrabro$closurePer <- sub("[_][v][c]", "", as.character(DICResults_Vcrabro$closurePer))
DICResults_Vcrabro$species <- "Vespa crabro"

# Combine the three species DIC results
DICResults_all <- rbind(DICResults_Vvulgaris, DICResults_Vgermanica)
DICResults_all <- rbind(DICResults_all, DICResults_Vcrabro)

require(plyr)
require(ggplot2)
DICResults_all$spatialRes <- revalue(DICResults_all$spatialRes, c("1km"="1x1 km", "2km"="2x2 km", "5km"="5x5 km", "10km"="10x10 km"))
DICResults_all$spatialRes = factor(DICResults_all$spatialRes, levels=c('1x1 km','2x2 km','5x5 km','10x10 km'))
DICResults_all$closurePer <- revalue(DICResults_all$closurePer, c("year"="1 year", "5years"="5 years", "10years"="10 years"))
DICResults_all$closurePer = factor(DICResults_all$closurePer, levels=c('1 year','5 years','10 years'))
names(DICResults_all)[names(DICResults_all) == "species"] <- "Species"
DICResults_all$Species <- as.factor(DICResults_all$Species)
DICResults_all$Species <- revalue(DICResults_all$Species, c("Vespa crabro"="V. crabro", "Vespula germanica"="V. germanica", "Vespula vulgaris"="V. vulgaris"))
DICResults_all$Species = factor(DICResults_all$Species, levels=c("V. vulgaris", "V. germanica", "V. crabro"))

DIC_fig <- ggplot(data = DICResults_all , aes(closurePer, DIC, color=Species)) + 
  geom_point(aes(shape = Species)) + facet_grid( Species ~ spatialRes, scales = "free_y") + 
  scale_color_manual(values=viridis(3)) +
  theme_bw(base_size = 10, ) + xlab("Temporal resolution") + ylab(" \n DIC") +
  theme(panel.grid.major = element_blank(),
        panel.grid.minor = element_blank()) +
  theme(legend.text = element_text(face = "italic")) + 
  theme(axis.text.x = element_text(angle = 90, hjust = 1)) +
  theme(strip.text.y = element_text(face = "italic")) + 
  theme(legend.key.size = unit(0.8, 'lines'))

require("cowplot")
DIC_fig <-ggdraw() + draw_plot(DIC_fig, x = 0, y = 0, width = 1, height = 0.9) +
  draw_plot_label(label = c("(a)", "(b)", "(c)"), size = 10,
                  x = c(0, 0, 0), y = c(0.83, 0.61, 0.40))

ggsave(filename = "Figure_6.pdf", plot = DIC_fig, width = 120, height = 90, 
       dpi = 600, units = "mm", device='pdf', path = "./figs")
