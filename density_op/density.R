library(flowCore)
library(rtercen)
library(Biobase)

# client = TercenClient$new("XXX", "YYY")
# execute the query and get the data
# workflowId = 'd640063c135adb5d0022ff5c0725d271'
# stepId =     'cc3139f0-3690-11e7-d873-93f9f9418b15'
# query = client$getCubeQuery(workflowId, stepId)


query = TercenClient$new()$getCubeQuery()

# execute the query and get the data
df <- query$execute()$sourceTable$as.data.frame()
 

data = reshape2::acast(df, .rindex ~ .cindex, value.var='.values',fun.aggregate=mean)

n <- ncol(data)
col_names <- unlist(Map(paste0, rep("c", n), 1:n), use.names = FALSE)
colnames(data) <- col_names


# calculate density
nbin = 128

map <- grDevices:::.smoothScatterCalcDensity(data, nbin = nbin)
xm <- map$x1
ym <- map$x2
dens <- map$fhat

# transformation the density 
transformation = function(x) x^0.25
dens <- transformation(dens)

# image(xm, ym, dens)

# starting organizing the data structures for returing the result to tercen
# make sure xp, yp are the same size and ordering to match the dens matrix
yp <- rep(ym, nbin)
xp <- rep(xm, nbin)
yp<- yp[order(yp, decreasing = TRUE)]

# reshape the density values as a long matrix with one col
dim(dens) <- c(nbin * nbin, 1)

# calculate ids, note the lack of relationship between input ids and output ids
ids <- 0:((nbin * nbin)-1)

# add output
data_out <- data.frame(xp = xp, yp = yp, dens = dens, .ids = ids)

#send data back to tercen

query$setResult(data_out)

