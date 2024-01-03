// Copyright (C) 2024 Ekorau LLC. All rights reserved.
// Use of this source code is governed by an MIT-style license that can be
// found in the LICENSE file.

import webd show *

main:

  routes := {
    "/": :: print "root invoked",
    "/index.html": :: print "index.html invoked",
    "/ws": :: print "ws invoked"
  }
  was-executed := false

  tree := TopicTree
  routes.do: | route/string callback/Lambda |
    tree.set route callback

  tree.do --most_specialized "bob": | callback |
    callback.call
    was-executed = true
  
  if not was-executed:
    print "not executed"
  else:
    print "executed"