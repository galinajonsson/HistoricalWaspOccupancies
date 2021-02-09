require("dplyr")
require("ggplot2")
require("gridExtra")
require("grid")
require("lattice")
require("cowplot")
require("ggtext")
#devtools::install_github("clauswilke/ggtext")
require("ggtext")
############################ One Year VV ############################

results_10kmgrid_date_year_vv <- readRDS("./outputs/modelOutputs/results_10kmgrid_date_year_vv.rds")

# gets summary output from the BUGS files 
main = results_10kmgrid_date_year_vv$SPP_NAME
reg_agg =''
spp_data <- as.data.frame(results_10kmgrid_date_year_vv$BUGSoutput$summary)

if(reg_agg != '') reg_agg <- paste0('.r_', reg_agg)

# get rows we are interested in
### take psi.fs rows - these are the yearly proportion of occupied cells ###
spp_data$X <- row.names(spp_data)
new_data <- spp_data[grepl(paste0("^psi.fs", reg_agg, "\\["),spp_data$X),]
new_data$year <- (Year = (results_10kmgrid_date_year_vv$min_year + 1898) + as.numeric(gsub(paste0("psi.fs", reg_agg), "", gsub("\\[|\\]","", row.names(new_data)))))

# rename columns, otherwise ggplot doesn't work properly    
names(new_data) <- gsub("2.5%","quant_025", names(new_data))
names(new_data) <- gsub("97.5%","quant_975", names(new_data))

new_data$species <- as.factor("Common<br />wasp") # <br />(*V. vulgaris*)")

############################ One Year VG ############################

results_5kmgrid_date_year_vg <- readRDS("./outputs/modelOutputs/results_5kmgrid_date_year_vg.rds")

# gets summary output from the BUGS files 
spp_data2 <- as.data.frame(results_5kmgrid_date_year_vg$BUGSoutput$summary)

if(reg_agg != '') reg_agg <- paste0('.r_', reg_agg)

# get rows we are interested in
### take psi.fs rows - these are the yearly proportion of occupied cells ###
spp_data2$X <- row.names(spp_data2)
new_data2 <- spp_data2[grepl(paste0("^psi.fs", reg_agg, "\\["),spp_data2$X),]
new_data2$year <- (Year = (results_5kmgrid_date_year_vg$min_year + 1898) + as.numeric(gsub(paste0("psi.fs", reg_agg), "", gsub("\\[|\\]","", row.names(new_data2)))))

# rename columns, otherwise ggplot doesn't work properly    
names(new_data2) <- gsub("2.5%","quant_025", names(new_data2))
names(new_data2) <- gsub("97.5%","quant_975", names(new_data2))


new_data2$species <- as.factor("German<br />wasp") # <br />(*V. germanica*)")

############################ One Year VC ############################

results_10kmgrid_date_year_vc <- readRDS("./outputs/modelOutputs/results_10kmgrid_date_year_vc.rds")

# gets summary output from the BUGS files 
spp_data3 <- as.data.frame(results_10kmgrid_date_year_vc$BUGSoutput$summary)

if(reg_agg != '') reg_agg <- paste0('.r_', reg_agg)

# get rows we are interested in
### take psi.fs rows - these are the yearly proportion of occupied cells ###
spp_data3$X <- row.names(spp_data2)
new_data3 <- spp_data3[grepl(paste0("^psi.fs", reg_agg, "\\["),spp_data3$X),]
new_data3$year <- (Year = (results_10kmgrid_date_year_vc$min_year + 1898) + as.numeric(gsub(paste0("psi.fs", reg_agg), "", gsub("\\[|\\]","", row.names(new_data3)))))

# rename columns, otherwise ggplot doesn't work properly    
names(new_data3) <- gsub("2.5%","quant_025", names(new_data3))
names(new_data3) <- gsub("97.5%","quant_975", names(new_data3))

new_data3$species <- as.factor("European<br />hornet") # <br />(*V. crabro*)")



datat <- rbind(new_data, new_data2, new_data3)

############################ Plot ############################
p <- ggplot(datat, aes(x = year, y= mean)) + 
  theme_classic() +
  geom_ribbon(data=datat, aes(ymin = quant_025, ymax = quant_975, fill = species),
              alpha = 0.4) +
  geom_line(data=datat, aes(x=year, y = mean,  colour = species, linetype=species),
            size = 0.8) +
  labs(y = "Occupancy") +
  #labs(x="Year") +
  scale_y_continuous(breaks=seq(0, 1, 1), expand =  c(0, 0.019)) +
  scale_x_continuous(breaks=seq(1900, 2020,40), expand = expansion(mult = c(0, 0.1))) +
  #geom_text(aes(x=1900, label="Stretch it")) + #, vjust=-1)
  theme(text = element_text(size=11, colour = "black"),
        axis.title.x=element_blank(),
        axis.text.x=element_text(size=11, colour = "black"),
        axis.title.y=element_text(hjust=0.5, vjust = 1),
        axis.text.y = element_blank()) +
  scale_fill_manual("", values = c("#00AFBB", "#999999", "#E69F00")) +
  scale_linetype_manual("", values=c("solid", "dashed", "dotdash")) +
  scale_color_manual("", values = c("#00AFBB", "#999999", "#E69F00")) +
  theme(legend.text=element_text(size=9)) + 
        theme(legend.text = element_markdown(),
              legend.position="bottom") +
  theme(plot.margin=grid::unit(c(0.5,2,0,0.5), "mm")) +
  guides(fill = guide_legend(label.position = "bottom", 
                             keywidth = 1, keyheight = 1,
                             label.vjust = 0.5, label.hjust =0.5)) +
  theme(legend.margin=margin(0,0,0,0),
        legend.box.margin=margin(-7,18,1,0))
  

ggsave(filename = "GraphicalAbstract_plot.tiff", plot = p, width = 5, height = 6, 
       dpi = 600, units = "cm", device='tiff', path = "./figs")
