import strutils

type
  Formatter* = object {.inheritable.}
  LeftAlign* = object of Formatter
    width: Natural
  RightAlign* = object of Formatter
    width: Natural
  ExtendedRightAlign* = object of Formatter
    width, precision: Natural
  ExtendedLeftAlign* = object of Formatter
    width, precision: Natural

proc padRight(s: string, width: Natural): string =
  if width > len(s):
    result = s & repeat(' ', width - len(s))
  else:
    result = s

proc padLeft(s: string, width: Natural): string =
  if width > len(s):
    result = repeat(' ', width - len(s)) & s
  else:
    result = s

proc format*(f: LeftAlign, x: string): string =
  padRight(x, f.width)

proc format*(f: LeftAlign, x: SomeInteger): string =
  padRight($x, f.width)

proc format*(f: LeftAlign, x: SomeFloat): string =
  padRight(formatFloat(x, ffDecimal, 2), f.width)

proc format*(f: RightAlign, x: string): string =
  padLeft(x, f.width)

proc format*(f: RightAlign, x: SomeInteger): string =
  padLeft($x, f.width)

proc format*(f: RightAlign, x: SomeFloat): string =
  padLeft(formatFloat(x, ffDecimal, 2), f.width)

proc format*(f: ExtendedRightAlign, x: SomeFloat): string =
  padLeft(formatFloat(x, ffDecimal, f.precision), f.width)

proc format*(f: ExtendedLeftAlign, x: SomeFloat): string =
  padRight(formatFloat(x, ffDecimal, f.precision), f.width)

template `|`*(x: string|SomeInteger|SomeFloat, f: Formatter): string =
  f.format(x)

proc L*(w: Natural): LeftAlign =
  LeftAlign(width: w)
proc R*(w: Natural): RightAlign =
  RightAlign(width: w)
proc L*(w, p: Natural): ExtendedLeftAlign =
  ExtendedLeftAlign(width: w, precision: p)
proc R*(w, p: Natural): ExtendedRightAlign =
  ExtendedRightAlign(width: w, precision: p)
