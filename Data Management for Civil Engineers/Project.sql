USE project;

CREATE TABLE IF NOT EXISTS DATES (SampleID varchar(255),
YYYY INT, 
MM Real, 
DD Real, 
Hr Real, 
Mins Real, 
Secs INT);

CREATE TABLE IF NOT EXISTS  COMMONAREAS (SampleID varchar(255), 
T_Kitchen Real, 
RH_Kitchen Real, 
T_LivingRoom Real, 
RH_LivingRoom Real, 
T_Bathroom Real, 
RH_Bathroom float);

CREATE TABLE IF NOT EXISTS  PERSONALAREAS(SampleID varchar(255),
T_Teenagerroom Real,
RH_Teenagerroom Real,
T_Parentsroom Real,
RH_Parentsroom Real);

CREATE TABLE IF NOT EXISTS  SUBORDINATEAREAS (SampleID varchar(255),
T_Laundryroom Real,	
RH_Laundryroom Real,	
T_Officeroom Real,	
RH_Officeroom Real,	
T_Northend Real,	
RH_Northend Real,	
T_Ironingroom Real,	
RH_Ironingroom Real);

CREATE TABLE IF NOT EXISTS  WEATHER (SampleID varchar(255),
T_out Real,
Press_mm_hg Real,	
RH_out Real,	
Windspeed Real,
Visibility Real,	
Tdewpoint Real);

CREATE TABLE IF NOT EXISTS  TEMPERATUREFLAGS (SampleID varchar(255),
Kitchen varchar(255),	
LivingRoom varchar(255),	
LaundryRoom varchar(255),	
OfficeRoom	 varchar(255),
Bathroom varchar(255),	
Northbuilding varchar(255),	
IroningRoom varchar(255),	
TeenagerRoom varchar(255),	
ParentsRoom varchar(255));

CREATE TABLE IF NOT EXISTS  HUMIDITYFLAGS (SampleID varchar(255),
Kitchen varchar(255),	
LivingRoom varchar(255),	
LaundryRoom varchar(255),	
OfficeRoom	 varchar(255),
Bathroom varchar(255),	
Northbuilding varchar(255),	
IroningRoom varchar(255),	
TeenagerRoom varchar(255),	
ParentsRoom varchar(255));

CREATE TABLE IF NOT EXISTS OUTPUT(SampleID varchar(255),
Appliances Real,	
ApplianceUseType varchar(255),	
lights Real,	
lightsUseType varchar(255));

CREATE TABLE IF NOT EXISTS INDICATORS(SampleID varchar(255),
Dew varchar(255),	
Visibility varchar(255),	
Windspeed varchar(255),	
Pressure varchar(255));

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 5.7/Uploads/times.csv' 
INTO TABLE DATES 
fields terminated BY ','
IGNORE 1 ROWS;

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 5.7/Uploads/commonareas.csv' 
INTO TABLE COMMONAREAS
fields terminated BY ','
IGNORE 1 ROWS;

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 5.7/Uploads/personalareas.csv' 
INTO TABLE PERSONALAREAS
fields terminated BY ','
IGNORE 1 ROWS;

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 5.7/Uploads/subordinateareas.csv' 
INTO TABLE SUBORDINATEAREAS
fields terminated BY ','
IGNORE 1 ROWS;

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 5.7/Uploads/weather.csv' 
INTO TABLE WEATHER
fields terminated BY ','
IGNORE 1 ROWS;

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 5.7/Uploads/tempflags.csv' 
INTO TABLE TEMPERATUREFLAGS
fields terminated BY ','
IGNORE 1 ROWS;

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 5.7/Uploads/RHflags.csv' 
INTO TABLE HUMIDITYFLAGS
fields terminated BY ','
IGNORE 1 ROWS;

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 5.7/Uploads/use.csv' 
INTO TABLE OUTPUT
fields terminated BY ','
IGNORE 1 ROWS;

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 5.7/Uploads/outside.csv' 
INTO TABLE INDICATORS
fields terminated BY ','
IGNORE 1 ROWS;




