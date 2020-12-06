setwd("C:\\Users\\yashg\\OneDrive\\Desktop\\CMU\\Fall 2019\\Data Science\\Project\\Combined Files\\")
library(readxl)
library(ggplot2)
library(tidyverse)
library(lubridate)

so2<-read_csv('SO2.csv')

arizona<-so2%>%
  filter(State_Name=='Arizona')
  


ggplot(data=arizona)+
  geom_point(mapping=aes(x=Year,y=Avg_SO2,color=as.character(Month)))

