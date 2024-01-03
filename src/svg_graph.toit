// Copyright (C) 2024 Ekorau LLC. All rights reserved.
// Use of this source code is governed by an MIT-style license that can be
// found in the LICENSE file.

import http
import.graph_layout
import http


abstract class SVGgraph:

  writer /http.ResponseWriter

  polylines /List := []
  // defaults, if nothing better is set
  v-width := 400
  v-height := 300

  graph-h := 1
  graph-w := 100
  xLabel := "X"
  yLabel := "Y"
  x-grid-interval := 5
  y-grid-interval := 20
  xMin := 0
  xMax := 100
  yMin := 0
  yMax := 100
  pad := 5
  lMargin := 25
  bMargin := 25
  x-border-h := 40
  y-border-w := 40

  x-grid-cache := List
  y-grid-cache := List

  x-layout /GraphLayout? := null
  y-layout /GraphLayout? := null

  dataset-transform := "translate(-725, 579.5455) scale(13.3929, -1.9318)"
  marker /Marker? := null

  constructor .writer:

  addMarker x /int y /int style /string:

      marker = Marker x y style

  write_ str/string -> none:
    writer.write str

  write --.v-width/int --.v-height/int --.xLabel/string --.x-layout --.yLabel/string --.y-layout --.polylines/List -> none:
    x-grid-interval = (v-width / x-layout.tick-num).floor
    y-grid-interval = (v-height / y-layout.tick-num).floor
    graph-w = x-grid-interval * x-layout.tick-num
    graph-h = y-grid-interval * y-layout.tick-num
    calculate-dataset-transform

    write_ "<div id=\"$xLabel\" class=\"flex-row\">\n"
    write-graph-xcontainer
    write-ycontainer
    write_ "</div>\n"

  calculate-dataset-transform -> none:
//        String datasetTransform = "translate(-11256, 420) scale(5.6, -0.00014)";
    xS := graph-w / (x-layout.max-nice - x-layout.min-nice).to-float
    yS := -graph-h / (y-layout.max-nice - y-layout.min-nice).to-float
    xT := (graph-w - (xS * x-layout.max-nice)).to-float
    yT := (graph-h - (yS * y-layout.min-nice)).to-float //

    dataset-transform = "translate($(%.2f xT), $(%.2f yT)) scale($(%.2f xS), $(%.2f yS)"

  write-ycontainer -> none:
    // write_ "<div style=\"float:left\">\n"
    write-yBorder
    // write_ "</div>\n"

  write-yBorder -> none:
    fill-y-grid-cache
    write_ "<svg width=\"$y-border-w\" height=\"$v-height\">\n"
    write_ "<text x=\"5\" y=\"200\" font-size=\"15\">$yLabel</text>\n"
    write_ "</svg>\n"

  fill-y-grid-cache -> none:
    loc := 0
    y-grid-cache = List (y-layout.tick-num).to-int
    for i := 0; i < y-layout.tick-num; i++:
        loc = graph-h - (y-grid-interval + i*y-grid-interval);
        y-grid-cache[i] = loc;

  write-graph-xcontainer -> none:
    // write_ "<div style=\"float:left\">\n"
    // write_ "<div style=\"position: relative;left: 0px; width: $v-width px;\">\n"
    write_ "<div class=\"flex-column\">\n"
    write_ "<div>\n"
    write-graph
    write_ "</div>\n"
    write_ "<div>\n"
    write-x-border
    write_ "</div>\n"
    write_ "</div>\n"
    // write_ "</div>\n"
    // write_ "</div>\n"

  write-graph -> none:
    write_ "<svg width=\"$v-width\" height=\"$v-height\">\n"
    write-grid-x
    write-grid-y
    write-dataset_
    write_ "</svg>\n"

  write-x-border -> none:
    write_ "<svg width=\"$v-width\" height=\"$x-border-h\">\n"
    write_"<text x=\"200\" y=\"20\" font-size=\"15\">$xLabel</text>\n"
    write_ "</svg>\n"
  
  write-grid-x -> none:
    loc := 0
    x-grid-cache = List x-layout.tick-num.to-int
    write-line 0 0 0 graph-h "style=\"stroke:rgb(0,0,0);stroke-width:1\"" // y axis
    for i := 0; i < x-layout.tick-num; i++:
      loc = x-grid-interval + i*x-grid-interval
      write-line loc 0 loc graph-h "vector-effect=\"non-scaling-stroke\" stroke=\"black\" stroke-dasharray=\"20,5\" stroke-opacity=\"0.5\""
      x-grid-cache[i] = loc

  write-grid-y -> none:
    loc := 0
    y-grid-cache = List y-layout.tick-num.to-int
    y-grid-interval = (v-height / y-layout.tick-num).floor
    write-line 0 graph-h graph-w graph-h "style=\"stroke:rgb(0,0,0);stroke-width:1\""  // x axis
    for i := 0; i < y-layout.tick-num; i++:
      loc = graph-h - (y-grid-interval + i*y-grid-interval)
      write-line 0 loc graph-w loc "vector-effect=\"non-scaling-stroke\" stroke=\"black\" stroke-dasharray=\"20,5\" stroke-opacity=\"0.5\""
      y-grid-cache[i] = loc
/*
  write-axes -> none:
    write_ "<g transform=\"translate(0, $height) scale(1, -1)\">\n"
    write-line pad bMargin (width - pad) bMargin  "style=\"stroke:rgb(0,0,0);stroke-width:1\""  // x axis
    write-line lMargin pad lMargin (height - pad) "style=\"stroke:rgb(0,0,0);stroke-width:1\"" // y axis
    write_ "</g>\n"

  write-labels -> none:
    // appendText((width/2), -30, xLabel, "style=\"stroke:rgb(0,0,0);stroke-width:1\"", t.toString());
    write-text (width/2) 0 xLabel "transform=\"translate(0, $height)\"" "style=\"stroke:rgb(0,0,0);stroke-width:1\""
    write-text 0 (height/2) yLabel "transform=\"rotate(90, 5, 30)\"" "style=\"stroke:rgb(0,0,0);stroke-width:1\""
    // appendText(30, height / 2, yLabel, "style=\"stroke:rgb(0,0,0);stroke-width:1\"", t.toString());

  write-x-grid -> none:
    write_ "<g class=\"xgrid\" transform=\"$dataset-transform\">\n"
    for i := (lMargin + xMin + 5); i < xMax; i = i + 5:
      write-line i yMin i yMax "vector-effect=\"non-scaling-stroke\" stroke=\"cyan\" stroke-dasharray=\"20,5\" stroke-opacity=\"0.5\""
    write_ "</g>\n"

  write-y-grid -> none:
    write_ "<g class=\"ygrid\" transform=\"dataset-transform\">\n"
    for i := (bMargin + yMin + 20); i < yMax; i = i + 20:
      write-line xMin i xMax i "vector-effect=\"non-scaling-stroke\" stroke=\"cyan\" stroke-dasharray=\"12,3\" stroke-opacity=\"0.5\""
    write_ "</g>\n"
*/
  /**
    * Appends a line description, in view coordinates, to the StrinbBuilder
    */
  write-line x1/num y1/num x2/num y2/num style/string -> none:
    write_ "<line x1=\"$x1\" y1=\"$y1\" x2=\"$x2\" y2=\"$y2\" $style />\n"

  write-text x/int y/int text/string transform/string style/string -> none:
    //      <text x="0" y="15" fill="red">I love SVG!</text>
    write_ "<text x=\"$x\" y=\"$y\" $transform $style>$text</text>\n"

  write-marker -> none:
    write_ "<g class=\"marker\" transform=\"$dataset-transform\">\n"
    write-line (marker.x - 1) marker.y (marker.x + 1) marker.y "vector-effect=\"non-scaling-stroke\" stroke=\"red\""
    write-line marker.x (marker.y - 5) marker.x (marker.y + 5) "vector-effect=\"non-scaling-stroke\" stroke=\"red\""
    write_ "</g>\n"


  abstract write-dataset_ -> none


class Marker:

  x /int?
  y /int?
  style /string?

  constructor .x .y .style:
