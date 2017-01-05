require(dplyr)
require(tidyr)
require(stringr)
require(sqldf)


#for tl
tl <- tl[-1,]
tl <- tl[,-1]
names(tl) <- c("data", "model")
tl$model <- substr(tl$model, "4", nchar(tl$model)-3)
tl <- separate(tl, model, into = c("m", "c"), sep = "_")
c1 <- c("name")
c2 <- c("1":"58")
coln <- paste(c1, c2, sep = "")
tl <- separate(tl, data, into = coln, sep = "]")
tl <- tl %>% gather(temp, itemname, name1:name58, na.rm = TRUE) %>% 
      select(-temp) %>% filter(nchar(itemname) > 3) %>% arrange(m, c, itemname)
tl$itemname <- gsub("'", "", tl$itemname)
tl$itemname <- gsub("\\[", "", tl$itemname)
tl <- separate(data = tl, col = itemname, into = c("itemno", "partname"), sep = ",")
finaltl <- tl
finaltl$itemno <- as.integer(finaltl$itemno)

#for cat
numcols <- as.character(max(str_count(cat$data, "]"))+1)
c1 <- c("name")
c2 <- c("1":numcols)
coln <- paste(c1, c2, sep = "")
cat <- separate(cat, data, into = coln, sep = "]")
cat <- mutate(cat, imagename = name2)
cat$imagename <- gsub("\\[", "", cat$imagename)
cat <- cat[,-2]
names(cat) <- c("n1", "n2", "n3", "n4", "n5", "n6", "n7", "n8", "n9", "n10", "n11", "n12", 
                "n13", "n14", "n15", "n16", "n17", "n18", "n19", "n20", "n21", "n22", "n23", 
                "n24", "n25", "n26", "n27", "n28", "n29", "m", "c", "imagename")
cat <- cat %>% gather(temp, catname, n1:n29, na.rm = TRUE) %>% 
      select(-temp) %>% filter(nchar(catname) > 3) %>% arrange(m, c, imagename, catname)
cat$catname <- gsub("\\[", "", cat$catname)
cat$catname <- gsub("\\]", "", cat$catname)
cat <- cat %>% select(-imagename)
cata <- cat[grepl("^.[0-9]", cat$catname),]
catb <- cat[grepl("^.[A-Z]", cat$catname),]
catab <- merge(cata, catb, by = c("m", "c"))
names(catab) <- c("m", "c", "catname", "header")
catab$catname <- gsub("\\d|,", "", catab$catname)
catab <- catab %>% mutate(cathead = paste(header, "/", catname), sep = "") %>% select(m, c, cathead)
finalcat <- catab


#for item
item <- item[-1,]
item <- item[,-1]
names(item) <- c("data", "model")
item$model <- substr(item$model, "4", nchar(item$model)-3)
item <- separate(item, model, into = c("m", "c"), sep = "_")
itemx <- item
itemx$data <- as.vector(gsub("\\\n", "zz", itemx$data))
itemx <- mutate(itemx, data = strsplit(data, "zz"))
itemx <- separate_rows(itemx, data, sep = "zz")
itemx <- itemx[grep(".'pb_02.", itemx$data),]
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
itemxbackup <- itemx
itemx <- select(itemx, partno, itemno, m, c)
itemx$m <- as.character(itemx$m); itemx$c <- as.character(itemx$c)
itemx$itemno <- as.character(itemx$itemno)
itemx <- mutate(itemx, partno = strsplit(partno, ","))
itemx <- separate_rows(itemx, partno, sep = ",")
itemx$partno <- gsub("c\\(|\"|\\)", "", itemx$partno)
finalitem <- itemx
finalitem <- select(finalitem, m, c, itemno, partno)
finalitem$itemno <- as.integer(finalitem$itemno)


#for item (heading)
final_merge <- sqldf("SELECT cat.m, cat.c, cat.cathead, a.itemno, a.partno, 
   a.partname FROM finalcat cat JOIN 
   (SELECT i.m, i.c, i.itemno, i.partno, t.partname FROM finalitem i JOIN finaltl t 
   WHERE i.m = t.m AND i.c = t.c AND i.itemno = t.itemno) a 
   WHERE cat.m = a.m AND cat.c = a.c")
names(final_merge) <- c("m", "c", "heading", "itemno", "partno", "partname")
final_merge$heading <- gsub("\\\n", "", final_merge$heading)
final_merge$partno <- gsub("\\\n|\\\\\\n", "", final_merge$partno)
final_merge <- final_merge[,c(1,2,4,6,5,3)]
final_merge$partno <- gsub(" ", "", final_merge$partno)
final_merge <- unique(final_merge)
final_merge <- arrange(final_merge, partno)
for (i in 1:19282) {
      final_merge$partno[i] <- substr(final_merge$partno[i], 3, nchar(final_merge$partno[i]))
}
rm(i)
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
unique_class <- unique(final_merge$class)
unique_class <- unique_class[-c(6,15,17)]
final_merge <- final_merge[which(final_merge$class %in% unique_class),]
rm(unique_class)
up <- sqldf("SELECT m, c, itemno, partname, partno, class, max(heading) FROM final_merge
      GROUP BY m, c, partno, class")
names(up)[7] <- c("category")
up <- up[,-c(1,2,6)]
up <- mutate(up, item_notes = paste("Item ", itemno, ":  ", category))
up <- up[,-c(1,4)]
