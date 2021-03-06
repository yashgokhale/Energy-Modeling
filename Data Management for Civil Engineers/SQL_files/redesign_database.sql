use roomschema;
# Creating Tables
CREATE TABLE SAMPLE (sampleID varchar(255) NOT NULL PRIMARY KEY,
times varchar(255));

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 5.7/Uploads/dates.csv' 
INTO TABLE SAMPLE 
FIELDS TERMINATED BY ','
IGNORE 1 LINES;

CREATE TABLE TEMPERATURE (sampleID varchar(255) NOT NULL PRIMARY KEY,
KITCHEN DOUBLE,
LIVINGROOM DOUBLE,
LAUNDRYROOM DOUBLE,
OFFICEROOM DOUBLE,
BATHROOM DOUBLE,
NORTHBUILDING DOUBLE,
IRONINGROOM DOUBLE,
TEENAGERROOM DOUBLE,
PARENTSROOM INT);

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 5.7/Uploads/temp.csv' 
INTO TABLE TEMPERATURE
FIELDS TERMINATED BY ','
IGNORE 1 LINES;

CREATE TABLE HUMIDITY (sampleID varchar(255) NOT NULL PRIMARY KEY,
KITCHEN DOUBLE,
LIVINGROOM DOUBLE,
LAUNDRYROOM DOUBLE,
OFFICEROOM DOUBLE,
BATHROOM DOUBLE,
NORTHBUILDING DOUBLE,
IRONINGROOM DOUBLE,
TEENAGERROOM DOUBLE,
PARENTSROOM INT);

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 5.7/Uploads/hum.csv' 
INTO TABLE HUMIDITY
FIELDS TERMINATED BY ','
IGNORE 1 LINES;

CREATE TABLE INDVARS (measureID varchar(255) NOT NULL PRIMARY KEY,
PRESSURE DOUBLE,
WINDSPEED DOUBLE,
VISIBILITY DOUBLE,
DEWPOINT INT);

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 5.7/Uploads/indvars.csv' 
INTO TABLE INDVARS
FIELDS TERMINATED BY ','
IGNORE 1 LINES;

CREATE TABLE CORRVARS (measureID varchar(255) NOT NULL PRIMARY KEY,
TOUT DOUBLE,
RHOUT int);

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 5.7/Uploads/corrvars.csv' 
INTO TABLE CORRVARS
FIELDS TERMINATED BY ','
IGNORE 1 LINES;

CREATE TABLE ENERGYUSE (measureID varchar(255) NOT NULL PRIMARY KEY,
APPLIANCES INT,
LIGHTS INT);

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 5.7/Uploads/app.csv' 
INTO TABLE ENERGYUSE
FIELDS TERMINATED BY ','
IGNORE 1 LINES;

# Answering Questions
# How does the temperature of a particular room compare to the outdoor temperature?
# (Comparing the temperature of kitchen to the outside temperature)

SELECT COUNT(TEMPERATURE.KITCHEN)/(Select count(KITCHEN) from TEMPERATURE), 
AVG(TEMPERATURE.KITCHEN), AVG(CORRVARS.TOUT)
FROM TEMPERATURE
INNER JOIN CORRVARS
ON TEMPERATURE.SAMPLEID=CORRVARS.MEASUREID
WHERE TEMPERATURE.KITCHEN>=CORRVARS.TOUT;

# Can dew be expected at a particular moment?
select sum(case when CORRVARS.TOUT <= INDVARS.DEWPOINT then 1 else 0 end)/(Select count(TOUT) from CORRVARS) as Dew_present,
sum(case when CORRVARS.TOUT > INDVARS.DEWPOINT then 1 else 0 end)/(Select count(TOUT) from CORRVARS) as Dew_absent
from CORRVARS, INDVARS
WHERE CORRVARS.MEASUREID=INDVARS.MEASUREID;

#Creating a new table with categories
CREATE TABLE CATEGORIES
AS (
SELECT measureID,
CASE
    WHEN Appliances > 300 THEN 'High'
    WHEN Appliances<=300 and Appliances>100 THEN 'Moderate'
    ELSE 'Low'
END AS Appliance_flag,
CASE
    WHEN Lights > 25 THEN 'High'
    WHEN Lights<=25 and Lights>10 THEN 'Moderate'
    ELSE 'Low'
END AS Light_flag
FROM ENERGYUSE);

SELECT AVG(INDVARS.VISIBILITY)
FROM INDVARS,CATEGORIES
WHERE CATEGORIES.LIGHT_FLAG='MODERATE' AND CATEGORIES.MEASUREID=INDVARS.MEASUREID;