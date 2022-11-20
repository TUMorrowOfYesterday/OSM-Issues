from flask import Flask, jsonify, request
import sqlite3
import csv

#UPLOAD_FOLDER = './images'
#ALLOWED_EXTENSIONS = {'png', 'jpg', 'jpeg'}



app = Flask(__name__) 
#app.config['UPLOAD_FOLDER'] = UPLOAD_FOLDER

con = sqlite3.connect("app.db", check_same_thread=False)




# hello beautiful world
@app.route("/")
def hello_app():
    return "Hello World"

# App first-time registration of a user, args: user (longitude, latitude, avatar hardcoded first)
# returns Success if inserted to db, Failure if username not unique
@app.route("/register", methods=['POST'])
def register():
    userId = request.args['user']
    # longitude = request.args['longitude']
    # latitude = request.args['latitude']
    # avatarId = request.args['avatar']

    cur = con.cursor()

    try:
        cur.execute("INSERT INTO users VALUES (?,0,null,null,0)", (userId, ))
        con.commit()
        cur.close()
        return jsonify(True)
    except sqlite3.IntegrityError:
        cur.close()
        return jsonify(False)



# App GETS leaderboard
# returns all [[username, score]], filter and display in App
@app.route("/leaderboard", methods=['GET'])
def leaderboard():
    cur = con.cursor()
    res = cur.execute("SELECT userId, score, avatarId FROM users ORDER BY score DESC").fetchall()
    cur.close()
    return jsonify(res)



# App POSTS args: image, user, issue
# returns [result, updatedScore]
@app.route("/upload_Issue", methods=['POST'])
def upload():
    baseScore = 10

    userId = request.args['user']
    issueId = request.args['issue']
    # for better score estimation of issue
    # startLon = request.args['startLon']
    # startLat = request.args['startLat']
    request.files.get('image', '').save('image.jpg')
    

    # ML Model
    res = "footway"


    cur = con.cursor()
    score, = cur.execute("SELECT score FROM users where userId = ?", (userId, )).fetchone()
    issueLon, = cur.execute("SELECT longitude FROM openIssues where issueId = ?", (issueId, )).fetchone()
    issueLat, = cur.execute("SELECT latitude FROM openIssues where issueId = ?", (issueId, )).fetchone()

    # update score in users table
    cur.execute("UPDATE users SET score=? WHERE userId = 'tomate'", (score + baseScore, ))
    # insert into fixedIssues
    cur.execute("""
     INSERT INTO fixedIssues VALUES
         (?, ?, ?, ?) """, (issueId, issueLon, issueLat, userId, ))
    # remove from openIssues
    cur.execute("DELETE FROM openIssues WHERE issueId = ?", (issueId, ))  
    con.commit()   
    cur.close()


    return jsonify([res, (score + baseScore)])

    

# App POSTS args: user, longitude, latitude
# returns Success 
@app.route("/update_Position", methods=['POST'])
def updatePos():
    userId = request.args['user']
    longitude = request.args['longitude']
    latitude = request.args['latitude']

    cur = con.cursor()
    # does null / None for longitude/latitude work ?
    cur.execute("UPDATE users SET longitude = ?, latitude = ? WHERE userId = ?", (longitude, latitude, userId))
    con.commit()
    cur.close()

    # return nothing ? 
    return "Success"  


# App GETS position of other users to render on map
# returns [[userId, score, longitude, latitude, avatarId]]
@app.route("/get_OthersPosition", methods=['GET'])
def others():

    cur = con.cursor()
    res = cur.execute("SELECT * FROM users WHERE longitude NOT null")
    cur.close()

    # return other peoples position
    return jsonify(res)        


# App GETS the openIssues to render on map
# returns all [[issueId, longitude, latitude, radius, showLongitude, showLatitude]]
@app.route("/get_openIssues", methods=['GET'])
def openIssues():
    cur = con.cursor()
    res = cur.execute("SELECT * FROM openIssues").fetchall()
    cur.close()
    return jsonify(res)    



# App GETS the fixedIssues to render already fixed issues on map with their fixer
# returns all [[issueId, longitude, latitude, fixedBy]]
@app.route("/get_fixedIssues", methods=['GET'])
def closedIssues():
    cur = con.cursor()
    res = cur.execute("SELECT * FROM fixedIssues").fetchall()
    cur.close()
    return jsonify(res)             







    