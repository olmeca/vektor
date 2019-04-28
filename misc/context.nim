import strutils, sequtils, tables, logging
import common, doctype, utils, lineparsing, serialization

proc createSubContext*(parentContext: var Context, lineType: LineType, line: string): Context =
   result = Context(docType: parentContext.docType, parent: parentContext, state: csInitial, lineType: linetype, line: line, subContexts: newOrderedTable[string, Context](4), currentSubContext: nil)
   parentContext.subContexts[lineType.lineId] = result


proc createContext*(dType: DocumentType, lineType: LineType, line: string): Context =
   result = Context(docType: dType, parent: nil, state: csInitial, lineType: linetype, line: line, subContexts: newOrderedTable[string, Context](4), currentSubContext: nil)
   result.currentSubContext = result
   result.state = csRegistered


proc `$`*(ctx: Context): string =
   "Context[lt: $#, ln: $#]" % [ctx.lineType.lineId, ctx.line[0..13]]


proc contextWithLineId*(context: Context, lineId: string): Context =
   assert(lineId != "")
   debug( "context.contextWithLineId: ctx:$#, lid: $#" % [context.lineType.lineId, lineId])
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
   debug("context.contextWithLineId -> $#" % $(result))


proc getElement*(leType: LineElementType, rootContext: Context): LineElement =
   debug("context.getElement: leType: $#, rootContext: $#" % [leType.asString(), $(rootContext)])
   let context = rootContext.contextWithLineId(leType.lineId)
   result = leType.parse(context.line)


proc getElementValue*(leType: LineElementType, rootContext: Context): VektisValue =
    getElement(leType, rootContext).value


proc getElementValue*(leId: string, rootContext: Context): VektisValue =
    let leType = rootContext.docType.getLineElementType(leId)
    getElementValue(leType, rootContext)

proc getElementValueFullString*(rootContext: Context, leType: LineElementType): string =
    getElement(leType, rootContext).serialize()


proc getSourceElementValueFullString*(rootContext: Context, leType: LineElementType): string =
   let sourceLeType = rootContext.doctype.getLineElementType(leType.sourceId)
   getElementValueFullString(rootContext, sourceLeType)


proc getElementValueString*(context: Context, leType: LineElementType): string =
   stripBlanks(getElementValueFullString(context, leType))


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

proc root*(context: Context): Context =
    if isNil(context.parent):
        context
    else:
        root(context.parent)

proc current*(context: Context): Context =
    context.currentSubContext

proc addLine*(context: var Context, line: string) =
    debug("context.addLine: ctx: $#, line: '$#'" % [$(context), line[0..13]])
    let lType = context.docType.getLineTypeForLine(line)
    let lineId = getLineId(line)
    var parentContext = findParentContextForLineType(context.currentSubContext, lineId)
    context.currentSubContext = createSubContext(parentContext, lType, line)
    context.currentSubContext.state = csRegistered
