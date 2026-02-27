CREATE DATABASE hotel_db;
USE hotel_db;
CREATE TABLE hotel_reservations (
    Booking_ID VARCHAR(20),
    no_of_adults INT,
    no_of_children INT,
    no_of_weekend_nights INT,
    no_of_week_nights INT,
    type_of_meal_plan VARCHAR(50),
    required_car_parking_space INT,
    room_type_reserved VARCHAR(50),
    lead_time INT,
    arrival_year INT,
    arrival_month INT,
    arrival_date INT,
    market_segment_type VARCHAR(50),
    repeated_guest INT,
    no_of_previous_cancellations INT,
    no_of_previous_bookings_not_canceled INT,
    avg_price_per_room DECIMAL(10,2),
    no_of_special_requests INT,
    booking_status VARCHAR(20)
);

SELECT COUNT(*) FROM hotel_reservations;
ALTER TABLE hotel_reservations
ADD COLUMN total_nights INT,
ADD COLUMN revenue DECIMAL(10,2);

UPDATE hotel_reservations
SET total_nights =
    IFNULL(no_of_week_nights,0) + IFNULL(no_of_weekend_nights,0),
    revenue =
    IFNULL(avg_price_per_room,0) *
    (IFNULL(no_of_week_nights,0) + IFNULL(no_of_weekend_nights,0));
    

-- KPI 1 — Total Bookings    
SELECT COUNT(*) AS total_bookings
FROM hotel_reservations;

 -- KPI 2 — Confirmed Bookings
SELECT COUNT(*) AS confirmed_bookings
FROM hotel_reservations
WHERE booking_status = 'Not_Canceled';

-- KPI 3 — Cancellation Rate
SELECT 
ROUND(
    SUM(CASE WHEN booking_status='Canceled' THEN 1 ELSE 0 END) * 100.0
    / COUNT(*),
2) AS cancellation_rate
FROM hotel_reservations;

-- KPI 4 — Average Daily Rate (ADR)
SELECT AVG(avg_price_per_room) AS avg_daily_rate
FROM hotel_reservations
WHERE booking_status = 'Not_Canceled';

-- KPI 5 — Average Lead Time
SELECT AVG(lead_time) AS avg_lead_time
FROM hotel_reservations;

SELECT 
arrival_year,
arrival_month,
SUM(revenue) AS revenue
FROM hotel_reservations
WHERE booking_status='Not_Canceled'
GROUP BY arrival_year, arrival_month
ORDER BY arrival_year, arrival_month;

SELECT 
market_segment_type,
COUNT(*) AS total_bookings,
SUM(revenue) AS total_revenue,
ROUND(
    SUM(CASE WHEN booking_status='Canceled' THEN 1 ELSE 0 END)*100.0
    / COUNT(*),
2) AS cancellation_rate,
AVG(avg_price_per_room) AS avg_adr
FROM hotel_reservations
GROUP BY market_segment_type
ORDER BY total_revenue DESC;

-- Check missing critical fields
SELECT COUNT(*) AS missing_price
FROM hotel_reservations
WHERE avg_price_per_room IS NULL;

SELECT COUNT(*) AS missing_nights
FROM hotel_reservations
WHERE no_of_week_nights IS NULL 
   OR no_of_weekend_nights IS NULL;
   
-- Top revenue generating segments
SELECT 
market_segment_type,
SUM(revenue) AS total_revenue
FROM hotel_reservations
WHERE booking_status='Not_Canceled'
GROUP BY market_segment_type
ORDER BY total_revenue DESC;

-- Top revenue generating segments
SELECT 
market_segment_type,
SUM(revenue) AS total_revenue
FROM hotel_reservations
WHERE booking_status='Not_Canceled'
GROUP BY market_segment_type
ORDER BY total_revenue DESC;

-- Cancellation rate by month
SELECT 
arrival_year,
arrival_month,
ROUND(
    SUM(CASE WHEN booking_status='Canceled' THEN 1 ELSE 0 END)*100.0
    / COUNT(*),
2) AS cancellation_rate
FROM hotel_reservations
GROUP BY arrival_year, arrival_month
ORDER BY arrival_year, arrival_month;