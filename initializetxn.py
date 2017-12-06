#!/usr/bin/python
import MySQLdb
import pickle
db = MySQLdb.connect(host="localhost", user="root", passwd="root", db="krishnamedico")
cur = db.cursor()
cur.execute("""SELECT MAX(txn_id) from invoice;""")
txn_id = cur.fetchall()[0][0]
if txn_id == None:
    txn_id = 1
pickle.dump(txn_id+1,open("current_txn.pkl", "wb"))
db.close()
