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

For reproducibility purposes download this and place it into the `rawdata/` or `data/` folder as appropriate to rerun our analyses. 

The full NHM dataset is available via the [NHM data portal](https://data.nhm.ac.uk/doi/10.5519/qd.tdi9zagc). If you use it, please cite as folows: 
> Natural History Museum (2019). Data Portal query on 1 resources created at 2019-12-20 14:28:57.870572 PID https://doi.org/10.5519/qd.tdi9zagc

In this repository, we have uploaded the raw NHM data for all *Vespula vulgaris*, *Vespula germanica* and *Vespa crabro* specimens in the folder `data/rawData`, as well as the cleaned NHM data in the folder `data/cleanData`, and auxiliary data in the folder `data/auxiliaryData`.

We were unable to upload the formatted date files and the model output files to GitHub because the files are too large. These files will be made available on Dryad if the manuscript is accepted for publication. 

## Analyses
The analysis code is divided into .Rmd files that run the analyses and plot the figures for each section of the manuscript/supplementary materials, and more detailed scripts for the figures found in the paper and called by the .Rmd files.

Note that throughout I've commented out `write.csv` and `saveRDS` commands in order to not clog up your machine (the analyses were run on high performance machines).

* __01-data-cleaning-Rdm__
* __02-format-data.Rdm__
* __03-models__
* __04-summary-stats.Rmd__
* __05-summary-plots.Rmd__

##### Code for figures

* __figure-bla__
* __figure-bla__
* __figure-bla__


##### Code for functions

* __function-bla__
* __figure-bla__


## Other folders

* ´/figs´ contains the figures
* ´/output´ contains the formatted data and model outputs. For reproducibility purposes download these files from Dryad and place into this folder to rerun our analyses.

## Session Info

