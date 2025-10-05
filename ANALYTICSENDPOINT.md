## Endpoints 

> *Should be authenticated and header should have the access token*
### Executive analytics

#### GET analytics/executive/top_customers #DONE
- ##### INPUT (Query Parameters)
	- tenant_id
	- sales_executive_id (only  for area_manager, client_admin and superadmin users, for sales_executive it takes its own id )
- ##### OUTPUT (List)
	- shop_name (get it using the foreign key shop_id)
	- points
#### GET analytics/executive/best_selling_products #DONE
- ##### INPUT (Query Parameters)
	- tenant_id
	- sales_executive_id (only  for area_manager, client_admin and superadmin users, for sales_executive it takes its own id )
- ##### OUTPUT (List)
	- product_name (get it using the foreign key shop_id)
	- units sold by this sales executive
	- percentage (units of this product sold by this executive divided by total products(all) ever sold)
#### GET analytics/executive/sales_report #DONE
- ##### INPUT (Query Parameters)
	- tenant_id
	- sales_executive_id (only  for area_manager, client_admin and superadmin users, for sales_executive it takes its own id )
- ##### OUTPUT (List)
	- month_year (need to combine month and year like yyyy-mm )
	- sale_point 
- #### NOTE
	- It should only show the report of last one year


### Shop analytics
#### GET analytics/shops/purchase_analysis
- ##### INPUT (Query Parameters)
	- tenant_id
	- shop_id
	- year (Optional, if not given should provide the result of last one year)
- ##### OUTPUT (List)
	- month_year (need to combine month and year like yyyy-mm )
	- is purchased (bool)
#### GET analytics/shops/best_selling_products
- ##### INPUT (Query Parameters)
	- tenant_id
	- shop_id
	- year (Optional, if not given should provide the result of last one year)
- ##### OUTPUT (List)
	- product_name (get it using the foreign key shop_id)
	- units sold by this sales executive
	- percentage (units of this product sold by this executive divided by total products(all) ever sold)
#### GET analytics/shops/sales_report
- ##### INPUT (Query Parameters)
	- tenant_id
	- shop_id
	- year (Optional, if not given should provide the result of last one year)
- ##### OUTPUT (List)
	- month_year (need to combine month and year like yyyy-mm )
	- sale_point 