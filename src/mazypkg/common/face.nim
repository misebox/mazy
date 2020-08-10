import position, way
import strformat

type
  FaceType* {.pure.} = enum
    None
    Wall
    Door
    FaceTypeMax

proc `[]`*(sf: seq[FaceType], w: Way): FaceType =
  sf[w.int]

proc `[]=`*(sf: var seq[FaceType], w: Way, ft: FaceType) =
  sf[w.int] = ft

type
  Face* = object
    x*, y*: int
    way*: Way

proc `+`*(f1, f2: Face): Face =
  Face(x: f1.x + f2.x, y: f1.y + f2.y, way: f1.way + f2.way)
  
proc toPosition*(f: Face): Position =
  newPosition(f.x, f.y)

proc setPosition*(f: var Face, p: Position) =
  f.x = p.x
  f.y = p.y

proc `$`*(f: var Face): string =
  fmt"Face(x: {f.x}, y: {f.y}, way: {f.way})"

proc rotate*(f: Face, w: Way): Face =
  let p = f.toPosition().rotate(w)
  Face(x: p.x, y: p.y, way: f.way + w)
