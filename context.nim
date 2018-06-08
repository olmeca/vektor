import strutils, sequtils, tables, logging
import "common", "doctypes", "utils"

type
   ContextState* = enum
      csInitial, csRegistered, csExported
   Context* = ref object
      parent*: Context
      state*: ContextState
      docType*: DocumentType
      lineType*: LineType
      line*: string
      subContexts*: OrderedTableRef[string, Context]
      currentSubContext*: Context

proc createSubContext*(parentContext: var Context, lineType: LineType, line: string): Context =
   result = Context(docType: parentContext.docType, parent: parentContext, state: csInitial, lineType: linetype, line: line, subContexts: newOrderedTable[string, Context](4), currentSubContext: nil)
   parentContext.subContexts[lineType.lineId] = result


proc createContext*(dType: DocumentType, lineType: LineType, line: string): Context =
   result = Context(docType: dType, parent: nil, state: csInitial, lineType: linetype, line: line, subContexts: newOrderedTable[string, Context](4), currentSubContext: nil)
   result.currentSubContext = result
   result.state = csRegistered



proc contextWithLineId*(context: Context, lineId: string): Context =
   assert(not isNil(lineId))
   debug( "contextWithLineId: ctx:$#, lid: $#" % [context.lineType.lineId, lineId])
   if context.lineType.lineId == lineId:
      result = context
   elif len(context.subContexts) == 0:
      raise newException(ContextWithLineIdNotFoundError, "No context found with line id $#" % [lineId])
   elif context.subContexts.hasKey(lineId):
      result = context.subContexts[lineId]
   else:
      for sub in context.subContexts.values:
         let found = contextWithLineId(sub, lineId)
         if not isNil(found):
            result = found
            break
         else: discard

proc getElementValueFullString*(rootContext: Context, lineElementId: string): string =
   let lineId = lineElementId[0..1]
   let context = rootContext.contextWithLineId(lineId)
   #debug("getElementValueFullString: rootctx: $#, leId: $#, subctx: $#" % 
   #      [rootContext.lineType.lineId, lineId, context.lineType.lineId])
   assert(context.line.startsWith(lineId))
   let leType = context.lineType.getLineElementType(lineElementId)
   getElementValueFormatted(context.line, leType)

proc getElementValueString*(context: Context, leId: string): string =
   stripBlanks(getElementValueFullString(context, leId))

proc isContentContext*(context: Context): bool =
   context.line.isContentLine()

proc dropContentSubContexts*(context: Context) =
   # Assuming for now that we do not need to recurse
   var delLineIds: seq[string] = @[]
   for key in context.subContexts.keys:
      if key.isContentLine():
         add(delLineIds,key)
   for lineId in delLineIds:
      debug("Deleting subcontext " & lineId)
      # Dunno if we need to null the parent reference
      var subcontext = context.subContexts[lineId]
      subcontext.parent = nil
      context.subContexts.del(lineId)

proc findParentContextForLineType*(context: Context, lineId: string): Context =
   result = nil
   if context.lineType.childLinks.anyIt(it.subLineId == lineId):
      result = context
   elif not isNil(context.parent):
      result = findParentContextForLineType(context.parent, lineId)
   else: discard
   if isNil(result):
        raise newException(ContextWithLineIdNotFoundError, "No context found supporting child record type $#" % lineId)

proc toString*(ctx: Context): string = 
   "Context[lt: $#]" % [ctx.lineType.lineId]

proc root*(context: Context): Context =
    if isNil(context.parent):
        context
    else:
        root(context.parent)

proc current*(context: Context): Context =
    context.currentSubContext

proc addLine*(context: var Context, line: string) =
    let lType = context.docType.getLineTypeForLine(line)
    let lineId = getLineId(line)
    var parentContext = findParentContextForLineType(context.currentSubContext, lineId)
    context.currentSubContext = createSubContext(parentContext, lType, line)
    context.currentSubContext.state = csRegistered
