-- Latihan 1
-- Dapatkan total pendapatan, laba dan persentase laba 
-- untuk seluruh website pembelanjaan.

SELECT SUM(items.price) AS "Total Pendapatan", 
       SUM(items.price - items.cost) AS "Total Laba", 
       1.0*SUM(items.price - items.cost) / SUM(items.price) * 100 AS "Persentase Laba"
FROM items
JOIN sales_records
ON items.id = sales_records.item_id

-- Latihan 2
-- Apakah Anda tahu 5 item yang berkontribusi paling banyak terhadap pendapatan? 

SELECT items.name, COUNT(*) as "Jumlah Penjualan", items.price as "Harga", items.price * COUNT(*) as "Total Pemasukan"
FROM items
JOIN sales_records
ON items.id = sales_records.item_id
GROUP BY items.name
ORDER BY "Total Pemasukan" DESC
LIMIT 5

-- Latihan 3
-- Cari tahu persentase laba dan laba dari 5 item penghasil pendapatan teratas

SELECT items.name AS "Nama Item", 
       items.price - items.cost AS "Keuntungan tiap Item", 
       1.0*(items.price - items.cost) / (items.price) * 100 AS "Persentase Laba",
       COUNT(*) * items.price - items.cost AS "Jumlah penjualan"
FROM items
JOIN sales_records
ON items.id = sales_records.item_id
GROUP BY "Keuntungan tiap Item"
ORDER BY "Keuntungan tiap Item" DESC
LIMIT 5

-- Latihan 4
-- Cari tahu 5 item yang memberikan penghasilan laba teratas

SELECT items.name AS "Nama Item", items.price - items.cost AS "Keuntungan tiap Item",
       1.0*(items.price - items.cost) / (items.price) * 100 AS "Persentase Laba",
       COUNT(*) * items.price - items.cost AS "Jumlah penjualan"
FROM items
JOIN sales_records
ON items.id = sales_records.item_id
GROUP BY "Nama Item", "Keuntungan tiap Item", "Persentase Laba"
ORDER BY "Jumlah penjualan" DESC
LIMIT 5

-- Latihan 5
-- Sekarang tim Anda sudah tau item-item  mana saja yang paling berpengaruh. Agar 
-- dapat mengalokasikan biaya marketing secara efektif, Cari tahu 5 item penghasil 
-- pendapatan terburuk

SELECT items.name, COUNT(*) as "Jumlah Penjualan", items.price as "Harga", items.price * COUNT(*) as "Total Pemasukan"
FROM items
JOIN sales_records
ON items.id = sales_records.item_id
GROUP BY items.name
ORDER BY "Total Pemasukan" ASC
LIMIT 5

-- Latihan 6
-- Cari tahu 5 item dengan penghasilan laba terburuk

SELECT items.name AS "Nama Item", 
       items.price - items.cost AS "Laba tiap Item", 
       1.0*(items.price - items.cost) / (items.price) * 100 AS "Persentase Laba",
       COUNT(*) * items.price - items.cost AS "Total Laba tiap Item"
FROM items
JOIN sales_records
ON items.id = sales_records.item_id
GROUP BY "Nama Item", "Laba tiap Item", "Persentase Laba"
ORDER BY "Total Laba tiap Item" ASC
LIMIT 5

-- Latihan 7
-- Cari tahu keuntungan total dan tingkat keuntungan item tergantung pada gender

SELECT items.gender AS "gender", 
        SUM(items.price - items.cost) AS "Total Laba", 
        1.0*SUM(items.price - items.cost) / SUM(items.price) * 100 AS "Persentase Laba"
FROM items
JOIN sales_records
ON items.id = sales_records.item_id
JOIN users
ON sales_records.user_id = users.id
GROUP BY items.gender

-- Latihan 8
-- Cari tahu jumlah pengguna aktif dan persentasenya.

SELECT COUNT(DISTINCT(users.id)) AS "jumlah pengguna", 1.0 * 100 * COUNT(DISTINCT(users.id))/ (SELECT COUNT(*) FROM users) AS "persentasi pengguna"
FROM users
JOIN sales_records
ON users.id = sales_records.user_id

-- Latihan 9
-- Cari tahu frekuensi rata-rata pembelian, pengeluaran rata-rata, 
-- dan pengeluaran rata-rata per pembelian pengguna aktif

SELECT 1.0 * (SELECT COUNT(*) FROM sales_records)/COUNT(DISTINCT(users.id)) AS "frekuensi",
       1.0 * SUM(items.price) / COUNT(DISTINCT(users.id)) AS "rata rata",
       (1.0 * SUM(items.price) / COUNT(DISTINCT(users.id))) / (1.0 * (SELECT COUNT(*) FROM sales_records)/COUNT(DISTINCT(users.id))) AS "pengeluaran rata rata"
FROM users
JOIN sales_records
ON users.id = sales_records.user_id
JOIN items
ON items.id = sales_records.item_id

-- Latihan 10
-- Get the list of users who purchased more often than the average

SELECT users.name, COUNT(sales_records.user_id) AS "number of purchase"
FROM users
JOIN sales_records ON users.id = sales_records.user_id 
GROUP BY users.name
HAVING "number of purchase" >= (
  SELECT 1.0 * COUNT(*)/COUNT(DISTINCT(users.id)) AS "frekuensi"
  FROM users
)
ORDER BY "number of purchase" DESC
LIMIT 5