// Copyright (C) 2024 Ekorau LLC. All rights reserved.
// Use of this source code is governed by an MIT-style license that can be
// found in the LICENSE file.

import http show Server Request ResponseWriter
import http.request show RequestIncoming
import http.web_socket show WebSocket
import net
import webd show WebdServer

/**
Example that demonstrates a web server, with support for web-sockets.
The server updates a counter for button presses.
*/

network := net.open
addr-str := network.address.stringify

main:
  print "Starting web server at $addr-str:8080" 
  webd-server := WebdServer --port=8080 --routes={
    "/": :: | server/Server request/Request response/ResponseWriter |
      response.headers.set "Content-Type" "text/html"
      response.write SPA
      response.close,
    "/ws": :: | server/Server request/Request response/ResponseWriter |
      print "websocket request invoked"
      websocket := server.web_socket (request as RequestIncoming) response
      if websocket:
        handle websocket 
  }
  webd-server.start 

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
          ws = new WebSocket('ws://$addr-str:8080/ws');
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