import os
from flask import Flask, request, session, g, redirect, url_for, abort, \
     render_template, flash, jsonify
from sqlite3 import dbapi2 as sqlite3

app = Flask(__name__)

app.config.update(dict(
	DATABASE=os.path.join(app.root_path, 'PhotoMap.db'),
	DEBUG=True
))

def connect_db():
	rv = sqlite3.connect(app.config['DATABASE'])
	rv.row_factory = sqlite3.Row
	return rv

def get_db():
	if not hasattr(g, 'sqlite_db'):
		g.sqlite_db = connect_db()
	return g.sqlite_db

@app.teardown_appcontext
def close_db(error):
	if hasattr(g, 'sqlite_db'):
		g.sqlite_db.close()

@app.route('/')
def show_index():
	return render_template('index.html')

@app.route('/PhotoMap/api/countries/<ccode>', methods=['PUT'])
def update_country(ccode):
	print(request.data)
	db = get_db()
	cur = db.execute('select country from Country where country_code = ?', (ccode,))
	if (cur == None):
		abort(400)

	entry = cur.fetchone()
	if (entry == None):
		abort(404)
	new_name = request.json.get('name', entry['Country'])
	cur.close()
	cur = db.execute('update Country set country = ? where country_code = ?', (new_name, ccode))
	ret = jsonify(cur)
	db.commit()
	cur.close()
	return ret


@app.route('/countries')
def show_countries():
	db = get_db()
	cur = db.execute('select country_code, country from Country')
	entries = cur.fetchall()
	cur.close()
	return render_template('show_countries.html', entries=entries)

if __name__ == '__main__':
	app.run()