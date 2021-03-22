# Historical Wasp Occupancies

Author(s): [Galina M. Jönsson](https://github.com/galinajonsson)

This repository contains all the code and some data for:

>Jönsson, G. M., Broad, G. R., Sumner, S. and Isaac, N. J. B. (in press.). A century of social wasp occupancy trends from natural history collections: spatiotemporal resolutions have little effect on model performance. *Insect Conservation and Diversity*. doi:10.1111/icad.12494.


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
* __figure-occupancy_estimates.R__
* __figure-detectionProbability_estimates.R__
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
For reproducibility purposes, here is the output of devtools::session_info() used to perform the analyses in the publication.
```
─ Session info ───────────────────────────────────────────────────────────────────────────────
 setting  value                       
 version  R version 3.5.2 (2018-12-20)
 os       macOS Mojave 10.14.3        
 system   x86_64, darwin15.6.0        
 ui       RStudio                     
 language (EN)                        
 collate  en_GB.UTF-8                 
 ctype    en_GB.UTF-8                 
 tz       Europe/London               
 date     2020-01-27                  

─ Packages ───────────────────────────────────────────────────────────────────────────────────
 package     * version  date       lib source                                         
 abind         1.4-5    2016-07-21 [1] CRAN (R 3.5.0)                                 
 AICcmodavg  * 2.2-2    2019-05-29 [1] CRAN (R 3.5.2)                                 
 assertthat    0.2.1    2019-03-21 [1] CRAN (R 3.5.2)                                 
 backports     1.1.5    2019-10-02 [1] CRAN (R 3.5.2)                                 
 boot        * 1.3-23   2019-07-05 [1] CRAN (R 3.5.2)                                 
 BRCmap      * 0.10.3.3 2017-11-13 [1] local                                          
 callr         3.3.2    2019-09-22 [1] CRAN (R 3.5.2)                                 
 cli           1.1.0    2019-03-19 [1] CRAN (R 3.5.2)                                 
 coda          0.19-3   2019-07-05 [1] CRAN (R 3.5.2)                                 
 codetools     0.2-16   2018-12-24 [1] CRAN (R 3.5.2)                                 
 colorspace    1.4-1    2019-03-18 [1] CRAN (R 3.5.2)                                 
 cowplot     * 1.0.0    2019-07-11 [1] CRAN (R 3.5.2)                                 
 crayon        1.3.4    2017-09-16 [1] CRAN (R 3.5.0)                                 
 desc          1.2.0    2018-05-01 [1] CRAN (R 3.5.0)                                 
 devtools    * 2.2.1    2019-09-24 [1] CRAN (R 3.5.2)                                 
 digest        0.6.22   2019-10-21 [1] CRAN (R 3.5.2)                                 
 dplyr       * 0.8.3    2019-07-04 [1] CRAN (R 3.5.2)                                 
 ellipsis      0.3.0    2019-09-20 [1] CRAN (R 3.5.2)                                 
 evaluate      0.14     2019-05-28 [1] CRAN (R 3.5.2)                                 
 foreign       0.8-72   2019-08-02 [1] CRAN (R 3.5.2)                                 
 fs            1.3.1    2019-05-06 [1] CRAN (R 3.5.2)                                 
 gdata         2.18.0   2017-06-06 [1] CRAN (R 3.5.0)                                 
 ggplot2     * 3.2.1    2019-08-10 [1] CRAN (R 3.5.2)                                 
 ggthemes    * 4.2.0    2019-05-13 [1] CRAN (R 3.5.2)                                 
 glue          1.3.1    2019-03-12 [1] CRAN (R 3.5.2)                                 
 gridExtra   * 2.3      2017-09-09 [1] CRAN (R 3.5.0)                                 
 gtable        0.3.0    2019-03-25 [1] CRAN (R 3.5.2)                                 
 gtools        3.8.1    2018-06-26 [1] CRAN (R 3.5.0)                                 
 hms           0.5.2    2019-10-30 [1] CRAN (R 3.5.2)                                 
 htmltools     0.4.0    2019-10-04 [1] CRAN (R 3.5.2)                                 
 httr          1.4.1    2019-08-05 [1] CRAN (R 3.5.2)                                 
 kableExtra  * 1.1.0    2019-03-16 [1] CRAN (R 3.5.2)                                 
 knitr       * 1.26     2019-11-12 [1] CRAN (R 3.5.2)                                 
 lattice       0.20-38  2018-11-04 [1] CRAN (R 3.5.2)                                 
 lazyeval      0.2.2    2019-03-15 [1] CRAN (R 3.5.2)                                 
 LearnBayes    2.15.1   2018-03-18 [1] CRAN (R 3.5.0)                                 
 lifecycle     0.1.0    2019-08-01 [1] CRAN (R 3.5.2)                                 
 lme4        * 1.1-21   2019-03-05 [1] CRAN (R 3.5.2)                                 
 magrittr      1.5      2014-11-22 [1] CRAN (R 3.5.0)                                 
 maptools    * 0.9-8    2019-10-05 [1] CRAN (R 3.5.2)                                 
 MASS          7.3-51.4 2019-03-31 [1] CRAN (R 3.5.2)                                 
 Matrix      * 1.2-17   2019-03-22 [1] CRAN (R 3.5.2)                                 
 memoise       1.1.0    2017-04-21 [1] CRAN (R 3.5.0)                                 
 minqa         1.2.4    2014-10-09 [1] CRAN (R 3.5.0)                                 
 munsell       0.5.0    2018-06-12 [1] CRAN (R 3.5.0)                                 
 nlme          3.1-142  2019-11-07 [1] CRAN (R 3.5.2)                                 
 nloptr        1.2.1    2018-10-03 [1] CRAN (R 3.5.0)                                 
 pillar        1.4.2    2019-06-29 [1] CRAN (R 3.5.2)                                 
 pkgbuild      1.0.6    2019-10-09 [1] CRAN (R 3.5.2)                                 
 pkgconfig     2.0.3    2019-09-22 [1] CRAN (R 3.5.2)                                 
 pkgload       1.0.2    2018-10-29 [1] CRAN (R 3.5.0)                                 
 plyr        * 1.8.4    2016-06-08 [1] CRAN (R 3.5.0)                                 
 prettyunits   1.0.2    2015-07-13 [1] CRAN (R 3.5.0)                                 
 processx      3.4.1    2019-07-18 [1] CRAN (R 3.5.2)                                 
 ps            1.3.0    2018-12-21 [1] CRAN (R 3.5.0)                                 
 purrr         0.3.3    2019-10-18 [1] CRAN (R 3.5.2)                                 
 R2jags        0.5-7    2015-08-23 [1] CRAN (R 3.5.0)                                 
 R2WinBUGS     2.1-21   2015-07-30 [1] CRAN (R 3.5.0)                                 
 R6            2.4.1    2019-11-12 [1] CRAN (R 3.5.2)                                 
 raster        3.0-7    2019-09-24 [1] CRAN (R 3.5.2)                                 
 Rcpp          1.0.3    2019-11-08 [1] CRAN (R 3.5.2)                                 
 readr         1.3.1    2018-12-21 [1] CRAN (R 3.5.0)                                 
 remotes       2.1.0    2019-06-24 [1] CRAN (R 3.5.2)                                 
 reshape2    * 1.4.3    2017-12-11 [1] CRAN (R 3.5.0)                                 
 rgdal       * 1.4-7    2019-10-28 [1] CRAN (R 3.5.2)                                 
 rgeos       * 0.5-2    2019-10-03 [1] CRAN (R 3.5.2)                                 
 rjags         4-10     2019-11-06 [1] CRAN (R 3.5.2)                                 
 rlang         0.4.1    2019-10-24 [1] CRAN (R 3.5.2)                                 
 rmarkdown     1.17     2019-11-13 [1] CRAN (R 3.5.2)                                 
 rprojroot     1.3-2    2018-01-03 [1] CRAN (R 3.5.0)                                 
 rstudioapi    0.10     2019-03-19 [1] CRAN (R 3.5.2)                                 
 rvest         0.3.5    2019-11-08 [1] CRAN (R 3.5.2)                                 
 scales        1.1.0    2019-11-18 [1] CRAN (R 3.5.2)                                 
 sessioninfo   1.1.1    2018-11-05 [1] CRAN (R 3.5.0)                                 
 sp          * 1.3-2    2019-11-07 [1] CRAN (R 3.5.2)                                 
 sparta      * 0.2.07   2019-12-19 [1] Github (BiologicalRecordsCentre/sparta@9c4312f)
 stringi       1.4.3    2019-03-12 [1] CRAN (R 3.5.2)                                 
 stringr       1.4.0    2019-02-10 [1] CRAN (R 3.5.2)                                 
 survival      3.1-7    2019-11-09 [1] CRAN (R 3.5.2)                                 
 testthat      2.3.0    2019-11-05 [1] CRAN (R 3.5.2)                                 
 tibble        2.1.3    2019-06-06 [1] CRAN (R 3.5.2)                                 
 tidyselect    0.2.5    2018-10-11 [1] CRAN (R 3.5.0)                                 
 unmarked      0.13-0   2019-11-12 [1] CRAN (R 3.5.2)                                 
 usethis     * 1.5.1    2019-07-04 [1] CRAN (R 3.5.2)                                 
 vctrs         0.2.0    2019-07-05 [1] CRAN (R 3.5.2)                                 
 VGAM          1.1-1    2019-02-18 [1] CRAN (R 3.5.2)                                 
 viridis     * 0.5.1    2018-03-29 [1] CRAN (R 3.5.0)                                 
 viridisLite * 0.3.0    2018-02-01 [1] CRAN (R 3.5.0)                                 
 webshot       0.5.1    2018-09-28 [1] CRAN (R 3.5.0)                                 
 withr         2.1.2    2018-03-15 [1] CRAN (R 3.5.0)                                 
 xfun          0.11     2019-11-12 [1] CRAN (R 3.5.2)                                 
 xml2          1.2.2    2019-08-09 [1] CRAN (R 3.5.2)                                 
 xtable        1.8-4    2019-04-21 [1] CRAN (R 3.5.2)                                 
 yaml          2.2.0    2018-07-25 [1] CRAN (R 3.5.0)                                 
 zeallot       0.1.0    2018-01-28 [1] CRAN (R 3.5.0) 
 ```
