provider "aws" {
    region = "us-east-1"   // your AWS region
}

resource "aws_db_instance" "myRDS" {
    db_name = "myDB"   
    identifier = "my-first-db"         // name of the database
    instance_class = "db.m5.large"     // instance class
    engine = "mariadb"                 // specify the SQL database
    engine_version = "10.11.7"         // database version
    username = "bob"                   // authentication username
    password = "password123"           // authentication password
    port = 3306                        // port number on which Db instance is running
    allocated_storage = 20
    skip_final_snapshot = true
}
