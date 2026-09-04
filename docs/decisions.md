DECISIONS:

Silver Layer — Field-Level Cleaning

#aisle, department, product_name
Decision: Remove trailing spaces
Reason: To keep the text format consistent
Consequence: Matching and filtering on these fields will work better, since extra spaces won't cause mismatches anymore

#product_id
Decision: Drop rows where product_id is null
Reason: We need product_id to connect to dim_product; without it, the row can't be linked to a product
Consequence: A few rows will be removed, so the final row count will be a bit lower than the raw data

#reordered
Decision: Standardized to 0 or 1
Reason: Keeps the field consistent as a simple yes/no value

#add_to_cart_order
Decision: Only keep values greater than 0
Reason: This field should represent a real position in the cart, so 0 or negative doesn't make sense
Consequence: Rows with invalid values are removed

#eval_set
Decision: Applied INITCAP (capitalize first letter)
Reason: For consistent formatting
Consequence: Any future filters on this field need to match the capitalized version (e.g. 'Prior', not 'prior')

#product_name
Decision: Removed unnecessary symbols
Reason: For cleaner, more consistent formatting

#days_since_prior_order
Decision: Kept null values
Reason: A null probably just means it's the customer's first order, not missing data
Consequence: Anyone using this field for averages or totals should keep the nulls in mind, so first-time orders aren't accidentally left out

#days_since_prior_order
Decision: Rounded to the nearest whole number
Reason: For consistent formatting, since this field is a day count

#aisle_id, department_id
Decision: Replaced nulls with "Unknown"
Reason: A missing aisle/department doesn't mean the transaction is invalid — it just wasn't labeled
Consequence: Charts/reports grouped by aisle or department will show an "Unknown" category

Gold Layer — Fact & Mart Modeling

#fact_table
Decision: Combined order_products_prior and order_products_train using UNION ALL
Reason: Both tables have the same structure, so combining them gives one complete set
Consequence: UNION ALL doesn't remove duplicates, but that's fine here since the two tables don't overlap

#fact_table
Decision: Used a LEFT JOIN to the products table
Reason: To bring in department_id and aisle_id for each product, while keeping all order rows
Consequence: If a product_id doesn't match anything in products, its department/aisle will just show as null instead of the row being dropped

Visualization Layer
#purchasing_behavior — Weekday vs. Weekend

Decision: Set order_dow 0 and 6 as Sunday and Saturday, and 1–5 as Monday to Friday; split into Weekend and Weekday groups
Reason: To compare how customers shop on weekdays vs weekends
Consequence: Found no relation in the database if the number in dow corresponds to the days we used, thus might be inaccurate.
