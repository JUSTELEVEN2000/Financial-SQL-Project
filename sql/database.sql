-- ==========================================
-- 1. 数据库初始化与建表模块
-- ==========================================

CREATE DATABASE IF NOT EXISTS financial_project;
USE financial_project;

-- 按照外键依赖的反向顺序删除旧表（必须先删有外键的子表，最后删主表）
DROP TABLE IF EXISTS stock_price;
DROP TABLE IF EXISTS financials;
DROP TABLE IF EXISTS company;

-- 重新创建公司基础信息表
CREATE TABLE company (
    company_id INT AUTO_INCREMENT PRIMARY KEY,
    company_name VARCHAR(100) NOT NULL,
    industry VARCHAR(50),
    country VARCHAR(50)
);

-- 重新创建公司财务指标表
CREATE TABLE financials (
    financial_id INT AUTO_INCREMENT PRIMARY KEY,
    company_id INT NOT NULL,
    year INT NOT NULL,
    revenue DECIMAL(15,2),
    net_income DECIMAL(15,2),
    assets DECIMAL(15,2),
    liabilities DECIMAL(15,2),
    roe DECIMAL(5,2),
    FOREIGN KEY (company_id) REFERENCES company(company_id)
);

-- 重新创建股票价格与市值表
CREATE TABLE stock_price (
    price_id INT AUTO_INCREMENT PRIMARY KEY,
    company_id INT NOT NULL,
    date DATE NOT NULL,
    close_price DECIMAL(10,2),
    market_cap DECIMAL(15,2),
    FOREIGN KEY (company_id) REFERENCES company(company_id)
);


-- ==========================================
-- 2. 基础数据插入模块 (Data Seed)
-- ==========================================

-- 导入公司基础数据
INSERT INTO company (company_name, industry, country) VALUES
('Toyota', 'Automobile', 'Japan'),
('Sony', 'Electronics', 'Japan'),
('Nintendo', 'Game', 'Japan'),
('Fast Retailing', 'Retail', 'Japan'),
('Keyence', 'Manufacturing', 'Japan');

-- 导入 2022 - 2024 年度财务数据
INSERT INTO financials (company_id, year, revenue, net_income, assets, liabilities, roe) VALUES
(1, 2022, 39000000, 2200000, 85000000, 47000000, 7.8),
(2, 2022, 11500000, 850000, 28000000, 17000000, 9.5),
(3, 2022, 1600000, 350000, 2300000, 650000, 20.0),
(4, 2022, 2500000, 250000, 4200000, 1900000, 11.5),
(5, 2022, 900000, 270000, 950000, 180000, 23.5),
(1, 2023, 45000000, 2451000, 90000000, 50000000, 8.5),
(2, 2023, 13000000, 1000000, 30000000, 18000000, 10.2),
(3, 2023, 1700000, 400000, 2500000, 700000, 22.5),
(4, 2023, 2760000, 310000, 4500000, 2000000, 12.8),
(5, 2023, 967000, 300000, 1000000, 200000, 25.0),
(1, 2024, 48000000, 2800000, 95000000, 52000000, 9.2),
(2, 2024, 14000000, 1100000, 32000000, 18500000, 11.0),
(3, 2024, 1900000, 450000, 2700000, 720000, 24.0),
(4, 2024, 3000000, 360000, 4800000, 2100000, 13.5),
(5, 2024, 1100000, 350000, 1150000, 220000, 27.0);

-- 导入 2024 股票时间序列价格
INSERT INTO stock_price (company_id, date, close_price, market_cap) VALUES
(1, '2024-01-05', 2600, 35000000),
(1, '2024-06-05', 3100, 42000000),
(1, '2024-12-05', 2900, 39000000),
(2, '2024-01-05', 13000, 16000000),
(2, '2024-06-05', 14000, 17000000),
(2, '2024-12-05', 15000, 18000000),
(3, '2024-01-05', 6500, 7500000),
(3, '2024-06-05', 8000, 9000000),
(3, '2024-12-05', 8500, 9500000);


-- ==========================================
-- 3. 基础财务交叉查询与过滤
-- ==========================================

-- 基础联查：企业年度 ROE 表现
SELECT 
    c.company_name, 
    f.year, 
    f.revenue, 
    f.roe
FROM company c
JOIN financials f ON c.company_id = f.company_id;

-- 过滤高 ROE (>10) 的企业
SELECT 
    c.company_name, 
    f.roe
FROM company c
JOIN financials f ON c.company_id = f.company_id
WHERE f.roe > 10;

-- 按净利润降序排列拓扑前 3 核心企业
SELECT 
    c.company_name, 
    f.net_income
FROM company c
JOIN financials f ON c.company_id = f.company_id
ORDER BY f.net_income DESC
LIMIT 3;

-- 子查询应用：找出净利润高于行业平均水平的公司
SELECT 
    company_id, 
    net_income
FROM financials
WHERE net_income > (
    SELECT AVG(net_income) 
    FROM financials
);


-- ==========================================
-- 4. 行业聚合与分组统计分析 (Aggregations)
-- ==========================================

-- 统计行业平均 ROE 水平
SELECT 
    c.industry, 
    AVG(f.roe) AS avg_roe
FROM company c
JOIN financials f ON c.company_id = f.company_id
GROUP BY c.industry;

-- 筛选平均 ROE 大于 15 的高回报行业
SELECT 
    c.industry, 
    AVG(f.roe) AS avg_roe
FROM company c
JOIN financials f ON c.company_id = f.company_id
GROUP BY c.industry
HAVING AVG(f.roe) > 15;


-- ==========================================
-- 5. 高阶财务分析与窗口函数 (Advanced Metrics)
-- ==========================================

-- 财务时间序列应用：计算各公司年度营收增长率 (LAG 函数)
WITH revenue_growth AS (
    SELECT
        company_id,
        year,
        revenue,
        LAG(revenue) OVER (PARTITION BY company_id ORDER BY year) AS previous_revenue
    FROM financials
)
SELECT
    company_id,
    year,
    revenue,
    previous_revenue,
    (revenue - previous_revenue) / previous_revenue AS growth_rate
FROM revenue_growth;

-- 基于条件分支 (CASE WHEN) 对企业表现进行评级 (2024年数据为例)
SELECT 
    c.company_name,
    f.roe,
    CASE 
        WHEN f.roe >= 20 THEN 'Excellent'
        WHEN f.roe >= 10 THEN 'Good'
        ELSE 'Normal'
    END AS roe_level
FROM company c
JOIN financials f ON c.company_id = f.company_id
WHERE f.year = 2024;

-- 窗口函数应用：2024年度行业 ROE 排名
SELECT 
    c.company_name,
    f.roe,
    RANK() OVER (ORDER BY f.roe DESC) AS roe_rank
FROM company c
JOIN financials f ON c.company_id = f.company_id
WHERE f.year = 2024;

-- 窗口函数应用：按年份分区对公司进行内部 ROE 排名
SELECT 
    c.company_name,
    f.year,
    f.roe,
    RANK() OVER (PARTITION BY f.year ORDER BY f.roe DESC) AS roe_rank
FROM company c
JOIN financials f ON c.company_id = f.company_id;


-- ==========================================
-- 6. 股票收益率与财务交叉核心看板 (Python数据源)
-- ==========================================

-- 核心分析：计算区间股票收益率并与 2024 财年指标进行联动分析
WITH stock_return AS (
    SELECT
        start_price.company_id,
        (end_price.close_price - start_price.close_price) / start_price.close_price AS return_rate
    FROM stock_price AS start_price
    JOIN stock_price AS end_price ON start_price.company_id = end_price.company_id
    WHERE start_price.date = '2024-01-05' 
      AND end_price.date = '2024-12-05'
),
company_analysis AS (
    SELECT
        c.company_name,
        f.roe,
        sr.return_rate
    FROM company c
    JOIN financials f ON c.company_id = f.company_id
    JOIN stock_return sr ON c.company_id = sr.company_id
    WHERE f.year = 2024
)
SELECT 
    CASE 
        WHEN roe >= 20 THEN 'High ROE'
        ELSE 'Low ROE'
    END AS roe_group,
    AVG(return_rate) AS avg_return
FROM company_analysis
GROUP BY roe_group;
