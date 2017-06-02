library(flowCore)
library(rtercen)
library(Biobase)



query = TercenClient$new()$getCubeQuery()


# execute the query and get the data

df <- query$execute()$sourceTable$as.data.frame()


data = reshape2::acast(df, .rindex ~ .cindex, value.var='.values',fun.aggregate=mean)

n <- ncol(data)
col_names <- unlist(Map(paste0, rep("c", n), 1:n), use.names = FALSE)
colnames(data) <- col_names


# create a frame class

create_params <- function (in_data, in_col_names){
  n <- ncol(in_data)
  df <- data.frame(name=in_col_names, desc = rep("channel", n), range = range(data), minRange = min(data), maxRange = max(data), row.names=in_col_names)
  params <- new("AnnotatedDataFrame", data= df )
}

params <- create_params(data, col_names)
frame <- flowCore::flowFrame(exprs=data, params, description=list())

# transform  parameters using the estimated logicle transformation
lgcl <- flowCore::logicleTransform( w = 0.5, t = 262144, m =10)
lgcl <- flowCore::estimateLogicle(frame, channels = col_names, m = 5.5)
frame <- flowCore::transform(frame, lgcl)

# extract results
data_out <- exprs(frame)

#work out ids
ids <- 0:(nrow(df)-1)
ids <- matrix(data = ids, nrow = nrow(data), ncol= ncol(data), byrow  = TRUE)
ids <- reshape2::melt(ids)
ids <- ids[[3]]

#reshape results
data_out <- reshape2::melt(data_out)
data_out <- data.frame(transformed = data_out[[3]], .ids = ids)


#send data back to tercen

query$setResult(data_out)

