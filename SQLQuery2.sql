select * from [Portfolio Project]..['covid deaths$']
select * from [Portfolio Project]..['covid vacination$']
select * from [Portfolio Project]..['covid deaths$'] where YEAR(date)=2022
select continent,SUM(total_cases), "total cases" from [Portfolio Project]..['covid deaths$']  group by continent order by [total cases] desc
select count(*),location from [Portfolio Project]..['covid deaths$'] 
where location like '%India%'
group by location
ORDER BY 1 
select location,date,total_cases,total_deaths,(total_deaths/total_cases)*100 "death percentage" from [Portfolio Project]..['covid deaths$'] 
where location like '%India%'
order by 4 desc
select location,date,total_cases,total_deaths,(total_deaths/total_cases)*100 "death percentage" from [Portfolio Project]..['covid deaths$'] 
where location like '%India%'
order by 5 desc
select location,date,total_cases,total_deaths,(total_deaths/total_cases)*100 "death percentage" from [Portfolio Project]..['covid deaths$'] 
where location like '%India%'
order by 3 desc
select location,date,total_cases,total_deaths,(total_deaths/total_cases)*100 "death percentage" from [Portfolio Project]..['covid deaths$'] 
where location like '%India%'
order by 4 
select location,date,total_cases,total_deaths,(total_deaths/total_cases)*100 "death percentage" from [Portfolio Project]..['covid deaths$'] 
where location like '%India%' and total_deaths is not NULL and (total_deaths/total_cases)*100 is not NULL
order by 4
select location,sum(total_cases) as "total cases" from [Portfolio Project]..['covid deaths$']
where location like '%India%'
group by location
select location,date,population,total_cases,(total_cases/population)*100 "population percentage" from [Portfolio Project]..['covid deaths$'] 
--where location like '%India%'
order by 2
select location,population,max(total_cases) "maximum cases",max((total_cases/population))*100 "population percentage" from [Portfolio Project]..['covid deaths$'] 
--where location like '%India%'
group by location,population
order by max((total_cases/population))*100 desc
select location,population,max(total_cases) "maximum cases",max((total_cases/population))*100 "population percentage" from [Portfolio Project]..['covid deaths$'] 
--where location like '%India%'
group by location,population
order by [maximum cases] desc
select location,max(total_deaths) "maximum deaths" from [Portfolio Project]..['covid deaths$'] 
--where location like '%India%'
group by location
order by [maximum deaths] desc
select continent,max(total_deaths) "maximum deaths" from [Portfolio Project]..['covid deaths$'] 
--where location like '%India%'
where continent is not NULL
group by continent
order by [maximum deaths] desc
select location,max(total_deaths) "maximum deaths" from [Portfolio Project]..['covid deaths$'] 
where location like '%India%'
where continent is  NULL 
group by location
order by [maximum deaths] desc
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 
order by 2,3



With PopvsVac (Continent, Location, Date, Population, New_Vaccinations, RollingPeopleVaccinated)
as
(
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 
)
Select *, (RollingPeopleVaccinated/Population)*100
From PopvsVac




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
(RollingPeopleVaccinated/population)*100
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
--where dea.continent is not null 
--order by 2,3

Select *, (RollingPeopleVaccinated/Population)*100
From #PercentPopulationVaccinated



Create View PercentPopulationVaccinated as
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 
