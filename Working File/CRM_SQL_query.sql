-- ============================================================
-- CRM SQL Queries
-- Extracted from DB Browser for SQLite project file
-- Source DB: CRM_data.db (table: crm_data)
-- ============================================================


-- ============================================================
-- Query: Resolved and Active
-- ============================================================
WITH classified AS(
	SELECT *,
		CASE
			WHEN Status IN ("Customer", "Churned Customer") THEN "Won"
			WHEN Status = "Disqualified" THEN "Lost"
			WHEN Status = "Opportunity" AND Stage = "Won" THEN "Won"
			WHEN Status = "Opportunity" AND Stage = "Lost" THEN "Lost"
			ELSE "Still Active (in progress)"
		END AS outcome
	FROM crm_data
)
SELECT
	outcome,
	COUNT(*) AS leads,
	ROUND(100.0 * COUNT(*) / (SELECT COUNT(*) FROM classified), 1) AS "% of all leads",
	CASE WHEN outcome = "Still Active (in progress)" THEN NULL
	ELSE ROUND(100.0 * COUNT(*) / (SELECT COUNT(*) FROM classified WHERE outcome != "Still Active (in progress)"), 1)
    END AS "% of resolved only"
FROM classified
GROUP BY outcome
ORDER BY leads DESC;


-- ============================================================
-- Query: Lead Distribution (Country)
-- ============================================================
WITH classified AS(
	SELECT *,
		CASE
			WHEN Status IN ("Customer", "Churned Customer") THEN "Won"
			WHEN Status = "Disqualified" THEN "Lost"
			WHEN Status = "Opportunity" AND Stage = "Won" THEN "Won"
			WHEN Status = "Opportunity" AND Stage = "Lost" THEN "Lost"
			ELSE "Still Active (in progress)"
		END AS outcome
	FROM crm_data
), by_country AS(
	SELECT
		Country,
		COUNT(*) AS "Total leads",
		SUM(CASE WHEN outcome = "Won" THEN 1 ELSE 0 END) AS "Successful deals",
		ROUND(100.0 * SUM(CASE WHEN outcome = "Won" THEN 1 ELSE 0 END)
			  / SUM(CASE WHEN outcome != "Still Active (in progress)" THEN 1 ELSE 0 END), 1) AS "% of successful of resolved cases",
		ROUND(AVG(CASE WHEN outcome = "Won" THEN "Deal Value, $" END), 1) AS "avg value of successful deals"
	FROM classified
	GROUP BY Country
), score AS (
	SELECT
		Country,
		"Total leads",
		NTILE(5) OVER (ORDER BY "Total leads")  AS "Total leads score",
		"Successful deals",
		NTILE(5) OVER (ORDER BY "Successful deals")  AS "Successful deals score",
		"% of successful of resolved cases",
		NTILE(5) OVER (ORDER BY "% of successful of resolved cases")    AS "% successful deals score",
		"avg value of successful deals",
		NTILE(5) OVER (ORDER BY "avg value of successful deals")     AS "avg value of successful deals score"
	FROM by_country
)
SELECT
	Country,
	("Total leads score" + "Successful deals score" + "% successful deals score" + "avg value of successful deals score") AS "Total score",
	"Total leads",
	"Total leads score",
	"Successful deals",
	"Successful deals score",
	"% of successful of resolved cases",
	"% successful deals score",
	"avg value of successful deals",
	"avg value of successful deals score"
FROM Score
ORDER BY "Total score" DESC;


-- ============================================================
-- Query: Lead Dist (Industry)
-- ============================================================
WITH classified AS(
	SELECT *,
		CASE
			WHEN Status IN ("Customer", "Churned Customer") THEN "Won"
			WHEN Status = "Disqualified" THEN "Lost"
			WHEN Status = "Opportunity" AND Stage = "Won" THEN "Won"
			WHEN Status = "Opportunity" AND Stage = "Lost" THEN "Lost"
			ELSE "Still Active (in progress)"
		END AS outcome
	FROM crm_data
), by_industry AS(
	SELECT
		Industry,
		COUNT(*) AS "Total leads",
		SUM(CASE WHEN outcome = "Won" THEN 1 ELSE 0 END) AS "Successful deals",
		ROUND(100.0 * SUM(CASE WHEN outcome = "Won" THEN 1 ELSE 0 END)
			  / SUM(CASE WHEN outcome != "Still Active (in progress)" THEN 1 ELSE 0 END), 1) AS "% of successful of resolved cases",
		ROUND(AVG(CASE WHEN outcome = "Won" THEN "Deal Value, $" END), 1) AS "avg value of successful deals"
	FROM classified
	GROUP BY Industry
), score AS (
	SELECT
		Industry,
		"Total leads",
		NTILE(5) OVER (ORDER BY "Total leads")  AS "Total leads score",
		"Successful deals",
		NTILE(5) OVER (ORDER BY "Successful deals")  AS "Successful deals score",
		"% of successful of resolved cases",
		NTILE(5) OVER (ORDER BY "% of successful of resolved cases")    AS "% successful deals score",
		"avg value of successful deals",
		NTILE(5) OVER (ORDER BY "avg value of successful deals")     AS "avg value of successful deals score"
	FROM by_industry
)
SELECT
	Industry,
	("Total leads score" + "Successful deals score" + "% successful deals score" + "avg value of successful deals score") AS "Total score",
	"Total leads",
	"Total leads score",
	"Successful deals",
	"Successful deals score",
	"% of successful of resolved cases",
	"% successful deals score",
	"avg value of successful deals",
	"avg value of successful deals score"
FROM Score
ORDER BY "Total score" DESC;


-- ============================================================
-- Query: Lead Dist (Product)
-- ============================================================
WITH classified AS(
	SELECT *,
		CASE
			WHEN Status IN ("Customer", "Churned Customer") THEN "Won"
			WHEN Status = "Disqualified" THEN "Lost"
			WHEN Status = "Opportunity" AND Stage = "Won" THEN "Won"
			WHEN Status = "Opportunity" AND Stage = "Lost" THEN "Lost"
			ELSE "Still Active (in progress)"
		END AS outcome
	FROM crm_data
), by_prod AS(
	SELECT
		Product,
		COUNT(*) AS "Total leads",
		SUM(CASE WHEN outcome = "Won" THEN 1 ELSE 0 END) AS "Successful deals",
		ROUND(100.0 * SUM(CASE WHEN outcome = "Won" THEN 1 ELSE 0 END)
			  / SUM(CASE WHEN outcome != "Still Active (in progress)" THEN 1 ELSE 0 END), 1) AS "% of successful of resolved cases",
		ROUND(AVG(CASE WHEN outcome = "Won" THEN "Deal Value, $" END), 1) AS "avg value of successful deals"
	FROM classified
	GROUP BY Product
), score AS (
	SELECT
		Product,
		"Total leads",
		NTILE(3) OVER (ORDER BY "Total leads")  AS "Total leads score",
		"Successful deals",
		NTILE(3) OVER (ORDER BY "Successful deals")  AS "Successful deals score",
		"% of successful of resolved cases",
		NTILE(3) OVER (ORDER BY "% of successful of resolved cases")    AS "% successful deals score",
		"avg value of successful deals",
		NTILE(3) OVER (ORDER BY "avg value of successful deals")     AS "avg value of successful deals score"
	FROM by_prod
)
SELECT
	Product,
	("Total leads score" + "Successful deals score" + "% successful deals score" + "avg value of successful deals score") AS "Total score",
	"Total leads",
	"Total leads score",
	"Successful deals",
	"Successful deals score",
	"% of successful of resolved cases",
	"% successful deals score",
	"avg value of successful deals",
	"avg value of successful deals score"
FROM Score
ORDER BY "Total score" DESC;


-- ============================================================
-- Query: Agent performance
-- ============================================================
WITH classified AS(
	SELECT *,
		CASE
			WHEN Status IN ("Customer", "Churned Customer") THEN "Won"
			WHEN Status = "Disqualified" THEN "Lost"
			WHEN Status = "Opportunity" AND Stage = "Won" THEN "Won"
			WHEN Status = "Opportunity" AND Stage = "Lost" THEN "Lost"
			ELSE "Still Active (in progress)"
		END AS outcome
	FROM crm_data
), by_agent AS(
	SELECT
		Owner,
		COUNT(*) AS "Total leads",
		SUM(CASE WHEN outcome = "Won" THEN 1 ELSE 0 END) AS "Successful deals",
		ROUND(100.0 * SUM(CASE WHEN outcome = "Won" THEN 1 ELSE 0 END)
			  / SUM(CASE WHEN outcome != "Still Active (in progress)" THEN 1 ELSE 0 END), 1) AS "% of successful of resolved cases",
		ROUND(AVG(CASE WHEN outcome = "Won" THEN "Deal Value, $" END), 1) AS "avg value of successful deals"
	FROM classified
	GROUP BY Owner
), score AS (
	SELECT
		Owner,
		"Total leads",
		NTILE(5) OVER (ORDER BY "Total leads")  AS "Total leads score",
		"Successful deals",
		NTILE(5) OVER (ORDER BY "Successful deals")  AS "Successful deals score",
		"% of successful of resolved cases",
		NTILE(5) OVER (ORDER BY "% of successful of resolved cases")    AS "% successful deals score",
		"avg value of successful deals",
		NTILE(5) OVER (ORDER BY "avg value of successful deals")     AS "avg value of successful deals score"
	FROM by_agent
)
SELECT
	Owner,
	("Total leads score" + "Successful deals score" + "% successful deals score" + "avg value of successful deals score") AS "Total score",
	"Total leads",
	"Total leads score",
	"Successful deals",
	"Successful deals score",
	"% of successful of resolved cases",
	"% successful deals score",
	"avg value of successful deals",
	"avg value of successful deals score"
FROM Score
ORDER BY "Total score" DESC;


-- ============================================================
-- Query: Churn rate
-- ============================================================
SELECT 
	Status,
	COUNT(*) AS "Total customer",
	ROUND(100.0 * COUNT(*) / (SELECT COUNT(*) FROM crm_data WHERE Status IN ("Customer", "Churned Customer")),  1) AS "% of total customer",
	SUM("Deal Value, $") AS "Total deal value",
	ROUND(100.0 * SUM("Deal Value, $") / (SELECT SUM("Deal Value, $") FROM crm_data WHERE Status IN ("Customer", "Churned Customer")), 1) AS "% of total deal value"
FROM crm_data
WHERE Status IN ("Customer", "Churned Customer")
GROUP BY Status;


-- ============================================================
-- Query: Churn customer
-- ============================================================
WITH cust AS (
    SELECT *
    FROM crm_data
    WHERE Status IN ('Customer', 'Churned Customer')
),
churned AS (
    SELECT
        Owner,
        SUM(CASE WHEN Status = 'Customer' THEN 1 ELSE 0 END) AS current_customer_count,
        SUM(CASE WHEN Status = 'Churned Customer' THEN 1 ELSE 0 END) AS churned_customer_count,
        SUM(CASE WHEN Status = 'Churned Customer' THEN "Deal Value, $" ELSE 0 END) AS lost_deal_value
    FROM cust
    GROUP BY Owner
)
SELECT
    Owner,
    current_customer_count AS "Current customer count",
    churned_customer_count AS "Churned customer count",
    ROUND(100.0 * churned_customer_count / (churned_customer_count + current_customer_count), 1) AS "Churn rate %",
    lost_deal_value AS "Lost deal value",
    ROUND(100.0 * lost_deal_value / SUM(lost_deal_value) OVER (), 1) AS "% of total lost deal value"
FROM churned
ORDER BY "Churn rate %" DESC, lost_deal_value DESC;


-- ============================================================
-- Query: Lost rate
-- ============================================================
WITH classified AS(
	SELECT *,
		CASE
			WHEN Status IN ("Customer", "Churned Customer") THEN "Won"
			WHEN Status = "Disqualified" THEN "Lost"
			WHEN Status = "Opportunity" AND Stage = "Won" THEN "Won"
			WHEN Status = "Opportunity" AND Stage = "Lost" THEN "Lost"
			ELSE "Still Active (in progress)"
		END AS outcome
	FROM crm_data
)
SELECT 
	outcome,
	COUNT(*) AS leads,
	ROUND(100.0 * COUNT(*) / (SELECT COUNT(*) FROM classified), 1) AS "% of all leads",
	CASE WHEN outcome = "Still Active (in progress)" THEN NULL
	ELSE ROUND(100.0 * COUNT(*) / (SELECT COUNT(*) FROM classified WHERE outcome != "Still Active (in progress)"), 1)
    END AS "% of resolved only",
	SUM("Deal Value, $") AS "Deal value",
	ROUND(100.0 * SUM("Deal Value, $")/ (SELECT SUM("Deal Value, $") FROM classified), 1) AS "% of total value",
	CASE WHEN outcome = "Still Active (in progress)" THEN NULL
	ELSE ROUND(100.0 * SUM("Deal Value, $") / (SELECT SUM("Deal Value, $") FROM classified WHERE outcome IN ("Lost", "Won")),1)
	END AS "% of resolved deals"
FROM classified
GROUP BY outcome
ORDER BY "% of total value" DESC;


-- ============================================================
-- Query: Lost rate by categories
-- ============================================================
WITH outcomes AS (
    SELECT *,
        CASE
			WHEN Status IN ("Customer", "Churned Customer") THEN "Won"
			WHEN Status = "Disqualified" THEN "Lost"
			WHEN Status = "Opportunity" AND Stage = "Won" THEN "Won"
			WHEN Status = "Opportunity" AND Stage = "Lost" THEN "Lost"
			ELSE "Still Active (in progress)"
        END AS outcome
    FROM crm_data
),
per AS (
    SELECT
        Owner,
        SUM(CASE WHEN outcome = "Won" THEN 1 ELSE 0 END) AS won_count,
        SUM(CASE WHEN outcome = "Lost" THEN 1 ELSE 0 END) AS lost_count,
        SUM(CASE WHEN outcome = "Lost" THEN "Deal Value, $" ELSE 0 END) AS lost_deal_value
    FROM outcomes
    GROUP BY Owner
)
SELECT
    Owner,
    lost_count AS "Total lost deals",
    won_count AS "Total won deals",
    ROUND(100.0 * lost_count / (lost_count + won_count), 1) AS "% of resolved deals lost",
    lost_deal_value AS "Total lost deal value",
    ROUND(100.0 * lost_deal_value / SUM(lost_deal_value) OVER (), 1) AS "% of total lost value"
FROM per
ORDER BY "% of total lost value" DESC;
