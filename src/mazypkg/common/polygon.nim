import unicode
import vertex


# Polygon
type Polygon = object
  vertices  : seq[Vertex]
  fill      : bool
  fillLetter: Rune
  border    : bool
  core      : Vertex
  priority  : int

proc newPolygon(vt: seq[Vertex]): Polygon =
  # Calculate core position
  var a = newVertex(0, 0, 0)
  if vt.len > 0:
    for v in vt:
      a.x += v.x
      a.y += v.y
      a.z += v.z
    a.x = a.x div len(vt)
    a.y = a.y div len(vt)
    a.z = a.z div len(vt)

  var p = newPolygon(vt)
  p.border = true
  p.core = a
  p

proc newBoxPolygon(v1, v3: Vertex): Polygon =
  var s = seq[seq[int]]
  s.add(v1.slice)
  s.add(v1.slice)
  s.add(v3.slice)
  s.add(v1.slice)
  var k = 0
  for j in 0..<3:
    if s[0][j] == s[2][j]:
      k = j
  let a, b: int = (k+1) mod 3, (k+2) mod 3
  s[1][a] = s[2][a]
  s[3][b] = s[2][b]
  let v: seq[Vertex] = @[v1, newVertexFromSeq(s[1]), v3, newVertexFromSeq(s[3])]
  newPolygon(v)


# PolygonMesh
type PolygonMesh = object
  polygons: seq[Polygon]


proc add(m: var PolygonMesh, p: Polygon) {
  m.polygons.add(p)
}
proc newPolygonMesh(): PolygonMesh =
  PolygonMesh(polygons: @[])

proc newCubePolygonMesh(v1, v2: Vertex, fill: bool, letter: Rune): PolygonMesh =
  var m = newPolygonMesh()
  var sl = @[v1.toSeq, v2.toSeq]
  var ptn1 = @[0, 1, 1, 0]
  var ptn2 = @[0, 0, 1, 1]
  for s in sl:
    for j in 0..<3:
      a, b := (j+1) mod 3, (j+2) mod 3
      var verts = seq[Vertex]
      for k in 0..<4:
        var f = @[s[0], s[1], s[2]]
        f[a] = sl[ ptn1[k] ][a]
        f[b] = sl[ ptn2[k] ][b]
        verts.add(newVertexFromSeq(f))
      var p = newPolygon(verts)
      p.fill = fill
      p.fillLetter = letter
      m.add(p)
  m

proc rotateY(m: PolygonMesh, rot float64) *PolygonMesh {
  var nm = newPolygonMesh()
  for p in m.polygons:
    var vertices: seq[Vertex]
    for v in p.vertices:
      let nv = v.rotateY(rot)
      vertices.add(nv)
    var np = newPolygon(vertices)
    np.border = p.border
    np.fill = p.fill
    np.fillLetter = p.fillLetter
    np.priority = p.priority
    nm.polygons.add(np)
  nm
