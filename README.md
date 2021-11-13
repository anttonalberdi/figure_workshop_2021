# Scientific figure-making workshop 2021
### 03/12/2021, Center for Evolutionary Hologenomics
Data, scripts and documentation of the scientific figure-making workshop

#Preparations

## Download repository
All the documentation required for the workshop is in this Github repository. In order to download it, you need to click the green button on the top-right of the page that says "Code", and then select the "Download ZIP" option. This will download the entire repository to your local computer. Once you decompress the ZIP file, you will find all the contents in a folder called "figure_workshop_2021".

## Install and open R or RStudio
R: https://www.r-project.org/
RStudio: https://www.rstudio.com/

## Install/load libraries
````R
library(vegan)
library(nlme)
library(ggplot2)
````

#Homework assignment
The homework assignment will consist of the following:
````py
We analysed...
````

#Pipeline used to generate results

## Load data
The only change you need to make to the code in this repository is to adjust the "setwd" parameter with the absolute path to the folder you unzipped from the file  downloaded from github. If you don't know the path, right-click the folder and find information about its exact location in your computer.

````R
setwd("~/github/figure_workshop_2021/") #this needs to be changed
counts <- read.csv("data/counts.csv",row.names=1)
metadata <- read.csv("data/metadata.csv",row.names=1)
````

## Calculate diversity statistics
In this first step we will create a table containing the Shannon diversity values (exponential of the Shannon index, or Hill number of q=1) and the relevant metadata we will use for statistics and visualisations.

````R
shannon_div <- t(t(exp(diversity(counts, index = "shannon", MARGIN = 2))))
shannon_div <- merge(shannon_div,metadata,by="row.names")
colnames(shannon_div)[1:2] <- c("Sample","Shannon")
head(shannon_div)
````
# Does overall diversity change between species?
We will run a Wilcoxon signed-rank test to  

````R
wilcox.test(Shannon ~ Species, data = shannon_div)
````
````py
RESULTS
Wilcoxon rank sum exact test
data:  Shannon by Species
W = 856, p-value = 7.593e-12

As p-value < 0.05 we accept that there are diversity differences between species (regardless of origin).
````
# Does overall diversity change between origins?
````R
summary(lme(Shannon ~ Origin, random=~1|Individual/Species, data=shannon_div))
````
````py
RESULTS
Fixed effects:  Shannon ~ Origin
               Value Std.Error DF  t-value p-value
(Intercept) 41.80053  9.810341 29 4.260864  0.0002
OriginWild  34.80076 10.516611 29 3.309123  0.0025

As p-value of Origin is < 0.05 we accept that there are diversity differences between origins (factoring individuals and species).
````
# Calculate pairwise dissimilarity values
````R
bray_dist <- vegdist(t(counts), method="bray", binary=FALSE)
````

# Does the composition change by species and origin?
````R
bray_dist <- adonis(data = bray_dist)
adonis2(bray_dist ~ Origin/Species, data = metadata)
````
````py
RESULTS
Df SumOfSqs      R2      F Pr(>F)    
Origin          1   1.7092 0.06563 4.8451  0.001 ***
Origin:Species  2   4.5768 0.17575 6.4870  0.001 ***
Residual       56  19.7551 0.75861                  
Total          59  26.0410 1.00000    

As p-value of Species is < 0.05 we accept that the composition differs between species.        
As p-value of Species:Origin is < 0.05 we accept that the composition differs between origins.   
````
