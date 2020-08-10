import math
import strformat

import way

type Position* = object
  x*: int
  y*: int

proc `$`*(p: Position): string = fmt"Position({p.x}, {p.y})"

proc newPosition*(x:int=0, y:int=0): Position {.inline.} = Position(x:x, y:y)

proc clone*(p: Position): Position {.inline.} = newPosition(p.x, p.y)

proc `+`*(p1, p2: Position): Position {.inline.} = newPosition(p1.x + p2.x, p1.y + p2.y)
proc `-`*(p1, p2: Position): Position {.inline.} = newPosition(p1.x - p2.x, p1.y - p2.y)
proc `*`*(p1, p2: Position): Position {.inline.} = newPosition(p1.x * p2.x, p1.y * p2.y)

proc abs*(p: Position): Position = newPosition(abs(p.x), abs(p.y))

proc dot*(p, q: Position): float = float(p.x*q.x + p.y*q.y)

proc cross*(p, q: Position): float = float(p.x*q.y - p.y*q.x)

proc magnitude*(p: Position): float = sqrt(float(p.x*p.x + p.y*p.y))

proc angle*(a, b, c: Position): float =
  let ab = b - a
  let ac = c - a
  math.arccos(dot(ab, ac) / (magnitude(ab) * magnitude(ac)))

proc directedAngle*(a, b, c: Position): float =
  let ab = b - a
  let ac = c - a
  math.arctan2(cross(ab, ac), dot(ab, ac))

proc isInside*(p: Position, vx: seq[Position]): bool =
  var sum = 0.0
  for i, p1 in vx:
    let p2 = vx[(i+1) mod vx.len]
    sum += p.directedAngle(p1, p2)
  # If the sum of angles is about 2 * PI or more, it means encircled.
  let laps = sum / (2 * PI)
  laps >= 0.99 or laps <= -0.99

# way
proc rotate*(p: Position, w: Way): Position {.inline.} =
  let rt = float(w) * math.PI / 2.0
  Position(
    x: int(math.cos(rt))*p.x + int(math.sin(rt))*p.y,
    y: int(-math.sin(rt))*p.x + int(math.cos(rt))*p.y,
  )

proc slideMap*(w: Way): Position {.inline.} =
  case w:
  of Way.North: newPosition(x=0, y=0)
  of Way.West : newPosition(x=0, y=1)
  of Way.South: newPosition(x=1, y=1)
  of Way.East : newPosition(x=1, y=0)

proc rotateInBox*(p: Position, w, h: int, r: Way): Position =
  let size = Position(x: w, y: h).rotate(r).abs
  p.rotate(r) + ((size - newPosition(1, 1)) * slideMap(r))
