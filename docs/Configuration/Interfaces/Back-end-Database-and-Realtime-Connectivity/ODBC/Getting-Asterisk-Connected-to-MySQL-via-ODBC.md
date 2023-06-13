---
title: Getting Asterisk Connected to MySQL via ODBC
pageid: 34636864
---

Connect Asterisk to a MySQL back-end through ODBC
=================================================

This is a short tutorial on how to quickly setup Asterisk to use MySQL, the ODBC MariaDB connector and ODBC. We'll use CentOS 6 as the OS in this tutorial. However, the same essential steps apply for any popular Linux distro.

Installing and Configuring MySQL
--------------------------------

There are three basic steps to install and configure MySQL for Asterisk.* Install MySQL server package and start the DB service.
* Secure the installation if appropriate.
* Configure a user and database for Asterisk in MySQL
On This Page### Install MySQL server package and start the DB service

 

# sudo yum install mysql-server
# sudo service mysqld start### Secure the installation if appropriate

If you intend to push this install into production or practice as if you were then you will want to use the mysql\_secure\_installation script to apply some basic security. 

# sudo /usr/bin/mysql\_secure\_installation### Configure a user and database for Asterisk in MySQL

If you want to use a GUI to manage your database then now is the time to set that GUI up and use it to create your asterisk user. Otherwise we will provide basic instructions for user setup below.

We'll have you login into the mysql command console, create a user, create a database and then assign appropriate permissions for the asterisk user.First, login using the root password you set earlier.

# mysql -u root -pNow verify you are at the MySQL command prompt. It should look like "mysql>". Then enter the following commands:

# CREATE USER 'asterisk'@'%' IDENTIFIED BY 'replace\_with\_strong\_password';
# CREATE DATABASE asterisk;
# GRANT ALL PRIVILEGES ON asterisk.\* TO 'asterisk'@'%';
# exitAfter each of the CREATE and GRANT commands you should see output indicating that the Query was OK including many rows were affected.If you want, you can test out the new permissions by logging in as your user to the asterisk database and then logout again. 

# mysql -u asterisk -p asterisk
# exit 

Install ODBC and the MariaDB ODBC connector
-------------------------------------------

It is not recommended to use the MySQL ODBC connector due to crash issues experienced by users. These have not been experienced when using the MariaDB ODBC connector.

 

Be sure you have followed the previous sections as we presume you already have MySQL installed on your CentOS server along with a database and user for Asterisk configured. The database name should be 'asterisk' and the username should be 'asterisk'.

### Install the latest unixODBC and GNU Libtool Dynamic Module Loader packages

The development packages are necessary as well, since later Asterisk will need to use them when building ODBC related modules.

# sudo yum install unixODBC unixODBC-devel libtool-ltdl libtool-ltdl-devel### Install the latest MariaDB ODBC connector

# sudo yum install mariadb-connector-odbc 

Configure ODBC and the MariaDB ODBC connector
---------------------------------------------

### Configure odbcinst.ini for ODBC

With recent UnixODBC versions the configuration should already be done for you in the /etc/odbcinst.ini file.

Verify that you have the following configuration:

# Driver from the mariadb-connector-odbc package
# Setup from the unixODBC package
[MariaDB]
Description=ODBC for MariaDB
Driver=/usr/lib64/libmaodbc.so
Setup=/usr/lib64/libodbcmyS.so
UsageCount=1  
There may also be configuration for PostgreSQL which you can comment out if you are not planning to setup PostgreSQL as well. Comments begin the line with a hash (#) symbol.

You can also call **`odbcinst`** to query the driver, verifying that the configuration is found.

# odbcinst -q -dThe output should read simply "[MySQL]"

### Configure the MariaDB ODBC connector

Now we'll configure the /etc/odbc.ini file to create a DSN (Data Source Name) for Asterisk. The file may be empty, so you'll have to copy-paste from this example or write this from scratch.

Add the following to /etc/odbc.ini

[asterisk-connector]
Description = MySQL connection to 'asterisk' database
Driver = MariaDB
Database = asterisk
Server = localhost
Port = 3306
Socket = /var/lib/mysql/mysql.sockYou may want to verify that mysql.sock is actually in the location specific here. It will differ on some systems depending on your configuration.

 

Test the ODBC Data Source Name connection
-----------------------------------------

Now is a good time to test your database by connecting to it and performing a query. The unixODBC package provides **`isql`**; a command line utility that allows you to connect to the Data Source, send SQL commands to it and receive results back. The syntax used is:

isql -v *dsn\_name* *db\_username* *db\_password*

So, for our purposes you would enter:

# isql -v asterisk-connector asterisk replace\_with\_strong\_passwordIt is important to use the -v flag so that if isql runs into a problem you will be alerted of any diagnostics or errors available.

 

At this point you should get an SQL prompt. Run the following command:

SQL> select 1You should see some simple results if the query is successful. Then you can exit.

SQL> select 1
+---------------------+
| 1 |
+---------------------+
| 1 |
+---------------------+
SQLRowCount returns 1
1 rows fetched
 
SQL> quit 

Configuring Asterisk to Use the New ODBC and MySQL Install
----------------------------------------------------------

Now you have a MySQL database, ODBC and an ODBC MariaDB connector installed and basically configured. The next step is to recompile Asterisk so that the ODBC modules which required the previously mentioned items can now be built. Once those modules exist, then you can configure the proper configuration files in Asterisk depending on what information you want to write to or read from MySQL.

### Getting the right Asterisk modules

If you already had Asterisk installed from source and the modules you need are already selected by default in menuselect - then the recompilation process could be as simple as navigating to the Asterisk source and running a few commands.

# cd ~/asterisk-source/
# ./configure
# make && make installOtherwise you should follow the typical Asterisk installation process to make sure modules such as res\_odbc, res\_config\_odbc, cdr\_odbc, cdr\_adaptive\_odbc and func\_odbc have their dependencies fulfilled and that they will be built.

See  and .

### Configuring Asterisk's ODBC connection

The basic configuration for an Asterisk ODBC connection is handled in res\_odbc.conf. You should check out the  page and follow it using the DSN and database username and password you setup earlier.

After you have the connection set up in Asterisk you are ready to then configure your database tables with the proper schema depending on what exactly you want to do with them. Asterisk comes with some helpful tools to do this, such as Alembic. See the  section to get started with Alembic if you are working towards an Asterisk Realtime setup.

 

 

