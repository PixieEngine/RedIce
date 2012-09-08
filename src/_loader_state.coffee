do ->
  loadedAssets = 0
  assetList = []

  Sprite.load = ((oldLoad) ->
    (url, callback) ->
      assetList.push url

      oldLoad url, (sprite) ->
        loadedAssets += 1
        callback?(sprite)
  )(Sprite.load)
  
  Sprite.loadSheet = ((oldLoad) ->
    (name, tileWidth, tileHeight, scale, callback) ->
      assetList.push name

      oldLoad name, tileWidth, tileHeight, scale, (sprites) ->
        loadedAssets += 1
        callback?(sprites)
  )(Sprite.loadSheet)

  window.LoaderState = (I={}) ->
    self = GameState(I)
    
    loadingComplete = ->
      loadedAssets >= assetList.length
  
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
        text: "#{loadedAssets} / #{assetList.length}"
        y: App.height/2 + 50
        color: "#FFF"
        
      canvas.font("bold 20px consolas, 'Courier New', 'andale mono', 'lucida console', monospace")
        
      assetList.each (asset, i) ->
        canvas.drawText
          x: 12
          y: (i + 1) * 24
          text: asset
  
    # We must always return self as the last line
    return self
