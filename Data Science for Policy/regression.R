setwd("C:\\Users\\yashg\\OneDrive\\Desktop\\CMU\\Fall 2019\\Data Science\\Project\\Combined\\")
library(readxl)
library(ggplot2)
library(tidyverse)
library(lubridate)

SO2<-read_csv('SO2.csv')
CO<-read_csv('CO.csv')
NO2<-read_csv('NO2.csv')
O3<-read_csv('Ozone.csv')
T<-read_csv('T.csv')
RH<-read_csv('RH.csv')

state2<-readline(prompt="Enter State: ")
city<-readline(prompt="Enter City:")
parameter<-readline(prompt="Enter Parameter: (SO2,NO2,O3,CO,T,RH)")

SO2_f<-SO2%>%
  filter(State_Name==as.character(state2))%>%
  filter(City_Name==as.character(city))%>%
  group_by(Year)%>%
  mutate(yr_SO2=mean(Avg_SO2))

NO2_f<-NO2%>%
  filter(State_Name==as.character(state))%>%
  filter(City_Name==as.character(city))%>%
  group_by(Year)%>%
  mutate(yr_NO2=mean(Avg_NO2))

O3_f<-O3%>%
  filter(State_Name==as.character(state))%>%
  filter(City_Name==as.character(city))%>%
  group_by(Year)%>%
  mutate(yr_O3=mean(Avg_O3))

CO_f<-CO%>%
  filter(State_Name==as.character(state))%>%
  filter(City_Name==as.character(city))%>%
  group_by(Year)%>%
  mutate(yr_CO=mean(Avg_CO))

T_f<-T%>%
  filter(State_Name==as.character(state))%>%
  filter(City_Name==as.character(city))%>%
  group_by(Year)%>%
  mutate(yr_T=mean(Avg_T))

RH_f<-RH%>%
  filter(State_Name==as.character(state))%>%
  filter(City_Name==as.character(city))%>%
  group_by(Year)%>%
  mutate(yr_RH=mean(Avg_RH))

#param2<-"Avg_"+as.character(parameter)

ggplot(data=SO2_f)+
  geom_point(mapping=aes(x=Year,y=Avg_SO2,color=as.character(Month)))+
  geom_line(mapping=aes(x=Year,y=yr_SO2))+
  ggtitle(as.character(city))

ggplot()+
  geom_line(mapping=aes(x=Year,y=yr_SO2),data=SO2_f,color='Blue')+
  geom_line(mapping=aes(x=Year,y=yr_NO2),data=NO2_f,color='Green')+
  geom_line(mapping=aes(x=Year,y=yr_O3),data=O3_f,color='Red')+
  geom_line(mapping=aes(x=Year,y=yr_CO),data=CO_f,color='Yellow')+
  ggtitle(as.character(city))

ggplot()+
  geom_line(mapping=aes(x=Year,y=yr_SO2),data=SO2_f)

SO2_2<-SO2%>%
  group_by(State_Name)%>%
  rename(State_Name=state)

ggplot()+
  geom_density(mapping=aes(num),data=SO2)+
  xlab("Count")+
  ylab("Relative Humidity")+
  ggtitle("Fluctuation of RH over years")+
  theme(plot.title = element_text(hjust = 0.5))
