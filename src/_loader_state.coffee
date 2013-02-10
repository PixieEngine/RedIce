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

      loadingComplete: ->
        assetList.pluck("loaded").sum() is assetList.length

  window.AssetLoader =
    group: (name, callback) ->
      oldAssetGroup = currentAssetGroup
      currentAssetGroup = name
      callback()
      currentAssetGroup = oldAssetGroup

    load: (groupName="default") ->
      assetGroups[groupName].loadAll()

  oldSpriteLoad = Sprite.load

  loadSpriteFnGenerator = (url, callback) ->
    (fn) ->
      oldSpriteLoad url, (sprite) ->
        callback?(sprite)
        fn()

  Sprite.load = (url, callback) ->
    proxy = Sprite.LoaderProxy()

    currentGroup().add(Asset loadSpriteFnGenerator(url, (sprite) ->
      Object.extend(proxy, sprite)
      callback?(sprite)
    ))

    return proxy

  oldSpriteLoadSheet = Sprite.loadSheet

  loadSpriteSheetFnGenerator = (name, tileWidth, tileHeight, scale, callback) ->
    (fn) ->
      oldSpriteLoadSheet name, tileWidth, tileHeight, scale, (sprites) ->
        callback?(sprites)
        fn()

  Sprite.loadSheet = (name, tileWidth, tileHeight, scale, callback) ->
    proxy = []

    currentGroup().add(Asset loadSpriteSheetFnGenerator(name, tileWidth, tileHeight, scale, (sprites) ->
      sprites.each (sprite) ->
        proxy.push sprite
      callback?(sprites)
    ))

    return proxy

  window.LoaderState = (I={}) ->
    Object.reverseMerge I,
      assetGroup: "default"
      nextState: MatchSetupState

    assetGroup = assetGroups[I.assetGroup]
    assetGroup.loadAll()

    self = GameState(I)

    # Add events and methods here
    self.on "update", ->
      # Add update method behavior
      if assetGroup.loadingComplete()
        engine.setState(I.nextState?())

    self.on "overlay", (canvas) ->
      canvas.font("bold 48px consolas, 'Courier New', 'andale mono', 'lucida console', monospace")

      canvas.centerText
        text: "Loading"
        y: App.height/2
        color: "#FFF"

      canvas.centerText
        text: assetGroup.status()
        y: App.height/2 + 50
        color: "#FFF"

    # We must always return self as the last line
    return self
