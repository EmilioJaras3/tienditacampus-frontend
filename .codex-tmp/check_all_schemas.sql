SELECT column_name, data_type FROM information_schema.columns WHERE table_name = 'inventory_records' ORDER BY ordinal_position;
SELECT column_name, data_type FROM information_schema.columns WHERE table_name = 'daily_sales' ORDER BY ordinal_position;
SELECT column_name, data_type FROM information_schema.columns WHERE table_name = 'sale_details' ORDER BY ordinal_position;
SELECT column_name, data_type FROM information_schema.columns WHERE table_name = 'order_items' ORDER BY ordinal_position;
SELECT column_name, data_type FROM information_schema.columns WHERE table_name = 'orders' ORDER BY ordinal_position;
