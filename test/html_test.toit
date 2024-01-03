// Copyright (C) 2024 Ekorau LLC. All rights reserved.
// Use of this source code is governed by an MIT-style license that can be
// found in the LICENSE file.

import .graph-layout
import math

estimator := GraphLayout 17 87

main:

  testMathFloor
  testAxesCalculation

  testEstimatorOnRangeNearZero
  testEstimatorOnRangeZero
  testEstimatorOnRangeOne
  testEstimatorOnRangeTwo
  testEstimatorOnRangeNine
  testEstimatorOnRangeTen
  testEstimatorOnRangeEleven

  testEstimatorOnRangeWithNegs
/*
  testGraphNoData
  testGraphOneYear
  testGraphRange
  testGraphGrid
*/
//  testSamplePro
/*  
    void testSamplePro() {

        writeToFile(broker.mUIReporter.getNetWortReport(), broker.getSimulation().getName"
    }
*/

testAxesCalculation -> none:
  print "// ----- testAxesCalculation -----"
  print "Tick Spacing: $estimator.tick-spacing"
  print "Nice Minimum: $estimator.min-nice"
  print "Nice Maximum: $estimator.max-nice"
  print "Num ticks: $estimator.tick-num"

testMathFloor -> none:
  print "// ----- testMathFloor -----"
  print (340/6.0).floor


testEstimatorOnRangeWithNegs -> none:
  print "// ----- testEstimatorOnRangeWithNegs -----"
  estimator = GraphLayout -30 10
  print "Tick Spacing: $estimator.tick-spacing"
  print "Nice Minimum: $estimator.min-nice"
  print "Nice Maximum: $estimator.max-nice"
  print "Num ticks: $estimator.tick-num"

testEstimatorOnRangeNearZero -> none:
  print "// ----- testEstimatorOnRangeNearZero -----"
  a := 0.0000027
  b := 0.000045
  estimator = GraphLayout a b
  print "Nice number, false: $(estimator.nice-number (b - a) false)"
  print "Tick Spacing: $estimator.tick-spacing"
  print "Nice Minimum: $estimator.min-nice"
  print "Nice Maximum: $estimator.max-nice"
  print "Num ticks: $estimator.tick-num"


testEstimatorOnRangeZero -> none:
  print "// ----- testEstimatorOnRangeZero -----"
  estimator = GraphLayout 0.000045 0.0000027
  print "Tick Spacing: $estimator.tick-spacing"
  print "Nice Minimum: $estimator.min-nice"
  print "Nice Maximum: $estimator.max-nice"
  print "Num ticks: $estimator.tick-num"
    
testEstimatorOnRangeOne -> none:
  print "// ----- testEstimatorOnRangeOne -----"
  estimator = GraphLayout 0 1
  print "Tick Spacing: $estimator.tick-spacing"
  print "Nice Minimum: $estimator.min-nice"
  print "Nice Maximum: $estimator.max-nice"
  print "Num ticks: $estimator.tick-num"

testEstimatorOnRangeTwo -> none:
  print "// ----- testEstimatorOnRangeTwo -----"
  estimator = GraphLayout 0 2
  print "Tick Spacing: $estimator.tick-spacing"
  print "Nice Minimum: $estimator.min-nice"
  print "Nice Maximum: $estimator.max-nice"
  print "Num ticks: $estimator.tick-num"

testEstimatorOnRangeNine -> none:
  print "// ----- testEstimatorOnRangeNine -----"
  estimator = GraphLayout 0 9
  print "Tick Spacing: $estimator.tick-spacing"
  print "Nice Minimum: $estimator.min-nice"
  print "Nice Maximum: $estimator.max-nice"
  print "Num ticks: $estimator.tick-num"

testEstimatorOnRangeTen -> none:
  print "// ----- testEstimatorOnRangeTen -----"
  estimator = GraphLayout 0 10
  print "Tick Spacing: $estimator.tick-spacing"
  print "Nice Minimum: $estimator.min-nice"
  print "Nice Maximum: $estimator.max-nice"
  print "Num ticks: $estimator.tick-num"

testEstimatorOnRangeEleven -> none:
  print "// ----- testEstimatorOnRangeEleven -----"
  estimator = GraphLayout 0 11.0
  print "Tick Spacing: $estimator.tick-spacing"
  print "Nice Minimum: $estimator.min-nice"
  print "Nice Maximum: $estimator.max-nice"
  print "Num ticks: $estimator.tick-num"

/*
 void testGraphNoData() {

        HTMLpage page = new HTMLpage
        page.writeHeader("testGraphNoData");
        Number[][] data = null;
        String[] legend = {"tiny", "positive", "negative"};
        page.writeSVGlinegraph(300, 400, "(Year)", "($)", data, legend);
        page.writeFooter
        writeToFile(page.toString(), "testGraphNoData");
    }
    void testGraphOneYear() {

        HTMLpage page = new HTMLpage
        page.writeHeader("testGraphOneYear");
        Number[][] data = {{2017, 50., -500., -1000.}, {2018, -50., 500., 2000.}};
        String[] legend = {"tiny", "positive", "negative"};
        page.writeSVGlinegraph(300, 400, "(Year)", "($)", data, legend);
        page.writeFooter
        writeToFile(page.toString(), "testGraphOneYear");
    }
    void testGraphRange() {

        HTMLpage page = new HTMLpage
        page.writeHeader("testGraphRange");
        Number[][] data = {{2017, 50., -500., -1000.}, {2018, -50., 500., 2000.}, {2019, 50., 1500., -4500.}};
        String[] legend = {"tiny", "positive", "negative"};
        page.writeSVGlinegraph(300, 400, "(Year)", "($)", data, legend);
        page.writeFooter
        writeToFile(page.toString(), "testGraphRange");
    }
    void testGraphGrid() {

        HTMLpage page = new HTMLpage
        page.writeHeader("testGraphGrid");
        Number[][] data = {{0, -5., -10., -2.}, {5, 0., 0., 0.}, {10, 5., 10., 2.}};
        String[] legend = {"tiny", "positive", "negative"};
        page.writeSVGlinegraph(300, 400, "(Year)", "($)", data, legend);
        page.writeFooter
        writeToFile(page.toString(), "testGraphGrid");
    }
    void writeToFile(String aStr, String aFile) {

        BufferedWriter bw = null;
        FileWriter fw = null;

        try {

            String content = "This is the content to write into file\n";

            fw = new FileWriter("/home/david/temp/" + aFile + ".html");
            bw = new BufferedWriter(fw);
            bw.write(aStr);

            print "Done");

        } catch (IOException e) {
            e.printStackTrace
        } finally {
            try {
                if (bw != null) bw.close
                if (fw != null) fw.close
            } catch (IOException ex) {ex.printStackTrace}
        }
    }
}
*/