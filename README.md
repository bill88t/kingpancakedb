= Docker MariaDB

This docker sets up and configures a database using MySQL

= Database

We chose to do MariaDB because its an open source software, is free to use and has an active community that contributes to its development. 
It is fully compatible with MySQL and it provides high performance with improved storage capabilities and fast searches while also offering enhanced security features and fixes.

== Docker Steps
* Executes predefined preparation scenarios.
* Checks and creates the necessary folders if they do not exist.
* Configures access permissions for MySQL folders.
* Creates the initial MySQL data if none exists.
* Sets the password of the MySQL root user.
* Optionally, creates a new database and user.
* Executes predefined scripts before booting.
* Starts the MySQL server.

=== How to install

[,ruby]
----
find file 'install.sh'
----

**Open a terminal**
Do the following commands

----
first 'docker volume create mdb1'
----

----
second 'docker build -t kingpancakedb:latest .'
----

----
third 'docker run -d \
    --name myMariaDB \
    -v mdb1:/var/lib/mysql \
    -p 3306:3306 \
    kingpancakedb:latest'
----

==== Checking the Logs
[,ruby]
----
locate file 'monitor.sh'
---- 

----
do 'docker logs -f myMariaDB'
----

==== Removing the docker
[,ruby]
----
locate file 'remove.sh'
---- 

----
do [.red]#'docker container stop myMariaDB'#
----

----
do 'docker container rm myMariaDB'
----

----
do 'docker volume rm mdb1'
----
