use NYCPropertySales;

-- Question 1: What is the average sales price of properties within each 
--             zip code and how does it compare to the city-wide average?

SELECT
 DISTINCT N.ZipCode,
  AVG(TD.SalePrice) OVER (PARTITION BY N.ZipCode) AS AvgSalesPricePerZipCode,
  AVG(TD.SalePrice) OVER () AS CityWideAvgSalesPrice,
  AVG(TD.SalePrice) OVER (PARTITION BY N.ZipCode) - AVG(TD.SalePrice) OVER () AS DifferenceFromCityAverage
FROM
  TransactionDetails TD
JOIN
  CityBlock CB ON TD.Lot = CB.Block
JOIN
  Neighborhood N ON CB.ZipCode = N.ZipCode;
  

-- Question 2: Which block has the highest average sales price, and 
--             how does it compare to the city-wide average?

WITH AvgPrices AS (
  SELECT
    CB.Block,
    N.ZipCode,
    AVG(TD.SalePrice) AS AvgSalesPricePerBlock
  FROM
    TransactionDetails TD
  JOIN
    CityBlock CB ON TD.Lot = CB.Block
  JOIN
    Neighborhood N ON CB.ZipCode = N.ZipCode
  GROUP BY
    CB.Block, N.ZipCode
),
CityWideAvg AS (
  SELECT
    AVG(TD.SalePrice) AS CityWideAvgSalesPrice
  FROM
    TransactionDetails TD
)
SELECT
  AP.Block,
  AP.ZipCode,
  AP.AvgSalesPricePerBlock,
  CW.CityWideAvgSalesPrice,
  AP.AvgSalesPricePerBlock - CW.CityWideAvgSalesPrice AS DifferenceFromCityAverage
FROM
  AvgPrices AP
CROSS JOIN
  CityWideAvg CW
ORDER BY
  AvgSalesPricePerBlock DESC
LIMIT 1;

-- Question 3: What is the total sales volume for residential properties versus commercial properties?

SELECT
  'Residential' AS PropertyType,
  SUM(SalePrice) AS TotalSalesVolume
FROM
  TransactionDetails
WHERE
  ResUnits > 0

UNION ALL

SELECT
  'Commercial' AS PropertyType,
  SUM(SalePrice) AS TotalSalesVolume
FROM
  TransactionDetails
WHERE
  ComUnits > 0;
  
-- Question 4: Calculate the average price per square foot for properties sold in each neighborhood?
SELECT 
    n.Neighborhood,
    AVG(t.SalePrice / t.GrossSqft) as AvgPricePerSqFt
FROM 
    TransactionDetails t
JOIN 
    CityBlock cb ON t.Lot = cb.Block
JOIN 
    Neighborhood n ON cb.ZipCode = n.ZipCode
WHERE 
    t.GrossSqft > 0 AND t.SalePrice > 0
GROUP BY 
    n.Neighborhood;


-- Question 5: How many properties have been sold in each building class category, 
--             and what is the average sales price for each category?

SELECT 
    t.BuildingClassCat, 
    COUNT(*) as TotalPropertiesSold,
    AVG(t.SalePrice) as AvgSalesPrice
FROM 
    TransactionDetails t
JOIN 
    Tax tx ON t.BuildingClassCat = tx.BuildingClassCat
GROUP BY 
    t.BuildingClassCat;


-- Question 6: What is the average land square footage of the properties sold in each borough?

SELECT 
    b.Borough,
    AVG(td.LandSqft) as AvgLandSqft
FROM 
    TransactionDetails td
JOIN 
    CityBlock cb ON td.Lot = cb.Block
JOIN 
    Neighborhood n ON cb.ZipCode = n.ZipCode
JOIN 
    Borough b ON n.Neighborhood = b.Neighborhood
GROUP BY 
    b.Borough;

-- Question 7: Determine the average sales price per unit for the following 
--             categories: 1-3 unit buildings, 4-7 unit buildings, 8+ unit buildings.

SELECT 
    Category,
    AVG(SalePricePerUnit) as AvgSalePricePerUnit
FROM (
    SELECT
        SalePrice / (ResUnits + ComUnits) as SalePricePerUnit,
        CASE
            WHEN (ResUnits + ComUnits) BETWEEN 1 AND 3 THEN '1-3 Units'
            WHEN (ResUnits + ComUnits) BETWEEN 4 AND 7 THEN '4-7 Units'
            ELSE '8+ Units'
        END as Category
    FROM 
        TransactionDetails
    WHERE
        ResUnits + ComUnits > 0 AND SalePrice > 0
) as SubQuery
GROUP BY 
    Category;
    

-- Question 8: What is the ratio of average sales price to the total unit 
--              count for properties within each borough, and how does this ratio vary 
--              with respect to the building class at the time of sale?

SELECT DISTINCT
    b.Borough,
    tx.BuildingClassCat,
    AVG(td.SalePrice) OVER (PARTITION BY b.Borough, tx.BuildingClassCat) / 
    SUM(td.ResUnits + td.ComUnits) OVER (PARTITION BY b.Borough, tx.BuildingClassCat) as PriceToUnitRatio
FROM 
    TransactionDetails td
JOIN 
    CityBlock cb ON td.Lot = cb.Block
JOIN 
    Neighborhood n ON cb.ZipCode = n.ZipCode
JOIN 
    Borough b ON n.Neighborhood = b.Neighborhood
JOIN 
    Tax tx ON td.BuildingClassCat = tx.BuildingClassCat
WHERE
    td.ResUnits + td.ComUnits > 0 AND td.SalePrice > 0;




