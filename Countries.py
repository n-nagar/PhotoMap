import os
from flask import Flask, request, session, g, redirect, url_for, abort, \
     render_template, flash
from sqlite3 import dbapi2 as sqlite3

def list_countries():
	db = get_db()
	cur = db.execute('select country_code, country from Country')
	entries = cur.fetchall()
	return render_template('show_countries.html', entries=entries)