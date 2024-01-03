// Copyright (C) 2024 Ekorau LLC. All rights reserved.
// Use of this source code is governed by an MIT-style license that can be
// found in the LICENSE file.

import math show log pow

class GraphLayout:
  min-val := 0.0
  max-val := 0.0
  tick-max := 10
  tick-spacing := 0.0
  min-nice := 0.0
  max-nice := 0.0

  constructor .min-val/num .max-val/num .tick-max=10:
    calculate

  constructor.range nums/List .tick-max=10:
    min-val = nums[0]
    max-val = nums[1]
    calculate

  calculate:
    range := nice_number (max-val - min-val) false
    tick-spacing = nice_number range / (tick-max - 1) true
    min-nice = (min-val / tick-spacing).floor * tick-spacing
    max-nice = (max-val / tick-spacing).ceil * tick-spacing

  nice_number range/num round/bool:
    exponent := (log range 10).floor
    fraction := range / (pow 10.0 exponent)
    nice_fraction := 0.0

    if round:
      if fraction <= 1.0: nice_fraction = 1.0
      else if fraction <= 2.0: nice_fraction = 2.0
      else if fraction <= 5.0: nice_fraction = 5.0
      else: nice_fraction = 10.0
    else:
      if fraction <= 1.0: nice_fraction = 1.0
      else if fraction <= 1.5: nice_fraction = 1.5
      else if fraction <= 3.0: nice_fraction = 2.0
      else if fraction <= 7.0: nice_fraction = 5.0
      else: nice_fraction = 10.0

    return nice_fraction * (pow 10.0 exponent)

  tick-num: return (max-nice - min-nice) / tick-spacing