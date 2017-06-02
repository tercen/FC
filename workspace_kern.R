library(KernSmooth)

library(flowCore)
in_file<-"data\\20161222-10012 U2OS_SET8.fcs"

flowCore::isFCSfile("data\\20161222-10012 U2OS_SET8.fcs")

sample <- flowCore::read.FCS(in_file, transformation = FALSE)


lgcl <- logicleTransform( w = 0.5, t = 262144, m =10)
lgcl <- estimateLogicle(sample, channels = c("PI-Cells-Intensity", "AF647-H3S10p-Cells-Intensity"), m = 5.5)
sample <- transform(sample, lgcl)


exprs_all <- exprs(sample)

x <- exprs_all[, 3]
y <- exprs_all[, 27]
x4 <- x[x > 4]
y4 <- y[x > 4]


data(geyser, package="MASS")
x <- cbind(geyser$duration, geyser$waiting)
est <- bkde2D(x, bandwidth=c(0.7, 7))
contour(est$x1, est$x2, est$fhat)
persp(est$fhat)

x <-cbind(x4,y4)
est <- bkde2D(x, bandwidth=c(.1, 1))
contour(est$x1, est$x2, est$fhat)
persp(est$fhat)

data(geyser, package="MASS")
x <- geyser$duration
est <- bkde(x, bandwidth=0.25)
plot(est, type="l")

d <- cbind(x4, y4)

smoothScatter(d)
map <- grDevices:::.smoothScatterCalcDensity(d, nbin=128)
xm <- map$x1
ym <- map$x2
dens <- map$fhat
transformation = function(x) x^0.25
dens[] <- transformation(dens)

image(xm, ym, z = dens)


x1  <- matrix(rnorm(1e3), ncol = 2)
x2  <- matrix(rnorm(1e3, mean = 3, sd = 1.5), ncol = 2)
x   <- rbind(x1, x2)

dcols <- densCols(x)
graphics::plot(x, col = dcols, pch = 20, main = "n = 1000")

graphics::plot(x,pch = 20, main = "n = 1000")


t <- cbind(x=1:1000, y=1:1000)
plot(t)

map <- grDevices:::.smoothScatterCalcDensity(t, nbin=100)
xm <- map$x1
ym <- map$x2
dens <- map$fhat
transformation = function(x) x^0.25
dens[] <- transformation(dens)

image(xm, ym, z = dens)
plot(xm,ym)



