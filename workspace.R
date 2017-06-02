library(flowCore)
in_file<-"data\\20161222-10012 U2OS_SET8.fcs"

flowCore::isFCSfile("data\\20161222-10012 U2OS_SET8.fcs")

sample <- flowCore::read.FCS(in_file, transformation = FALSE)


lgcl <- logicleTransform( w = 0.5, t = 262144, m =10)
lgcl <- estimateLogicle(sample, channels = c("PI-Cells-Intensity", "AF647-H3S10p-Cells-Intensity"), m = 5.5)
sample <- transform(sample, lgcl)


exprs_all <- exprs(sample)

rg <- rectangleGate(filterId="Region of Interest", "PI-Cells-Intensity"=c(4.75, 5), "AF647-H3S10p-Cells-Intensity"=c(3.5, Inf))

result = filter(sample,rg)
summary(result)
## Fluorescence Region+: 9811 of 10000 events (98.11%)
summary(result)$n
## [1] 10000
summary(result)$true
## [1] 9811
summary(result)$p
sample2 <- Subset(sample, rg)

exprs_all_2 <- exprs(sample2)

kg <- filter(sample, kmeansFilter("PI-Cells-Intensity"=c("Low", "Middle", "High"), filterId="myKMeans"))
summary(kg)
ksample <- split(sample, kg)
sample <- ksample$High

exprs_all <- flowCore::exprs(sample)

x <- exprs_all_2[, 3]
y <- exprs_all[, 27]
x4 <- x[x > 4]
y4 <- y[x > 4]



