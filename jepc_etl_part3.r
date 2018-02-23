require(dplyr)
require(tidyr)
require(stringr)
require(sqldf)

# The TL_M_C_L file (shortened to tl) contains unformatted information that relates 
# part names to a specific subsection of the parts catalog.  Each catalog page 
# displays a labeled diagram for one subsystem of each car; this file contains the 
# name, the subsystem, and a subsystem index for each part number it represents

tl <- read.csv("C:/JEPC ETL Database/XML Documents/tl_m_c_l/tl_m_c_l.csv")

# The data in tl is unformatted and not usable in its current form, but the internal
# subsystem labels used to identify car make and system that each catalog page refers
# to is embedded in this data and simply needs to be extracted.  The code below
# isolates the part names and category names and removes any extraneous characters/info

tl <- tl[-1,-1]
names(tl) <- c("data", "model")
head(tl, 3)

# Stripping off excess formatting characters

tl$model <- substr(tl$model, 
                   "4", 
                   nchar(as.character(tl$model))-3)

# Separating the field containing category codes into main and subcategories.

tl <- separate(tl, 
               model, 
               into = c("m", "c"), 
               sep = "_")

c1 <- c("name")
c2 <- c("1":"58")
coln <- paste(c1, c2, sep = "")

# Separating the field containing individual item names and indexes

tl <- suppressWarnings(
      separate(tl, 
               data, 
               into = coln, 
               sep = "]"))

# Recombining item names and indexes to a more normalized format 

tl <- tl %>% 
      gather(temp, 
             itemname, 
             name1:name58, 
             na.rm = TRUE) %>% 
      select(-temp) %>% 
      filter(nchar(itemname) > 3) %>% 
      arrange(m, c, itemname)

# Removing extraneous characters and splitting part name and indexes into separate 
# fields

tl$itemname <- gsub("'|\\[", "", tl$itemname)
tl <- suppressWarnings(
      separate(data = tl, 
               col = itemname, 
               into = c("itemno", "partname"), 
               sep = ","))
tl$itemno <- as.integer(tl$itemno)

# Reassigning name of tl to finaltl to indicate that this data.frame is finalized

finaltl <- tl

# Removing unneeded objects from memory

rm(tl)
rm(c1)
rm(c2)
rm(coln)

# The cat_m_c_l file (shortened to cat) contains names for the categories and 
# subcategories embedded in the tl file above.  It also contains unformatted 
# referential keys that relate these names to the categories above

cat <- read.csv("C:/JEPC ETL Database/XML Documents/cat_m_c_l/cat_m_c_l.csv")
cat <- cat[-1,-1]
names(cat) <- c("data", "catname")
head(cat, 3)

# Stripping off excess formatting characters from category key fields

cat$catname <- substr(cat$catname, "5", nchar(as.character(cat$catname))-3)

# Separating category and subcategory names into multiple fields

cat <- suppressWarnings(separate(cat, catname, into = c("m", "c"), sep = "_"))

# Separate category and subcategory keys into multiple fields

numcols <- as.character(max(str_count(cat$data, "]"))+1)
c1 <- c("name")
c2 <- c("1":numcols)
coln <- paste(c1, c2, sep = "")
cat <- suppressWarnings(
       separate(cat, 
                data, 
                into = coln, 
                sep = "]"))
cat <- cat[,-2]
names(cat) <- c("n1", "n2", "n3", "n4", "n5", "n6", "n7", "n8", "n9", "n10", "n11", "n12", 
                "n13", "n14", "n15", "n16", "n17", "n18", "n19", "n20", "n21", "n22", "n23", 
                "n24", "n25", "n26", "n27", "n28", "n29", "m", "c")
cat <- cat %>% gather(temp, catname, n1:n29, na.rm = TRUE) %>% 
      select(-temp) %>% filter(nchar(catname) > 3) %>% arrange(m, c, catname)
cat$catname <- gsub("\\[|\\]", "", cat$catname)

# Separating main category names from subcategory names and recombining them into
# a normalized format

cata <- cat[grepl("^.[0-9]", cat$catname),]
catb <- cat[grepl("^.[A-Z]", cat$catname),]
catab <- merge(cata, catb, by = c("m", "c"))
names(catab) <- c("m", "c", "catname", "header")
catab$catname <- gsub("\\d|,", "", catab$catname)

# Concatenating category name fields

catab <- catab %>% 
         mutate(cathead = paste(header, "/", catname), sep = "") %>% 
         select(m, c, cathead)

# Renaming data.frame to indicate that it's finalized

finalcat <- catab

# Removing unneeded objects 

rm(cat); rm(catb); rm(cata); rm(catab)

# item_m_c_i_l (shortened to item) contains part numbers for every part in the Jaguar
# catalog. It also contains reference keys to tie the part numbers back to part names
# in tl and subcategories in cat

item <- read.csv("C:/JEPC ETL Database/XML Documents/item_m_c_i_l/item_m_c_i_l.csv")
head(item, 3)

# Formatting item table prior to being split

item <- item[-1,-1]
names(item) <- c("data", "model")
item$model <- substr(item$model, "5", nchar(as.character(item$model))-3)
item <- suppressWarnings(separate(item, model, into = c("m", "c"), sep = "_"))
item$data <- as.vector(gsub("\\\n", "zz", item$data))
item <- mutate(item, data = strsplit(data, "zz"))
item <- separate_rows(item, data, sep = "zz")
head(item, 3)

# Separating all of the raw data from the 'item' table, cleaning it, and reformatting it in a more useful way

itemx <- item[grep(".'pb_02.", item$data),]
itemx <- mutate(itemx, data = strsplit(as.character(data), ","))
itemx$data <- gsub(" ", "", itemx$data)
itemx$data <- substr(itemx$data, 15, nchar(itemx$data))
itemx <- mutate(itemx, itemno = str_match(itemx$data, "\\[[0-9]+"))
itemx$itemno <- gsub("\\[|,", "", itemx$itemno)
y <- as.data.frame(t(as.data.frame(t(str_match_all(itemx$data, "'pb_02[0-9A-Za-z]+'")))))
names(y) <- c("partno")
z <- as.data.frame(cbind(itemx$m, itemx$c, itemx$itemno, y$partno))
itemx <- z
rm(y)
rm(z)
names(itemx) <- c("m", "c", "itemno", "partno")
itemx$partno <- as.vector(gsub("c\\(|\\)|\"|pb_02|'| ", "", itemx$partno))
itemx <- select(itemx, partno, itemno, m, c)
itemx$m <- as.character(itemx$m); itemx$c <- as.character(itemx$c)
itemx$itemno <- as.character(itemx$itemno)
itemx <- mutate(itemx, partno = strsplit(partno, ","))
itemx <- separate_rows(itemx, partno, sep = ",")
itemx$partno <- gsub("c\\(|\"|\\)", "", itemx$partno)
itemy <- item[grep(".'pb_27.", item$data),]
itemy <- mutate(itemy, data = strsplit(as.character(data), ","))
itemy$data <- gsub(" ", "", itemy$data)
itemy$data <- substr(itemy$data, 15, nchar(itemy$data))
itemy <- mutate(itemy, itemno = str_match(itemy$data, "\\[[0-9]+"))
itemy$itemno <- gsub("\\[|,", "", itemy$itemno)
y <- as.data.frame(t(as.data.frame(t(str_match_all(itemy$data, "'pb_27[0-9A-Za-z]+'")))))
names(y) <- c("partno")
z <- as.data.frame(cbind(itemy$m, itemy$c, itemy$itemno, y$partno))
itemy <- z
rm(y)
rm(z)
names(itemy) <- c("m", "c", "itemno", "partno")
itemy$partno <- as.vector(gsub("c\\(|\\)|\"|pb_27|'| ", "", itemy$partno))
itemy <- select(itemy, partno, itemno, m, c)
itemy$m <- as.character(itemy$m); itemy$c <- as.character(itemy$c)
itemy$itemno <- as.character(itemy$itemno)
itemy <- mutate(itemy, partno = strsplit(partno, ","))
itemy <- separate_rows(itemy, partno, sep = ",")
itemy$partno <- gsub("c\\(|\"|\\)", "", itemy$partno)

# Recombining the extracted 'item' data into a much more easily read table

finalitem <- rbind(itemx, itemy)
finalitem <- select(finalitem, m, c, itemno, partno)
finalitem$itemno <- as.integer(finalitem$itemno)
finalitem$partno <- gsub(" ", "", finalitem$partno)
head(finalitem, 3)

# Removing unneeded data 

rm(item);rm(c1);rm(c2);rm(coln);rm(numcols);rm(itemx);rm(itemy)

# Merging all data from 3 metatables into one primary data format

final_merge <- sqldf("SELECT cat.m, cat.c, cat.cathead, a.itemno, a.partno, 
   a.partname FROM finalcat cat JOIN 
   (SELECT i.m, i.c, i.itemno, i.partno, t.partname FROM finalitem i JOIN finaltl t 
   WHERE i.m = t.m AND i.c = t.c AND i.itemno = t.itemno) a 
   WHERE cat.m = a.m AND cat.c = a.c")
names(final_merge) <- c("m", "c", "heading", "itemno", "partno", "partname")

# Continued data cleaning

final_merge$heading <- gsub("\\\n", "", final_merge$heading)
final_merge$partno <- gsub("\\\n|\\\\\\n", "", final_merge$partno)
final_merge <- final_merge[,c(1,2,4,6,5,3)]
final_merge$partno <- gsub(" ", "", final_merge$partno)
final_merge <- unique(final_merge)
final_merge <- arrange(final_merge, partno)
final_merge$partno[1:19282] <- substr(final_merge$partno[1:19282], 3, nchar(final_merge$partno[1:19282]))
grep("european|japan|uk|europe|jaguarsport|non catalyst|austria|belarus|belgium|
     canary|denmark|eire|estonia|finland|france|germany|gilbraltor|greece|holland|hong kong|
     hungary|italy|japan|kazakhstan|latvia|lithuania|luxembourg|malta|moscow|norway|poland|
     portugal|spain|sweden|switzerland|ukraine|uzbekistan|limousine|australia|daimler|diesel", 
     ignore.case = TRUE, final_merge$heading) -> b
final_merge <- final_merge[-b,]
rm(b)
final_merge$heading <- gsub("Coupe/Convertible", "", final_merge$heading)
final_merge <- mutate(final_merge, class = gsub("/.*", "", final_merge$heading))
final_merge <- final_merge[,c(1,2,3,4,5,7,6)]

# imagefiles contains the image name for every parts diagram, the main category name, and the subcategory name
# for each page in the catalog.  

imagefiles <- read.csv("C:/JEPC ETL Database/Images/category_imagename.csv")
imagefiles <- imagefiles[,-1]
imagefiles$imagename <- paste(imagefiles$imagename, ".jpg", sep = "")
head(imagefiles,3)

# Merging the image names with item data

up <- sqldf("SELECT m, c, itemno, partname, partno, class, max(heading) FROM final_merge
      GROUP BY m, c, partno, class")
names(up)[7] <- c("category")
up <- sqldf("SELECT itemno, partname, partno, category, imagename FROM up, imagefiles 
            WHERE up.m = imagefiles.m AND up.c = imagefiles.c")

# Removing unused data

rm(cat); rm(cata); rm(catb); rm(catab); rm(final_merge); rm(finalcat); rm(finalitem); rm(finaltl); rm(imagefiles)

# Additional formatting of data

up <- mutate(up, item_notes = paste("Item ", itemno, ":  ", category))
up <- unique(up)
up$category <- as.character(lapply(up$category, function(x) unlist(str_split(x, "/", n = 2))[1]))

# Reformatting model names to be more easily understood and to match existing internal catalog listings

up$category <- gsub("XJ Range \\(From \\(V\\) V00001", "New XJ", up$category)
up$category <- gsub("XJ6 & XJ12 \\(From \\(V\\)667829 up to \\(V\\)708757) - Canada", "XJ40 1993-1994", up$category)
up$category <- gsub("XJ6 & XJ12 \\(From \\(V\\)667829 up to \\(V\\)708757\\)", "XJ40 1993-1994", up$category)
up$category <- gsub("XJS \\(From \\(V\\)179737 Up to \\(V\\)226645\\)", "Late XJS from 179737", up$category)
up$category <- gsub("XJS \\(From \\(V\\)139052 up to \\(V\\)179736\\)", "Early XJS to 179736", up$category)
up$category <- gsub("XJ6 \\(2.9, 3.2, 3.6, 4.0\\) From \\(V\\)500001 Up to \\(V\\)667828", "XJ40 1988-1992", up$category)
up$category <- gsub("XJ Series \\(From \\(V\\)720125 up to \\(V\\) 812255)", "X300", up$category)
up$category <- gsub("Series III XJ12", "Series 3 V12", up$category)
up$category <- gsub("XK8  From \\(V\\) A30645", "XK8 2003-2006", up$category)
up$category <- gsub("XK8  From \\(V\\) A00083 To \\(V\\) A30644", "XK8 2000-2002", up$category)
up$category <- gsub("XK8  up to \\(V\\) 042775", "XK8 1997-1999", up$category)
up$category <- gsub("XK8  - Canada", "XK8 1997-1999", up$category)
up$category <- gsub("XJ Series \\(From \\(V\\)812317 to \\(V\\)F59525 \\(Canada", "XJ8 1998-2003", up$category)
up$category <- gsub("XJ Series From \\(V\\)812317 to \\(V\\)F59525 \\(X308\\)", "XJ8 1998-2003", up$category)
up$category <- gsub("XJ Range \\(From \\(V\\) G00442 to \\(V\\) H32732\\)", "XJ8 2004-2009", up$category)
up$category <- gsub("XK Range \\(FROM \\(V\\) B00379\\)", "New XK", up$category)
up <- up[,c(3,2,6,5,4)]
names(up) <- c("Part_Number", "Part_Name", "Catalog_Notes", "Image_Name", "Fitment")

# Taking one last look at the final table--looks good!

head(up, 5)

# Removing last unneeded data tables

rm(final_merge); rm(finalcat); rm(finalitem); rm(finaltl); rm(imagefiles)

# Saving image for Shiny Application upload

save.image(file = "c:/JEPC ETL Database/R Code/JEPC/up.RData")