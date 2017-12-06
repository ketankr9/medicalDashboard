#!/bin/bash
echo "mysqldump -u root -p krishnamedico"
mysqldump -u root -p krishnamedico > ~/dbms/backkrishnamedico.sql
echo "scp ......"
scp -i ~/uk.pem -r ~/dbms/ ubuntu@ec2-34-208-110-47.us-west-2.compute.amazonaws.com:~/
