import math
import strformat


type Vertex = object
  x: int
  y: int
  z: int

proc newVertex(x, y, z: int): Vertex =
  Vertex(x: x, y: y, z: z)

proc newVertexFromSeq(s: seq[int]): Vertex =
  Vertex(x: s[0], y: s[1], z: s[2])

proc toSeq(v: Vertex): seq[int] =
  @[v.x, v.y, v.z]

proc distance(v1, v2: Vertex): float =
  let d = Vertex(x: v2.x - v1.x, y: v2.y - v1.y, z: v2.z - v1.z)
  math.sqrt(float(d.x*d.x + d.y*d.y + d.z*d.z))

proc slide(v: Vertex, x, y, z: int): Vertex =
  newVertex(v.x + x, v.y + y, v.z + z)

func rotateY(v: Vertex, Vertex, rot: float): Vertex =
  newVertex(
    int(math.cos(rot)*float(v.x) + math.sin(rot)*float(v.z)),
    v.y,
    int(-math.sin(rot)*float(v.x) + math.cos(rot)*float(v.z)),
  )
