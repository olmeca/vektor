#!/bin/sh
# nim c -r doctypes/codegen.nim
MODULE=$1
nim c --out:out/${MODULE} "${MODULE}.nim"
