#=================================================================================
# Retrieve USGS dataset using API and export to csv
# NB: csv created for each stations in Q_usgs_data folder
#     List of stations are stored in Q_usgs_data folder under csv named st_info.csv
#=================================================================================

rm(list=ls())

library(dataRetrieval)
library(tidyverse)
library(rstudioapi)

curr_dir = dirname(rstudioapi::getSourceEditorContext()$path)
setwd(curr_dir)
setwd('..')

source(paste0(curr_dir,'/dirs.R'))

#===============================================================================================
# Functions
#===============================================================================================
# Retrieve data
get_hydrodata = function(mrb_huc){
  
  # Variabls to retrieve
  param_codes = c("00060" # Discharge
  )
  
  # Retrieve data
  huc_data <- whatNWISdata(huc = mrb_huc, 
                                      parameterCd = param_codes, 
                                      statCd = "00003", # mean stat code
                                      service=c("uv", "dv")) #instantanous  or daily data 
  
  return(huc_data)
}


# Retrieve data and export csv
get_qdata = function(parm_sel,huc_data){
  
  qgage = unique(huc_data[huc_data$parm_cd== parm_sel,]$site_no)
  var_type = var_c[which(parm_c==parm_sel)]
  
  for(j in 1:length(qgage)){
    
    
    qData <- readNWISdata(sites=qgage[j],
                            parameterCd = parm_sel,
                            startDate = "2002-01-01",
                            endDate = "2022-07-31") 
    
    if(dim(qData)[1]==0){next()}
    
    df = data.frame(Date = qData$dateTime , value = qData$X_00060_00003 )
    colnames(df) = c('Date',paste0(var_type))
    
    write.csv(df, paste0(wd$raw,'usgs/USGS-',qgage[j],'_',var_type,'.csv'))
  }
  return(qgage)
}

#===============================================================================================
# Run code
#=========================================================================================
# variable types
parm_c =  c("00060")
var_c = c('Discharge')
#HUC ids for CA can be obtained using interactive portal here: https://gispublic.waterboards.ca.gov/portal/home/item.html?id=b6c1bab9acc148e7ac726e33c43402ee
#Below only few HUC 8 watershed ids used. HUC 4 can also be used instead
mrb_huc =  c("18020158", "18020159", "18020125",'18020104')

# Loop through the parameters to retrieve data and export to csv
dinfo = 0
for(k in 1:length(mrb_huc)){
  
  for(i in 1:length(parm_c)){
    
    # Retrieve data
    huc_data = get_hydrodata(mrb_huc[k])
    
    # export data to csv
    qgage = get_qdata(parm_sel = parm_c[i],huc_data)
    
    #storing the gage and huc ids
    tmp = cbind(mrb_huc[k], qgage, var_c[i], huc_data$dec_lat_va,huc_data$dec_long_va,huc_data$begin_date, huc_data$end_date)
    dinfo = rbind(dinfo, tmp)
  }
}

dinfo = dinfo[-1,]
colnames(dinfo) = c('HUC', 'USGS_id', 'Variable', 'lat', 'lon','begin_data','end_date')

write.csv(dinfo, paste0(wd$raw,'usgs/st_info.csv'))
