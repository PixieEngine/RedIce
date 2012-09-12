do ->
  currentAssetGroup = undefined
  assetGroups = {}

  currentGroup = ->
    (assetGroups[currentAssetGroup || "default"] ||= AssetGroup())

  Asset = (loadFn) ->
    self =
      load: ->
        loadFn ->
          self.loaded = true
      loaded: false

  window.AssetGroup = ->
    assetList = []
    loading = false

    self =
      add: (asset) ->
        assetList.push asset
        asset.load() if loading
    
      loadAll: ->
        assetList.invoke "load"
        loading = true
    
      status: ->
        loadedAssetCount = assetList.pluck("loaded").sum()
        "#{loadedAssetCount} / #{assetList.length}"

  window.AssetLoader =
    group: (name, callback) ->
      oldAssetGroup = currentAssetGroup
      currentAssetGroup = name
      callback()
      currentAssetGroup = oldAssetGroup
    
    load: (groupName="default") ->
      assetGroups[]

  oldSpriteLoad = Sprite.load
  
  loadSpriteFnGenerator = (url, callback) ->
    (fn) ->
      oldSpriteLoad url, (sprite) ->
        callback?(sprite)
        fn()

  Sprite.load = (url, callback) ->
    currentGroup.add(Asset loadSpriteFnGenerator(url, callback))
  
  oldSpriteLoadSheet = Sprite.loadSheet
  
  loadSpriteSheetFnGenerator = (name, tileWidth, tileHeight, scale, callback) ->
    (fn) ->
      oldSpriteLoadSheet name, tileWidth, tileHeight, scale, (sprites) ->
        callback?(sprites)
        fn()

  Sprite.loadSheet = (name, tileWidth, tileHeight, scale, callback) ->
    currentGroup.add(Asset loadSpriteSheetFnGenerator(name, tileWidth, tileHeight, scale, callback))

  window.LoaderState = (I={}) ->
    Object.reverseMerge I,
      assetGroup: "default"

    self = GameState(I)
    
    loadingComplete = ->
      loadedList.length >= assetList.length
  
    # Add events and methods here
    self.bind "update", ->
      loadedList.sort()
      assetList.sort()

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
        text: "#{loadedList.length} / #{assetList.length}"
        y: App.height/2 + 50
        color: "#FFF"
        
      canvas.font("bold 10px consolas, 'Courier New', 'andale mono', 'lucida console', monospace")
        
      assetList.each (asset, i) ->
        canvas.drawText
          x: 12
          y: (i + 1) * 14
          text: asset
          
      loadedList.each (asset, i) ->
        canvas.drawText
          x: 12 + App.width/2
          y: (i + 1) * 14
          text: asset
  
    # We must always return self as the last line
    return self
