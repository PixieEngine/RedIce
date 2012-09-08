do ->
  outstandingAssets = 0
  loadedAssets = 0

  Sprite.load = ((oldLoad) ->
    (url, callback) ->
      outstandingAssets += 1
      oldLoad url, (sprite) ->
        loadedAssets += 1
        callback?(sprite)
  )(Sprite.load)
  
  Sprite.loadSheet = ((oldLoad) ->
    (name, tileWidth, tileHeight, scale, callback) ->
      outstandingAssets += 1

      oldLoad name, tileWidth, tileHeight, scale, (sprites) ->
        loadedAssets += 1
        callback?(sprites)
  )(Sprite.loadSheet)

  window.LoaderState = (I={}) ->
    self = GameState(I)
    
    loadingComplete = ->
      loadedAssets >= outstandingAssets
  
    # Add events and methods here
    self.bind "update", ->
      # Add update method behavior
      if loadingComplete()
        engine.setState(MainMenuState())
        
    self.bind "overlay", (canvas) ->
      canvas.font("bold 48px consolas, 'Courier New', 'andale mono', 'lucida console', monospace")
      
      canvas.centerText
        text: "Loading"
        y: App.height/2
        color: "#FFF"
        
      canvas.centerText
        text: "#{loadedAssets} / #{outstandingAssets}"
        y: App.height/2 + 50
        color: "#FFF"
  
    # We must always return self as the last line
    return self
