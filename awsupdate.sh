#!/bin/bash

echo "Updating current_txn.pkl"
/usr/bin/python ./initializetxn.py

echo "Updating mysql data"
mysql -u root -p krishnamedico < backkrishnamedico.sql

exit 0