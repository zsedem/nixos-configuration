#!/usr/bin/env python3
import sys, os
import time
import json
from urllib.parse import urlparse
import argparse

parser = argparse.ArgumentParser()
parser.add_argument('--name', dest="name")
parser.add_argument('uri')
parser.parse_args()

FIREFOX="/run/current-system/sw/bin/firefox"
with open("/etc/firefox-opener-config.json") as fp:
  CONFIG=json.load(fp)

profiles = CONFIG["containers"]
host_mapping = CONFIG["host-mapping"]

def run():
  if len(sys.argv) == 1:
    os.execv(FIREFOX, [FIREFOX])
    return
  temp = open("/tmp/firefox.container.chooser.html", "w")
  parsed, unknown = parser.parse_known_args()
  url = parsed.uri
  print(f"Openening {url}")
  try:
    netloc = urlparse(url).netloc
    if netloc in host_mapping:
      os.execv(FIREFOX, [FIREFOX, f'ext+container:name={host_mapping[netloc]}&url={url}'])
  except ValueError:
    print(f"Couldn't parse '{url}' as an url")
  temp.write(header(url))
  for profile in profiles:
    name = profile["name"]
    color = profile["color"]
    temp.write(f"""
      <button type="button" class="btn btn-primary" style="background-color: {color};"
        onClick="window.location.href = 'ext+container:name={name}&url={url}';"
      >{name}</button>
    """)
  temp.write(tail)
  temp.close()
  os.execv(FIREFOX, [FIREFOX, "/tmp/firefox.container.chooser.html"])



def header(url):
   return """
      <!DOCTYPE html>
      <html>
        <head>
          <title>Opening url</title>
          <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-EVSTQN3/azprG1Anm3QDgpJLIm9Nao0Yz1ztcQTwFspd3yD65VohhpuuCOmLASjC" crossorigin="anonymous">
        </head>
        <body>
          <div class="modal-dialog">
            <div class="modal-content">
              <div class="modal-header">
                <h5 class="modal-title">Choose Container</h5>
              </div>
              <div class="modal-body">
    """
tail = """
              </div>
            </div>
          </div>
        </body>
      </html>
      """

if __name__ == '__main__':
  run()
