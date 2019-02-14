import os, parseopt, strutils, sequtils, json, sugar, streams, random, pegs, times, tables, logging

const
   cBlanksSet*: set[char] = { ' ' }


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

proc stripBlanks*(source: string): string =
   strip(source, true, true, cBlanksSet)

proc copyChars*(buf: var openArray[char], start: int, length: int, newValue: string) =
   assert newValue.len == length
   let newValueSeq = toSeq(newValue.items)
   # Nim range is inclusive
   for i in 0..(length-1):
      buf[start+i] = newValueSeq[i]

proc id*(intValue: int): string =
    intToStr(intValue, 2)

proc leTypeId*(recTypeIndex: int, leTypeIndex: int): string =
    result = "$#$#" % [id(recTypeIndex), id(leTypeIndex)]
