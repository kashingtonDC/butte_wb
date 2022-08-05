#########################################################################################
# Directories
#########################################################################################

# Library
library(rstudioapi)

curr_dir = dirname(rstudioapi::getSourceEditorContext()$path)
setwd(curr_dir)
setwd('..')

# Directories
wd=list()
wd$main = getwd()
wd$shp = paste0(wd$main,'/data/gis/subregion_shape/')
wd$sy = paste0(wd$main,'/data/sy_krig_ly1_3_utm/')
wd$ss_c2vsim = paste0(wd$main,'/data/c2vsim_ss/Ss_ly2_4_C2VSIM_Dec2021Rel_2000m/')
wd$sy_c2vsim = paste0(wd$main,'/data/c2vsim_sy/Sy_C2VSIM_Dec2021Rel_2000m/')
wd$data = paste0(wd$main,'/data/')
wd$raw = paste0(wd$main, '/raw_data/')
wd$wse_data = paste0(wd$main,'/output/1_3_wse_initial_all_stations/')
wd$GWL_data = paste0(wd$main,'/output/')
wd$GWS_data = paste0(wd$main,'/output/3_3_GWS_initial_data_all_type/')
wd$figure = paste0(wd$main,'/figure/')