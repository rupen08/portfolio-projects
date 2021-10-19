from flask import Flask,render_template,url_for,request	 
import pickle

clf = pickle.load(open("model.pkl", 'rb'))
vector= pickle.load(open('abc.pkl','rb'))
app = Flask(__name__)

@app.route("/") ## Home page
def home():
    return render_template("index.html")  

@app.route("/predict", methods = ["GET", "POST"]) ## Page after submitting some data 
def predict():
    if request.method == "POST":
        get_msg = request.form["text_msg"]
        data = [get_msg]  ## Why List
        trans = vector.transform(data) ## here we are just doing transform instead of fit_transform as it is test data!!!
        new_prediction = clf.predict(trans) ## here we are predicting result
    return render_template("output.html", prediction = new_prediction) 
    ## render_template: "prediction" is name of the template nd has to be same as /predict HTML file's jinja for loop variable
    ## and new_prediction is the variable we wanna return from /predict route

if __name__ ==  "__main__":
    app.run(Debug = True)