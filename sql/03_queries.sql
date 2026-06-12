-- ============================================================================
--  Automotive Inventory — Analytical Query Library
--  Database: automotive_inventory.db   |   Table: vehicles
--  Engine:   SQLite 3
--
--  Run a query:  sqlite3 automotive_inventory.db < queries.sql
--  Or open automotive_inventory.db in DB Browser for SQLite and paste a block.
-- ============================================================================

-- Schema reference -----------------------------------------------------------
--   id, make, model, year, vehicle_type, status,
--   buy_price, sell_price, profit, days_to_sell, purchase_date, sale_date
-- profit and sell_price are NULL for units still 'In Inventory'.

-- ----------------------------------------------------------------------------
-- 01. Headline KPIs (single-row scorecard)
-- ----------------------------------------------------------------------------
SELECT
    COUNT(*)                                           AS total_units,
    SUM(status = 'Sold')                               AS units_sold,
    SUM(status = 'In Inventory')                       AS units_in_inventory,
    ROUND(SUM(profit), 2)                              AS total_profit,
    ROUND(AVG(profit), 2)                              AS avg_profit_per_sale,
    ROUND(SUM(sell_price), 2)                          AS total_sales_cumulative,  -- gross sales summed across all flips (recycled bankroll)
    ROUND(SUM(CASE WHEN status='Sold' THEN buy_price END), 2) AS total_purchase_cost,
    ROUND(AVG(days_to_sell), 1)                        AS avg_days_to_sell
FROM vehicles;

-- ----------------------------------------------------------------------------
-- 02. Overall ROI and margin on sold units
-- ----------------------------------------------------------------------------
-- NOTE: total_purchase_cost is the CUMULATIVE cost of every vehicle bought over
-- the period, funded by a small bankroll that was recycled deal-to-deal. It is
-- NOT money held at one time. ROI here = return on that cumulative cost.
SELECT
    ROUND(SUM(profit), 2)                                          AS total_profit,
    ROUND(SUM(buy_price), 2)                                       AS total_purchase_cost,
    ROUND(100.0 * SUM(profit) / SUM(buy_price), 1)                 AS roi_pct,
    ROUND(100.0 * SUM(profit) / SUM(sell_price), 1)                AS net_margin_pct
FROM vehicles
WHERE status = 'Sold';

-- ----------------------------------------------------------------------------
-- 03. Monthly performance trend (revenue, profit, units, avg ROI)
-- ----------------------------------------------------------------------------
SELECT
    strftime('%Y-%m', sale_date)                       AS sale_month,
    COUNT(*)                                            AS units_sold,
    ROUND(SUM(sell_price), 2)                           AS sales,
    ROUND(SUM(profit), 2)                               AS profit,
    ROUND(AVG(days_to_sell), 1)                         AS avg_days_to_sell,
    ROUND(100.0 * SUM(profit) / SUM(buy_price), 1)      AS roi_pct
FROM vehicles
WHERE status = 'Sold'
GROUP BY sale_month
ORDER BY sale_month;

-- ----------------------------------------------------------------------------
-- 04. Profit & ROI by make (brand-level performance)
-- ----------------------------------------------------------------------------
SELECT
    make,
    COUNT(*)                                            AS units_sold,
    ROUND(SUM(profit), 2)                               AS total_profit,
    ROUND(AVG(profit), 2)                               AS avg_profit,
    ROUND(100.0 * SUM(profit) / SUM(buy_price), 1)      AS roi_pct
FROM vehicles
WHERE status = 'Sold'
GROUP BY make
ORDER BY total_profit DESC;

-- ----------------------------------------------------------------------------
-- 05. Most profitable models (min 2 sales) ranked by avg profit
-- ----------------------------------------------------------------------------
SELECT
    make || ' ' || model                                AS model_name,
    COUNT(*)                                            AS units_sold,
    ROUND(AVG(profit), 0)                               AS avg_profit,
    ROUND(AVG(days_to_sell), 1)                         AS avg_days_to_sell
FROM vehicles
WHERE status = 'Sold'
GROUP BY model_name
HAVING COUNT(*) >= 2
ORDER BY avg_profit DESC;

-- ----------------------------------------------------------------------------
-- 06. Top 5 individual vehicles by profit
-- ----------------------------------------------------------------------------
SELECT year, make, model, buy_price, sell_price, profit, days_to_sell
FROM vehicles
WHERE status = 'Sold'
ORDER BY profit DESC
LIMIT 5;

-- ----------------------------------------------------------------------------
-- 07. Bottom 5 vehicles by profit (worst performers)
-- ----------------------------------------------------------------------------
SELECT year, make, model, buy_price, sell_price, profit, days_to_sell
FROM vehicles
WHERE status = 'Sold'
ORDER BY profit ASC
LIMIT 5;

-- ----------------------------------------------------------------------------
-- 08. Cars vs. motorcycles (segment comparison)
-- ----------------------------------------------------------------------------
SELECT
    vehicle_type,
    COUNT(*)                                            AS units_sold,
    ROUND(AVG(buy_price), 0)                            AS avg_buy,
    ROUND(AVG(profit), 0)                               AS avg_profit,
    ROUND(100.0 * SUM(profit) / SUM(buy_price), 1)      AS roi_pct
FROM vehicles
WHERE status = 'Sold'
GROUP BY vehicle_type;

-- ----------------------------------------------------------------------------
-- 09. Current inventory still held (capital tied up)
-- ----------------------------------------------------------------------------
SELECT
    id, year, make, model, buy_price, purchase_date,
    CAST(julianday('now') - julianday(purchase_date) AS INT) AS days_held
FROM vehicles
WHERE status = 'In Inventory'
ORDER BY days_held DESC;

-- ----------------------------------------------------------------------------
-- 10. Inventory aging buckets
-- ----------------------------------------------------------------------------
SELECT
    CASE
        WHEN julianday('now') - julianday(purchase_date) <= 30  THEN '0-30 days'
        WHEN julianday('now') - julianday(purchase_date) <= 60  THEN '31-60 days'
        WHEN julianday('now') - julianday(purchase_date) <= 90  THEN '61-90 days'
        ELSE '90+ days'
    END                                                 AS age_bucket,
    COUNT(*)                                            AS units,
    ROUND(SUM(buy_price), 0)                            AS capital_tied_up
FROM vehicles
WHERE status = 'In Inventory'
GROUP BY age_bucket
ORDER BY MIN(julianday('now') - julianday(purchase_date));

-- ----------------------------------------------------------------------------
-- 11. Speed vs. profit: do faster sales earn less?
-- ----------------------------------------------------------------------------
SELECT
    CASE
        WHEN days_to_sell <= 10 THEN '1) <=10 days'
        WHEN days_to_sell <= 20 THEN '2) 11-20 days'
        ELSE                         '3) 21+ days'
    END                                                 AS speed_bucket,
    COUNT(*)                                            AS units,
    ROUND(AVG(profit), 0)                               AS avg_profit,
    ROUND(AVG(days_to_sell), 1)                         AS avg_days
FROM vehicles
WHERE status = 'Sold'
GROUP BY speed_bucket
ORDER BY speed_bucket;

-- ----------------------------------------------------------------------------
-- 12. Running cumulative profit over time (window function)
-- ----------------------------------------------------------------------------
SELECT
    sale_date, make, model, profit,
    SUM(profit) OVER (ORDER BY sale_date, id) AS cumulative_profit
FROM vehicles
WHERE status = 'Sold'
ORDER BY sale_date, id;

-- ----------------------------------------------------------------------------
-- 13. Each sale vs. brand average (window function)
-- ----------------------------------------------------------------------------
SELECT
    make, model, profit,
    ROUND(AVG(profit) OVER (PARTITION BY make), 0)      AS brand_avg_profit,
    ROUND(profit - AVG(profit) OVER (PARTITION BY make), 0) AS vs_brand_avg
FROM vehicles
WHERE status = 'Sold'
ORDER BY make, profit DESC;

-- ----------------------------------------------------------------------------
-- 14. Profit by vehicle model-year (newer vs. older)
-- ----------------------------------------------------------------------------
SELECT
    CASE WHEN year >= 2021 THEN '2021+' ELSE 'Pre-2021' END AS age_group,
    COUNT(*)                                            AS units_sold,
    ROUND(AVG(buy_price), 0)                            AS avg_buy,
    ROUND(AVG(profit), 0)                               AS avg_profit
FROM vehicles
WHERE status = 'Sold'
GROUP BY age_group;

-- ----------------------------------------------------------------------------
-- 15. Monthly running total of units sold (cumulative pace)
-- ----------------------------------------------------------------------------
WITH monthly AS (
    SELECT strftime('%Y-%m', sale_date) AS m, COUNT(*) AS units
    FROM vehicles WHERE status = 'Sold' GROUP BY m
)
SELECT m AS sale_month, units,
       SUM(units) OVER (ORDER BY m) AS cumulative_units
FROM monthly ORDER BY m;

-- ----------------------------------------------------------------------------
-- 16. Best month by total profit (subquery)
-- ----------------------------------------------------------------------------
SELECT strftime('%Y-%m', sale_date) AS sale_month,
       ROUND(SUM(profit), 0) AS profit
FROM vehicles
WHERE status = 'Sold'
GROUP BY sale_month
ORDER BY profit DESC
LIMIT 1;

-- ----------------------------------------------------------------------------
-- 17. Reusable KPI view (create once, query anytime)
-- ----------------------------------------------------------------------------
DROP VIEW IF EXISTS v_monthly_kpi;
CREATE VIEW v_monthly_kpi AS
SELECT
    strftime('%Y-%m', sale_date)                   AS sale_month,
    COUNT(*)                                        AS units_sold,
    SUM(sell_price)                                 AS revenue,
    SUM(profit)                                     AS profit,
    ROUND(100.0 * SUM(profit) / SUM(buy_price), 1)  AS roi_pct
FROM vehicles
WHERE status = 'Sold'
GROUP BY sale_month;

SELECT * FROM v_monthly_kpi ORDER BY sale_month;

-- ----------------------------------------------------------------------------
-- 18. Buyers — who we sold to (once buyer_name is filled in on the Data side)
-- ----------------------------------------------------------------------------
SELECT buyer_name, buyer_contact, COUNT(*) AS vehicles_bought,
       ROUND(SUM(sell_price),0) AS total_spent
FROM vehicles
WHERE status = 'Sold' AND buyer_name IS NOT NULL AND buyer_name <> ''
GROUP BY buyer_name, buyer_contact
ORDER BY total_spent DESC;

-- ----------------------------------------------------------------------------
-- 19. Partner contributions per vehicle (JOIN to the partners table)
--     Each partner row records cash put in and/or the labor they did.
-- ----------------------------------------------------------------------------
SELECT v.year, v.make, v.model,
       p.partner_name,
       p.cash_contributed,
       p.labor_note
FROM vehicles v
JOIN partners p ON p.vehicle_id = v.id
ORDER BY v.purchase_date DESC, p.partner_name;

-- ----------------------------------------------------------------------------
-- 20. Total cash each partner has put in across all vehicles
-- ----------------------------------------------------------------------------
SELECT partner_name,
       COUNT(DISTINCT vehicle_id) AS vehicles_involved,
       ROUND(SUM(cash_contributed),0) AS total_cash_in
FROM partners
GROUP BY partner_name
ORDER BY total_cash_in DESC;

-- ----------------------------------------------------------------------------
-- 21. Most-sold models, fastest movers first
--     How often each model sells and how quickly (popularity + speed).
-- ----------------------------------------------------------------------------
SELECT
    make || ' ' || model            AS model_name,
    COUNT(*)                        AS times_sold,
    ROUND(AVG(days_to_sell), 1)     AS avg_days_to_sell,
    ROUND(AVG(profit), 0)           AS avg_profit
FROM vehicles
WHERE status = 'Sold'
GROUP BY model_name
ORDER BY times_sold DESC, avg_days_to_sell ASC;
