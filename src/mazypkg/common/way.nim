type Way* {.pure.} = enum
  North
  West
  South
  East

const WayMax: int = Way.high.int + 1

proc `+`*(w1: Way, w2: int): Way {.inline.} =
  Way((w1.int + w2 + WayMax) mod WayMax)

proc `+`*(w1: Way, w2: Way): Way {.inline.} =
  Way((w1.int + w2.int + WayMax) mod WayMax)

proc `-`*(w1: Way, w2: Way): Way {.inline.} =
  Way((w1.int - w2.int + WayMax) mod WayMax)

proc reverse*(w: Way): Way {.inline.} =
  (WayMax - w.int).Way
