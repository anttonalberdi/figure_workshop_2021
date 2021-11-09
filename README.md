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
````html
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
````
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
````
RESULTS
Df SumOfSqs      R2      F Pr(>F)    
Origin          1   1.7092 0.06563 4.8451  0.001 ***
Origin:Species  2   4.5768 0.17575 6.4870  0.001 ***
Residual       56  19.7551 0.75861                  
Total          59  26.0410 1.00000    

As p-value of Species is < 0.05 we accept that the composition differs between species.        
As p-value of Species:Origin is < 0.05 we accept that the composition differs between origins.   
````
