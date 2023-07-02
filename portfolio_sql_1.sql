use portfolio_project;

-- to calculate death percentage 
select location,total_deaths,total_cases,(total_deaths/total_cases)*100 as death_percentage from coviddeaths;

--  to find the countries with highest death_rates
 select location,total_deaths,total_cases,max((total_deaths/total_cases)*100) as death_percentage from coviddeaths group by location order by death_percentage desc;
 
 -- to find countries with highest infection rate
 select location,population,total_cases,max((total_cases/population)*100) as InfectedPopulation_percentage from coviddeaths group by location order by Infectedpopulation_percentage desc;
 
-- CTE
with infectionrate(Country,Number_of_people,Totalcases,Infectedpopulation_percentage) as (select location,population,total_cases,max((total_cases/population)*100) as InfectedPopulation_percentage from coviddeaths group by location)
select * from infectionrate;

-- Creating view
create view Temp_1 as select Location,total_cases,new_cases,population, max((total_cases/population)*100) as Infection_rate, max((total_deaths/total_cases)*100) as death_rate from coviddeaths group by location order by death_rate desc;
select * from Temp_1;

-- Table Joining
select coviddeaths.location,sum(coviddeaths.total_cases) as total_case,sum(coviddeaths.total_deaths) as total_death,sum(covidvaccinations.total_vaccinations) as totalvaccinations from coviddeaths join covidvaccinations on coviddeaths.location=covidvaccinations.location group by coviddeaths.location;