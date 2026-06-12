# How to put this on GitHub (no coding, ~5 minutes)

You don't need the command line. Do it all in the browser.

## 1. Make a GitHub account
Go to https://github.com and sign up (free).

## 2. Create an empty repository
- Click the **+** (top right) → **New repository**.
- **Repository name:** `automotive-inventory-tracker`
- Set it to **Public** (so recruiters can see it).
- Do **NOT** check "Add a README" (this project already has one).
- Click **Create repository**.

## 3. Upload the files
- On the new repo page, click **uploading an existing file** (the link in the
  "Quick setup" box), or **Add file → Upload files**.
- Open this `automotive-inventory-tracker` folder on your computer, select **everything
  inside it** (the `sql`, `data`, `excel`, `docs` folders and the `README.md`, `LICENSE`,
  `.gitignore` files), and **drag them into the browser**.
  - Dragging the folders keeps the structure intact.
- Scroll down, click **Commit changes**.

That's it — your project is live. The `README.md` shows automatically on the repo home page,
and recruiters can click into the `sql/` folder to read every query.

## 4. (Optional) Turn on the live dashboard
- In the repo, go to **Settings → Pages**.
- Under **Build and deployment → Source**, choose **Deploy from a branch**.
- Branch: **main**, folder: **/docs** → **Save**.
- Wait ~1 minute, then your dashboard is live at:
  `https://zeshanmurtaza.github.io/automotive-inventory-tracker/`
- Add that link to your README's top line and to your resume.

## 5. Put it on your resume
- Link the repo: `github.com/zeshanmurtaza/automotive-inventory-tracker`
- Suggested bullet:
  > Built an automotive-resale analytics project: designed a SQLite schema with a related
  > partners table, wrote 21 analytical SQL queries (aggregations, window functions, JOINs),
  > and shipped Excel and web dashboards — surfacing 28% return on cost across 25 flips.

## Tip
If you later change the Excel or dashboard, just **Add file → Upload files** again and
upload the updated file with the same name to replace it.
