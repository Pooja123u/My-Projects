select*
from ProfolioProject..CovidDeaths$
where continent is not null
order by 3,4

select * 
from ProfolioProject..CovidVaccination$


select location,date,total_cases,new_cases,total_deaths,population_density
from ProfolioProject..CovidDeaths$
order by 1,2

select location,date,total_cases, total_deaths,(cast(total_deaths as int)/cast(total_cases as int))*100 as DeathPercentage
from ProfolioProject..CovidDeaths$
where location like '%states%'
and continent is not null
order by 1,2

select location,population_density, max(total_cases )as higestinfectioncount ,max((total_cases/population_density ))*100 as percentpopulationinfected
from ProfolioProject..CovidDeaths$
--where location like '%states%'
group by location,population_density
order by  percentpopulationinfected desc

select location,max(cast(total_deaths as int))as totaldeathcount
from ProfolioProject..CovidDeaths$
--where location like '%states%'
where continent is not null
group by location
order by totaldeathcount  desc

select continent,max(cast(total_deaths as int))as totaldeathcount
from ProfolioProject..CovidDeaths$
--where location like '%states%'
where continent is not null
group by continent
order by totaldeathcount  desc

select location,max(cast(total_deaths as int))as totaldeathcount
from ProfolioProject..CovidDeaths$
--where location like '%states%'
where continent is null
group by location
order by totaldeathcount  desc

select sum(new_cases)as total_cases,sum(cast(new_deaths as int))as totale_deaths,sum(cast(new_deaths as int ))/sum(new_cases)*100 as Deathpercentage
from ProfolioProject..CovidDeaths$
--where location like '%states%'
where continent is not  null
--group by date
order by 1,2

select*
from ProfolioProject..CovidVaccination$ vac
join ProfolioProject..CovidDeaths$ dea
on dea.location = vac.location
and dea.date = vac.date

select dea.continent,dea.location,dea.date,dea.population_density 
,vac.new_vaccinations, sum(cast(vac.new_vaccinations as bigint)) over (partition by dea.location order by dea.location,dea.date)
from ProfolioProject..CovidVaccination$ vac
join ProfolioProject.. CovidDeaths$ dea
on dea.location = vac.location
and dea.date = vac.date
where dea.continent is not null
order by 2,3

select  location,count(total_cases)as totalcases ,max(total_deaths)as totaldeaths
from ProfolioProject..CovidDeaths$
where location = 'india'
and total_deaths > 100 
group by location
order by totalcases

select dea.location,dea.date,total_cases,total_deaths
from ProfolioProject..CovidDeaths$ dea
inner join ProfolioProject..CovidVaccination$ vac
on dea.continent=vac.continent

with popvsvac (continent, location,date,population,new_vaccination,rollingpepolevaccinated)
as
(
select dea.continent,dea.location,dea.date,dea.population_density 
,vac.new_vaccinations, sum(cast(vac.new_vaccinations as bigint)) over (partition by dea.location order by dea.location,dea.date) as rollingpepolevaccinated
--(rollingpepolevaccinated)*`100
from ProfolioProject..CovidVaccination$ vac
join ProfolioProject.. CovidDeaths$ dea
on dea.location = vac.location
and dea.date = vac.date
where dea.continent is not null
--order by 2,3
)

select*,(rollingpepolevaccinated/population)*100
from popvsvac

drop table if exists #percentpopulationvaccinated
create table #percentpopulationvaccinated
(
continent nvarchar(255),
location nvarchar(255),
date datetime,
population numeric,
new_vaccination numeric,
rollingpepolevaccinated numeric
)

insert into #percentpopulationvaccinated
select  dea.continent,dea.location,dea.date,dea.population_density 
,vac.new_vaccinations, sum(cast(vac.new_vaccinations as bigint)) over (partition by dea.location order by dea.location,dea.date) as rollingpepolevaccinated
--(rollingpepolevaccinated)*`100
from ProfolioProject..CovidVaccination$ vac
join ProfolioProject.. CovidDeaths$ dea
on dea.location = vac.location
and dea.date = vac.date
where dea.continent is not null
--order by 2,3

select *
from #percentpopulationvaccinated

create view percentpopulationvaccinated as 
select  dea.continent,dea.location,dea.date,dea.population_density 
,vac.new_vaccinations, sum(cast(vac.new_vaccinations as bigint)) over (partition by dea.location order by dea.location,dea.date) as rollingpepolevaccinated
--(rollingpepolevaccinated)*`100
from ProfolioProject..CovidVaccination$ vac
join ProfolioProject.. CovidDeaths$ dea
on dea.location = vac.location
and dea.date = vac.date
where dea.continent is not null
--order by 2,3
