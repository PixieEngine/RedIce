;
;
document.oncontextmenu = function() {
  return false;
};
$(document).bind("keydown", function(event) {
  if (!$(event.target).is("input")) {
    return event.preventDefault();
  }
});;
var Joysticks;
var __slice = Array.prototype.slice;
Joysticks = (function() {
  var AXIS_MAX, Controller, DEAD_ZONE, TRIP_HIGH, TRIP_LOW, buttonMapping, controllers, displayInstallPrompt, joysticks, plugin, previousJoysticks, type;
  type = "application/x-boomstickjavascriptjoysticksupport";
  plugin = null;
  AXIS_MAX = 32767;
  DEAD_ZONE = AXIS_MAX * 0.2;
  TRIP_HIGH = AXIS_MAX * 0.75;
  TRIP_LOW = AXIS_MAX * 0.5;
  previousJoysticks = [];
  joysticks = [];
  controllers = [];
  buttonMapping = {
    "A": 1,
    "B": 2,
    "C": 4,
    "D": 8,
    "X": 4,
    "Y": 8,
    "R": 32,
    "RB": 32,
    "R1": 32,
    "L": 16,
    "LB": 16,
    "L1": 16,
    "SELECT": 64,
    "BACK": 64,
    "START": 128,
    "HOME": 256,
    "GUIDE": 256,
    "TL": 512,
    "TR": 1024,
    "ANY": 0xFFFFFF
  };
  displayInstallPrompt = function(text, url) {
    return $("<a />", {
      css: {
        backgroundColor: "yellow",
        boxSizing: "border-box",
        color: "#000",
        display: "block",
        fontWeight: "bold",
        left: 0,
        padding: "1em",
        position: "absolute",
        textDecoration: "none",
        top: 0,
        width: "100%",
        zIndex: 2000
      },
      href: url,
      target: "_blank",
      text: text
    }).appendTo("body");
  };
  Controller = function(i) {
    var axisTrips, currentState, previousState, self;
    currentState = function() {
      return joysticks[i];
    };
    previousState = function() {
      return previousJoysticks[i];
    };
    axisTrips = [];
    return self = Core().include(Bindable).extend({
      actionDown: function() {
        var buttons, state;
        buttons = 1 <= arguments.length ? __slice.call(arguments, 0) : [];
        if (state = currentState()) {
          return buttons.inject(false, function(down, button) {
            return down || state.buttons & buttonMapping[button];
          });
        } else {
          return false;
        }
      },
      buttonPressed: function(button) {
        var buttonId;
        buttonId = buttonMapping[button];
        return (self.buttons() & buttonId) && !(previousState().buttons & buttonId);
      },
      position: function(stick) {
        var state;
        if (stick == null) {
          stick = 0;
        }
        if (state = currentState()) {
          return Joysticks.position(state, stick);
        } else {
          return Point(0, 0);
        }
      },
      axis: function(n) {
        return self.axes()[n] || 0;
      },
      axes: function() {
        var state;
        if (state = currentState()) {
          return state.axes;
        } else {
          return [];
        }
      },
      buttons: function() {
        var state;
        if (state = currentState()) {
          return state.buttons;
        }
      },
      processEvents: function() {
        var x, y, _ref;
        _ref = [0, 1].map(function(n) {
          if (!axisTrips[n] && self.axis(n).abs() > TRIP_HIGH) {
            axisTrips[n] = true;
            return self.axis(n).sign();
          }
          if (axisTrips[n] && self.axis(n).abs() < TRIP_LOW) {
            axisTrips[n] = false;
          }
          return 0;
        }), x = _ref[0], y = _ref[1];
        if (!x || !y) {
          return self.trigger("tap", Point(x, y));
        }
      },
      drawDebug: function(canvas) {
        var axis, i, lineHeight, _len, _ref;
        lineHeight = 18;
        canvas.fillColor("#FFF");
        _ref = self.axes();
        for (i = 0, _len = _ref.length; i < _len; i++) {
          axis = _ref[i];
          canvas.fillText(axis, 0, i * lineHeight);
        }
        return canvas.fillText(self.buttons(), 0, i * lineHeight);
      }
    });
  };
  return {
    getController: function(i) {
      return controllers[i] || (controllers[i] = Controller(i));
    },
    init: function() {
      if (!plugin) {
        plugin = document.createElement("object");
        plugin.type = type;
        plugin.width = 0;
        plugin.height = 0;
        $("body").append(plugin);
        plugin.maxAxes = 6;
        if (!plugin.status) {
          return displayInstallPrompt("Your browser does not yet handle joysticks, please click here to install the Boomstick plugin!", "https://github.com/STRd6/Boomstick/wiki");
        }
      }
    },
    position: function(joystick, stick) {
      var magnitude, p, ratio;
      if (stick == null) {
        stick = 0;
      }
      p = Point(joystick.axes[2 * stick], joystick.axes[2 * stick + 1]);
      magnitude = p.magnitude();
      if (magnitude > AXIS_MAX) {
        return p.norm();
      } else if (magnitude < DEAD_ZONE) {
        return Point(0, 0);
      } else {
        ratio = magnitude / AXIS_MAX;
        return p.scale(ratio / AXIS_MAX);
      }
    },
    status: function() {
      return plugin != null ? plugin.status : void 0;
    },
    update: function() {
      var controller, _i, _len, _results;
      if (plugin.joysticksJSON) {
        previousJoysticks = joysticks;
        joysticks = JSON.parse(plugin.joysticksJSON());
      }
      _results = [];
      for (_i = 0, _len = controllers.length; _i < _len; _i++) {
        controller = controllers[_i];
        _results.push(controller != null ? controller.processEvents() : void 0);
      }
      return _results;
    },
    joysticks: function() {
      return joysticks;
    }
  };
})();;
/**
jQuery Hotkeys Plugin
Copyright 2010, John Resig
Dual licensed under the MIT or GPL Version 2 licenses.

Based upon the plugin by Tzury Bar Yochay:
http://github.com/tzuryby/hotkeys

Original idea by:
Binny V A, http://www.openjs.com/scripts/events/keyboard_shortcuts/
*/(function(jQuery) {
  var keyHandler;
  jQuery.hotkeys = {
    version: "0.8",
    specialKeys: {
      8: "backspace",
      9: "tab",
      13: "return",
      16: "shift",
      17: "ctrl",
      18: "alt",
      19: "pause",
      20: "capslock",
      27: "esc",
      32: "space",
      33: "pageup",
      34: "pagedown",
      35: "end",
      36: "home",
      37: "left",
      38: "up",
      39: "right",
      40: "down",
      45: "insert",
      46: "del",
      96: "0",
      97: "1",
      98: "2",
      99: "3",
      100: "4",
      101: "5",
      102: "6",
      103: "7",
      104: "8",
      105: "9",
      106: "*",
      107: "+",
      109: "-",
      110: ".",
      111: "/",
      112: "f1",
      113: "f2",
      114: "f3",
      115: "f4",
      116: "f5",
      117: "f6",
      118: "f7",
      119: "f8",
      120: "f9",
      121: "f10",
      122: "f11",
      123: "f12",
      144: "numlock",
      145: "scroll",
      186: ";",
      187: "=",
      188: ",",
      189: "-",
      190: ".",
      191: "/",
      219: "[",
      220: "\\",
      221: "]",
      222: "'",
      224: "meta"
    },
    shiftNums: {
      "`": "~",
      "1": "!",
      "2": "@",
      "3": "#",
      "4": "$",
      "5": "%",
      "6": "^",
      "7": "&",
      "8": "*",
      "9": "(",
      "0": ")",
      "-": "_",
      "=": "+",
      ";": ":",
      "'": "\"",
      ",": "<",
      ".": ">",
      "/": "?",
      "\\": "|"
    }
  };
  keyHandler = function(handleObj) {
    var keys, origHandler;
    if (typeof handleObj.data !== "string") {
      return;
    }
    origHandler = handleObj.handler;
    keys = handleObj.data.toLowerCase().split(" ");
    return handleObj.handler = function(event) {
      var character, key, modif, possible, special, _i, _len;
      if (this !== event.target && (/textarea|select/i.test(event.target.nodeName) || event.target.type === "text" || event.target.type === "password")) {
        return;
      }
      special = event.type !== "keypress" && jQuery.hotkeys.specialKeys[event.which];
      character = String.fromCharCode(event.which).toLowerCase();
      modif = "";
      possible = {};
      if (event.altKey && special !== "alt") {
        modif += "alt+";
      }
      if (event.ctrlKey && special !== "ctrl") {
        modif += "ctrl+";
      }
      if (event.metaKey && !event.ctrlKey && special !== "meta") {
        modif += "meta+";
      }
      if (event.shiftKey && special !== "shift") {
        modif += "shift+";
      }
      if (special) {
        possible[modif + special] = true;
      } else {
        possible[modif + character] = true;
        possible[modif + jQuery.hotkeys.shiftNums[character]] = true;
        if (modif === "shift+") {
          possible[jQuery.hotkeys.shiftNums[character]] = true;
        }
      }
      for (_i = 0, _len = keys.length; _i < _len; _i++) {
        key = keys[_i];
        if (possible[key]) {
          return origHandler.apply(this, arguments);
        }
      }
    };
  };
  return jQuery.each(["keydown", "keyup", "keypress"], function() {
    return jQuery.event.special[this] = {
      add: keyHandler
    };
  });
})(jQuery);;
/**
Merges properties from objects into target without overiding.
First come, first served.

@return target
*/var __slice = Array.prototype.slice;
jQuery.extend({
  reverseMerge: function() {
    var name, object, objects, target, _i, _len;
    target = arguments[0], objects = 2 <= arguments.length ? __slice.call(arguments, 1) : [];
    for (_i = 0, _len = objects.length; _i < _len; _i++) {
      object = objects[_i];
      for (name in object) {
        if (!target.hasOwnProperty(name)) {
          target[name] = object[name];
        }
      }
    }
    return target;
  }
});;
$(function() {
  /**
  The global keydown property lets your query the status of keys.

  <pre>
  # Examples:

  if keydown.left
    moveLeft()

  if keydown.a or keydown.space
    attack()

  if keydown.return
    confirm()

  if keydown.esc
    cancel()

  </pre>

  @name keydown
  @namespace
  */  var keyName, prevKeysDown;
  window.keydown = {};
  window.justPressed = {};
  prevKeysDown = {};
  keyName = function(event) {
    return jQuery.hotkeys.specialKeys[event.which] || String.fromCharCode(event.which).toLowerCase();
  };
  $(document).bind("keydown", function(event) {
    var key;
    key = keyName(event);
    return keydown[key] = true;
  });
  $(document).bind("keyup", function(event) {
    var key;
    key = keyName(event);
    return keydown[key] = false;
  });
  return window.updateKeys = function() {
    var key, value, _results;
    window.justPressed = {};
    for (key in keydown) {
      value = keydown[key];
      if (!prevKeysDown[key]) {
        justPressed[key] = value;
      }
    }
    prevKeysDown = {};
    _results = [];
    for (key in keydown) {
      value = keydown[key];
      _results.push(prevKeysDown[key] = value);
    }
    return _results;
  };
});;
var __slice = Array.prototype.slice;
(function($) {
  return $.fn.powerCanvas = function(options) {
    var $canvas, canvas, context;
    options || (options = {});
    canvas = this.get(0);
    context = void 0;
    /**
    * PowerCanvas provides a convenient wrapper for working with Context2d.
    * @name PowerCanvas
    * @constructor
    */
    $canvas = $(canvas).extend((function() {
      /**
       * Passes this canvas to the block with the given matrix transformation
       * applied. All drawing methods called within the block will draw
       * into the canvas with the transformation applied. The transformation
       * is removed at the end of the block, even if the block throws an error.
       *
       * @name withTransform
       * @methodOf PowerCanvas#
       *
       * @param {Matrix} matrix
       * @param {Function} block
       * @returns this
      */
    })(), {
      withTransform: function(matrix, block) {
        context.save();
        context.transform(matrix.a, matrix.b, matrix.c, matrix.d, matrix.tx, matrix.ty);
        try {
          block(this);
        } finally {
          context.restore();
        }
        return this;
      },
      clear: function() {
        context.clearRect(0, 0, canvas.width, canvas.height);
        return this;
      },
      clearRect: function(x, y, width, height) {
        context.clearRect(x, y, width, height);
        return this;
      },
      context: function() {
        return context;
      },
      element: function() {
        return canvas;
      },
      globalAlpha: function(newVal) {
        if (newVal != null) {
          context.globalAlpha = newVal;
          return this;
        } else {
          return context.globalAlpha;
        }
      },
      compositeOperation: function(newVal) {
        if (newVal != null) {
          context.globalCompositeOperation = newVal;
          return this;
        } else {
          return context.globalCompositeOperation;
        }
      },
      createLinearGradient: function(x0, y0, x1, y1) {
        return context.createLinearGradient(x0, y0, x1, y1);
      },
      createRadialGradient: function(x0, y0, r0, x1, y1, r1) {
        return context.createRadialGradient(x0, y0, r0, x1, y1, r1);
      },
      buildRadialGradient: function(c1, c2, stops) {
        var color, gradient, position;
        gradient = context.createRadialGradient(c1.x, c1.y, c1.radius, c2.x, c2.y, c2.radius);
        for (position in stops) {
          color = stops[position];
          gradient.addColorStop(position, color);
        }
        return gradient;
      },
      createPattern: function(image, repitition) {
        return context.createPattern(image, repitition);
      },
      drawImage: function(image, sx, sy, sWidth, sHeight, dx, dy, dWidth, dHeight) {
        context.drawImage(image, sx, sy, sWidth, sHeight, dx, dy, dWidth, dHeight);
        return this;
      },
      drawLine: function(x1, y1, x2, y2, width) {
        if (arguments.length === 3) {
          width = x2;
          x2 = y1.x;
          y2 = y1.y;
          y1 = x1.y;
          x1 = x1.x;
        }
        width || (width = 3);
        context.lineWidth = width;
        context.beginPath();
        context.moveTo(x1, y1);
        context.lineTo(x2, y2);
        context.closePath();
        context.stroke();
        return this;
      },
      fill: function(color) {
        $canvas.fillColor(color);
        context.fillRect(0, 0, canvas.width, canvas.height);
        return this;
      }
    }, (function() {
      /**
       * Fills a circle at the specified position with the specified
       * radius and color.
       *
       * @name fillCircle
       * @methodOf PowerCanvas#
       *
       * @param {Number} x
       * @param {Number} y
       * @param {Number} radius
       * @param {Number} color
       * @see PowerCanvas#fillColor 
       * @returns this
      */
    })(), {
      fillCircle: function(x, y, radius, color) {
        $canvas.fillColor(color);
        context.beginPath();
        context.arc(x, y, radius, 0, Math.TAU, true);
        context.closePath();
        context.fill();
        return this;
      }
    }, (function() {
      /**
       * Fills a rectangle with the current fillColor
       * at the specified position with the specified
       * width and height 

       * @name fillRect
       * @methodOf PowerCanvas#
       *
       * @param {Number} x
       * @param {Number} y
       * @param {Number} width
       * @param {Number} height
       * @see PowerCanvas#fillColor 
       * @returns this
      */
    })(), {
      fillRect: function(x, y, width, height) {
        context.fillRect(x, y, width, height);
        return this;
      },
      fillShape: function() {
        var points;
        points = 1 <= arguments.length ? __slice.call(arguments, 0) : [];
        context.beginPath();
        points.each(function(point, i) {
          if (i === 0) {
            return context.moveTo(point.x, point.y);
          } else {
            return context.lineTo(point.x, point.y);
          }
        });
        context.lineTo(points[0].x, points[0].y);
        return context.fill();
      }
    }, (function() {
      /**
      * Adapted from http://js-bits.blogspot.com/2010/07/canvas-rounded-corner-rectangles.html
      */
    })(), {
      fillRoundRect: function(x, y, width, height, radius, strokeWidth) {
        radius || (radius = 5);
        context.beginPath();
        context.moveTo(x + radius, y);
        context.lineTo(x + width - radius, y);
        context.quadraticCurveTo(x + width, y, x + width, y + radius);
        context.lineTo(x + width, y + height - radius);
        context.quadraticCurveTo(x + width, y + height, x + width - radius, y + height);
        context.lineTo(x + radius, y + height);
        context.quadraticCurveTo(x, y + height, x, y + height - radius);
        context.lineTo(x, y + radius);
        context.quadraticCurveTo(x, y, x + radius, y);
        context.closePath();
        if (strokeWidth) {
          context.lineWidth = strokeWidth;
          context.stroke();
        }
        context.fill();
        return this;
      },
      fillText: function(text, x, y) {
        context.fillText(text, x, y);
        return this;
      },
      centerText: function(text, y) {
        var textWidth;
        textWidth = $canvas.measureText(text);
        return $canvas.fillText(text, (canvas.width - textWidth) / 2, y);
      },
      fillWrappedText: function(text, x, y, width) {
        var lineHeight, tokens, tokens2;
        tokens = text.split(" ");
        tokens2 = text.split(" ");
        lineHeight = 16;
        if ($canvas.measureText(text) > width) {
          if (tokens.length % 2 === 0) {
            tokens2 = tokens.splice(tokens.length / 2, tokens.length / 2, "");
          } else {
            tokens2 = tokens.splice(tokens.length / 2 + 1, (tokens.length / 2) + 1, "");
          }
          context.fillText(tokens.join(" "), x, y);
          return context.fillText(tokens2.join(" "), x, y + lineHeight);
        } else {
          return context.fillText(tokens.join(" "), x, y + lineHeight);
        }
      },
      fillColor: function(color) {
        if (color) {
          if (color.channels) {
            context.fillStyle = color.toString();
          } else {
            context.fillStyle = color;
          }
          return this;
        } else {
          return context.fillStyle;
        }
      },
      font: function(font) {
        if (font != null) {
          context.font = font;
          return this;
        } else {
          return context.font;
        }
      },
      measureText: function(text) {
        return context.measureText(text).width;
      },
      putImageData: function(imageData, x, y) {
        context.putImageData(imageData, x, y);
        return this;
      },
      strokeColor: function(color) {
        if (color) {
          if (color.channels) {
            context.strokeStyle = color.toString();
          } else {
            context.strokeStyle = color;
          }
          return this;
        } else {
          return context.strokeStyle;
        }
      },
      strokeCircle: function(x, y, radius, color) {
        $canvas.strokeColor(color);
        context.beginPath();
        context.arc(x, y, radius, 0, Math.TAU, true);
        context.closePath();
        context.stroke();
        return this;
      },
      strokeRect: function(x, y, width, height) {
        context.strokeRect(x, y, width, height);
        return this;
      },
      textAlign: function(textAlign) {
        context.textAlign = textAlign;
        return this;
      },
      height: function() {
        return canvas.height;
      },
      width: function() {
        return canvas.width;
      }
    });
    if (canvas != null ? canvas.getContext : void 0) {
      context = canvas.getContext('2d');
      if (options.init) {
        options.init($canvas);
      }
      return $canvas;
    }
  };
})(jQuery);;
window.requestAnimationFrame || (window.requestAnimationFrame = window.webkitRequestAnimationFrame || window.mozRequestAnimationFrame || window.oRequestAnimationFrame || window.msRequestAnimationFrame || function(callback, element) {
  return window.setTimeout(function() {
    return callback(+new Date());
  }, 1000 / 60);
});;
(function($) {
  var Sound, directory, format, loadSoundChannel, sounds, _ref;
  directory = (typeof App !== "undefined" && App !== null ? (_ref = App.directories) != null ? _ref.sounds : void 0 : void 0) || "sounds";
  format = "wav";
  sounds = {};
  loadSoundChannel = function(name) {
    var sound, url;
    url = "" + BASE_URL + "/" + directory + "/" + name + "." + format;
    return sound = $('<audio />', {
      autobuffer: true,
      preload: 'auto',
      src: url
    }).get(0);
  };
  Sound = function(id, maxChannels) {
    return {
      play: function() {
        return Sound.play(id, maxChannels);
      },
      stop: function() {
        return Sound.stop(id);
      }
    };
  };
  return Object.extend(Sound, {
    play: function(id, maxChannels) {
      var channel, channels, freeChannels, sound;
      maxChannels || (maxChannels = 4);
      if (!sounds[id]) {
        sounds[id] = [loadSoundChannel(id)];
      }
      channels = sounds[id];
      freeChannels = $.grep(channels, function(sound) {
        return sound.currentTime === sound.duration || sound.currentTime === 0;
      });
      if (channel = freeChannels.first()) {
        try {
          channel.currentTime = 0;
        } catch (_e) {}
        return channel.play();
      } else {
        if (!maxChannels || channels.length < maxChannels) {
          sound = loadSoundChannel(id);
          channels.push(sound);
          return sound.play();
        }
      }
    },
    playFromUrl: function(url) {
      var sound;
      sound = $('<audio />').get(0);
      sound.src = url;
      sound.play();
      return sound;
    },
    stop: function(id) {
      var _ref2;
      return (_ref2 = sounds[id]) != null ? _ref2.stop() : void 0;
    }
  }, (typeof exports !== "undefined" && exports !== null ? exports : this)["Sound"] = Sound);
})(jQuery);;
(function() {
  /**
  @name Local
  @namespace
  */
  /**
  Store an object in local storage.

  @name set
  @methodOf Local

  @param {String} key
  @param {Object} value
  @type Object
  @returns value
  */  var retrieve, store;
  store = function(key, value) {
    localStorage[key] = JSON.stringify(value);
    return value;
  };
  /**
  Retrieve an object from local storage.

  @name get
  @methodOf Local

  @param {String} key
  @type Object
  @returns The object that was stored or undefined if no object was stored.
  */
  retrieve = function(key) {
    var value;
    value = localStorage[key];
    if (value != null) {
      return JSON.parse(value);
    }
  };
  return (typeof exports !== "undefined" && exports !== null ? exports : this)["Local"] = {
    get: retrieve,
    set: store,
    put: store,
    /**
    Access an instance of Local with a specified prefix.

    @name new
    @methodOf Local

    @param {String} prefix
    @type Local
    @returns An interface to local storage with the given prefix applied.
    */
    "new": function(prefix) {
      prefix || (prefix = "");
      return {
        get: function(key) {
          return retrieve("" + prefix + "_key");
        },
        set: function(key, value) {
          return store("" + prefix + "_key", value);
        },
        put: function(key, value) {
          return store("" + prefix + "_key", value);
        }
      };
    }
  };
})();;
;
