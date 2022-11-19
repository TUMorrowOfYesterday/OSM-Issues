from flask import Flask, jsonify, request

#UPLOAD_FOLDER = './images'
#ALLOWED_EXTENSIONS = {'png', 'jpg', 'jpeg'}


app = Flask(__name__) 
#app.config['UPLOAD_FOLDER'] = UPLOAD_FOLDER



@app.route("/")
def hello_app():
    return "Hello World"




@app.route("/leaderboard")
def leaderboard():
    
    # list of [username, score]
    board = [
        ["j", 1],
        ["w", 4]
    ]
    
    return jsonify(board)


@app.route("/upload_Issue", methods=['POST'])
def upload():
    request.files.get('image', '').save('image.jpg')
    
    # return result and rewards
    return jsonify(leaderboard)    



@app.route("/update_Position", methods=['POST'])
def upload():
    longitude = request.args['longitude']
    latitude = request.args['latitude']

    
    # return 
    return jsonify(leaderboard)      


@app.route("/get_OthersPosition")
def others():

     # list of [username, longitude, latitude, avatarId]
    otherInfo = [
        ["username"]
    ]

    # return other peoples position
    return       


@app.route("/get_Issues", methods=['GET'])
def issues():
   
    # return the issues to render on map
    return jsonify(leaderboard)       






# @app.route("/upload_issue", methods=['POST'])
# def upload():
    