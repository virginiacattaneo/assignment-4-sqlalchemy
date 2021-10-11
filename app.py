from flask import Flask, jsonify,escape, make_response, request
from flask_sqlalchemy import SQLAlchemy

app = Flask(__name__)
app.config['SQLALCHEMY_DATABASE_URI'] = 'sqlite:////tmp/test.db'
app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = False
db = SQLAlchemy(app)

class Assignment(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    name = db.Column(db.String(80), unique=True, nullable=False)
    description = db.Column(db.String(400), unique=True, nullable=False)
    price = db.Column(db.String(80), unique=True, nullable=False)
    status= db.Column(db.String(100), unique=True, nullable=False)

    def __repr__(self):
         Assignment={"id":self.id,
                     "name":self.name,
                     "description":self.description,
                     "price":self.price,
                     "status":self.status
                    }
         return Assignment

# Get Assignments
@app.route('/assignments/',methods=['GET'])
def ViewAllAsignments():
    assignment = {"assignments":[]}
    assignment['assignments']=Assignment.query.all()
    all_assignments=[]
    for i in assignment['assignments']:
        all_assignments.append(Assignment.__repr__(i))
    return make_response(jsonify({"assignments":all_assignments}))    



# Get Assignment by name
@app.route('/assignments/<name>',methods=['GET'])
def ViewAssignments(name):
    assignment=Assignment.query.filter_by(name=name).first()
    if (assignment is None):
        return make_response(jsonify({"assignments":"Not found"}),404)   
    else: 
        return make_response(jsonify({"assignment":[Assignment.__repr__(assignment)]}))   
   
         
# Create New Assignment
@app.route('/assignments', methods=['POST'])
def addAssignments():
    new_name=request.json['name']
    new_description=request.json['description']
    new_price=request.json['price']
    new_status=request.json['status']
    new_assignment = Assignment(name=new_name ,description=new_description ,price=new_price ,status=new_status)
    assignment=Assignment.query.filter_by(name=request.json['name']).first()
    if assignment is None:
        db.session.add(new_assignment)  
        db.session.commit()
        mostrar_assig=Assignment.query.filter_by(name=request.json['name']).first()
        return make_response(jsonify(Assignment.__repr__(mostrar_assig)))
    else:    
        return make_response(jsonify({"assignment": "repeated"}),409)

 
# Update Assignment
@app.route('/assignments/<string:name>', methods=['PUT'])
def UpdateAssignment(name):
    assignment=Assignment.query.filter_by(name=name).first() 
    if assignment is None:   
        return make_response(jsonify({"Assignments":"Not Found!"}),404) 
    else:
        new_name=request.json['name']
        assignment.name=new_name
        db.session.commit() 
        return make_response(jsonify({"assignment":[Assignment.__repr__(assignment)]}))
   
# Delete Assignment
@app.route('/assignments/<string:name>', methods=['DELETE'])
def DeleteAssignment(name):
    assignment=Assignment.query.filter_by(name=name).first()
    if assignment is None:
        return make_response(jsonify({"Assignments":"Not Found!"}),404) 
    else:
        db.session.delete(assignment)  
        db.session.commit() 
        assignment_deleted=Assignment.query.filter_by(name=name).first()
        return make_response(jsonify({"assignments":[assignment_deleted]}))   
           

def shutdown_server():
    func = request.environ.get('werkzeug.server.shutdown')
    if func is None:
        raise RuntimeError('Not running with the Werkzeug Server')
    func()


@app.route('/shutdown', methods=['POST'])
def shutdown():
    shutdown_server()
    return 'Server shutting down...'
