# Features of this website Krishna Medico

##TO DO
1. Modify transaction ids case.  \\ will leave cause no full integration
2. db.new_stockist_form me primary(name,phone,address,date)
4. drop db.purchase and add cust_id to db.invoice  <<Redundancy>>
5. stock purchase calculate gross total etc total tax amt
6. At end create trigger before update and delete on "invoice,order_item,purchase,stock" 


## Points.
1. Admin is given privilages which is not available to customers or staffs(except owner).
2. Admin can generate electronic invoice online on this site.
3. Public login url is not published on the site, because of security.
4. Invoice page-> you can't buy more items than available.
5. Password is appended with salt and its sha256 hash is stored in password. Can't be reversed.
6. Trigger is created on medicine_available so that available_quantity can't be negative.