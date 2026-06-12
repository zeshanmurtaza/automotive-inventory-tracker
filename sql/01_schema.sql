-- Schema: tables, constraints, and indexes for the Automotive Inventory project
-- Engine: SQLite 3

CREATE TABLE partners (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    vehicle_id INTEGER NOT NULL REFERENCES vehicles(id),
    partner_name TEXT NOT NULL,
    cash_contributed REAL DEFAULT 0,
    labor_note TEXT );
CREATE TABLE vehicles (
    id INTEGER PRIMARY KEY, make TEXT NOT NULL, model TEXT NOT NULL, year INTEGER NOT NULL,
    vehicle_type TEXT NOT NULL,
    status TEXT NOT NULL CHECK (status IN ('Sold','In Inventory')),
    buy_price REAL NOT NULL, sell_price REAL, profit REAL, days_to_sell INTEGER,
    purchase_date TEXT NOT NULL, sale_date TEXT,
    buyer_name TEXT, buyer_contact TEXT );
CREATE INDEX idx_purchase ON vehicles(purchase_date);
CREATE INDEX idx_make ON vehicles(make);
CREATE INDEX idx_partner_vehicle ON partners(vehicle_id);
DELETE FROM "sqlite_sequence";
