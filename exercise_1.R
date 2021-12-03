#Set working directory
setwd("/Users/anttonalberdi/github/figure_workshop_2021")

#Load libraries
library(vegan)

#Load data
counts <- read.csv("data/counts.csv",row.names=1)
metadata <- read.csv("data/metadata.csv",row.names=1)
metadata$Group <- paste(metadata$Species,metadata$Origin,sep="_")

#Compute diversities
shannon_div <- t(t(exp(diversity(counts, index = "shannon", MARGIN = 2))))
shannon_div <- merge(shannon_div,metadata,by="row.names")
colnames(shannon_div)[1:2] <- c("Sample","Shannon")

#Compute dissimilarities
bray_dist <- vegdist(t(counts), method="bray", binary=FALSE)

##########################
# Box plot between species
##########################

#Simple boxplot using base plotting method
boxplot(Shannon ~ Species, data=shannon_div)

#Boxplot using ggplot2
#http://r-statistics.co/Complete-Ggplot2-Tutorial-Part1-With-R-Code.html
library(ggplot2)
ggplot(shannon_div, aes(x=Species, y=Shannon)) +
  geom_boxplot()

#Change orientation using cord_flip
#Q: When is it adviced to flip the orientation?
ggplot(shannon_div, aes(x=Species, y=Shannon)) +
  geom_boxplot() +
  coord_flip()

#Boxplot with overlay of dots (jitter plot)
#Requested by some journals
#We will need to find a balance between the boxplot and the jitterplot. Let's go step by step.
ggplot(shannon_div, aes(x=Species, y=Shannon)) +
  geom_boxplot() +
  geom_jitter(shape=16, position=position_jitter(0.2))

#Narrower jitter plot
ggplot(shannon_div, aes(x=Species, y=Shannon)) +
  geom_boxplot() +
  geom_jitter(shape=16, position=position_jitter(0.1))

#The order matters
#Elements are overlayed in order: first boxplot, then jitterplot
ggplot(shannon_div, aes(x=Species, y=Shannon)) +
  geom_jitter(shape=16, position=position_jitter(0.2)) +
  geom_boxplot()

#Simplify background using light theme
ggplot(shannon_div, aes(x=Species, y=Shannon)) +
  geom_jitter(shape=16, position=position_jitter(0.2)) +
  geom_boxplot() +
  theme_light()

#Simplify even more
ggplot(shannon_div, aes(x=Species, y=Shannon)) +
  geom_jitter(shape=16, position=position_jitter(0.2)) +
  geom_boxplot() +
  theme_light() +
  theme(axis.line = element_line(colour = "grey"),
        panel.grid.major = element_blank(),
        panel.grid.minor = element_blank(),
        panel.border = element_blank(),
        panel.background = element_blank())

#Let's give it some colour
ggplot(shannon_div, aes(x=Species, y=Shannon, color=Species)) +
  geom_boxplot() +
  geom_jitter(shape=16, position=position_jitter(0.2)) +
  theme_light() +
  theme(axis.line = element_line(colour = "grey"),
        panel.grid.major = element_blank(),
        panel.grid.minor = element_blank(),
        panel.border = element_blank(),
        panel.background = element_blank())

#Let's give it some colour
#Argument "color" sets contours
ggplot(shannon_div, aes(x=Species, y=Shannon, color=Species)) +
  geom_boxplot() +
  geom_jitter(shape=16, position=position_jitter(0.2)) +
  scale_color_manual(values=c("#E69F00", "#56B4E9")) +
  theme_light() +
  theme(axis.line = element_line(colour = "grey"),
        panel.grid.major = element_blank(),
        panel.grid.minor = element_blank(),
        panel.border = element_blank(),
        panel.background = element_blank())

#Let's give it more colour
#Argument "fill" sets inner areas
ggplot(shannon_div, aes(x=Species, y=Shannon, color=Species, fill=Species)) +
  geom_boxplot() +
  geom_jitter(shape=16, position=position_jitter(0.2)) +
  scale_color_manual(values=c("#E69F00", "#56B4E9")) +
  scale_fill_manual(values=c("#E69F00", "#56B4E9")) +
  theme_light() +
  theme(axis.line = element_line(colour = "grey"),
        panel.grid.major = element_blank(),
        panel.grid.minor = element_blank(),
        panel.border = element_blank(),
        panel.background = element_blank())

#Transparency is handy to create nice layouts!
#20% transparency of fill #E69F00 > #E69F0020
#20% transparency of fill #56B4E9 > #56B4E920
#30% of transparency of jitter
ggplot(shannon_div, aes(x=Species, y=Shannon, color=Species, fill=Species)) +
  geom_boxplot() +
  geom_jitter(shape=16, position=position_jitter(0.2), alpha=0.3) +
  scale_color_manual(values=c("#E69F00", "#56B4E9")) +
  scale_fill_manual(values=c("#E69F0020", "#56B4E920")) +
  theme_light() +
  theme(axis.line = element_line(colour = "grey"),
        panel.grid.major = element_blank(),
        panel.grid.minor = element_blank(),
        panel.border = element_blank(),
        panel.background = element_blank())

#Another complementary combination
#Q: Any criticism?
ggplot(shannon_div, aes(x=Species, y=Shannon, color=Species, fill=Species)) +
  geom_boxplot() +
  geom_jitter(shape=16, position=position_jitter(0.2), alpha=0.3) +
  scale_color_manual(values=c("#b0d6b5", "#d9bbb4")) +
  scale_fill_manual(values=c("#b0d6b520", "#d9bbb420")) +
  theme_light() +
  theme(axis.line = element_line(colour = "grey"),
        panel.grid.major = element_blank(),
        panel.grid.minor = element_blank(),
        panel.border = element_blank(),
        panel.background = element_blank())

#Change order of groups
shannon_div$Species <- as.factor(shannon_div$Species)
shannon_div$Species <- factor(shannon_div$Species, levels = c("Crocidura_russula", "Apodemus_sylvaticus"))

ggplot(shannon_div, aes(x=Species, y=Shannon, color=Species, fill=Species)) +
  geom_boxplot() +
  geom_jitter(shape=16, position=position_jitter(0.2)) +
  scale_color_manual(values=c("#E69F00", "#56B4E9")) +
  scale_fill_manual(values=c("#E69F0020", "#56B4E920")) +
  theme_light() +
  theme(axis.line = element_line(colour = "grey"),
        panel.grid.major = element_blank(),
        panel.grid.minor = element_blank(),
        panel.border = element_blank(),
        panel.background = element_blank())

### Boxplot with statistical support ###

library(ggpubr)

#Save basal plot for making code simpler
basalplot <- ggplot(shannon_div, aes(x=Species, y=Shannon, color=Species, fill=Species)) +
  geom_boxplot() +
  geom_jitter(shape=16, position=position_jitter(0.2), alpha=0.3) +
  scale_color_manual(values=c("#E69F00", "#56B4E9")) +
  scale_fill_manual(values=c("#E69F0020", "#56B4E920")) +
  theme_light() +
  theme(axis.line = element_line(colour = "grey"),
        panel.grid.major = element_blank(),
        panel.grid.minor = element_blank(),
        panel.border = element_blank(),
        panel.background = element_blank())

#Run statistical test
compare_means(Shannon ~ Species,  data = shannon_div)

#Add test result to basal plot
basalplot + stat_compare_means(comparisons = list(c("Apodemus_sylvaticus", "Crocidura_russula")))

### Save boxplot ###

#let's export the chart
pdf("figures/species_boxplot_small.pdf",width=10, height=6)
basalplot + stat_compare_means(comparisons = list(c("Apodemus_sylvaticus", "Crocidura_russula")))
dev.off()

#let's make it bigger
statplot <- basalplot + stat_compare_means(comparisons = list(c("Apodemus_sylvaticus", "Crocidura_russula")))

pdf("figures/species_boxplot_large.pdf",width=5, height=3)
statplot
dev.off()

##########################
# Paired boxplot
##########################

#Prepare data frame
shannon_div_apodemus <- shannon_div[shannon_div$Species == "Apodemus_sylvaticus",]
shannon_div_apodemus$Origin <- as.factor(shannon_div_apodemus$Origin)
shannon_div_apodemus$Origin <- factor(shannon_div_apodemus$Origin, levels = c("Wild", "Captive"))

#By modifying the previous code we get:
ggplot(shannon_div_apodemus, aes(x=Origin, y=Shannon, color=Origin, fill=Origin)) +
  geom_boxplot() +
  geom_jitter(shape=16, position=position_jitter(0.2), alpha=0.3) +
  scale_color_manual(values=c("#E69F00", "#56B4E9")) +
  scale_fill_manual(values=c("#E69F0020", "#56B4E920")) +
  theme_light() +
  theme(axis.line = element_line(colour = "grey"),
        panel.grid.major = element_blank(),
        panel.grid.minor = element_blank(),
        panel.border = element_blank(),
        panel.background = element_blank())

#Let's add pairing lines
ggplot(shannon_div_apodemus, aes(x=Origin, y=Shannon, color=Origin, fill=Origin)) +
  geom_boxplot() +
  geom_jitter(shape=16, position=position_jitter(0.2), alpha=0.3) +
  scale_color_manual(values=c("#E69F00", "#56B4E9")) +
  scale_fill_manual(values=c("#E69F0020", "#56B4E920")) +
  geom_line(aes(group = Individual)) +
  theme_light() +
  theme(axis.line = element_line(colour = "grey"),
        panel.grid.major = element_blank(),
        panel.grid.minor = element_blank(),
        panel.border = element_blank(),
        panel.background = element_blank())

#Let's fix style issues
## Remove boxplot (cleaner)
## Remove jitter (redundant)
## Fix colors

ggplot(shannon_div_apodemus, aes(x=Origin, y=Shannon, color=Origin, fill=Origin)) +
  geom_point() +
  scale_color_manual(values=c("#b0d6b5", "#d9bbb4")) +
  scale_fill_manual(values=c("#E69F0020", "#56B4E920")) +
  geom_line(aes(group = Individual), color="grey") +
  theme_light() +
  theme(axis.line = element_line(colour = "grey"),
        panel.grid.major = element_blank(),
        panel.grid.minor = element_blank(),
        panel.border = element_blank(),
        panel.background = element_blank())

#Emphasize increases and decreases
head(shannon_div_apodemus)

trendvector <- c()
for (i in seq(2,nrow(shannon_div_apodemus),2)){
  dif <- shannon_div_apodemus$Shannon[i]-shannon_div_apodemus$Shannon[i-1]
  if(dif > 0) {
  value <- "Increasing"
  } else {
    if(dif == 0) {
      value <- "Even"
    } else {
      value <- "Decreasing"
    }}
    trendvector <- c(trendvector,value,value)
}

shannon_div_apodemus$Trend  <- as.factor(trendvector)
head(shannon_div_apodemus)

ggplot(shannon_div_apodemus, aes(x=Origin, y=Shannon,)) +
  geom_point(colour="grey", alpha=0.5) +
  geom_line(aes(group = Individual, color=Trend)) +
  scale_color_manual(values=c("#d9bbb4", "#b0d6b5")) +
  theme_light() +
  theme(axis.line = element_line(colour = "grey"),
        panel.grid.major = element_blank(),
        panel.grid.minor = element_blank(),
        panel.border = element_blank(),
        panel.background = element_blank())

#Let's do the same for Crocidura
shannon_div_crocidura <- shannon_div[shannon_div$Species == "Crocidura_russula",]
shannon_div_crocidura$Origin <- as.factor(shannon_div_crocidura$Origin)
shannon_div_crocidura$Origin <- factor(shannon_div_crocidura$Origin, levels = c("Wild", "Captive"))
trendvector <- c()
for (i in seq(2,nrow(shannon_div_crocidura),2)){
  dif <- shannon_div_crocidura$Shannon[i]-shannon_div_crocidura$Shannon[i-1]
  if(dif > 0) {
    value <- "Increasing"
  } else {
    if(dif == 0) {
      value <- "Even"
    } else {
      value <- "Decreasing"
    }}
  trendvector <- c(trendvector,value,value)
}
shannon_div_crocidura$Trend  <- as.factor(trendvector)

#Let's plot both charts (with adjusted Y axis, and icons)
apodemus <- ggplot(shannon_div_apodemus, aes(x=Origin, y=Shannon, shape=Origin)) +
  geom_point(colour="#E69F00", alpha=0.5) +
  geom_line(aes(group = Individual, color=Trend)) +
  scale_color_manual(values=c("#d9bbb4", "#b0d6b5")) +
  ylim(0, 250) +
  theme_light() +
  theme(axis.line = element_line(colour = "grey"),
        panel.grid.major = element_blank(),
        panel.grid.minor = element_blank(),
        panel.border = element_blank(),
        panel.background = element_blank())

crocidura <- ggplot(shannon_div_crocidura, aes(x=Origin, y=Shannon, shape=Origin)) +
  geom_point(colour="#56B4E9", alpha=0.5) +
  geom_line(aes(group = Individual, color=Trend)) +
  scale_color_manual(values=c("#d9bbb4", "#b0d6b5")) +
  ylim(0, 250) +
  theme_light() +
  theme(axis.line = element_line(colour = "grey"),
        panel.grid.major = element_blank(),
        panel.grid.minor = element_blank(),
        panel.border = element_blank(),
        panel.background = element_blank())

pdf("figures/paired_boxplot_apodemus.pdf",width=4, height=4)
apodemus
dev.off()

pdf("figures/paired_boxplot_crocidura.pdf",width=4, height=4)
crocidura
dev.off()

##########################
# Non-metric multidimensional scaling
##########################

#Generate and prepare data
nmds <- metaMDS(bray_dist,k=2,trymax=100)
NMDS=data.frame(x=nmds$point[,1],y=nmds$point[,2])
NMDS <- merge(NMDS,metadata,by="row.names")
head(NMDS)

#First nmds plot!
ggplot(NMDS, aes(x=x,y=y,colour=Species)) +
    geom_point()

#Let's add colours and remove grid
nmds_simple <- ggplot(NMDS, aes(x=x,y=y,colour=Group, shape=Origin)) +
    scale_color_manual(values=c("#C1BE30","#C1BE3070", "#8A2D19", "#8A2D1970")) +
    geom_point() +
    theme_light() +
    theme(axis.line = element_line(colour = "grey"),
        panel.grid.major = element_blank(),
        panel.grid.minor = element_blank(),
        panel.border = element_blank(),
        panel.background = element_blank(),
        axis.title=element_blank())

pdf("figures/nmds_simple.pdf",width=7, height=3)
nmds_simple
dev.off()

#Let's add centroids to make the contrast more clear
NMDS.centroids=aggregate(NMDS[,c(2:3)],by=list(NMDS$Group),FUN=mean)
colnames(NMDS.centroids) <- c("Group","x_cen","y_cen")
NMDS=merge(NMDS,NMDS.centroids,by="Group")

#Change factor order
NMDS$Origin <- as.factor(NMDS$Origin)
NMDS$Origin <- factor(NMDS$Origin, levels = c("Wild","Captive"))

nmds_centroids <- ggplot(NMDS, aes(x=x,y=y,colour=Group, shape=Origin)) +
    geom_point(size=2) +
    scale_color_manual(values=c("#E69F00","#E69F0070", "#56B4E9", "#56B4E970")) +
    geom_point(aes(x=x_cen,y=y_cen),alpha=0) +
    geom_segment(aes(x=x_cen, y=y_cen, xend=x, yend=y), alpha=0.2) +
    theme_light() +
    theme(axis.line = element_line(colour = "grey"),
        panel.grid.major = element_blank(),
        panel.grid.minor = element_blank(),
        panel.border = element_blank(),
        panel.background = element_blank(),
        axis.title=element_blank())

pdf("figures/nmds_centroids.pdf",width=7, height=3)
nmds_centroids
dev.off()
