// Copyright (C) 2024 Ekorau LLC. All rights reserved.
// Use of this source code is governed by an MIT-style license that can be
// found in the LICENSE file.

import .svg_graph show *

class SVGlinegraph extends SVGgraph:

  constructor writer:
    super writer

  write-dataset_ -> none:
    print "write dataset"

    /*
    //todo the chart grid lines should be added here, as they are in chart space
    createPolylines
    write_ "<g class=\"dataset\"\n"
    write_ " transform=\"$dataset-transform\">\n"
    ListIterator<Polyline> li = lines.listIterator();
      Polyline line;
      while(li.hasNext()){
          line = li.next();
          appendPolyline(line);
      }
      sb.append("</g>\n");
*/
/*
/**
Creates the polylines that will be used to draw the graph.
The polylines are created from the xyData array.
*/
void createPolylines() {

//        int[] points = {2015, 69250, 2016, 138434, 2017, 207645, 2018, 276980};
//        int[] points = {0, 0, 275, 150, 320, 400};
    for (int col=1; col<xyData[0].length; col++) {
        int[] points = new int[xyData.length * 2];
        for (int row = 0; row < xyData.length; row++) {
            points[2 * row] = (int) xyData[row][0];
            points[(2 * row) + 1] = (int) Math.round((double) xyData[row][col]);
        }
        addPolyline(points, plotStyles[col-1]);
    }
}
protected void appendPolyline(Polyline line) {

    sb.append("<polyline points=\"");
    for (int i = 0; i < line.points.length - 2; i = i + 2){
        sb.append(line.points[i]);
        sb.append(",");
        sb.append(line.points[i+1]);
        sb.append(", ");
    }
    sb.append(line.points[line.points.length - 2]);
    sb.append(",");
    sb.append(line.points[line.points.length - 1]);

    sb.append("\" ");
    sb.append(line.style);
    sb.append(" />\n");
}

class Polyline {

    int[] points;
    String style;
*/