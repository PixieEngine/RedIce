;
;
/**
The Animated module, when included in a GameObject, gives the object 
methods to transition from one animation state to another

@name Animated
@module
@constructor

@param {Object} I Instance variables
@param {Object} self Reference to including object
*/var Animated;
Animated = function(I, self) {
  var advanceFrame, find, initializeState, loadByName, updateSprite, _name, _ref;
  I || (I = {});
  $.reverseMerge(I, {
    animationName: (_ref = I["class"]) != null ? _ref.underscore() : void 0,
    data: {
      version: "",
      tileset: [
        {
          id: 0,
          src: "",
          title: "",
          circles: [
            {
              x: 0,
              y: 0,
              radius: 0
            }
          ]
        }
      ],
      animations: [
        {
          name: "",
          complete: "",
          interruptible: false,
          speed: "",
          transform: [
            {
              hflip: false,
              vflip: false
            }
          ],
          triggers: {
            "0": ["a trigger"]
          },
          frames: [0],
          transform: [void 0]
        }
      ]
    },
    activeAnimation: {
      name: "",
      complete: "",
      interruptible: false,
      speed: "",
      transform: [
        {
          hflip: false,
          vflip: false
        }
      ],
      triggers: {
        "0": [""]
      },
      frames: [0]
    },
    currentFrameIndex: 0,
    debugAnimation: false,
    hflip: false,
    vflip: false,
    lastUpdate: new Date().getTime(),
    useTimer: false
  });
  loadByName = function(name, callback) {
    var url;
    url = "" + BASE_URL + "/animations/" + name + ".animation?" + (new Date().getTime());
    $.getJSON(url, function(data) {
      I.data = data;
      return typeof callback === "function" ? callback(data) : void 0;
    });
    return I.data;
  };
  initializeState = function() {
    I.activeAnimation = I.data.animations.first();
    return I.spriteLookup = I.data.tileset.map(function(spriteData) {
      return Sprite.fromURL(spriteData.src);
    });
  };
  window[_name = "" + I.animationName + "SpriteLookup"] || (window[_name] = []);
  if (!window["" + I.animationName + "SpriteLookup"].length) {
    window["" + I.animationName + "SpriteLookup"] = I.data.tileset.map(function(spriteData) {
      return Sprite.fromURL(spriteData.src);
    });
  }
  I.spriteLookup = window["" + I.animationName + "SpriteLookup"];
  if (I.data.animations.first().name !== "") {
    initializeState();
  } else if (I.animationName) {
    loadByName(I.animationName, function() {
      return initializeState();
    });
  } else {
    throw "No animation data provided. Use animationName to specify an animation to load from the project or pass in raw JSON to the data key.";
  }
  advanceFrame = function() {
    var frames, nextState, sprite;
    frames = I.activeAnimation.frames;
    if (I.currentFrameIndex === frames.indexOf(frames.last())) {
      self.trigger("Complete");
      if (nextState = I.activeAnimation.complete) {
        I.activeAnimation = find(nextState) || I.activeAnimation;
        I.currentFrameIndex = 0;
      }
    } else {
      I.currentFrameIndex = (I.currentFrameIndex + 1) % frames.length;
    }
    sprite = I.spriteLookup[frames[I.currentFrameIndex]];
    return updateSprite(sprite);
  };
  find = function(name) {
    var nameLower, result;
    result = null;
    nameLower = name.toLowerCase();
    I.data.animations.each(function(animation) {
      if (animation.name.toLowerCase() === nameLower) {
        return result = animation;
      }
    });
    return result;
  };
  updateSprite = function(spriteData) {
    I.sprite = spriteData;
    I.width = spriteData.width;
    return I.height = spriteData.height;
  };
  return {
    /**
    Transitions to a new active animation. Will not transition if the new state
    has the same name as the current one or if the active animation is marked as locked.

    @param {String} newState The name of the target state you wish to transition to.
    */
    transition: function(newState, force) {
      var toNextState;
      if (newState === I.activeAnimation.name) {
        return;
      }
      toNextState = function(state) {
        var firstFrame, firstSprite, nextState;
        if (nextState = find(state)) {
          I.activeAnimation = nextState;
          firstFrame = I.activeAnimation.frames.first();
          firstSprite = I.spriteLookup[firstFrame];
          I.currentFrameIndex = 0;
          return updateSprite(firstSprite);
        } else {
          if (I.debugAnimation) {
            return warn("Could not find animation state '" + newState + "'. The current transition will be ignored");
          }
        }
      };
      if (force) {
        return toNextState(newState);
      } else {
        if (!I.activeAnimation.interruptible) {
          if (I.debugAnimation) {
            warn("Cannot transition to '" + newState + "' because '" + I.activeAnimation.name + "' is locked");
          }
          return;
        }
        return toNextState(newState);
      }
    },
    before: {
      update: function() {
        var time, triggers, updateFrame, _ref2, _ref3;
        if (I.useTimer) {
          time = new Date().getTime();
          if (updateFrame = (time - I.lastUpdate) >= I.activeAnimation.speed) {
            I.lastUpdate = time;
            if (triggers = (_ref2 = I.activeAnimation.triggers) != null ? _ref2[I.currentFrameIndex] : void 0) {
              triggers.each(function(event) {
                return self.trigger(event);
              });
            }
            return advanceFrame();
          }
        } else {
          if (triggers = (_ref3 = I.activeAnimation.triggers) != null ? _ref3[I.currentFrameIndex] : void 0) {
            triggers.each(function(event) {
              return self.trigger(event);
            });
          }
          return advanceFrame();
        }
      }
    }
  };
};;
(function() {
  var Animation, fromPixieId;
  Animation = function(data) {
    var activeAnimation, advanceFrame, currentSprite, spriteLookup;
    spriteLookup = {};
    activeAnimation = data.animations[0];
    currentSprite = data.animations[0].frames[0];
    advanceFrame = function(animation) {
      var frames;
      frames = animation.frames;
      return currentSprite = frames[(frames.indexOf(currentSprite) + 1) % frames.length];
    };
    data.tileset.each(function(spriteData, i) {
      return spriteLookup[i] = Sprite.fromURL(spriteData.src);
    });
    return $.extend(data, {
      currentSprite: function() {
        return currentSprite;
      },
      draw: function(canvas, x, y) {
        return canvas.withTransform(Matrix.translation(x, y), function() {
          return spriteLookup[currentSprite].draw(canvas, 0, 0);
        });
      },
      frames: function() {
        return activeAnimation.frames;
      },
      update: function() {
        return advanceFrame(activeAnimation);
      },
      active: function(name) {
        if (name !== void 0) {
          if (data.animations[name]) {
            return currentSprite = data.animations[name].frames[0];
          }
        } else {
          return activeAnimation;
        }
      }
    });
  };
  window.Animation = function(name, callback) {
    return fromPixieId(App.Animations[name], callback);
  };
  fromPixieId = function(id, callback) {
    var proxy, url;
    url = "http://pixie.strd6.com/s3/animations/" + id + "/data.json";
    proxy = {
      active: $.noop,
      draw: $.noop
    };
    $.getJSON(url, function(data) {
      $.extend(proxy, Animation(data));
      return typeof callback === "function" ? callback(proxy) : void 0;
    });
    return proxy;
  };
  return window.Animation.fromPixieId = fromPixieId;
})();;
(function($) {
  /**
  The <code>Developer</code> module provides a debug overlay and methods for debugging and live coding.

  @name Developer
  @fieldOf Engine
  @module

  @param {Object} I Instance variables
  @param {Object} self Reference to the engine
  */  var developerHotkeys, developerMode, developerModeMousedown, namespace, objectToUpdate;
  Engine.Developer = function(I, self) {
    var boxHeight, boxWidth, font, lineHeight, margin, screenHeight, screenWidth, textStart;
    screenWidth = (typeof App !== "undefined" && App !== null ? App.width : void 0) || 480;
    screenHeight = (typeof App !== "undefined" && App !== null ? App.height : void 0) || 320;
    margin = 10;
    boxWidth = 240;
    boxHeight = 60;
    textStart = screenWidth - boxWidth + margin;
    font = "bold 9pt arial";
    lineHeight = 16;
    self.bind("draw", function(canvas) {
      if (I.paused) {
        canvas.withTransform(I.cameraTransform, function(canvas) {
          return I.objects.each(function(object) {
            canvas.fillColor('rgba(255, 0, 0, 0.5)');
            return canvas.fillRect(object.bounds().x, object.bounds().y, object.bounds().width, object.bounds().height);
          });
        });
        canvas.font(font);
        canvas.fillColor('rgba(0, 0, 0, 0.5)');
        canvas.fillRect(screenWidth - boxWidth, 0, boxWidth, boxHeight);
        canvas.fillColor('#fff');
        canvas.fillText("Developer Mode. Press Esc to resume", textStart, margin + 5);
        canvas.fillText("Shift+Left click to add boxes", textStart, margin + 5 + lineHeight);
        return canvas.fillText("Right click red boxes to edit properties", textStart, margin + 5 + 2 * lineHeight);
      }
    });
    self.bind("init", function() {
      var fn, key, _results;
      window.updateObjectProperties = function(newProperties) {
        if (objectToUpdate) {
          return Object.extend(objectToUpdate, GameObject.construct(newProperties));
        }
      };
      $(document).unbind("." + namespace);
      $(document).bind("mousedown." + namespace, developerModeMousedown);
      _results = [];
      for (key in developerHotkeys) {
        fn = developerHotkeys[key];
        _results.push((function(key, fn) {
          return $(document).bind("keydown." + namespace, key, function(event) {
            event.preventDefault();
            return fn();
          });
        })(key, fn));
      }
      return _results;
    });
    return {};
  };
  namespace = "engine_developer";
  developerMode = false;
  objectToUpdate = null;
  developerModeMousedown = function(event) {
    var object;
    if (developerMode) {
      console.log(event.which);
      if (event.which === 3) {
        if (object = engine.objectAt(event.pageX, event.pageY)) {
          parent.editProperties(object.I);
          objectToUpdate = object;
        }
        return console.log(object);
      } else if (event.which === 2 || keydown.shift) {
        return typeof window.developerAddObject === "function" ? window.developerAddObject(event) : void 0;
      }
    }
  };
  return developerHotkeys = {
    esc: function() {
      developerMode = !developerMode;
      if (developerMode) {
        return engine.pause();
      } else {
        return engine.play();
      }
    },
    f3: function() {
      return Local.set("level", engine.saveState());
    },
    f4: function() {
      return engine.loadState(Local.get("level"));
    },
    f5: function() {
      return engine.reload();
    }
  };
})(jQuery);;
/**
The <code>FPSCounter</code> module tracks and displays the framerate.

<code><pre>
window.engine = Engine
  ...
  includedModules: ["FPSCounter"]
  FPSColor: "#080"
</pre></code>

@name FPSCounter
@fieldOf Engine
@module

@param {Object} I Instance variables
@param {Object} self Reference to the engine
*/Engine.FPSCounter = function(I, self) {
  var framerate;
  Object.reverseMerge(I, {
    showFPS: true,
    FPSColor: "#FFF"
  });
  framerate = Framerate({
    noDOM: true
  });
  return self.bind("overlay", function(canvas) {
    if (I.showFPS) {
      canvas.font("bold 9pt consolas, 'Courier New', 'andale mono', 'lucida console', monospace");
      canvas.drawText({
        color: I.FPSColor,
        position: Point(6, 18),
        text: "fps: " + framerate.fps
      });
    }
    return framerate.rendered();
  });
};;
/**
The <code>HUD</code> module provides an extra canvas to draw to. GameObjects that respond to the
<code>drawHUD</code> method will draw to the HUD canvas. The HUD canvas is not cleared each frame, it is
the responsibility of the objects drawing on it to manage that themselves.

@name HUD
@fieldOf Engine
@module

@param {Object} I Instance variables
@param {Object} self Reference to the engine
*/Engine.HUD = function(I, self) {
  var hudCanvas;
  hudCanvas = $("<canvas width=" + App.width + " height=" + App.height + " />").powerCanvas();
  hudCanvas.font("bold 9pt consolas, 'Courier New', 'andale mono', 'lucida console', monospace");
  self.bind("draw", function(canvas) {
    var hud;
    I.objects.each(function(object) {
      return typeof object.drawHUD === "function" ? object.drawHUD(hudCanvas) : void 0;
    });
    hud = hudCanvas.element();
    return canvas.drawImage(hud, 0, 0, hud.width, hud.height, 0, 0, hud.width, hud.height);
  });
  return {};
};;
(function($) {
  /**
  The <code>Joysticks</code> module gives the engine access to joysticks.

  <code><pre>
  # First you need to add the joysticks module to the engine
  window.engine = Engine
    ...
    includedModules: ["Joysticks"]
  # Then you need to get a controller reference
  # id = 0 for player 1, etc.
  controller = engine.controller(id)

  # Point indicating direction primary axis is held
  direction = controller.position()

  # Check if buttons are held
  controller.actionDown("A")
  controller.actionDown("B")
  controller.actionDown("X")
  controller.actionDown("Y")
  </pre></code>

  @name Joysticks
  @fieldOf Engine
  @module

  @param {Object} I Instance variables
  @param {Object} self Reference to the engine
  */  return Engine.Joysticks = function(I, self) {
    Joysticks.init();
    self.bind("update", function() {
      Joysticks.init();
      return Joysticks.update();
    });
    return {
      /**
      Get a controller for a given joystick id.

      @name controller
      @methodOf Engine.Joysticks#

      @param {Number} i The joystick id to get the controller of.
      */
      controller: function(i) {
        return Joysticks.getController(i);
      }
    };
  };
})();;
/**
The <code>Shadows</code> module provides a lighting extension to the Engine. Objects that have
an illuminate method will add light to the scene. Objects that have an true opaque attribute will cast
shadows.

@name Shadows
@fieldOf Engine
@module

@param {Object} I Instance variables
@param {Object} self Reference to the engine
*/Engine.Shadows = function(I, self) {
  var shadowCanvas;
  shadowCanvas = $("<canvas width=640 height=480 />").powerCanvas();
  self.bind("draw", function(canvas) {
    var shadows;
    if (I.ambientLight < 1) {
      shadowCanvas.compositeOperation("source-over");
      shadowCanvas.clear();
      shadowCanvas.fill("rgba(0, 0, 0, " + (1 - I.ambientLight) + ")");
      shadowCanvas.compositeOperation("destination-out");
      shadowCanvas.withTransform(I.cameraTransform, function(shadowCanvas) {
        return I.objects.each(function(object, i) {
          if (object.illuminate) {
            shadowCanvas.globalAlpha(1);
            return object.illuminate(shadowCanvas);
          }
        });
      });
      shadows = shadowCanvas.element();
      return canvas.drawImage(shadows, 0, 0, shadows.width, shadows.height, 0, 0, shadows.width, shadows.height);
    }
  });
  return {};
};;
/**
The <code>Tilemap</code> module provides a way to load tilemaps in the engine.

@name Tilemap
@fieldOf Engine
@module

@param {Object} I Instance variables
@param {Object} self Reference to the engine
*/Engine.Tilemap = function(I, self) {
  var clearObjects, map, updating;
  map = null;
  updating = false;
  clearObjects = false;
  self.bind("preDraw", function(canvas) {
    return map != null ? map.draw(canvas) : void 0;
  });
  self.bind("update", function() {
    return updating = true;
  });
  self.bind("afterUpdate", function() {
    updating = false;
    if (clearObjects) {
      I.objects.clear();
      return clearObjects = false;
    }
  });
  return {
    /**
    Loads a new may and unloads any existing map or entities.

    @name loadMap
    @methodOf Engine#
    */
    loadMap: function(name, complete) {
      clearObjects = updating;
      return map = Tilemap.load({
        name: name,
        complete: complete,
        entity: self.add
      });
    }
  };
};;
/**
This object keeps track of framerate and displays it by creating and appending an
html element to the DOM.

Once created you call snapshot at the end of every rendering cycle.

@name Framerate
@constructor
*/var Framerate;
Framerate = function(options) {
  var element, framerateUpdateInterval, framerates, numFramerates, renderTime, self, updateFramerate;
  options || (options = {});
  if (!options.noDOM) {
    element = $("<div>", {
      css: {
        color: "#FFF",
        fontFamily: "consolas, 'Courier New', 'andale mono', 'lucida console', monospace",
        fontWeight: "bold",
        paddingLeft: 4,
        position: "fixed",
        top: 0,
        left: 0
      }
    }).appendTo('body').get(0);
  }
  numFramerates = 15;
  framerateUpdateInterval = 250;
  renderTime = -1;
  framerates = [];
  updateFramerate = function() {
    var framerate, rate, tot, _i, _len;
    tot = 0;
    for (_i = 0, _len = framerates.length; _i < _len; _i++) {
      rate = framerates[_i];
      tot += rate;
    }
    framerate = (tot / framerates.length).round();
    self.fps = framerate;
    if (element) {
      return element.innerHTML = "fps: " + framerate;
    }
  };
  setInterval(updateFramerate, framerateUpdateInterval);
  /**
  Call this method everytime you render.

  @name rendered
  @methodOf Framerate#
  */
  return self = {
    rendered: function() {
      var framerate, newTime, t;
      if (renderTime < 0) {
        return renderTime = new Date().getTime();
      } else {
        newTime = new Date().getTime();
        t = newTime - renderTime;
        framerate = 1000 / t;
        framerates.push(framerate);
        while (framerates.length > numFramerates) {
          framerates.shift();
        }
        return renderTime = newTime;
      }
    }
  };
};;
(function() {
  var Map, Tilemap, fromPixieId, loadByName;
  Map = function(data, entityCallback) {
    var entity, loadEntities, spriteLookup, tileHeight, tileWidth, uuid, _ref;
    tileHeight = data.tileHeight;
    tileWidth = data.tileWidth;
    spriteLookup = {};
    _ref = App.entities;
    for (uuid in _ref) {
      entity = _ref[uuid];
      spriteLookup[uuid] = Sprite.fromURL(entity.tileSrc);
    }
    loadEntities = function() {
      if (!entityCallback) {
        return;
      }
      return data.layers.each(function(layer, layerIndex) {
        var entities, entity, entityData, x, y, _i, _len, _results;
        if (layer.name.match(/entities/i)) {
          if (entities = layer.entities) {
            _results = [];
            for (_i = 0, _len = entities.length; _i < _len; _i++) {
              entity = entities[_i];
              x = entity.x, y = entity.y, uuid = entity.uuid;
              entityData = Object.extend({
                layer: layerIndex,
                sprite: spriteLookup[uuid],
                x: x,
                y: y
              }, App.entities[uuid], entity.properties);
              _results.push(entityCallback(entityData));
            }
            return _results;
          }
        }
      });
    };
    loadEntities();
    return Object.extend(data, {
      draw: function(canvas, x, y) {
        return canvas.withTransform(Matrix.translation(x, y), function() {
          return data.layers.each(function(layer) {
            if (layer.name.match(/entities/i)) {
              return;
            }
            return layer.tiles.each(function(row, y) {
              return row.each(function(uuid, x) {
                var sprite;
                if (sprite = spriteLookup[uuid]) {
                  return sprite.draw(canvas, x * tileWidth, y * tileHeight);
                }
              });
            });
          });
        });
      }
    });
  };
  Tilemap = function(name, callback, entityCallback) {
    return fromPixieId(App.Tilemaps[name], callback, entityCallback);
  };
  fromPixieId = function(id, callback, entityCallback) {
    var proxy, url;
    url = "http://pixieengine.com/s3/tilemaps/" + id + "/data.json";
    proxy = {
      draw: function() {}
    };
    $.getJSON(url, function(data) {
      Object.extend(proxy, Map(data, entityCallback));
      return typeof callback === "function" ? callback(proxy) : void 0;
    });
    return proxy;
  };
  loadByName = function(name, callback, entityCallback) {
    var directory, proxy, url, _ref;
    directory = (typeof App !== "undefined" && App !== null ? (_ref = App.directories) != null ? _ref.tilemaps : void 0 : void 0) || "data";
    url = "" + BASE_URL + "/" + directory + "/" + name + ".tilemap?" + (new Date().getTime());
    proxy = {
      draw: function() {}
    };
    $.getJSON(url, function(data) {
      Object.extend(proxy, Map(data, entityCallback));
      return typeof callback === "function" ? callback(proxy) : void 0;
    });
    return proxy;
  };
  Tilemap.fromPixieId = fromPixieId;
  Tilemap.load = function(options) {
    if (options.pixieId) {
      return fromPixieId(options.pixieId, options.complete, options.entity);
    } else if (options.name) {
      return loadByName(options.name, options.complete, options.entity);
    }
  };
  return (typeof exports !== "undefined" && exports !== null ? exports : this)["Tilemap"] = Tilemap;
})();;
;
