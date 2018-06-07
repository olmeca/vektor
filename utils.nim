import os, parseopt2, strutils, sequtils, json, future, streams, random, pegs, times, tables, logging


proc padright*(source: string, length: int, fillChar: char = ' '): string =
   if source.len > length:
      source.substr(0, length-1)
   else:
      source & repeat(fillChar, length - source.len)

proc writeCharsToStream*(buf: seq[char], stream: Stream) =
   for c in buf:
      stream.write(c)
   stream.write('\r')
   stream.write('\l')

proc mytrim*(value: string, length: int): string =
   result = if value.len > length: value[0..length-1] else: value

