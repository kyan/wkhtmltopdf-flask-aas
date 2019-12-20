from flask import Flask, Response, request
from werkzeug import secure_filename
from paste.translogger import TransLogger
import pdfkit

import cherrypy

app = Flask(__name__)

tmpfolder = "/tmp/"

@app.route("/pdf", methods=['POST'])
def pdf():
    config = pdfkit.configuration(wkhtmltopdf='/usr/bin/wkhtmltopdf')
    doc = handle_request(config)
    return Response(doc, mimetype='application/pdf')

@app.route("/jpg", methods=['POST'])
def jpg():
    config = pdfkit.configuration(wkhtmltopdf='/usr/bin/wkhtmltoimage')
    doc = handle_request(config)
    return Response(doc, mimetype='image/jpg')


def handle_request(config):
    request_data = request.get_json()
    options = request_data['options']

    print('Options provided: ')
    print(options)

    if ('url' in request_data):
        print("URL provided: " + request_data['url'])
        pdf = pdfkit.from_url(str(request_data['url']), output_path=False, configuration=config, options=options)

    if ('html' in request_data):
        print("Html provided")
        pdf = pdfkit.from_string(unicode(request_data['html']), output_path=False, configuration=config, options=options)

    # If we are receiving the html contents from a uploaded file
    elif ('content' in request.files):
        print("File provided: " + str(request.files['content']))
        f = request.files['content']
        f.save(tmpfolder + secure_filename(f.filename))

        pdf = pdfkit.from_file(tmpfolder + secure_filename(f.filename), output_path=False, configuration=config, options=options)

    return pdf

def run_server():
    # Enable WSGI access logging via Paste
    app_logged = TransLogger(app)

    # Mount the WSGI callable object (app) on the root directory
    cherrypy.tree.graft(app_logged, '/')

    # Set the configuration of the web server
    cherrypy.config.update({
        'engine.autoreload_on': True,
        'log.screen': True,
        'server.socket_port': 8080,
        'server.socket_host': '0.0.0.0'
    })

    # Start the CherryPy WSGI web server
    cherrypy.engine.start()
    cherrypy.engine.block()


if __name__ == "__main__":
    run_server()
