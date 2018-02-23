# This is the first step in the parts catalog extract-transform-load project.  Each individual part in the catalog
# has at least 4 separate XML files related to it, each containing relevant information about that part (i.e what 
# car it fits, supersession information, which diagram it can be found in, etc).  In order to more easily extract
# information from these files, the data will be collated into 4 main data tables rather than in thousands of 
# individual XML files.  These files are currently saved in one large directory, so the first phase of the project
# is to move all of the files into one of four main directories based on the type of information each file contains.
# In all, there are approximately 180,000# XML files to move, so while there is not much coding here, this step 
# takes the longest to process.

# Setting up the paths for moving the files

filepath <- "C:/JEPC ETL Database/XML Documents/Aggregate/"
movepath1 <- "C:/JEPC ETL Database/XML Documents/item_m_c_i_attr/"
movepath2 <- "C:/JEPC ETL Database/XML Documents/item_m_c_i_l/"
movepath3 <- "C:/JEPC ETL Database/XML Documents/tl_m_c_attr/"
movepath4 <- "C:/JEPC ETL Database/XML Documents/tl_m_c_l/"

setwd(filepath)
files <- list.files()

# Identifying files based on their data 

itm_m_c_i_attr <- files[grep("(?=.*itm)(?=.*attributes.xml)", files, perl = TRUE, ignore.case = TRUE)]
itm_m_c_i_l <- files[grep("(?=.*itm)(?=.*l0.xml)", files, perl = TRUE, ignore.case = TRUE)]
tl_m_c_l <- files[grep("(?=.*tl)(?=.*l0.xml)", files, perl = TRUE, ignore.case = TRUE)]
tl_m_c_attr <- files[grep("(?=.*tl)(?=.*attributes.xml)", files, perl = TRUE, ignore.case = TRUE)]

# Copying each file to its corresponding directory and removing it from the old directory

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

rm(movepath1);rm(movepath2);rm(movepath3);rm(movepath4)