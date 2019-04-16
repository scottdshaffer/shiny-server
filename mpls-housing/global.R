#install packages

library(readr)
library(shiny)
library(leaflet)
library(dplyr)
library(sf)
library(sp)
library(lwgeom)
library(magrittr)
library(rgdal)

#get data
mpls_assessor <- read_csv("data/assessor_data.csv")

myvars <- c("FORMATTED_ADDRESS", "MAIN_PT", "SUB_PT1", "OWNERNAME", "TAX_EXEMPT", "YEARBUILT", "TOTAL_UNITS", "APN", "NEIGHBORHOOD", "X", "Y")
mpls_sf <- mpls_assessor %>% 
  filter(MAIN_PT == "HL" | MAIN_PT == "A") %>%
  select(myvars) %>% 
  st_as_sf(coords = c("X", "Y"), crs = "+proj=lcc +lat_1=45 +lat_2=45 +lat_0=44.79111	 +lon_0=-93.38333	 +x_0=152400.3048 +y_0=30480.0610 +a=6378418.941 +b=6357033.310 +units=ft +no_defs", agr = "constant", na.fail = FALSE) %>% 
  st_transform(crs = 4326)

mpls_sf$INCOME[mpls_sf$MAIN_PT=="A"] <- "Market rate"
mpls_sf$INCOME[mpls_sf$MAIN_PT=="HL" | mpls_sf$SUB_PT1=="HL" | mpls_sf$TAX_EXEMPT=="Yes" | mpls_sf$OWNERNAME=="Mpls Public Housing Authority Mpha"] <- "Income restricted"

mpls_sf$UNITS <- as.numeric(mpls_sf$TOTAL_UNITS)

mpls_sp <- mpls_sf %>% 
  select(c("FORMATTED_ADDRESS", "INCOME", "YEARBUILT", "UNITS", "APN", "NEIGHBORHOOD", "geometry")) %>% 
  na.omit() %>% 
  as("Spatial")

pal <- colorFactor(
  palette = c("#E69F00", "#56B4E9"),
  domain = mpls_sp@data$INCOME
)
