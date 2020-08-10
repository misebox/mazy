# Package

version       = "0.1.0"
author        = "misebox"
description   = "A text based pseudo-3D rendering engine"
license       = "MIT"
srcDir        = "src"
installExt    = @["nim"]
bin           = @["mazy"]



# Dependencies

requires "nim >= 1.2.0"
requires "https://github.com/dom96/nimbox"
