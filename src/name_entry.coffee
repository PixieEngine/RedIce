NameEntry = (I) ->
  $.reverseMerge I,
    backgroundColor: "rgba(0, 255, 255, 0.5)"
    characterSet: "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789 _-.!?♦♥♣♠★¤$¥£€®™".split("")
    cellWidth: 20
    cellHeight: 20
    textColor: "#FFF"
    cols: 8
    cursorColor: "rgba(0, 255, 0, 0.5)"
    cursor:
      x: 0
      y: 0
      menu: false
    font: "bold 14px 'Monaco', 'Inconsolata', 'consolas', 'Courier New', 'andale mono', 'lucida console', 'monospace'"
    name: ""
    maxLength: 8
    controller: null

  lineHeight = 11
  verticalPadding = 4
  horizontalPadding = 6
  margin = 6

  controller = engine.controller(I.controller) if I.controller?

  cols = ->
    I.cols

  rows = ->
    (I.characterSet.length / I.cols).ceil()
    
  width = ->
    cols() * I.cellWidth
    
  textAreaHeight = ->
    I.cellHeight * rows()
    
  move = (delta) ->
    I.cursor.x = (I.cursor.x + delta.x).mod(cols())
    
    newY = I.cursor.y + delta.y
    if I.cursor.menu && newY
      I.cursor.menu = false
      
      if newY > 0
        newY = 0

      I.cursor.y = newY.mod(rows())
    else if (newY == -1) || (newY == rows())
      I.cursor.menu = true
      I.cursor.y = 0
    else
      I.cursor.y = newY.mod(rows())
      
    # Horrible and terrifying hacks to skip blanks in partial rows
    if !I.cursor.menu && characterAtCursor() == undefined
      if delta.x > 0
        I.cursor.x = (I.cursor.x + 1) % rows() while characterAtCursor() == undefined
      else
        I.cursor.x = (I.cursor.x - 1) % rows() while characterAtCursor() == undefined
    
  characterAtCursor = ->
    I.characterSet[I.cursor.x + I.cursor.y * I.cols]
    
  addCharacter = ->
    if I.cursor.menu
      self.trigger "done", I.name
    else
      if I.name.length < I.maxLength
        I.name += characterAtCursor()
        
      # Jump to 'done' menu when name is full
      if I.name.length == I.maxLength
        I.cursor.menu = true
        I.cursor.y = 0
        I.cursor.x = 0

  nameArea =
    draw: (canvas) ->
      cursorWidth = 10
      cursorHeight = 2
      
      nameAreaWidth = canvas.measureText(["M"].wrap(0, I.maxLength).join("")) + 2 * horizontalPadding

      canvas.withTransform Matrix.translation(this.x, this.y), ->
        canvas.fillColor(I.backgroundColor)
        canvas.fillRoundRect(0, 0, nameAreaWidth, I.cellHeight)
        
        canvas.fillColor(I.textColor)
        canvas.fillText(I.name, horizontalPadding, lineHeight + verticalPadding)
        
        if (I.age / 20).floor() % 2
          canvas.fillColor(I.cursorColor)
          if I.name.length == I.maxLength
            nameWidth = canvas.measureText(I.name.substring(0, I.name.length - 1))
          else
            nameWidth = canvas.measureText(I.name)
          
          canvas.fillRect(nameWidth + horizontalPadding, verticalPadding + lineHeight, cursorWidth, cursorHeight)

    x: 0
    y: 0
    
  textArea =
    draw: (canvas) ->
      canvas.withTransform Matrix.translation(this.x, this.y), ->
        canvas.fillColor(I.backgroundColor)
        canvas.fillRoundRect(0, 0, width(), textAreaHeight())
      
        canvas.fillColor(I.textColor)
  
        row = 0
        I.characterSet.each (c, i) ->
          col = i % I.cols
          row = (i / I.cols).floor()
          canvas.fillText(c, col * I.cellWidth + horizontalPadding, row * I.cellHeight + lineHeight + verticalPadding)
        
        row += 1
        
        unless I.cursor.menu
          canvas.fillColor(I.cursorColor)
          canvas.fillRoundRect(I.cursor.x * I.cellWidth, I.cursor.y * I.cellHeight, I.cellWidth, I.cellHeight)

    x: 0
    y: I.cellHeight + margin
    
  menuArea =
    draw: (canvas) ->
      canvas.withTransform Matrix.translation(this.x, this.y), ->
        option = "Done"
        optionWidth = canvas.measureText(option)
        
        canvas.fillColor(I.textColor)
        canvas.fillText(option, horizontalPadding, lineHeight + verticalPadding)
        
        if I.cursor.menu
          canvas.fillColor(I.cursorColor)
          canvas.fillRoundRect(0, 0,optionWidth + 2 * horizontalPadding, I.cellHeight)
          
    x: 0
    y: I.cellHeight * (rows() + 1) + 2 * margin

  self = GameObject(I).extend
    draw: (canvas) ->
      canvas.withTransform self.transform(), (canvas) ->
        canvas.font(I.font)
        nameArea.draw(canvas)
        textArea.draw(canvas)
        menuArea.draw(canvas)

  controller?.bind "tap", (direction) ->
    move(direction)

  self.bind "step", ->
    if justPressed.left
      move(Point(-1, 0))
    if justPressed.right
      move(Point(1, 0))
    if justPressed.up
      move(Point(0, -1))
    if justPressed.down
      move(Point(0, 1))
      
    if justPressed.return
      addCharacter()
      
    if justPressed.backspace
      I.name = I.name.substring(0, I.name.length - 1)
      
    if controller?.buttonPressed "A"
      addCharacter()

    if controller?.buttonPressed "B"
      I.name = I.name.substring(0, I.name.length - 1)

  return self

