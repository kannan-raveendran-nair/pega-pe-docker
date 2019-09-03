Place the following files into <project root>/pega/resources
1. prweb.war
2. prhelp.war [optional]
3. prsysmgmt.war [optional]

They will be auto-picked by dockerbuild for generating the image

Place the jdbc driver for the database you use into <project root>/pega/resources/jdbc_drivers. Don't place anything else other than the jdbc drivers in this folder.
