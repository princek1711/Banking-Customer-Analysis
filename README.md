# 🏦 Banking Customer Analysis

A complete end-to-end data analytics project analyzing 3,000 banking customers across Python, MySQL, and Power BI.

---

## 📋 Project Overview

This project answers 10 real business questions for a bank:
- Which customer segments are most profitable?
- Which loyalty tiers carry the highest loan risk?
- How do deposits vary across nationalities and occupations?
- Who are the top 10% most valuable customers?

---

## 🛠️ Tools & Technologies

| Tool | Purpose |
|---|---|
| Python (Pandas, Seaborn, Matplotlib) | Data cleaning, EDA, feature engineering |
| MySQL 8.0 | Data storage, 15 business SQL queries |
| Power BI | 5-page interactive dashboard |
| SQLAlchemy + python-dotenv | Secure database connection |
| GitHub | Version control |

---

## 📁 Project Structure

```
BankingDataAnalysis/
├── data/
│   └── Banking.csv               # 3,000 customers, 25 features
├── notebooks/
│   └── Banking_EDA_Analysis.ipynb  # Full EDA with 10 business questions
├── sql/
│   └── Banking_queries.sql       # 15 queries: Basic → Advanced (CTEs, Window Functions)
├── dashboard/
│   └── dashboard.pbix            # Power BI 5-page interactive dashboard
├── assets/
│   └── *.png                     # Chart exports from EDA
├── .env                          # Credentials (not pushed to GitHub)
├── .gitignore
├── requirements.txt
└── README.md
```

---

## 📊 Dataset

- **Rows:** 3,000 banking customers
- **Columns:** 25 features
- **Source:** Banking customer records
- **Key fields:** Age, Income, Loans, Deposits, Loyalty Tier, Risk Score, Nationality, Occupation

---

## ⚙️ Feature Engineering

Created 6 new analytical features:

| Feature | Formula | Business Use |
|---|---|---|
| Age_Group | pd.cut(Age, bins) | Segment customers by life stage |
| Income_Band | pd.cut(Income, bins) | High/Mid/Low value classification |
| Tenure_Years | (Today - Joined_Bank) / 365 | Customer loyalty measurement |
| Total_Assets | Sum of all account types | Net wealth proxy |
| Loan_to_Income | Bank_Loans / Income | Risk indicator |
| Total_Products | Count of all products held | Engagement score |

---

## ❓ 10 Business Questions Answered

| # | Question | Key Finding |
|---|---|---|
| Q1 | Age & Gender distribution | 36-45 is largest segment |
| Q2 | Income band breakdown | Mid-income is majority |
| Q3 | Loyalty tier profitability | Higher tier = higher loans + assets |
| Q4 | Loan behavior by age | 36-55 carries highest loans |
| Q5 | Deposits by occupation | Top occupations hold 2x more assets |
| Q6 | Risk profile analysis | Risk varies significantly by income band |
| Q7 | Tenure vs products held | Longer tenure = more products |
| Q8 | Nationality vs income | Top nationalities earn 2x vs bottom |
| Q9 | Income vs total assets | Strong positive correlation |
| Q10 | Top customer segment | Premium 10% hold disproportionate value |

---

## 🗄️ SQL Highlights (15 Queries)

```sql
-- Level 1: Basic (SELECT, GROUP BY, ORDER BY)
-- Level 2: Intermediate (HAVING, NULLIF, subqueries)
-- Level 3: Advanced (CTEs, Window Functions - RANK() OVER, SUM() OVER)

-- Example: Rank customers by loan within loyalty tier
SELECT Client_ID, Name, Loyalty_Classification,
       RANK() OVER (
           PARTITION BY Loyalty_Classification
           ORDER BY Bank_Loans DESC
       ) AS Rank_Within_Tier
FROM customer;
```

---

## 📈 Power BI Dashboard

5-page interactive dashboard:
- **Home** — KPI overview + navigation
- **Loan Analysis** — Loan trends, loyalty tier, age group, occupation
- **Deposit Analysis** — Deposit growth, nationality, occupation breakdown
- **Risk Analysis** — Risk scoring, scatter analysis, riskiest segments
- **Summary** — Complete KPI summary

---

## 🚀 How to Run

```bash
# 1. Clone the repo
git clone https://github.com/princek1711/BankingDataAnalysis.git

# 2. Install dependencies
pip install -r requirements.txt

# 3. Set up .env file
DB_HOST=localhost
DB_USER=root
DB_PASSWORD=your_password
DB_NAME=Banking_case
DB_PORT=3306

# 4. Run the notebook
jupyter lab notebooks/Banking_EDA_Analysis.ipynb
```

---

## 👤 Author

**Prince Kumar**
- GitHub: [github.com/princek1711](https://github.com/princek1711)
- LinkedIn: [linkedin.com/in/princekumar](https://www.linkedin.com/in/prince-kumar-48446325a/)
