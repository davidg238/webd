import http
import http.request show RequestIncoming
import http.web_socket show WebSocket
import net

/**
Example that demonstrates a web-socket server.
The server updates a counter for button presses.
*/

network := net.open
addr-str := network.address.stringify
server := http.Server --max-tasks=2
ws-path := "ws_counter"

main:
  print "Open a browser on: $network.address:8080"
  sessions := {:}
  server.listen network 8080:: | request/RequestIncoming response/http.ResponseWriter |
    if request.path == "/$ws-path":
      websocket := server.web_socket request response
      if websocket:
        handle websocket
    else if request.path == "/":
      response.write SPA
    else:
      print "request $request.method $request.path $request.body.read failed"
      response.headers.set "Content-Type" "text/plain"
      response.write_headers 404
      response.write "Not found\n"
    print "exit handler"


handle websocket /WebSocket -> none:
  task --background=true::
    i := 1
    while in := websocket.receive:
      print "received: $in"
      websocket.send "{\"counter\": $i}"
      i += 1


SPA := """
<!DOCTYPE HTML>
<html>
  <head>
    $style
  </head>
  <body onload="open_ws_connection()">
    <h1>Counter</h1>
    <p id="counter">0</p>
    <button onclick="device_on(1)">Click me</button>
    <div id="alerts"> -- -- </div>
  </body>
  $script
</html>
"""

script := """
<script type = "text/javascript">
    var ws;
    
    function send_num(device, num) {
      ws.send('{"' + device + '": ' + num + '}');
    }
    function device_on(adevice) {
      send_num(adevice, 1);
    }
    function device_off(adevice) {
      send_num(adevice, 0);
    }
    function dispatch_msg(msg)  {
      // const obj = JSON.parse(msg)
      
      const obj = JSON.parse(msg, function (key, value) {
        var el = document.getElementById(key);
        if (el != null) {
          el.innerHTML = value;
        };
      });
    }

    function open_ws_connection() {
      if ("WebSocket" in window) {
          ws = new WebSocket('ws://$addr-str:8080/$ws-path');
          ws.onopen = function() {
            document.getElementById("alerts").innerHTML = "-- active --";
          };
          ws.onmessage = function (evt) { 
            var received_msg = evt.data;
            dispatch_msg(received_msg);
          };
          ws.onclose = function() {
            document.getElementById("alerts").innerHTML = "-- closed --";
          };
      } else {
          // The browser doesn't support WebSocket
          alert("WebSocket NOT supported by your Browser!");
      };
    }
</script>
"""

style := """
    <style>
      .tab {
        overflow: hidden;
        border: 1px solid #ccc;
        background-color: #f1f1f1;
      }
      /* Style the buttons that are used to open the tab content */
      .tab button {
        background-color: inherit;
        float: left;
        border: none;
        outline: none;
        cursor: pointer;
        padding: 14px 16px;
        transition: 0.3s;
      }
      /* Change background color of buttons on hover */
      .tab button:hover {
        background-color: #ddd;
      }

      /* Create an active/current tablink class */
      .tab button.active {
        background-color: #ccc;
      }
      /* Style the tab content */
      .tabcontent {
        display: none;
        padding: 6px 12px;
        border: 1px solid #ccc;
        border-top: none;
      }
      table, th, td {
        padding: 5px;
        border-collapse: collapse;
      }
    </style>
"""