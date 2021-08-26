
Select * 
From covid_deaths
order by 3,4

Select * 
From covid_vaccinations
order by 3,4

Select location, datum, total_cases, new_cases, total_deaths, population
From Covid_deaths
order by 1,2



--Broj smrtnosti u Bosini i Hercegovini

Select location, datum, total_cases, total_deaths, (total_deaths / total_cases)*100 as DeathPercentage 
From Covid_deaths
Where location like '%Bosnia%'
order by 1,2


--Broj slucajeva vs populacija

SELECT
    location,
    datum,
    population,
    total_cases,
    ( total_cases / population ) * 100 AS infectedpercentage
FROM
    covid_deaths
WHERE
    location LIKE '%Bosnia%'
ORDER BY
    1,2


--Drzave sa najvecim procentom zarazenosti u odnosu na populaciju

SELECT
    location,
    population,
    MAX(total_cases) as HighestInfectionCount,
    MAX((total_cases / population )) * 100 AS PercentPopulationInfected
FROM
    covid_deaths
Group by
    location,
    population
ORDER BY
    PercentPopulationInfected DESC;


--Sa najvecim brojem smrtnosti po populaciji

SELECT
    location, MAX(total_deaths) as TotalDeathCount
FROM
    covid_deaths
WHERE 
    total_deaths is not Null and continent is not null
Group by
    location
ORDER BY
    TotalDeathCount DESC;


SELECT
    continent, MAX(total_deaths) as TotalDeathCount
FROM
    covid_deaths
WHERE 
    total_deaths is not Null and continent is not null
Group by
    continent
ORDER BY
    TotalDeathCount DESC;



--Globalni brojevi 

SELECT
    --datum,
    SUM(new_cases),
    SUM(new_deaths),
    SUM(new_deaths)/SUM(new_cases)*100 as DeathProcentage
FROM
    covid_deaths
WHERE
    continent is not null
--GROUP BY
  --  datum
ORDER BY
    1,2

Select 
    dea.continent, dea.location, dea.datum, dea.population, vac.new_vaccinations,
    SUM(vac.new_vaccinations) OVER (PARTITION by dea.location order by dea.location, dea.datum) as PeopleVaccinated
    --(RollingPeopleVactinated/population)*100
    
from 
    covid_deaths dea
Join 
    covid_vaccinations vac
    on dea.location = vac.location
    and dea.datum = vac.datum
WHERE 
    dea.continent is not null
ORDER BY
    2,3


WITH popvsvac AS (
    SELECT
        dea.continent,
        dea.location,
        dea.datum,
        dea.population,
        vac.new_vaccinations,
        SUM(vac.new_vaccinations)
        OVER(PARTITION BY dea.location
             ORDER BY
                 dea.location, dea.datum
        ) AS peoplevacctinated
    FROM
             covid_deaths dea
        JOIN covid_vaccinations vac ON dea.location = vac.location
                                       AND dea.datum = vac.datum
    WHERE
        dea.continent IS NOT NULL
    /*
    ORDER BY
        2,
        3

)

SELECT
-- select * Moze se zamjeniti na ovaj nacin
    p.*,
    ( p.peoplevacctinated / p.population ) * 100
FROM
    popvsvac p    
  

Create TABLE PercentPopVac (
    continent varchar2(200),
    location varchar2(200),
    datum date,
    population NUMBER(38,0),
    new_vaccinations NUMBER(38,0),
    peopleVaccinated NUMBER(38,0)
); 

select * from PercentPopVac;

Insert into PercentPopVac

    SELECT
        dea.continent,
        dea.location,
        dea.datum,
        dea.population,
        vac.new_vaccinations,
        SUM(vac.new_vaccinations)
        OVER(PARTITION BY dea.location
             ORDER BY
                 dea.location, dea.datum
        ) AS peoplevacctinated
    FROM
             covid_deaths dea
        JOIN covid_vaccinations vac ON dea.location = vac.location
                                       AND dea.datum = vac.datum
    WHERE
        dea.continent IS NOT NULL;
 
 
 Create View PercentPopVac_V as
  SELECT
        dea.continent,
        dea.location,
        dea.datum,
        dea.population,
        vac.new_vaccinations,
        SUM(vac.new_vaccinations)
        OVER(PARTITION BY dea.location
             ORDER BY
                 dea.location, dea.datum
        ) AS peoplevacctinated
    FROM
             covid_deaths dea
        JOIN covid_vaccinations vac ON dea.location = vac.location
                                       AND dea.datum = vac.datum
    WHERE
        dea.continent IS NOT NULL;
        
        
        

    
    