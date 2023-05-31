--Select the data that we are going to be using

select location, date, total_cases, new_cases, total_deaths, population
from Portfolio_Scamale_Analyst..CoDe
order by Location, date

-- Looking at total cases vs total deaths
-- Shows likelyhood of dying if you contract covid in you country
select location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 Percentage_of_deaths_per_case
from Portfolio_Scamale_Analyst..CoDe
where location like '%states%'
order by Location, date


--Looking at the total cases vs population
-- Shows the % of people that contracted covid in your country

select location, date, total_cases, population, (total_cases/population)*100 Percentage_of_cases_based_on_population
from Portfolio_Scamale_Analyst..CoDe
where location like '%states%'
order by location, date

-- Looking at countries with highest infection rate compared to population
-- Shows how likely you are to contract covid on a specific country

select location, max((total_cases/population)*100) Percentage_of_cases_based_on_population
from Portfolio_Scamale_Analyst..CoDe
group by location
order by Percentage_of_cases_based_on_population desc

-- Looking at countries with highest death rate compared to population
-- Shows how likely you are to die from contracting covid on a specific country

select Location, max(cast(total_deaths as int)) Total_Deaths, max((total_deaths/population)*100) Percentage_of_deaths_based_on_population
from Portfolio_Scamale_Analyst..CoDe
group by location
order by Percentage_of_deaths_based_on_population desc


-- Now we will be looking at the continents themselves


--Looking at the highest death percentage per population on continents

select continent, max(cast(total_deaths as int))total_deaths, max(population) population, max(total_deaths/population)*100 Percentage_of_deaths_based_on_population
from Portfolio_Scamale_Analyst..CoDe
where continent is not null and population is not null
group by continent
order by Percentage_of_deaths_based_on_population desc


-- Global Numbers

Select date, SUM (new_cases) as total_cases, SUM(cast (new_deaths as int)) as total_deaths, SUM(cast
(new_deaths as int))/SUM (New_Cases) *100 as DeathPercentage
From Portfolio_Scamale_Analyst..CoDe
--Where location like '%states%'
where continent is not null and date > '2020-01-23'
Group By date
order by 1,2


--Now lets join the Covid Vaccinations table

Select *
From Portfolio_Scamale_Analyst..CoDe dea
Join Portfolio_Scamale_Analyst..CoVa vac
	On dea.location = vac.location and
	dea.date = vac.date


-- Now lets count the number of people vaccinated per country per date

Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
		sum(cast(vac.new_vaccinations as int)) OVER (partition by dea.location order by dea.location, dea.date) Increasing_count_of_vaccinated_people
From Portfolio_Scamale_Analyst..CoDe dea
Join Portfolio_Scamale_Analyst..CoVa vac
	On dea.location = vac.location and
	dea.date = vac.date
where dea.continent is not null
ORDER BY location, date


-- Creating view to store data for later visualizations

create view count_number_of_people_vaccinated as 
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
		sum(cast(vac.new_vaccinations as int)) OVER (partition by dea.location order by dea.location, dea.date) Increasing_count_of_vaccinated_people
From Portfolio_Scamale_Analyst..CoDe dea
Join Portfolio_Scamale_Analyst..CoVa vac
	On dea.location = vac.location and
	dea.date = vac.date
where dea.continent is not null

--To show the view:
select *
from Portfolio_Scamale_Analyst..count_number_of_people_vaccinated
order by location, date



