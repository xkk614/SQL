Select *
From CovidDeath
Where continent is not null 
order by 3,4


Select Location, date, total_cases, new_cases, total_deaths, population
From CovidDeath
Where continent is not null 
order by 1,2


-- Total Cases vs Total Deaths

Select Location, date, total_cases,total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
From CovidDeath
Where location = 'United States'
and continent is not null 
order by 1,2


-- Total Cases vs Population

Select Location, date, Population, total_cases,  (total_cases/population)*100 as PercentPopulationInfected
From CovidDeath
--Where location = 'China'
order by 1,2


-- Countries with Highest Infection Rate

Select Location, Population, MAX(total_cases) as HighestInfectionCount,  Max((total_cases/population))*100 as PercentPopulationInfected
From CovidDeath
--Where location = 'United States'
Group by Location, Population
order by PercentPopulationInfected desc


-- Countries with Highest Death Count
Select Location, MAX(cast(Total_deaths as int)) as TotalDeathCount
From CovidDeath
--Where location = 'United States'
Where continent is not null 
Group by Location
order by TotalDeathCount desc


-- Showing contintents with the highest death count

Select continent, MAX(cast(Total_deaths as int)) as TotalDeathCount
From CovidDeath
--Where location = 'United States'
Where continent is not null 
Group by continent
order by TotalDeathCount desc

-- Death rate by contient

Select continent, date, total_cases,total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
From CovidDeath
--Where location = 'United States'
Where continent is not null
order by DeathPercentage DESC

--% popoulation infected contient over time

Select continent, date, Population, total_cases,  (total_cases/population)*100 as PercentPopulationInfected
From CovidDeath
where continent is not null
order by 1,2

-- total % people infected by continent

Select continent, Population, MAX(total_cases) as HighestInfectionCount,  Max((total_cases/population))*100 as PercentPopulationInfected
From CovidDeath
--Where location = 'United States'
Group by continent, Population
order by PercentPopulationInfected desc


-- GLOBAL NUMBERS

Select SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/SUM(New_Cases)*100 as DeathPercentage
From CovidDeath
--Where location = 'United States'
where continent is not null 
--Group By date
order by 1,2



-- Total Population vs Vaccinations

Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(bigint,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From CovidDeath as dea
Join CovidVaccincation as vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 
order by 2,3


-- Using CTE to perform Calculation on Partition By in previous query

With PopvsVac (Continent, Location, Date, Population, New_Vaccinations, RollingPeopleVaccinated)
as
(
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(bigint,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From CovidDeath as dea
Join CovidVaccincation as vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 
--order by 2,3
)
Select *, (RollingPeopleVaccinated/Population)*100
From PopvsVac



-- Using Temp Table to perform Calculation on Partition By in previous query

DROP Table if exists #PercentPopulationVaccinated
Create Table #PercentPopulationVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_vaccinations numeric,
RollingPeopleVaccinated numeric
)

Insert into #PercentPopulationVaccinated
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From CovidDeath as dea
Join CovidVaccincation as vac
	On dea.location = vac.location
	and dea.date = vac.date
--where dea.continent is not null 
--order by 2,3

Select *, (RollingPeopleVaccinated/Population)*100
From #PercentPopulationVaccinated




-- Creating Views
Create View PercentPopulationVaccinated as
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From CovidDeath as dea
Join CovidVaccincation as vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 

Create view PercentagePopluationInfectedByCountry as
Select Location, date, Population, total_cases,  (total_cases/population)*100 as PercentPopulationInfected
From CovidDeath


Create View TotalDeathByContinent as
Select continent, MAX(cast(Total_deaths as int)) as TotalDeathCount
From CovidDeath
--Where location = 'United States'
Where continent is not null 
Group by continent

Create View GlobalTotal as
Select SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/SUM(New_Cases)*100 as DeathPercentage
From CovidDeath
where continent is not null 

