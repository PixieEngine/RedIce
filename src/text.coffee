DialogBox = (I={}) ->
  Object.reverseMerge I,
    backgroundColor: "#000"
    blinkRate: 15
    cursor: false
    cursorWidth: 10
    displayChars: 0
    font: "30px 'Iceland'"
    height: App.height/3
    lineHeight: 30
    paddingX: 24
    paddingY: 24
    text: ""
    textColor: "#FFC"
    width: App.width + 200
    x: 0
    y: 0

  I.textWidth = I.width - 2 * (I.paddingX)
  I.textHeight = I.height - 2 * (I.paddingY)

  computedLines = null

  self = GameObject(I).extend
    complete: ->
      I.displayChars >= I.text.length - 1

    flush: ->
      I.displayChars = I.text.length

  precomputeLines = ->
    unless computedLines
      words = I.text.split(/\s/)
      canvas = $("<canvas>").pixieCanvas()
      canvas.font I.font

      computedLines = []
      line = ""

      words.each (word) ->
        proposedLine = "#{line}#{word} "

        if line.length is 0 or canvas.measureText(proposedLine) <= I.textWidth
          line = proposedLine
        else
          computedLines.push line
          line = "#{word} "

      computedLines.push line

  self.bind 'update', ->
    precomputeLines()

    I.displayChars += 1

  self.unbind 'draw'
  self.bind 'draw', (canvas) ->
    precomputeLines()

    canvas.font I.font

    textStart = Point(I.paddingX, I.paddingY + I.lineHeight)

    canvas.fillColor I.backgroundColor
    canvas.drawRect 0, 0, I.width, I.height

    canvas.fillColor I.textColor

    charsRemaining = I.displayChars

    computedLines.each (text, line) ->
      if text.length <= charsRemaining
        displayText = text
      else
        displayText = text.substring(0, charsRemaining)

      canvas.drawText
        text: displayText
        x: textStart.x
        y: textStart.y + line * I.lineHeight

      charsRemaining -= text.length

  return self
