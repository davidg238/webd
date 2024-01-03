// Copyright (C) 2024 Ekorau LLC. All rights reserved.
// Use of this source code is governed by an MIT-style license that can be
// found in the LICENSE file.

import .graph_layout
import math show *

main:

    estimator := GraphLayout 2017 2072

    print "Input min,max: 2017, 2072 ..."
    print "Nice num for 13,700,000 round: $(estimator.nice-number 13700000.0 true)"
    print "Tick Spacing: $estimator.tick-spacing"
    print "Nice Minimum: $estimator.min-nice"
    print "Nice Maximum: $estimator.max-nice"
    print "Num ticks: $estimator.num-ticks"

