// Copyright (C) 2024 Ekorau LLC. All rights reserved.
// Use of this source code is governed by an MIT-style license that can be
// found in the LICENSE file.

import http
import net

import log
import .topic-tree


/**
Example that demonstrates a web-socket server.
The server updates a counter for button presses.
*/

class WebdServer:

  server_ := http.Server --max-tasks=2
  port_ /int
  subscription_callbacks_ /TopicTree := TopicTree
  sessions := {:}
  logger_ /log.Logger

  constructor
      --port /int = 8080
      --logger /log.Logger = log.default
      --routes /Map = {:}:
    port_ = port
    logger_ = logger
    routes.do: | route/string callback/Lambda |
      subscription_callbacks_.set route callback

  start -> none
      --catch_all_callback /Lambda = :: | request/http.Request response/http.ResponseWriter |
          print "request $request.method $request.path $request.body.read failed"
          response.headers.set "Content-Type" "text/plain"
          response.write_headers 404
          response.write "Not found\n":

    network := net.open
    addr-str := network.address.stringify
    server_.listen network port_ :: | request/http.Request writer/http.ResponseWriter |
      was-executed := false
      subscription-callbacks_.do --most_specialized request.path: | callback |
        callback.call server_ request writer
        was-executed = true
      if not was-executed:
        catch-all-callback.call request writer
        logger_.info "received request for unregistered path $request.path"
