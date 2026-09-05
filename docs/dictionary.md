## Instacart Data Dictionary

| Table | Column | Data Type | Description |
|---|---|---|---|
| **aisles** | `aisle_id` | INT | Unique identifier for the aisle |
| | `aisle` | STRING | Name of the aisle |
| **departments** | `department_id` | INT | Unique identifier for the department |
| | `department` | STRING | Name of the department |
| **products** | `product_id` | INT | Unique identifier for the product |
| | `product_name` | STRING | Name of the product |
| | `aisle_id` | INT | ID of the aisle where the product belongs |
| | `department_id` | INT | ID of the department where the product belongs |
| **orders** | `order_id` | INT | Unique identifier for an order |
| | `user_id` | INT | Identifier for the customer who placed the order |
| | `eval_set` | STRING | Indicates whether the order belongs to the prior, train, or test dataset |
| | `order_number` | INT | Order sequence number for the user |
| | `order_dow` | INT | Day of week when the order was placed |
| | `order_hour_of_day` | INT | Hour of day when the order was placed |
| | `days_since_prior_order` | DOUBLE | Number of days since the user's previous order |
| **order_products_prior** | `order_id` | INT | ID of the order |
| | `product_id` | INT | ID of the product purchased |
| | `add_to_cart_order` | INT | Position in which the product was added to the cart |
| | `reordered` | INT | Indicates whether the product was reordered |
| **order_products_train** | `order_id` | INT | ID of the order |
| | `product_id` | INT | ID of the product purchased |
| | `add_to_cart_order` | INT | Position in which the product was added to the cart |
| | `reordered` | INT | Indicates whether the product was reordered |
