# Scientific figure-making workshop 2021
### 03/12/2021, Center for Evolutionary Hologenomics
Data, scripts and documentation of the scientific figure-making workshop

## Install/load libraries
````R
library(vegan)
library(nlme)
library(ggplot2)
````

## Load data
````R
setwd("~/github/figure_workshop_2021/")
counts <- read.csv("data/counts.csv",row.names=1)
metadata <- read.csv("data/metadata.csv",row.names=1)
````

## Calculate diversity statistics
````R
shannon_div <- t(t(exp(diversity(counts, index = "shannon", MARGIN = 2))))
shannon_div <- merge(shannon_div,metadata,by="row.names")
colnames(shannon_div)[1:2] <- c("Sample","Shannon")
````
# Does overall diversity change between species?
````R
wilcox.test(Shannon ~ Species, data = shannon_div)
````
# Does overall diversity change between origins?
````R
summary(lme(Shannon ~ Origin, random=~1|Individual/Species, data=shannon_div))
````

# Calculate pairwise dissimilarity values
````R
bray_dist <- vegdist(t(counts), method="bray", binary=FALSE)
````

# Does the composition change by species and origin?
````R
bray_dist <- adonis(data = bray_dist)
adonis2(bray_dist ~ Species/Origin, data = metadata)
````
