# Scientific figure-making workshop 2021
### 03/12/2021, Center for Evolutionary Hologenomics
Dear all, welcome to the Github repository of the scientific figure-making workshop 2021. All the documentation required for the workshop is, or will be, in this Github repository. Please, read through this introductory document to find your way to the relevant data, tools and assignments. This introductory document includes the following contents.

1) **Preparations**: get ready for the workshop.
2) **Homework assignment**: explanation, text and code required for the assignment.
3) **R pipeline**: code used for generating the results.

# Preparations

## Install and open R or RStudio
- R: https://www.r-project.org/
- RStudio: https://www.rstudio.com/

## Install/load libraries
For installing the libraries (if they were not installed before):
````R
install.packages("vegan")
install.packages("ggplot2")
install.packages("ggpubr")
````
Note that some libraries have many dependencies (other libraries that are required), so the installation might take a few minutes.

For loading the libraries (if already installed):
````R
library(vegan)
library(ggplot2)
library(ggpubr)
````

## Download repository
You will be able to generate the results and data for the homework assignment through running the R code shown in the end of this document. The easiest way to run the exercise is to download this repository to your local computer. In order to download it, you need to click the green button on the top-right of the page that says "Code", and then select the "Download ZIP" option. This will download the entire repository to your local computer. Once you decompress the ZIP file, you will find all the contents in a folder called "figure_workshop_2021". This folder should be your working directory. You can leave it in the Downloads folder, or you might want to move it elsewhere. Be aware that you will need to define the absolute path to this folder in R (you will find more detailed explanations below).

# Homework assignment
Before the workshop you will be requested to do some home work. The figure(s) you create before the workshop will be anonimously shared with the rest of the attendees and used during the course to identify the strengths and the weaknesses of the various figures created. Even the slightest effort you do to run the home work will be useful to improve the quality of the workshop, so I fully encourage you to spend 1-2h working on this assignment within the two weeks before the workshop. 

## Assignment
Below you will find a short text about the methods and results of a research study. Your task will be to draw the figure(s) (whatever you consider relevant or necessary) to support that text. You are welcome to use any tool for that, including R, Excel, Numbers, Adobe Illustrator, Inkscape, Microsoft Paint or any other tool you know. Yes, the assignment is as open as it seems. Draw one or multile figures, single or composite, as you consider relevant. Create figure notes as well. Then, include the figure references in the best place in the provided text (e.g., Figure 1, Figure 2b, etc.). Finally, add the text and the figure(s) to a Word document, and send it to antton.alberdi@sund.ku.dk before **December 1st, 2021** (the sooner the better so I can better prepare the discussions during the workshop). You will find the raw data and the script for generating the results below.

## Text
> METHODS
>
> We captured a total of 30 individuals belonging to two small mammal species, namely Apodemus sylvaticus (N=15) and Crocidura russula (N=15). The captured animals were taken into an experimentation facility where they were kept for 5 weeks to study the effect of captivity in the diversity and composition of their gut microbiota. Faecal samples were collected at day 1 and day 35, and named 'wild' and 'captive', respectively. Sequencing libraries were generated using a double-PCR protocol and gut microbiota profiles were generated using the standard DADA2 pipeline.
>/
> Microbial diversity (alpha diversity) of each sample was calculated by means of Shannon diversity (= Hill number of q=1, or exp(Shannon index) using the R package vegan). Overall diversity differences between species were calculated using a Wilcoxon signed-rank test. Whether and how captivity modified the microbial diversity in each species was studied using paired Wilcoxon tests.
>
> Compositional dissimilarity (beta diversity across samples) was calculated by means of Bray-Curtis distances among samples. Whether the composition changed according to species and origin was studies using permutational multivariate analysis of variance as implemented in the R package vegan.
>
> Full code used for generating the results can be found below.
>
> RESULTS
>
> The overall microbial diversity of both species was different (W = 856, p-value < 0.01), A. sylvaticus' diversity being higher (98.7±51.9) than that of C. russula (19.6±21.4). Captivity induced a significant diversity drop in both species (A. syvaticus: V = 17, p-value < 0.01; C. russula: V = 6, p-value < 0.01).
>
> Compositional differences were also significant both for species (R2 = 0.065, F = 4.845, p-value < 0.001) and origin of samples (R2 = 0.175, F = 6.487, p-value<0.001).
>
> CONCLUSION
>
> We conclude that captivity induces a significant change in the microbial communities of the two studied species.

# Pipeline used to generate results
Note that the statistical approach employed can be improved. It has been simplified to focus the assignment on the figure making rather than the actual analysis.

## Set the working directory
The only change you need to make to the code in this repository is to adjust the "setwd" parameter with the absolute path to the folder you unzipped from the file downloaded from github. If you don't know the path, right-click the folder and find information about its exact location in your computer. The rest of the code should work by copy-pasting it directly to the R command line.

````R
setwd("~/Downloads/figure_workshop_2021-main/figure_workshop_2021-main/") #Mac example. You will need to modify this
setwd("C:/Users/XXXXX/Downloads/figure_workshop_2021-main/figure_workshop_2021-main/") #Windows example. You will need to modify this. Use slashes (/) rather than backslashes (\) in the path, as otherwise R will most probably complain. 
````
## Load libraries
For installing the libraries (if they were not installed before):
````R
install.packages("vegan")
install.packages("ggplot2")
install.packages("ggpubr")
````

For loading the libraries (if already installed):
````R
library(vegan)
library(ggplot2)
library(ggpubr)
````

## Load data
If the directory has been set properly, these data files should be loaded.
````R
counts <- read.csv("data/counts.csv",row.names=1)
metadata <- read.csv("data/metadata.csv",row.names=1)
head(counts) #visualise first 6 lines
head(metadata) #visualise first 6 lines
````

## Calculate diversity statistics
In this first step we will create a table containing the Shannon diversity values and the relevant metadata we will use for statistics and visualisations.

````R
shannon_div <- t(t(exp(diversity(counts, index = "shannon", MARGIN = 2))))
shannon_div <- merge(shannon_div,metadata,by="row.names")
colnames(shannon_div)[1:2] <- c("Sample","Shannon")
#Show table structure
head(shannon_div)
#Save table
write.csv(shannon_div,"results/shannon_div.csv")
````
# Does overall diversity change between species?
We will run a Wilcoxon signed-rank test to  

````R
#Group means
aggregate(shannon_div$Shannon, by=list(shannon_div$Species), FUN=mean)
#Group sd
aggregate(shannon_div$Shannon, by=list(shannon_div$Species), FUN=sd)
#Group quartiles
by(shannon_div$Shannon, shannon_div$Species, summary)
#Wilcoxon test
wilcox.test(Shannon ~ Species, data = shannon_div)
````
````py
RESULTS
Wilcoxon rank sum exact test
data:  Shannon by Species
W = 856, p-value = 7.593e-12

As p-value < 0.05 we accept that there are diversity differences between species (regardless of origin).
````

# Does captivity produce diversity changes in both species?
````R
#Apodemus sylvaticus
wilcox.test(Shannon ~ Origin, paired=TRUE, data=shannon_div[shannon_div$Species == "Apodemus_sylvaticus",])
#Crocidura russula
wilcox.test(Shannon ~ Origin, paired=TRUE, data=shannon_div[shannon_div$Species == "Crocidura_russula",])
````

````py
RESULTS
# Apodemus sylvaticus
V = 17, p-value = 0.01245
alternative hypothesis: true location shift is not equal to 0
# Crocidura russula
V = 6, p-value = 0.0008545
alternative hypothesis: true location shift is not equal to 0

As in both cases p-value is < 0.05 we accept that there are diversity differences between origins.
````

# Calculate pairwise dissimilarity values
````R
bray_dist <- vegdist(t(counts), method="bray", binary=FALSE)
#Save distance matrix
write.csv(bray_dist,"results/bray_dist.csv")
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
