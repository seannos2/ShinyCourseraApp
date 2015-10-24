###COMPOSITE SCRIPT FOR IRISH CENSUS DATA

##Downloading and cleaning Irish educational census data

## Required packages
require(pxR)
require(plyr)
require(ggplot2)
## Downloading the files from the internet

#1 - Educational Data
temp<-tempfile()
fileUrl <- "http://www.cso.ie/px/pxeirestat/Database/eirestat/Profile%209%20What%20we%20Know%20-%20A%20study%20of%20Education%20and%20Skills%20in%20Ireland/CD904.px"
download.file (fileUrl,temp)
census <-as.data.frame(read.px(temp))
unlink(temp)

#2 - Country of origin

##This file is census by country of origin
temp<-tempfile()
fileUrl <- "http://www.cso.ie/px/pxeirestat/Database/eirestat/This%20is%20Ireland%20Part%201/CDD23.px"
download.file (fileUrl,temp)
censusnat <-as.data.frame(read.px(temp))
unlink(temp)

#3

## Downloading the file from the internet
##This file is census by marital status, sex and age
temp<-tempfile()
fileUrl <- "http://www.cso.ie/px/pxeirestat/Database/eirestat/Profile%205%20Households%20and%20Families%20-%20Living%20Arrangements%20in%20Ireland/CD519.px"
download.file (fileUrl,temp)
censusage <-as.data.frame(read.px(temp))
unlink(temp)

##EDUCATIONAL DATA

##Remove unnecessary aggregation levels and unneeded columns

educated <-census[census$Age.at.which.Full.Time.Education.Ceased %in% c( "Total whose full-time education has ceased","Total whose full-time education has not ceased"),]
educated <- educated[educated$Sex %in% c("Male", "Female"),]
aggs <- c("Ulster (part of)","Dublin", "Limerick", "Galway", "Cork", "Waterford", "State", "Connacht", "Leinster", "Munster")
educated <- educated[!(educated$Province.County.or.City %in% aggs),]
educated$CensusYear <- NULL
educated$Age.at.which.Full.Time.Education.Ceased <- NULL
total_labels <- c("Total whose full-time education has ceased",
                  
                  "Total education ceased and not ceased")
educated <- educated[!(educated$Highest.Level.of.Education.Completed %in% total_labels),]
educated <- as.data.frame(sapply(educated,gsub, pattern = "/professional qualification or both", replacement =""))
educated <- as.data.frame(sapply(educated,gsub, pattern = "/completed apprenticeship", replacement =""))
educated <- as.data.frame(sapply(educated,gsub, pattern = "Total whose f", replacement ="F"))
educated$value <- as.numeric(as.character(educated$value))
educated <- educated[!(is.na(educated$value)),]

##Rename dataframe and add some calculated columns

edu <-educated[order(educated$Sex),]
colnames(edu) <- c("Sex", "Location", "Educational.Level", "Number")

#create summary table and ranking within each state

eds <-aggregate(Number ~ Location+Educational.Level, data = edu, FUN=sum)
eds <-ddply(eds,.(Location), transform, total =sum(Number))
eds$per <- (eds$Number/eds$total)*100
eds$negper <- 0 - eds$per
eds$rank <-ave(eds$negper, eds$Educational.Level, FUN=rank)
eds$negper <- NULL
eds$per = round(eds$per,digits = 2)


##COUNTRY OF ORIGIN


##  Filter out aggregation levels, NAs and redundant columns


censusnat <- censusnat[censusnat$Sex %in% c("Male", "Female"),]
aggcount <- c("All countries","Ireland - county of usual residence","Ireland - county other than county of usual residence","Africa (2)","Asia (2)","America (2)","EU27 excluding Ireland","Other Europe (8)","Other Europe (9)","All countries excluding Ireland")
censusnat <- censusnat[!(censusnat$Birthplace %in% aggcount),]
aggs <- c("Ulster (part of)","Dublin City", "Limerick City", "Galway City", "Cork City", "Waterford City", "State", "Connacht", "Leinster", "Munster", "Dún Laoghaire-Rathdown", "Fingal", "South Dublin", "Cork County","Limerick County", "Waterford County", "Galway County" )
censusnat <- censusnat[!(censusnat$Province.County.or.City %in% aggs),]
censusnat$CensusYear <- NULL
censusnat$value <- as.numeric(as.character(censusnat$value))
censusnat <- censusnat[!(is.na(censusnat$value)),]
censusnat$CensusYear <- NULL

# - Summary tables

origin <-aggregate(value ~ Province.County.or.City+Birthplace, data = censusnat, FUN=sum)
origin <-ddply(origin,.(Province.County.or.City), transform, total =sum(value))
origin$per <- (origin$value/origin$total)*100
origin$negper <- 0 - origin$per
origin$rank <-ave(origin$negper, origin$Birthplace, FUN=rank)
origin$negper <- NULL
origin$per <- round(origin$per, digits = 2)

##AGE, SEX, MARITAL STATUS

##	Remove aggregation levels and unneeded sublevels

censusage <- censusage[censusage$Sex %in% c("Male", "Female"),]
censusage <- censusage[(censusage$Aggregate.Town.or.Rural.Area=="State"),]
censusage <- censusage[!(censusage$Marital.Status=="All marital status"),]
censusage <- censusage[!(censusage$Age.Group=="All ages"),]
aggs <- c("Ulster (part of)","Dublin", "Limerick", "Galway", "Cork", "Waterford", "State", "Connacht", "Leinster", "Munster")

censusage <- censusage[!(censusage$Province.County.or.City %in% aggs),]

# Filter out census year. Remove NAs.

censusage$CensusYear <- NULL
censusage$Aggregate.Town.or.Rural.Area <- NULL
censusage$value <- as.numeric(as.character(censusage$value))
censusage <- censusage[!(is.na(censusage$value)),]

## Summary tables

### 1 - Subset by age
age <-aggregate(value ~ Province.County.or.City+Age.Group, data = censusage, FUN=sum)
age <-ddply(age,.(Province.County.or.City), transform, total =sum(value))
age$per <- (age$value/age$total)*100
age$negper <- 0 - age$per
age$rank <-ave(age$negper, age$Age.Group, FUN=rank)
age$negper <- NULL
age$per <- round(age$per, digits = 2)

##2 - subset by sex

sex <-aggregate(value ~ Province.County.or.City+Sex, data = censusage, FUN=sum)
sex <-ddply(sex,.(Province.County.or.City), transform, total =sum(value))
sex$per <- (sex$value/sex$total)*100
sex$negper <- 0 - sex$per
sex$rank <-ave(sex$negper, sex$Sex, FUN=rank)
sex$negper <- NULL
sex$per = round (sex$per, digits = 2)

##3 - subset by marital status

marital <-aggregate(value ~ Province.County.or.City+Marital.Status, data = censusage, FUN=sum)
marital <-ddply(marital,.(Province.County.or.City), transform, total =sum(value))
marital$per <- (marital$value/marital$total)*100
marital$negper <- 0 - marital$per
marital$rank <-ave(marital$negper, marital$Marital.Status, FUN=rank)
marital$negper <- NULL
marital$per <- round(marital$per, digits = 2)

shinyServer(function(input, output) {
  

  output$edutable <-  renderDataTable({
    out_ed <- eds[eds$Educational.Level ==input$Edu,]
    out_ed <- out_ed[order(out_ed$rank),]
    out_ed$Number <- NULL
    out_ed$total <- NULL
    colnames(out_ed) <-c("Location", "EducationalLevel", "Percentage of County", "Ranking")
    out_ed
  })
  
  output$origtable <-  renderDataTable({
    out_orig <- origin[origin$Birthplace ==input$Country,]
    out_orig <- out_orig[order(out_orig$rank),]
    out_orig$value <- NULL
    out_orig$total <- NULL
    colnames(out_orig) <-c("Location", "Birthplace", "Percentage of County", "Ranking")
    out_orig
  })
  
  output$agetable <-  renderDataTable({
    out_age <- age[age$Age.Group ==input$AgeRange,]
    out_age <- out_age[order(out_age$rank),]
    out_age$value <- NULL
    out_age$total <- NULL
    colnames(out_age) <-c("Location", "Age Group", "Percentage of County", "Ranking")
    out_age
  })
  
  output$sextable <-  renderDataTable({
    out_sex <- sex[sex$Sex ==input$Sex,]
    out_sex <- out_sex[order(out_sex$rank),]
    out_sex$value <- NULL
    out_sex$total <- NULL
    colnames(out_sex) <-c("Location", "Sex", "Percentage of County", "Ranking")
    out_sex
  })
  
  output$martable <-  renderDataTable({
    out_mar <- marital[marital$Marital.Status ==input$Marital,]
    out_mar <- out_mar[order(out_mar$rank),]
    out_mar$value <- NULL
    out_mar$total <- NULL
    colnames(out_mar) <-c("Location", "Marital Status", "Percentage of County", "Ranking")
    out_mar
  })
})