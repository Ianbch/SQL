-- Prestige Cars
Use prestigecars;

-- Q1
select make.MakeName, m.ModelName
	from model m
	join make make on make.MakeID = m.MakeID
	where m.ModelID IN (
		select s.ModelID
		from stock s
		where s.DateBought = '2015-07-25'
);

-- Q2
select make.MakeName, m.ModelName
	from model m
	join make make on make.MakeID = m.MakeID
	where m.ModelID in (
		select st.ModelID
		from stock st
		where st.DateBought > '2015-07-15' and st.DateBought < '2015-08-31'
);

-- Q3
select make.MakeName, m.ModelName, datediff(st.DateBought, sale.SaleDate) + 1 as DaysUnsold
	from make make
	join model m on  make.MakeID = m.MakeID
	join stock st on m.ModelID = st.ModelID
	join salesdetails sd on sd.StockID = st.StockCode
	join sales sale on sd.SalesID = sale.SalesID
	where datediff(st.DateBought, sale.SaleDate) >= 0
order by datediff(st.DateBought, sale.SaleDate) desc;

-- Q4
select st.DateBought, avg(st.cost) as AverageDailySpend
	from stock st
	where st.DateBought between '2015-07-01' and '2015-12-31'
	group by st.DateBought
	order by st.DateBought;

-- Q5
select distinct make.MakeName, mo.ModelName
	from sales sale
	join salesdetails salesd on sale.SalesID = salesd.SalesID
	join stock st on salesd.stockID = st.StockCode
	join model mo on st.modelID = mo.ModelID
	join make make on mo.MakeID = mo.MakeId
	where YEAR(sale.SaleDate) = 2015;

-- Q6
select distinct make.MakeName, m.ModelName, YEAR(sale.SaleDate) as YearSold
	from sales sale
		join salesdetails salesd on sale.SalesID = salesd.SalesID
		join stock st on salesd.StockID = st.StockCode
		join model m on st.ModelID = m.ModelID
		join make make on m.MakeID = make.MakeID
		where year(sale.SaleDate) in (2015, 2016)
		order by  make.MakeName, m.ModelName, YearSold;

-- Q7
select make.MakeName, mo.ModelName
	from sales sa
	join salesdetails sd on sa.SalesID = sd.SalesID
	join stock st on sd.StockID = st.StockCode
	join model mo on st.ModelID = mo.ModelID
	join make make on mo.MakeID = make.MakeID
	where year(sa.SaleDate) = 2015 and month(sa.SaleDate) = 7
	order by make.MakeName, mo.ModelName;

-- Q8
select ma.MakeName, mo.ModelName
	from sales sa
	join salesdetails salesd on sa.SalesID = salesd.SalesID
	join stock st on salesd.StockID = st.StockCode
	join model mo on st.ModelID = mo.ModelID
	join make ma on mo.MakeID = ma.MakeID
		where sa.SaleDate >= '2015-07-01' and sa.SaleDate <= '2015-09-30'
		order by ma.MakeName, mo.ModelName;

-- Q9
select make.MakeName, mo.ModelName, sa.SaleDate
	from sales sa
		join salesdetails sd on sa.SalesID = sd.SalesID
		join stock st on sd.StockID = st.StockCode
		join model mo on st.ModelID = mo.ModelID
		join make make on mo.MakeID = make.MakeID
			where year(sa.SaleDate) = 2016 and DAYOFWEEK(sa.SaleDate) = 6
			order by make.MakeName, mo.ModelName, sa.SaleDate;

-- Q10 
select make.MakeName, mo.ModelName, sa.SaleDate
	from sales sa
	join salesdetails salesd on sa.SalesID = salesd.SalesID
	join stock st on salesd.StockID = st.StockCode
	join model mo on st.ModelID = mo.ModelID
	join make make on mo.MakeID = make.MakeID
		where YEARWEEK(sa.SaleDate) = 201726
		order by make.MakeName, mo.ModelName, sa.SaleDate;

-- Q11
select DAYOFWEEK(sa.SaleDate) as Weekday, COUNT(*) as Total_Sales
	from sales sa
	where year(sa.SaleDate) = 2015
	group by DAYOFWEEK(sa.SaleDate)
	order by Total_Sales desc;

-- Q12
select DAYNAME(sa.SaleDate) as Weekday, COUNT(*) as TotalSales
	from sales sa
	where YEAR(sa.SaleDate) = 2015
	group by Weekday
	order by Total_Sales desc;

-- Q13
select st.DateBought, avg(st.cost) as Average_Daily_Spend
	from stock st
	where st.DateBought between '2015-07-01' and '2015-12-31'
	group by st.DateBought
	order by st.DateBought;

-- Q14
select sa.SaleDate, SUM(sa.TotalSalePrice) as Sales 
	from sales sa
	group by sa.SaleDate
	union all
	select 'Average' as SaleDate, avg(TotalSalePrice) as Sales
	from sales;

-- Q15
select month(sa.SaleDate) as SaleMonth, MONTHNAME(sa.SaleDate) as MonthofSale, COUNT(salesd.StockID) as SaleCount
	from sales sa
	join salesdetails salesd on salesd.SalesID = sa.SalesID
	where year(sa.SaleDate) = 2018
	group by SaleMonth, MonthofSale;

-- Q16	
SELECT SUM(TotalSalePrice) as Accumulated_Sales
	FROM sales
		join salesdetails salesd on salesd.SalesID = sales.SalesID
		join stock st on st.StockCode = salesd.StockID
		join model mo on mo.ModelID = st.ModelID
		join make make on mo.MakeID = make.MakeID
	WHERE make.MakeName = 'Jaguar' AND SaleDate BETWEEN '2015-05-12' AND '2015-07-25';

-- Q17
SELECT CONCAT_WS(' - ', CONCAT_WS(', ', 
COALESCE(Address1, ''), 
COALESCE(Address2, '')), 
COALESCE(Town, ''), 
COALESCE(PostCode, '')) AS FormattedAddress
FROM customer;

-- Q18
SELECT CONCAT(make.MakeName, ' ', mo.ModelName) as Make_And_Model, SUM(salesd.SalePrice) as Total_Sale_Price
	FROM salesdetails salesd
	join stock st on salesd.StockID = st.StockCode
	join model mo on mo.ModelID = st.ModelID
	join make make on make.MakeID = mo.MakeId
	GROUP BY Make_And_Model;

-- Q19 
select CONCAT(ModelName, ' (', left(make.MakeName, 3), ')') as Model_With_Acronym
	FROM make make
	join model mo on mo.MakeID = make.MakeID;

-- Q20
Select SalesID, 
CustomerID, 
right(InvoiceNumber, 3), 
TotalSalePrice, 
SaleDate 
from sales;

-- Q21
select SalesID, 
CustomerID, 
Substring(InvoiceNumber, 4, 2), 
totalSalePrice, 
SaleDate 
from sales;

-- Q22
select SalesID, sales.CustomerID, InvoiceNumber, totalSalePrice, SaleDate from sales
	join customer c on sales.CustomerID = c.CustomerID
	join country coun on c.Country = coun.CountryISO2
	where coun.CountryName in ('Germany', 'Belgium', 'Spain', 'France');

-- Q23
select *
	from salesdetails salesd 
	join sales sa on salesd.SalesID = sa.SalesID
	join customer cust on cust.CustomerID = sa.CustomerID
	join country co on cust.Country = co.CountryISO2
	join stock st on st.StockCode = salesd.StockID
	join model mo on st.ModelID = mo.ModelId
	join make make on make.MakeID = mo.MakeID
	where make.MakeCountry = 'ITA' and cust.Country = 'FR';

-- Q24
select StockID, cust.Country as Destination_Country
	from salesdetails salesd
	join sales sa on salesd.SalesID = sa.SalesID
	join customer cust on sa.CustomerID = cust.CustomerID;


-- REST OF THIS DATABASE NEEDS NEW ALIASES -- 

-- Q25
SELECT StockCode,  ModelID, FORMAT(Cost, 2) AS FormattedCost
FROM stock;

-- Q26
SELECT ma.MakeName, mo.Modelname,  stock.ModelID, CONCAT('£', FORMAT(Cost, 2))AS FormattedCost
	FROM stock
	join model mo on mo.ModelID = stock.ModelID
	join make ma on mo.MakeID = ma.MakeID;

-- Q27 
SELECT ma.MakeName, 
       mo.ModelName, 
       CONCAT('£', FORMAT(sd.SalePrice, 'N2', 'de-DE')) AS SalePrice 
FROM SalesDetails sd 
JOIN stock st ON sd.StockID = st.StockCode
JOIN model mo ON st.ModelID = mo.ModelID
JOIN make ma ON ma.MakeID = mo.MakeID;

-- Q28
SELECT InvoiceNumber, DATE_FORMAT(SaleDate, '%d %b %Y') AS FormattedSaleDate
FROM sales;

-- Q29 
SELECT InvoiceNumber, DATE_FORMAT(SaleDate, '%Y-%m-%d') AS FormattedSaleDate
FROM sales;

-- Q30
SELECT InvoiceNumber, DATE_FORMAT(SaleDate, '%Y-%m-%d %h:%i:%s %p') AS FormattedSaleDateTime
FROM sales;

-- Q31
SELECT StockCode, PartsCost, RepairsCost,
    CASE WHEN PartsCost > RepairsCost THEN 'Alert' ELSE 'OK' END AS HighPartsCost
FROM stock;

-- Q32
SELECT StockCode, CONCAT(LEFT(BuyerComments, 25), '...') AS ShortenedComments
	FROM stock
	ORDER BY BuyerComments DESC;

-- Q33
SELECT 
    s.SalesID, 
    st.Cost, 
    st.PartsCost, 
    st.RepairsCost,
    (sd.SalePrice - st.Cost - st.RepairsCost - st.TransportInCost - st.PartsCost) AS Profit,
    CASE 
        WHEN (sd.SalePrice - st.Cost - st.RepairsCost - st.TransportInCost - st.PartsCost) < 0.1 * st.Cost 
             AND st.RepairsCost >= 2 * st.PartsCost 
        THEN 'Warning!' 
        ELSE 'OK' 
    END AS CostAlert
FROM sales s
JOIN salesdetails sd ON sd.SalesID = s.SalesID
JOIN stock st ON st.StockCode = sd.StockID;

-- Q34
SELECT 
    s.SalesID, 
    st.Cost, 
    st.PartsCost, 
    st.RepairsCost,
    (sd.SalePrice - st.Cost - st.RepairsCost - st.TransportInCost - st.PartsCost) AS Profit,
    CASE 
        WHEN (sd.SalePrice - st.Cost - st.RepairsCost - st.TransportInCost - st.PartsCost) < 0.1 * st.Cost 
             AND st.RepairsCost >= 2 * st.PartsCost 
        THEN 'Warning!' 
        WHEN (sd.SalePrice - st.Cost - st.RepairsCost - st.TransportInCost - st.PartsCost) > 0.1 * st.Cost 
             AND (sd.SalePrice - st.Cost - st.RepairsCost - st.TransportInCost - st.PartsCost) < 0.5 * sd.SalePrice
        THEN 'Acceptable'
        ELSE 'OK' 
    END AS CostAlert
FROM 
    sales s
JOIN 
    salesdetails sd ON sd.SalesID = s.SalesID
JOIN 
    stock st ON st.StockCode = sd.StockID;

    
-- Q35
SELECT
    c.CustomerID,
    c.Country,
    CASE 
        WHEN c.Country IN ('DE', 'FR', 'IT', 'BE', 'ES') THEN 'Eurozone'
        WHEN c.Country = 'GB' THEN 'Pound Sterling'
        WHEN c.Country = 'US' THEN 'Dollar'
        ELSE 'Other'
    END AS CurrencyArea
FROM
    customer c;
    
-- Q36
SELECT distinct MakeCountry from make;
SELECT
    CASE
        WHEN ma.MakeCountry IN ('GER', 'FRA', 'ITA') THEN 'European'
        WHEN ma.MakeCountry IN ('USA') THEN 'American'
        WHEN ma.MakeCountry IN ('GBR') THEN 'British'
    END AS GeographicalZone,
    ma.MakeName
FROM make ma;

-- Q37 
SELECT
    CASE
        WHEN TotalSalePrice < 5000 THEN 'Under 5000'
        WHEN TotalSalePrice BETWEEN 5000 AND 50000 THEN '5000-50000'
        WHEN TotalSalePrice BETWEEN 50001 AND 100000 THEN '50001-100000'
        WHEN TotalSalePrice BETWEEN 100001 AND 200000 THEN '100001-200000'
        ELSE 'Over 200000'
    END AS SalesCategory,
    COUNT(*) AS VehiclesSold
FROM sales
GROUP BY SalesCategory
ORDER BY MIN(TotalSalePrice);

-- Q38
SELECT salesdetails.StockID, MONTH(SaleDate) AS MonthNumber, SaleDate,
    CASE
        WHEN MONTH(SaleDate) IN (11, 12, 1, 2) THEN 'Winter'
        WHEN MONTH(SaleDate) IN (3, 4) THEN 'Spring'
        WHEN MONTH(SaleDate) IN (5, 6, 7, 8) THEN 'Summer'
        WHEN MONTH(SaleDate) IN (9, 10) THEN 'Autumn'
    END AS SaleSeason
FROM sales
join salesdetails on sales.SalesID = salesdetails.SalesID
ORDER BY SaleDate;

-- Q39
SELECT ma.MakeName, SUM(sd.SalePrice) AS TotalSales
	FROM salesdetails sd
	JOIN stock st ON sd.StockID = st.StockCode
	JOIN Model mo ON st.ModelID = mo.ModelID
	JOIN Make ma ON mo.MakeID = ma.MakeID
	GROUP BY ma.MakeName
	ORDER BY TotalSales DESC
	LIMIT 5;

-- Q40
SELECT
    st.Color,
    COUNT(*) AS TotalCarsSold,
    SUM(s.TotalSalePrice) AS TotalSaleValue,
    (SUM(s.TotalSalePrice) / (SELECT SUM(TotalSalePrice) FROM sales)) * 100 AS PercentageOfTotalValue
FROM
    stock st
JOIN salesdetails sd on st.StockCode = sd.StockID
JOIN sales s ON sd.SalesID = s.SalesID
GROUP BY st.Color
ORDER BY  TotalCarsSold DESC;

-- Q41
SELECT DISTINCT ma.MakeName, mo.ModelName
	FROM salesdetails sd
	join sales sa on sa.SalesID = sd.SalesID
	JOIN stock st ON sd.StockID = st.StockCode
	JOIN Model mo ON st.ModelID = mo.ModelID
	JOIN Make ma ON mo.MakeID = ma.MakeID
	WHERE YEAR(sa.SaleDate) = 2018 -- Current year
	  AND (ma.MakeName, mo.ModelName) IN (
		SELECT ma_lastyear.MakeName, mo_lastyear.ModelName
		FROM salesdetails sd_lastyear
		join sales sa_lastyear on sd_lastyear.SalesID = sa_lastyear.SalesID
		JOIN stock st_lastyear ON sd_lastyear.StockID = st_lastyear.StockCode
		JOIN Model mo_lastyear ON st_lastyear.ModelID = mo_lastyear.ModelID
		JOIN Make ma_lastyear ON mo_lastyear.MakeID = ma_lastyear.MakeID
		WHERE YEAR(sa_lastyear.SaleDate) = 2017 -- Previous year
	  )
	ORDER BY ma.MakeName, mo.ModelName;

-- Q42
SELECT
    s.SalePrice,
    s.CountryName,
    100 * s.SalePrice / total.TotalSales AS SalesPercentage,
    s.SalePrice - total.AverageSales AS SalesDeviationFromAverage
FROM salesbycountry s
JOIN (
    SELECT
        SUM(SalePrice) AS TotalSales,
        AVG(SalePrice) AS AverageSales
    FROM
        salesbycountry
    WHERE
        YEAR(SaleDate) = 2017
) total ON 1=1
WHERE YEAR(s.SaleDate) = 2017;

-- Q43
SELECT
    m.MakeName,
    SUM(s.TotalSalePrice) AS TotalSales
FROM sales s
JOIN salesdetails sd on s.SalesID = sd.SalesID
JOIN stock st on sd.StockID = st.StockCode
JOIN model mo on mo.ModelID = st.ModelID
JOIN make m ON m.MakeID = mo.MakeID
WHERE YEAR(s.SaleDate) = 2017
GROUP BY  m.MakeName
ORDER BY  TotalSales DESC;

-- Q44
SELECT
    MakeName,
    BestsellingColor,
    SalesCount
FROM (
    SELECT
        ma.MakeName,
        st.Color AS BestsellingColor,
        COUNT(*) AS SalesCount,
        ROW_NUMBER() OVER (PARTITION BY ma.MakeID ORDER BY COUNT(*) DESC) AS RowNum
    FROM salesdetails sd
    JOIN stock st ON sd.StockID = st.StockCode
    JOIN model mo ON st.ModelID = mo.ModelID
    JOIN make ma ON mo.MakeID = ma.MakeID
    GROUP BY ma.MakeID, st.Color
) AS RankedColors
WHERE RowNum = 1
ORDER BY MakeName, SalesCount DESC;

-- Q45 
SELECT MakeName, SalesID, SaleDate, SalePrice
FROM (
    SELECT
        ma.MakeName,
        sd.SalesID,
        sa.SaleDate,
        sd.SalePrice,
        PERCENT_RANK() OVER (ORDER BY sd.SalePrice DESC) AS SalePercentRank
    FROM
        sales sa 
        JOIN
            salesdetails sd ON sa.SalesID = sd.SalesID
        JOIN
            stock st ON sd.StockID = st.StockCode
        JOIN
            model mo ON st.ModelID = mo.ModelID
        JOIN
            make ma ON mo.MakeID = ma.MakeID
) AS RankedSales
WHERE SalePercentRank BETWEEN 0.2 AND 0.4
ORDER BY SalePrice DESC
LIMIT 3;

-- Q46
SELECT SaleDate,
    SUM(TotalSalePrice) OVER (PARTITION BY YEAR(SaleDate) ORDER BY SaleDate) AS RunningTotal,
    YEAR(SaleDate) AS SaleYear
FROM sales
ORDER BY SaleDate;

-- Q47
SELECT CustomerID, SalesID, SaleDate
FROM (
    SELECT
        CustomerID,
        SalesID,
        SaleDate,
        ROW_NUMBER() OVER (PARTITION BY CustomerID ORDER BY SaleDate) AS SaleOrderAsc,
        COUNT(*) OVER (PARTITION BY CustomerID) AS TotalSales
    FROM
        sales
) AS RankedSales
WHERE SaleOrderAsc = 1 OR (SaleOrderAsc >= TotalSales - 3 AND SaleOrderAsc <= TotalSales)
ORDER BY CustomerID, SaleDate;

-- Q48 
SELECT DAYOFWEEK(SaleDate) AS Weekday, COUNT(*) AS NumberOfSales
	FROM sales
	WHERE  YEAR(SaleDate) = 2017 AND DAYOFWEEK(SaleDate) BETWEEN 2 AND 6
	GROUP BY DAYOFWEEK(SaleDate)
	ORDER BY Weekday;

-- COLONIAL DATABASE

use colonial;

-- Q1
SELECT res.ReservationID, t.TripID, res.TripDate
	FROM reservation res
	JOIN trip t ON res.TripID = t.TripID
	WHERE t.State = 'ME';

SELECT res.ReservationID, t.TripID, res.TripDate
	FROM reservation res
	JOIN trip t ON res.TripID = t.TripID
	WHERE state IN (SELECT state FROM trip WHERE State = 'ME');

SELECT res.ReservationID, res.TripID, res.TripDate
FROM reservation res
JOIN trip t ON res.TripID = t.TripID
WHERE EXISTS (
        SELECT *
        FROM trip t
        WHERE t.TripID = res.TripID
          AND t.State = 'ME'
    );
    
-- Q2
SELECT t1.TripID, t1.TripName
	FROM trip t1
	WHERE t1.MaxGrpSize > (
        SELECT MAX(t2.MaxGrpSize)
        FROM trip t2
        WHERE t2.Type = 'Hiking'
    );

-- Q3
SELECT t1.TripID, t1.TripName
	FROM trip t1
	WHERE t1.MaxGrpSize > ANY (
        SELECT t2.MaxGrpSize
        FROM trip t2
        WHERE t2.Type = 'Biking'
    );
    
-- ENTERTAINMENT AGENCY DATABASE

Use entertainmentagencyexample;

-- Q1
SELECT distinct ent.EntertainerID, ent.EntStageName
	FROM entertainers ent
	JOIN engagements eng ON ent.EntertainerID = eng.EntertainerID
	WHERE eng.CustomerID IN (SELECT CustomerID FROM customers WHERE CustLastName IN ('Berg', 'Hallmark'));

SELECT ent.EntertainerID, ent.EntStageName
FROM entertainers ent
WHERE EXISTS (
        SELECT *
        FROM engagements eng
        JOIN customers c ON eng.CustomerID = c.CustomerID
        WHERE ent.EntertainerID = eng.EntertainerID
            AND c.CustLastName IN ('Berg', 'Hallmark')
    );
    
-- Q2 
Select round(avg(salary),2) 
	from agents;

-- Q3
Select eng1.EngagementNumber, eng1.ContractPrice
	from engagements eng1 
	where eng1.ContractPrice >= (
		Select avg(eng2.ContractPrice)
		from engagements eng2);
    
-- Q4
select distinct count(*) 
	from entertainers 
    where EntCity = 'Bellevue';

-- Q5
select EngagementNumber, StartDate, EndDate 
	from engagements 
	where month(StartDate) = 10
	order by StartDate;

-- Q6
SELECT ent.EntertainerID, ent.EntStageName, COUNT(eng.EngagementNumber) AS Engagement_Count
	FROM entertainers ent
	LEFT JOIN engagements eng ON ent.EntertainerID = eng.EntertainerID
	GROUP BY ent.EntertainerID, ent.EntStageName
	ORDER BY ent.EntertainerID;

-- Q7  
SELECT DISTINCT c.CustomerID, c.CustFirstName, c.CustLastName
FROM CUSTOMERS c
WHERE EXISTS (
    SELECT 1
    FROM ENGAGEMENTS eng
    WHERE eng.CustomerID = c.CustomerID
    AND eng.EntertainerID IN (
        SELECT es.EntertainerID
        FROM ENTERTAINER_STYLES es
        WHERE es.StyleID IN (
            SELECT ms.StyleID
            FROM MUSICAL_STYLES ms
            WHERE ms.StyleName IN ('country', 'country rock')
        )
    )
);

-- Q8
SELECT DISTINCT c.CustomerID, c.CustFirstName, c.CustLastName, ms.StyleName
	FROM customers c
	JOIN engagements eng ON c.CustomerID = eng.CustomerID
	JOIN entertainers ent ON eng.EntertainerID = ent.EntertainerID
	JOIN entertainer_styles es on ent.EntertainerID = es.EntertainerID
	JOIN musical_styles ms ON es.StyleID = ms.StyleID
	WHERE ms.StyleName IN ('Country', 'Country Rock');

-- Q9
SELECT DISTINCT e.EntertainerID, e.EntStageName
FROM entertainers e
WHERE EXISTS (
        SELECT * 
        FROM
            engagements eng
        JOIN
            customers c ON eng.CustomerID = c.CustomerID
        WHERE
            e.EntertainerID = eng.EntertainerID
            AND c.CustLastName IN ('Berg', 'Hallmark')
    );
    
-- Q10
SELECT DISTINCT e.EntertainerID, e.EntStageName
	FROM entertainers e
	JOIN engagements eng ON e.EntertainerID = eng.EntertainerID
	JOIN customers c ON eng.CustomerID = c.CustomerID
	WHERE c.CustLastName IN ('Berg', 'Hallmark');

-- Q11
SELECT DISTINCT a.AgentID, a.AgtFirstName, a.AgtLastName
FROM agents a
WHERE NOT EXISTS (
        SELECT *
        FROM
            engagements eng
        WHERE
            eng.AgentID = a.AgentID
    );

SELECT a.AgentID, a.AgtFirstName, a.AgtLastName
FROM agents a
WHERE a.AgentID NOT IN (
        SELECT DISTINCT
            eng.AgentID
        FROM
            engagements eng
        WHERE
            eng.AgentID IS NOT NULL
    );

-- Q12
SELECT a.AgentID, a.AgtFirstName, a.AgtLastName
	FROM agents a
	LEFT JOIN engagements eng ON a.AgentID = eng.AgentID
	WHERE eng.AgentID IS NULL;

-- Q13
SELECT c.CustomerID, c.CustFirstName, c.CustLastName,
    (   SELECT MAX(eng.StartDate)
        FROM engagements eng
        WHERE eng.CustomerID = c.CustomerID
    ) AS LastBookingDate
FROM customers c;

-- Q14
SELECT DISTINCT e.EntertainerID, e.EntStageName
FROM entertainers e
WHERE e.EntertainerID IN (
        SELECT DISTINCT
            eng.EntertainerID
        FROM
            engagements eng
        JOIN
            customers c ON eng.CustomerID = c.CustomerID
        WHERE
            c.CustLastName = 'Berg'
    );
    
SELECT DISTINCT e.EntertainerID, e.EntStageName
FROM entertainers e
WHERE EXISTS (
        SELECT *
        FROM
            engagements eng
        JOIN
            customers c ON eng.CustomerID = c.CustomerID
        WHERE
            e.EntertainerID = eng.EntertainerID
            AND c.CustLastName = 'Berg'
    );
    
-- Q15
SELECT DISTINCT e.EntertainerID, e.EntStageName
	FROM entertainers e
	JOIN engagements eng ON e.EntertainerID = eng.EntertainerID
	JOIN customers c ON eng.CustomerID = c.CustomerID AND c.CustLastName = 'Berg';

-- Q16
SELECT EngagementNumber, ContractPrice
FROM engagements
WHERE ContractPrice > (
        SELECT
            SUM(ContractPrice)
        FROM
            engagements
        WHERE
            MONTH(StartDate) = 11
            AND YEAR(StartDate) = 2017
    );

-- Q17
SELECT EngagementNumber, ContractPrice
FROM engagements
WHERE StartDate = (
        SELECT MIN(StartDate)
        FROM engagements
    );
    
-- Q18
SELECT SUM(ContractPrice) from engagements where (Month(StartDate) = 10 AND YEAR(StartDate) = 2017) OR (MONTH(EndDate) = 10 AND YEAR(EndDate) = 2017);

-- Q19
SELECT DISTINCT c.CustomerID, c.CustFirstName, c.CustLastName
	FROM customers c
	LEFT JOIN engagements eng ON c.CustomerID = eng.CustomerID
	WHERE eng.EngagementNumber IS NULL;

-- Q20
SELECT DISTINCT c.CustomerID, c.CustFirstName, c.CustLastName
	FROM customers c
	WHERE NOT EXISTS (
			SELECT *
			FROM engagements eng
			WHERE c.CustomerID = eng.CustomerID
		);
    
SELECT DISTINCT c.CustomerID, c.CustFirstName,  c.CustLastName
	FROM customers c
	LEFT JOIN (SELECT DISTINCT CustomerID
		FROM engagements
	) eng ON c.CustomerID = eng.CustomerID
	WHERE eng.CustomerID IS NULL;

-- Q21
SELECT e.EntCity, COUNT(DISTINCT es.StyleID) AS num_styles
FROM entertainers e
JOIN entertainer_styles es ON e.EntertainerID = es.EntertainerID
GROUP BY e.EntCity WITH ROLLUP;

-- Q22
SELECT AgentID, SUM(ContractPrice) AS total_booking_amount
	FROM engagements 
	WHERE EXTRACT(YEAR_MONTH FROM StartDate) = '201712'
	GROUP BY AgentID
	HAVING SUM(ContractPrice) > 3000;

-- Q23
SELECT DISTINCT e.EntertainerID, e.EntStageName
	FROM entertainers e
	JOIN engagements eng1 ON e.EntertainerID = eng1.EntertainerID
	JOIN engagements eng2 ON e.EntertainerID = eng2.EntertainerID
	WHERE eng1.StartDate < eng2.EndDate
		AND eng1.EndDate > eng2.StartDate
		AND eng1.EngagementNumber <> eng2.EngagementNumber;
    
-- Q24
SELECT a.AgtFirstName, a.AgtLastName, SUM(e.ContractPrice) AS total_contract_price,
		COALESCE(SUM(a.CommissionRate*e.ContractPrice), 0) AS total_commission
	FROM agents a
	JOIN engagements e ON a.AgentID = e.AgentID
	GROUP BY a.AgentID, a.AgtFirstName, a.AgtLastName
	HAVING COALESCE(SUM(a.CommissionRate*e.ContractPrice), 0) > 1000;

-- Q25
SELECT DISTINCT a.AgentID, a.AgtFirstName, a.AgtLastName
	FROM AGENTS a
	WHERE NOT EXISTS (
	  SELECT 1
	  FROM ENGAGEMENTS e
	  JOIN ENTERTAINERS et ON e.EntertainerID = et.EntertainerID
	  JOIN ENTERTAINER_STYLES es ON et.EntertainerID = es.EntertainerID
	  JOIN MUSICAL_STYLES ms ON es.StyleID = ms.StyleID
	  WHERE e.AgentID = a.AgentID
		AND (ms.StyleName = 'Country' OR ms.StyleName = 'Country Rock')
	);

-- Q26
SELECT EntertainerID, EntStageName
	FROM ENTERTAINERS
	WHERE EntertainerID NOT IN (
	  SELECT EntertainerID
	  FROM ENGAGEMENTS
	  WHERE StartDate >= '2018-02-01' AND StartDate < '2018-05-01'
);

-- Q27 
-- Approach 1 
SELECT e.EntertainerID, e.EntStageName
FROM ENTERTAINERS e
WHERE EXISTS (
  SELECT 1 FROM ENTERTAINER_STYLES es
  JOIN MUSICAL_STYLES ms ON es.StyleID = ms.StyleID
  WHERE es.EntertainerID = e.EntertainerID AND ms.StyleName = 'Jazz'
) AND EXISTS (
  SELECT 1 FROM ENTERTAINER_STYLES es
  JOIN MUSICAL_STYLES ms ON es.StyleID = ms.StyleID
  WHERE es.EntertainerID = e.EntertainerID AND ms.StyleName = 'Rhythm and Blues'
) AND EXISTS (
  SELECT 1 FROM ENTERTAINER_STYLES es
  JOIN MUSICAL_STYLES ms ON es.StyleID = ms.StyleID
  WHERE es.EntertainerID = e.EntertainerID AND ms.StyleName = 'Salsa'
);

-- Approach 2 
SELECT e.EntertainerID, e.EntStageName
	FROM ENTERTAINERS e
	JOIN ENTERTAINER_STYLES es1 ON e.EntertainerID = es1.EntertainerID
	JOIN MUSICAL_STYLES ms1 ON es1.StyleID = ms1.StyleID AND ms1.StyleName = 'Jazz'
	JOIN ENTERTAINER_STYLES es2 ON e.EntertainerID = es2.EntertainerID
	JOIN MUSICAL_STYLES ms2 ON es2.StyleID = ms2.StyleID AND ms2.StyleName = 'Rhythm and Blues'
	JOIN ENTERTAINER_STYLES es3 ON e.EntertainerID = es3.EntertainerID
	JOIN MUSICAL_STYLES ms3 ON es3.StyleID = ms3.StyleID AND ms3.StyleName = 'Salsa'
	GROUP BY e.EntertainerID, e.EntStageName
	HAVING COUNT(DISTINCT ms1.StyleName) = 1
	   AND COUNT(DISTINCT ms2.StyleName) = 1
	   AND COUNT(DISTINCT ms3.StyleName) = 1;

-- Q28 
-- Approach 1 
SELECT DISTINCT c.CustomerID, c.CustFirstName, c.CustLastName
FROM CUSTOMERS c
WHERE EXISTS (
  SELECT 1 FROM ENGAGEMENTS e
  JOIN ENTERTAINERS et ON e.EntertainerID = et.EntertainerID
  WHERE e.CustomerID = c.CustomerID AND et.EntStageName = 'Carol Peacock Trio'
) AND EXISTS (
  SELECT 1 FROM ENGAGEMENTS e
  JOIN ENTERTAINERS et ON e.EntertainerID = et.EntertainerID
  WHERE e.CustomerID = c.CustomerID AND et.EntStageName = 'Caroline Coie Cuartet'
) AND EXISTS (
  SELECT 1 FROM ENGAGEMENTS e
  JOIN ENTERTAINERS et ON e.EntertainerID = et.EntertainerID
  WHERE e.CustomerID = c.CustomerID AND et.EntStageName = 'Jazz Persuasion'
);

-- Approach 2
SELECT c.CustomerID, c.CustFirstName, c.CustLastName
FROM CUSTOMERS c
WHERE (SELECT COUNT(DISTINCT et.EntStageName)
       FROM ENGAGEMENTS e
       JOIN ENTERTAINERS et ON e.EntertainerID = et.EntertainerID
       WHERE e.CustomerID = c.CustomerID AND et.EntStageName IN ('Carol Peacock Trio', 'Caroline Coie Cuartet', 'Jazz Persuasion')) = 3;

-- Approach 3 
SELECT c.CustomerID, c.CustFirstName, c.CustLastName
	FROM CUSTOMERS c
	JOIN ENGAGEMENTS e ON c.CustomerID = e.CustomerID
	JOIN ENTERTAINERS et ON e.EntertainerID = et.EntertainerID
	WHERE et.EntStageName IN ('Carol Peacock Trio', 'Caroline Coie Cuartet', 'Jazz Persuasion')
	GROUP BY c.CustomerID, c.CustFirstName, c.CustLastName
	HAVING COUNT(DISTINCT et.EntStageName) = 3;

-- Q29 
SELECT DISTINCT c.CustomerID, c.CustFirstName, c.CustLastName, et.EntertainerID, et.EntStageName
	FROM CUSTOMERS c
	JOIN MUSICAL_PREFERENCES mp ON c.CustomerID = mp.CustomerID
	JOIN ENTERTAINER_STYLES es ON mp.StyleID = es.StyleID
	JOIN ENTERTAINERS et ON es.EntertainerID = et.EntertainerID
	WHERE NOT EXISTS (
	  SELECT 1 FROM MUSICAL_PREFERENCES mp2
	  WHERE mp2.CustomerID = c.CustomerID
	  AND NOT EXISTS (
		SELECT 1 FROM ENTERTAINER_STYLES es2
		WHERE es2.StyleID = mp2.StyleID AND es2.EntertainerID = et.EntertainerID
	  )
	);

-- Q30 
SELECT et.EntertainerID, et.EntStageName
	FROM ENTERTAINERS et
	JOIN ENTERTAINER_STYLES es ON et.EntertainerID = es.EntertainerID
	JOIN MUSICAL_STYLES ms ON es.StyleID = ms.StyleID
	JOIN ENTERTAINER_MEMBERS em ON et.EntertainerID = em.EntertainerID
	WHERE ms.StyleName = 'Jazz'
	GROUP BY et.EntertainerID, et.EntStageName
	HAVING COUNT(DISTINCT em.MemberID) > 3;
    
-- Q31 
SELECT c.CustomerID, c.CustFirstName, c.CustLastName,
       CASE
         WHEN ms.StyleName IN ('50’s', '60’s', '70’s', '80’s') THEN 'Oldies'
         ELSE ms.StyleName
       END AS StyleName
FROM CUSTOMERS c
JOIN MUSICAL_PREFERENCES mp ON c.CustomerID = mp.CustomerID
JOIN MUSICAL_STYLES ms ON mp.StyleID = ms.StyleID
ORDER BY c.CustomerID;

-- Q32 
SELECT EngagementNumber, StartDate, StartTime, CustomerID, EntertainerID
	FROM ENGAGEMENTS
	WHERE StartDate BETWEEN '2017-10-01' AND '2017-10-31'
	AND StartTime >= '12:00:00' AND StartTime <= '17:00:00';

-- Q33 
SELECT ent.EntertainerID, ent.EntStageName,
       CASE
         WHEN EXISTS (
           SELECT 1 FROM ENGAGEMENTS e
           WHERE e.EntertainerID = ent.EntertainerID AND e.StartDate = '2017-12-25'
         ) THEN 'Booked'
         ELSE 'Not Booked'
       END AS BookingStatus
FROM ENTERTAINERS ent;
 

-- Q34 
SELECT c.CustomerID, c.CustFirstName, c.CustLastName
	FROM CUSTOMERS c
	JOIN MUSICAL_PREFERENCES mp ON c.CustomerID = mp.CustomerID
	JOIN MUSICAL_STYLES ms ON mp.StyleID = ms.StyleID
	WHERE ms.StyleName = 'Jazz'
	AND NOT EXISTS (
	  SELECT 1
	  FROM MUSICAL_PREFERENCES mp2
	  JOIN MUSICAL_STYLES ms2 ON mp2.StyleID = ms2.StyleID
	  WHERE ms2.StyleName = 'Standards' AND mp2.CustomerID = c.CustomerID
	);


-- Q35
SELECT c.CustomerID, CONCAT(c.CustFirstName, ' ', c.CustLastName) AS CustomerName,
       ms.StyleName,
       (SELECT COUNT(*) FROM MUSICAL_PREFERENCES WHERE CustomerID = c.CustomerID) AS TotalPreferences
FROM CUSTOMERS c
JOIN MUSICAL_PREFERENCES mp ON c.CustomerID = mp.CustomerID
JOIN MUSICAL_STYLES ms ON mp.StyleID = ms.StyleID;


-- Q36
SELECT c.CustomerID, 
       CONCAT(c.CustFirstName, ' ', c.CustLastName) AS CustomerName,
       ms.StyleName,
       COUNT(*) OVER (PARTITION BY c.CustomerID) AS TotalPreferences,
       SUM(COUNT(*)) OVER (ORDER BY CONCAT(c.CustFirstName, ' ', c.CustLastName)) AS RunningTotalPreferences
FROM CUSTOMERS c
JOIN MUSICAL_PREFERENCES mp ON c.CustomerID = mp.CustomerID
JOIN MUSICAL_STYLES ms ON mp.StyleID = ms.StyleID
GROUP BY c.CustomerID, ms.StyleName
ORDER BY CustomerName;

-- Q37 
SELECT c.CustCity,
       CONCAT(c.CustFirstName, ' ', c.CustLastName) AS CustomerName,
       COUNT(mp.StyleID) AS NumberOfPreferences,
       SUM(COUNT(mp.StyleID)) OVER (PARTITION BY c.CustCity ORDER BY c.CustCity, c.CustFirstName) AS RunningTotalPreferences
FROM CUSTOMERS c
JOIN MUSICAL_PREFERENCES mp ON c.CustomerID = mp.CustomerID
GROUP BY c.CustCity, c.CustomerID
ORDER BY c.CustCity, c.CustFirstName;


-- Q38 
SELECT ROW_NUMBER() OVER (ORDER BY CONCAT(CustFirstName, ' ', CustLastName)) AS RowNum,
       CustomerID, 
       CONCAT(CustFirstName, ' ', CustLastName) AS CustomerName,
       CustState
FROM CUSTOMERS
ORDER BY CustomerName;

-- Q39 
SELECT ROW_NUMBER() OVER (PARTITION BY CustCity, CustState ORDER BY CONCAT(CustFirstName, ' ', CustLastName)) AS CityStateRowNum,
       CustomerID, 
       CONCAT(CustFirstName, ' ', CustLastName) AS CustomerName,
       CustCity, 
       CustState
FROM CUSTOMERS
ORDER BY CustCity, CustState, CustomerName;

-- Q40 
SELECT StartDate,
       CONCAT(c.CustFirstName, ' ', c.CustLastName) AS CustomerName,
       et.EntStageName,
       ROW_NUMBER() OVER (ORDER BY et.EntStageName) AS EntertainerNum,
       ROW_NUMBER() OVER (PARTITION BY StartDate ORDER BY StartDate) AS EngagementNum
	FROM ENGAGEMENTS e
	JOIN CUSTOMERS c ON e.CustomerID = c.CustomerID
	JOIN ENTERTAINERS et ON e.EntertainerID = et.EntertainerID
	ORDER BY StartDate, EntertainerNum;

-- Q41 
SELECT et.EntertainerID,
       EntStageName,
       NTILE(3) OVER (ORDER BY COUNT(e.EngagementNumber) DESC) AS BookingGroup
	FROM ENTERTAINERS et
	LEFT JOIN ENGAGEMENTS e ON et.EntertainerID = e.EntertainerID
	GROUP BY et.EntertainerID, et.EntStageName
	ORDER BY BookingGroup;

-- Q42 
SELECT a.AgentID,
       a.AgtFirstName,
       a.AgtLastName,
       COALESCE(SUM(e.ContractPrice), 0) AS TotalBookingsValue,
       RANK() OVER (ORDER BY COALESCE(SUM(e.ContractPrice), 0) DESC) AS AgentRank
	FROM AGENTS a
	LEFT JOIN ENGAGEMENTS e ON a.AgentID = e.AgentID
	GROUP BY a.AgentID, a.AgtFirstName, a.AgtLastName
	ORDER BY TotalBookingsValue DESC;

-- Q43
SELECT 
    e.StartDate,
    CONCAT(c.CustFirstName, ' ', c.CustLastName) AS CustomerName,
    et.EntStageName,
    COUNT(e.EngagementNumber) OVER (PARTITION BY et.EntertainerID) AS TotalBookings
	FROM ENGAGEMENTS e
	JOIN ENTERTAINERS et ON e.EntertainerID = et.EntertainerID
	JOIN CUSTOMERS c ON e.CustomerID = c.CustomerID
	ORDER BY et.EntStageName, e.StartDate;


-- Q44
SELECT 
    et.EntertainerID,
    et.EntStageName,
    em.MemberID,
    mbr.MbrFirstName,
    mbr.MbrLastName,
    ROW_NUMBER() OVER (PARTITION BY et.EntertainerID ORDER BY em.MemberID) AS MemberNumber
	FROM ENTERTAINERS et
	JOIN ENTERTAINER_MEMBERS em ON et.EntertainerID = em.EntertainerID
	JOIN MEMBERS mbr ON em.MemberID = mbr.MemberID
	ORDER BY et.EntertainerID, MemberNumber;

	

-- Account Payable Database
USE accountspayable;

-- Q1 
SELECT COUNT(*) AS UnpaidInvoiceCount, SUM(invoice_total - payment_total) AS TotalDue
	FROM invoices
	WHERE payment_total < invoice_total OR payment_date IS NULL OR payment_date > invoice_due_date;

-- Q2
SELECT i.*, v.*
	FROM invoices i
	JOIN vendors v ON i.vendor_id = v.vendor_id
	WHERE v.vendor_state = 'CA';

-- Q3 
SELECT *
	FROM invoices
	WHERE vendor_id IN (
		SELECT vendor_id
		FROM vendors
		WHERE vendor_state = 'CA'
);

-- Q4 
SELECT v.*
	FROM vendors v
	LEFT JOIN invoices i ON v.vendor_id = i.vendor_id
	WHERE i.invoice_id IS NULL;

-- Q5 
SELECT v.*
	FROM vendors v
	LEFT JOIN (
		SELECT DISTINCT vendor_id
		FROM invoices
	) as inv ON v.vendor_id = inv.vendor_id
	WHERE inv.vendor_id IS NULL;

-- Q6 
SELECT *
	FROM invoices
	WHERE invoice_total - payment_total < (SELECT AVG(invoice_total - payment_total) FROM invoices);

-- Q7 
SELECT v.vendor_name, i.invoice_number, i.invoice_total
	FROM invoices i
	JOIN vendors v ON i.vendor_id = v.vendor_id
	WHERE i.invoice_total > (
	  SELECT MAX(invoice_total)
	  FROM invoices
	  WHERE vendor_id = 34
);

-- Q8 
SELECT v.vendor_name, i.invoice_number, i.invoice_total
	FROM invoices i
	JOIN vendors v ON i.vendor_id = v.vendor_id
	WHERE i.invoice_total < (SELECT MAX(invoice_total) FROM invoices WHERE vendor_id = 115);

-- Q9 
SELECT vendor_name, 
       (SELECT MAX(invoice_date) FROM invoices i2 WHERE i2.vendor_id = v.vendor_id) as LatestInvoiceDate
FROM vendors v;

-- Q10 
SELECT v.vendor_name, MAX(i.invoice_date) as LatestInvoiceDate
	FROM vendors v
	JOIN invoices i ON v.vendor_id = i.vendor_id
	GROUP BY v.vendor_name;

-- Q11
SELECT i.*
	FROM invoices i
	WHERE i.invoice_total > (SELECT AVG(invoice_total) FROM invoices WHERE vendor_id = i.vendor_id);

-- Q12 
SELECT v.vendor_state, MAX(i.invoice_total)
	FROM vendors v
	JOIN invoices i ON v.vendor_id = i.vendor_id
	GROUP BY v.vendor_state;
    
-- Q13 
SELECT gl.account_description, COUNT(li.invoice_sequence) AS NumberOfLineItems, SUM(li.line_item_amount) AS TotalLineItemAmount
	FROM general_ledger_accounts gl
	JOIN invoice_line_items li ON gl.account_number = li.account_number
	GROUP BY gl.account_description
	HAVING COUNT(li.invoice_sequence) > 1;

-- Q14
SELECT 
    gl.account_number, 
    SUM(ili.line_item_amount) AS total_amount_invoiced
FROM 
    general_ledger_accounts gl
JOIN 
    invoice_line_items ili ON gl.account_number = ili.account_number
GROUP BY 
    gl.account_number
WITH ROLLUP;

-- Q15 
SELECT 
    v.vendor_id, 
    v.vendor_name
FROM 
    vendors v
JOIN 
    invoices i ON v.vendor_id = i.vendor_id
JOIN 
    invoice_line_items ili ON i.invoice_id = ili.invoice_id
GROUP BY 
    v.vendor_id
HAVING 
    COUNT(DISTINCT ili.account_number) > 1;

-- Q16 
SELECT 
    v.vendor_id, 
    i.terms_id, 
    MAX(i.payment_date) AS last_payment_date, 
    SUM(i.invoice_total) AS total_amount_due
FROM 
    vendors v
JOIN 
    invoices i ON v.vendor_id = i.vendor_id
GROUP BY 
    v.vendor_id, i.terms_id
WITH ROLLUP;

-- Q17 
SELECT 
    CONCAT('$', FORMAT(invoice_total, 2)) AS invoice_total_with_sign
FROM 
    invoices;

-- Q18 
SELECT 
    DATE_FORMAT(invoice_date, '%Y-%m-%d') AS char_invoice_date, 
    CAST(invoice_total AS UNSIGNED) AS int_invoice_total
FROM 
    invoices;

-- Q19 
SELECT 
    LPAD(invoice_number, 3, '0') AS padded_invoice_number
FROM 
    invoices;

-- Q20
SELECT 
    FORMAT(invoice_total, 1) AS one_decimal,
    FORMAT(invoice_total, 0) AS no_decimal
FROM 
    invoices;

-- Q21
CREATE TABLE date_sample
(
  date_id INT NOT NULL,
  start_date DATETIME
);

INSERT INTO date_sample (date_id, start_date) VALUES
(1, '1986-03-01 00:00:00'),
(2, '2006-02-28 00:00:00'),
(3, '2010-10-31 00:00:00'),
(4, '2018-02-28 10:00:00'),
(5, '2019-02-28 13:58:32'),
(6, '2019-03-01 09:02:25');

SELECT 
  start_date,
  DATE_FORMAT(start_date, '%b/%d/%y') AS Format1,
  DATE_FORMAT(start_date, '%c/%e/%y') AS Format2,
  DATE_FORMAT(start_date, '%l:%i %p') AS Format3
FROM date_sample;

-- Q22
SELECT
	  vendor_name,
	  UPPER(vendor_name) AS vendor_name_uppercase,
	  vendor_phone,
	  RIGHT(vendor_phone, 4) AS last_four_digits_of_phone,
	  REPLACE(vendor_phone, '-', '.') AS phone_with_dots,
	  COALESCE(NULLIF(SUBSTRING_INDEX(SUBSTRING_INDEX(vendor_name, ' ', 2), ' ', -1), vendor_name), '') AS second_word_in_name
	FROM vendors;

-- Q23
 SELECT
	  invoice_number,
	  invoice_date,
	  DATE_ADD(invoice_date, INTERVAL 30 DAY) AS invoice_date_plus_30,
	  payment_date,
	  DATEDIFF(payment_date, invoice_date) AS days_to_pay,
	  MONTH(invoice_date) AS invoice_month_number,
	  YEAR(invoice_date) AS invoice_year
	FROM invoices
	WHERE MONTH(invoice_date) = 5;

-- Q24 
CREATE TABLE string_sample
(
  emp_id VARCHAR(3),
  emp_name VARCHAR(25)
);

INSERT INTO string_sample (emp_id, emp_name) VALUES
('1', 'Lizbeth Darien'),
('2', 'Darnell O''Sullivan'),
('17', 'Lance Pinos-Potter'),
('20', 'Jean Paul Renard'),
('3', 'Alisha von Strump');

-- Query using regular expressions
SELECT 
  emp_name,
  REGEXP_SUBSTR(emp_name, '^[^ ]+') AS first_name,
  REGEXP_SUBSTR(emp_name, '[^- '' ]+$') AS last_name
FROM string_sample;

-- Q25 
SELECT
  vendor_id,
  (invoice_total - payment_total - credit_total) AS balance_due,
  SUM(invoice_total - payment_total - credit_total) OVER (ORDER BY vendor_id) AS total_balance_due,
  SUM(invoice_total - payment_total - credit_total) OVER (PARTITION BY vendor_id ORDER BY vendor_id) AS vendor_balance_due
FROM invoices;

-- Q26 
SELECT
  vendor_id,
  (invoice_total - payment_total - credit_total) AS balance_due,
  SUM(invoice_total - payment_total - credit_total) OVER (ORDER BY vendor_id) AS total_balance_due,
  SUM(invoice_total - payment_total - credit_total) OVER (PARTITION BY vendor_id ORDER BY vendor_id) AS vendor_balance_due,
  AVG(invoice_total - payment_total - credit_total) OVER (PARTITION BY vendor_id) AS avg_balance_due
FROM invoices;

-- Q27 
SELECT
	  MONTH(invoice_date) AS invoice_month,
	  SUM(invoice_total) AS monthly_invoice_total,
	  AVG(SUM(invoice_total)) OVER (
		ORDER BY YEAR(invoice_date), MONTH(invoice_date)
		ROWS BETWEEN 3 PRECEDING AND CURRENT ROW
	  ) AS four_month_moving_average
	FROM invoices
	GROUP BY YEAR(invoice_date), MONTH(invoice_date)
	ORDER BY YEAR(invoice_date), MONTH(invoice_date);

-- Window Functions Query 1 
CREATE TEMPORARY TABLE IF NOT EXISTS TableValues (ID INT, Data INT);

INSERT INTO TableValues (ID, Data) VALUES
(1,100), (2,100), (3,NULL),
(4,NULL), (5,600), (6,NULL),
(7,500), (8,1000), (9,1300),
(10,1200), (11,NULL);

SET @last_non_null := 0;

SELECT
  ID,
  @last_non_null := COALESCE(Data, @last_non_null) AS Data
FROM TableValues
ORDER BY ID;

-- Window Functions Query 2 
CREATE TEMPORARY TABLE IF NOT EXISTS Registrations (
  ID INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
  DateJoined DATE NOT NULL,
  DateLeft DATE NULL
);

DELIMITER //
CREATE PROCEDURE PopulateData()
BEGIN
  DECLARE i INT DEFAULT 0;
  DECLARE randomDays INT;
  WHILE i < 10000 DO
    SET randomDays = FLOOR(RAND() * 5 * 365);
    INSERT INTO Registrations (DateJoined) VALUES (DATE_ADD('2011-01-01', INTERVAL randomDays DAY));
    SET i = i + 1;
  END WHILE;
END //
DELIMITER ;

CALL PopulateData();
DROP PROCEDURE PopulateData;

SET @updateCount := FLOOR((SELECT COUNT(*) FROM Registrations) * 0.75);

UPDATE Registrations
SET DateLeft = DATE_ADD(DateJoined, INTERVAL FLOOR(RAND() * 5 * 365) DAY)
WHERE ID <= @updateCount;

SELECT 
	  LAST_DAY(DateJoined) AS MonthEnding,
	  COUNT(*) AS NumberSubscribed,
	  SUM(CASE WHEN DateLeft IS NOT NULL THEN 1 ELSE 0 END) AS NumberUnsubscribed,
	  SUM(CASE WHEN DateLeft IS NULL OR DateLeft > LAST_DAY(DateJoined) THEN 1 ELSE 0 END) AS ActiveSubscriptions
	FROM Registrations
	GROUP BY MonthEnding
	ORDER BY MonthEnding;


-- Window Functions Query 3 
DROP TABLE IF EXISTS TimeCards;

CREATE TABLE TimeCards (
  TimeStampID INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
  EmployeeID INT NOT NULL,
  ClockDateTime DATETIME(0) NOT NULL,
  EventType VARCHAR(5) NOT NULL
);

INSERT INTO TimeCards (EmployeeID, ClockDateTime, EventType) VALUES
(1, '2023-01-02 08:00', 'ENTER'),
(2, '2023-01-02 08:03', 'ENTER'),
(2, '2023-01-02 12:00', 'EXIT'),
(2, '2023-01-02 12:34', 'ENTER'),
(3, '2023-01-02 16:30', 'ENTER'),
(2, '2023-01-02 16:00', 'EXIT'),
(1, '2023-01-02 16:07', 'EXIT'),
(3, '2023-01-03 01:00', 'EXIT'),
(2, '2023-01-03 08:10', 'ENTER'),
(1, '2023-01-03 08:15', 'ENTER'),
(2, '2023-01-03 12:17', 'EXIT'),
(3, '2023-01-03 16:00', 'ENTER'),
(1, '2023-01-03 15:59', 'EXIT'),
(3, '2023-01-04 01:00', 'EXIT');

SELECT 
    EmployeeID,
    DATE(ClockDateTime) AS WorkDate,
    SEC_TO_TIME(SUM(TIME_TO_SEC(TIMEDIFF(NextClockDateTime, ClockDateTime)))) AS TimeWorked
FROM (
    SELECT 
        EmployeeID, 
        ClockDateTime,
        EventType,
        LEAD(ClockDateTime) OVER (PARTITION BY EmployeeID ORDER BY ClockDateTime) AS NextClockDateTime
    FROM 
        TimeCards
    WHERE 
        EventType = 'ENTER' OR EventType = 'EXIT'
) AS Shifts
WHERE 
    EventType = 'ENTER'
GROUP BY 
    EmployeeID, WorkDate;


-- SQL Server Window Functions Query 4 (Completed in MySQL instead of SQL Server)
DROP TABLE IF EXISTS FolderHierarchy;

CREATE TABLE FolderHierarchy (
  ID INTEGER PRIMARY KEY,
  Name VARCHAR(100),
  ParentID INTEGER
);

INSERT INTO FolderHierarchy (ID, Name, ParentID) VALUES
(1, 'my_folder', NULL),
(2, 'my_documents', 1),
(3, 'events', 2),
(4, 'meetings', 3),
(5, 'conferences', 3),
(6, 'travel', 3),
(7, 'integration', 3),
(8, 'out_of_town', 4),
(9, 'abroad', 8),
(10, 'in_town', 4);

WITH RECURSIVE PathCTE AS (
  SELECT ID, Name, ParentID, CONCAT('/', Name, '/') AS Path
  FROM FolderHierarchy
  WHERE ParentID IS NULL
  UNION ALL
  SELECT f.ID, f.Name, f.ParentID, CONCAT(p.Path, f.Name, '/') AS Path
  FROM FolderHierarchy f
  JOIN PathCTE p ON f.ParentID = p.ID
)
SELECT * FROM PathCTE;

-- Window Functions Query 5 
DROP TABLE IF EXISTS Destination;

CREATE TABLE Destination (
  ID INTEGER PRIMARY KEY,
  Name VARCHAR(100)
);

INSERT INTO Destination VALUES
(1, 'Warsaw'),
(2, 'Berlin'),
(3, 'Bucharest'),
(4, 'Prague');

DROP TABLE IF EXISTS Ticket;

CREATE TABLE Ticket (
  CityFrom INTEGER,
  CityTo INTEGER,
  Cost INTEGER
);

INSERT INTO Ticket VALUES
(1, 2, 350),
(1, 3, 80),
(1, 4, 220),
(2, 3, 410),
(2, 4, 230),
(3, 2, 160),
(3, 4, 110),
(4, 2, 140),
(4, 3, 75);

WITH RECURSIVE TravelPath AS (
  SELECT 
    d.Name AS Path,
    t.CityTo AS LastId,
    t.Cost AS TotalCost,
    1 AS NumPlacesVisited
  FROM 
    Destination d
  JOIN 
    Ticket t ON d.ID = t.CityFrom
  WHERE 
    d.Name = 'Warsaw'
  
  UNION ALL
  
SELECT 
    CONCAT(tp.Path, ' -> ', d.Name),
    t.CityTo,
    tp.TotalCost + t.Cost,
    tp.NumPlacesVisited + 1
  FROM 
    TravelPath tp
  JOIN 
    Ticket t ON tp.LastId = t.CityFrom
  JOIN 
    Destination d ON t.CityTo = d.ID
  WHERE 
    tp.Path NOT LIKE CONCAT('%', d.Name, '%') AND
    tp.NumPlacesVisited < 4
)
SELECT 
  Path,
  LastId,
  TotalCost,
  NumPlacesVisited
FROM 
  TravelPath
WHERE 
  NumPlacesVisited = 4
ORDER BY 
  TotalCost DESC;
