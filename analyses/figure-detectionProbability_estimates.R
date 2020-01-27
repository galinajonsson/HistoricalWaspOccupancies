# Load packages
require(ggplot2)
require(cowplot)
require(dplyr)
require(grid)
require(gridExtra)
require(boot)

# Load readRDS_multi function
source("./analyses/function-readRDS_multi.R")
# Load all model files
readRDS_multi("./outputs/modelOutputs")

# First, I will create three functions per species that plots occupancy trends for all four
# spatial resolutions on the same plot for each of 1 year, 5 year and 10 year models

############################ V. vulgaris One Year plot function ############################
# This function plots all occupancy estimates at 1x1, 2x2, 5x5 and 10x10 km resolutions
plot1yr_occDet_vv <- function(mod1, mod2, mod3, mod4){
  
  ########## 1x1km
  # gets summary output from the BUGS files 
  main = mod1$SPP_NAME
  reg_agg =''
  spp_data <- as.data.frame(mod1$BUGSoutput$summary)
  
  if(reg_agg != '') reg_agg <- paste0('.r_', reg_agg)
  
  # get rows we are interested in
  ### take psi.fs rows - these are the yearly proportion of occupied cells ###
  spp_data$X <- row.names(spp_data)
  new_data <- spp_data[grepl(paste0("^alpha.p", reg_agg, "\\["),spp_data$X),]
  new_data$year <- (Year = (mod1$min_year + 1898) + 
                      as.numeric(gsub(paste0("^alpha.p", reg_agg), 
                                      "", gsub("\\[|\\]","", row.names(new_data)))))
  
  # rename columns, otherwise ggplot doesn't work properly    
  names(new_data) <- gsub("2.5%","quant_025", names(new_data))
  names(new_data) <- gsub("97.5%","quant_975", names(new_data))   
  new_data$mean <- inv.logit(new_data$mean)   
  new_data$quant_025 <- inv.logit(new_data$quant_025)   
  new_data$quant_975 <- inv.logit(new_data$quant_975)
  
  
  ########## 2x2km
  # gets summary output from the BUGS files 
  spp_data2 <- as.data.frame(mod2$BUGSoutput$summary)
  
  if(reg_agg != '') reg_agg <- paste0('.r_', reg_agg)
  
  # get rows we are interested in
  ### take psi.fs rows - these are the yearly proportion of occupied cells ###
  spp_data2$X <- row.names(spp_data2)
  new_data2 <- spp_data2[grepl(paste0("^alpha.p", reg_agg, "\\["),spp_data2$X),]
  new_data2$year <- (Year = (mod2$min_year + 1898) + 
                       as.numeric(gsub(paste0("^alpha.p", reg_agg), "", 
                                       gsub("\\[|\\]","", row.names(new_data2)))))
  
  # rename columns, otherwise ggplot doesn't work properly    
  names(new_data2) <- gsub("2.5%","quant_025", names(new_data2))
  names(new_data2) <- gsub("97.5%","quant_975", names(new_data2))
  new_data2$mean <- inv.logit(new_data2$mean)   
  new_data2$quant_025 <- inv.logit(new_data2$quant_025)   
  new_data2$quant_975 <- inv.logit(new_data2$quant_975)
  
  
  ########## 5x5km
  # gets summary output from the BUGS files 
  spp_data3 <- as.data.frame(mod3$BUGSoutput$summary)
  
  if(reg_agg != '') reg_agg <- paste0('.r_', reg_agg)
  
  # get rows we are interested in
  ### take psi.fs rows - these are the yearly proportion of occupied cells ###
  spp_data3$X <- row.names(spp_data3)
  new_data3 <- spp_data3[grepl(paste0("^alpha.p", reg_agg, "\\["),spp_data3$X),]
  new_data3$year <- (Year = (mod3$min_year + 1898) + 
                       as.numeric(gsub(paste0("^alpha.p", reg_agg), "", 
                                       gsub("\\[|\\]","", row.names(new_data3)))))
  
  # rename columns, otherwise ggplot doesn't work properly    
  names(new_data3) <- gsub("2.5%","quant_025", names(new_data3))
  names(new_data3) <- gsub("97.5%","quant_975", names(new_data3))
  new_data3$mean <- inv.logit(new_data3$mean)   
  new_data3$quant_025 <- inv.logit(new_data3$quant_025)   
  new_data3$quant_975 <- inv.logit(new_data3$quant_975)
  
  
  ########## 10x10km
  # gets summary output from the BUGS files 
  spp_data4 <- as.data.frame(mod4$BUGSoutput$summary)
  
  if(reg_agg != '') reg_agg <- paste0('.r_', reg_agg)
  
  # get rows we are interested in
  ### take psi.fs rows - these are the yearly proportion of occupied cells ###
  spp_data4$X <- row.names(spp_data4)
  new_data4 <- spp_data4[grepl(paste0("^alpha.p", reg_agg, "\\["),spp_data4$X),]
  new_data4$year <- (Year = (mod4$min_year + 1898) + 
                       as.numeric(gsub(paste0("^alpha.p", reg_agg), "", 
                                       gsub("\\[|\\]","", row.names(new_data4)))))
  
  # rename columns, otherwise ggplot doesn't work properly    
  names(new_data4) <- gsub("2.5%","quant_025", names(new_data4))
  names(new_data4) <- gsub("97.5%","quant_975", names(new_data4))
  new_data4$mean <- inv.logit(new_data4$mean)   
  new_data4$quant_025 <- inv.logit(new_data4$quant_025)   
  new_data4$quant_975 <- inv.logit(new_data4$quant_975)
  
  
  ########## Plot
  
  p <- ggplot(new_data, aes_string(x = "year", y = "mean")) + 
    theme_bw() +
    geom_ribbon(data = new_data,
                aes_string(group = 1, ymin = "quant_025", ymax = "quant_975"),
                alpha = 0.2, fill = "#999999") +
    geom_ribbon(data = new_data2,
                aes_string(group = 1, ymin = "quant_025", ymax = "quant_975"),
                alpha = 0.2, fill="#E69F00") +
    geom_ribbon(data = new_data3,
                aes_string(group = 1, ymin = "quant_025", ymax = "quant_975"),
                alpha = 0.2, fill = "#56B4E9") +
    geom_ribbon(data = new_data4,
                aes_string(group = 1, ymin = "quant_025", ymax = "quant_975"),
                alpha = 0.2, fill = "#009E73") +
    geom_line(data = new_data, aes(col = "#999999"), size=1) +
    ylab("Occupancy") +
    theme(axis.title.x=element_blank(),
          axis.text.x=element_blank()) +
    theme(axis.title.y=element_blank()) +
    theme(text = element_text(size=18)) +
    scale_y_continuous(limits = c(0, 1)) +
    scale_x_continuous(breaks=seq(1900, 2020,20)) +
    geom_line(data = new_data2, aes(col = "#E69F00"), size=1) +
    geom_line(data = new_data3, aes(col = "#56B4E9"), size=1) +
    geom_line(data = new_data4, aes(col = "#009E73"), size=1) +
    scale_colour_manual(name = 'Spatial \nresolution', 
                        values =c("#999999"="#999999","#E69F00"="#E69F00", 
                                  "#56B4E9"="#56B4E9", "#009E73"="#009E73"), 
                        labels = c('10 km','5 km','1 km', '2 km')) + 
    theme(legend.position = "none") +
    theme(text = element_text(size=18))
  
  return(p)
}


############################ V. vulgaris Five Years plot function ############################
# This function plots all occupancy estimates at 1x1, 2x2, 5x5 and 10x10 km resolutions
plot5yr_occDet_vv <- function(mod1, mod2, mod3, mod4){
  
  
  ########## 1x1km
  # gets summary output from the BUGS files 
  main = mod1$SPP_NAME
  reg_agg =''
  spp_data <- as.data.frame(mod1$BUGSoutput$summary)
  
  if(reg_agg != '') reg_agg <- paste0('.r_', reg_agg)
  
  # get rows we are interested in
  ### take psi.fs rows - these are the yearly proportion of occupied cells ###
  spp_data$X <- row.names(spp_data)
  new_data <- spp_data[grepl(paste0("^alpha.p", reg_agg, "\\["),spp_data$X),]
  new_data$year <- (Year = (mod1$min_year + 1896) + 
                      (as.numeric(gsub(paste0("^alpha.p", reg_agg), "",
                                       gsub("\\[|\\]","", row.names(new_data)))))*5)
  
  # rename columns, otherwise ggplot doesn't work properly    
  names(new_data) <- gsub("2.5%","quant_025", names(new_data))
  names(new_data) <- gsub("97.5%","quant_975", names(new_data))
  new_data$mean <- inv.logit(new_data$mean)   
  new_data$quant_025 <- inv.logit(new_data$quant_025)   
  new_data$quant_975 <- inv.logit(new_data$quant_975)
  
  
  ########## 2x2km
  # gets summary output from the BUGS files 
  spp_data2 <- as.data.frame(mod2$BUGSoutput$summary)
  
  if(reg_agg != '') reg_agg <- paste0('.r_', reg_agg)
  
  # get rows we are interested in
  ### take psi.fs rows - these are the yearly proportion of occupied cells ###
  spp_data2$X <- row.names(spp_data2)
  new_data2 <- spp_data2[grepl(paste0("^alpha.p", reg_agg, "\\["),spp_data2$X),]
  new_data2$year <- (Year = (mod2$min_year + 1896) + 
                       (as.numeric(gsub(paste0("^alpha.p", reg_agg), "", 
                                        gsub("\\[|\\]","", row.names(new_data2)))))*5)
  
  
  # rename columns, otherwise ggplot doesn't work properly    
  names(new_data2) <- gsub("2.5%","quant_025", names(new_data2))
  names(new_data2) <- gsub("97.5%","quant_975", names(new_data2))
  new_data2$mean <- inv.logit(new_data2$mean)   
  new_data2$quant_025 <- inv.logit(new_data2$quant_025)   
  new_data2$quant_975 <- inv.logit(new_data2$quant_975)
  
  
  ########## 5x5km
  # gets summary output from the BUGS files 
  spp_data3 <- as.data.frame(mod3$BUGSoutput$summary)
  
  if(reg_agg != '') reg_agg <- paste0('.r_', reg_agg)
  
  # get rows we are interested in
  ### take psi.fs rows - these are the yearly proportion of occupied cells ###
  spp_data3$X <- row.names(spp_data3)
  new_data3 <- spp_data3[grepl(paste0("^alpha.p", reg_agg, "\\["),spp_data3$X),]
  new_data3$year <- (Year = (mod3$min_year + 1896) + 
                       (as.numeric(gsub(paste0("^alpha.p", reg_agg), "", 
                                        gsub("\\[|\\]","", row.names(new_data3)))))*5)
  
  # rename columns, otherwise ggplot doesn't work properly    
  names(new_data3) <- gsub("2.5%","quant_025", names(new_data3))
  names(new_data3) <- gsub("97.5%","quant_975", names(new_data3))
  new_data3$mean <- inv.logit(new_data3$mean)   
  new_data3$quant_025 <- inv.logit(new_data3$quant_025)   
  new_data3$quant_975 <- inv.logit(new_data3$quant_975)
  
  
  ########## 10x10km
  # gets summary output from the BUGS files 
  spp_data4 <- as.data.frame(mod4$BUGSoutput$summary)
  
  if(reg_agg != '') reg_agg <- paste0('.r_', reg_agg)
  
  # get rows we are interested in
  ### take psi.fs rows - these are the yearly proportion of occupied cells ###
  spp_data4$X <- row.names(spp_data4)
  new_data4 <- spp_data4[grepl(paste0("^alpha.p", reg_agg, "\\["),spp_data4$X),]
  new_data4$year <- (Year = (mod4$min_year + 1896) + 
                       (as.numeric(gsub(paste0("^alpha.p", reg_agg), "", 
                                        gsub("\\[|\\]","", row.names(new_data4)))))*5)
  # rename columns, otherwise ggplot doesn't work properly    
  names(new_data4) <- gsub("2.5%","quant_025", names(new_data4))
  names(new_data4) <- gsub("97.5%","quant_975", names(new_data4))
  new_data4$mean <- inv.logit(new_data4$mean)   
  new_data4$quant_025 <- inv.logit(new_data4$quant_025)   
  new_data4$quant_975 <- inv.logit(new_data4$quant_975)
  
  
  ########## Plot
  p <- ggplot(new_data, aes_string(x = "year", y = "mean")) + 
    theme_bw() +
    geom_ribbon(data = new_data,
                aes_string(group = 1, ymin = "quant_025", ymax = "quant_975"),
                alpha = 0.2, fill = "#999999") +
    geom_ribbon(data = new_data2,
                aes_string(group = 1, ymin = "quant_025", ymax = "quant_975"),
                alpha = 0.2, fill="#E69F00") +
    geom_ribbon(data = new_data3,
                aes_string(group = 1, ymin = "quant_025", ymax = "quant_975"),
                alpha = 0.2, fill = "#56B4E9") +
    geom_ribbon(data = new_data4,
                aes_string(group = 1, ymin = "quant_025", ymax = "quant_975"),
                alpha = 0.2, fill = "#009E73") +
    geom_line(data = new_data, aes(col = "#999999"), size=1) +
    theme(axis.title.x=element_blank(),
          axis.text.x=element_blank()) +
    theme(axis.title.y=element_blank(),
          axis.text.y=element_blank()) +
    scale_y_continuous(limits = c(0, 1)) +
    scale_x_continuous(breaks=seq(1900, 2020,20)) +
    geom_line(data = new_data2, aes(col = "#E69F00"), size=1) +
    geom_line(data = new_data3, aes(col = "#56B4E9"), size=1) +
    geom_line(data = new_data4, aes(col = "#009E73"), size=1) +
    scale_colour_manual(name = 'Spatial resolution', 
                        values =c("#999999"="#999999","#E69F00"="#E69F00", 
                                  "#56B4E9"="#56B4E9", "#009E73"="#009E73"), 
                        labels = c('10 km','5 km','1 km', '2 km')) +
    theme(legend.position = "none") +
    theme(text = element_text(size=18))
  
  return(p)
}


############################ V. vulgaris Ten Year plot function ############################
# This function plots all occupancy estimates at 1x1, 2x2, 5x5 and 10x10 km resolutions
plot10yr_occDet_vv <- function(mod1, mod2, mod3, mod4){
  
  ########## 1x1km
  # gets summary output from the BUGS files 
  main = mod1$SPP_NAME
  reg_agg =''
  spp_data <- as.data.frame(mod1$BUGSoutput$summary)
  
  if(reg_agg != '') reg_agg <- paste0('.r_', reg_agg)
  
  # get rows we are interested in
  ### take psi.fs rows - these are the yearly proportion of occupied cells ###
  spp_data$X <- row.names(spp_data)
  new_data <- spp_data[grepl(paste0("^alpha.p", reg_agg, "\\["),spp_data$X),]
  new_data$year <- (Year = (mod1$min_year + 1894) + 
                      (as.numeric(gsub(paste0("^alpha.p", reg_agg), "", 
                                       gsub("\\[|\\]","", row.names(new_data)))))*10)
  # rename columns, otherwise ggplot doesn't work properly    
  names(new_data) <- gsub("2.5%","quant_025", names(new_data))
  names(new_data) <- gsub("97.5%","quant_975", names(new_data))
  new_data$mean <- inv.logit(new_data$mean)   
  new_data$quant_025 <- inv.logit(new_data$quant_025)   
  new_data$quant_975 <- inv.logit(new_data$quant_975)
  
  
  ########## 2x2km
  # gets summary output from the BUGS files 
  spp_data2 <- as.data.frame(mod2$BUGSoutput$summary)
  if(reg_agg != '') reg_agg <- paste0('.r_', reg_agg)
  # get rows we are interested in
  ### take psi.fs rows - these are the yearly proportion of occupied cells ###
  spp_data2$X <- row.names(spp_data2)
  new_data2 <- spp_data2[grepl(paste0("^alpha.p", reg_agg, "\\["),spp_data2$X),]
  new_data2$year <- (Year = (mod2$min_year + 1894) + 
                       (as.numeric(gsub(paste0("^alpha.p", reg_agg), "", 
                                        gsub("\\[|\\]","", row.names(new_data2)))))*10)
  # rename columns, otherwise ggplot doesn't work properly    
  names(new_data2) <- gsub("2.5%","quant_025", names(new_data2))
  names(new_data2) <- gsub("97.5%","quant_975", names(new_data2))
  new_data2$mean <- inv.logit(new_data2$mean)   
  new_data2$quant_025 <- inv.logit(new_data2$quant_025)   
  new_data2$quant_975 <- inv.logit(new_data2$quant_975)
  
  
  ########## 5x5km
  # gets summary output from the BUGS files 
  spp_data3 <- as.data.frame(mod3$BUGSoutput$summary)
  if(reg_agg != '') reg_agg <- paste0('.r_', reg_agg)
  # get rows we are interested in
  ### take psi.fs rows - these are the yearly proportion of occupied cells ###
  spp_data3$X <- row.names(spp_data3)
  new_data3 <- spp_data3[grepl(paste0("^alpha.p", reg_agg, "\\["),spp_data3$X),]
  new_data3$year <- (Year = (mod3$min_year + 1894) + 
                       (as.numeric(gsub(paste0("^alpha.p", reg_agg), "", 
                                        gsub("\\[|\\]","", row.names(new_data3)))))*10)
  # rename columns, otherwise ggplot doesn't work properly    
  names(new_data3) <- gsub("2.5%","quant_025", names(new_data3))
  names(new_data3) <- gsub("97.5%","quant_975", names(new_data3))
  new_data3$mean <- inv.logit(new_data3$mean)   
  new_data3$quant_025 <- inv.logit(new_data3$quant_025)   
  new_data3$quant_975 <- inv.logit(new_data3$quant_975)
  
  
  ########## 10x10km
  # gets summary output from the BUGS files 
  spp_data4 <- as.data.frame(mod4$BUGSoutput$summary)
  if(reg_agg != '') reg_agg <- paste0('.r_', reg_agg)
  # get rows we are interested in
  ### take psi.fs rows - these are the yearly proportion of occupied cells ###
  spp_data4$X <- row.names(spp_data4)
  new_data4 <- spp_data4[grepl(paste0("^alpha.p", reg_agg, "\\["),spp_data4$X),]
  new_data4$year <- (Year = (mod4$min_year + 1894) + 
                       (as.numeric(gsub(paste0("^alpha.p", reg_agg), "", 
                                        gsub("\\[|\\]","", row.names(new_data4)))))*10)
  # rename columns, otherwise ggplot doesn't work properly    
  names(new_data4) <- gsub("2.5%","quant_025", names(new_data4))
  names(new_data4) <- gsub("97.5%","quant_975", names(new_data4))
  new_data4$mean <- inv.logit(new_data4$mean)   
  new_data4$quant_025 <- inv.logit(new_data4$quant_025)   
  new_data4$quant_975 <- inv.logit(new_data4$quant_975)
  
  
  ########## Plot
  p <- ggplot(new_data, aes_string(x = "year", y = "mean")) + 
    theme_bw() +
    geom_ribbon(data = new_data,
                aes_string(group = 1, ymin = "quant_025", ymax = "quant_975"),
                alpha = 0.2, fill = "#999999") +
    geom_ribbon(data = new_data2,
                aes_string(group = 1, ymin = "quant_025", ymax = "quant_975"),
                alpha = 0.2, fill="#E69F00") +
    geom_ribbon(data = new_data3,
                aes_string(group = 1, ymin = "quant_025", ymax = "quant_975"),
                alpha = 0.2, fill = "#56B4E9") +
    geom_ribbon(data = new_data4,
                aes_string(group = 1, ymin = "quant_025", ymax = "quant_975"),
                alpha = 0.2, fill = "#009E73") +
    geom_line(data = new_data, aes(col = "#999999"), size=1) +
    theme(axis.title.x=element_blank(),
          axis.text.x=element_blank()) +
    theme(axis.title.y=element_blank(),
          axis.text.y=element_blank()) +
    scale_y_continuous(limits = c(0, 1)) +
    scale_x_continuous(breaks=seq(1900, 2020,20)) +
    geom_line(data = new_data2, aes(col = "#E69F00"), size=1) +
    geom_line(data = new_data3, aes(col = "#56B4E9"), size=1) +
    geom_line(data = new_data4, aes(col = "#009E73"), size=1) +
    scale_colour_manual(name = 'Spatial resolution', 
                        values =c("#999999"="#999999","#E69F00"="#E69F00", 
                                  "#56B4E9"="#56B4E9", "#009E73"="#009E73"), 
                        labels = c('10 km','5 km','1 km', '2 km'))  +
    theme(legend.position = "none") +
    theme(text = element_text(size=18))
  return(p)
}









############################ V. germanica One Year plot function ############################
# This function plots all occupancy estimates at  2x2, 5x5 and 10x10 km resolutions
plot1yr_occDet_vg <- function(mod1, mod2, mod3, mod4){
  
  ########## 1x1km
  #gets summary output from the BUGS files 
  main = mod1$SPP_NAME
  reg_agg =''
  spp_data <- as.data.frame(mod1$BUGSoutput$summary)
  if(reg_agg != '') reg_agg <- paste0('.r_', reg_agg)
  # get rows we are interested in
  ### take psi.fs rows - these are the yearly proportion of occupied cells ###
  spp_data$X <- row.names(spp_data)
  new_data <- spp_data[grepl(paste0("^alpha.p", reg_agg, "\\["),spp_data$X),]
  new_data$year <- (Year = (mod1$min_year + 1898) + 
                      as.numeric(gsub(paste0("^alpha.p", reg_agg), 
                                      "", gsub("\\[|\\]","", row.names(new_data)))))
  # rename columns, otherwise ggplot doesn't work properly    
  names(new_data) <- gsub("2.5%","quant_025", names(new_data))
  names(new_data) <- gsub("97.5%","quant_975", names(new_data))
  new_data$mean <- inv.logit(new_data$mean)   
  new_data$quant_025 <- inv.logit(new_data$quant_025)   
  new_data$quant_975 <- inv.logit(new_data$quant_975)
  
  
  ########## 2x2km
  # gets summary output from the BUGS files
  reg_agg =''
  spp_data2 <- as.data.frame(mod2$BUGSoutput$summary)
  if(reg_agg != '') reg_agg <- paste0('.r_', reg_agg)
  # get rows we are interested in
  ### take psi.fs rows - these are the yearly proportion of occupied cells ###
  spp_data2$X <- row.names(spp_data2)
  new_data2 <- spp_data2[grepl(paste0("^alpha.p", reg_agg, "\\["),spp_data2$X),]
  new_data2$year <- (Year = (mod2$min_year + 1898) + 
                       as.numeric(gsub(paste0("^alpha.p", reg_agg), "", 
                                       gsub("\\[|\\]","", row.names(new_data2)))))
  # rename columns, otherwise ggplot doesn't work properly    
  names(new_data2) <- gsub("2.5%","quant_025", names(new_data2))
  names(new_data2) <- gsub("97.5%","quant_975", names(new_data2))
  new_data2$mean <- inv.logit(new_data2$mean)   
  new_data2$quant_025 <- inv.logit(new_data2$quant_025)   
  new_data2$quant_975 <- inv.logit(new_data2$quant_975)
  
  
  ########## 5x5km
  # gets summary output from the BUGS files 
  spp_data3 <- as.data.frame(mod3$BUGSoutput$summary)
  if(reg_agg != '') reg_agg <- paste0('.r_', reg_agg)
  # get rows we are interested in
  ### take psi.fs rows - these are the yearly proportion of occupied cells ###
  spp_data3$X <- row.names(spp_data3)
  new_data3 <- spp_data3[grepl(paste0("^alpha.p", reg_agg, "\\["),spp_data3$X),]
  new_data3$year <- (Year = (mod3$min_year + 1898) + 
                       as.numeric(gsub(paste0("^alpha.p", reg_agg), "", 
                                       gsub("\\[|\\]","", row.names(new_data3)))))
  # rename columns, otherwise ggplot doesn't work properly    
  names(new_data3) <- gsub("2.5%","quant_025", names(new_data3))
  names(new_data3) <- gsub("97.5%","quant_975", names(new_data3))
  new_data3$mean <- inv.logit(new_data3$mean)   
  new_data3$quant_025 <- inv.logit(new_data3$quant_025)   
  new_data3$quant_975 <- inv.logit(new_data3$quant_975)
  
  
  ########## 10x10km
  # gets summary output from the BUGS files 
  spp_data4 <- as.data.frame(mod4$BUGSoutput$summary)
  if(reg_agg != '') reg_agg <- paste0('.r_', reg_agg)
  # get rows we are interested in
  ### take psi.fs rows - these are the yearly proportion of occupied cells ###
  spp_data4$X <- row.names(spp_data4)
  new_data4 <- spp_data4[grepl(paste0("^alpha.p", reg_agg, "\\["),spp_data4$X),]
  new_data4$year <- (Year = (mod4$min_year + 1898) + 
                       as.numeric(gsub(paste0("^alpha.p", reg_agg), "", 
                                       gsub("\\[|\\]","", row.names(new_data4)))))
  # rename columns, otherwise ggplot doesn't work properly    
  names(new_data4) <- gsub("2.5%","quant_025", names(new_data4))
  names(new_data4) <- gsub("97.5%","quant_975", names(new_data4))
  new_data4$mean <- inv.logit(new_data4$mean)   
  new_data4$quant_025 <- inv.logit(new_data4$quant_025)   
  new_data4$quant_975 <- inv.logit(new_data4$quant_975)
  
  
  ########## Plot
  p <- ggplot(new_data, aes_string(x = "year", y = "mean")) + 
    theme_bw() +
    geom_ribbon(data = new_data2,
                aes_string(group = 1, ymin = "quant_025", ymax = "quant_975"),
                alpha = 0.2, fill="#E69F00") +
    geom_ribbon(data = new_data3,
                aes_string(group = 1, ymin = "quant_025", ymax = "quant_975"),
                alpha = 0.2, fill = "#56B4E9") +
    geom_ribbon(data = new_data4,
                aes_string(group = 1, ymin = "quant_025", ymax = "quant_975"),
                alpha = 0.2, fill = "#009E73") +
    ylab("Occupancy") +
    theme(axis.title.x=element_blank(),
          axis.text.x=element_blank()) +
    theme(axis.title.y=element_blank()) +
    theme(text = element_text(size=18)) +
    scale_y_continuous(limits = c(0, 1)) +
    scale_x_continuous(breaks=seq(1900, 2020,20)) +
    geom_line(data = new_data2, aes(col = "#E69F00"), size=1) +
    geom_line(data = new_data3, aes(col = "#56B4E9"), size=1) +
    geom_line(data = new_data4, aes(col = "#009E73"), size=1) +
    scale_colour_manual(name = 'Spatial \nresolution', 
                        values =c("#E69F00"="#E69F00", 
                                  "#56B4E9"="#56B4E9", "#009E73"="#009E73"), 
                        labels = c('10 km','5 km','2 km')) + 
    theme(legend.position = "none") +
    theme(text = element_text(size=18))
  
  return(p)
}



############################ V. germanica Five Years plot function ############################
# This function plots all occupancy estimates at 2x2, 5x5 and 10x10 km resolutions
plot5yr_occDet_vg <- function(mod1, mod2, mod3, mod4){
  
  ########## 1x1km
  # gets summary output from the BUGS files 
  main = mod1$SPP_NAME
  reg_agg =''
  spp_data <- as.data.frame(mod1$BUGSoutput$summary)
  if(reg_agg != '') reg_agg <- paste0('.r_', reg_agg)
  # get rows we are interested in
  ### take psi.fs rows - these are the yearly proportion of occupied cells ###
  spp_data$X <- row.names(spp_data)
  new_data <- spp_data[grepl(paste0("^alpha.p", reg_agg, "\\["),spp_data$X),]
  new_data$year <- (Year = (mod1$min_year + 1896) + 
                      (as.numeric(gsub(paste0("^alpha.p", reg_agg), "",
                                       gsub("\\[|\\]","", row.names(new_data)))))*5)
  # rename columns, otherwise ggplot doesn't work properly    
  names(new_data) <- gsub("2.5%","quant_025", names(new_data))
  names(new_data) <- gsub("97.5%","quant_975", names(new_data))
  new_data$mean <- inv.logit(new_data$mean)   
  new_data$quant_025 <- inv.logit(new_data$quant_025)   
  new_data$quant_975 <- inv.logit(new_data$quant_975)
  
  
  ########## 2x2km
  # gets summary output from the BUGS files 
  spp_data2 <- as.data.frame(mod2$BUGSoutput$summary)
  if(reg_agg != '') reg_agg <- paste0('.r_', reg_agg)
  # get rows we are interested in
  ### take psi.fs rows - these are the yearly proportion of occupied cells ###
  spp_data2$X <- row.names(spp_data2)
  new_data2 <- spp_data2[grepl(paste0("^alpha.p", reg_agg, "\\["),spp_data2$X),]
  new_data2$year <- (Year = (mod2$min_year + 1896) + 
                       (as.numeric(gsub(paste0("^alpha.p", reg_agg), "", 
                                        gsub("\\[|\\]","", row.names(new_data2)))))*5)
  # rename columns, otherwise ggplot doesn't work properly    
  names(new_data2) <- gsub("2.5%","quant_025", names(new_data2))
  names(new_data2) <- gsub("97.5%","quant_975", names(new_data2))
  new_data2$mean <- inv.logit(new_data2$mean)   
  new_data2$quant_025 <- inv.logit(new_data2$quant_025)   
  new_data2$quant_975 <- inv.logit(new_data2$quant_975)
  
  
  ########## 5x5km
  # gets summary output from the BUGS files 
  spp_data3 <- as.data.frame(mod3$BUGSoutput$summary)
  if(reg_agg != '') reg_agg <- paste0('.r_', reg_agg)
  # get rows we are interested in
  ### take psi.fs rows - these are the yearly proportion of occupied cells ###
  spp_data3$X <- row.names(spp_data3)
  new_data3 <- spp_data3[grepl(paste0("^alpha.p", reg_agg, "\\["),spp_data3$X),]
  new_data3$year <- (Year = (mod3$min_year + 1896) + 
                       (as.numeric(gsub(paste0("^alpha.p", reg_agg), "", 
                                        gsub("\\[|\\]","", row.names(new_data3)))))*5)
  # rename columns, otherwise ggplot doesn't work properly    
  names(new_data3) <- gsub("2.5%","quant_025", names(new_data3))
  names(new_data3) <- gsub("97.5%","quant_975", names(new_data3))
  new_data3$mean <- inv.logit(new_data3$mean)   
  new_data3$quant_025 <- inv.logit(new_data3$quant_025)   
  new_data3$quant_975 <- inv.logit(new_data3$quant_975)
  
  
  ########## 10x10km
  # gets summary output from the BUGS files 
  spp_data4 <- as.data.frame(mod4$BUGSoutput$summary)
  if(reg_agg != '') reg_agg <- paste0('.r_', reg_agg)
  # get rows we are interested in
  ### take psi.fs rows - these are the yearly proportion of occupied cells ###
  spp_data4$X <- row.names(spp_data4)
  new_data4 <- spp_data4[grepl(paste0("^alpha.p", reg_agg, "\\["),spp_data4$X),]
  new_data4$year <- (Year = (mod4$min_year + 1896) + 
                       (as.numeric(gsub(paste0("^alpha.p", reg_agg), "", 
                                        gsub("\\[|\\]","", row.names(new_data4)))))*5)
  # rename columns, otherwise ggplot doesn't work properly    
  names(new_data4) <- gsub("2.5%","quant_025", names(new_data4))
  names(new_data4) <- gsub("97.5%","quant_975", names(new_data4))
  new_data4$mean <- inv.logit(new_data4$mean)   
  new_data4$quant_025 <- inv.logit(new_data4$quant_025)   
  new_data4$quant_975 <- inv.logit(new_data4$quant_975)
  
  
  ########## Plot
  p <- ggplot(new_data, aes_string(x = "year", y = "mean")) + 
    theme_bw() +
    geom_ribbon(data = new_data2,
                aes_string(group = 1, ymin = "quant_025", ymax = "quant_975"),
                alpha = 0.2, fill="#E69F00") +
    geom_ribbon(data = new_data3,
                aes_string(group = 1, ymin = "quant_025", ymax = "quant_975"),
                alpha = 0.2, fill = "#56B4E9") +
    geom_ribbon(data = new_data4,
                aes_string(group = 1, ymin = "quant_025", ymax = "quant_975"),
                alpha = 0.2, fill = "#009E73") +
    theme(axis.title.x=element_blank(),
          axis.text.x=element_blank()) +
    theme(axis.title.y=element_blank(),
          axis.text.y=element_blank()) +
    scale_y_continuous(limits = c(0, 1)) +
    scale_x_continuous(breaks=seq(1900, 2020,20)) +
    geom_line(data = new_data2, aes(col = "#E69F00"), size=1) +
    geom_line(data = new_data3, aes(col = "#56B4E9"), size=1) +
    geom_line(data = new_data4, aes(col = "#009E73"), size=1) +
    scale_colour_manual(name = 'Spatial resolution', 
                        values =c("#E69F00"="#E69F00", "#56B4E9"="#56B4E9", 
                                  "#009E73"="#009E73"), 
                        labels = c('10 km','5 km', '2 km')) +
    theme(legend.position = "none") +
    theme(text = element_text(size=18))
  
  return(p)
}


############################ V. germanica Ten Years plot function ############################
# This function plots all occupancy estimates at 2x2, 5x5 and 10x10 km resolutions

plot10yr_occDet_vg <- function(mod1, mod2, mod3, mod4){
  ########## 1x1km
  # gets summary output from the BUGS files 
  main = mod1$SPP_NAME
  reg_agg =''
  spp_data <- as.data.frame(mod1$BUGSoutput$summary)
  if(reg_agg != '') reg_agg <- paste0('.r_', reg_agg)
  # get rows we are interested in
  ### take psi.fs rows - these are the yearly proportion of occupied cells ###
  spp_data$X <- row.names(spp_data)
  new_data <- spp_data[grepl(paste0("^alpha.p", reg_agg, "\\["),spp_data$X),]
  new_data$year <- (Year = (mod1$min_year + 1894) + 
                      (as.numeric(gsub(paste0("^alpha.p", reg_agg), "", 
                                       gsub("\\[|\\]","", row.names(new_data)))))*10)
  # rename columns, otherwise ggplot doesn't work properly    
  names(new_data) <- gsub("2.5%","quant_025", names(new_data))
  names(new_data) <- gsub("97.5%","quant_975", names(new_data))
  new_data$mean <- inv.logit(new_data$mean)   
  new_data$quant_025 <- inv.logit(new_data$quant_025)   
  new_data$quant_975 <- inv.logit(new_data$quant_975)
  
  
  ########## 2x2km
  # gets summary output from the BUGS files 
  spp_data2 <- as.data.frame(mod2$BUGSoutput$summary)
  if(reg_agg != '') reg_agg <- paste0('.r_', reg_agg)
  # get rows we are interested in
  ### take psi.fs rows - these are the yearly proportion of occupied cells ###
  spp_data2$X <- row.names(spp_data2)
  new_data2 <- spp_data2[grepl(paste0("^alpha.p", reg_agg, "\\["),spp_data2$X),]
  new_data2$year <- (Year = (mod2$min_year + 1894) + 
                       (as.numeric(gsub(paste0("^alpha.p", reg_agg), "", 
                                        gsub("\\[|\\]","", row.names(new_data)))))*10)
  # rename columns, otherwise ggplot doesn't work properly    
  names(new_data2) <- gsub("2.5%","quant_025", names(new_data2))
  names(new_data2) <- gsub("97.5%","quant_975", names(new_data2))
  new_data2$mean <- inv.logit(new_data2$mean)   
  new_data2$quant_025 <- inv.logit(new_data2$quant_025)   
  new_data2$quant_975 <- inv.logit(new_data2$quant_975)
  
  
  ########## 5x5km
  # gets summary output from the BUGS files 
  spp_data3 <- as.data.frame(mod3$BUGSoutput$summary)
  if(reg_agg != '') reg_agg <- paste0('.r_', reg_agg)
  # get rows we are interested in
  ### take psi.fs rows - these are the yearly proportion of occupied cells ###
  spp_data3$X <- row.names(spp_data3)
  new_data3 <- spp_data3[grepl(paste0("^alpha.p", reg_agg, "\\["),spp_data3$X),]
  new_data3$year <- (Year = (mod3$min_year + 1894) + 
                       (as.numeric(gsub(paste0("^alpha.p", reg_agg), "", 
                                        gsub("\\[|\\]","", row.names(new_data3)))))*10)
  # rename columns, otherwise ggplot doesn't work properly    
  names(new_data3) <- gsub("2.5%","quant_025", names(new_data3))
  names(new_data3) <- gsub("97.5%","quant_975", names(new_data3))  
  new_data3$mean <- inv.logit(new_data3$mean)   
  new_data3$quant_025 <- inv.logit(new_data3$quant_025)   
  new_data3$quant_975 <- inv.logit(new_data3$quant_975)
  
  
  ########## 10x10km
  # gets summary output from the BUGS files 
  spp_data4 <- as.data.frame(mod4$BUGSoutput$summary)
  if(reg_agg != '') reg_agg <- paste0('.r_', reg_agg)
  # get rows we are interested in
  ### take psi.fs rows - these are the yearly proportion of occupied cells ###
  spp_data4$X <- row.names(spp_data4)
  new_data4 <- spp_data4[grepl(paste0("^alpha.p", reg_agg, "\\["),spp_data4$X),]
  new_data4$year <- (Year = (mod4$min_year + 1894) + 
                       (as.numeric(gsub(paste0("^alpha.p", reg_agg), "", 
                                        gsub("\\[|\\]","", row.names(new_data4)))))*10)
  # rename columns, otherwise ggplot doesn't work properly    
  names(new_data4) <- gsub("2.5%","quant_025", names(new_data4))
  names(new_data4) <- gsub("97.5%","quant_975", names(new_data4))
  new_data4$mean <- inv.logit(new_data4$mean)   
  new_data4$quant_025 <- inv.logit(new_data4$quant_025)   
  new_data4$quant_975 <- inv.logit(new_data4$quant_975)
  
  ########## Plot
  p <-  ggplot(new_data, aes_string(x = "year", y = "mean")) + 
    theme_bw() +
    geom_ribbon(data = new_data2,
                aes_string(group = 1, ymin = "quant_025", ymax = "quant_975"),
                alpha = 0.2, fill="#E69F00") +
    geom_ribbon(data = new_data3,
                aes_string(group = 1, ymin = "quant_025", ymax = "quant_975"),
                alpha = 0.2, fill = "#56B4E9") +
    geom_ribbon(data = new_data4,
                aes_string(group = 1, ymin = "quant_025", ymax = "quant_975"),
                alpha = 0.2, fill = "#009E73") +
    theme(axis.title.x=element_blank(),
          axis.text.x=element_blank()) +
    theme(axis.title.y=element_blank(),
          axis.text.y=element_blank()) +
    scale_y_continuous(limits = c(0, 1)) +
    scale_x_continuous(breaks=seq(1900, 2020,20)) +
    geom_line(data = new_data2, aes(col = "#E69F00"), size=1) +
    geom_line(data = new_data3, aes(col = "#56B4E9"), size=1) +
    geom_line(data = new_data4, aes(col = "#009E73"), size=1) +
    scale_colour_manual(name = 'Spatial resolution', 
                        values =c("#E69F00"="#E69F00", "#56B4E9"="#56B4E9", 
                                  "#009E73"="#009E73"), 
                        labels = c('10 km','5 km', '2 km')) +
    theme(legend.position = "none") +
    theme(text = element_text(size=18))
  return(p)
}















############################ V. crabro One Year plot function ############################
# This function plots all occupancy estimates at 1x1, 2x2, 5x5 and 10x10 km resolutions

plot1yr_occDet_vc <- function(mod1, mod2, mod3, mod4){
  
  ########## 1x1km
  # gets summary output from the BUGS files 
  main = mod1$SPP_NAME
  reg_agg =''
  spp_data <- as.data.frame(mod1$BUGSoutput$summary)
  if(reg_agg != '') reg_agg <- paste0('.r_', reg_agg)
  # get rows we are interested in
  ### take psi.fs rows - these are the yearly proportion of occupied cells ###
  spp_data$X <- row.names(spp_data)
  new_data <- spp_data[grepl(paste0("^alpha.p", reg_agg, "\\["),spp_data$X),]
  new_data$year <- (Year = (mod1$min_year + 1898) + 
                      as.numeric(gsub(paste0("^alpha.p", reg_agg), 
                                      "", gsub("\\[|\\]","", row.names(new_data)))))
  # rename columns, otherwise ggplot doesn't work properly    
  names(new_data) <- gsub("2.5%","quant_025", names(new_data))
  names(new_data) <- gsub("97.5%","quant_975", names(new_data))
  new_data$mean <- inv.logit(new_data$mean)   
  new_data$quant_025 <- inv.logit(new_data$quant_025)   
  new_data$quant_975 <- inv.logit(new_data$quant_975)
  
  
  ########## 2x2km
  # gets summary output from the BUGS files 
  spp_data2 <- as.data.frame(mod2$BUGSoutput$summary)
  if(reg_agg != '') reg_agg <- paste0('.r_', reg_agg)
  # get rows we are interested in
  ### take psi.fs rows - these are the yearly proportion of occupied cells ###
  spp_data2$X <- row.names(spp_data2)
  new_data2 <- spp_data2[grepl(paste0("^alpha.p", reg_agg, "\\["),spp_data2$X),]
  new_data2$year <- (Year = (mod2$min_year + 1898) + 
                       as.numeric(gsub(paste0("^alpha.p", reg_agg), "", 
                                       gsub("\\[|\\]","", row.names(new_data2)))))
  # rename columns, otherwise ggplot doesn't work properly    
  names(new_data2) <- gsub("2.5%","quant_025", names(new_data2))
  names(new_data2) <- gsub("97.5%","quant_975", names(new_data2))
  new_data2$mean <- inv.logit(new_data2$mean)   
  new_data2$quant_025 <- inv.logit(new_data2$quant_025)   
  new_data2$quant_975 <- inv.logit(new_data2$quant_975)
  
  
  ########## 5x5km
  # gets summary output from the BUGS files 
  spp_data3 <- as.data.frame(mod3$BUGSoutput$summary)
  if(reg_agg != '') reg_agg <- paste0('.r_', reg_agg)
  # get rows we are interested in
  ### take psi.fs rows - these are the yearly proportion of occupied cells ###
  spp_data3$X <- row.names(spp_data3)
  new_data3 <- spp_data3[grepl(paste0("^alpha.p", reg_agg, "\\["),spp_data3$X),]
  new_data3$year <- (Year = (mod3$min_year + 1898) + 
                       as.numeric(gsub(paste0("^alpha.p", reg_agg), "", 
                                       gsub("\\[|\\]","", row.names(new_data3)))))
  # rename columns, otherwise ggplot doesn't work properly    
  names(new_data3) <- gsub("2.5%","quant_025", names(new_data3))
  names(new_data3) <- gsub("97.5%","quant_975", names(new_data3))
  new_data3$mean <- inv.logit(new_data3$mean)   
  new_data3$quant_025 <- inv.logit(new_data3$quant_025)   
  new_data3$quant_975 <- inv.logit(new_data3$quant_975)
  
  
  ########## 10x10km
  # gets summary output from the BUGS files 
  spp_data4 <- as.data.frame(mod4$BUGSoutput$summary)
  if(reg_agg != '') reg_agg <- paste0('.r_', reg_agg)
  # get rows we are interested in
  ### take psi.fs rows - these are the yearly proportion of occupied cells ###
  spp_data4$X <- row.names(spp_data4)
  new_data4 <- spp_data4[grepl(paste0("^alpha.p", reg_agg, "\\["),spp_data4$X),]
  new_data4$year <- (Year = (mod4$min_year + 1898) + 
                       as.numeric(gsub(paste0("^alpha.p", reg_agg), "", 
                                       gsub("\\[|\\]","", row.names(new_data4)))))
  # rename columns, otherwise ggplot doesn't work properly    
  names(new_data4) <- gsub("2.5%","quant_025", names(new_data4))
  names(new_data4) <- gsub("97.5%","quant_975", names(new_data4))
  new_data4$mean <- inv.logit(new_data4$mean)   
  new_data4$quant_025 <- inv.logit(new_data4$quant_025)   
  new_data4$quant_975 <- inv.logit(new_data4$quant_975)
  
  
  ########## Plot
  p <- ggplot(new_data, aes_string(x = "year", y = "mean")) + 
    theme_bw() +
    geom_ribbon(data = new_data,
                aes_string(group = 1, ymin = "quant_025", ymax = "quant_975"),
                alpha = 0.2, fill = "#999999") +
    geom_ribbon(data = new_data2,
                aes_string(group = 1, ymin = "quant_025", ymax = "quant_975"),
                alpha = 0.2, fill="#E69F00") +
    geom_ribbon(data = new_data3,
                aes_string(group = 1, ymin = "quant_025", ymax = "quant_975"),
                alpha = 0.2, fill = "#56B4E9") +
    geom_ribbon(data = new_data4,
                aes_string(group = 1, ymin = "quant_025", ymax = "quant_975"),
                alpha = 0.2, fill = "#009E73") +
    geom_line(data = new_data, aes(col = "#999999"), size=1) +
    ylab("Occupancy") +
    xlab("Year") +
    theme(axis.title.x=element_blank()) +
    theme(axis.title.y=element_blank()) +
    theme(text = element_text(size=18)) +
    scale_y_continuous(limits = c(0, 1)) +
    scale_x_continuous(breaks=seq(1900, 2020,20)) +
    geom_line(data = new_data2, aes(col = "#E69F00"), size=1) +
    geom_line(data = new_data3, aes(col = "#56B4E9"), size=1) +
    geom_line(data = new_data4, aes(col = "#009E73"), size=1) +
    scale_colour_manual(name = 'Spatial \nresolution', 
                        values =c("#999999"="#999999","#E69F00"="#E69F00", 
                                  "#56B4E9"="#56B4E9", "#009E73"="#009E73"), 
                        labels = c('10 km','5 km','1 km', '2 km')) +
    theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust=1)) +
    theme(legend.position = "none") +
    theme(text = element_text(size=18))
  
  return(p)
}



############################ V. crabro Five Years plot function ############################
# This function plots all occupancy estimates at 1x1, 2x2, 5x5 and 10x10 km resolutions
plot5yr_occDet_vc <- function(mod1, mod2, mod3, mod4){
  
  
  ########## 1x1km
  # gets summary output from the BUGS files 
  main = mod1$SPP_NAME
  reg_agg =''
  spp_data <- as.data.frame(mod1$BUGSoutput$summary)
  if(reg_agg != '') reg_agg <- paste0('.r_', reg_agg)
  # get rows we are interested in
  ### take psi.fs rows - these are the yearly proportion of occupied cells ###
  spp_data$X <- row.names(spp_data)
  new_data <- spp_data[grepl(paste0("^alpha.p", reg_agg, "\\["),spp_data$X),]
  new_data$year <- (Year = (mod1$min_year + 1896) + 
                      (as.numeric(gsub(paste0("^alpha.p", reg_agg), "",
                                       gsub("\\[|\\]","", row.names(new_data)))))*5)
  # rename columns, otherwise ggplot doesn't work properly    
  names(new_data) <- gsub("2.5%","quant_025", names(new_data))
  names(new_data) <- gsub("97.5%","quant_975", names(new_data))
  new_data$mean <- inv.logit(new_data$mean)   
  new_data$quant_025 <- inv.logit(new_data$quant_025)   
  new_data$quant_975 <- inv.logit(new_data$quant_975)
  
  
  ########## 2x2km
  # gets summary output from the BUGS files 
  spp_data2 <- as.data.frame(mod2$BUGSoutput$summary)
  if(reg_agg != '') reg_agg <- paste0('.r_', reg_agg)
  # get rows we are interested in
  ### take psi.fs rows - these are the yearly proportion of occupied cells ###
  spp_data2$X <- row.names(spp_data2)
  new_data2 <- spp_data2[grepl(paste0("^alpha.p", reg_agg, "\\["),spp_data2$X),]
  new_data2$year <- (Year = (mod2$min_year + 1896) + 
                       (as.numeric(gsub(paste0("^alpha.p", reg_agg), "", 
                                        gsub("\\[|\\]","", row.names(new_data2)))))*5)
  # rename columns, otherwise ggplot doesn't work properly    
  names(new_data2) <- gsub("2.5%","quant_025", names(new_data2))
  names(new_data2) <- gsub("97.5%","quant_975", names(new_data2))
  new_data2$mean <- inv.logit(new_data2$mean)   
  new_data2$quant_025 <- inv.logit(new_data2$quant_025)   
  new_data2$quant_975 <- inv.logit(new_data2$quant_975)
  
  
  
  
  ########## 5x5km
  # gets summary output from the BUGS files 
  spp_data3 <- as.data.frame(mod3$BUGSoutput$summary)
  if(reg_agg != '') reg_agg <- paste0('.r_', reg_agg)
  # get rows we are interested in
  ### take psi.fs rows - these are the yearly proportion of occupied cells ###
  spp_data3$X <- row.names(spp_data3)
  new_data3 <- spp_data3[grepl(paste0("^alpha.p", reg_agg, "\\["),spp_data3$X),]
  new_data3$year <- (Year = (mod3$min_year + 1896) + 
                       (as.numeric(gsub(paste0("^alpha.p", reg_agg), "", 
                                        gsub("\\[|\\]","", row.names(new_data3)))))*5)
  # rename columns, otherwise ggplot doesn't work properly    
  names(new_data3) <- gsub("2.5%","quant_025", names(new_data3))
  names(new_data3) <- gsub("97.5%","quant_975", names(new_data3))
  new_data3$mean <- inv.logit(new_data3$mean)   
  new_data3$quant_025 <- inv.logit(new_data3$quant_025)   
  new_data3$quant_975 <- inv.logit(new_data3$quant_975)
  
  
  ########## 10x10km
  # gets summary output from the BUGS files 
  reg_agg =''
  spp_data4 <- as.data.frame(mod4$BUGSoutput$summary)
  if(reg_agg != '') reg_agg <- paste0('.r_', reg_agg)
  # get rows we are interested in
  ### take psi.fs rows - these are the yearly proportion of occupied cells ###
  spp_data4$X <- row.names(spp_data4)
  new_data4 <- spp_data4[grepl(paste0("^alpha.p", reg_agg, "\\["),spp_data4$X),]
  new_data4$year <- (Year = (mod4$min_year + 1896) + 
                       (as.numeric(gsub(paste0("alpha.p", reg_agg), "", 
                                        gsub("\\[|\\]","", row.names(new_data4)))))*5)
  # rename columns, otherwise ggplot doesn't work properly    
  names(new_data4) <- gsub("2.5%","quant_025", names(new_data4))
  names(new_data4) <- gsub("97.5%","quant_975", names(new_data4))
  new_data4$mean <- inv.logit(new_data4$mean)   
  new_data4$quant_025 <- inv.logit(new_data4$quant_025)   
  new_data4$quant_975 <- inv.logit(new_data4$quant_975)
  
  
  ########## Plot
  p <- ggplot(new_data, aes_string(x = "year", y = "mean")) + 
    theme_bw() +
    geom_ribbon(data = new_data,
                aes_string(group = 1, ymin = "quant_025", ymax = "quant_975"),
                alpha = 0.2, fill = "#999999") +
    geom_ribbon(data = new_data2,
                aes_string(group = 1, ymin = "quant_025", ymax = "quant_975"),
                alpha = 0.2, fill="#E69F00") +
    geom_ribbon(data = new_data3,
                aes_string(group = 1, ymin = "quant_025", ymax = "quant_975"),
                alpha = 0.2, fill = "#56B4E9") +
    geom_ribbon(data = new_data4,
                aes_string(group = 1, ymin = "quant_025", ymax = "quant_975"),
                alpha = 0.2, fill = "#009E73") +
    geom_line(data = new_data, aes(col = "#999999"), size=1) +
    #geom_point(data = new_data, size = 4, aes(col = "#999999")) +
    ylab("Occupancy") +
    xlab("Year") +
    theme(axis.title.x=element_blank()) +
    theme(axis.title.y=element_blank(),
          axis.text.y = element_blank()) +
    scale_y_continuous(limits = c(0, 1)) +
    scale_x_continuous(breaks=seq(1900, 2020,20)) +
    geom_line(data = new_data2, aes(col = "#E69F00"), size=1) +
    geom_line(data = new_data3, aes(col = "#56B4E9"), size=1) +
    geom_line(data = new_data4, aes(col = "#009E73"), size=1) +
    scale_colour_manual(name = 'Spatial resolution', 
                        values =c("#999999"="#999999","#E69F00"="#E69F00", 
                                  "#56B4E9"="#56B4E9", "#009E73"="#009E73"), 
                        labels = c('10 km','5 km','1 km', '2 km')) +
    theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust=1)) +
    theme(legend.position = "none") +
    theme(text = element_text(size=18))
  
  return(p)
}



############################ V. crabro Ten Year plot function ############################
# This function plots all occupancy estimates at 1x1, 2x2, 5x5 and 10x10 km resolutions
plot10yr_occDet_vc <- function(mod1, mod2, mod3, mod4){
  
  ########## 1x1km
  # gets summary output from the BUGS files 
  main = mod1$SPP_NAME
  reg_agg =''
  spp_data <- as.data.frame(mod1$BUGSoutput$summary)
  if(reg_agg != '') reg_agg <- paste0('.r_', reg_agg)
  # get rows we are interested in
  ### take psi.fs rows - these are the yearly proportion of occupied cells ###
  spp_data$X <- row.names(spp_data)
  new_data <- spp_data[grepl(paste0("^alpha.p", reg_agg, "\\["),spp_data$X),]
  new_data$year <- (Year = (mod1$min_year + 1894) + 
                      (as.numeric(gsub(paste0("^alpha.p", reg_agg), "", 
                                       gsub("\\[|\\]","", row.names(new_data)))))*10)
  # rename columns, otherwise ggplot doesn't work properly    
  names(new_data) <- gsub("2.5%","quant_025", names(new_data))
  names(new_data) <- gsub("97.5%","quant_975", names(new_data))
  new_data$mean <- inv.logit(new_data$mean)   
  new_data$quant_025 <- inv.logit(new_data$quant_025)   
  new_data$quant_975 <- inv.logit(new_data$quant_975)
  
  
  ########## 2x2km
  # gets summary output from the BUGS files 
  spp_data2 <- as.data.frame(mod2$BUGSoutput$summary)
  if(reg_agg != '') reg_agg <- paste0('.r_', reg_agg)
  # get rows we are interested in
  ### take psi.fs rows - these are the yearly proportion of occupied cells ###
  spp_data2$X <- row.names(spp_data2)
  new_data2 <- spp_data2[grepl(paste0("^alpha.p", reg_agg, "\\["),spp_data2$X),]
  new_data2$year <- (Year = (mod2$min_year + 1894) + 
                       (as.numeric(gsub(paste0("^alpha.p", reg_agg), "", 
                                        gsub("\\[|\\]","", row.names(new_data2)))))*10)
  # rename columns, otherwise ggplot doesn't work properly    
  names(new_data2) <- gsub("2.5%","quant_025", names(new_data2))
  names(new_data2) <- gsub("97.5%","quant_975", names(new_data2))
  new_data2$mean <- inv.logit(new_data2$mean)   
  new_data2$quant_025 <- inv.logit(new_data2$quant_025)   
  new_data2$quant_975 <- inv.logit(new_data2$quant_975)
  
  
  ########## 5x5km
  # gets summary output from the BUGS files 
  spp_data3 <- as.data.frame(mod3$BUGSoutput$summary)
  if(reg_agg != '') reg_agg <- paste0('.r_', reg_agg)
  # get rows we are interested in
  ### take psi.fs rows - these are the yearly proportion of occupied cells ###
  spp_data3$X <- row.names(spp_data3)
  new_data3 <- spp_data3[grepl(paste0("^alpha.p", reg_agg, "\\["),spp_data3$X),]
  new_data3$year <- (Year = (mod3$min_year + 1894) + 
                       (as.numeric(gsub(paste0("^alpha.p", reg_agg), "", 
                                        gsub("\\[|\\]","", row.names(new_data3)))))*10)
  # rename columns, otherwise ggplot doesn't work properly    
  names(new_data3) <- gsub("2.5%","quant_025", names(new_data3))
  names(new_data3) <- gsub("97.5%","quant_975", names(new_data3))
  new_data3$mean <- inv.logit(new_data3$mean)   
  new_data3$quant_025 <- inv.logit(new_data3$quant_025)   
  new_data3$quant_975 <- inv.logit(new_data3$quant_975)
  
  
  ########## 10x10km
  # gets summary output from the BUGS files 
  spp_data4 <- as.data.frame(mod4$BUGSoutput$summary)
  if(reg_agg != '') reg_agg <- paste0('.r_', reg_agg)
  # get rows we are interested in
  ### take psi.fs rows - these are the yearly proportion of occupied cells ###
  spp_data4$X <- row.names(spp_data4)
  new_data4 <- spp_data4[grepl(paste0("^alpha.p", reg_agg, "\\["),spp_data4$X),]
  new_data4$year <- (Year = (mod4$min_year + 1894) + 
                       (as.numeric(gsub(paste0("^alpha.p", reg_agg), "", 
                                        gsub("\\[|\\]","", row.names(new_data4)))))*10)
  # rename columns, otherwise ggplot doesn't work properly    
  names(new_data4) <- gsub("2.5%","quant_025", names(new_data4))
  names(new_data4) <- gsub("97.5%","quant_975", names(new_data4))
  new_data4$mean <- inv.logit(new_data4$mean)   
  new_data4$quant_025 <- inv.logit(new_data4$quant_025)   
  new_data4$quant_975 <- inv.logit(new_data4$quant_975)
  
  
  ########## Plot
  p <- ggplot(new_data, aes_string(x = "year", y = "mean")) + 
    theme_bw() +
    geom_ribbon(data = new_data,
                aes_string(group = 1, ymin = "quant_025", ymax = "quant_975"),
                alpha = 0.2, fill = "#999999") +
    geom_ribbon(data = new_data2,
                aes_string(group = 1, ymin = "quant_025", ymax = "quant_975"),
                alpha = 0.2, fill="#E69F00") +
    geom_ribbon(data = new_data3,
                aes_string(group = 1, ymin = "quant_025", ymax = "quant_975"),
                alpha = 0.2, fill = "#56B4E9") +
    geom_ribbon(data = new_data4,
                aes_string(group = 1, ymin = "quant_025", ymax = "quant_975"),
                alpha = 0.2, fill = "#009E73") +
    geom_line(data = new_data, aes(col = "#999999"), size=1) +
    theme(axis.title.x=element_blank()) +
    theme(axis.title.y=element_blank(),
          axis.text.y = element_blank()) +
    scale_y_continuous(limits = c(0, 1)) +
    scale_x_continuous(breaks=seq(1900, 2020,20)) +
    geom_line(data = new_data2, aes(col = "#E69F00"), size=1) +
    geom_line(data = new_data3, aes(col = "#56B4E9"), size=1) +
    geom_line(data = new_data4, aes(col = "#009E73"), size=1) +
    scale_colour_manual(name = 'Spatial resolution', 
                        values =c("#999999"="#999999","#E69F00"="#E69F00", 
                                  "#56B4E9"="#56B4E9", "#009E73"="#009E73"), 
                        labels = c('10 km','5 km','1 km', '2 km'))  +
    theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust=1)) +
    theme(legend.position = "none") +
    theme(text = element_text(size=18))
  return(p)
}



#### Plot V. vulgaris
Vvulgaris1yr <- plot1yr_occDet_vv(results_1kmgrid_date_year_vv, 
                                results_2kmgrid_date_year_vv, 
                                results_5kmgrid_date_year_vv, 
                                results_10kmgrid_date_year_vv)

Vvulgaris5yr <- plot5yr_occDet_vv(results_1kmgrid_date_5years_vv, 
                                results_2kmgrid_date_5years_vv,
                                results_5kmgrid_date_5years_vv,
                                results_10kmgrid_date_5years_vv)

Vvulgaris10yr <- plot10yr_occDet_vv(results_1kmgrid_date_10years_vv, 
                                  results_2kmgrid_date_10years_vv,
                                  results_5kmgrid_date_10years_vv,
                                  results_10kmgrid_date_10years_vv)



#### Plot V. germanica
Vgermanica1yr <- plot1yr_occDet_vg(results_1kmgrid_date_year_vg, 
                                 results_2kmgrid_date_year_vg, 
                                 results_5kmgrid_date_year_vg, 
                                 results_10kmgrid_date_year_vg)
Vgermanica5yr <- plot5yr_occDet_vg(results_1kmgrid_date_5years_vg,
                                 results_2kmgrid_date_5years_vg,
                                 results_5kmgrid_date_5years_vg,
                                 results_10kmgrid_date_5years_vg)
Vgermanica10yr <- plot10yr_occDet_vg(results_1kmgrid_date_10years_vg,
                                   results_2kmgrid_date_10years_vg,
                                   results_5kmgrid_date_10years_vg,
                                   results_10kmgrid_date_10years_vg)

#### Plot V. crabro
Vcrabro1yr <- plot1yr_occDet_vc(results_1kmgrid_date_year_vc, 
                              results_2kmgrid_date_year_vc, 
                              results_5kmgrid_date_year_vc, 
                              results_10kmgrid_date_year_vc)

Vcrabro5yr <- plot5yr_occDet_vc(results_1kmgrid_date_5years_vc, 
                              results_2kmgrid_date_5years_vc,
                              results_5kmgrid_date_5years_vc,
                              results_10kmgrid_date_5years_vc)

Vcrabro10yr <- plot10yr_occDet_vc(results_1kmgrid_date_10years_vc, 
                                results_2kmgrid_date_10years_vc,
                                results_5kmgrid_date_10years_vc,
                                results_10kmgrid_date_10years_vc)








edge <- rectGrob(gp=gpar(col = "white", fill="grey90"))
blanc <- rectGrob(gp=gpar(col = "white", fill=NA))
gs <- list(edge, edge, edge, blanc,
           Vvulgaris1yr, Vvulgaris5yr, Vvulgaris10yr, edge,
           Vgermanica1yr, Vgermanica5yr, Vgermanica10yr, edge,
           Vcrabro1yr, Vcrabro5yr, Vcrabro10yr, edge)


occDet_fig <-ggdraw() + draw_plot((grid.arrange(grobs= gs,
                                              widths= c(1.25, 1, 1, 0.2),
                                              heights = c(0.17, 1, 1, 1.27),
                                              layout.matrix = rbind(c(1, 2, 3, 4), 
                                                                    c(5, 6, 7, 8),
                                                                    c(9, 10, 11, 12),
                                                                    c(13, 14, 15, 16)),
                                              left=textGrob("\n \n Detection Probability", rot=90, hjust=0.2,
                                                            gp=gpar(fontsize=16, fontface="bold")),
                                              bottom=textGrob("Year", hjust=0.2,
                                                              gp=gpar(fontsize=16, fontface="bold")),
                                              top=textGrob("Closure Period", vjust=0.3, 
                                                           gp=gpar(fontsize=14, fontface="bold")))), 
                                x = 0, y = 0, width = 0.9, height = 1) +
  draw_plot_label(label = c("(a)", "(b)", "(c)"), size = 16,
                  x = c(0, 0, 0), y = c(0.91, 0.66, 0.37)) +
  draw_plot_label(label = c("1 Year", "5 Year", "10 Year"), size = 14, fontface="plain",
                  x = c(0.2, 0.45, 0.67), y = c(0.962, 0.962, 0.962)) +
  draw_plot_label(label = c("V. vulgaris", "V. germanica", "V. crabro"), angle=-90, size = 14, fontface="italic",
                  x = c(0.89, 0.89, 0.89), y = c(0.93, 0.7, 0.37))

#ggsave(filename = "Figure_5.pdf", plot = occDet_fig, width = 220, height = 180, 
#       dpi = 600, units = "mm", device='pdf', path = "./figs")





















































############################ V. germanica Ten Years plot function ############################
# This function plots all occupancy estimates at 2x2, 5x5 and 10x10 km resolutions
# at one year temporal resolutions
plot10yr_occDet_vg <- function(mod1, mod2, mod3, mod4){
  
  ########## 1x1km
  # gets summary output from the BUGS files 
  main = mod1$SPP_NAME
  reg_agg =''
  spp_data <- as.data.frame(mod1$BUGSoutput$summary)
  
  if(reg_agg != '') reg_agg <- paste0('.r_', reg_agg)
  
  # get rows we are interested in
  ### take psi.fs rows - these are the yearly proportion of occupied cells ###
  spp_data$X <- row.names(spp_data)
  new_data <- spp_data[grepl(paste0("^alpha.p", reg_agg, "\\["),spp_data$X),]
  new_data$year <- (Year = (mod1$min_year + 1894) + 
                      (as.numeric(gsub(paste0("alpha.p", reg_agg), "", 
                                       gsub("\\[|\\]","", row.names(new_data)))))*10)
  
  # rename columns, otherwise ggplot doesn't work properly    
  names(new_data) <- gsub("2.5%","quant_025", names(new_data))
  names(new_data) <- gsub("97.5%","quant_975", names(new_data))
  new_data$mean <- inv.logit(new_data$mean)
  new_data$quant_025 <- inv.logit(new_data$quant_025)
  new_data$quant_975 <- inv.logit(new_data$quant_975)
  
  
  ########## 2x2km
  # gets summary output from the BUGS files 
  spp_data2 <- as.data.frame(mod2$BUGSoutput$summary)
  
  if(reg_agg != '') reg_agg <- paste0('.r_', reg_agg)
  
  # get rows we are interested in
  ### take psi.fs rows - these are the yearly proportion of occupied cells ###
  spp_data2$X <- row.names(spp_data2)
  new_data2 <- spp_data2[grepl(paste0("^alpha.p", reg_agg, "\\["),spp_data2$X),]
  new_data2$year <- (Year = (mod2$min_year + 1894) + 
                       (as.numeric(gsub(paste0("alpha.p", reg_agg), "", 
                                        gsub("\\[|\\]","", row.names(new_data)))))*10)
  
  # rename columns, otherwise ggplot doesn't work properly    
  names(new_data2) <- gsub("2.5%","quant_025", names(new_data2))
  names(new_data2) <- gsub("97.5%","quant_975", names(new_data2))
  new_data2$mean <- inv.logit(new_data2$mean)
  new_data2$quant_025 <- inv.logit(new_data2$quant_025)
  new_data2$quant_975 <- inv.logit(new_data2$quant_975)
  
  
  ########## 5x5km
  # gets summary output from the BUGS files 
  spp_data3 <- as.data.frame(mod3$BUGSoutput$summary)
  
  if(reg_agg != '') reg_agg <- paste0('.r_', reg_agg)
  
  # get rows we are interested in
  ### take psi.fs rows - these are the yearly proportion of occupied cells ###
  spp_data3$X <- row.names(spp_data3)
  new_data3 <- spp_data3[grepl(paste0("^alpha.p", reg_agg, "\\["),spp_data3$X),]
  new_data3$year <- (Year = (mod3$min_year + 1894) + 
                       (as.numeric(gsub(paste0("alpha.p", reg_agg), "", 
                                        gsub("\\[|\\]","", row.names(new_data3)))))*10)
  
  # rename columns, otherwise ggplot doesn't work properly    
  names(new_data3) <- gsub("2.5%","quant_025", names(new_data3))
  names(new_data3) <- gsub("97.5%","quant_975", names(new_data3))
  new_data3$mean <- inv.logit(new_data3$mean)
  new_data3$quant_025 <- inv.logit(new_data3$quant_025)
  new_data3$quant_975 <- inv.logit(new_data3$quant_975)
  
  
  ########## 10x10km
  # gets summary output from the BUGS files 
  spp_data4 <- as.data.frame(mod4$BUGSoutput$summary)
  
  if(reg_agg != '') reg_agg <- paste0('.r_', reg_agg)
  
  # get rows we are interested in
  ### take psi.fs rows - these are the yearly proportion of occupied cells ###
  spp_data4$X <- row.names(spp_data4)
  new_data4 <- spp_data4[grepl(paste0("alpha.p", reg_agg, "\\["),spp_data4$X),]
  new_data4$year <- (Year = (mod4$min_year + 1894) + 
                       (as.numeric(gsub(paste0("alpha.p", reg_agg), "", 
                                        gsub("\\[|\\]","", row.names(new_data4)))))*10)
  
  # rename columns, otherwise ggplot doesn't work properly    
  names(new_data4) <- gsub("2.5%","quant_025", names(new_data4))
  names(new_data4) <- gsub("97.5%","quant_975", names(new_data4))
  new_data4$mean <- inv.logit(new_data4$mean)
  new_data4$quant_025 <- inv.logit(new_data4$quant_025)
  new_data4$quant_975 <- inv.logit(new_data4$quant_975)
  
  ########## Plot
  ggplot(new_data, aes_string(x = "year", y = "mean")) + 
    theme_bw() +
    #geom_ribbon(data = new_data,
    #            aes_string(group = 1, ymin = "quant_025", ymax = "quant_975"),
    #            alpha = 0.2, fill = "#999999") +
    geom_ribbon(data = new_data2,
                aes_string(group = 1, ymin = "quant_025", ymax = "quant_975"),
                alpha = 0.2, fill="#E69F00") +
    geom_ribbon(data = new_data3,
                aes_string(group = 1, ymin = "quant_025", ymax = "quant_975"),
                alpha = 0.2, fill = "#56B4E9") +
    geom_ribbon(data = new_data4,
                aes_string(group = 1, ymin = "quant_025", ymax = "quant_975"),
                alpha = 0.2, fill = "#009E73") +
    #geom_line(data = new_data, aes(col = "#999999"), size=1) +
    #geom_point(data = new_data, size = 4, aes(col = "#999999")) +
    #ylab("Occupancy") +
    #xlab("Year") +
    theme(axis.title.x=element_blank(),
          axis.text.x=element_blank()) +
    theme(axis.title.y=element_blank(),
          axis.text.y=element_blank()) +
    scale_y_continuous(limits = c(0, 1)) +
    scale_x_continuous(breaks=seq(1900, 2020,20)) +
    geom_line(data = new_data2, aes(col = "#E69F00"), size=1) +
    #geom_point(data = new_data2, size = 4, aes(col = "#E69F00")) +
    geom_line(data = new_data3, aes(col = "#56B4E9"), size=1) +
    #geom_point(data = new_data3, size = 4, aes(col = "#56B4E9")) +
    geom_line(data = new_data4, aes(col = "#009E73"), size=1) +
    #geom_point(data = new_data4, size = 4, aes(col = "#009E73")) +
    #ggtitle("Vespula germanica: Four models @ 10 year closure periods") +
    scale_colour_manual(name = 'Spatial resolution', 
                        values =c(#"#999999"="#999999",
                          "#E69F00"="#E69F00", "#56B4E9"="#56B4E9", 
                          "#009E73"="#009E73"), 
                        labels = c('10 km','5 km',#'1 km', 
                                   '2 km')) 
  theme(legend.position = "none") 
  return(p)
}