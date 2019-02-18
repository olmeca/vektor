#!/bin/sh
# nim c -r doctypes/codegen.nim
MODULE=$1
nim c -r --out:out/${MODULE} "${MODULE}.nim"
