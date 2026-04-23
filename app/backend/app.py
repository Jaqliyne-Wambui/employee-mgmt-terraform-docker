from flask import Flask, request, jsonify
from flask_sqlalchemy import SQLAlchemy
from flask_cors import CORS
import os

app = Flask(__name__)
CORS(app) # This allows your HTML to talk to this Python code

# Connection string for Postgres (we will set this in K8s later)
app.config['SQLALCHEMY_DATABASE_URI'] = os.environ.get('DATABASE_URL')
db = SQLAlchemy(app)

# The Database Table structure
class Employee(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    name = db.Column(db.String(100), nullable=False)

@app.route('/employees', methods=['GET'])
def get_employees():
    employees = Employee.query.all()
    return jsonify([{"id": e.id, "name": e.name} for e in employees])

@app.route('/add', methods=['POST'])
def add_employee():
    data = request.json
    new_emp = Employee(name=data['name'])
    db.session.add(new_emp)
    db.session.commit()
    return jsonify({"message": "Success"}), 201

if __name__ == '__main__':
    with app.app_context():
        db.create_all() # Creates the table automatically
    app.run(host='0.0.0.0', port=5000)
