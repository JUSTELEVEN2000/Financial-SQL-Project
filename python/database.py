import mysql.connector


def connect_database():
    connection = mysql.connector.connect(
        host="localhost",
        user="root",
        password="Sly041632",
        database="financial_project",
    )

    print("Database connected successfully!")

    return connection
