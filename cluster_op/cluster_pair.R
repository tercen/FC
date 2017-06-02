library(flowCore)
library(rtercen)
library(Biobase)
library(cytofkit)


# client = TercenClient$new("XXX", "YYY")
# workflowId = 'd640063c135adb5d0022ff5c0725d271'
# stepId =     'f2ce90d0-3690-11e7-c823-770f534f1def'

# query = client$getCubeQuery(workflowId, stepId)
query = TercenClient$new()$getCubeQuery()


# execute the query and get the data
df <- query$execute()$sourceTable$as.data.frame()

data <- data.frame(tsne1 = df$.values, tsne2 = df$.x)

plot(df$.values, df$.x)

cluster <- cytof_cluster(ydata = data,  method="ClusterX")
cluster_cells <- names(cluster)
names(cluster)<-NULL
cluster <- as.character(cluster)

#work out ids
ids <-as.integer(rep(0, nrow(df)))

#reshape results
data_out <- data.frame(cell_no = cluster_cells, cluster = cluster, tsne1 = data$tsne1, tsne2 = data$tsne2, .ids = ids)


#send data back to tercen

query$setResult(data_out)

