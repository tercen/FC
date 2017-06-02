library(flowCore)
library(rtercen)
library(Biobase)
library(cytofkit)

# client = TercenClient$new("XXX", "YYY")
# workflowId = 'd640063c135adb5d0022ff5c0725d271'
# stepId =     'f44892f0-3690-11e7-90d9-cd77e87615ce'

# query = client$getCubeQuery(workflowId, stepId)
query = TercenClient$new()$getCubeQuery()

# execute the query and get the data
df <- query$execute()$sourceTable$as.data.frame()

data = reshape2::acast(df, .rindex ~ .cindex, value.var='.values',fun.aggregate=mean)


n <- ncol(data)
col_names <- unlist(Map(paste0, rep("c", n), 1:n), use.names = FALSE)
colnames(data) <- col_names

data_tsne <- cytof_dimReduction(data=data, method = "tsne")


plot(data_tsne)

cluster <- cytof_cluster(ydata = data_tsne,  method="ClusterX")
names(cluster)<-NULL
cluster <- as.numeric(cluster)

#work out ids
ids <- 0:(nrow(df)-1)
ids <- matrix(data = ids, nrow = nrow(data), ncol= ncol(data), byrow  = TRUE)
ids <- reshape2::melt(ids)
ids <- ids[[3]]

#reshape results
data_out <- data.frame(cluster = cluster, tsne1 = data_tsne[, 1], tsne2 = data_tsne[,2], .ids = ids, row.names = NULL)


#send data back to tercen
query$setResult(data_out)

