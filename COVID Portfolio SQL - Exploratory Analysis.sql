-- An�lise de Dados Explorat�ria com SQL
-- Base de dados utilizada: https://ourworldindata.org/covid-deaths

-- Visualizando algumas linhas do dataset

SELECT TOP 100 *
FROM PortfolioProjects..CovidDeaths
order by 3,4;

-- Selecionando dados que vamos utilizar

SELECT
	location,
	date,
	total_cases,
	new_cases,
	total_deaths,
	population
FROM
	PortfolioProjects..CovidDeaths
WHERE
	continent IS NOT NULL
ORDER BY
	1,2;

-- Procurando por Total de Casos x Total de Mortes
-- Mostra probabilidade de morrer se contrair Covid no seu pa�s

SELECT
	location,
	date,
	total_cases,
	total_deaths,
	(CONVERT(DECIMAL(15, 3), total_deaths) / CONVERT(DECIMAL(15, 3), total_cases))*100 AS death_percentage
FROM
	PortfolioProjects..CovidDeaths
WHERE
	location = 'Brazil'
	AND continent IS NOT NULL
ORDER BY
	1,2;


-- Procurando por Total de Casos x Popula��o
-- Mostra a porcentagem de popula��o que contraiu Covid

SELECT
	location,
	date,
	population,
	total_cases,
	(total_cases/population)*100 AS percent_population_infected
FROM
	PortfolioProjects..CovidDeaths
WHERE
	location = 'Brazil'
	AND continent IS NOT NULL
ORDER BY
	1,2;


-- Procurando por pa�ses com maiores �ndices de infec��o comparados com a popula��o

SELECT
	location,
	population,
	MAX(CAST(total_cases AS INT)) AS highest_infection_count,
	MAX((CAST(total_cases AS INT)/population))*100 AS percent_population_infected
FROM
	PortfolioProjects..CovidDeaths
WHERE
	continent IS NOT NULL
GROUP BY
	location,
	population
ORDER BY
	percent_population_infected DESC;


-- Quais s�o os pa�ses com maior contagem de mortes por popula��o?

SELECT
	location,
	MAX(CAST(total_deaths AS INT)) AS total_death_count
FROM
	PortfolioProjects..CovidDeaths
WHERE
	continent IS NOT NULL
GROUP BY
	location
ORDER BY
	total_death_count DESC;


-- Mostrando os continentes com maior contagem de mortes por popula��o

SELECT
	continent,
	population,
	MAX(CAST(total_deaths AS INT)) AS total_death_count
FROM
	PortfolioProjects..CovidDeaths
WHERE
	continent IS NOT NULL
GROUP BY
	continent
ORDER BY
	total_death_count DESC;


-- N�meros Globais

SELECT
	SUM(new_cases) AS total_cases,
	SUM(new_deaths) AS total_deaths,
	(CASE WHEN SUM(new_deaths) = 0 THEN 0 ELSE (SUM(new_deaths)/SUM(new_cases))*100 END) AS death_percentage
FROM
	PortfolioProjects..CovidDeaths
WHERE
	continent IS NOT NULL;



-- Procurando por Popula��o Total x Vacina��es

-- CTE (Common Table Expression)
WITH popvsvac (continent, location, date, population, new_vaccinations, rolling_people_vaccinated)
AS (
SELECT
	dea.continent,
	dea.location,
	dea.date,
	dea.population,
	vac.new_vaccinations,
	SUM(CONVERT(BIGINT, vac.new_vaccinations))
	OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date)
	AS rolling_people_vaccinated
FROM
PortfolioProjects..CovidDeaths AS dea
JOIN
PortfolioProjects..CovidVaccinations AS vac
	ON
		dea.location = vac.location
		AND dea.date = vac.date
WHERE
	dea.continent IS NOT NULL
)

SELECT
	*,
	(rolling_people_vaccinated/population)*100
FROM
	popvsvac;


-- TEMP TABLE

CREATE TABLE #PercentPopulationVaccinated (
	continent nvarchar(255),
	location nvarchar(255),
	date datetime,
	population numeric,
	new_vaccinations numeric,
	rolling_people_vaccinated numeric
);

INSERT INTO #PercentPopulationVaccinated
SELECT
	dea.continent,
	dea.location,
	dea.date,
	dea.population,
	vac.new_vaccinations,
	SUM(CONVERT(BIGINT, vac.new_vaccinations))
	OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date)
	AS rolling_people_vaccinated
FROM
PortfolioProjects..CovidDeaths AS dea
JOIN
PortfolioProjects..CovidVaccinations AS vac
	ON
		dea.location = vac.location
		AND dea.date = vac.date

SELECT
	*,
	(rolling_people_vaccinated/population)*100
FROM
	#PercentPopulationVaccinated;


-- Criando View para guardar dados de visualiza��o posterior

CREATE VIEW PercentPopulationVaccinated AS
SELECT
	dea.continent,
	dea.location,
	dea.date,
	dea.population,
	vac.new_vaccinations,
	SUM(CONVERT(BIGINT, vac.new_vaccinations))
	OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date)
	AS rolling_people_vaccinated
FROM
PortfolioProjects..CovidDeaths AS dea
JOIN
PortfolioProjects..CovidVaccinations AS vac
	ON
		dea.location = vac.location
		AND dea.date = vac.date
WHERE
	dea.continent IS NOT NULL;

SELECT
	*
FROM
	PercentPopulationVaccinated;