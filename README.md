Adding version 2.0 of Diagnostics to GitHub
This project will attempt to create a script to execute diagonistic scripts with PS and create and add the data to SQL Server tables in Diagnostic database

This current flow is the following
1. Create scripts by pointing to target server and creating
2. Use python to wrap create table around code and create all tables
3. run scripts against target and load results into tables in DBA server
