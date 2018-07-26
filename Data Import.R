################################################################
#
# Data Prep for National Institutional Finance Analysis
# Paul Jarvey V1.1  July 2018
#
################################################################


########### DEPENDENCIEs #######################################

# Check.Packages
# Function to simplify package install
# Requires 'packages' as array of strings using 'c'

check.packages <- function(pkg){
  new.pkg <- pkg[!(pkg %in% installed.packages()[, "Package"])]
  if (length(new.pkg)) 
    install.packages(new.pkg, dependencies = TRUE)
  sapply(pkg, require, character.only = TRUE)
}

# check dependencies and install if needed

packages<-c("ggplot2", "RODBC", "plyr", "dplyr")
check.packages(packages)


########### DATA PREP ##########################################

# Load core data tables as data frames

FIUC_ALL <- odbcConnectAccess2007("FIUC_1980-2016.mdb")   #specifies the file path
province <- sqlFetch(FIUC_ALL, "province")   #loads the provinces reference table
institutions <- sqlFetch(FIUC_ALL, "inst")   #loads the institutions reference table
fiuc <- sqlFetch(FIUC_ALL, "FIUC")   #loads the institutions reference table

 # build a reference table for data_type / table name
tables_num <- c(1,2,3,4) 
tables_names <- c("revenue","expenditure","cog","delta") 
tables <- data.frame(tables_names,tables_num, stringsAsFactors=FALSE)


# Add province to institutional data table

institutions <- inner_join(institutions, province)

# drop french names and rename some columns for convenience

institutions <- institutions2 %>% select(-fr_name)
institutions <- rename(institutions, inst = inst_cd)
institutions <- rename(institutions, prov = prov_cd)
institutions <- rename(institutions, provname = en_name)
fiuc <- rename(fiuc, year = repyr)
fiuc <- rename(fiuc, inst = inst_code)
fiuc <- rename(fiuc, table = data_type)

# label tables
# label data
# do some useful groups/summaries

#Enrolment <- read.csv("PSIS2017-054_T1_Enrolment_2015.csv")
#instEnrol <- summarize(group_by(Enrolment, psis_instit5_en, Year), Enrolees=sum(Enrolment_Count))

# tests

head(fiuc, n=10)
head(institutions, n=10)
