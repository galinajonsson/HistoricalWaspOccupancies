# Function to read all .rds files in a specified directory and assign all to the global directory
# This function reads in all the .rds files in a folder specified by the "input_dir" argument and assign all to the global directory
readRDS_multi <-  function(input_dir, verbose = TRUE) {
  
  # Load required packages
  library(reshape2)
  require(dplyr)
  
  # list all .rds files from the input directory
  files <- list.files(path = paste(input_dir), ignore.case = TRUE, pattern = '\\.rds$') # list of the files to loop through
  
  # sense check these file names
  if(length(files) == 0) stop('No .rds files found in ', input_dir) # No .rds files in input dir
  if(length(files) < length(list.files(path = input_dir))) warning('Not all files in ', input_dir, ' are .rds files, other file types have been ignored')
  
  #function to load an rds file, tests if it contains the necessary objects and returns it
  loadrds <- function(fileName){
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

  
  if(verbose) cat('Loading data...')
  
  # Use lapply to run the loadrds function across all files, creating a list of all model outputs
  list.rds <- lapply(file.path(input_dir, files), loadrds)
  
  ### Create an object ("model_names") that specifies model names (same as file names)
  model_names <- gsub("../outputs/modelOutputs/","",files) # Remove folder names from file paths
  model_names <- gsub(".rds","",files) # Remove .rds from file names
  
  # Name the model outputs (list elements) in "list.rds" according model_names
  names(list.rds) <- model_names
  # Assign each names list element to the global environment within lapply. 
  # Wrapped in invisible to avoid printing the output to the console.
  invisible(lapply(names(list.rds),function(x) assign(x,list.rds[[x]],.GlobalEnv)))

  if(verbose) cat('done\n')
}