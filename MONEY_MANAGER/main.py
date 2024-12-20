from flask import Flask, render_template, session, redirect, url_for, request, jsonify
import bcrypt
import mysql.connector
from mysql.connector import Error
import uuid
from settings import *
from datetime import datetime, timedelta
from dateutil.relativedelta import relativedelta
import json
from SendMail import SendMail

app = Flask(__name__)
app.secret_key = b'K%h\xf4\xaa\xecB6\xaf/:>X\xf0\x1a$\x19r\x87O\xe4\x1a\xa00'

hostname = HOSTNAME
username = USERNAME
password = PASSWORD
dbname = DBNAME

mailer = SendMail()

def create_connection(hostname, username, password, dbname):
    connection = None
    try:
        connection = mysql.connector.connect(
            host=hostname,
            user=username,
            passwd=password,
            database=dbname
        )
    except Error as e:
        pass
    return connection

connection = create_connection(hostname, username, password, dbname)

def execute_param_query(query, params):
    connection = create_connection(hostname, username, password, dbname)
    cursor = connection.cursor()
    try:
        cursor.execute(query, params)
        connection.commit()
    except Error as e:
        raise e
    finally:
        cursor.close()

def execute_read_query(query, params=None):
    connection = create_connection(hostname, username, password, dbname)
    cursor = connection.cursor()
    result = None
    try:
        if params:
            cursor.execute(query, params)
        else:
            cursor.execute(query)
        result = cursor.fetchall()
        return result
    except Error as e:
        pass

def create_session(userid):
    session_id = str(uuid.uuid4())
    session_key = str(uuid.uuid4())

    # SessionID	 UserID	 SessionKey	  CreatedAt
    query = """
    INSERT INTO Sessions (SessionID, UserID, SessionKey) VALUES (%s, %s, %s)
    """

    params = (session_id, userid, session_key)
    execute_param_query(query, params)
    session["session_id"] = session_id
    session["userid"] = userid
    session["session_key"] = session_key

def validate_session():
    username = session.get("userid")
    session_id = session.get("session_id")
    session_key = session.get("session_key")

    if session_id and username and session_key:
        query = """
        SELECT * FROM Sessions WHERE SessionID=%s AND UserID=%s AND SessionKey=%s
        """
        params = (session_id, username, session_key)
        result = execute_read_query(query, params)
        if result:
            return True
        
    return False

def hash_password(password):
    salt = bcrypt.gensalt()
    hashed = bcrypt.hashpw(password.encode("utf-8"), salt)
    return hashed

def comp_password(entered_password, stored_password):
    return bcrypt.checkpw(entered_password.encode("utf-8"), stored_password)

def get_assets(userid):
    query = """
        SELECT * FROM Assets WHERE UserID = %s;
    """ 

    params = (userid, )

    return execute_read_query(query, params)

def get_transactions(userid):

    today = datetime.today()
    today = today.strftime('%Y-%m-%d')

    query = """
    SELECT * From Transaction WHERE UserID = %s AND Date >= %s ORDER BY Date ASC;
    """
    params = (userid, today, )

    return execute_read_query(query, params)
    
def get_users(username):
    query = """
    SELECT * FROM Users WHERE UserName = %s
    """

    params = (username, )

    return execute_read_query(query, params)

def get_categories(category):
    query = """
        SELECT * FROM Categories WHERE CategoryName = %s
    """
    params = (category,)

    return execute_read_query(query, params)[0]

def calc_total_assets(userid):
    assets = get_assets(userid)

    total = 0
    for asset in assets:
        total += asset[-1]

    return total

def get_simple_transaction_data(userid):
    transactions = get_transactions(userid)

    total_assets = calc_total_assets(userid)

    data = []
    for trans in transactions:
        if trans[-1]:
            tmp = [trans[3].year, trans[3].month, trans[3].day, total_assets-trans[2]]
            total_assets -= trans[2]
        else:
            tmp = [trans[3].year, trans[3].month, trans[3].day, total_assets+trans[2]]
            total_assets += trans[2]

        data.append(tmp)

    return data

def generate_provisional_url(token):
    baseurl = "http://localhost"
    port = 8080
    authpoint = "auth_register"

    url = baseurl + "/" + authpoint + "?token=" + token

    return url

def loop_put_item(query, params, options):

    between_select = int(options[0])
    todate = datetime.strptime(options[1], "%Y-%m-%d")
    tmpdate = datetime.strptime(params[2], "%Y-%m-%d")

    if between_select == 0:
        while(tmpdate <= todate):
            execute_param_query(query, tuple(params))
            params[2] = (tmpdate + relativedelta(months=1)).strftime("%Y-%m-%d")
            tmpdate += relativedelta(months=1)

    elif between_select == 1:
        while(tmpdate <= todate):
            execute_param_query(query, tuple(params))
            params[2] = (tmpdate + timedelta(weeks=1)).strftime("%Y-%m-%d")
            tmpdate += timedelta(weeks=1)

    elif between_select == 2:
        while(tmpdate <= todate):
            execute_param_query(query, tuple(params))
            params[2] = (tmpdate + timedelta(days=1)).strftime("%Y-%m-%d")
            tmpdate += timedelta(days=1)


@app.route("/manager/list/delete", methods=["POST"])
def delete_item():
    data = request.get_json()
    entryid = data["entryid"]

    query = """
        DELETE FROM Transaction WHERE EntryID = %s
    """

    params = (entryid, )

    execute_param_query(query, params)
    userid = session.get("userid")
    
    query = """
    SELECT UserName FROM Users WHERE UserID = %s
    """

    params = (userid, )

    username = execute_read_query(query, params)[0][0]

    return render_template("forecast_list.html", username=username), 200


@app.route("/manager/list/change", methods=["POST"])
def change_item():
    data = request.get_json()
    userid = None

    for datum in data:
        entryid = datum["entryid"][0]
        value = int(datum['value'])
        entrytype = int(datum['entrytype'])
        if value < 0:
            value = abs(value)
            entrytype = (entrytype + 1) % 2
        date = datum['date']
        category = datum['category']
        categoryid = get_categories(category)[0]
        
        description = datum['description']

        query = """
        UPDATE Transaction SET UserID=%s, Amount=%s, Date=%s, CategoryID=%s, Description=%s, EntryType=%s WHERE EntryID=%s
        """

        params = (session.get("userid"), value, date, categoryid, description, entrytype, entryid, )

        execute_param_query(query, params)

        userid = session.get("userid")

        query = """
            SELECT UserName FROM Users WHERE UserID = %s
        """

        params = (userid, )

        username = execute_read_query(query, params)[0][0]

    return render_template("forecast_list.html", username=username), 200
    

@app.route("/auth_register")
def auth_register():
    token = request.args.get("token")

    query = """
        SELECT * From Provisional_Users WHERE Token=%s
    """

    params = (token, )

    result = execute_read_query(query, params)

    if result:
        query = """
        INSERT INTO Users(UserName, Email, PasswordHash) VALUES (%s, %s, %s)
        """

        params = (result[0][1], result[0][2], result[0][4],)

        execute_param_query(query, params)

        query = "DELETE FROM Provisional_Users WHERE token=%s"
        params = (token, )

        execute_param_query(query, params)

        return render_template("auth.html", auth="本登録が完了いたしました。")
    else:
        return render_template("auth.html", auth="リンクが正しくないようです。")


@app.route("/register", methods=["GET", "POST"])
def register():
    if validate_session():
        return redirect(url_for("index"))

    msg = """"""
    if request.method == "POST":
        username = request.form.get("nickname").lower()
        address = request.form.get("email")
        password = hash_password(request.form.get("password"))

        result = get_users(username)

        if result:
            msg = """
            Your username is already in use and your email address is already registered.
            """

            return render_template("register.html", msg=msg)


        # UserID	UserName	Email	timestamp	PasswordHash	
        query = """
        INSERT INTO Provisional_Users (UserName, Email, PasswordHash, Token) VALUES (%s, %s, %s, %s)
        """

        token = str(uuid.uuid4())

        params = (username, address, password, token, )

        try:
            execute_param_query(query, params)

            subject = """仮登録メール"""
            body = """
            仮登録が完了いたしました。
            以下のURLをクリックし、本登録を完了させてください。

            """

            body = body + "\n" + generate_provisional_url(token)

            mailer.send_email(receiver_email=address, subject=subject, body=body)

            return redirect(url_for("index"))
        except Exception as e:

            msg = """
            Your username is already in use and your email address is already registered.
            """

    return render_template("register.html", msg=msg)

@app.route("/logout", methods=["GET"])
def logout():
    session_id = session.get("session_id")
    if session_id:
        query = """
        DELETE FROM Sessions WHERE SessionID=%s
        """
        params = (session_id,)
        execute_param_query(query, params)
        session.clear()

    return redirect(url_for("index"))


@app.route("/", methods=["GET", "POST"])
def index():
    if request.method == "POST":
        username = request.form.get("username").lower()
        password = request.form.get("password")

        row = get_users(username)

        if row:
            data = row[0]
            userid = data[0]
            if comp_password(password, data[3].encode("utf-8")):
                create_session(userid)
                userid = session.get("userid")
                return render_template("graph.html", userid=userid, transactions=get_simple_transaction_data(userid), assets=get_assets(userid), total_asset=calc_total_assets(userid))
            else:
                return render_template("index.html", message="Incorrect email or password.")
        else:
            return render_template("index.html", message="Incorrect email or password.")

    if validate_session():
        userid = session.get("userid")

        query = """
            SELECT UserName FROM Users WHERE UserID = %s
        """

        params = (userid, )

        username = execute_read_query(query, params)[0][0]

        return render_template("graph.html", username=username, transactions=get_simple_transaction_data(session.get("userid")), assets=get_assets(session.get("userid")), total_asset=calc_total_assets(session.get("userid")))

    return render_template("index.html")

@app.route("/manager")
def manager():
    if validate_session():
        userid = session.get("userid")

        query = """
            SELECT UserName FROM Users WHERE UserID = %s
        """

        params = (userid, )

        username = execute_read_query(query, params)[0][0]

        return render_template("graph.html", username=username, transactions=get_simple_transaction_data(session.get("userid")), assets=get_assets(session.get("userid")), total_asset=calc_total_assets(session.get("userid")))
    
    return redirect(url_for("index"))

@app.route("/manager/list/put", methods=["POST"])
def put_item():
    if request.method == "POST":
        if validate_session():
            data = request.get_json()

            for datum in data:
                value = datum['value']
                date = datum['date']
                category = datum['category']
                description = datum['description']
                loop = datum["loop"]
                loopbtwdate = datum["loopbtwdate"]

                result = get_categories(category)

                categoryid = result[0]
                categorytype = result[-1]

                if categorytype == "Income":
                    select = 0
                else:
                    select = 1

                userid = session.get("userid")

                query = """
                        INSERT INTO Transaction (UserID, Amount, Date, CategoryID, Description, EntryType) VALUES (%s, %s, %s, %s, %s, %s)
                    """
                params = (userid, value, date, categoryid, description, int(select))

                if loopbtwdate != "" and loopbtwdate != None and loop != "" and loop != None:
                    options = (loop, loopbtwdate)
                    loop_put_item(query, list(params), options)
                else:
                    execute_param_query(query, params)

            return jsonify({'status': 'success'}), 200

    return jsonify({'status': 'failure'}), 400


@app.route("/manager/forecast_list")
def forecast_list():
    userid = None

    query = """
    SELECT CategoryName From Categories;
    """

    result = execute_read_query(query)

    categories = []

    for item in result:
        categories.append(item[0])

    userid = session.get("userid")

    data = get_transactions(userid)

    msg = ""

    if not data:
        msg = "No data available"

    assets_data = get_assets(userid)
    sum = 0

    if assets_data:
        for item in assets_data:
            sum += int(item[3])

    userid = session.get("userid")

    query = """
            SELECT UserName FROM Users WHERE UserID = %s
    """

    params = (userid, )

    username = execute_read_query(query, params)[0][0]

    return render_template("forecast_list.html", username=username, categories=categories, data=data, sum=sum, msg=msg)

@app.route("/manager/assets", methods=["GET", "POST"])
def assets():
    if request.method == "POST" and validate_session():
        userid = session.get("userid")
        p_assets = json.loads(request.form.get("assets"))
        query = """
            DELETE FROM Assets
        """

        execute_param_query(query, params=())
        
        query = """
            INSERT INTO Assets(UserID, Name, Value) VALUES (%s, %s, %s)
        """

        for item in p_assets:
            params = (userid, item[0], item[1],)
            execute_param_query(query, params)

    userid = session.get("userid")
    assets_data = get_assets(userid)

    msg = ""

    if not assets_data:
        msg = "No data available"

    userid = session.get("userid")

    query = """
            SELECT UserName FROM Users WHERE UserID = %s
    """

    params = (userid, )

    username = execute_read_query(query, params)[0][0]

    return render_template("assets.html", username=username, assets_data=assets_data, msg=msg)


if __name__ == "__main__":
    app.run(host="0.0.0.0", port=80, debug=True)

