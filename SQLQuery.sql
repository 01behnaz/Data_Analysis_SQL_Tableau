
--Select data that we are going to be using

select location, date, total_cases, new_cases, total_deaths, population
from PortfolioProject..CovidDeaths
where continent is not null
order by 1,2


-- looking at Total cases vs Total deaths
-- shows the likelihood of dying if you contract covid in your country

SELECT location, date, total_cases, total_deaths,
CAST((CAST(total_deaths AS FLOAT) / CAST(total_cases AS FLOAT)) * 100 AS FLOAT) AS Death_percentage
FROM PortfolioProject..CovidDeaths
where location like '%iran%'
and continent is not null
order by 1,2


-- looking at Total Cases vs Population
-- shows what percentage of the population got covid

SELECT location, date, population, total_cases,
CAST((CAST(total_cases AS FLOAT) / CAST(population AS FLOAT)) * 100 AS FLOAT) AS PercentPopulationInfected
FROM PortfolioProject..CovidDeaths
where continent is not null
order by 1,2


-- looking at countries with the Highest infection Rate compared to the Population

SELECT location, population, MAX(total_cases) as HighestInfectionCount,
MAX(CAST(CAST(total_cases AS FLOAT) / NULLIF(CAST(population AS FLOAT), 0) * 100 AS FLOAT)) AS PercentPopulationInfected
FROM PortfolioProject..CovidDeaths
WHERE continent is not null 
GROUP BY location, population
ORDER BY PercentPopulationInfected desc


-- showing Countries with Highest Death Count per Population

SELECT location,
MAX(cast(total_deaths as int)) as TotalDeathCount
FROM PortfolioProject..CovidDeaths
where continent is not null
Group by location
order by TotalDeathCount desc


-- break things down by continent

SELECT
continent,
MAX(cast(total_deaths as int)) as TotalDeathCount
FROM PortfolioProject..CovidDeaths
where continent is not null
Group by continent
order by TotalDeathCount desc


-- showing continents with the highest death count per population

SELECT continent, MAX(cast(total_deaths as int)) as TotalDeathCount
FROM PortfolioProject..CovidDeaths
where continent is not null
Group by continent
order by TotalDeathCount desc


-- join 2 table together

select * 
from PortfolioProject..CovidDeaths dea
join PortfolioProject..CovidVaccinations vac
on dea.location = vac.location
and dea.date = vac.date


-- looking at total population vs vaccinations
-- all people vaccinated in the world

select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
from PortfolioProject..CovidDeaths dea
join PortfolioProject..CovidVaccinations vac
on dea.location = vac.location
and dea.date = vac.date
WHERE dea.continent IS NOT NULL
order by 2,3


/*
Queries used for Tableau
*/

-- 1. 

Select SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/SUM(New_Cases)*100 as DeathPercentage
From PortfolioProject..CovidDeaths
where continent is not null 
order by 1,2


-- 2. 

-- We take these out as they are not inluded in the above queries and want to stay consistent
-- 'European Union' is part of Europe and 'world' is the sum of all continents

Select location, SUM(cast(new_deaths as int)) as TotalDeathCount
From PortfolioProject..CovidDeaths
Where continent is null 
and location not in ('World', 'European Union', 'International', 'High income', 'Low income', 'Upper middle income', 'Lower middle income')
Group by location
order by TotalDeathCount desc


-- 3.

Select Location, Population, MAX(total_cases) as HighestInfectionCount,  Max((total_cases/population))*100 as PercentPopulationInfected
From PortfolioProject..CovidDeaths
Group by Location, Population
order by PercentPopulationInfected desc


-- 4.

Select Location, Population,date, MAX(total_cases) as HighestInfectionCount,  Max((total_cases/population))*100 as PercentPopulationInfected
From PortfolioProject..CovidDeaths
Group by Location, Population, date
order by PercentPopulationInfected desc




