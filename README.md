# 🚗 Automotive Inventory Dashboard — SQL · Excel · Web

A real buy / recondition / resell operation (motorcycles + a few cars), tracked three ways:
a **SQLite database** with a 21-query analytical library, a self-updating **Excel** tracker,
and an interactive **web dashboard**. Built to show end-to-end data skills: schema design,
SQL analytics, spreadsheet modeling, and a front-end that anyone can use.

**Period:** Jul 2025 – Jun 2026 · **30 vehicles** · **25 sold, 5 in inventory**

> ### How the money actually worked (important context)
> This was bootstrapped from a **small bankroll that was recycled deal to deal** — buy a
> bike, fix it, sell it, roll the proceeds into the next one. The dollar totals below are
> **cumulative across all flips over the year**, *not* money held at any one time. For
> example, "total purchased" sums every buy price across all 30 vehicles; the actual cash
> in play at any moment was a small fraction of that.

---

## 📊 Results (from the real data)

| KPI | Value |
|---|---|
| Vehicles flipped (sold) | **25** |
| Total profit (realized) | **$25,025** |
| Return on cost (ROI) | **28.0%** |
| Avg profit per flip | $1,001 |
| Avg days to sell | ~15 |
| Total revenue *(cumulative, all sales)* | $114,525 |
| Total purchased *(cumulative cost across all flips)* | $104,900 |
| Currently in inventory | 5 vehicles · $15,400 cost |

Best volume-and-speed model: **Kawasaki Ninja 400** (6 sold, ~11 days each). Every vehicle
is a **50/50 partnership** (Zeshan / Asmaar), tracked down to each partner's cash share.

---

## 🗂️ What's in this repo

```
automotive-inventory-tracker/
├── README.md                  ← you are here
├── sql/
│   ├── 01_schema.sql          CREATE TABLE statements (vehicles + partners)
│   ├── 02_seed_data.sql       INSERTs to load the 30 vehicles + partner splits
│   ├── 03_queries.sql         21 analytical queries (KPIs, trends, window fns, JOINs)
│   └── automotive_inventory.db prebuilt SQLite database (ready to open)
├── data/
│   └── automotive_inventory.csv  flat export of the dataset
├── excel/
│   └── Automotive_Inventory_Tracker.xlsx  Inventory + Sales dashboards (live formulas)
└── docs/
    ├── index.html             the interactive web dashboard (GitHub Pages entry point)
    ├── explainer-website.html one-page walkthrough of the web app (for recruiters)
    ├── explainer-excel.html   one-page walkthrough of the Excel build
    ├── explainer-sql.html     one-page walkthrough of the SQL
    └── STUDY_GUIDE.md         plain-English walkthrough of the whole project
```

---

## 👀 Recruiter walkthroughs (one page each)

Short, plain-English pages explaining each part — once GitHub Pages is on, share these links:

- **The Web Dashboard** — https://zeshanmurtaza.github.io/automotive-inventory-tracker/explainer-website.html
- **The Excel Tracker** — https://zeshanmurtaza.github.io/automotive-inventory-tracker/explainer-excel.html
- **The SQL Database** — https://zeshanmurtaza.github.io/automotive-inventory-tracker/explainer-sql.html

(Or open the matching `docs/explainer-*.html` files locally in a browser.)

---

## ▶️ See the SQL (no install needed)

The SQL is plain text — just click into the [`sql/`](sql/) folder on GitHub to read it.
To **run** it:

**Easiest (visual):** download the free [DB Browser for SQLite](https://sqlitebrowser.org),
open `sql/automotive_inventory.db`, go to **Execute SQL**, and paste any block from
`sql/03_queries.sql`.

**Command line:**
```bash
# rebuild the DB from text, then run the query library
sqlite3 automotive.db < sql/01_schema.sql
sqlite3 automotive.db < sql/02_seed_data.sql
sqlite3 automotive.db < sql/03_queries.sql
```

The query library covers: KPI scorecard, ROI & margin, monthly trend, profit by make/model,
top & bottom flips, cars vs. bikes, inventory aging, speed-vs-profit, **window functions**
(running cumulative profit, each sale vs. its brand average), a reusable **view**, and
**JOINs** to the partners table for per-partner contributions.

---

## 🌐 Use the live dashboard

The web dashboard runs entirely in the browser (no server, no install).

- **Locally:** open `docs/index.html` in any browser.
- **Online (recommended for recruiters):** enable **GitHub Pages** →
  *Settings → Pages → Build from branch → `main` / `docs`*. Your dashboard goes live at
  `https://zeshanmurtaza.github.io/automotive-inventory-tracker/`.

Add a vehicle, mark one sold, log the buyer and partner split — the Inventory and Sales
views update instantly.

---

## 📈 Use the Excel tracker

Open `excel/Automotive_Inventory_Tracker.xlsx`. The **Data** tab is where you type; the
**Inventory** and **Sales** dashboards recalculate automatically (KPIs, charts, partner
percentages). Works in Excel, Google Sheets, or LibreOffice.

---

## 🛠️ Skills demonstrated

- **SQL:** schema design with constraints & indexes, aggregations, `GROUP BY`/`HAVING`,
  subqueries, **window functions**, a **view**, and **JOINs** across a related `partners` table.
- **Data modeling:** one-to-many relationship (vehicles → partners), derived metrics
  (profit, ROI, days-to-sell, inventory aging).
- **Excel:** `SUMIFS`/`COUNTIFS`/`AVERAGEIFS`, `INDEX`/`MATCH`, auto-calculating partner
  splits, dashboards driven entirely by formulas.
- **Front-end:** a self-contained HTML/JS app with live charts and local persistence.

---

*Data is the operator's real flip records (Jul 2025 – Jun 2026). Figures are cumulative
across all deals on a small, recycled bankroll.*
