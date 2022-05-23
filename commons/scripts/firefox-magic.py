#!/usr/bin/env python3
import sys, os
import time

FIREFOX="/run/current-system/sw/bin/firefox"

def run():
  if len(sys.argv) == 1:
    os.execv(FIREFOX, [FIREFOX])
    return
  temp = open("/tmp/firefox.container.chooser.html", "w")
  url = sys.argv[1]
  print(f"Openening {url}")
  temp.write(header(url))
  for profile in profiles:
    name = profile["name"]
    color = profile["color"]
    temp.write(f"""
      <button type="button" class="btn btn-primary"
        onClick="window.location.href = 'ext+container:name={name}&url={url}';"
      >{name}</button>
    """)
  temp.write(tail)
  temp.close()
  os.execv(FIREFOX, [FIREFOX, "/tmp/firefox.container.chooser.html"])



# cat ~/.mozilla/firefox/vtehakby.default/containers.json | jq -cr ".identities | map(select(.public)| {name: .name, color: .color}) "
profiles = [
  {"name":"Hiya","color":"purple"},
  {"name":"Personal","color":"red"},
  {"name":"oem","color":"green"},
  {"name":"aegis","color":"blue"},
  {"name":"data","color":"orange"},
  {"name":"Facebook","color":"toolbar"},
  {"name":"app-brain","color":"yellow"}
]
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