from app import db

if __name__ == "__main__":
    print("Creating DB tables")
    db.create_all()
