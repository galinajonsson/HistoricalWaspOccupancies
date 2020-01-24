# Historical Wasp Occupancies

Author(s): [Galina M. Jönsson](https://github.com/galinajonsson)

This repository contains all the code and some data for:

>Jönsson, G. M., Broad, G. R., Sumner, S. and Isaac, N. J. B. (2020). A century of social wasp occupancy trends from natural history collections: spatiotemporal resolutions have little effect on model performance.  Unpublished manucript. 


## Data
We used two sources of data: specimen records from the Natural History Museum, London (NHM), and observational records from the Bees, Ants and Wasps Recording Society (BWARS). The BWARS data is available upon request from:
>The National Biodiversity Network  
Unit F, 14-18 St. Mary’s Gate  
Lace Market  
Nottingham, UK  
Telephone: +44 (0)115 850 0177  
Email: support@nbn.org.uk  

For reproducibility purposes, download this and place it into the `data/rawdata/` folder to rerun our analyses. 

The georeferenced NHM dataset is available via the [NHM data portal](https://data.nhm.ac.uk/dataset/georeferenced-uk-social-wasps). If you use it, please cite as folows: 
> Galina M. Jönsson (2020). Dataset: Georeferenced UK social wasps. Natural History Museum Data Portal (data.nhm.ac.uk). https://doi.org/10.5519/0082541

In this repository, we have uploaded the georeferenced NHM data for all *Vespula vulgaris*, *Vespula germanica* and *Vespa crabro* specimens in the folder `/data/rawData`, as well as the cleaned NHM data in the folder `/data/cleanData`, and auxiliary data in the folder `/data/auxiliaryData`.

We were unable to upload the formatted date files and the model output files to GitHub because the files are too large. For reproducibility purposes, format the raw data according to the code in `/analyses/02-format-data.Rdm` and place into the `/output/formattedData`. All model outputs are available via the [NHM data portal](https://data.nhm.ac.uk/dataset/historical-wasp-occupancies-model-outputs). If you use it, please cite as folows: 
> Galina M. Jönsson (2020). Dataset: Historical wasp occupancies: model outputs. Natural History Museum Data Portal (data.nhm.ac.uk). https://doi.org/10.5519/0055095

For reproducibility purposes, download it and place it into the `/output/modelOutput` folder to rerun our analyses. 

## Analyses
The analyses code is divided into .Rmd files that run the analyses for each section of the manuscript/supplementary materials, more detailed scripts for some functions used in analyses and called by the .Rmd files, and scripts for the figures found in the manuscript.

Note that throughout I've commented out `write.csv` and `saveRDS` commands in order to not clog up your machine. For code chunks that run the models, I've set `eval` to FALSE, again, to not clog up your macine as the analyses are computationally expensive and were run on high performance machines.

* __01-data-cleaning-Rdm__ cleans and standardises the georeferenced data.
* __02-format-model.Rdm__ formats the clean data and runs the models.
* __03-summaries.Rmd__ summarises the data used in models and model outputs.

##### Code for figures

* __figure-record_numbers.R__
* __figure-spatial_cover.R__
* __figure-XXXX__
* __figure-XXXX__
* __figure-DIC.R__
* __figure-spatial_species.R__
* __figure-pD.R__
* __figure-deviance.R__



##### Code for functions

* __function-readRDS_multi.R__
* __function-summarise_Rhat.R__


## Other folders

* `/figs` contains the figures with file names matching those of the manuscript
* `/output` contains the empty subfolders `/output/formattedData` and `/output/modelOutputs`, as well as the subfolder `/output/summaryTables` that contains tables summarising both the data used in models and model outputs. For reproducibility purposes, format the raw data according to the code in `/analyses/02-format-data.Rdm` and place into `/output/formattedData`, and download the model outputs and place into `/output/modelOutputs`. All model outputs are available via the [NHM data portal](https://data.nhm.ac.uk/dataset/historical-wasp-occupancies-model-outputs). 


## Session Info
``
