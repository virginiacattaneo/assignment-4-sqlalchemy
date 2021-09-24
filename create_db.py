from app import db, create_app

if __name__ == "__main__":
    print("Creating DB tables")
    db.create_all()
    # Comentar la linea anterior y descomentar la linea que sigue este si se usa una factory para crear la app
    # db.create_all(app=create_app())
    
