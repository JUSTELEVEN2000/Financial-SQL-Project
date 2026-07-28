# Financial SQL Project

## Overview

This project is a financial data analysis project that combines **MySQL database management** and **Python data analysis**.

The project stores company financial data and stock price data in MySQL, retrieves data through SQL queries, and performs financial analysis using Python.

The main purpose is to analyze corporate financial performance indicators and explore the relationship between ROE and stock return performance.

---

## Tech Stack

- Python 3.14
- MySQL
- SQL
- pandas
- matplotlib
- mysql-connector-python
- python-dotenv
- Git / GitHub

---

## Project Structure
```text
Financial_SQL_Project
│
├── python
│   ├── mysql_analysis.py
│   ├── database.py
│   ├── charts.py
│   └── requirements.txt
│
├── sql
│   └── database.sql
│
├── screenshots
│   ├── ROE Comparison.png
│   ├── Stock Return Comparison.png
│   └── ROE vs Stock Return.png
│
├── .gitignore
├── README.md
└── .env (not included)
```

---

## Analysis Workflow
```text
MySQL Database
↓
SQL Query
↓
Python (pandas)
↓
Data Processing
↓
Financial Analysis
↓
Visualization
↓
Excel Report
```

---

## Database Design

The database contains three main tables:

### company

Stores basic company information.

Example:

| company_id | company_name |
|---|---|
| 1 | Toyota |
| 2 | Sony |
| 3 | Nintendo |

---

### financials

Stores annual financial indicators.

Main variables:

- ROE
- Revenue
- Year

---

### stock_price

Stores historical stock prices.

Main variables:

- Date
- Closing price

---

## Analysis Contents

### 1. ROE Comparison

Compare profitability among companies.

Output:

- ROE ranking
- ROE comparison chart


### 2. Stock Return Analysis

Calculate annual stock return:
Return Rate =
(End Price - Start Price) / Start Price

Output:

- Stock return ranking
- Stock return comparison chart


### 3. Relationship Between ROE and Stock Return

Explore whether companies with higher profitability show higher stock performance.

Output:

- Scatter plot of ROE vs Stock Return

---

## Example Output

The program generates:

- ROE Comparison chart
- Stock Return Comparison chart
- ROE vs Stock Return scatter plot
- Excel analysis report

Example result:
Average ROE: 14.73%
Average Stock Return: 19.23%

---

## How to Run

### 1. Install dependencies

```bash
pip install -r python/requirements.txt

2. Configure database environment variables

Create a .env file:

DB_HOST=localhost
DB_USER=your_username
DB_PASSWORD=your_password
DB_NAME=financial_project

3. Run analysis

From project root:

python python/mysql_analysis.py

---

```markdown
## Future Improvements

Possible extensions:

- Connect to real financial APIs
- Automatically update stock price data
- Add more companies and industries
- Build automated financial dashboards
