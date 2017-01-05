require(XML)
require(plyr)
require(stringr)

filepath <- "C:/JEPC ETL Database/XML Documents/cat_m_c_l/"
setwd(filepath) 
files <- list.files() 
cat_m_c_l <- c("Data", "DataName")
for (i in 1:length(files)) {
      doc <- xmlTreeParse(files[i], useInternalNodes = TRUE)
      top <- xmlRoot(doc)
      datainput <- cbind(xmlSApply(top, xmlValue), substring(files[i],1, nchar(files[i])-4))
      cat_m_c_l <- rbind(cat_m_c_l, datainput)
}
write.csv(cat_m_c_l, "cat_m_c_l.csv")

filepath <- "C:/JEPC ETL Database/XML Documents/pl_id_attr/"
setwd(filepath) 
files <- list.files() 
pl_id_attr <- c("Data", "DataName")
for (i in 1:length(files)) {
      doc <- xmlTreeParse(files[i], useInternalNodes = TRUE)
      top <- xmlRoot(doc)
      datainput <- cbind(xmlSApply(top, xmlValue), substring(files[i],1, nchar(files[i])-4))
      pl_id_attr <- rbind(pl_id_attr, datainput)
}
write.csv(pl_id_attr, "pl_id_attr.csv")

filepath <- "C:/JEPC ETL Database/XML Documents/pl_id_id/"
setwd(filepath) 
files <- list.files() 
pl_id_id <- c("Data", "DataName")
for (i in 1:length(files)) {
      doc <- xmlTreeParse(files[i], useInternalNodes = TRUE)
      top <- xmlRoot(doc)
      datainput <- cbind(xmlSApply(top, xmlValue), substring(files[i],1, nchar(files[i])-4))
      pl_id_id <- rbind(pl_id_id, datainput)
}
write.csv(pl_id_id, "pl_id_id")

filepath <- "C:/JEPC ETL Database/XML Documents/item_m_c_i_attr/"
setwd(filepath) 
files <- list.files() 
item_m_c_i_attr <- c("Data", "DataName")
for (i in 1:length(files)) {
      doc <- xmlTreeParse(files[i], useInternalNodes = TRUE)
      top <- xmlRoot(doc)
      datainput <- cbind(xmlSApply(top, xmlValue), substring(files[i],1, nchar(files[i])-4))
      item_m_c_i_attr <- rbind(item_m_c_i_attr, datainput)
}
write.csv(item_m_c_i_attr, "item_m_c_i_attr.csv")

filepath <- "C:/JEPC ETL Database/XML Documents/item_m_c_i_l/"
setwd(filepath) 
files <- list.files() 
item_m_c_i_l <- c("Data", "DataName")
for (i in 1:length(files)) {
      doc <- xmlTreeParse(files[i], useInternalNodes = TRUE)
      top <- xmlRoot(doc)
      datainput <- cbind(xmlSApply(top, xmlValue), substring(files[i],1, nchar(files[i])-4))
      item_m_c_i_l <- rbind(item_m_c_i_l, datainput)
}
write.csv(item_m_c_i_l, "item_m_c_i_l.csv")

filepath <- "C:/JEPC ETL Database/XML Documents/tl_m_c_attr/"
setwd(filepath) 
files <- list.files() 
tl_m_c_attr <- c("Data", "DataName")
for (i in 1:length(files)) {
      doc <- xmlTreeParse(files[i], useInternalNodes = TRUE)
      top <- xmlRoot(doc)
      datainput <- cbind(xmlSApply(top, xmlValue), substring(files[i],1, nchar(files[i])-4))
      tl_m_c_attr <- rbind(tl_m_c_attr, datainput)
}
write.csv(tl_m_c_attr, "tl_m_c_attr.csv")

filepath <- "C:/JEPC ETL Database/XML Documents/tl_m_c_l/"
setwd(filepath) 
files <- list.files() 
tl_m_c_l <- c("Data", "DataName")
for (i in 1:length(files)) {
      doc <- xmlTreeParse(files[i], useInternalNodes = TRUE)
      top <- xmlRoot(doc)
      datainput <- cbind(xmlSApply(top, xmlValue), substring(files[i],1, nchar(files[i])-4))
      tl_m_c_l <- rbind(tl_m_c_l, datainput)
}
write.csv(tl_m_c_l, "tl_m_c_l.csv")

rm(i)
rm(doc)
rm(filepath)
mr(files)

