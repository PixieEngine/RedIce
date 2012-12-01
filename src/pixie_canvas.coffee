( ($) ->
  $.fn.pixieCanvas = (options) ->
    options ||= {}

    canvas = this.get(0)
    context = undefined

    ###*
    PixieCanvas provides a convenient wrapper for working with Context2d.

    Methods try to be as flexible as possible as to what arguments they take.

    Non-getter methods return `this` for method chaining.

    @name PixieCanvas
    @constructor
    ###
    $canvas = $(canvas).extend
      ###*
      Passes this canvas to the block with the given matrix transformation
      applied. All drawing methods called within the block will draw
      into the canvas with the transformation applied. The transformation
      is removed at the end of the block, even if the block throws an error.

      @name withTransform
      @methodOf PixieCanvas#

      @param {Matrix} matrix
      @param {Function} block

      @returns {PixieCanvas} this
      ###
      withTransform: (matrix, block) ->
        context.save()

        context.transform(
          matrix.a,
          matrix.b,
          matrix.c,
          matrix.d,
          matrix.tx,
          matrix.ty
        )

        try
          block(@)
        finally
          context.restore()

        return @

      ###*
      Clear the canvas (or a portion of it).

      Clear the entire canvas

      <code><pre>
      canvas.clear()
      </pre></code>

      Clear a portion of the canvas

      <code class="run"><pre>
      # Set up: Fill canvas with blue
      canvas.fill("blue")

      # Clear a portion of the canvas
      canvas.clear
        x: 50
        y: 50
        width: 50
        height: 50
      </pre></code>

      You can also clear the canvas by passing x, y, width height as
      unnamed parameters:

      <code><pre>
      canvas.clear(25, 25, 50, 50)
      </pre></code>

      @name clear
      @methodOf PixieCanvas#

      @param {Number} [x] where to start clearing on the x axis
      @param {Number} [y] where to start clearing on the y axis
      @param {Number} [width] width of area to clear
      @param {Number} [height] height of area to clear

      @returns {PixieCanvas} this
      ###
      clear: (x={}, y, width, height) ->
        unless y?
          {x, y, width, height} = x

        x ||= 0
        y ||= 0
        width = canvas.width unless width?
        height = canvas.height unless height?

        context.clearRect(x, y, width, height)

        return @

      ###*
      Fills the entire canvas (or a specified section of it) with
      the given color.

      <code class="run"><pre>
      # Paint the town (entire canvas) red
      canvas.fill "red"

      # Fill a section of the canvas white (#FFF)
      canvas.fill
        x: 50
        y: 50
        width: 50
        height: 50
        color: "#FFF"
      </pre></code>

      @name fill
      @methodOf PixieCanvas#

      @param {Number} [x=0] Optional x position to fill from
      @param {Number} [y=0] Optional y position to fill from
      @param {Number} [width=canvas.width] Optional width of area to fill
      @param {Number} [height=canvas.height] Optional height of area to fill
      @param {Bounds} [bounds] bounds object to fill
      @param {String|Color} [color] color of area to fill

      @returns {PixieCanvas} this
      ###
      fill: (color={}) ->
        unless color.isString?() || color.channels
          {x, y, width, height, bounds, color} = color

        {x, y, width, height} = bounds if bounds

        x ||= 0
        y ||= 0
        width = canvas.width unless width?
        height = canvas.height unless height?

        @fillColor(color)
        context.fillRect(x, y, width, height)

        return @

      ###*
      A direct map to the Context2d draw image. `GameObject`s
      that implement drawable will have this wrapped up nicely,
      so there is a good chance that you will not have to deal with
      it directly.

      @name drawImage
      @methodOf PixieCanvas#

      @param image
      @param {Number} sx
      @param {Number} sy
      @param {Number} sWidth
      @param {Number} sHeight
      @param {Number} dx
      @param {Number} dy
      @param {Number} dWidth
      @param {Number} dHeight

      @returns {PixieCanvas} this
      ###
      drawImage: (image, sx, sy, sWidth, sHeight, dx, dy, dWidth, dHeight) ->
        context.drawImage(image, sx, sy, sWidth, sHeight, dx, dy, dWidth, dHeight)

        return @

      ###*
      Draws a circle at the specified position with the specified
      radius and color.

      <code class="run"><pre>
      # Draw a large orange circle
      canvas.drawCircle
        radius: 30
        position: Point(100, 75)
        color: "orange"

      # Draw a blue circle with radius 10 at (25, 50)
      # and a red stroke
      canvas.drawCircle
        x: 25
        y: 50
        radius: 10
        color: "blue"
        stroke:
          color: "red"
          width: 1

      # Create a circle object to set up the next examples
      circle =
        radius: 20
        x: 50
        y: 50

      # Draw a given circle in yellow
      canvas.drawCircle
        circle: circle
        color: "yellow"

      # Draw the circle in green at a different position
      canvas.drawCircle
        circle: circle
        position: Point(25, 75)
        color: "green"

      # Draw an outline circle in purple.
      canvas.drawCircle
        x: 50
        y: 75
        radius: 10
        stroke:
          color: "purple"
          width: 2
      </pre></code>

      @name drawCircle
      @methodOf PixieCanvas#

      @param {Number} [x] location on the x axis to start drawing
      @param {Number} [y] location on the y axis to start drawing
      @param {Point} [position] position object of location to start drawing. This will override x and y values passed
      @param {Number} [radius] length of the radius of the circle
      @param {Color|String} [color] color of the circle
      @param {Circle} [circle] circle object that contains position and radius. Overrides x, y, and radius if passed
      @param {Stroke} [stroke] stroke object that specifies stroke color and stroke width

      @returns {PixieCanvas} this
      ###
      drawCircle: ({x, y, radius, position, color, stroke, circle}) ->
        {x, y, radius} = circle if circle
        {x, y} = position if position

        context.beginPath()
        context.arc(x, y, radius, 0, Math.TAU, true)
        context.closePath()

        if color
          @fillColor(color)
          context.fill()

        if stroke
          @strokeColor(stroke.color)
          @lineWidth(stroke.width)
          context.stroke()

        return @

      ###*
      Draws a rectangle at the specified position with given
      width and height. Optionally takes a position, bounds
      and color argument.

      <code class="run"><pre>
      # Draw a red rectangle using x, y, width and height
      canvas.drawRect
        x: 50
        y: 50
        width: 50
        height: 50
        color: "#F00"

      # Draw a blue rectangle using position, width and height
      # and throw in a stroke for good measure
      canvas.drawRect
        position: Point(0, 0)
        width: 50
        height: 50
        color: "blue"
        stroke:
          color: "orange"
          width: 3

      # Set up a bounds object for the next examples
      bounds =
        x: 100
        y: 0
        width: 100
        height: 100

      # Draw a purple rectangle using bounds
      canvas.drawRect
        bounds: bounds
        color: "green"

      # Draw the outline of the same bounds, but at a different position
      canvas.drawRect
        bounds: bounds
        position: Point(0, 50)
        stroke:
          color: "purple"
          width: 2
      </pre></code>

      @name drawRect
      @methodOf PixieCanvas#

      @param {Number} [x] location on the x axis to start drawing
      @param {Number} [y] location on the y axis to start drawing
      @param {Number} [width] width of rectangle to draw
      @param {Number} [height] height of rectangle to draw
      @param {Point} [position] position to start drawing. Overrides x and y if passed
      @param {Color|String} [color] color of rectangle
      @param {Bounds} [bounds] bounds of rectangle. Overrides x, y, width, height if passed
      @param {Stroke} [stroke] stroke object that specifies stroke color and stroke width

      @returns {PixieCanvas} this
      ###
      drawRect: ({x, y, width, height, position, bounds, color, stroke}) ->
        {x, y, width, height} = bounds if bounds
        {x, y} = position if position

        if color
          @fillColor(color)
          context.fillRect(x, y, width, height)

        if stroke
          @strokeColor(stroke.color)
          @lineWidth(stroke.width)
          context.strokeRect(x, y, width, height)

        return @

      ###*
      Draw a line from `start` to `end`.

      <code class="run"><pre>
      # Draw a sweet diagonal
      canvas.drawLine
        start: Point(0, 0)
        end: Point(200, 200)
        color: "purple"

      # Draw another sweet diagonal
      canvas.drawLine
        start: Point(200, 0)
        end: Point(0, 200)
        color: "red"
        width: 6

      # Now draw a sweet horizontal with a direction and a length
      canvas.drawLine
        start: Point(0, 100)
        length: 200
        direction: Point(1, 0)
        color: "orange"

      </pre></code>

      @name drawLine
      @methodOf PixieCanvas#

      @param {Point} start position to start drawing from
      @param {Point} [end] position to stop drawing
      @param {Number} [width] width of the line
      @param {String|Color} [color] color of the line

      @returns {PixieCanvas} this
      ###
      drawLine: ({start, end, width, color, direction, length, lineCap}) ->
        width ||= 3

        if direction
          end = direction.norm(length).add(start)

        @lineWidth(width)
        @strokeColor(color)

        context.beginPath()
        context.moveTo(start.x, start.y)
        context.lineTo(end.x, end.y)

        if lineCap
          context.lineCap = lineCap

        context.stroke()

        return @

      ###*
      Draw a polygon.

      <code class="run"><pre>
      # Draw a sweet rhombus
      canvas.drawPoly
        points: [
          Point(50, 25)
          Point(75, 50)
          Point(50, 75)
          Point(25, 50)
        ]
        color: "purple"
        stroke:
          color: "red"
          width: 2
      </pre></code>

      @name drawPoly
      @methodOf PixieCanvas#

      @param {Point[]} [points] collection of points that define the vertices of the polygon
      @param {String|Color} [color] color of the polygon
      @param {Stroke} [stroke] stroke object that specifies stroke color and stroke width

      @returns {PixieCanvas} this
      ###
      drawPoly: ({points, color, stroke}) ->
        context.beginPath()
        points.each (point, i) ->
          if i == 0
            context.moveTo(point.x, point.y)
          else
            context.lineTo(point.x, point.y)
        context.lineTo points[0].x, points[0].y

        if color
          @fillColor(color)
          context.fill()

        if stroke
          @strokeColor(stroke.color)
          @lineWidth(stroke.width)
          context.stroke()

        return @

      ###*
      Draw a rounded rectangle.

      Adapted from http://js-bits.blogspot.com/2010/07/canvas-rounded-corner-rectangles.html

      <code class="run"><pre>
      # Draw a purple rounded rectangle with a red outline
      canvas.drawRoundRect
        position: Point(25, 25)
        radius: 10
        width: 150
        height: 100
        color: "purple"
        stroke:
          color: "red"
          width: 2
      </pre></code>

      @name drawRoundRect
      @methodOf PixieCanvas#

      @param {Number} [x] location on the x axis to start drawing
      @param {Number} [y] location on the y axis to start drawing
      @param {Number} [width] width of the rounded rectangle
      @param {Number} [height] height of the rounded rectangle
      @param {Number} [radius=5] radius to round the rectangle corners
      @param {Point} [position] position to start drawing. Overrides x and y if passed
      @param {Color|String} [color] color of the rounded rectangle
      @param {Bounds} [bounds] bounds of the rounded rectangle. Overrides x, y, width, and height if passed
      @param {Stroke} [stroke] stroke object that specifies stroke color and stroke width

      @returns {PixieCanvas} this
      ###
      drawRoundRect: ({x, y, width, height, radius, position, bounds, color, stroke}) ->
        radius = 5 unless radius?

        {x, y, width, height} = bounds if bounds
        {x, y} = position if position

        context.beginPath()
        context.moveTo(x + radius, y)
        context.lineTo(x + width - radius, y)
        context.quadraticCurveTo(x + width, y, x + width, y + radius)
        context.lineTo(x + width, y + height - radius)
        context.quadraticCurveTo(x + width, y + height, x + width - radius, y + height)
        context.lineTo(x + radius, y + height)
        context.quadraticCurveTo(x, y + height, x, y + height - radius)
        context.lineTo(x, y + radius)
        context.quadraticCurveTo(x, y, x + radius, y)
        context.closePath()

        if color
          @fillColor(color)
          context.fill()

        if stroke
          @lineWidth(stroke.width)
          @strokeColor(stroke.color)
          context.stroke()

        return @

      ###*
      Draws text on the canvas at the given position, in the given color.
      If no color is given then the previous fill color is used.

      <code class="run"><pre>
      # Fill canvas to indicate bounds
      canvas.fill
        color: '#eee'

      # A line to indicate the baseline
      canvas.drawLine
        start: Point(25, 50)
        end: Point(125, 50)
        color: "#333"
        width: 1

      # Draw some text, note the position of the baseline
      canvas.drawText
        position: Point(25, 50)
        color: "red"
        text: "It's dangerous to go alone"

      </pre></code>

      @name drawText
      @methodOf PixieCanvas#

      @param {Number} [x] location on x axis to start printing
      @param {Number} [y] location on y axis to start printing
      @param {String} text text to print
      @param {Point} [position] position to start printing. Overrides x and y if passed
      @param {String|Color} [color] color of text to start printing

      @returns {PixieCanvas} this
      ###
      drawText: ({x, y, text, position, color}) ->
        {x, y} = position if position

        @fillColor(color)
        context.fillText(text, x, y)

        return @

      ###*
      Centers the given text on the canvas at the given y position. An x position
      or point position can also be given in which case the text is centered at the
      x, y or position value specified.

      <code class="run"><pre>
      # Fill canvas to indicate bounds
      canvas.fill
        color: "#eee"

      # A line to indicate the baseline
      canvas.drawLine
        start: Point(25, 25)
        end: Point(125, 25)
        color: "#333"
        width: 1

      # Center text on the screen at y value 25
      canvas.centerText
        y: 25
        color: "red"
        text: "It's dangerous to go alone"

      # Center text at point (75, 75)
      canvas.centerText
        position: Point(75, 75)
        color: "green"
        text: "take this"

      </pre></code>

      @name centerText
      @methodOf PixieCanvas#

      @param {String} text Text to print
      @param {Number} [y] location on the y axis to start printing
      @param {Number} [x] location on the x axis to start printing. Overrides the default centering behavior if passed
      @param {Point} [position] position to start printing. Overrides x and y if passed
      @param {String|Color} [color] color of text to print

      @returns {PixieCanvas} this
      ###
      centerText: ({text, x, y, position, color}) ->
        {x, y} = position if position

        x = canvas.width / 2 unless x?

        textWidth = @measureText(text)

        @drawText {
          text
          color
          x: x - (textWidth) / 2
          y
        }

      ###*
      A getter / setter method to set the canvas fillColor.

      <code><pre>
      # Set the fill color
      canvas.fillColor('#FF0000')

      # Passing no arguments returns the fillColor
      canvas.fillColor()
      # => '#FF0000'

      # You can also pass a Color object
      canvas.fillColor(Color('sky blue'))
      </pre></code>

      @name fillColor
      @methodOf PixieCanvas#

      @param {String|Color} [color] color to make the canvas fillColor

      @returns {PixieCanvas} this
      ###
      fillColor: (color) ->
        if color
          if color.channels
            context.fillStyle = color.toString()
          else
            context.fillStyle = color

          return @
        else
          return context.fillStyle

      ###*
      A getter / setter method to set the canvas strokeColor.

      <code><pre>
      # Set the stroke color
      canvas.strokeColor('#FF0000')

      # Passing no arguments returns the strokeColor
      canvas.strokeColor()
      # => '#FF0000'

      # You can also pass a Color object
      canvas.strokeColor(Color('sky blue'))
      </pre></code>

      @name strokeColor
      @methodOf PixieCanvas#

      @param {String|Color} [color] color to make the canvas strokeColor

      @returns {PixieCanvas} this
      ###
      strokeColor: (color) ->
        if color
          if color.channels
            context.strokeStyle = color.toString()
          else
            context.strokeStyle = color

          return @
        else
          return context.strokeStyle

      ###*
      Determine how wide some text is.

      <code><pre>
      canvas.measureText('Hello World!')
      # => 55
      </pre></code>

      @name measureText
      @methodOf PixieCanvas#

      @param {String} [text] the text to measure

      @returns {PixieCanvas} this
      ###
      measureText: (text) ->
        context.measureText(text).width

      putImageData: (imageData, x, y) ->
        context.putImageData(imageData, x, y)

        return @

      context: ->
        context

      element: ->
        canvas

      createPattern: (image, repitition) ->
        context.createPattern(image, repitition)

      clip: (x, y, width, height) ->
        context.beginPath()
        context.rect(x, y, width, height)
        context.clip()

        return @

    contextAttrAccessor = (attrs...) ->
      attrs.each (attr) ->
        $canvas[attr] = (newVal) ->
          if newVal?
            context[attr] = newVal
            return @
          else
            context[attr]

    canvasAttrAccessor = (attrs...) ->
      attrs.each (attr) ->
        $canvas[attr] = (newVal) ->
          if newVal?
            canvas[attr] = newVal
            return @
          else
            canvas[attr]

    contextAttrAccessor(
      "font",
      "globalAlpha",
      "globalCompositeOperation",
      "lineWidth",
      "textAlign",
    )

    canvasAttrAccessor(
      "height",
      "width",
    )

    if canvas?.getContext
      context = canvas.getContext("2d")

      if options.init
        options.init($canvas)

      return $canvas

)(jQuery)
