from flask import Flask
app = Flask(__name__)
 
@app.route('/')
def movieapp():
   return "Hello World!"
 
if __name__ == '__main__':
   app.run(debug=False)