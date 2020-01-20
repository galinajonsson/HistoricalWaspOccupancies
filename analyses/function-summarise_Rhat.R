# Function to summarise whether or not all occupancy estimates throughout the time series have converged (based on Rhat-values) for many .rds files in an input directory
# This function reads in and summarises all the .rds files' Rhat values (all values below 1.1 or not) for the occupancy estimates
summarise_Rhat <-  function(input_dir, verbose = TRUE) {
  
  library(reshape2)
  require(dplyr)
  
  # get files from the input directory
  files <- list.files(path = paste(input_dir), ignore.case = TRUE, pattern = '\\.rds$') # list of the files to loop through
  
  # sense check these file names
  if(length(files) == 0) stop('No .rds files found in ', input_dir)
  if(length(files) < length(list.files(path = input_dir))) warning('Not all files in ', input_dir, ' are .rds files, other file types have been ignored')
  
  loadrds <- function(fileName){
    #loads an rds file, tests if it contains the necessary objects and returns it
    out <- readRDS(fileName)
    if(!("BUGSoutput" %in% ls(out))){
      stop('The rds file(s) do not contain a "BUGSoutput" object.')
    }
    if(!("summary" %in% ls(out$BUGSoutput))){
      stop('The rds file(s) do not contain a summary of the "BUGSoutput" object.')
    }
    if(!("SPP_NAME" %in% ls(out))){
      stop('The rds file(s) do not contain a "SPP_NAME" object.')
    }
    if(!("min_year" %in% ls(out))){
      stop('The rds file(s) do not contain a "min_year" object.')
    }
    if(!("max_year" %in% ls(out))){
      stop('The rds file(s) do not contain a "max_year" object.')
    }
    return(out)
  }
  
  # create a function to read in the data we want from these .rds files
  read_bayes <- function(file){
    
    out <- loadrds(file) 
    
    # some old outputs dont have min year in which case make it == 1
    min_year <- ifelse(is.null(out$min_year), 1, out$min_year)
    #Get the summary output for the rows and columns that we are interested in
    temp_out <- as.data.frame(out$BUGSoutput$summary)
      rows <- grep("^(psi.fs[^.r])", row.names(temp_out))
      for (i in rows) 
      {
        if (temp_out[i, c("Rhat")] > 1.1) 
          {
          convergenceYN <- "N"
          break
        }
        if (i == max(rows)) 
          {convergenceYN <- "Y"}
      }
      summary_out <- data.frame(species_name = out$SPP_NAME,
                                converged = convergenceYN)
    return(summary_out)
  }
  
  if(verbose) cat('Loading data...')
  # Use lapply to run this function on all files
  list_summaries <- lapply(file.path(input_dir, files), read_bayes)
  if(verbose) cat('done\n')
  
  # Unlist these and bind them together
  spp_data <- do.call(rbind, list_summaries)
  
  return(spp_data)
}
