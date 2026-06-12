# Study Guide — Understand & Defend This Project (baby steps)

This is your cheat sheet. Read it before any interview. It explains, in the simplest
possible words, what you built, what each piece does, and exactly what to say.

---

## 1. The one-sentence story (memorize this)

> "I tracked a motorcycle buy-and-resell side business in a database and in Excel, then
> wrote SQL queries to measure profit, ROI, and how fast bikes sold."

That's it. That sentence is your whole project. Everything below just backs it up.

---

## 2. What is each file? (in baby words)

**`automotive_inventory.db` — the database.**
Think of it as one big table, like a spreadsheet, but stored in a way that SQL can read.
Each row = one bike (or car) you bought. Columns = make, model, price you paid, price you
sold for, profit, how many days it took to sell, dates. It has **30 rows**.

**`queries.sql` — the questions.**
SQL is just a language for *asking the database questions*. This file has 20 ready-made
questions like "how much profit total?" and "which brand made the most money?". You run a
question, the database hands back the answer as a little table.

**`Automotive_Inventory_Tracker.xlsx` — the Excel report.**
Same data, but in Excel with big number boxes (KPIs) and charts so a human can glance and
understand it. The numbers are *formulas*, not typed in — so if you change the data, the
report updates itself.

**`README.md` — the project description** for your GitHub/resume.

---

## 3. Words you must understand (so you don't freeze up)

| Word | Baby explanation |
|---|---|
| **Database** | A neat container that holds rows and columns of data. |
| **Table** | One grid of data inside the database. Yours is called `vehicles`. |
| **Row / record** | One bike. |
| **Column / field** | One piece of info about each bike (e.g. `buy_price`). |
| **Query** | A question you ask the database in SQL. |
| **SQL** | The language used to ask those questions. |
| **KPI** | "Key Performance Indicator" = an important number, like Total Profit. |
| **ROI** | "Return on Investment" = profit ÷ money spent. Shows how *efficient* the money was. |
| **Schema** | The blueprint: what columns exist and what type each holds. |

---

## 4. The 4 SQL building blocks (this is 90% of SQL)

Every query is just these pieces mixed together:

1. **SELECT** — *what columns do I want to see?*
2. **FROM** — *which table?* (always `vehicles` here)
3. **WHERE** — *filter the rows* (e.g. only `status = 'Sold'`)
4. **GROUP BY** — *bucket rows together and add them up* (e.g. one row per brand)

Plus three helpers:
- **SUM() / COUNT() / AVG()** — add up, count, or average a column.
- **ORDER BY** — sort the answer (biggest first, etc.).
- **JOIN / window functions** — fancier stuff; you have a couple to show you can go deeper.

If you understand "SELECT the columns FROM the table WHERE a condition, GROUP BY a category,"
you can read every query in the file.

---

## 5. Each query and its OUTCOME (what the answer actually is)

These are the real results from *your* data. Knowing the outcome is how you "back it up."

**Total scorecard**
- 30 vehicles tracked, **25 sold**, 5 still in inventory.
- **Total profit: $25,025.** Total revenue: $114,525. Avg profit per bike: **$1,001**.
- **Overall ROI: 28.0%** (you turned ~$1.00 into ~$1.28). Avg time to sell: **15 days**.

**Profit by brand** (which name makes money)
- Kawasaki: 16 sold, **$16,225** profit (your bread and butter), 27% ROI.
- Yamaha: 3 sold, $3,200, 31% ROI. Toyota (Camrys): 2 sold, $2,350, **37% ROI**.
- KTM: 1 sold, $1,750, **best ROI at 58%**. CFMoto $800; Honda $500.
- Ducati: only $200 profit, **6.7% ROI** (a weak flip — good "what I learned" story).

**Monthly trend** (busiest months)
- Best months were **Aug 2025 ($7,775)** and **Sep 2025 ($5,200)**, then March 2026 ($3,450).
  Activity dips over winter and picks back up in spring — shows seasonality.

**Best single flips**
- A **2023 KTM Duke 390** and a **2020 Ninja 400** tied for the top, ~**$1,750 profit each**.

**Cars vs motorcycles**
- The 2 Camrys averaged **$1,175 profit (37% ROI)** — higher ROI than bikes (27%). Insight:
  cars were rarer but more efficient per dollar.

**Speed vs profit**
- Most bikes sold in about **two weeks** (avg 15 days). Selling super fast often meant slightly
  underpricing; letting one sit too long dragged returns down. Insight: there's a
  sweet spot — don't fire-sale, don't let it rot.

**Inventory still held**
- 5 vehicles unsold (a 2009 Camry plus four bikes) = **$15,400 of cash tied up** waiting to be sold.

---

## 6. The "wow" parts to name-drop in interviews

You don't just have basic queries. Point to these to sound legit:

- **Window function** — running cumulative profit (`SUM(profit) OVER (ORDER BY sale_date)`).
  Translation: "a running total that grows with each sale." Reaching for window functions
  signals you're past beginner.
- **PARTITION BY** — compares each sale to its own brand's average. "Was this Kawasaki better
  or worse than a typical Kawasaki?"
- **A VIEW** (`v_monthly_kpi`) — a saved query you can re-run anytime. Shows you think about
  reusability, not just one-off questions.
- **CHECK constraint + indexes** in the schema — shows you care about data quality and speed.

---

## 7. How to actually RUN it (so you can demo live)

**SQL (easiest path):**
1. Google "DB Browser for SQLite", download the free app, install.
2. Open it → File → Open Database → pick `automotive_inventory.db`.
3. Click the **Execute SQL** tab. Open `queries.sql` in any text editor, copy one block,
   paste it in, click the blue ▶ play button. The answer appears below. Done.

**Excel:**
1. Double-click `Automotive_Inventory_Tracker.xlsx`.
2. **Dashboard** tab = the pretty report. **Data** tab = the raw table.
3. Click any KPI box and look at the formula bar — it's a live formula, not a typed number.
   That's the thing to show off: "everything recalculates automatically."

---

## 8. Likely interview questions + your answers

**"Walk me through this project."**
> "It's a buy-fix-resell motorcycle operation I tracked. I put 30 deals into a SQLite
> database, designed the schema, and wrote SQL to measure profit and ROI. I also built an
> Excel tracker with Inventory and Sales dashboards. Key findings: 28% ROI overall, Kawasaki
> drove most of the profit, and bikes turned over in about two weeks on average."

**"What's ROI and how did you calculate it?"**
> "Return on investment — profit divided by money spent. In SQL: `SUM(profit) / SUM(buy_price)`.
> Mine came out to 28%."

**"What's a GROUP BY?"**
> "It buckets rows by a category and lets me aggregate. I used it to get profit per brand —
> one result row per make."

**"What's a window function?"**
> "It calculates across a set of rows while still showing each row. I used `SUM() OVER` to get
> a running cumulative profit over time."

**"Did you find anything surprising?"**
> "Cars had higher ROI than bikes, and there was a sweet spot — selling in about two weeks beat
> both fire-selling and letting inventory sit."

**"Is the data real?"**
> "It's based on my real deals, with additional realistic records in the same price ranges to
> make the analysis richer. The structure and the SQL are the real skill on display." (Honest
> and totally fine to say.)

---

## 9. Your 1-week study plan

- **Day 1–2:** Read sections 3 & 4 until the words feel normal. Open the DB, run 3 queries.
- **Day 3–4:** Read each query in `queries.sql` and predict the answer before running it.
- **Day 5:** Open the Excel dashboard, click formulas, understand where each number comes from.
- **Day 6:** Practice saying section 1 and the section 8 answers out loud.
- **Day 7:** Change one bike's price in Excel, watch the dashboard update — now you *get* it.

---

## 10. Resume bullets (copy-paste ready)

> - Built a SQLite database (30 records) and 20-query SQL library to analyze a motorcycle
>   resale operation, surfacing 28% ROI and brand-level profitability.
> - Used aggregations, subqueries, window functions, and a reusable view to measure profit,
>   inventory aging, and sales velocity.
> - Designed a self-updating Excel dashboard (KPI cards, pivot summaries, charts) driven
>   entirely by formulas for repeatable reporting.
