filepath <- "C:/JEPC ETL Database/XML Documents/Aggregate/"
movepath1 <- "C:/JEPC ETL Database/XML Documents/item_m_c_i_attr/"
movepath2 <- "C:/JEPC ETL Database/XML Documents/item_m_c_i_l/"
movepath3 <- "C:/JEPC ETL Database/XML Documents/tl_m_c_attr/"
movepath4 <- "C:/JEPC ETL Database/XML Documents/tl_m_c_l/"
setwd(filepath)
files <- list.files()
itm_m_c_i_attr <- files[grep("(?=.*itm)(?=.*attributes.xml)", files, perl = TRUE, ignore.case = TRUE)]
itm_m_c_i_l <- files[grep("(?=.*itm)(?=.*l0.xml)", files, perl = TRUE, ignore.case = TRUE)]
tl_m_c_l <- files[grep("(?=.*tl)(?=.*l0.xml)", files, perl = TRUE, ignore.case = TRUE)]
tl_m_c_attr <- files[grep("(?=.*tl)(?=.*attributes.xml)", files, perl = TRUE, ignore.case = TRUE)]

for (i in 1:length(itm_m_c_i_attr)) {
      file.copy(itm_m_c_i_attr[i], paste(movepath1,itm_m_c_i_attr[i], sep = ""))
      file.remove(itm_m_c_i_attr[i])
}

for (i in 1:length(itm_m_c_i_l)) {
      file.copy(itm_m_c_i_l[i], paste(movepath2,itm_m_c_i_l[i], sep = ""))
      file.remove(itm_m_c_i_l[i])
}

for (i in 1:length(tl_m_c_l)) {
      file.copy(tl_m_c_l[i], paste(movepath3,tl_m_c_l[i], sep = ""))
      file.remove(tl_m_c_l[i])
}

for (i in 1:length(tl_m_c_attr)) {
      file.copy(tl_m_c_attr[i], paste(movepath4,tl_m_c_attr[i], sep = ""))
      file.remove(tl_m_c_attr[i])
}

rm(movepath1)
rm(movepath2)
rm(movepath3)
rm(movepath4)