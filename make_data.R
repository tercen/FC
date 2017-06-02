library(flowCore)
in_file<-"data\\20161222-10012 U2OS_SET8.fcs"

flowCore::isFCSfile("data\\20161222-10012 U2OS_SET8.fcs")

sample <- flowCore::read.FCS(in_file, transformation = FALSE)
exprs_all <- exprs(sample)

cell_id   <- 1:nrow(exprs_all)
col_names <- colnames(exprs_all)
split_names <- strsplit(col_names, split="-")
num_of_qts <- 12
first_idx <- (1 == (1:length(col_names)) %% num_of_qts)
last_idx <- (0 == (1:length(col_names)) %% num_of_qts)

qt_names <- sapply(split_names, function(x) tail(x, 1L))
qt_names_unique <- unique(qt_names)

channel_names <- sapply(split_names, function(x) setdiff(x, tail(x, 2L)))
channel_names <- sapply(channel_names, paste, collapse= "_")
channel_names <- unlist(channel_names, use.names = FALSE)
channel_names_unique <- unique(channel_names)

channel_names_unique <- gsub("AF647", "z_AF67", channel_names_unique)

colnames(exprs_all) <- unlist(qt_names, use.names = FALSE)



for (i in 1:length(channel_names_unique)) {
file_name <- paste(in_file, channel_names_unique[i], sep="_")
file_name <- paste0(file_name,"_wide.tsv")
print(file_name)
col_begin <- ((i-1)*12)+1
col_end <- col_begin + num_of_qts -1

channel_id <- rep(channel_names_unique[i], nrow(exprs_all))
print(i)
section <- data.frame(cell_id, channel_id, exprs_all[, col_begin:col_end])
section <- reshape2::melt(section, id.vars = c("cell_id", "channel_id", qt_names_unique), value.name="measurement" )
write.table(file = file_name, section, sep="\t", row.names = FALSE, quote = FALSE)
}


