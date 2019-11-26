#!/usr/bin/python
from flask import Flask
from flask import render_template
from flask import request, flash, redirect, url_for, abort, session
from flask_mysqldb import MySQL
from functools import wraps
import json
import hashlib
import datetime
from random import randint
import os
import pickle

app = Flask(__name__, static_url_path = '')
app.config['MYSQL_USER'] = 'root'
app.config['MYSQL_DATABASE_USER'] = 'root'
app.config['MYSQL_PASSWORD'] = 'root'
app.config['MYSQL_DB'] = 'krishnamedico'
app.config['MYSQL_HOST'] = 'localhost'
app.secret_key = '\x0f2\xaer\xffH\xba;mA\x14\xcbB\xa6\xe0#\xbe\xf5\t\xc1\xd5\xf5Dm'
mysql = MySQL(app)
key = "sK3Mkj2g"
salt = "88WwSB0OcX"

def login_required(f):
    @wraps(f)
    def wrap(*args, **kwargs):
        if "isLogged" in session.keys() and session["isLogged"]:
            return f(*args, **kwargs)
        else:
            flash("You need to login first")
            return redirect(url_for('login'))
    return wrap

def successful(msg):
    return render_template("message.html",msg=msg)

@app.route('/')
def index_page():
    return render_template("index.html")

@app.route('/initialize/')
def index_file():
    return render_template("index.html")

@app.route('/product_avail/')
def  product_avail():
    cur=mysql.connection.cursor()
    cur.execute(""" select md.name, md.company, md.med_type, md.quantperleaf, st.quantity, md.description,
     md.mrp from medicines as md, medicine_available as st where st.med_code = md.med_code ORDER BY md.name ASC;""")
    DATA=[]
    for x in cur.fetchall():
        DATA.append({"name":x[0],"company":x[1],"type":x[2],"quant":x[3],"quantity":x[4],"desc":x[5],"mrp":x[6]})
    # DATA=[{"name":"Paracetamol","company":"Aristorate","type":"capsules","quant":"1","quantity":"1",
    # "desc":"Anti-amalgamation","mrp":"58.69"}]
    return render_template("productAvailable.html",data=DATA)

@app.route('/invoice/',methods=['POST','GET'])
def invoice_generation():
    DATA={"items":[],"txn_id":""}
    cur=mysql.connection.cursor()
    cur.execute(""" select md.name,md.med_code,av.quantity, md.mrp, md.quantperleaf from medicines as md, medicine_available as av where md.med_code=av.med_code
    and av.quantity > 0 ORDER BY md.name ASC;""")
    for x in cur.fetchall():
        DATA["items"].append({"name":x[0],"stk_id":x[1],"quant":x[2],"mrp":round(float(x[3])/float(x[4]),2) })
    # cur.execute("""SELECT MAX(txn_id) from invoice;""")
    # txn_id=cur.fetchall()[0][0]
    txn_id = pickle.load(open("current_txn.pkl", "rb"))
    pickle.dump(txn_id+1, open("current_txn.pkl", "wb"))
    if txn_id == None:
        txn_id = 0
    DATA["txn_id"]=int(txn_id)
    return render_template("invoice.html",data=DATA)

@app.route('/invoice_submit/',methods=["POST"])
def invoice_submit():
    x = request.data
    x = json.loads(x.decode('string-escape').strip('"'))
    print x
    # {u'comment': u'ok', u'txn_id': u'Bill No: 253', u'name': u'madan',
    #  u'items': [{u'rate': u'100', u'quantity': u'2', u'amount': u'200', u'particular': u'0'},
    #   {u'rate': u'20', u'quantity': u'3', u'amount': u'60', u'particular': u'0'}],
    #    u'paid': 250, u'phone': u'8987454124', u'address': u'Tower Chowk, Darbhanga', u'tamt': u'260'}
    cur=mysql.connection.cursor()
    cur.execute("""INSERT INTO invoice(txn_id,total_amt,amount_paid,pay_mode,txn_date,discount,comment)
    VALUES(%s,%s,%s,%s,CURDATE(),%s,%s)""",(x["txn_id"],x["tamt"],x["paid"],x["pay_mode"],float(x["tamt"])-float(x["paid"]),x["comment"]) )
    mysql.connection.commit()
    cur.execute("""INSERT INTO customer(name,phone,address)
    VALUES(%s,%s,%s)""",(x["name"],x["phone"],x["address"]))
    mysql.connection.commit()
    cur.execute("""SELECT MAX(customer_id) from customer;""")
    cus_id=cur.fetchall()[0][0]
    # cur.execute("""SELECT MAX(txn_id) from invoice;""")
    # txn_id=cur.fetchall()[0][0]
    cur.execute("""INSERT INTO purchase(cust_id,txn_id) VALUES(%s,%s)""",(cus_id,x["txn_id"]))
    mysql.connection.commit()
    print ""
    for y in x["items"]:
        cur.execute("""INSERT INTO order_item(txn_id,med_code,quantity,rate) VALUES(%s,%s,%s,%s)""",
        (x["txn_id"],y["particular"],y["quantity"],y["rate"]))
        # mysql.connection.commit()
        cur.execute("""select quantity from medicine_available where med_code = %s""",[y["particular"]])
        q=cur.fetchall()
        print "QQQQ",q==()
        if q == ():
            print "Not Found"
        elif int(q[0][0])-int(y["quantity"]) <0:
            abort(409)
        else:
            print "subtract"
            cur.execute("""UPDATE medicine_available SET quantity = %s where med_code = %s""",
            (int(q[0][0])-int(y["quantity"]),y["particular"]))
        mysql.connection.commit()
    mysql.connection.commit()

    return json.dumps({'success':True}), 200, {'ContentType':'application/json'}


# @app.route('/get_avail/<stkId>',methods=['POST'])
# def get_quantity():
#     # medicine availability by med_code across multiple stk_id
#     # select md.med_code,SUM(st.quantity),md.name from stock as st,medicines as md where
#     # md.med_code = st.med_code GROUP BY md.med_code ORDER BY md.name;
#     cur=mysql.connection.cursor()
#     cur.execute(""" """)

@app.route('/stockist/')
def stockist():
    cur=mysql.connection.cursor()
    cur.execute("""select * from stockist ORDER BY store_name ASC;""")
    # data=cur.fetchall()
    DATA=[]
    for x in cur.fetchall():
        DATA.append({"store":x[1],"address":x[2],"phone":x[3],"link":x[0]})
    # DATA=[{"store":"Hindustan","phonePhone":"9151643209","address":"Naka No.5","link":"http://www.google.com"},
    # {"store":"Hindustan","phone":"9151643209","address":"Naka No.5","link":"http://www.google.com"}]
    return render_template("stockist.html",data=DATA)

@app.route('/stock_pur/')
@login_required
def stock_purchase():
    cur=mysql.connection.cursor()
    cur.execute("""select sup_id,store_name,address from stockist ORDER BY store_name ASC;""");
    DATA=[[],[]]
    for x in cur.fetchall():
        DATA[0].append({"id":x[0],"name":x[1]+" / "+x[2][:30]})
    cur.execute("""select med_code,name,quantperleaf,mrp from medicines ORDER by name ASC;""");
    for x in cur.fetchall():
        DATA[1].append({"code":x[0],"name":x[1],"quant":x[2],"mrp":x[3]})

    return render_template("stock_purchase.html",arr=DATA)

@app.route('/purchase_submit/',methods=['POST'])
@login_required
def add_stock():
    try:
        # raise Exception('My error!') # testing
        data = request.data
        data = json.loads(data.decode('string-escape').strip('"'))
        # print data
        seller=data["seller"]
        # print data["comment"],data["paid"]
        cur=mysql.connection.cursor()
        # transaction
        cur.execute("""INSERT INTO stock_purchase(sup_id,purchase_date,paid,comment)
        VALUES(%s,CURDATE(),%s,%s)""",(seller,float(data['paid']),data['comment']));
        mysql.connection.commit()
        cur.execute("""SELECT MAX(txn_id) from stock_purchase;""")
        txn_id=cur.fetchall()[0][0]
        # print txn_id
        for x in data["items"]:
            print "Loop"
            try:
                cur.execute("""INSERT INTO deals_in(sup_id,med_code) VALUES(%s,%s) """,(seller,x["particular"]))
            except:
                pass
            print txn_id,x["particular"],x["expiry"],x["units"],x["perunit"],x["mrp"],x["rate"],float(x["amount"]),x["disc"],x["gst"]
            cur.execute("""INSERT INTO stock(txn_id,med_code,quantity,expiry,rate,mrp,gst,disc)
            VALUES(%s,%s,%s,%s,%s,%s,%s,%s)""",(txn_id,x["particular"],x["units"],x["expiry"],float(x["rate"]),float(x["mrp"]),x["gst"],x["disc"]))
            mysql.connection.commit()
            # print "insertion success"
            cur.execute("""select quantity from medicine_available where med_code = %s""",[x["particular"]])
            q=cur.fetchall()
            print "QQQQ",q==()
            if q == ():
                print "New"
                cur.execute("""INSERT INTO medicine_available(med_code,quantity) VALUES(%s,%s)""",(x["particular"],x["units"]))
                mysql.connection.commit()
            else:
                print "add"
                cur.execute("""UPDATE medicine_available SET quantity = %s where med_code = %s""",
                (int(x["units"])+int(q[0][0]),x["particular"]))
                mysql.connection.commit()

        return json.dumps({'success':True}), 200, {'ContentType':'application/json'}
    except:
        abort(409)
        # print "failure"
        # return json.dumps({'failure':True}), 409, {'ContentType':'application/json'}

@app.route('/purchase_history/')
@login_required
def purchase_history():
    cur=mysql.connection.cursor()
    cur.execute("""select p.txn_id,si.store_name,p.purchase_date,p.paid,p.comment from stockist as si,
     stock_purchase as p where p.sup_id=si.sup_id ORDER BY p.txn_id DESC""")
    DATA=[]
    new_data=[]
    no_items=[]
    for x in cur.fetchall():
        DATA.append({   "id":x[0],"seller":x[1],"pd":x[2],"ap":float(x[3]),"cmt":x[4],"items":[]   })
    for i in range(len(DATA)):
        cur.execute("""select md.name,st.expiry,st.quantity,md.quantperleaf,st.mrp,st.rate,
        st.disc,st.gst from medicines as md, stock as st where st.med_code = md.med_code and st.txn_id=%s""",[DATA[i]["id"]])
        temp=cur.fetchall()

        for y in temp:
            DATA[i]["items"].append({"p":y[0],"e":y[1],"u":y[2],"pu":y[3],"m":y[4],"r":y[5],"a":100,"d":y[6],"g":y[7]})
        if len(temp) != 0:
            new_data.append(DATA[i])

    # DATA=[{"id":"124",
    #     "seller":"hellomedical",
    #     "pd":"2017-10-1",
    #     "ap":"11248",
    #     "cmt":"No comment"
    #     "items":[{"p":"Paracitamol",
    #         "e":"2020-22",
    #         "u":"25",
    #         "pu":"6",
    #         "m":"14.45",
    #         "r":"10.89",
    #         "a":"NaN",
    #         "d":"2",
    #         "g":"8"
    #         }]
    # },{"id":"124",
    #     "seller":"hellomedical",
    #     "pd":"2017-10-1",
    #     "ap":"11248",
    #     "items":[{"p":"Paracitamol",
    #         "e":"2020-22",
    #         "u":"25",
    #         "pu":"6",
    #         "m":"14.45",
    #         "r":"10.89",
    #         "a":"NaN",
    #         "d":"2",
    #         "g":"8"
    #         }]
    # }]
        # DATA.append("")
    # for x in cur.fetchall():
    return render_template("purchase_history.html",data=new_data)

@app.route('/new_stockist/',methods=['POST','GET'])
def new_stockist():
    if request.method == 'POST':
        cur=mysql.connection.cursor()
        # print type(request.form["store_name"]),request.form["address"],request.form["phone_no"]
        cur.execute("""INSERT INTO new_stockist_form(name,address,phone,submitted_on)
        VALUES(%s,%s,%s,CURDATE())""",(request.form["store_name"],request.form["address"],request.form["phone_no"]))
        mysql.connection.commit()
        return successful("Your form is successfully submitted. We will contact you shortly.")
    else:
        return render_template("new_stockist_form.html")

@app.route('/stockist_approval/')
@login_required
def new_stockist_list():
    cur=mysql.connection.cursor()
    cur.execute("""select name,phone,address,submitted_on from new_stockist_form ORDER BY submitted_on DESC""")
    DATA=[]
    for x in cur.fetchall():
        DATA.append({"name":x[0],"phone":x[1],"address":x[2],"submitted_on":x[3]})
    return render_template("new_stockist_data.html",data=DATA)

@app.route('/stockist_deals/<supId>')
def stockist_deals_in(supId):
    DATA={"medicines":[]}
    cur=mysql.connection.cursor()
    cur.execute("""select store_name,address,phone from stockist where sup_id = %s""",[str(supId)])
    t=cur.fetchall()[0]
    DATA["seller"]=t[0]
    DATA["address"]=t[1]
    DATA["phone"]=t[2]
    cur.execute("""select md.name,md.med_type,md.company,md.description from deals_in as di,
    medicines as md where di.sup_id = %s and md.med_code=di.med_code ORDER BY md.name ASC""",[str(supId)])
    for x in cur.fetchall():
        DATA["medicines"].append({"name":x[0],"type":x[1],"comp":x[2],"desc":x[3]})
    # return "Hey"+str(DATA)
    return render_template("stockist_deals_in.html",data=DATA)


@app.route('/medicine_request/',methods=['POST','GET'])
def medicine_request():
    if request.method == "POST":
        print request.form["med_name"],request.form["company"],request.form["med_type"],request.form["comment"],
        request.form["phone"],request.form["users_name"]
        cur=mysql.connection.cursor()
        cur.execute("""INSERT INTO new_medicine_request(name,company,med_type,description,phone,users_name,
        submitted_on) VALUES(%s,%s,%s,%s,%s,%s,CURDATE())""",(request.form["med_name"],request.form["company"],
        request.form["med_type"],request.form["comment"],request.form["phone"],request.form["users_name"]))
        mysql.connection.commit()
        return successful("""Your request for %s has been submitted to us."""%(request.form["med_name"]))
    return render_template("new_medicine_request.html")


@app.route('/medicine_request_list/')
@login_required
def medicine_request_list():
    DATA=[]
    cur=mysql.connection.cursor()
    cur.execute("""select name,company,med_type,description,phone,users_name,submitted_on from new_medicine_request
     ORDER BY submitted_on DESC""")
    for x in cur.fetchall():
        DATA.append({"name":x[0],"company":x[1],"med_type":x[2],"comment":x[3],"phone":x[4],"users_name":x[5],
        "submitted_on":x[6]})
    return render_template("new_medicine_request_data.html",data=DATA)

@app.route('/payme/')
def payme():
    return render_template("payment_page.html")

def check_login(username,passwd):
    pa=hashlib.sha512(app.secret_key + passwd).hexdigest()
    cur=mysql.connection.cursor()
    cur.execute("""select count(*) from login_tb where username = %s and passwd = %s""",(username,pa))
    p=cur.fetchall()[0][0]
    print p
    return p

@app.route('/login/',methods=['POST','GET'])
def login():
    msg="Please login!"
    if request.method == 'POST':
        if check_login(str(request.form["username"]),request.form["passwd"].encode('utf-8')):
            session["username"]=request.form["username"]
            session["isLogged"]=True
            session["addr"]=request.remote_addr
            msg=""
            return render_template("index.html")
        else:
            msg="Username or password is incorrect!"
    return render_template("login.html",data={"msg":msg})

@app.route('/logout/')
@login_required
def logout():
    session["isLogged"]=False
    session.pop(session["username"],None)
    return redirect(url_for("index_page"))

@app.route('/adduser/',methods=["POST","GET"])
def adduser():
    msg="New User!"
    if request.method == 'POST':
        try:
            cur=mysql.connection.cursor()
            pa=hashlib.sha512(app.secret_key + request.form["passwd"].encode("utf-8")).hexdigest()
            cur.execute("""INSERT INTO login_tb(username,passwd) VALUES(%s,%s)""",(request.form["username"],pa))
            mysql.connection.commit()
        except:
            msg="username "+request.form["username"]+" already exists!"
            return render_template("signup.html",data={"msg":msg})
    else:
        return render_template("signup.html",data={"msg":"signup"})
    return redirect(url_for("index_page"))


@app.route('/status/',methods=["POST","GET"])
def status():
    if request.method=="POST":
        x = request.data
        print x
        # x = json.loads(x.decode('string-escape').strip('"'))
        # print x
        # fh = open("status.txt", "a")
        # fh.write(str(x)+"\n")
        # fh.close
        return json.dumps({'success':True}), 200, {'ContentType':'application/json'}
    else:
        print "Get request received"
        return json.dumps({'success':True}), 200, {'ContentType':'application/json'}

@app.route('/test/',methods=["GET","POST"])
def test():
    MERCHANT_KEY = key
    SALT = salt
    
    PAYU_BASE_URL = "https://secure.payu.in/_payment"
    action = ''
    posted={}
    if request.method == "POST":
        print "yay"
        for i in request.form:
            posted[i]=request.form[i]
    temp="qwertyuiopasdfghjklzxcvbnm1234567890"
    txnid=""
    for _ in xrange(20):
        txnid+=temp[randint(0,len(temp)-1)]
    # hash_object = hashlib.sha256(b'randint(0,20)')
    # txnid=hash_object.hexdigest()[0:20]
    hashh = ''
    posted['txnid']=txnid
    hashSequence = "key|txnid|amount|productinfo|firstname|email|udf1|udf2|udf3|udf4|udf5|udf6|udf7|udf8|udf9|udf10"
    posted['key']=key
    hash_string=''
    hashVarsSeq=hashSequence.split('|')
    for i in hashVarsSeq:
		try:
			hash_string+=str(posted[i])
		except Exception:
			hash_string+=''
		hash_string+='|'
    hash_string+=SALT
    hashh=hashlib.sha512(hash_string).hexdigest().lower()
    # print hash_string,hashh
    action =PAYU_BASE_URL
    # print ""

    if request.method=="POST":
        S_URL = "http://localhost:5000"
        posted['surl'], posted['furl'] = S_URL+url_for('success'), S_URL+url_for('failure')
        return render_template('current_datetime.html',posted=posted,hashh=hashh,MERCHANT_KEY=MERCHANT_KEY,txnid=txnid,hash_string=hash_string,action=PAYU_BASE_URL )
    else:
        # return "yay"
        # print posted
        return render_template('current_datetime.html',posted=posted,hashh="",MERCHANT_KEY=MERCHANT_KEY,txnid=txnid,hash_string=hash_string,action="." )

@app.route('/success/',methods=["POST","GET"])
def success():
	status=request.form["status"]
	firstname=request.form["firstname"]
	amount=request.form["amount"]
	txnid=request.form["txnid"]
	posted_hash=request.form["hash"]
	key=request.form["key"]
	productinfo=request.form["productinfo"]
	email=request.form["email"]

	try:
		additionalCharges=request.form["additionalCharges"]
		retHashSeq=additionalCharges+'|'+salt+'|'+status+'|||||||||||'+email+'|'+firstname+'|'+productinfo+'|'+amount+'|'+txnid+'|'+key
	except Exception:
		retHashSeq = salt+'|'+status+'|||||||||||'+email+'|'+firstname+'|'+productinfo+'|'+amount+'|'+txnid+'|'+key
	hashh=hashlib.sha512(retHashSeq).hexdigest().lower()
	if(hashh !=posted_hash):
		print "Invalid Transaction. Please try again"
	else:
		print "Thank You. Your order status is ", status
		print "Your Transaction ID for this transaction is ",txnid
		print "We have received a payment of Rs. ", amount ,". Your order will soon be shipped."
	return render_template('payment_success.html',txnid=txnid,status=status,amount=amount,firstname=firstname)

@app.route('/failure/',methods=["POST","GET"])
def failure():
    status=request.form["status"]
    firstname=request.form["firstname"]
    amount=request.form["amount"]
    txnid=request.form["txnid"]
    posted_hash=request.form["hash"]
    key=request.form["key"]
    productinfo=request.form["productinfo"]
    email=request.form["email"]
    msg=""
    try:
        additionalCharges=request.form["additionalCharges"]
        retHashSeq=additionalCharges+'|'+salt+'|'+status+'|||||||||||'+email+'|'+firstname+'|'+productinfo+'|'+amount+'|'+txnid+'|'+key
    except Exception:
        retHashSeq = salt+'|'+status+'|||||||||||'+email+'|'+firstname+'|'+productinfo+'|'+amount+'|'+txnid+'|'+key
    hashh=hashlib.sha512(retHashSeq).hexdigest().lower()
    if(hashh !=posted_hash):
        print "Invalid Transaction. Please try again"
    else:
        msg+="Sorry:( Your order status is "+status+"\n"+"Your Transaction ID for this transaction is "+txnid
        print msg
    return render_template("payment_failure.html",msg=msg)
