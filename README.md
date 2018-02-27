# Electronic Parts Catalog ETL Project

<b>Summary</b>:  Extracting images and data from XML files for use in internal parts catalog lookup application

<b>Application URL</b>:  https://bbfulton.shinyapps.io/JaguarEPCLookup/
Examples to use:  aj88912, cac9295, xr817754

<b>Abstract</b>:  In the automotive parts industry, a good parts catalog is essential for a multitude of reasons.  Unfortunately, outside of the dealer network, there is very little support for a business product for small companies such as ours; most major parts suppliers are large-scale operations that spend millions of dollars in developing and maintaining adequate parts catalogs for the makes/models that they deal with.  That leaves smaller companies (such as ours) with very few options.  In the past, this wasn't a huge limitation as the older dealership software was readily available for public use once it became obsolete for their purposes (which was primarily to sell parts for brand new cars) but was still quite suitable for everyone else.  However, with technological advancements in automobiles also came more robust point of sale catalogs, ordering systems and integration in general, thereby necessitating greater security in software.  As such, while versions of dealer catalogs are still available, they all have been stripped of various features with made them useful in the first place.

While the basic hierarchical catalog structure and data is still intact, the search/lookup functionality has been removed because that is strictly reserved for users who are logged into the dealer network, and clearly, no one outside of a dealership setting will be.  Quite simply, there is no way to enter in a part number and see an image/diagram of the part in question.  This is obviously quite an important feature to have and is the impetus for creating this application.

This project entails extracting data found in the dealer software package, transforming it into something more readily usable, and uploading it all into a new application.  The application itself is quite simple; it takes a part number as input (example: AJ88912) and outputs a diagram as well as a listing of what models that part fits and where to find it in the catalog.

I've split the R code up into 3 sections:

-Part 1 involves moving the XML files into their corresponding directory based on the type of information they contain.

-Part 2 extracts the data from each XML file (as I recall, there are 180,000 files total) and enters it into one of seven new data tables

-Part 3 formats and normalizes the new data tables and recombines them for use in the application noted above





