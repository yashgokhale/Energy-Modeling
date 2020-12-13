use roomschema;

#Analyzing distribution of data to check number of non-zero values:
SELECT COUNT(APPLIANCES) FROM ENERGY
WHERE APPLIANCES!=0;

SELECT COUNT(LIGHTS) FROM ENERGY
WHERE LIGHTS!=0;

# Appliance-Light Correlation
select Avg(T_out),sum(case when appliances <= 100 then 1 else 0 end) as LowEnergy,
       sum(case when appliances > 100 and appliances <= 300 then 1 else 0 end) as ModerateEnergy,
       sum(case when appliances > 300 then 1 else 0 end) as HighEnergy
from energy WHERE LIGHTS>0;

#Appliance-Temperature correlation
select Avg(T_out),sum(case when appliances <= 100 then 1 else 0 end) as LowEnergy,
       sum(case when appliances > 100 and appliances <= 300 then 1 else 0 end) as ModerateEnergy,
       sum(case when appliances > 300 then 1 else 0 end) as HighEnergy
from energy WHERE LIGHTS=0;

# Categorizing Pressure, Visibility and Windspeed according to energy categorization
#1. Appliances
select sum(case when appliances <= 100 then 1 else 0 end)/(Select count(appliances) from energy) as LowEnergy,
       sum(case when appliances > 100 and appliances <= 300 then 1 else 0 end)/(Select count(appliances) from energy)  as ModerateEnergy,
       sum(case when appliances > 300 then 1 else 0 end)/(Select count(appliances) from energy)  as HighEnergy,
       Avg(T_out),Avg(RH_out)
from energy WHERE Press_mm_Hg<=760;

select sum(case when appliances <= 100 then 1 else 0 end)/(Select count(appliances) from energy) as LowEnergy,
       sum(case when appliances > 100 and appliances <= 300 then 1 else 0 end)/(Select count(appliances) from energy)  as ModerateEnergy,
       sum(case when appliances > 300 then 1 else 0 end)/(Select count(appliances) from energy)  as HighEnergy,
       Avg(T_out),Avg(RH_out)
from energy WHERE Press_mm_Hg>760;

select sum(case when appliances <= 100 then 1 else 0 end)/(Select count(appliances) from energy) as LowEnergy,
       sum(case when appliances > 100 and appliances <= 300 then 1 else 0 end)/(Select count(appliances) from energy)  as ModerateEnergy,
       sum(case when appliances > 300 then 1 else 0 end)/(Select count(appliances) from energy)  as HighEnergy,
       Avg(T_out),Avg(RH_out)
from energy WHERE Visibility<=35;

select sum(case when appliances <= 100 then 1 else 0 end)/(Select count(appliances) from energy) as LowEnergy,
       sum(case when appliances > 100 and appliances <= 300 then 1 else 0 end)/(Select count(appliances) from energy)  as ModerateEnergy,
       sum(case when appliances > 300 then 1 else 0 end)/(Select count(appliances) from energy)  as HighEnergy,
       Avg(T_out),Avg(RH_out)
from energy WHERE Visibility>35;

select sum(case when appliances <= 100 then 1 else 0 end)/(Select count(appliances) from energy) as LowEnergy,
       sum(case when appliances > 100 and appliances <= 300 then 1 else 0 end)/(Select count(appliances) from energy)  as ModerateEnergy,
       sum(case when appliances > 300 then 1 else 0 end)/(Select count(appliances) from energy)  as HighEnergy,
       Avg(T_out),Avg(RH_out)
from energy WHERE Windspeed<=5;

select sum(case when appliances <= 100 then 1 else 0 end)/(Select count(appliances) from energy) as LowEnergy,
       sum(case when appliances > 100 and appliances <= 300 then 1 else 0 end)/(Select count(appliances) from energy)  as ModerateEnergy,
       sum(case when appliances > 300 then 1 else 0 end)/(Select count(appliances) from energy)  as HighEnergy,
       Avg(T_out),Avg(RH_out)
from energy WHERE Windspeed>5;


