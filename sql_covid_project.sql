-- looking at total cases vs total deaths
-- chances of succumbing to covid when you contract it in Africa 

SELECT Location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 AS Death_percentage
From covid
WHERE location like '%Africa%'
order by 1,2

-- looking at total cases v population
SELECT Location, date, total_cases, population, (total_cases/population)*100 AS Death_percentage
From covid
WHERE location like '%Africa%'
order by 1,2


-- looking at countries with highest Infection Rate compared to population.
SELECT Location, MAX(total_cases) AS highestinfectioncount, population, max(total_cases/population)*100 AS 
percentpopulationinfected
From covid
WHERE location like '%Africa%'
GROUP BY location, population 
order by percentpopulationinfected DESC

-- showing countries with highest death count per population
SELECT Location, max(total_deaths) AS TotalDeathCount
FROM covid
-- WHERE location like '%states%'
GROUP BY location, 
order by TotalDeathCount DESC

-- breakdown down per continent
SELECT continent, max(cast(total_deaths as int)) AS TotalDeathCount
FROM covid
WHERE continent is not null
GROUP BY continent, 
order by TotalDeathCount DESC


-- continents with the highest death count per population
SELECT continent, max(cast(total_deaths as int)) AS TotalDeathCount
FROM covid
-- WHERE location like '%states%'
GROUP BY continent, 
order by TotalDeathCount DESC


-- Global numbers
select SUM(new_cases) as total_cases, SUM(cast(new_deaths as int) as total_deaths, SUM(cast
(new_deaths as int))SUM(new_cases)*100 as Deathpercentage
from covid
where continent is null
order by 1,2

-- looking at total population v vaccinations
select c.continent, c.location, c.date, c.population, v.new_vacations
SUM(CONVERT(int, v.new_vaccinations)) OVER (partition by c.location)
from covid c
join vaccinations v
    on c.location = v.location
    and c.date = v.date
where continent is not null
order by 1,2,3


-- use CTE
WITH popvsv(continent, location, date, population, New_vaccinations, Rollingpeoplevaccinated)
as
(
select c.continent, c.location, c.date, c.population, v.new_vacations
SUM(CONVERT(int, v.new_vaccinations)) OVER (partition by c.location)
from covid c
join vaccinations v
    on c.location = v.location
    and c.date = v.date
where continent is not null
order by 1,2,3
) 
select*, (Rollingpeoplevaccinated/population)*100
from popvsv


-- Temp Tables

DROP TABLE if exists percentpeoplevaccinated
create table percentpeoplevaccinated;
(
continent nvarchar(255),
location nvarchar(255),
date, datetime,
population numeric
New_vaccination numeric,
Rollingpeoplevaccinated numeric
)
select c.continent, c.location, c.date, c.population, v.new_vacations
SUM(CONVERT(int, v.new_vaccinations)) OVER (partition by c.location)
from covid c
join vaccinations v
    on c.location = v.location
    and c.date = v.date
where continent is not null
order by 1,2,3

select*, (Rollingpeoplevaccinated/population)*100
from percentpeoplevaccinated


create view percentpeoplevaccinated as
select c.continent, c.location, c.date, c.population, v.new_vacations
SUM(CONVERT(int, v.new_vaccinations)) OVER (partition by c.location)
from covid c
join vaccinations v
    on c.location = v.location
    and c.date = v.date
where continent is not null
order by 2,3