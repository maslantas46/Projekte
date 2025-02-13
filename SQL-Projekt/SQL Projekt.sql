-- Datenreinigung + Exploratory Data Analysis

SELECT * 
FROM layoffs;

-- 1. Duplikate entfernen
-- 2. Standardisierung wir die daten
-- 3. Leere Werte ausbessern
-- 4. Columns oder Rows die unnötig sind entfernen
-- 5. EDA



-- KOPIE ERSTELLEN
CREATE TABLE layoffs_staging
LIKE layoffs;

SELECT *
FROM layoffs_staging;

-- IN KOPIE EINFÜGEN
INSERT layoffs_staging
SELECT *
FROM layoffs;


-- 1. Duplikate entfernen

SELECT *,
ROW_NUMBER() OVER(
PARTITION BY company, industry, total_laid_off, percentage_laid_off, 'date') AS row_num
FROM layoffs_staging;

-- 1.1 Duplikate erkennen
WITH duplicate_cte AS 
(
SELECT *,
ROW_NUMBER() OVER(
PARTITION BY company, location, industry, total_laid_off, percentage_laid_off, date, stage, country, funds_raised_millions) AS row_num
FROM layoffs_staging
)
SELECT *
FROM duplicate_cte
WHERE row_num > 1;

-- 1.2 gefundenes Duplikatbeispiel der Firma Casper vergleichen
SELECT *
FROM layoffs_staging
WHERE company = 'Casper';

-- 1.3 Duplikatzeilen entfernen bzw. neue Tabelle erstellen mit row_num dazu.
CREATE TABLE `layoffs_staging2` (
  `company` text,
  `location` text,
  `industry` text,
  `total_laid_off` int DEFAULT NULL,
  `percentage_laid_off` text,
  `date` text,
  `stage` text,
  `country` text,
  `funds_raised_millions` int DEFAULT NULL,
  `row_num` int
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- 1.4 einfügen in die neue tabelle
INSERT INTO layoffs_staging2
SELECT *,
ROW_NUMBER() OVER(
PARTITION BY company, location, industry, total_laid_off, percentage_laid_off, date, stage, country, funds_raised_millions) AS row_num
FROM layoffs_staging;

SELECT *
FROM layoffs_staging2;

-- 1.5 Entferne die Duplikate von der neuen Tabelle

DELETE 
FROM layoffs_staging2
WHERE row_num > 1;


-- 2. Standardisierung der Daten
SELECT *
FROM layoffs_staging2;

-- 2.1 Alle Leerzeichen vor und nach entfernen
UPDATE layoffs_staging2
SET 
    company = TRIM(company),
    location = TRIM(location),
    industry = TRIM(industry),
    percentage_laid_off = TRIM(percentage_laid_off),
    date = TRIM(date),
    stage = TRIM(stage),
    country = TRIM(country);
    
SELECT *
FROM layoffs_staging2;

SELECT *
FROM layoffs_staging2
WHERE industry LIKE 'Crypto%';

-- 2.2 Analyse und Fund: Industriename Crypto und CryptoCurrency sind dasselbe -> Standardisieren im folgenden!

UPDATE layoffs_staging2
SET industry = 'Crypto'
WHERE industry LIKE 'Crypto%';


SELECT *
FROM layoffs_staging2
WHERE country LIKE 'United States%';

-- 2.3 Analyse und Fund: Landname United States und United States. sind dasselbe -> Standardisieren im folgenden!

UPDATE layoffs_staging2
SET country = TRIM(TRAILING '.' FROM country)

-- 2.4 Datum von Strng zu Datumformat umwandeln
UPDATE layoffs_staging2
SET 'date' = str_to_date(`date`, '%m/%d/%yyyy');

SELECT date
FROM layoffs_staging2;

-- 3. Leere Zeilen bereinigen

-- 3.1 Leere Zeilen zu Nullwerten umwandeln

SELECT *
FROM layoffs_staging2;

UPDATE layoffs_staging2
SET 
    industry = NULL
WHERE 
    industry = '';
    
UPDATE layoffs_staging2
SET
    location = NULL
 WHERE  
	location = '';

UPDATE layoffs_staging2
SET
    company = NULL
 WHERE  
	company = '';
    
UPDATE layoffs_staging2
SET
    total_laid_off = NULL
 WHERE  
	total_laid_off = '';
    
UPDATE layoffs_staging2
SET
    percentage_laid_off = NULL
 WHERE  
	percentage_laid_off = '';
 
 UPDATE layoffs_staging2
SET
    stage = NULL
 WHERE  
	stage = '';
    
UPDATE layoffs_staging2
SET
    country = NULL
 WHERE  
	country = '';
    
    
--  4. Columns oder Rows die unnötig sind entfernen

-- row_num braucht man nicht mehr, löschen!

ALTER TABLE layoffs_staging2
DROP column row_num;

-- Exploratory Data Analysis

SELECT *
FROM layoffs_staging2;

SELECT MAX(total_laid_off), MAX(percentage_laid_off)
FROM layoffs_staging2;
-- Es gab 12000 entlassungen - Höchstsumme

SELECT *
FROM layoffs_staging2
WHERE percentage_laid_off = 1
ORDER BY total_laid_off DESC;
-- Viele Firmen haben alle ihre Angestellten gefeuert

SELECT company, SUM(total_laid_off)
FROM layoffs_staging2
GROUP by company
ORDER BY 2 DESC;
-- Die Firma mit den meisten Entlassungen ist Amazon

SELECT MIN(date), MAX(date)
FROM layoffs_staging2;

SELECT industry, SUM(total_laid_off)
FROM layoffs_staging2
GROUP by industry
ORDER BY 2 DESC;
-- Die industrie mit den meisten Entlassungen ist Consumer

SELECT country, SUM(total_laid_off)
FROM layoffs_staging2
GROUP by country
ORDER BY 2 DESC;
-- Das Land mit den meisten Entlassungen ist die USA

SELECT stage, SUM(total_laid_off)
FROM layoffs_staging2
GROUP by stage
ORDER BY 2 DESC;

SELECT company, YEAR(`date`),SUM(total_laid_off)
FROM layoffs_staging2
GROUP by company, YEAR(`date`)
ORDER BY 3 DESC;

WITH Company_Year (company, years, total_laid_off) AS
(
SELECT company, YEAR(date),SUM(total_laid_off)
FROM layoffs_staging2
GROUP by company, YEAR(date)
)
SELECT *
FROM Company_year;


    
    















