import sequtils
import way, face, position


# Event
type
  Event* = object

# FieldCell
type
  FieldCell* = object
    faces*: seq[FaceType]
    events*: seq[Event]
  PFieldCell* = ref FieldCell

proc newFieldCell*(): FieldCell =
  FieldCell(faces: FaceType.None.repeat(4), events: newSeq[Event]())

proc clone*(c: FieldCell): FieldCell =
  var a = newFieldCell()
  a.faces = c.faces
  a

# Field
type
  Field* = object
    cells*: seq[seq[FieldCell]]
    width*, height*: int

proc newField*(w, h: int): Field =
  var cells: seq[seq[FieldCell]] = @[]
  for y in 0 ..< h:
    var row: seq[FieldCell] = @[]
    for x in 0 ..< w:
      var c = newFieldCell()
      row.add(c)
    cells.add(row)
  Field(cells: cells, width: w, height: h)

proc hasCell*(f: Field, x, y: int): bool =
  0 <= x and x < f.width and 0 <= y and y < f.height

proc setFace*(f: var Field, x, y: int, w: Way, ft: FaceType) =
  f.cells[y][x].faces[w.ord] = ft

proc setFaceReversible*(f: var Field, x, y: int, w: Way, ft: FaceType) =
  f.setFace(x, y, w, ft)
  let d = newPosition(0, -1).rotate(w)
  let r = newPosition(x, y) + d
  f.setFace(r.x, r.y, w + 2, ft)

proc rotate*(f: Field, rw: Way): Field =
  let size = newPosition(f.width, f.height).rotate(rw).abs
  var nf = newField(size.x, size.y)
  for y in 0..<f.height:
    for x in 0..<f.width:
      let np = newPosition(x, y).rotateInBox(f.width, f.height, rw)
      let c = f.cells[y][x]
      var nc = newFieldCell()
      for w in Way.low..Way.high:
        nc.faces[(w + rw).int] = c.faces[w.int]
      nc.events = c.events
      nf.cells[np.y][np.x] = nc
  nf
