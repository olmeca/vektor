import strutils, sequtils, tables, logging
import "common", "doctypes"

type
   ContextState* = enum
      csInitial, csRegistered, csExported
   Context* = ref object
      parent*: Context
      state*: ContextState
      lineType*: LineType
      line*: string
      subContexts*: OrderedTableRef[string, Context]

proc createContext*(lineType: LineType, line: string, parentContext: var Context): Context =
   result = Context(parent: parentContext, state: csInitial, lineType: linetype, line: line, subContexts: newOrderedTable[string, Context](4))
   if not isNil(parentContext):
      parentContext.subContexts[lineType.lineId] = result

proc createContext*(lineType: LineType, line: string): Context =
   result = Context(parent: nil, state: csInitial, lineType: linetype, line: line, subContexts: newOrderedTable[string, Context](4))



proc contextWithLineId*(context: Context, lineId: string): Context =
   assert(not isNil(lineId))
   debug( "contextWithLineId: ctx:$#, lid: $#" % [context.lineType.lineId, lineId])
   if context.lineType.lineId == lineId:
      result = context
   elif len(context.subContexts) == 0:
      raise newException(NotFoundError, "No context found with line id $#" % [lineId])
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
   if context.lineType.subLineTypeIds.contains(lineId):
      result = context
   elif not isNil(context.parent):
      result = findParentContextForLineType(context.parent, lineId)
   else: discard

proc toString*(ctx: Context): string = 
   "Context[lt: $#]" % [ctx.lineType.lineId]

