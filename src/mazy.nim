import mazypkg/submodule

import unicode
import random, strutils, sequtils, algorithm, times, os
import strformat
import nimbox

type
  GameState {.pure.} = enum playing pause over

  Screen = object
    buffer: seq[seq[Rune]]
    w: int
    h: int

  Game = object
    nb: Nimbox
    msec: int
    score: int
    state: GameState
    buffer: Screen

# globals
var ch: char

# ScreenBuffer
proc newScreen(w: int, h: int): Screen =
  var buf: seq[seq[Rune]] = newSeqWith(h, newSeq[Rune](w))
  Screen(w: w, h: h, buffer: buf)

# Game
proc newGame(): Game =
  randomize()
  Game(nb: newNimbox())

proc display(g: var Game) =
  g.nb.clear()
  let tbw = tbWidth()
  let sx = 20
  g.nb.print(sx, 0, "mazy")
  if g.state == GameState.pause:
    g.nb.print(sx, 1, "-- PAUSE --")
    g.nb.print(sx, 2, "[Hit P key]")
  elif g.state == GameState.over:
    g.nb.print(sx, 1, "-GAME OVER-")
    g.nb.print(sx, 2, "[Hit ENTER]")
  g.nb.print(sx, 3, fmt"[{ch}]")



  g.nb.present()
  sleep(10)

proc pause(g: var Game) =
  if g.state == GameState.playing: g.state = GameState.pause
  elif g.state == GameState.pause: g.state = GameState.playing

proc gameover(g: var Game) =
  g.state = GameState.over

proc initialize(g: var Game) =
  g.msec = 0
  g.score = 0
  g.state = GameState.playing

proc `=destroy`*(g: var Game) =
  g.nb.shutdown()

proc main() =
  var g = newGame()
  defer: g.nb.shutdown()

  g.initialize()

  var evt: Event
  var t = epochTime()

  while true:
    evt = g.nb.peekEvent(1000)
    case evt.kind:
      of EventType.Key:
        if evt.sym == Symbol.Escape: break
        elif evt.sym == Symbol.Enter and g.state == GameState.over:
          g.initialize()
        case evt.ch:
          of 'd': discard
          of 'f': discard
          of 'j': discard
          of 'k': discard
          of 'h': discard
          of 'l': discard
          of 'p': g.pause()
          else: discard
        ch = evt.ch
      else: discard

    if g.state == GameState.playing:
      let now = epochTime()
      t = now
    g.display()

when isMainModule:
  main()

