SELECT column_name, is_generated, generation_expression FROM information_schema.columns WHERE table_name IN ('sale_details','order_items') AND column_name = 'subtotal';
SELECT column_name, is_generated, generation_expression FROM information_schema.columns WHERE table_name = 'daily_sales' AND column_name = 'total_profit';
