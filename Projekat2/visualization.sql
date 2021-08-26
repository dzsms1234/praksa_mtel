--DA Projekat 2: Tableau
SELECT
    SUM(new_cases)                                      AS total_cases,
    SUM(CAST(new_deaths AS INT))                        AS total_deaths,
    SUM(CAST(new_deaths AS INT)) / SUM(new_cases) * 100 AS deathpercentage
FROM
    covid_deaths
--Where location like '%states%'
WHERE
    continent IS NOT NULL 
--Group By date
ORDER BY
    1,
    2;
    
    
Select location, SUM(cast(new_deaths as int)) as TotalDeathCount
From Covid_Deaths
--Where location like '%states%'
Where continent is null 
and location not in ('World', 'European Union', 'International')
Group by location
order by TotalDeathCount desc


Select Location, Population, MAX(total_cases) as HighestInfectionCount,  Max((total_cases/population))*100 as PercentPopulationInfected
From Covid_Deaths
--Where location like '%states%'
Group by Location, Population
order by PercentPopulationInfected desc


Select Location, Population,datum, MAX(total_cases) as HighestInfectionCount,  Max((total_cases/population))*100 as PercentPopulationInfected
From Covid_Deaths
--Where location like '%states%'
Group by Location, Population, datum
order by PercentPopulationInfected desc;


desc covid_deaths ;