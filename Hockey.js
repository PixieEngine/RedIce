var App;
App = {
  "directories": {
    "animations": "animations",
    "data": "data",
    "entities": "entities",
    "images": "images",
    "lib": "lib",
    "sounds": "sounds",
    "source": "src",
    "test": "test",
    "tilemaps": "tilemaps"
  },
  "width": 1024,
  "height": 768,
  "library": false,
  "main": "main",
  "wrapMain": true,
  "hotSwap": true,
  "name": "Hockey",
  "author": "STRd6",
  "libs": {
    "gamelib.js": "https://github.com/STRd6/gamelib/raw/pixie/gamelib.js"
  }
};;
;
;
;
/**
Returns a copy of the array without null and undefined values.

@name compact
@methodOf Array#
@type Array
@returns An array that contains only the non-null values.
*/var __slice = Array.prototype.slice;
Array.prototype.compact = function() {
  return this.select(function(element) {
    return element != null;
  });
};
/**
Creates and returns a copy of the array. The copy contains
the same objects.

@name copy
@methodOf Array#
@type Array
@returns A new array that is a copy of the array
*/
Array.prototype.copy = function() {
  return this.concat();
};
/**
Empties the array of its contents. It is modified in place.

@name clear
@methodOf Array#
@type Array
@returns this, now emptied.
*/
Array.prototype.clear = function() {
  this.length = 0;
  return this;
};
/**
Flatten out an array of arrays into a single array of elements.

@name flatten
@methodOf Array#
@type Array
@returns A new array with all the sub-arrays flattened to the top.
*/
Array.prototype.flatten = function() {
  return this.inject([], function(a, b) {
    return a.concat(b);
  });
};
/**
Invoke the named method on each element in the array
and return a new array containing the results of the invocation.

<code><pre>
  [1.1, 2.2, 3.3, 4.4].invoke("floor")
  => [1, 2, 3, 4]

  ['hello', 'world', 'cool!'].invoke('substring', 0, 3)
  => ['hel', 'wor', 'coo']
</pre></code>

@param {String} method The name of the method to invoke.
@param [arg...] Optional arguments to pass to the method being invoked.

@name invoke
@methodOf Array#
@type Array
@returns A new array containing the results of invoking the 
named method on each element.
*/
Array.prototype.invoke = function() {
  var args, method;
  method = arguments[0], args = 2 <= arguments.length ? __slice.call(arguments, 1) : [];
  return this.map(function(element) {
    return element[method].apply(element, args);
  });
};
/**
Randomly select an element from the array.

@name rand
@methodOf Array#
@type Object
@returns A random element from an array
*/
Array.prototype.rand = function() {
  return this[rand(this.length)];
};
/**
Remove the first occurance of the given object from the array if it is
present.

@name remove
@methodOf Array#
@param {Object} object The object to remove from the array if present.
@returns The removed object if present otherwise undefined.
*/
Array.prototype.remove = function(object) {
  var index;
  index = this.indexOf(object);
  if (index >= 0) {
    return this.splice(index, 1)[0];
  } else {
    return;
  }
};
/**
Returns true if the element is present in the array.

@name include
@methodOf Array#
@param {Object} element The element to check if present.
@returns true if the element is in the array, false otherwise.
@type Boolean
*/
Array.prototype.include = function(element) {
  return this.indexOf(element) !== -1;
};
/**
Call the given iterator once for each element in the array,
passing in the element as the first argument, the index of 
the element as the second argument, and this array as the
third argument.

@name each
@methodOf Array#
@param {Function} iterator Function to be called once for 
each element in the array.
@param {Object} [context] Optional context parameter to be 
used as `this` when calling the iterator function.

@type Array
@returns this to enable method chaining.
*/
Array.prototype.each = function(iterator, context) {
  var element, i, _len;
  if (this.forEach) {
    this.forEach(iterator, context);
  } else {
    for (i = 0, _len = this.length; i < _len; i++) {
      element = this[i];
      iterator.call(context, element, i, this);
    }
  }
  return this;
};
/**
Call the given iterator once for each pair of objects in the array.

Ex. [1, 2, 3, 4].eachPair (a, b) ->
  # 1, 2
  # 1, 3
  # 1, 4
  # 2, 3
  # 2, 4
  # 3, 4 

@name eachPair
@methodOf Array#
@param {Function} iterator Function to be called once for 
each pair of elements in the array.
@param {Object} [context] Optional context parameter to be 
used as `this` when calling the iterator function.
*/
Array.prototype.eachPair = function(iterator, context) {
  var a, b, i, j, length, _results;
  length = this.length;
  i = 0;
  _results = [];
  while (i < length) {
    a = this[i];
    j = i + 1;
    i += 1;
    _results.push((function() {
      var _results2;
      _results2 = [];
      while (j < length) {
        b = this[j];
        j += 1;
        _results2.push(iterator.call(context, a, b));
      }
      return _results2;
    }).call(this));
  }
  return _results;
};
/**
Call the given iterator once for each element in the array,
passing in the element as the first argument and the given object
as the second argument. Additional arguments are passed similar to
<code>each</code>

@see Array#each

@name eachWithObject
@methodOf Array#

@param {Object} object The object to pass to the iterator on each
visit.
@param {Function} iterator Function to be called once for 
each element in the array.
@param {Object} [context] Optional context parameter to be 
used as `this` when calling the iterator function.

@returns this
@type Array
*/
Array.prototype.eachWithObject = function(object, iterator, context) {
  this.each(function(element, i, self) {
    return iterator.call(context, element, object, i, self);
  });
  return object;
};
/**
Call the given iterator once for each group of elements in the array,
passing in the elements in groups of n. Additional argumens are
passed as in <code>each</each>.

@see Array#each

@name eachSlice
@methodOf Array#

@param {Number} n The number of elements in each group.
@param {Function} iterator Function to be called once for 
each group of elements in the array.
@param {Object} [context] Optional context parameter to be 
used as `this` when calling the iterator function.

@returns this
@type Array
*/
Array.prototype.eachSlice = function(n, iterator, context) {
  var i, len;
  if (n > 0) {
    len = (this.length / n).floor();
    i = -1;
    while (++i < len) {
      iterator.call(context, this.slice(i * n, (i + 1) * n), i * n, this);
    }
  }
  return this;
};
/**
Returns a new array with the elements all shuffled up.

@name shuffle
@methodOf Array#

@returns A new array that is randomly shuffled.
@type Array
*/
Array.prototype.shuffle = function() {
  var shuffledArray;
  shuffledArray = [];
  this.each(function(element) {
    return shuffledArray.splice(rand(shuffledArray.length + 1), 0, element);
  });
  return shuffledArray;
};
/**
Returns the first element of the array, undefined if the array is empty.

@name first
@methodOf Array#

@returns The first element, or undefined if the array is empty.
@type Object
*/
Array.prototype.first = function() {
  return this[0];
};
/**
Returns the last element of the array, undefined if the array is empty.

@name last
@methodOf Array#

@returns The last element, or undefined if the array is empty.
@type Object
*/
Array.prototype.last = function() {
  return this[this.length - 1];
};
/**
Returns an object containing the extremes of this array.
<pre>
[-1, 3, 0].extremes() # => {min: -1, max: 3}
</pre>

@name extremes
@methodOf Array#

@param {Function} [fn] An optional funtion used to evaluate 
each element to calculate its value for determining extremes.
@returns {min: minElement, max: maxElement}
@type Object
*/
Array.prototype.extremes = function(fn) {
  var max, maxResult, min, minResult;
  fn || (fn = function(n) {
    return n;
  });
  min = max = void 0;
  minResult = maxResult = void 0;
  this.each(function(object) {
    var result;
    result = fn(object);
    if (min != null) {
      if (result < minResult) {
        min = object;
        minResult = result;
      }
    } else {
      min = object;
      minResult = result;
    }
    if (max != null) {
      if (result > maxResult) {
        max = object;
        return maxResult = result;
      }
    } else {
      max = object;
      return maxResult = result;
    }
  });
  return {
    min: min,
    max: max
  };
};
/**
Pretend the array is a circle and grab a new array containing length elements. 
If length is not given return the element at start, again assuming the array 
is a circle.

@name wrap
@methodOf Array#

@param {Number} start The index to start wrapping at, or the index of the 
sole element to return if no length is given.
@param {Number} [length] Optional length determines how long result 
array should be.
@returns The element at start mod array.length, or an array of length elements, 
starting from start and wrapping.
@type Object or Array
*/
Array.prototype.wrap = function(start, length) {
  var end, i, result;
  if (length != null) {
    end = start + length;
    i = start;
    result = [];
    while (i++ < end) {
      result.push(this[i.mod(this.length)]);
    }
    return result;
  } else {
    return this[start.mod(this.length)];
  }
};
/**
Partitions the elements into two groups: those for which the iterator returns
true, and those for which it returns false.

@name partition
@methodOf Array#

@param {Function} iterator
@param {Object} [context] Optional context parameter to be
used as `this` when calling the iterator function.

@type Array
@returns An array in the form of [trueCollection, falseCollection]
*/
Array.prototype.partition = function(iterator, context) {
  var falseCollection, trueCollection;
  trueCollection = [];
  falseCollection = [];
  this.each(function(element) {
    if (iterator.call(context, element)) {
      return trueCollection.push(element);
    } else {
      return falseCollection.push(element);
    }
  });
  return [trueCollection, falseCollection];
};
/**
Return the group of elements for which the return value of the iterator is true.

@name select
@methodOf Array#

@param {Function} iterator The iterator receives each element in turn as 
the first agument.
@param {Object} [context] Optional context parameter to be
used as `this` when calling the iterator function.

@type Array
@returns An array containing the elements for which the iterator returned true.
*/
Array.prototype.select = function(iterator, context) {
  return this.partition(iterator, context)[0];
};
/**
Return the group of elements that are not in the passed in set.

@name without
@methodOf Array#

@param {Array} values List of elements to exclude.

@type Array
@returns An array containing the elements that are not passed in.
*/
Array.prototype.without = function(values) {
  return this.reject(function(element) {
    return values.include(element);
  });
};
/**
Return the group of elements for which the return value of the iterator is false.

@name reject
@methodOf Array#

@param {Function} iterator The iterator receives each element in turn as 
the first agument.
@param {Object} [context] Optional context parameter to be
used as `this` when calling the iterator function.

@type Array
@returns An array containing the elements for which the iterator returned false.
*/
Array.prototype.reject = function(iterator, context) {
  return this.partition(iterator, context)[1];
};
/**
Combines all elements of the array by applying a binary operation.
for each element in the arra the iterator is passed an accumulator 
value (memo) and the element.

@name inject
@methodOf Array#

@type Object
@returns The result of a
*/
Array.prototype.inject = function(initial, iterator) {
  this.each(function(element) {
    return initial = iterator(initial, element);
  });
  return initial;
};
/**
Add all the elements in the array.

@name sum
@methodOf Array#

@type Number
@returns The sum of the elements in the array.
*/
Array.prototype.sum = function() {
  return this.inject(0, function(sum, n) {
    return sum + n;
  });
};
/**
Multiply all the elements in the array.

@name product
@methodOf Array#

@type Number
@returns The product of the elements in the array.
*/
Array.prototype.product = function() {
  return this.inject(1, function(product, n) {
    return product * n;
  });
};
Array.prototype.zip = function() {
  var args;
  args = 1 <= arguments.length ? __slice.call(arguments, 0) : [];
  return this.map(function(element, index) {
    var output;
    output = args.map(function(arr) {
      return arr[index];
    });
    output.unshift(element);
    return output;
  });
};;
window.requestAnimationFrame || (window.requestAnimationFrame = window.webkitRequestAnimationFrame || window.mozRequestAnimationFrame || window.oRequestAnimationFrame || window.msRequestAnimationFrame || function(callback, element) {
  return window.setTimeout(function() {
    return callback(+new Date());
  }, 1000 / 60);
});;
var __slice = Array.prototype.slice;
(function() {
  var hslParser, hslToRgb, lookup, names, normalizeKey, parseHSL, parseHex, parseRGB, rgbParser, shiftLightness;
  rgbParser = /^rgba?\((\d{1,3}),\s*(\d{1,3}),\s*(\d{1,3}),?\s*(\d?\.?\d*)?\)$/;
  hslParser = /^hsla?\((\d{1,3}),\s*(\d?\.?\d*),\s*(\d?\.?\d*),?\s*(\d?\.?\d*)?\)$/;
  parseHex = function(hexString) {
    var i, rgb;
    hexString = hexString.replace(/#/, '');
    switch (hexString.length) {
      case 3:
      case 4:
        rgb = (function() {
          var _results;
          _results = [];
          for (i = 0; i <= 2; i++) {
            _results.push(parseInt(hexString.substr(i, 1), 16) * 0x11);
          }
          return _results;
        })();
        return rgb.concat(hexString.substr(3, 1).length ? (parseInt(hexString.substr(3, 1), 16) * 0x11) / 255.0 : 1.0);
      case 6:
      case 8:
        rgb = (function() {
          var _results;
          _results = [];
          for (i = 0; i <= 2; i++) {
            _results.push(parseInt(hexString.substr(2 * i, 2), 16));
          }
          return _results;
        })();
        return rgb.concat(hexString.substr(6, 2).length ? parseInt(hexString.substr(6, 2), 16) / 255.0 : 1.0);
    }
  };
  parseRGB = function(colorString) {
    var bits, rgbMap;
    if (!(bits = rgbParser.exec(colorString))) {
      return;
    }
    rgbMap = bits.splice(1, 3).map(function(channel) {
      return parseFloat(channel);
    });
    return rgbMap.concat(bits[1] != null ? parseFloat(bits[1]) : 1.0);
  };
  parseHSL = function(colorString) {
    var bits, hslMap;
    if (!(bits = hslParser.exec(colorString))) {
      return;
    }
    hslMap = bits.splice(1, 3).map(function(channel) {
      return parseFloat(channel);
    });
    return hslToRgb(hslMap.concat(bits[1] != null ? parseFloat(bits[1]) : 1.0));
  };
  shiftLightness = function(amount, obj) {
    var hsl;
    hsl = obj.toHsl();
    hsl[2] = hsl[2] + amount;
    return Color(hslToRgb(hsl));
  };
  hslToRgb = function(hsl) {
    var a, b, g, h, hueToRgb, l, p, q, r, rgbMap, s;
    h = hsl[0] / 360.0;
    s = hsl[1];
    l = hsl[2];
    a = (hsl[3] ? parseFloat(hsl[3]) : 1.0);
    r = g = b = null;
    hueToRgb = function(p, q, t) {
      if (t < 0) {
        t += 1;
      }
      if (t > 1) {
        t -= 1;
      }
      if (t < 1 / 6) {
        return p + (q - p) * 6 * t;
      }
      if (t < 1 / 2) {
        return q;
      }
      if (t < 2 / 3) {
        return p + (q - p) * (2 / 3 - t) * 6;
      }
      return p;
    };
    if (s === 0) {
      r = g = b = l;
    } else {
      q = (l < 0.5 ? l * (1 + s) : l + s - l * s);
      p = 2 * l - q;
      r = hueToRgb(p, q, h + 1 / 3);
      g = hueToRgb(p, q, h);
      b = hueToRgb(p, q, h - 1 / 3);
      rgbMap = [r, g, b].map(function(channel) {
        return channel * 0xFF;
      });
    }
    return rgbMap.concat(a);
  };
  normalizeKey = function(key) {
    return key.toString().toLowerCase().split(' ').join('');
  };
  window.Color = function() {
    var alpha, args, arr, channels, color, parsedColor, rgbMap, self;
    args = 1 <= arguments.length ? __slice.call(arguments, 0) : [];
    color = args.first();
    if (color != null ? color.channels : void 0) {
      return Color(color.channels());
    }
    parsedColor = null;
    if (args.length === 0) {
      parsedColor = [0, 0, 0, 1];
    } else if (args.length === 1 && Object.isArray(args.first())) {
      arr = args.first();
      rgbMap = arr.splice(0, 3).map(function(channel) {
        return parseFloat(channel);
      });
      alpha = arr[0] != null ? parseFloat(arr[0]) : 1.0;
      parsedColor = rgbMap.concat(alpha);
    } else if (args.length === 2) {
      color = args[0];
      alpha = args[1];
      if (Object.isArray(color)) {
        rgbMap = color.splice(0, 3).map(function(channel) {
          return parseFloat(channel);
        });
        parsedColor = rgbMap.concat(parseFloat(alpha));
      } else {
        parsedColor = lookup[normalizeKey(color)] || parseHex(color) || parseRGB(color) || parseHSL(color);
        parsedColor[3] = alpha;
      }
    } else if (args.length > 2) {
      rgbMap = args.splice(0, 3).map(function(channel) {
        return parseFloat(channel);
      });
      alpha = args.first() != null ? args.first() : 1.0;
      parsedColor = rgbMap.concat(parseFloat(alpha));
    } else {
      color = args.first().toString();
      parsedColor = lookup[normalizeKey(color)] || parseHex(color) || parseRGB(color) || parseHSL(color);
    }
    if (!parsedColor) {
      throw "" + (args.join(',')) + " is an unknown color";
    }
    rgbMap = parsedColor.splice(0, 3).map(function(channel) {
      return channel.round();
    });
    alpha = (parsedColor.first() != null ? parseFloat(parsedColor.first()) : 1.0);
    channels = rgbMap.concat(alpha);
    self = {
      channels: function() {
        return channels.copy();
      },
      r: function(val) {
        if (val != null) {
          channels[0] = val;
          return self;
        } else {
          return channels[0];
        }
      },
      g: function(val) {
        if (val != null) {
          channels[1] = val;
          return self;
        } else {
          return channels[1];
        }
      },
      b: function(val) {
        if (val != null) {
          channels[2] = val;
          return self;
        } else {
          return channels[2];
        }
      },
      a: function(val) {
        if (val != null) {
          channels[3] = val;
          return self;
        } else {
          return channels[3];
        }
      },
      equals: function(other) {
        return other.r() === self.r() && other.g() === self.g() && other.b() === self.b() && other.a() === self.a();
      },
      lighten: function(amount) {
        return shiftLightness(amount, self);
      },
      darken: function(amount) {
        return shiftLightness(-amount, self);
      },
      rgba: function() {
        return "rgba(" + (self.r()) + ", " + (self.g()) + ", " + (self.b()) + ", " + (self.a()) + ")";
      },
      desaturate: function(amount) {
        var hsl;
        hsl = self.toHsl();
        hsl[1] -= amount;
        return Color(hslToRgb(hsl));
      },
      saturate: function(amount) {
        var hsl;
        hsl = self.toHsl();
        hsl[1] += amount;
        return Color(hslToRgb(hsl));
      },
      grayscale: function() {
        var g, hsl;
        hsl = self.toHsl();
        g = hsl[2] * 255;
        return Color(g, g, g);
      },
      hue: function(degrees) {
        var hsl;
        hsl = self.toHsl();
        hsl[0] = (hsl[0] + degrees) % 360;
        return Color(hslToRgb(hsl));
      },
      complement: function() {
        var hsl;
        hsl = self.toHsl();
        return self.hue(180);
      },
      toHex: function() {
        var hexFromNumber, hexString, padString;
        hexString = function(number) {
          return number.toString(16);
        };
        padString = function(hexString) {
          var pad;
          if (hexString.length === 1) {
            pad = "0";
          }
          return (pad || "") + hexString;
        };
        hexFromNumber = function(number) {
          return padString(hexString(number));
        };
        return "#" + (hexFromNumber(channels[0])) + (hexFromNumber(channels[1])) + (hexFromNumber(channels[2]));
      },
      toHsl: function() {
        var b, delta, g, hue, lightness, max, min, r, saturation, _ref;
        _ref = channels.map(function(channel) {
          return channel / 255.0;
        }), r = _ref[0], g = _ref[1], b = _ref[2];
        min = Math.min(r, g, b);
        max = Math.max(r, g, b);
        hue = saturation = lightness = (max + min) / 2.0;
        if (max === min) {
          hue = saturation = 0;
        } else {
          delta = max - min;
          saturation = (lightness > 0.5 ? delta / (2 - max - min) : delta / (max + min));
          switch (max) {
            case r:
              hue = (g - b) / delta + (g < b ? 6 : 0);
              break;
            case g:
              hue = (b - r) / delta + 2;
              break;
            case b:
              hue = (r - g) / delta + 4;
          }
          hue *= 60;
        }
        return [hue, saturation, lightness, channels[3]];
      },
      toString: function() {
        return self.rgba();
      }
    };
    return self;
  };
  lookup = {};
  names = [["000000", "Black"], ["000080", "Navy Blue"], ["0000C8", "Dark Blue"], ["0000FF", "Blue"], ["000741", "Stratos"], ["001B1C", "Swamp"], ["002387", "Resolution Blue"], ["002900", "Deep Fir"], ["002E20", "Burnham"], ["002FA7", "International Klein Blue"], ["003153", "Prussian Blue"], ["003366", "Midnight Blue"], ["003399", "Smalt"], ["003532", "Deep Teal"], ["003E40", "Cyprus"], ["004620", "Kaitoke Green"], ["0047AB", "Cobalt"], ["004816", "Crusoe"], ["004950", "Sherpa Blue"], ["0056A7", "Endeavour"], ["00581A", "Camarone"], ["0066CC", "Science Blue"], ["0066FF", "Blue Ribbon"], ["00755E", "Tropical Rain Forest"], ["0076A3", "Allports"], ["007BA7", "Deep Cerulean"], ["007EC7", "Lochmara"], ["007FFF", "Azure Radiance"], ["008080", "Teal"], ["0095B6", "Bondi Blue"], ["009DC4", "Pacific Blue"], ["00A693", "Persian Green"], ["00A86B", "Jade"], ["00CC99", "Caribbean Green"], ["00CCCC", "Robin's Egg Blue"], ["00FF00", "Green"], ["00FF7F", "Spring Green"], ["00FFFF", "Cyan / Aqua"], ["010D1A", "Blue Charcoal"], ["011635", "Midnight"], ["011D13", "Holly"], ["012731", "Daintree"], ["01361C", "Cardin Green"], ["01371A", "County Green"], ["013E62", "Astronaut Blue"], ["013F6A", "Regal Blue"], ["014B43", "Aqua Deep"], ["015E85", "Orient"], ["016162", "Blue Stone"], ["016D39", "Fun Green"], ["01796F", "Pine Green"], ["017987", "Blue Lagoon"], ["01826B", "Deep Sea"], ["01A368", "Green Haze"], ["022D15", "English Holly"], ["02402C", "Sherwood Green"], ["02478E", "Congress Blue"], ["024E46", "Evening Sea"], ["026395", "Bahama Blue"], ["02866F", "Observatory"], ["02A4D3", "Cerulean"], ["03163C", "Tangaroa"], ["032B52", "Green Vogue"], ["036A6E", "Mosque"], ["041004", "Midnight Moss"], ["041322", "Black Pearl"], ["042E4C", "Blue Whale"], ["044022", "Zuccini"], ["044259", "Teal Blue"], ["051040", "Deep Cove"], ["051657", "Gulf Blue"], ["055989", "Venice Blue"], ["056F57", "Watercourse"], ["062A78", "Catalina Blue"], ["063537", "Tiber"], ["069B81", "Gossamer"], ["06A189", "Niagara"], ["073A50", "Tarawera"], ["080110", "Jaguar"], ["081910", "Black Bean"], ["082567", "Deep Sapphire"], ["088370", "Elf Green"], ["08E8DE", "Bright Turquoise"], ["092256", "Downriver"], ["09230F", "Palm Green"], ["09255D", "Madison"], ["093624", "Bottle Green"], ["095859", "Deep Sea Green"], ["097F4B", "Salem"], ["0A001C", "Black Russian"], ["0A480D", "Dark Fern"], ["0A6906", "Japanese Laurel"], ["0A6F75", "Atoll"], ["0B0B0B", "Cod Gray"], ["0B0F08", "Marshland"], ["0B1107", "Gordons Green"], ["0B1304", "Black Forest"], ["0B6207", "San Felix"], ["0BDA51", "Malachite"], ["0C0B1D", "Ebony"], ["0C0D0F", "Woodsmoke"], ["0C1911", "Racing Green"], ["0C7A79", "Surfie Green"], ["0C8990", "Blue Chill"], ["0D0332", "Black Rock"], ["0D1117", "Bunker"], ["0D1C19", "Aztec"], ["0D2E1C", "Bush"], ["0E0E18", "Cinder"], ["0E2A30", "Firefly"], ["0F2D9E", "Torea Bay"], ["10121D", "Vulcan"], ["101405", "Green Waterloo"], ["105852", "Eden"], ["110C6C", "Arapawa"], ["120A8F", "Ultramarine"], ["123447", "Elephant"], ["126B40", "Jewel"], ["130000", "Diesel"], ["130A06", "Asphalt"], ["13264D", "Blue Zodiac"], ["134F19", "Parsley"], ["140600", "Nero"], ["1450AA", "Tory Blue"], ["151F4C", "Bunting"], ["1560BD", "Denim"], ["15736B", "Genoa"], ["161928", "Mirage"], ["161D10", "Hunter Green"], ["162A40", "Big Stone"], ["163222", "Celtic"], ["16322C", "Timber Green"], ["163531", "Gable Green"], ["171F04", "Pine Tree"], ["175579", "Chathams Blue"], ["182D09", "Deep Forest Green"], ["18587A", "Blumine"], ["19330E", "Palm Leaf"], ["193751", "Nile Blue"], ["1959A8", "Fun Blue"], ["1A1A68", "Lucky Point"], ["1AB385", "Mountain Meadow"], ["1B0245", "Tolopea"], ["1B1035", "Haiti"], ["1B127B", "Deep Koamaru"], ["1B1404", "Acadia"], ["1B2F11", "Seaweed"], ["1B3162", "Biscay"], ["1B659D", "Matisse"], ["1C1208", "Crowshead"], ["1C1E13", "Rangoon Green"], ["1C39BB", "Persian Blue"], ["1C402E", "Everglade"], ["1C7C7D", "Elm"], ["1D6142", "Green Pea"], ["1E0F04", "Creole"], ["1E1609", "Karaka"], ["1E1708", "El Paso"], ["1E385B", "Cello"], ["1E433C", "Te Papa Green"], ["1E90FF", "Dodger Blue"], ["1E9AB0", "Eastern Blue"], ["1F120F", "Night Rider"], ["1FC2C2", "Java"], ["20208D", "Jacksons Purple"], ["202E54", "Cloud Burst"], ["204852", "Blue Dianne"], ["211A0E", "Eternity"], ["220878", "Deep Blue"], ["228B22", "Forest Green"], ["233418", "Mallard"], ["240A40", "Violet"], ["240C02", "Kilamanjaro"], ["242A1D", "Log Cabin"], ["242E16", "Black Olive"], ["24500F", "Green House"], ["251607", "Graphite"], ["251706", "Cannon Black"], ["251F4F", "Port Gore"], ["25272C", "Shark"], ["25311C", "Green Kelp"], ["2596D1", "Curious Blue"], ["260368", "Paua"], ["26056A", "Paris M"], ["261105", "Wood Bark"], ["261414", "Gondola"], ["262335", "Steel Gray"], ["26283B", "Ebony Clay"], ["273A81", "Bay of Many"], ["27504B", "Plantation"], ["278A5B", "Eucalyptus"], ["281E15", "Oil"], ["283A77", "Astronaut"], ["286ACD", "Mariner"], ["290C5E", "Violent Violet"], ["292130", "Bastille"], ["292319", "Zeus"], ["292937", "Charade"], ["297B9A", "Jelly Bean"], ["29AB87", "Jungle Green"], ["2A0359", "Cherry Pie"], ["2A140E", "Coffee Bean"], ["2A2630", "Baltic Sea"], ["2A380B", "Turtle Green"], ["2A52BE", "Cerulean Blue"], ["2B0202", "Sepia Black"], ["2B194F", "Valhalla"], ["2B3228", "Heavy Metal"], ["2C0E8C", "Blue Gem"], ["2C1632", "Revolver"], ["2C2133", "Bleached Cedar"], ["2C8C84", "Lochinvar"], ["2D2510", "Mikado"], ["2D383A", "Outer Space"], ["2D569B", "St Tropaz"], ["2E0329", "Jacaranda"], ["2E1905", "Jacko Bean"], ["2E3222", "Rangitoto"], ["2E3F62", "Rhino"], ["2E8B57", "Sea Green"], ["2EBFD4", "Scooter"], ["2F270E", "Onion"], ["2F3CB3", "Governor Bay"], ["2F519E", "Sapphire"], ["2F5A57", "Spectra"], ["2F6168", "Casal"], ["300529", "Melanzane"], ["301F1E", "Cocoa Brown"], ["302A0F", "Woodrush"], ["304B6A", "San Juan"], ["30D5C8", "Turquoise"], ["311C17", "Eclipse"], ["314459", "Pickled Bluewood"], ["315BA1", "Azure"], ["31728D", "Calypso"], ["317D82", "Paradiso"], ["32127A", "Persian Indigo"], ["32293A", "Blackcurrant"], ["323232", "Mine Shaft"], ["325D52", "Stromboli"], ["327C14", "Bilbao"], ["327DA0", "Astral"], ["33036B", "Christalle"], ["33292F", "Thunder"], ["33CC99", "Shamrock"], ["341515", "Tamarind"], ["350036", "Mardi Gras"], ["350E42", "Valentino"], ["350E57", "Jagger"], ["353542", "Tuna"], ["354E8C", "Chambray"], ["363050", "Martinique"], ["363534", "Tuatara"], ["363C0D", "Waiouru"], ["36747D", "Ming"], ["368716", "La Palma"], ["370202", "Chocolate"], ["371D09", "Clinker"], ["37290E", "Brown Tumbleweed"], ["373021", "Birch"], ["377475", "Oracle"], ["380474", "Blue Diamond"], ["381A51", "Grape"], ["383533", "Dune"], ["384555", "Oxford Blue"], ["384910", "Clover"], ["394851", "Limed Spruce"], ["396413", "Dell"], ["3A0020", "Toledo"], ["3A2010", "Sambuca"], ["3A2A6A", "Jacarta"], ["3A686C", "William"], ["3A6A47", "Killarney"], ["3AB09E", "Keppel"], ["3B000B", "Temptress"], ["3B0910", "Aubergine"], ["3B1F1F", "Jon"], ["3B2820", "Treehouse"], ["3B7A57", "Amazon"], ["3B91B4", "Boston Blue"], ["3C0878", "Windsor"], ["3C1206", "Rebel"], ["3C1F76", "Meteorite"], ["3C2005", "Dark Ebony"], ["3C3910", "Camouflage"], ["3C4151", "Bright Gray"], ["3C4443", "Cape Cod"], ["3C493A", "Lunar Green"], ["3D0C02", "Bean  "], ["3D2B1F", "Bistre"], ["3D7D52", "Goblin"], ["3E0480", "Kingfisher Daisy"], ["3E1C14", "Cedar"], ["3E2B23", "English Walnut"], ["3E2C1C", "Black Marlin"], ["3E3A44", "Ship Gray"], ["3EABBF", "Pelorous"], ["3F2109", "Bronze"], ["3F2500", "Cola"], ["3F3002", "Madras"], ["3F307F", "Minsk"], ["3F4C3A", "Cabbage Pont"], ["3F583B", "Tom Thumb"], ["3F5D53", "Mineral Green"], ["3FC1AA", "Puerto Rico"], ["3FFF00", "Harlequin"], ["401801", "Brown Pod"], ["40291D", "Cork"], ["403B38", "Masala"], ["403D19", "Thatch Green"], ["405169", "Fiord"], ["40826D", "Viridian"], ["40A860", "Chateau Green"], ["410056", "Ripe Plum"], ["411F10", "Paco"], ["412010", "Deep Oak"], ["413C37", "Merlin"], ["414257", "Gun Powder"], ["414C7D", "East Bay"], ["4169E1", "Royal Blue"], ["41AA78", "Ocean Green"], ["420303", "Burnt Maroon"], ["423921", "Lisbon Brown"], ["427977", "Faded Jade"], ["431560", "Scarlet Gum"], ["433120", "Iroko"], ["433E37", "Armadillo"], ["434C59", "River Bed"], ["436A0D", "Green Leaf"], ["44012D", "Barossa"], ["441D00", "Morocco Brown"], ["444954", "Mako"], ["454936", "Kelp"], ["456CAC", "San Marino"], ["45B1E8", "Picton Blue"], ["460B41", "Loulou"], ["462425", "Crater Brown"], ["465945", "Gray Asparagus"], ["4682B4", "Steel Blue"], ["480404", "Rustic Red"], ["480607", "Bulgarian Rose"], ["480656", "Clairvoyant"], ["481C1C", "Cocoa Bean"], ["483131", "Woody Brown"], ["483C32", "Taupe"], ["49170C", "Van Cleef"], ["492615", "Brown Derby"], ["49371B", "Metallic Bronze"], ["495400", "Verdun Green"], ["496679", "Blue Bayoux"], ["497183", "Bismark"], ["4A2A04", "Bracken"], ["4A3004", "Deep Bronze"], ["4A3C30", "Mondo"], ["4A4244", "Tundora"], ["4A444B", "Gravel"], ["4A4E5A", "Trout"], ["4B0082", "Pigment Indigo"], ["4B5D52", "Nandor"], ["4C3024", "Saddle"], ["4C4F56", "Abbey"], ["4D0135", "Blackberry"], ["4D0A18", "Cab Sav"], ["4D1E01", "Indian Tan"], ["4D282D", "Cowboy"], ["4D282E", "Livid Brown"], ["4D3833", "Rock"], ["4D3D14", "Punga"], ["4D400F", "Bronzetone"], ["4D5328", "Woodland"], ["4E0606", "Mahogany"], ["4E2A5A", "Bossanova"], ["4E3B41", "Matterhorn"], ["4E420C", "Bronze Olive"], ["4E4562", "Mulled Wine"], ["4E6649", "Axolotl"], ["4E7F9E", "Wedgewood"], ["4EABD1", "Shakespeare"], ["4F1C70", "Honey Flower"], ["4F2398", "Daisy Bush"], ["4F69C6", "Indigo"], ["4F7942", "Fern Green"], ["4F9D5D", "Fruit Salad"], ["4FA83D", "Apple"], ["504351", "Mortar"], ["507096", "Kashmir Blue"], ["507672", "Cutty Sark"], ["50C878", "Emerald"], ["514649", "Emperor"], ["516E3D", "Chalet Green"], ["517C66", "Como"], ["51808F", "Smalt Blue"], ["52001F", "Castro"], ["520C17", "Maroon Oak"], ["523C94", "Gigas"], ["533455", "Voodoo"], ["534491", "Victoria"], ["53824B", "Hippie Green"], ["541012", "Heath"], ["544333", "Judge Gray"], ["54534D", "Fuscous Gray"], ["549019", "Vida Loca"], ["55280C", "Cioccolato"], ["555B10", "Saratoga"], ["556D56", "Finlandia"], ["5590D9", "Havelock Blue"], ["56B4BE", "Fountain Blue"], ["578363", "Spring Leaves"], ["583401", "Saddle Brown"], ["585562", "Scarpa Flow"], ["587156", "Cactus"], ["589AAF", "Hippie Blue"], ["591D35", "Wine Berry"], ["592804", "Brown Bramble"], ["593737", "Congo Brown"], ["594433", "Millbrook"], ["5A6E9C", "Waikawa Gray"], ["5A87A0", "Horizon"], ["5B3013", "Jambalaya"], ["5C0120", "Bordeaux"], ["5C0536", "Mulberry Wood"], ["5C2E01", "Carnaby Tan"], ["5C5D75", "Comet"], ["5D1E0F", "Redwood"], ["5D4C51", "Don Juan"], ["5D5C58", "Chicago"], ["5D5E37", "Verdigris"], ["5D7747", "Dingley"], ["5DA19F", "Breaker Bay"], ["5E483E", "Kabul"], ["5E5D3B", "Hemlock"], ["5F3D26", "Irish Coffee"], ["5F5F6E", "Mid Gray"], ["5F6672", "Shuttle Gray"], ["5FA777", "Aqua Forest"], ["5FB3AC", "Tradewind"], ["604913", "Horses Neck"], ["605B73", "Smoky"], ["606E68", "Corduroy"], ["6093D1", "Danube"], ["612718", "Espresso"], ["614051", "Eggplant"], ["615D30", "Costa Del Sol"], ["61845F", "Glade Green"], ["622F30", "Buccaneer"], ["623F2D", "Quincy"], ["624E9A", "Butterfly Bush"], ["625119", "West Coast"], ["626649", "Finch"], ["639A8F", "Patina"], ["63B76C", "Fern"], ["6456B7", "Blue Violet"], ["646077", "Dolphin"], ["646463", "Storm Dust"], ["646A54", "Siam"], ["646E75", "Nevada"], ["6495ED", "Cornflower Blue"], ["64CCDB", "Viking"], ["65000B", "Rosewood"], ["651A14", "Cherrywood"], ["652DC1", "Purple Heart"], ["657220", "Fern Frond"], ["65745D", "Willow Grove"], ["65869F", "Hoki"], ["660045", "Pompadour"], ["660099", "Purple"], ["66023C", "Tyrian Purple"], ["661010", "Dark Tan"], ["66B58F", "Silver Tree"], ["66FF00", "Bright Green"], ["66FF66", "Screamin' Green"], ["67032D", "Black Rose"], ["675FA6", "Scampi"], ["676662", "Ironside Gray"], ["678975", "Viridian Green"], ["67A712", "Christi"], ["683600", "Nutmeg Wood Finish"], ["685558", "Zambezi"], ["685E6E", "Salt Box"], ["692545", "Tawny Port"], ["692D54", "Finn"], ["695F62", "Scorpion"], ["697E9A", "Lynch"], ["6A442E", "Spice"], ["6A5D1B", "Himalaya"], ["6A6051", "Soya Bean"], ["6B2A14", "Hairy Heath"], ["6B3FA0", "Royal Purple"], ["6B4E31", "Shingle Fawn"], ["6B5755", "Dorado"], ["6B8BA2", "Bermuda Gray"], ["6B8E23", "Olive Drab"], ["6C3082", "Eminence"], ["6CDAE7", "Turquoise Blue"], ["6D0101", "Lonestar"], ["6D5E54", "Pine Cone"], ["6D6C6C", "Dove Gray"], ["6D9292", "Juniper"], ["6D92A1", "Gothic"], ["6E0902", "Red Oxide"], ["6E1D14", "Moccaccino"], ["6E4826", "Pickled Bean"], ["6E4B26", "Dallas"], ["6E6D57", "Kokoda"], ["6E7783", "Pale Sky"], ["6F440C", "Cafe Royale"], ["6F6A61", "Flint"], ["6F8E63", "Highland"], ["6F9D02", "Limeade"], ["6FD0C5", "Downy"], ["701C1C", "Persian Plum"], ["704214", "Sepia"], ["704A07", "Antique Bronze"], ["704F50", "Ferra"], ["706555", "Coffee"], ["708090", "Slate Gray"], ["711A00", "Cedar Wood Finish"], ["71291D", "Metallic Copper"], ["714693", "Affair"], ["714AB2", "Studio"], ["715D47", "Tobacco Brown"], ["716338", "Yellow Metal"], ["716B56", "Peat"], ["716E10", "Olivetone"], ["717486", "Storm Gray"], ["718080", "Sirocco"], ["71D9E2", "Aquamarine Blue"], ["72010F", "Venetian Red"], ["724A2F", "Old Copper"], ["726D4E", "Go Ben"], ["727B89", "Raven"], ["731E8F", "Seance"], ["734A12", "Raw Umber"], ["736C9F", "Kimberly"], ["736D58", "Crocodile"], ["737829", "Crete"], ["738678", "Xanadu"], ["74640D", "Spicy Mustard"], ["747D63", "Limed Ash"], ["747D83", "Rolling Stone"], ["748881", "Blue Smoke"], ["749378", "Laurel"], ["74C365", "Mantis"], ["755A57", "Russett"], ["7563A8", "Deluge"], ["76395D", "Cosmic"], ["7666C6", "Blue Marguerite"], ["76BD17", "Lima"], ["76D7EA", "Sky Blue"], ["770F05", "Dark Burgundy"], ["771F1F", "Crown of Thorns"], ["773F1A", "Walnut"], ["776F61", "Pablo"], ["778120", "Pacifika"], ["779E86", "Oxley"], ["77DD77", "Pastel Green"], ["780109", "Japanese Maple"], ["782D19", "Mocha"], ["782F16", "Peanut"], ["78866B", "Camouflage Green"], ["788A25", "Wasabi"], ["788BBA", "Ship Cove"], ["78A39C", "Sea Nymph"], ["795D4C", "Roman Coffee"], ["796878", "Old Lavender"], ["796989", "Rum"], ["796A78", "Fedora"], ["796D62", "Sandstone"], ["79DEEC", "Spray"], ["7A013A", "Siren"], ["7A58C1", "Fuchsia Blue"], ["7A7A7A", "Boulder"], ["7A89B8", "Wild Blue Yonder"], ["7AC488", "De York"], ["7B3801", "Red Beech"], ["7B3F00", "Cinnamon"], ["7B6608", "Yukon Gold"], ["7B7874", "Tapa"], ["7B7C94", "Waterloo "], ["7B8265", "Flax Smoke"], ["7B9F80", "Amulet"], ["7BA05B", "Asparagus"], ["7C1C05", "Kenyan Copper"], ["7C7631", "Pesto"], ["7C778A", "Topaz"], ["7C7B7A", "Concord"], ["7C7B82", "Jumbo"], ["7C881A", "Trendy Green"], ["7CA1A6", "Gumbo"], ["7CB0A1", "Acapulco"], ["7CB7BB", "Neptune"], ["7D2C14", "Pueblo"], ["7DA98D", "Bay Leaf"], ["7DC8F7", "Malibu"], ["7DD8C6", "Bermuda"], ["7E3A15", "Copper Canyon"], ["7F1734", "Claret"], ["7F3A02", "Peru Tan"], ["7F626D", "Falcon"], ["7F7589", "Mobster"], ["7F76D3", "Moody Blue"], ["7FFF00", "Chartreuse"], ["7FFFD4", "Aquamarine"], ["800000", "Maroon"], ["800B47", "Rose Bud Cherry"], ["801818", "Falu Red"], ["80341F", "Red Robin"], ["803790", "Vivid Violet"], ["80461B", "Russet"], ["807E79", "Friar Gray"], ["808000", "Olive"], ["808080", "Gray"], ["80B3AE", "Gulf Stream"], ["80B3C4", "Glacier"], ["80CCEA", "Seagull"], ["81422C", "Nutmeg"], ["816E71", "Spicy Pink"], ["817377", "Empress"], ["819885", "Spanish Green"], ["826F65", "Sand Dune"], ["828685", "Gunsmoke"], ["828F72", "Battleship Gray"], ["831923", "Merlot"], ["837050", "Shadow"], ["83AA5D", "Chelsea Cucumber"], ["83D0C6", "Monte Carlo"], ["843179", "Plum"], ["84A0A0", "Granny Smith"], ["8581D9", "Chetwode Blue"], ["858470", "Bandicoot"], ["859FAF", "Bali Hai"], ["85C4CC", "Half Baked"], ["860111", "Red Devil"], ["863C3C", "Lotus"], ["86483C", "Ironstone"], ["864D1E", "Bull Shot"], ["86560A", "Rusty Nail"], ["868974", "Bitter"], ["86949F", "Regent Gray"], ["871550", "Disco"], ["87756E", "Americano"], ["877C7B", "Hurricane"], ["878D91", "Oslo Gray"], ["87AB39", "Sushi"], ["885342", "Spicy Mix"], ["886221", "Kumera"], ["888387", "Suva Gray"], ["888D65", "Avocado"], ["893456", "Camelot"], ["893843", "Solid Pink"], ["894367", "Cannon Pink"], ["897D6D", "Makara"], ["8A3324", "Burnt Umber"], ["8A73D6", "True V"], ["8A8360", "Clay Creek"], ["8A8389", "Monsoon"], ["8A8F8A", "Stack"], ["8AB9F1", "Jordy Blue"], ["8B00FF", "Electric Violet"], ["8B0723", "Monarch"], ["8B6B0B", "Corn Harvest"], ["8B8470", "Olive Haze"], ["8B847E", "Schooner"], ["8B8680", "Natural Gray"], ["8B9C90", "Mantle"], ["8B9FEE", "Portage"], ["8BA690", "Envy"], ["8BA9A5", "Cascade"], ["8BE6D8", "Riptide"], ["8C055E", "Cardinal Pink"], ["8C472F", "Mule Fawn"], ["8C5738", "Potters Clay"], ["8C6495", "Trendy Pink"], ["8D0226", "Paprika"], ["8D3D38", "Sanguine Brown"], ["8D3F3F", "Tosca"], ["8D7662", "Cement"], ["8D8974", "Granite Green"], ["8D90A1", "Manatee"], ["8DA8CC", "Polo Blue"], ["8E0000", "Red Berry"], ["8E4D1E", "Rope"], ["8E6F70", "Opium"], ["8E775E", "Domino"], ["8E8190", "Mamba"], ["8EABC1", "Nepal"], ["8F021C", "Pohutukawa"], ["8F3E33", "El Salva"], ["8F4B0E", "Korma"], ["8F8176", "Squirrel"], ["8FD6B4", "Vista Blue"], ["900020", "Burgundy"], ["901E1E", "Old Brick"], ["907874", "Hemp"], ["907B71", "Almond Frost"], ["908D39", "Sycamore"], ["92000A", "Sangria"], ["924321", "Cumin"], ["926F5B", "Beaver"], ["928573", "Stonewall"], ["928590", "Venus"], ["9370DB", "Medium Purple"], ["93CCEA", "Cornflower"], ["93DFB8", "Algae Green"], ["944747", "Copper Rust"], ["948771", "Arrowtown"], ["950015", "Scarlett"], ["956387", "Strikemaster"], ["959396", "Mountain Mist"], ["960018", "Carmine"], ["964B00", "Brown"], ["967059", "Leather"], ["9678B6", "Purple Mountain's Majesty"], ["967BB6", "Lavender Purple"], ["96A8A1", "Pewter"], ["96BBAB", "Summer Green"], ["97605D", "Au Chico"], ["9771B5", "Wisteria"], ["97CD2D", "Atlantis"], ["983D61", "Vin Rouge"], ["9874D3", "Lilac Bush"], ["98777B", "Bazaar"], ["98811B", "Hacienda"], ["988D77", "Pale Oyster"], ["98FF98", "Mint Green"], ["990066", "Fresh Eggplant"], ["991199", "Violet Eggplant"], ["991613", "Tamarillo"], ["991B07", "Totem Pole"], ["996666", "Copper Rose"], ["9966CC", "Amethyst"], ["997A8D", "Mountbatten Pink"], ["9999CC", "Blue Bell"], ["9A3820", "Prairie Sand"], ["9A6E61", "Toast"], ["9A9577", "Gurkha"], ["9AB973", "Olivine"], ["9AC2B8", "Shadow Green"], ["9B4703", "Oregon"], ["9B9E8F", "Lemon Grass"], ["9C3336", "Stiletto"], ["9D5616", "Hawaiian Tan"], ["9DACB7", "Gull Gray"], ["9DC209", "Pistachio"], ["9DE093", "Granny Smith Apple"], ["9DE5FF", "Anakiwa"], ["9E5302", "Chelsea Gem"], ["9E5B40", "Sepia Skin"], ["9EA587", "Sage"], ["9EA91F", "Citron"], ["9EB1CD", "Rock Blue"], ["9EDEE0", "Morning Glory"], ["9F381D", "Cognac"], ["9F821C", "Reef Gold"], ["9F9F9C", "Star Dust"], ["9FA0B1", "Santas Gray"], ["9FD7D3", "Sinbad"], ["9FDD8C", "Feijoa"], ["A02712", "Tabasco"], ["A1750D", "Buttered Rum"], ["A1ADB5", "Hit Gray"], ["A1C50A", "Citrus"], ["A1DAD7", "Aqua Island"], ["A1E9DE", "Water Leaf"], ["A2006D", "Flirt"], ["A23B6C", "Rouge"], ["A26645", "Cape Palliser"], ["A2AAB3", "Gray Chateau"], ["A2AEAB", "Edward"], ["A3807B", "Pharlap"], ["A397B4", "Amethyst Smoke"], ["A3E3ED", "Blizzard Blue"], ["A4A49D", "Delta"], ["A4A6D3", "Wistful"], ["A4AF6E", "Green Smoke"], ["A50B5E", "Jazzberry Jam"], ["A59B91", "Zorba"], ["A5CB0C", "Bahia"], ["A62F20", "Roof Terracotta"], ["A65529", "Paarl"], ["A68B5B", "Barley Corn"], ["A69279", "Donkey Brown"], ["A6A29A", "Dawn"], ["A72525", "Mexican Red"], ["A7882C", "Luxor Gold"], ["A85307", "Rich Gold"], ["A86515", "Reno Sand"], ["A86B6B", "Coral Tree"], ["A8989B", "Dusty Gray"], ["A899E6", "Dull Lavender"], ["A8A589", "Tallow"], ["A8AE9C", "Bud"], ["A8AF8E", "Locust"], ["A8BD9F", "Norway"], ["A8E3BD", "Chinook"], ["A9A491", "Gray Olive"], ["A9ACB6", "Aluminium"], ["A9B2C3", "Cadet Blue"], ["A9B497", "Schist"], ["A9BDBF", "Tower Gray"], ["A9BEF2", "Perano"], ["A9C6C2", "Opal"], ["AA375A", "Night Shadz"], ["AA4203", "Fire"], ["AA8B5B", "Muesli"], ["AA8D6F", "Sandal"], ["AAA5A9", "Shady Lady"], ["AAA9CD", "Logan"], ["AAABB7", "Spun Pearl"], ["AAD6E6", "Regent St Blue"], ["AAF0D1", "Magic Mint"], ["AB0563", "Lipstick"], ["AB3472", "Royal Heath"], ["AB917A", "Sandrift"], ["ABA0D9", "Cold Purple"], ["ABA196", "Bronco"], ["AC8A56", "Limed Oak"], ["AC91CE", "East Side"], ["AC9E22", "Lemon Ginger"], ["ACA494", "Napa"], ["ACA586", "Hillary"], ["ACA59F", "Cloudy"], ["ACACAC", "Silver Chalice"], ["ACB78E", "Swamp Green"], ["ACCBB1", "Spring Rain"], ["ACDD4D", "Conifer"], ["ACE1AF", "Celadon"], ["AD781B", "Mandalay"], ["ADBED1", "Casper"], ["ADDFAD", "Moss Green"], ["ADE6C4", "Padua"], ["ADFF2F", "Green Yellow"], ["AE4560", "Hippie Pink"], ["AE6020", "Desert"], ["AE809E", "Bouquet"], ["AF4035", "Medium Carmine"], ["AF4D43", "Apple Blossom"], ["AF593E", "Brown Rust"], ["AF8751", "Driftwood"], ["AF8F2C", "Alpine"], ["AF9F1C", "Lucky"], ["AFA09E", "Martini"], ["AFB1B8", "Bombay"], ["AFBDD9", "Pigeon Post"], ["B04C6A", "Cadillac"], ["B05D54", "Matrix"], ["B05E81", "Tapestry"], ["B06608", "Mai Tai"], ["B09A95", "Del Rio"], ["B0E0E6", "Powder Blue"], ["B0E313", "Inch Worm"], ["B10000", "Bright Red"], ["B14A0B", "Vesuvius"], ["B1610B", "Pumpkin Skin"], ["B16D52", "Santa Fe"], ["B19461", "Teak"], ["B1E2C1", "Fringy Flower"], ["B1F4E7", "Ice Cold"], ["B20931", "Shiraz"], ["B2A1EA", "Biloba Flower"], ["B32D29", "Tall Poppy"], ["B35213", "Fiery Orange"], ["B38007", "Hot Toddy"], ["B3AF95", "Taupe Gray"], ["B3C110", "La Rioja"], ["B43332", "Well Read"], ["B44668", "Blush"], ["B4CFD3", "Jungle Mist"], ["B57281", "Turkish Rose"], ["B57EDC", "Lavender"], ["B5A27F", "Mongoose"], ["B5B35C", "Olive Green"], ["B5D2CE", "Jet Stream"], ["B5ECDF", "Cruise"], ["B6316C", "Hibiscus"], ["B69D98", "Thatch"], ["B6B095", "Heathered Gray"], ["B6BAA4", "Eagle"], ["B6D1EA", "Spindle"], ["B6D3BF", "Gum Leaf"], ["B7410E", "Rust"], ["B78E5C", "Muddy Waters"], ["B7A214", "Sahara"], ["B7A458", "Husk"], ["B7B1B1", "Nobel"], ["B7C3D0", "Heather"], ["B7F0BE", "Madang"], ["B81104", "Milano Red"], ["B87333", "Copper"], ["B8B56A", "Gimblet"], ["B8C1B1", "Green Spring"], ["B8C25D", "Celery"], ["B8E0F9", "Sail"], ["B94E48", "Chestnut"], ["B95140", "Crail"], ["B98D28", "Marigold"], ["B9C46A", "Wild Willow"], ["B9C8AC", "Rainee"], ["BA0101", "Guardsman Red"], ["BA450C", "Rock Spray"], ["BA6F1E", "Bourbon"], ["BA7F03", "Pirate Gold"], ["BAB1A2", "Nomad"], ["BAC7C9", "Submarine"], ["BAEEF9", "Charlotte"], ["BB3385", "Medium Red Violet"], ["BB8983", "Brandy Rose"], ["BBD009", "Rio Grande"], ["BBD7C1", "Surf"], ["BCC9C2", "Powder Ash"], ["BD5E2E", "Tuscany"], ["BD978E", "Quicksand"], ["BDB1A8", "Silk"], ["BDB2A1", "Malta"], ["BDB3C7", "Chatelle"], ["BDBBD7", "Lavender Gray"], ["BDBDC6", "French Gray"], ["BDC8B3", "Clay Ash"], ["BDC9CE", "Loblolly"], ["BDEDFD", "French Pass"], ["BEA6C3", "London Hue"], ["BEB5B7", "Pink Swan"], ["BEDE0D", "Fuego"], ["BF5500", "Rose of Sharon"], ["BFB8B0", "Tide"], ["BFBED8", "Blue Haze"], ["BFC1C2", "Silver Sand"], ["BFC921", "Key Lime Pie"], ["BFDBE2", "Ziggurat"], ["BFFF00", "Lime"], ["C02B18", "Thunderbird"], ["C04737", "Mojo"], ["C08081", "Old Rose"], ["C0C0C0", "Silver"], ["C0D3B9", "Pale Leaf"], ["C0D8B6", "Pixie Green"], ["C1440E", "Tia Maria"], ["C154C1", "Fuchsia Pink"], ["C1A004", "Buddha Gold"], ["C1B7A4", "Bison Hide"], ["C1BAB0", "Tea"], ["C1BECD", "Gray Suit"], ["C1D7B0", "Sprout"], ["C1F07C", "Sulu"], ["C26B03", "Indochine"], ["C2955D", "Twine"], ["C2BDB6", "Cotton Seed"], ["C2CAC4", "Pumice"], ["C2E8E5", "Jagged Ice"], ["C32148", "Maroon Flush"], ["C3B091", "Indian Khaki"], ["C3BFC1", "Pale Slate"], ["C3C3BD", "Gray Nickel"], ["C3CDE6", "Periwinkle Gray"], ["C3D1D1", "Tiara"], ["C3DDF9", "Tropical Blue"], ["C41E3A", "Cardinal"], ["C45655", "Fuzzy Wuzzy Brown"], ["C45719", "Orange Roughy"], ["C4C4BC", "Mist Gray"], ["C4D0B0", "Coriander"], ["C4F4EB", "Mint Tulip"], ["C54B8C", "Mulberry"], ["C59922", "Nugget"], ["C5994B", "Tussock"], ["C5DBCA", "Sea Mist"], ["C5E17A", "Yellow Green"], ["C62D42", "Brick Red"], ["C6726B", "Contessa"], ["C69191", "Oriental Pink"], ["C6A84B", "Roti"], ["C6C3B5", "Ash"], ["C6C8BD", "Kangaroo"], ["C6E610", "Las Palmas"], ["C7031E", "Monza"], ["C71585", "Red Violet"], ["C7BCA2", "Coral Reef"], ["C7C1FF", "Melrose"], ["C7C4BF", "Cloud"], ["C7C9D5", "Ghost"], ["C7CD90", "Pine Glade"], ["C7DDE5", "Botticelli"], ["C88A65", "Antique Brass"], ["C8A2C8", "Lilac"], ["C8A528", "Hokey Pokey"], ["C8AABF", "Lily"], ["C8B568", "Laser"], ["C8E3D7", "Edgewater"], ["C96323", "Piper"], ["C99415", "Pizza"], ["C9A0DC", "Light Wisteria"], ["C9B29B", "Rodeo Dust"], ["C9B35B", "Sundance"], ["C9B93B", "Earls Green"], ["C9C0BB", "Silver Rust"], ["C9D9D2", "Conch"], ["C9FFA2", "Reef"], ["C9FFE5", "Aero Blue"], ["CA3435", "Flush Mahogany"], ["CABB48", "Turmeric"], ["CADCD4", "Paris White"], ["CAE00D", "Bitter Lemon"], ["CAE6DA", "Skeptic"], ["CB8FA9", "Viola"], ["CBCAB6", "Foggy Gray"], ["CBD3B0", "Green Mist"], ["CBDBD6", "Nebula"], ["CC3333", "Persian Red"], ["CC5500", "Burnt Orange"], ["CC7722", "Ochre"], ["CC8899", "Puce"], ["CCCAA8", "Thistle Green"], ["CCCCFF", "Periwinkle"], ["CCFF00", "Electric Lime"], ["CD5700", "Tenn"], ["CD5C5C", "Chestnut Rose"], ["CD8429", "Brandy Punch"], ["CDF4FF", "Onahau"], ["CEB98F", "Sorrell Brown"], ["CEBABA", "Cold Turkey"], ["CEC291", "Yuma"], ["CEC7A7", "Chino"], ["CFA39D", "Eunry"], ["CFB53B", "Old Gold"], ["CFDCCF", "Tasman"], ["CFE5D2", "Surf Crest"], ["CFF9F3", "Humming Bird"], ["CFFAF4", "Scandal"], ["D05F04", "Red Stage"], ["D06DA1", "Hopbush"], ["D07D12", "Meteor"], ["D0BEF8", "Perfume"], ["D0C0E5", "Prelude"], ["D0F0C0", "Tea Green"], ["D18F1B", "Geebung"], ["D1BEA8", "Vanilla"], ["D1C6B4", "Soft Amber"], ["D1D2CA", "Celeste"], ["D1D2DD", "Mischka"], ["D1E231", "Pear"], ["D2691E", "Hot Cinnamon"], ["D27D46", "Raw Sienna"], ["D29EAA", "Careys Pink"], ["D2B48C", "Tan"], ["D2DA97", "Deco"], ["D2F6DE", "Blue Romance"], ["D2F8B0", "Gossip"], ["D3CBBA", "Sisal"], ["D3CDC5", "Swirl"], ["D47494", "Charm"], ["D4B6AF", "Clam Shell"], ["D4BF8D", "Straw"], ["D4C4A8", "Akaroa"], ["D4CD16", "Bird Flower"], ["D4D7D9", "Iron"], ["D4DFE2", "Geyser"], ["D4E2FC", "Hawkes Blue"], ["D54600", "Grenadier"], ["D591A4", "Can Can"], ["D59A6F", "Whiskey"], ["D5D195", "Winter Hazel"], ["D5F6E3", "Granny Apple"], ["D69188", "My Pink"], ["D6C562", "Tacha"], ["D6CEF6", "Moon Raker"], ["D6D6D1", "Quill Gray"], ["D6FFDB", "Snowy Mint"], ["D7837F", "New York Pink"], ["D7C498", "Pavlova"], ["D7D0FF", "Fog"], ["D84437", "Valencia"], ["D87C63", "Japonica"], ["D8BFD8", "Thistle"], ["D8C2D5", "Maverick"], ["D8FCFA", "Foam"], ["D94972", "Cabaret"], ["D99376", "Burning Sand"], ["D9B99B", "Cameo"], ["D9D6CF", "Timberwolf"], ["D9DCC1", "Tana"], ["D9E4F5", "Link Water"], ["D9F7FF", "Mabel"], ["DA3287", "Cerise"], ["DA5B38", "Flame Pea"], ["DA6304", "Bamboo"], ["DA6A41", "Red Damask"], ["DA70D6", "Orchid"], ["DA8A67", "Copperfield"], ["DAA520", "Golden Grass"], ["DAECD6", "Zanah"], ["DAF4F0", "Iceberg"], ["DAFAFF", "Oyster Bay"], ["DB5079", "Cranberry"], ["DB9690", "Petite Orchid"], ["DB995E", "Di Serria"], ["DBDBDB", "Alto"], ["DBFFF8", "Frosted Mint"], ["DC143C", "Crimson"], ["DC4333", "Punch"], ["DCB20C", "Galliano"], ["DCB4BC", "Blossom"], ["DCD747", "Wattle"], ["DCD9D2", "Westar"], ["DCDDCC", "Moon Mist"], ["DCEDB4", "Caper"], ["DCF0EA", "Swans Down"], ["DDD6D5", "Swiss Coffee"], ["DDF9F1", "White Ice"], ["DE3163", "Cerise Red"], ["DE6360", "Roman"], ["DEA681", "Tumbleweed"], ["DEBA13", "Gold Tips"], ["DEC196", "Brandy"], ["DECBC6", "Wafer"], ["DED4A4", "Sapling"], ["DED717", "Barberry"], ["DEE5C0", "Beryl Green"], ["DEF5FF", "Pattens Blue"], ["DF73FF", "Heliotrope"], ["DFBE6F", "Apache"], ["DFCD6F", "Chenin"], ["DFCFDB", "Lola"], ["DFECDA", "Willow Brook"], ["DFFF00", "Chartreuse Yellow"], ["E0B0FF", "Mauve"], ["E0B646", "Anzac"], ["E0B974", "Harvest Gold"], ["E0C095", "Calico"], ["E0FFFF", "Baby Blue"], ["E16865", "Sunglo"], ["E1BC64", "Equator"], ["E1C0C8", "Pink Flare"], ["E1E6D6", "Periglacial Blue"], ["E1EAD4", "Kidnapper"], ["E1F6E8", "Tara"], ["E25465", "Mandy"], ["E2725B", "Terracotta"], ["E28913", "Golden Bell"], ["E292C0", "Shocking"], ["E29418", "Dixie"], ["E29CD2", "Light Orchid"], ["E2D8ED", "Snuff"], ["E2EBED", "Mystic"], ["E2F3EC", "Apple Green"], ["E30B5C", "Razzmatazz"], ["E32636", "Alizarin Crimson"], ["E34234", "Cinnabar"], ["E3BEBE", "Cavern Pink"], ["E3F5E1", "Peppermint"], ["E3F988", "Mindaro"], ["E47698", "Deep Blush"], ["E49B0F", "Gamboge"], ["E4C2D5", "Melanie"], ["E4CFDE", "Twilight"], ["E4D1C0", "Bone"], ["E4D422", "Sunflower"], ["E4D5B7", "Grain Brown"], ["E4D69B", "Zombie"], ["E4F6E7", "Frostee"], ["E4FFD1", "Snow Flurry"], ["E52B50", "Amaranth"], ["E5841B", "Zest"], ["E5CCC9", "Dust Storm"], ["E5D7BD", "Stark White"], ["E5D8AF", "Hampton"], ["E5E0E1", "Bon Jour"], ["E5E5E5", "Mercury"], ["E5F9F6", "Polar"], ["E64E03", "Trinidad"], ["E6BE8A", "Gold Sand"], ["E6BEA5", "Cashmere"], ["E6D7B9", "Double Spanish White"], ["E6E4D4", "Satin Linen"], ["E6F2EA", "Harp"], ["E6F8F3", "Off Green"], ["E6FFE9", "Hint of Green"], ["E6FFFF", "Tranquil"], ["E77200", "Mango Tango"], ["E7730A", "Christine"], ["E79F8C", "Tonys Pink"], ["E79FC4", "Kobi"], ["E7BCB4", "Rose Fog"], ["E7BF05", "Corn"], ["E7CD8C", "Putty"], ["E7ECE6", "Gray Nurse"], ["E7F8FF", "Lily White"], ["E7FEFF", "Bubbles"], ["E89928", "Fire Bush"], ["E8B9B3", "Shilo"], ["E8E0D5", "Pearl Bush"], ["E8EBE0", "Green White"], ["E8F1D4", "Chrome White"], ["E8F2EB", "Gin"], ["E8F5F2", "Aqua Squeeze"], ["E96E00", "Clementine"], ["E97451", "Burnt Sienna"], ["E97C07", "Tahiti Gold"], ["E9CECD", "Oyster Pink"], ["E9D75A", "Confetti"], ["E9E3E3", "Ebb"], ["E9F8ED", "Ottoman"], ["E9FFFD", "Clear Day"], ["EA88A8", "Carissma"], ["EAAE69", "Porsche"], ["EAB33B", "Tulip Tree"], ["EAC674", "Rob Roy"], ["EADAB8", "Raffia"], ["EAE8D4", "White Rock"], ["EAF6EE", "Panache"], ["EAF6FF", "Solitude"], ["EAF9F5", "Aqua Spring"], ["EAFFFE", "Dew"], ["EB9373", "Apricot"], ["EBC2AF", "Zinnwaldite"], ["ECA927", "Fuel Yellow"], ["ECC54E", "Ronchi"], ["ECC7EE", "French Lilac"], ["ECCDB9", "Just Right"], ["ECE090", "Wild Rice"], ["ECEBBD", "Fall Green"], ["ECEBCE", "Aths Special"], ["ECF245", "Starship"], ["ED0A3F", "Red Ribbon"], ["ED7A1C", "Tango"], ["ED9121", "Carrot Orange"], ["ED989E", "Sea Pink"], ["EDB381", "Tacao"], ["EDC9AF", "Desert Sand"], ["EDCDAB", "Pancho"], ["EDDCB1", "Chamois"], ["EDEA99", "Primrose"], ["EDF5DD", "Frost"], ["EDF5F5", "Aqua Haze"], ["EDF6FF", "Zumthor"], ["EDF9F1", "Narvik"], ["EDFC84", "Honeysuckle"], ["EE82EE", "Lavender Magenta"], ["EEC1BE", "Beauty Bush"], ["EED794", "Chalky"], ["EED9C4", "Almond"], ["EEDC82", "Flax"], ["EEDEDA", "Bizarre"], ["EEE3AD", "Double Colonial White"], ["EEEEE8", "Cararra"], ["EEEF78", "Manz"], ["EEF0C8", "Tahuna Sands"], ["EEF0F3", "Athens Gray"], ["EEF3C3", "Tusk"], ["EEF4DE", "Loafer"], ["EEF6F7", "Catskill White"], ["EEFDFF", "Twilight Blue"], ["EEFF9A", "Jonquil"], ["EEFFE2", "Rice Flower"], ["EF863F", "Jaffa"], ["EFEFEF", "Gallery"], ["EFF2F3", "Porcelain"], ["F091A9", "Mauvelous"], ["F0D52D", "Golden Dream"], ["F0DB7D", "Golden Sand"], ["F0DC82", "Buff"], ["F0E2EC", "Prim"], ["F0E68C", "Khaki"], ["F0EEFD", "Selago"], ["F0EEFF", "Titan White"], ["F0F8FF", "Alice Blue"], ["F0FCEA", "Feta"], ["F18200", "Gold Drop"], ["F19BAB", "Wewak"], ["F1E788", "Sahara Sand"], ["F1E9D2", "Parchment"], ["F1E9FF", "Blue Chalk"], ["F1EEC1", "Mint Julep"], ["F1F1F1", "Seashell"], ["F1F7F2", "Saltpan"], ["F1FFAD", "Tidal"], ["F1FFC8", "Chiffon"], ["F2552A", "Flamingo"], ["F28500", "Tangerine"], ["F2C3B2", "Mandys Pink"], ["F2F2F2", "Concrete"], ["F2FAFA", "Black Squeeze"], ["F34723", "Pomegranate"], ["F3AD16", "Buttercup"], ["F3D69D", "New Orleans"], ["F3D9DF", "Vanilla Ice"], ["F3E7BB", "Sidecar"], ["F3E9E5", "Dawn Pink"], ["F3EDCF", "Wheatfield"], ["F3FB62", "Canary"], ["F3FBD4", "Orinoco"], ["F3FFD8", "Carla"], ["F400A1", "Hollywood Cerise"], ["F4A460", "Sandy brown"], ["F4C430", "Saffron"], ["F4D81C", "Ripe Lemon"], ["F4EBD3", "Janna"], ["F4F2EE", "Pampas"], ["F4F4F4", "Wild Sand"], ["F4F8FF", "Zircon"], ["F57584", "Froly"], ["F5C85C", "Cream Can"], ["F5C999", "Manhattan"], ["F5D5A0", "Maize"], ["F5DEB3", "Wheat"], ["F5E7A2", "Sandwisp"], ["F5E7E2", "Pot Pourri"], ["F5E9D3", "Albescent White"], ["F5EDEF", "Soft Peach"], ["F5F3E5", "Ecru White"], ["F5F5DC", "Beige"], ["F5FB3D", "Golden Fizz"], ["F5FFBE", "Australian Mint"], ["F64A8A", "French Rose"], ["F653A6", "Brilliant Rose"], ["F6A4C9", "Illusion"], ["F6F0E6", "Merino"], ["F6F7F7", "Black Haze"], ["F6FFDC", "Spring Sun"], ["F7468A", "Violet Red"], ["F77703", "Chilean Fire"], ["F77FBE", "Persian Pink"], ["F7B668", "Rajah"], ["F7C8DA", "Azalea"], ["F7DBE6", "We Peep"], ["F7F2E1", "Quarter Spanish White"], ["F7F5FA", "Whisper"], ["F7FAF7", "Snow Drift"], ["F8B853", "Casablanca"], ["F8C3DF", "Chantilly"], ["F8D9E9", "Cherub"], ["F8DB9D", "Marzipan"], ["F8DD5C", "Energy Yellow"], ["F8E4BF", "Givry"], ["F8F0E8", "White Linen"], ["F8F4FF", "Magnolia"], ["F8F6F1", "Spring Wood"], ["F8F7DC", "Coconut Cream"], ["F8F7FC", "White Lilac"], ["F8F8F7", "Desert Storm"], ["F8F99C", "Texas"], ["F8FACD", "Corn Field"], ["F8FDD3", "Mimosa"], ["F95A61", "Carnation"], ["F9BF58", "Saffron Mango"], ["F9E0ED", "Carousel Pink"], ["F9E4BC", "Dairy Cream"], ["F9E663", "Portica"], ["F9E6F4", "Underage Pink"], ["F9EAF3", "Amour"], ["F9F8E4", "Rum Swizzle"], ["F9FF8B", "Dolly"], ["F9FFF6", "Sugar Cane"], ["FA7814", "Ecstasy"], ["FA9D5A", "Tan Hide"], ["FAD3A2", "Corvette"], ["FADFAD", "Peach Yellow"], ["FAE600", "Turbo"], ["FAEAB9", "Astra"], ["FAECCC", "Champagne"], ["FAF0E6", "Linen"], ["FAF3F0", "Fantasy"], ["FAF7D6", "Citrine White"], ["FAFAFA", "Alabaster"], ["FAFDE4", "Hint of Yellow"], ["FAFFA4", "Milan"], ["FB607F", "Brink Pink"], ["FB8989", "Geraldine"], ["FBA0E3", "Lavender Rose"], ["FBA129", "Sea Buckthorn"], ["FBAC13", "Sun"], ["FBAED2", "Lavender Pink"], ["FBB2A3", "Rose Bud"], ["FBBEDA", "Cupid"], ["FBCCE7", "Classic Rose"], ["FBCEB1", "Apricot Peach"], ["FBE7B2", "Banana Mania"], ["FBE870", "Marigold Yellow"], ["FBE96C", "Festival"], ["FBEA8C", "Sweet Corn"], ["FBEC5D", "Candy Corn"], ["FBF9F9", "Hint of Red"], ["FBFFBA", "Shalimar"], ["FC0FC0", "Shocking Pink"], ["FC80A5", "Tickle Me Pink"], ["FC9C1D", "Tree Poppy"], ["FCC01E", "Lightning Yellow"], ["FCD667", "Goldenrod"], ["FCD917", "Candlelight"], ["FCDA98", "Cherokee"], ["FCF4D0", "Double Pearl Lusta"], ["FCF4DC", "Pearl Lusta"], ["FCF8F7", "Vista White"], ["FCFBF3", "Bianca"], ["FCFEDA", "Moon Glow"], ["FCFFE7", "China Ivory"], ["FCFFF9", "Ceramic"], ["FD0E35", "Torch Red"], ["FD5B78", "Wild Watermelon"], ["FD7B33", "Crusta"], ["FD7C07", "Sorbus"], ["FD9FA2", "Sweet Pink"], ["FDD5B1", "Light Apricot"], ["FDD7E4", "Pig Pink"], ["FDE1DC", "Cinderella"], ["FDE295", "Golden Glow"], ["FDE910", "Lemon"], ["FDF5E6", "Old Lace"], ["FDF6D3", "Half Colonial White"], ["FDF7AD", "Drover"], ["FDFEB8", "Pale Prim"], ["FDFFD5", "Cumulus"], ["FE28A2", "Persian Rose"], ["FE4C40", "Sunset Orange"], ["FE6F5E", "Bittersweet"], ["FE9D04", "California"], ["FEA904", "Yellow Sea"], ["FEBAAD", "Melon"], ["FED33C", "Bright Sun"], ["FED85D", "Dandelion"], ["FEDB8D", "Salomie"], ["FEE5AC", "Cape Honey"], ["FEEBF3", "Remy"], ["FEEFCE", "Oasis"], ["FEF0EC", "Bridesmaid"], ["FEF2C7", "Beeswax"], ["FEF3D8", "Bleach White"], ["FEF4CC", "Pipi"], ["FEF4DB", "Half Spanish White"], ["FEF4F8", "Wisp Pink"], ["FEF5F1", "Provincial Pink"], ["FEF7DE", "Half Dutch White"], ["FEF8E2", "Solitaire"], ["FEF8FF", "White Pointer"], ["FEF9E3", "Off Yellow"], ["FEFCED", "Orange White"], ["FF0000", "Red"], ["FF007F", "Rose"], ["FF00CC", "Purple Pizzazz"], ["FF00FF", "Magenta / Fuchsia"], ["FF2400", "Scarlet"], ["FF3399", "Wild Strawberry"], ["FF33CC", "Razzle Dazzle Rose"], ["FF355E", "Radical Red"], ["FF3F34", "Red Orange"], ["FF4040", "Coral Red"], ["FF4D00", "Vermilion"], ["FF4F00", "International Orange"], ["FF6037", "Outrageous Orange"], ["FF6600", "Blaze Orange"], ["FF66FF", "Pink Flamingo"], ["FF681F", "Orange"], ["FF69B4", "Hot Pink"], ["FF6B53", "Persimmon"], ["FF6FFF", "Blush Pink"], ["FF7034", "Burning Orange"], ["FF7518", "Pumpkin"], ["FF7D07", "Flamenco"], ["FF7F00", "Flush Orange"], ["FF7F50", "Coral"], ["FF8C69", "Salmon"], ["FF9000", "Pizazz"], ["FF910F", "West Side"], ["FF91A4", "Pink Salmon"], ["FF9933", "Neon Carrot"], ["FF9966", "Atomic Tangerine"], ["FF9980", "Vivid Tangerine"], ["FF9E2C", "Sunshade"], ["FFA000", "Orange Peel"], ["FFA194", "Mona Lisa"], ["FFA500", "Web Orange"], ["FFA6C9", "Carnation Pink"], ["FFAB81", "Hit Pink"], ["FFAE42", "Yellow Orange"], ["FFB0AC", "Cornflower Lilac"], ["FFB1B3", "Sundown"], ["FFB31F", "My Sin"], ["FFB555", "Texas Rose"], ["FFB7D5", "Cotton Candy"], ["FFB97B", "Macaroni and Cheese"], ["FFBA00", "Selective Yellow"], ["FFBD5F", "Koromiko"], ["FFBF00", "Amber"], ["FFC0A8", "Wax Flower"], ["FFC0CB", "Pink"], ["FFC3C0", "Your Pink"], ["FFC901", "Supernova"], ["FFCBA4", "Flesh"], ["FFCC33", "Sunglow"], ["FFCC5C", "Golden Tainoi"], ["FFCC99", "Peach Orange"], ["FFCD8C", "Chardonnay"], ["FFD1DC", "Pastel Pink"], ["FFD2B7", "Romantic"], ["FFD38C", "Grandis"], ["FFD700", "Gold"], ["FFD800", "School bus Yellow"], ["FFD8D9", "Cosmos"], ["FFDB58", "Mustard"], ["FFDCD6", "Peach Schnapps"], ["FFDDAF", "Caramel"], ["FFDDCD", "Tuft Bush"], ["FFDDCF", "Watusi"], ["FFDDF4", "Pink Lace"], ["FFDEAD", "Navajo White"], ["FFDEB3", "Frangipani"], ["FFE1DF", "Pippin"], ["FFE1F2", "Pale Rose"], ["FFE2C5", "Negroni"], ["FFE5A0", "Cream Brulee"], ["FFE5B4", "Peach"], ["FFE6C7", "Tequila"], ["FFE772", "Kournikova"], ["FFEAC8", "Sandy Beach"], ["FFEAD4", "Karry"], ["FFEC13", "Broom"], ["FFEDBC", "Colonial White"], ["FFEED8", "Derby"], ["FFEFA1", "Vis Vis"], ["FFEFC1", "Egg White"], ["FFEFD5", "Papaya Whip"], ["FFEFEC", "Fair Pink"], ["FFF0DB", "Peach Cream"], ["FFF0F5", "Lavender blush"], ["FFF14F", "Gorse"], ["FFF1B5", "Buttermilk"], ["FFF1D8", "Pink Lady"], ["FFF1EE", "Forget Me Not"], ["FFF1F9", "Tutu"], ["FFF39D", "Picasso"], ["FFF3F1", "Chardon"], ["FFF46E", "Paris Daisy"], ["FFF4CE", "Barley White"], ["FFF4DD", "Egg Sour"], ["FFF4E0", "Sazerac"], ["FFF4E8", "Serenade"], ["FFF4F3", "Chablis"], ["FFF5EE", "Seashell Peach"], ["FFF5F3", "Sauvignon"], ["FFF6D4", "Milk Punch"], ["FFF6DF", "Varden"], ["FFF6F5", "Rose White"], ["FFF8D1", "Baja White"], ["FFF9E2", "Gin Fizz"], ["FFF9E6", "Early Dawn"], ["FFFACD", "Lemon Chiffon"], ["FFFAF4", "Bridal Heath"], ["FFFBDC", "Scotch Mist"], ["FFFBF9", "Soapstone"], ["FFFC99", "Witch Haze"], ["FFFCEA", "Buttery White"], ["FFFCEE", "Island Spice"], ["FFFDD0", "Cream"], ["FFFDE6", "Chilean Heath"], ["FFFDE8", "Travertine"], ["FFFDF3", "Orchid White"], ["FFFDF4", "Quarter Pearl Lusta"], ["FFFEE1", "Half and Half"], ["FFFEEC", "Apricot White"], ["FFFEF0", "Rice Cake"], ["FFFEF6", "Black White"], ["FFFEFD", "Romance"], ["FFFF00", "Yellow"], ["FFFF66", "Laser Lemon"], ["FFFF99", "Pale Canary"], ["FFFFB4", "Portafino"], ["FFFFF0", "Ivory"], ["FFFFFF", "White"], ["acc2d9", "cloudy blue"], ["56ae57", "dark pastel green"], ["b2996e", "dust"], ["a8ff04", "electric lime"], ["69d84f", "fresh green"], ["894585", "light eggplant"], ["70b23f", "nasty green"], ["d4ffff", "really light blue"], ["65ab7c", "tea"], ["952e8f", "warm purple"], ["fcfc81", "yellowish tan"], ["a5a391", "cement"], ["388004", "dark grass green"], ["4c9085", "dusty teal"], ["5e9b8a", "grey teal"], ["efb435", "macaroni and cheese"], ["d99b82", "pinkish tan"], ["0a5f38", "spruce"], ["0c06f7", "strong blue"], ["61de2a", "toxic green"], ["3778bf", "windows blue"], ["2242c7", "blue blue"], ["533cc6", "blue with a hint of purple"], ["9bb53c", "booger"], ["05ffa6", "bright sea green"], ["1f6357", "dark green blue"], ["017374", "deep turquoise"], ["0cb577", "green teal"], ["ff0789", "strong pink"], ["afa88b", "bland"], ["08787f", "deep aqua"], ["dd85d7", "lavender pink"], ["a6c875", "light moss green"], ["a7ffb5", "light seafoam green"], ["c2b709", "olive yellow"], ["e78ea5", "pig pink"], ["966ebd", "deep lilac"], ["ccad60", "desert"], ["ac86a8", "dusty lavender"], ["947e94", "purpley grey"], ["983fb2", "purply"], ["ff63e9", "candy pink"], ["b2fba5", "light pastel green"], ["63b365", "boring green"], ["8ee53f", "kiwi green"], ["b7e1a1", "light grey green"], ["ff6f52", "orange pink"], ["bdf8a3", "tea green"], ["d3b683", "very light brown"], ["fffcc4", "egg shell"], ["430541", "eggplant purple"], ["ffb2d0", "powder pink"], ["997570", "reddish grey"], ["ad900d", "baby shit brown"], ["c48efd", "liliac"], ["507b9c", "stormy blue"], ["7d7103", "ugly brown"], ["fffd78", "custard"], ["da467d", "darkish pink"], ["410200", "deep brown"], ["c9d179", "greenish beige"], ["fffa86", "manilla"], ["5684ae", "off blue"], ["6b7c85", "battleship grey"], ["6f6c0a", "browny green"], ["7e4071", "bruise"], ["009337", "kelley green"], ["d0e429", "sickly yellow"], ["fff917", "sunny yellow"], ["1d5dec", "azul"], ["054907", "darkgreen"], ["b5ce08", "green/yellow"], ["8fb67b", "lichen"], ["c8ffb0", "light light green"], ["fdde6c", "pale gold"], ["ffdf22", "sun yellow"], ["a9be70", "tan green"], ["6832e3", "burple"], ["fdb147", "butterscotch"], ["c7ac7d", "toupe"], ["fff39a", "dark cream"], ["850e04", "indian red"], ["efc0fe", "light lavendar"], ["40fd14", "poison green"], ["b6c406", "baby puke green"], ["9dff00", "bright yellow green"], ["3c4142", "charcoal grey"], ["f2ab15", "squash"], ["ac4f06", "cinnamon"], ["c4fe82", "light pea green"], ["2cfa1f", "radioactive green"], ["9a6200", "raw sienna"], ["ca9bf7", "baby purple"], ["875f42", "cocoa"], ["3a2efe", "light royal blue"], ["fd8d49", "orangeish"], ["8b3103", "rust brown"], ["cba560", "sand brown"], ["698339", "swamp"], ["0cdc73", "tealish green"], ["b75203", "burnt siena"], ["7f8f4e", "camo"], ["26538d", "dusk blue"], ["63a950", "fern"], ["c87f89", "old rose"], ["b1fc99", "pale light green"], ["ff9a8a", "peachy pink"], ["f6688e", "rosy pink"], ["76fda8", "light bluish green"], ["53fe5c", "light bright green"], ["4efd54", "light neon green"], ["a0febf", "light seafoam"], ["7bf2da", "tiffany blue"], ["bcf5a6", "washed out green"], ["ca6b02", "browny orange"], ["107ab0", "nice blue"], ["2138ab", "sapphire"], ["719f91", "greyish teal"], ["fdb915", "orangey yellow"], ["fefcaf", "parchment"], ["fcf679", "straw"], ["1d0200", "very dark brown"], ["cb6843", "terracota"], ["31668a", "ugly blue"], ["247afd", "clear blue"], ["ffffb6", "creme"], ["90fda9", "foam green"], ["86a17d", "grey/green"], ["fddc5c", "light gold"], ["78d1b6", "seafoam blue"], ["13bbaf", "topaz"], ["fb5ffc", "violet pink"], ["20f986", "wintergreen"], ["ffe36e", "yellow tan"], ["9d0759", "dark fuchsia"], ["3a18b1", "indigo blue"], ["c2ff89", "light yellowish green"], ["d767ad", "pale magenta"], ["720058", "rich purple"], ["ffda03", "sunflower yellow"], ["01c08d", "green/blue"], ["ac7434", "leather"], ["014600", "racing green"], ["9900fa", "vivid purple"], ["02066f", "dark royal blue"], ["8e7618", "hazel"], ["d1768f", "muted pink"], ["96b403", "booger green"], ["fdff63", "canary"], ["95a3a6", "cool grey"], ["7f684e", "dark taupe"], ["751973", "darkish purple"], ["089404", "true green"], ["ff6163", "coral pink"], ["598556", "dark sage"], ["214761", "dark slate blue"], ["3c73a8", "flat blue"], ["ba9e88", "mushroom"], ["021bf9", "rich blue"], ["734a65", "dirty purple"], ["23c48b", "greenblue"], ["8fae22", "icky green"], ["e6f2a2", "light khaki"], ["4b57db", "warm blue"], ["d90166", "dark hot pink"], ["015482", "deep sea blue"], ["9d0216", "carmine"], ["728f02", "dark yellow green"], ["ffe5ad", "pale peach"], ["4e0550", "plum purple"], ["f9bc08", "golden rod"], ["ff073a", "neon red"], ["c77986", "old pink"], ["d6fffe", "very pale blue"], ["fe4b03", "blood orange"], ["fd5956", "grapefruit"], ["fce166", "sand yellow"], ["b2713d", "clay brown"], ["1f3b4d", "dark blue grey"], ["699d4c", "flat green"], ["56fca2", "light green blue"], ["fb5581", "warm pink"], ["3e82fc", "dodger blue"], ["a0bf16", "gross green"], ["d6fffa", "ice"], ["4f738e", "metallic blue"], ["ffb19a", "pale salmon"], ["5c8b15", "sap green"], ["54ac68", "algae"], ["89a0b0", "bluey grey"], ["7ea07a", "greeny grey"], ["1bfc06", "highlighter green"], ["cafffb", "light light blue"], ["b6ffbb", "light mint"], ["a75e09", "raw umber"], ["152eff", "vivid blue"], ["8d5eb7", "deep lavender"], ["5f9e8f", "dull teal"], ["63f7b4", "light greenish blue"], ["606602", "mud green"], ["fc86aa", "pinky"], ["8c0034", "red wine"], ["758000", "shit green"], ["ab7e4c", "tan brown"], ["030764", "darkblue"], ["fe86a4", "rosa"], ["d5174e", "lipstick"], ["fed0fc", "pale mauve"], ["680018", "claret"], ["fedf08", "dandelion"], ["fe420f", "orangered"], ["6f7c00", "poop green"], ["ca0147", "ruby"], ["1b2431", "dark"], ["00fbb0", "greenish turquoise"], ["db5856", "pastel red"], ["ddd618", "piss yellow"], ["41fdfe", "bright cyan"], ["cf524e", "dark coral"], ["21c36f", "algae green"], ["a90308", "darkish red"], ["6e1005", "reddy brown"], ["fe828c", "blush pink"], ["4b6113", "camouflage green"], ["4da409", "lawn green"], ["beae8a", "putty"], ["0339f8", "vibrant blue"], ["a88f59", "dark sand"], ["5d21d0", "purple/blue"], ["feb209", "saffron"], ["4e518b", "twilight"], ["964e02", "warm brown"], ["85a3b2", "bluegrey"], ["ff69af", "bubble gum pink"], ["c3fbf4", "duck egg blue"], ["2afeb7", "greenish cyan"], ["005f6a", "petrol"], ["0c1793", "royal"], ["ffff81", "butter"], ["f0833a", "dusty orange"], ["f1f33f", "off yellow"], ["b1d27b", "pale olive green"], ["fc824a", "orangish"], ["71aa34", "leaf"], ["b7c9e2", "light blue grey"], ["4b0101", "dried blood"], ["a552e6", "lightish purple"], ["af2f0d", "rusty red"], ["8b88f8", "lavender blue"], ["9af764", "light grass green"], ["a6fbb2", "light mint green"], ["ffc512", "sunflower"], ["750851", "velvet"], ["c14a09", "brick orange"], ["fe2f4a", "lightish red"], ["0203e2", "pure blue"], ["0a437a", "twilight blue"], ["a50055", "violet red"], ["ae8b0c", "yellowy brown"], ["fd798f", "carnation"], ["bfac05", "muddy yellow"], ["3eaf76", "dark seafoam green"], ["c74767", "deep rose"], ["b9484e", "dusty red"], ["647d8e", "grey/blue"], ["bffe28", "lemon lime"], ["d725de", "purple/pink"], ["b29705", "brown yellow"], ["673a3f", "purple brown"], ["a87dc2", "wisteria"], ["fafe4b", "banana yellow"], ["c0022f", "lipstick red"], ["0e87cc", "water blue"], ["8d8468", "brown grey"], ["ad03de", "vibrant purple"], ["8cff9e", "baby green"], ["94ac02", "barf green"], ["c4fff7", "eggshell blue"], ["fdee73", "sandy yellow"], ["33b864", "cool green"], ["fff9d0", "pale"], ["758da3", "blue/grey"], ["f504c9", "hot magenta"], ["77a1b5", "greyblue"], ["8756e4", "purpley"], ["889717", "baby shit green"], ["c27e79", "brownish pink"], ["017371", "dark aquamarine"], ["9f8303", "diarrhea"], ["f7d560", "light mustard"], ["bdf6fe", "pale sky blue"], ["75b84f", "turtle green"], ["9cbb04", "bright olive"], ["29465b", "dark grey blue"], ["696006", "greeny brown"], ["adf802", "lemon green"], ["c1c6fc", "light periwinkle"], ["35ad6b", "seaweed green"], ["fffd37", "sunshine yellow"], ["a442a0", "ugly purple"], ["f36196", "medium pink"], ["947706", "puke brown"], ["fff4f2", "very light pink"], ["1e9167", "viridian"], ["b5c306", "bile"], ["feff7f", "faded yellow"], ["cffdbc", "very pale green"], ["0add08", "vibrant green"], ["87fd05", "bright lime"], ["1ef876", "spearmint"], ["7bfdc7", "light aquamarine"], ["bcecac", "light sage"], ["bbf90f", "yellowgreen"], ["ab9004", "baby poo"], ["1fb57a", "dark seafoam"], ["00555a", "deep teal"], ["a484ac", "heather"], ["c45508", "rust orange"], ["3f829d", "dirty blue"], ["548d44", "fern green"], ["c95efb", "bright lilac"], ["3ae57f", "weird green"], ["016795", "peacock blue"], ["87a922", "avocado green"], ["f0944d", "faded orange"], ["5d1451", "grape purple"], ["25ff29", "hot green"], ["d0fe1d", "lime yellow"], ["ffa62b", "mango"], ["01b44c", "shamrock"], ["ff6cb5", "bubblegum"], ["6b4247", "purplish brown"], ["c7c10c", "vomit yellow"], ["b7fffa", "pale cyan"], ["aeff6e", "key lime"], ["ec2d01", "tomato red"], ["76ff7b", "lightgreen"], ["730039", "merlot"], ["040348", "night blue"], ["df4ec8", "purpleish pink"], ["6ecb3c", "apple"], ["8f9805", "baby poop green"], ["5edc1f", "green apple"], ["d94ff5", "heliotrope"], ["c8fd3d", "yellow/green"], ["070d0d", "almost black"], ["4984b8", "cool blue"], ["51b73b", "leafy green"], ["ac7e04", "mustard brown"], ["4e5481", "dusk"], ["876e4b", "dull brown"], ["58bc08", "frog green"], ["2fef10", "vivid green"], ["2dfe54", "bright light green"], ["0aff02", "fluro green"], ["9cef43", "kiwi"], ["18d17b", "seaweed"], ["35530a", "navy green"], ["1805db", "ultramarine blue"], ["6258c4", "iris"], ["ff964f", "pastel orange"], ["ffab0f", "yellowish orange"], ["8f8ce7", "perrywinkle"], ["24bca8", "tealish"], ["3f012c", "dark plum"], ["cbf85f", "pear"], ["ff724c", "pinkish orange"], ["280137", "midnight purple"], ["b36ff6", "light urple"], ["48c072", "dark mint"], ["bccb7a", "greenish tan"], ["a8415b", "light burgundy"], ["06b1c4", "turquoise blue"], ["cd7584", "ugly pink"], ["f1da7a", "sandy"], ["ff0490", "electric pink"], ["805b87", "muted purple"], ["50a747", "mid green"], ["a8a495", "greyish"], ["cfff04", "neon yellow"], ["ffff7e", "banana"], ["ff7fa7", "carnation pink"], ["ef4026", "tomato"], ["3c9992", "sea"], ["886806", "muddy brown"], ["04f489", "turquoise green"], ["fef69e", "buff"], ["cfaf7b", "fawn"], ["3b719f", "muted blue"], ["fdc1c5", "pale rose"], ["20c073", "dark mint green"], ["9b5fc0", "amethyst"], ["0f9b8e", "blue/green"], ["742802", "chestnut"], ["9db92c", "sick green"], ["a4bf20", "pea"], ["cd5909", "rusty orange"], ["ada587", "stone"], ["be013c", "rose red"], ["b8ffeb", "pale aqua"], ["dc4d01", "deep orange"], ["a2653e", "earth"], ["638b27", "mossy green"], ["419c03", "grassy green"], ["b1ff65", "pale lime green"], ["9dbcd4", "light grey blue"], ["fdfdfe", "pale grey"], ["77ab56", "asparagus"], ["464196", "blueberry"], ["990147", "purple red"], ["befd73", "pale lime"], ["32bf84", "greenish teal"], ["af6f09", "caramel"], ["a0025c", "deep magenta"], ["ffd8b1", "light peach"], ["7f4e1e", "milk chocolate"], ["bf9b0c", "ocher"], ["6ba353", "off green"], ["f075e6", "purply pink"], ["7bc8f6", "lightblue"], ["475f94", "dusky blue"], ["f5bf03", "golden"], ["fffeb6", "light beige"], ["fffd74", "butter yellow"], ["895b7b", "dusky purple"], ["436bad", "french blue"], ["d0c101", "ugly yellow"], ["c6f808", "greeny yellow"], ["f43605", "orangish red"], ["02c14d", "shamrock green"], ["b25f03", "orangish brown"], ["2a7e19", "tree green"], ["490648", "deep violet"], ["536267", "gunmetal"], ["5a06ef", "blue/purple"], ["cf0234", "cherry"], ["c4a661", "sandy brown"], ["978a84", "warm grey"], ["1f0954", "dark indigo"], ["03012d", "midnight"], ["2bb179", "bluey green"], ["c3909b", "grey pink"], ["a66fb5", "soft purple"], ["770001", "blood"], ["922b05", "brown red"], ["7d7f7c", "medium grey"], ["990f4b", "berry"], ["8f7303", "poo"], ["c83cb9", "purpley pink"], ["fea993", "light salmon"], ["acbb0d", "snot"], ["c071fe", "easter purple"], ["ccfd7f", "light yellow green"], ["00022e", "dark navy blue"], ["828344", "drab"], ["ffc5cb", "light rose"], ["ab1239", "rouge"], ["b0054b", "purplish red"], ["99cc04", "slime green"], ["937c00", "baby poop"], ["019529", "irish green"], ["ef1de7", "pink/purple"], ["000435", "dark navy"], ["42b395", "greeny blue"], ["9d5783", "light plum"], ["c8aca9", "pinkish grey"], ["c87606", "dirty orange"], ["aa2704", "rust red"], ["e4cbff", "pale lilac"], ["fa4224", "orangey red"], ["0804f9", "primary blue"], ["5cb200", "kermit green"], ["76424e", "brownish purple"], ["6c7a0e", "murky green"], ["fbdd7e", "wheat"], ["2a0134", "very dark purple"], ["044a05", "bottle green"], ["fd4659", "watermelon"], ["0d75f8", "deep sky blue"], ["fe0002", "fire engine red"], ["cb9d06", "yellow ochre"], ["fb7d07", "pumpkin orange"], ["b9cc81", "pale olive"], ["edc8ff", "light lilac"], ["61e160", "lightish green"], ["8ab8fe", "carolina blue"], ["920a4e", "mulberry"], ["fe02a2", "shocking pink"], ["9a3001", "auburn"], ["65fe08", "bright lime green"], ["befdb7", "celadon"], ["b17261", "pinkish brown"], ["885f01", "poo brown"], ["02ccfe", "bright sky blue"], ["c1fd95", "celery"], ["836539", "dirt brown"], ["fb2943", "strawberry"], ["84b701", "dark lime"], ["b66325", "copper"], ["7f5112", "medium brown"], ["5fa052", "muted green"], ["6dedfd", "robin's egg"], ["0bf9ea", "bright aqua"], ["c760ff", "bright lavender"], ["ffffcb", "ivory"], ["f6cefc", "very light purple"], ["155084", "light navy"], ["f5054f", "pink red"], ["645403", "olive brown"], ["7a5901", "poop brown"], ["a8b504", "mustard green"], ["3d9973", "ocean green"], ["000133", "very dark blue"], ["76a973", "dusty green"], ["2e5a88", "light navy blue"], ["0bf77d", "minty green"], ["bd6c48", "adobe"], ["ac1db8", "barney"], ["2baf6a", "jade green"], ["26f7fd", "bright light blue"], ["aefd6c", "light lime"], ["9b8f55", "dark khaki"], ["ffad01", "orange yellow"], ["c69c04", "ocre"], ["f4d054", "maize"], ["de9dac", "faded pink"], ["05480d", "british racing green"], ["c9ae74", "sandstone"], ["60460f", "mud brown"], ["98f6b0", "light sea green"], ["8af1fe", "robin egg blue"], ["2ee8bb", "aqua marine"], ["11875d", "dark sea green"], ["fdb0c0", "soft pink"], ["b16002", "orangey brown"], ["f7022a", "cherry red"], ["d5ab09", "burnt yellow"], ["86775f", "brownish grey"], ["c69f59", "camel"], ["7a687f", "purplish grey"], ["042e60", "marine"], ["c88d94", "greyish pink"], ["a5fbd5", "pale turquoise"], ["fffe71", "pastel yellow"], ["6241c7", "bluey purple"], ["fffe40", "canary yellow"], ["d3494e", "faded red"], ["985e2b", "sepia"], ["a6814c", "coffee"], ["ff08e8", "bright magenta"], ["9d7651", "mocha"], ["feffca", "ecru"], ["98568d", "purpleish"], ["9e003a", "cranberry"], ["287c37", "darkish green"], ["b96902", "brown orange"], ["ba6873", "dusky rose"], ["ff7855", "melon"], ["94b21c", "sickly green"], ["c5c9c7", "silver"], ["661aee", "purply blue"], ["6140ef", "purpleish blue"], ["9be5aa", "hospital green"], ["7b5804", "shit brown"], ["276ab3", "mid blue"], ["feb308", "amber"], ["8cfd7e", "easter green"], ["6488ea", "soft blue"], ["056eee", "cerulean blue"], ["b27a01", "golden brown"], ["0ffef9", "bright turquoise"], ["fa2a55", "red pink"], ["820747", "red purple"], ["7a6a4f", "greyish brown"], ["f4320c", "vermillion"], ["a13905", "russet"], ["6f828a", "steel grey"], ["a55af4", "lighter purple"], ["ad0afd", "bright violet"], ["004577", "prussian blue"], ["658d6d", "slate green"], ["ca7b80", "dirty pink"], ["005249", "dark blue green"], ["2b5d34", "pine"], ["bff128", "yellowy green"], ["b59410", "dark gold"], ["2976bb", "bluish"], ["014182", "darkish blue"], ["bb3f3f", "dull red"], ["fc2647", "pinky red"], ["a87900", "bronze"], ["82cbb2", "pale teal"], ["667c3e", "military green"], ["fe46a5", "barbie pink"], ["fe83cc", "bubblegum pink"], ["94a617", "pea soup green"], ["a88905", "dark mustard"], ["7f5f00", "shit"], ["9e43a2", "medium purple"], ["062e03", "very dark green"], ["8a6e45", "dirt"], ["cc7a8b", "dusky pink"], ["9e0168", "red violet"], ["fdff38", "lemon yellow"], ["c0fa8b", "pistachio"], ["eedc5b", "dull yellow"], ["7ebd01", "dark lime green"], ["3b5b92", "denim blue"], ["01889f", "teal blue"], ["3d7afd", "lightish blue"], ["5f34e7", "purpley blue"], ["6d5acf", "light indigo"], ["748500", "swamp green"], ["706c11", "brown green"], ["3c0008", "dark maroon"], ["cb00f5", "hot purple"], ["002d04", "dark forest green"], ["658cbb", "faded blue"], ["749551", "drab green"], ["b9ff66", "light lime green"], ["9dc100", "snot green"], ["faee66", "yellowish"], ["7efbb3", "light blue green"], ["7b002c", "bordeaux"], ["c292a1", "light mauve"], ["017b92", "ocean"], ["fcc006", "marigold"], ["657432", "muddy green"], ["d8863b", "dull orange"], ["738595", "steel"], ["aa23ff", "electric purple"], ["08ff08", "fluorescent green"], ["9b7a01", "yellowish brown"], ["f29e8e", "blush"], ["6fc276", "soft green"], ["ff5b00", "bright orange"], ["fdff52", "lemon"], ["866f85", "purple grey"], ["8ffe09", "acid green"], ["eecffe", "pale lavender"], ["510ac9", "violet blue"], ["4f9153", "light forest green"], ["9f2305", "burnt red"], ["728639", "khaki green"], ["de0c62", "cerise"], ["916e99", "faded purple"], ["ffb16d", "apricot"], ["3c4d03", "dark olive green"], ["7f7053", "grey brown"], ["77926f", "green grey"], ["010fcc", "true blue"], ["ceaefa", "pale violet"], ["8f99fb", "periwinkle blue"], ["c6fcff", "light sky blue"], ["5539cc", "blurple"], ["544e03", "green brown"], ["017a79", "bluegreen"], ["01f9c6", "bright teal"], ["c9b003", "brownish yellow"], ["929901", "pea soup"], ["0b5509", "forest"], ["a00498", "barney purple"], ["2000b1", "ultramarine"], ["94568c", "purplish"], ["c2be0e", "puke yellow"], ["748b97", "bluish grey"], ["665fd1", "dark periwinkle"], ["9c6da5", "dark lilac"], ["c44240", "reddish"], ["a24857", "light maroon"], ["825f87", "dusty purple"], ["c9643b", "terra cotta"], ["90b134", "avocado"], ["01386a", "marine blue"], ["25a36f", "teal green"], ["59656d", "slate grey"], ["75fd63", "lighter green"], ["21fc0d", "electric green"], ["5a86ad", "dusty blue"], ["fec615", "golden yellow"], ["fffd01", "bright yellow"], ["dfc5fe", "light lavender"], ["b26400", "umber"], ["7f5e00", "poop"], ["de7e5d", "dark peach"], ["048243", "jungle green"], ["ffffd4", "eggshell"], ["3b638c", "denim"], ["b79400", "yellow brown"], ["84597e", "dull purple"], ["411900", "chocolate brown"], ["7b0323", "wine red"], ["04d9ff", "neon blue"], ["667e2c", "dirty green"], ["fbeeac", "light tan"], ["d7fffe", "ice blue"], ["4e7496", "cadet blue"], ["874c62", "dark mauve"], ["d5ffff", "very light blue"], ["826d8c", "grey purple"], ["ffbacd", "pastel pink"], ["d1ffbd", "very light green"], ["448ee4", "dark sky blue"], ["05472a", "evergreen"], ["d5869d", "dull pink"], ["3d0734", "aubergine"], ["4a0100", "mahogany"], ["f8481c", "reddish orange"], ["02590f", "deep green"], ["89a203", "vomit green"], ["e03fd8", "purple pink"], ["d58a94", "dusty pink"], ["7bb274", "faded green"], ["526525", "camo green"], ["c94cbe", "pinky purple"], ["db4bda", "pink purple"], ["9e3623", "brownish red"], ["b5485d", "dark rose"], ["735c12", "mud"], ["9c6d57", "brownish"], ["028f1e", "emerald green"], ["b1916e", "pale brown"], ["49759c", "dull blue"], ["a0450e", "burnt umber"], ["39ad48", "medium green"], ["b66a50", "clay"], ["8cffdb", "light aqua"], ["a4be5c", "light olive green"], ["cb7723", "brownish orange"], ["05696b", "dark aqua"], ["ce5dae", "purplish pink"], ["c85a53", "dark salmon"], ["96ae8d", "greenish grey"], ["1fa774", "jade"], ["7a9703", "ugly green"], ["ac9362", "dark beige"], ["01a049", "emerald"], ["d9544d", "pale red"], ["fa5ff7", "light magenta"], ["82cafc", "sky"], ["acfffc", "light cyan"], ["fcb001", "yellow orange"], ["910951", "reddish purple"], ["fe2c54", "reddish pink"], ["c875c4", "orchid"], ["cdc50a", "dirty yellow"], ["fd411e", "orange red"], ["9a0200", "deep red"], ["be6400", "orange brown"], ["030aa7", "cobalt blue"], ["fe019a", "neon pink"], ["f7879a", "rose pink"], ["887191", "greyish purple"], ["b00149", "raspberry"], ["12e193", "aqua green"], ["fe7b7c", "salmon pink"], ["ff9408", "tangerine"], ["6a6e09", "brownish green"], ["8b2e16", "red brown"], ["696112", "greenish brown"], ["e17701", "pumpkin"], ["0a481e", "pine green"], ["343837", "charcoal"], ["ffb7ce", "baby pink"], ["6a79f7", "cornflower"], ["5d06e9", "blue violet"], ["3d1c02", "chocolate"], ["82a67d", "greyish green"], ["be0119", "scarlet"], ["c9ff27", "green yellow"], ["373e02", "dark olive"], ["a9561e", "sienna"], ["caa0ff", "pastel purple"], ["ca6641", "terracotta"], ["02d8e9", "aqua blue"], ["88b378", "sage green"], ["980002", "blood red"], ["cb0162", "deep pink"], ["5cac2d", "grass"], ["769958", "moss"], ["a2bffe", "pastel blue"], ["10a674", "bluish green"], ["06b48b", "green blue"], ["af884a", "dark tan"], ["0b8b87", "greenish blue"], ["ffa756", "pale orange"], ["a2a415", "vomit"], ["154406", "forrest green"], ["856798", "dark lavender"], ["34013f", "dark violet"], ["632de9", "purple blue"], ["0a888a", "dark cyan"], ["6f7632", "olive drab"], ["d46a7e", "pinkish"], ["1e488f", "cobalt"], ["bc13fe", "neon purple"], ["7ef4cc", "light turquoise"], ["76cd26", "apple green"], ["74a662", "dull green"], ["80013f", "wine"], ["b1d1fc", "powder blue"], ["ffffe4", "off white"], ["0652ff", "electric blue"], ["045c5a", "dark turquoise"], ["5729ce", "blue purple"], ["069af3", "azure"], ["ff000d", "bright red"], ["f10c45", "pinkish red"], ["5170d7", "cornflower blue"], ["acbf69", "light olive"], ["6c3461", "grape"], ["5e819d", "greyish blue"], ["601ef9", "purplish blue"], ["b0dd16", "yellowish green"], ["cdfd02", "greenish yellow"], ["2c6fbb", "medium blue"], ["c0737a", "dusty rose"], ["d6b4fc", "light violet"], ["020035", "midnight blue"], ["703be7", "bluish purple"], ["fd3c06", "red orange"], ["960056", "dark magenta"], ["40a368", "greenish"], ["03719c", "ocean blue"], ["fc5a50", "coral"], ["ffffc2", "cream"], ["7f2b0a", "reddish brown"], ["b04e0f", "burnt sienna"], ["a03623", "brick"], ["87ae73", "sage"], ["789b73", "grey green"], ["ffffff", "white"], ["98eff9", "robin's egg blue"], ["658b38", "moss green"], ["5a7d9a", "steel blue"], ["380835", "eggplant"], ["fffe7a", "light yellow"], ["5ca904", "leaf green"], ["d8dcd6", "light grey"], ["a5a502", "puke"], ["d648d7", "pinkish purple"], ["047495", "sea blue"], ["b790d4", "pale purple"], ["5b7c99", "slate blue"], ["607c8e", "blue grey"], ["0b4008", "hunter green"], ["ed0dd9", "fuchsia"], ["8c000f", "crimson"], ["ffff84", "pale yellow"], ["bf9005", "ochre"], ["d2bd0a", "mustard yellow"], ["ff474c", "light red"], ["0485d1", "cerulean"], ["ffcfdc", "pale pink"], ["040273", "deep blue"], ["a83c09", "rust"], ["90e4c1", "light teal"], ["516572", "slate"], ["fac205", "goldenrod"], ["d5b60a", "dark yellow"], ["363737", "dark grey"], ["4b5d16", "army green"], ["6b8ba4", "grey blue"], ["80f9ad", "seafoam"], ["a57e52", "puce"], ["a9f971", "spring green"], ["c65102", "dark orange"], ["e2ca76", "sand"], ["b0ff9d", "pastel green"], ["9ffeb0", "mint"], ["fdaa48", "light orange"], ["fe01b1", "bright pink"], ["c1f80a", "chartreuse"], ["36013f", "deep purple"], ["341c02", "dark brown"], ["b9a281", "taupe"], ["8eab12", "pea green"], ["9aae07", "puke green"], ["02ab2e", "kelly green"], ["7af9ab", "seafoam green"], ["137e6d", "blue green"], ["aaa662", "khaki"], ["610023", "burgundy"], ["014d4e", "dark teal"], ["8f1402", "brick red"], ["4b006e", "royal purple"], ["580f41", "plum"], ["8fff9f", "mint green"], ["dbb40c", "gold"], ["a2cffe", "baby blue"], ["c0fb2d", "yellow green"], ["be03fd", "bright purple"], ["840000", "dark red"], ["d0fefe", "pale blue"], ["3f9b0b", "grass green"], ["01153e", "navy"], ["04d8b2", "aquamarine"], ["c04e01", "burnt orange"], ["0cff0c", "neon green"], ["0165fc", "bright blue"], ["cf6275", "rose"], ["ffd1df", "light pink"], ["ceb301", "mustard"], ["380282", "indigo"], ["aaff32", "lime"], ["53fca1", "sea green"], ["8e82fe", "periwinkle"], ["cb416b", "dark pink"], ["677a04", "olive green"], ["ffb07c", "peach"], ["c7fdb5", "pale green"], ["ad8150", "light brown"], ["ff028d", "hot pink"], ["000000", "black"], ["cea2fd", "lilac"], ["001146", "navy blue"], ["0504aa", "royal blue"], ["e6daa6", "beige"], ["ff796c", "salmon"], ["6e750e", "olive"], ["650021", "maroon"], ["01ff07", "bright green"], ["35063e", "dark purple"], ["ae7181", "mauve"], ["06470c", "forest green"], ["13eac9", "aqua"], ["00ffff", "cyan"], ["d1b26f", "tan"], ["00035b", "dark blue"], ["c79fef", "lavender"], ["06c2ac", "turquoise"], ["033500", "dark green"], ["9a0eea", "violet"], ["bf77f6", "light purple"], ["89fe05", "lime green"], ["929591", "grey"], ["75bbfd", "sky blue"], ["ffff14", "yellow"], ["c20078", "magenta"], ["96f97b", "light green"], ["f97306", "orange"], ["029386", "teal"], ["95d0fc", "light blue"], ["e50000", "red"], ["653700", "brown"], ["ff81c0", "pink"], ["0343df", "blue"], ["15b01a", "green"], ["7e1e9c", "purple"], ["FF5E99", "paul irish pink"], ["00000000", "transparent"]];
  names.each(function(element) {
    return lookup[normalizeKey(element[1])] = parseHex(element[0]);
  });
  window.Color.random = function() {
    return Color(rand(256), rand(256), rand(256), 1);
  };
  return window.Color.mix = function(color1, color2, amount) {
    var new_colors;
    amount || (amount = 0.5);
    new_colors = color1.channels().zip(color2.channels()).map(function(array) {
      return (array[0] * amount) + (array[1] * (1 - amount));
    });
    return Color(new_colors);
  };
})();;
/**
The Core class is used to add extended functionality to objects without
extending the object class directly. Inherit from Core to gain its utility
methods.

@name Core
@constructor

@param {Object} I Instance variables
*/var Core;
var __slice = Array.prototype.slice;
Core = function(I) {
  var self;
  I || (I = {});
  return self = {
    /**
      External access to instance variables. Use of this property should be avoided
      in general, but can come in handy from time to time.
    
      @name I
      @fieldOf Core#
      */
    I: I,
    /**
      Generates a public jQuery style getter / setter method for each 
      String argument.
    
      @name attrAccessor
      @methodOf Core#
      */
    attrAccessor: function() {
      var attrNames;
      attrNames = 1 <= arguments.length ? __slice.call(arguments, 0) : [];
      return attrNames.each(function(attrName) {
        return self[attrName] = function(newValue) {
          if (newValue != null) {
            I[attrName] = newValue;
            return self;
          } else {
            return I[attrName];
          }
        };
      });
    },
    /**
    Generates a public jQuery style getter method for each String argument.
    
    @name attrReader
    @methodOf Core#
    */
    attrReader: function() {
      var attrNames;
      attrNames = 1 <= arguments.length ? __slice.call(arguments, 0) : [];
      return attrNames.each(function(attrName) {
        return self[attrName] = function() {
          return I[attrName];
        };
      });
    },
    /**
    Extends this object with methods from the passed in object. `before` and 
    `after` are special option names that glue functionality before or after 
    existing methods.
    
    @name extend
    @methodOf Core#
    */
    extend: function(options) {
      var afterMethods, beforeMethods;
      afterMethods = options.after;
      beforeMethods = options.before;
      delete options.after;
      delete options.before;
      $.extend(self, options);
      if (beforeMethods) {
        $.each(beforeMethods, function(name, fn) {
          return self[name] = self[name].withBefore(fn);
        });
      }
      if (afterMethods) {
        $.each(afterMethods, function(name, fn) {
          return self[name] = self[name].withAfter(fn);
        });
      }
      return self;
    },
    /** 
    Includes a module in this object.
    
    @name include
    @methodOf Core#
    
    @param {Module} Module the module to include. A module is a constructor 
    that takes two parameters, I and self, and returns an object containing the 
    public methods to extend the including object with.
    */
    include: function(Module) {
      return self.extend(Module(I, self));
    }
  };
};;
Function.prototype.withBefore = function(interception) {
  var method;
  method = this;
  return function() {
    interception.apply(this, arguments);
    return method.apply(this, arguments);
  };
};
Function.prototype.withAfter = function(interception) {
  var method;
  method = this;
  return function() {
    var result;
    result = method.apply(this, arguments);
    interception.apply(this, arguments);
    return result;
  };
};;
/**
 * jQuery Hotkeys Plugin
 * Copyright 2010, John Resig
 * Dual licensed under the MIT or GPL Version 2 licenses.
 *
 * Based upon the plugin by Tzury Bar Yochay:
 * http://github.com/tzuryby/hotkeys
 *
 * Original idea by:
 * Binny V A, http://www.openjs.com/scripts/events/keyboard_shortcuts/
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
 * Merges properties from objects into target without overiding.
 * First come, first served.
 * @return target
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
  return ["log", "info", "warn", "error"].each(function(name) {
    if (typeof console !== "undefined") {
      return window[name] = function(message) {
        if (console[name]) {
          return console[name](message);
        }
      };
    } else {
      return window[name] = $.noop;
    }
  });
});;
/**
* Matrix.js v1.3.0pre
* 
* Copyright (c) 2010 STRd6
*
* Permission is hereby granted, free of charge, to any person obtaining a copy
* of this software and associated documentation files (the "Software"), to deal
* in the Software without restriction, including without limitation the rights
* to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
* copies of the Software, and to permit persons to whom the Software is
* furnished to do so, subject to the following conditions:
*
* The above copyright notice and this permission notice shall be included in
* all copies or substantial portions of the Software.
*
* THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
* IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
* FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
* AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
* LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
* OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
* THE SOFTWARE.
*
* Loosely based on flash:
* http://www.adobe.com/livedocs/flash/9.0/ActionScriptLangRefV3/flash/geom/Matrix.html
*/(function() {
  /**
  <pre>
     _        _
    | a  c tx  |
    | b  d ty  |
    |_0  0  1 _|
  </pre>
  Creates a matrix for 2d affine transformations.
  
  concat, inverse, rotate, scale and translate return new matrices with the
  transformations applied. The matrix is not modified in place.
  
  Returns the identity matrix when called with no arguments.
  
  @name Matrix
  @param {Number} [a]
  @param {Number} [b]
  @param {Number} [c]
  @param {Number} [d]
  @param {Number} [tx]
  @param {Number} [ty]
  @constructor
  */  var Matrix;
  Matrix = function(a, b, c, d, tx, ty) {
    return {
      __proto__: Matrix.prototype,
      /**
      @name a
      @fieldOf Matrix#
      */
      a: a != null ? a : 1,
      /**
      @name b
      @fieldOf Matrix#
      */
      b: b || 0,
      /**
      @name c
      @fieldOf Matrix#
      */
      c: c || 0,
      /**
      @name d
      @fieldOf Matrix#
      */
      d: d != null ? d : 1,
      /**
      @name tx
      @fieldOf Matrix#
      */
      tx: tx || 0,
      /**
      @name ty
      @fieldOf Matrix#
      */
      ty: ty || 0
    };
  };
  Matrix.prototype = {
    /**
      Returns the result of this matrix multiplied by another matrix
      combining the geometric effects of the two. In mathematical terms, 
      concatenating two matrixes is the same as combining them using matrix multiplication.
      If this matrix is A and the matrix passed in is B, the resulting matrix is A x B
      http://mathworld.wolfram.com/MatrixMultiplication.html
      @name concat
      @methodOf Matrix#
      
      @param {Matrix} matrix The matrix to multiply this matrix by.
      @returns The result of the matrix multiplication, a new matrix.
      @type Matrix
      */
    concat: function(matrix) {
      return Matrix(this.a * matrix.a + this.c * matrix.b, this.b * matrix.a + this.d * matrix.b, this.a * matrix.c + this.c * matrix.d, this.b * matrix.c + this.d * matrix.d, this.a * matrix.tx + this.c * matrix.ty + this.tx, this.b * matrix.tx + this.d * matrix.ty + this.ty);
    },
    /**
    Given a point in the pretransform coordinate space, returns the coordinates of 
    that point after the transformation occurs. Unlike the standard transformation 
    applied using the transformPoint() method, the deltaTransformPoint() method 
    does not consider the translation parameters tx and ty.
    @name deltaTransformPoint
    @methodOf Matrix#
    @see #transformPoint
    
    @return A new point transformed by this matrix ignoring tx and ty.
    @type Point
    */
    deltaTransformPoint: function(point) {
      return Point(this.a * point.x + this.c * point.y, this.b * point.x + this.d * point.y);
    },
    /**
    Returns the inverse of the matrix.
    http://mathworld.wolfram.com/MatrixInverse.html
    @name inverse
    @methodOf Matrix#
    
    @returns A new matrix that is the inverse of this matrix.
    @type Matrix
    */
    inverse: function() {
      var determinant;
      determinant = this.a * this.d - this.b * this.c;
      return Matrix(this.d / determinant, -this.b / determinant, -this.c / determinant, this.a / determinant, (this.c * this.ty - this.d * this.tx) / determinant, (this.b * this.tx - this.a * this.ty) / determinant);
    },
    /**
    Returns a new matrix that corresponds this matrix multiplied by a
    a rotation matrix.
    @name rotate
    @methodOf Matrix#
    @see Matrix.rotation
    
    @param {Number} theta Amount to rotate in radians.
    @param {Point} [aboutPoint] The point about which this rotation occurs. Defaults to (0,0).
    @returns A new matrix, rotated by the specified amount.
    @type Matrix
    */
    rotate: function(theta, aboutPoint) {
      return this.concat(Matrix.rotation(theta, aboutPoint));
    },
    /**
    Returns a new matrix that corresponds this matrix multiplied by a
    a scaling matrix.
    @name scale
    @methodOf Matrix#
    @see Matrix.scale
    
    @param {Number} sx
    @param {Number} [sy]
    @param {Point} [aboutPoint] The point that remains fixed during the scaling
    @type Matrix
    */
    scale: function(sx, sy, aboutPoint) {
      return this.concat(Matrix.scale(sx, sy, aboutPoint));
    },
    /**
    Returns the result of applying the geometric transformation represented by the 
    Matrix object to the specified point.
    @name transformPoint
    @methodOf Matrix#
    @see #deltaTransformPoint
    
    @returns A new point with the transformation applied.
    @type Point
    */
    transformPoint: function(point) {
      return Point(this.a * point.x + this.c * point.y + this.tx, this.b * point.x + this.d * point.y + this.ty);
    },
    /**
    Translates the matrix along the x and y axes, as specified by the tx and ty parameters.
    @name translate
    @methodOf Matrix#
    @see Matrix.translation
    
    @param {Number} tx The translation along the x axis.
    @param {Number} ty The translation along the y axis.
    @returns A new matrix with the translation applied.
    @type Matrix
    */
    translate: function(tx, ty) {
      return this.concat(Matrix.translation(tx, ty));
    }
    /**
    Creates a matrix transformation that corresponds to the given rotation,
    around (0,0) or the specified point.
    @see Matrix#rotate
    
    @param {Number} theta Rotation in radians.
    @param {Point} [aboutPoint] The point about which this rotation occurs. Defaults to (0,0).
    @returns 
    @type Matrix
    */
  };
  Matrix.rotate = Matrix.rotation = function(theta, aboutPoint) {
    var rotationMatrix;
    rotationMatrix = Matrix(Math.cos(theta), Math.sin(theta), -Math.sin(theta), Math.cos(theta));
    if (aboutPoint != null) {
      rotationMatrix = Matrix.translation(aboutPoint.x, aboutPoint.y).concat(rotationMatrix).concat(Matrix.translation(-aboutPoint.x, -aboutPoint.y));
    }
    return rotationMatrix;
  };
  /**
  Returns a matrix that corresponds to scaling by factors of sx, sy along
  the x and y axis respectively.
  If only one parameter is given the matrix is scaled uniformly along both axis.
  If the optional aboutPoint parameter is given the scaling takes place
  about the given point.
  @see Matrix#scale
  
  @param {Number} sx The amount to scale by along the x axis or uniformly if no sy is given.
  @param {Number} [sy] The amount to scale by along the y axis.
  @param {Point} [aboutPoint] The point about which the scaling occurs. Defaults to (0,0).
  @returns A matrix transformation representing scaling by sx and sy.
  @type Matrix
  */
  Matrix.scale = function(sx, sy, aboutPoint) {
    var scaleMatrix;
    sy = sy || sx;
    scaleMatrix = Matrix(sx, 0, 0, sy);
    if (aboutPoint) {
      scaleMatrix = Matrix.translation(aboutPoint.x, aboutPoint.y).concat(scaleMatrix).concat(Matrix.translation(-aboutPoint.x, -aboutPoint.y));
    }
    return scaleMatrix;
  };
  /**
  Returns a matrix that corresponds to a translation of tx, ty.
  @see Matrix#translate
  
  @param {Number} tx The amount to translate in the x direction.
  @param {Number} ty The amount to translate in the y direction.
  @return A matrix transformation representing a translation by tx and ty.
  @type Matrix
  */
  Matrix.translate = Matrix.translation = function(tx, ty) {
    return Matrix(1, 0, 0, 1, tx, ty);
  };
  /**
  A constant representing the identity matrix.
  @name IDENTITY
  @fieldOf Matrix
  */
  Matrix.IDENTITY = Matrix();
  /**
  A constant representing the horizontal flip transformation matrix.
  @name HORIZONTAL_FLIP
  @fieldOf Matrix
  */
  Matrix.HORIZONTAL_FLIP = Matrix(-1, 0, 0, 1);
  /**
  A constant representing the vertical flip transformation matrix.
  @name VERTICAL_FLIP
  @fieldOf Matrix
  */
  Matrix.VERTICAL_FLIP = Matrix(1, 0, 0, -1);
  window["Point"] = $.noop;
  return window["Matrix"] = Matrix;
})();;
window.Mouse = (function() {
  var Mouse, buttons, set_button;
  Mouse = {
    left: false,
    right: false,
    middle: false,
    location: Point(0, 0)
  };
  buttons = [null, "left", "middle", "right"];
  set_button = function(index, state) {
    var button_name;
    button_name = buttons[index];
    if (button_name) {
      return Mouse[button_name] = state;
    }
  };
  $(document).mousedown(function(event) {
    return set_button(event.which, true);
  });
  $(document).mouseup(function(event) {
    return set_button(event.which, false);
  });
  $(document).mousemove(function(event) {
    var x, y;
    x = event.pageX;
    y = event.pageY;
    Mouse.location = Point(x, y);
    Mouse.x = x;
    return Mouse.y = y;
  });
  return Mouse;
})();;
/** 
Returns the absolute value of this number.

@name abs
@methodOf Number#

@type Number
@returns The absolute value of the number.
*/Number.prototype.abs = function() {
  return Math.abs(this);
};
/**
Returns the mathematical ceiling of this number.

@name ceil
@methodOf Number#

@type Number
@returns The number truncated to the nearest integer of greater than or equal value.

(4.9).ceil() # => 5
(4.2).ceil() # => 5
(-1.2).ceil() # => -1
*/
Number.prototype.ceil = function() {
  return Math.ceil(this);
};
/**
Returns the mathematical floor of this number.

@name floor
@methodOf Number#

@type Number
@returns The number truncated to the nearest integer of less than or equal value.

(4.9).floor() # => 4
(4.2).floor() # => 4
(-1.2).floor() # => -2
*/
Number.prototype.floor = function() {
  return Math.floor(this);
};
/**
Returns this number rounded to the nearest integer.

@name round
@methodOf Number#

@type Number
@returns The number rounded to the nearest integer.

(4.5).round() # => 5
(4.4).round() # => 4
*/
Number.prototype.round = function() {
  return Math.round(this);
};
/**
Returns a number whose value is limited to the given range.

Example: limit the output of this computation to between 0 and 255
<pre>
(x * 255).clamp(0, 255)
</pre>

@name clamp
@methodOf Number#

@param {Number} min The lower boundary of the output range
@param {Number} max The upper boundary of the output range

@returns A number in the range [min, max]
@type Number
*/
Number.prototype.clamp = function(min, max) {
  return Math.min(Math.max(this, min), max);
};
/**
A mod method useful for array wrapping. The range of the function is
constrained to remain in bounds of array indices.

<pre>
Example:
(-1).mod(5) == 4
</pre>

@name mod
@methodOf Number#

@param {Number} base
@returns An integer between 0 and (base - 1) if base is positive.
@type Number
*/
Number.prototype.mod = function(base) {
  var result;
  result = this % base;
  if (result < 0 && base > 0) {
    result += base;
  }
  return result;
};
/**
Get the sign of this number as an integer (1, -1, or 0).

@name sign
@methodOf Number#

@type Number
@returns The sign of this number, 0 if the number is 0.
*/
Number.prototype.sign = function() {
  if (this > 0) {
    return 1;
  } else if (this < 0) {
    return -1;
  } else {
    return 0;
  }
};
/**
Calls iterator the specified number of times, passing in the number of the 
current iteration as a parameter: 0 on first call, 1 on the second call, etc. 

@name times
@methodOf Number#

@param {Function} iterator The iterator takes a single parameter, the number 
of the current iteration.
@param {Object} [context] The optional context parameter specifies an object
to treat as <code>this</code> in the iterator block.

@returns The number of times the iterator was called.
@type Number
*/
Number.prototype.times = function(iterator, context) {
  var i;
  i = -1;
  while (++i < this) {
    iterator.call(context, i);
  }
  return i;
};
/**
Returns the the nearest grid resolution less than or equal to the number. 

  EX: 
   (7).snap(8) => 0
   (4).snap(8) => 0
   (12).snap(8) => 8

@name snap
@methodOf Number#

@param {Number} resolution The grid resolution to snap to.
@returns The nearest multiple of resolution lower than the number.
@type Number
*/
Number.prototype.snap = function(resolution) {
  var n;
  n = this / resolution;
  1 / 1;
  return n.floor() * resolution;
};
/**
In number theory, integer factorization or prime factorization is the
breaking down of a composite number into smaller non-trivial divisors,
which when multiplied together equal the original integer.

Floors the number for purposes of factorization.

@name primeFactors
@methodOf Number#

@returns An array containing the factorization of this number.
@type Array
*/
Number.prototype.primeFactors = function() {
  var factors, i, iSquared, n;
  factors = [];
  n = Math.floor(this);
  if (n === 0) {
    return;
  }
  if (n < 0) {
    factors.push(-1);
    n /= -1;
  }
  i = 2;
  iSquared = i * i;
  while (iSquared < n) {
    while ((n % i) === 0) {
      factors.push(i);
      n /= i;
    }
    i += 1;
    iSquared = i * i;
  }
  if (n !== 1) {
    factors.push(n);
  }
  return factors;
};
Number.prototype.toColorPart = function() {
  var s;
  s = parseInt(this.clamp(0, 255), 10).toString(16);
  if (s.length === 1) {
    s = '0' + s;
  }
  return s;
};
Number.prototype.approach = function(target, maxDelta) {
  return (target - this).clamp(-maxDelta, maxDelta) + this;
};
Number.prototype.approachByRatio = function(target, ratio) {
  return this.approach(target, this * ratio);
};
Number.prototype.approachRotation = function(target, maxDelta) {
  while (target > this + Math.PI) {
    target -= Math.TAU;
  }
  while (target < this - Math.PI) {
    target += Math.TAU;
  }
  return (target - this).clamp(-maxDelta, maxDelta) + this;
};
/**
Constrains a rotation to between -PI and PI.

@name constrainRotation
@methodOf Number#

@returns This number constrained between -PI and PI.
@type Number
*/
Number.prototype.constrainRotation = function() {
  var target;
  target = this;
  while (target > Math.PI) {
    target -= Math.TAU;
  }
  while (target < -Math.PI) {
    target += MATH.TAU;
  }
  return target;
};
Number.prototype.d = function(sides) {
  var sum;
  sum = 0;
  this.times(function() {
    return sum += rand(sides) + 1;
  });
  return sum;
};
/** 
The mathematical circle constant of 1 turn.

@name TAU
@fieldOf Math
*/
Math.TAU = 2 * Math.PI;;
/**
Checks whether an object is an array.
@name isArray
@methodOf Object

@param {Object} object The object to check for array-ness.
@type Boolean
@returns A boolean expressing whether the object is an instance of Array 
*/Object.isArray = function(object) {
  return Object.prototype.toString.call(object) === '[object Array]';
};;
(function() {
  /**
  Create a new point with given x and y coordinates. If no arguments are given
  defaults to (0, 0).
  @name Point
  @param {Number} [x]
  @param {Number} [y]
  @constructor
  */  var Point;
  Point = function(x, y) {
    return {
      __proto__: Point.prototype,
      /**
      The x coordinate of this point.
      @name x
      @fieldOf Point#
      */
      x: x || 0,
      /**
      The y coordinate of this point.
      @name y
      @fieldOf Point#
      */
      y: y || 0
    };
  };
  Point.prototype = {
    /**
      Creates a copy of this point.
    
      @name copy
      @methodOf Point#
      @returns A new point with the same x and y value as this point.
      @type Point
      */
    copy: function() {
      return Point(this.x, this.y);
    },
    /**
    Adds a point to this one and returns the new point. You may
    also use a two argument call like <code>point.add(x, y)</code>
    to add x and y values without a second point object.
    @name add
    @methodOf Point#
    
    @param {Point} other The point to add this point to.
    @returns A new point, the sum of both.
    @type Point
    */
    add: function(first, second) {
      return this.copy().add$(first, second);
    },
    add$: function(first, second) {
      if (second != null) {
        this.x += first;
        this.y += second;
      } else {
        this.x += first.x;
        this.y += first.y;
      }
      return this;
    },
    /**
    Subtracts a point to this one and returns the new point.
    @name subtract
    @methodOf Point#
    
    @param {Point} other The point to subtract from this point.
    @returns A new point, this - other.
    @type Point
    */
    subtract: function(first, second) {
      return this.copy().subtract$(first, second);
    },
    subtract$: function(first, second) {
      if (second != null) {
        this.x -= first;
        this.y -= second;
      } else {
        this.x -= first.x;
        this.y -= first.y;
      }
      return this;
    },
    /**
    Scale this Point (Vector) by a constant amount.
    @name scale
    @methodOf Point#
    
    @param {Number} scalar The amount to scale this point by.
    @returns A new point, this * scalar.
    @type Point
    */
    scale: function(scalar) {
      return this.copy().scale$(scalar);
    },
    scale$: function(scalar) {
      this.x *= scalar;
      this.y *= scalar;
      return this;
    },
    /**
    The norm of a vector is the unit vector pointing in the same direction. This method
    treats the point as though it is a vector from the origin to (x, y).
    @name norm
    @methodOf Point#
    
    @returns The unit vector pointing in the same direction as this vector.
    @type Point
    */
    norm: function(length) {
      if (length == null) {
        length = 1.0;
      }
      return this.copy().norm$(length);
    },
    norm$: function(length) {
      if (length == null) {
        length = 1.0;
      }
      return this.scale$(length / this.length());
    },
    /**
    Floor the x and y values, returning a new point.
    
    @name floor
    @methodOf Point#
    @returns A new point, with x and y values each floored to the largest previous integer.
    @type Point
    */
    floor: function() {
      return this.copy().floor$();
    },
    floor$: function() {
      this.x = this.x.floor();
      this.y = this.y.floor();
      return this;
    },
    /**
    Determine whether this point is equal to another point.
    @name equal
    @methodOf Point#
    
    @param {Point} other The point to check for equality.
    @returns true if the other point has the same x, y coordinates, false otherwise.
    @type Boolean
    */
    equal: function(other) {
      return this.x === other.x && this.y === other.y;
    },
    /**
    Computed the length of this point as though it were a vector from (0,0) to (x,y)
    @name length
    @methodOf Point#
    
    @returns The length of the vector from the origin to this point.
    @type Number
    */
    length: function() {
      return Math.sqrt(this.dot(this));
    },
    /**
    Calculate the magnitude of this Point (Vector).
    @name magnitude
    @methodOf Point#
    
    @returns The magnitude of this point as if it were a vector from (0, 0) -> (x, y).
    @type Number
    */
    magnitude: function() {
      return this.length();
    },
    /**
    Returns the direction in radians of this point from the origin.
    @name direction
    @methodOf Point#
    
    @type Number
    */
    direction: function() {
      return Math.atan2(this.y, this.x);
    },
    /**
    Calculate the dot product of this point and another point (Vector).
    @name dot
    @methodOf Point#
    
    @param {Point} other The point to dot with this point.
    @returns The dot product of this point dot other as a scalar value.
    @type Number
    */
    dot: function(other) {
      return this.x * other.x + this.y * other.y;
    },
    /**
    Calculate the cross product of this point and another point (Vector). 
    Usually cross products are thought of as only applying to three dimensional vectors,
    but z can be treated as zero. The result of this method is interpreted as the magnitude 
    of the vector result of the cross product between [x1, y1, 0] x [x2, y2, 0]
    perpendicular to the xy plane.
    @name cross
    @methodOf Point#
    
    @param {Point} other The point to cross with this point.
    @returns The cross product of this point with the other point as scalar value.
    @type Number
    */
    cross: function(other) {
      return this.x * other.y - other.x * this.y;
    },
    /**
    Computed the Euclidean between this point and another point.
    @name distance
    @methodOf Point#
    
    @param {Point} other The point to compute the distance to.
    @returns The distance between this point and another point.
    @type Number
    */
    distance: function(other) {
      return Point.distance(this, other);
    }
    /**
    @param {Point} p1
    @param {Point} p2
    @type Number
    @returns The Euclidean distance between two points.
    */
  };
  Point.distance = function(p1, p2) {
    return Math.sqrt(Math.pow(p2.x - p1.x, 2) + Math.pow(p2.y - p1.y, 2));
  };
  /**
  Construct a point on the unit circle for the given angle.
  
  @param {Number} angle The angle in radians
  @type Point
  @returns The point on the unit circle.
  */
  Point.fromAngle = function(angle) {
    return Point(Math.cos(angle), Math.sin(angle));
  };
  /**
  If you have two dudes, one standing at point p1, and the other
  standing at point p2, then this method will return the direction
  that the dude standing at p1 will need to face to look at p2.
  
  @param {Point} p1 The starting point.
  @param {Point} p2 The ending point.
  @returns The direction from p1 to p2 in radians.
  */
  Point.direction = function(p1, p2) {
    return Math.atan2(p2.y - p1.y, p2.x - p1.x);
  };
  return window["Point"] = Point;
})();;
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
(function($) {
  /**
  @name Random
  @namespace Some useful methods for generating random things.
  */  window.Random = $.extend(window.Random, (function() {
    /**
    Returns a random angle, uniformly distributed, between 0 and 2pi.
    
    @name angle
    @methodOf Random
    @type Number
    */
  })(), {
    angle: function() {
      return rand() * Math.TAU;
    },
    color: function() {
      return Color.random();
    },
    often: function() {
      return rand(3);
    },
    sometimes: function() {
      return !rand(3);
    }
  });
  /**
  Returns random integers from [0, n) if n is given.
  Otherwise returns random float between 0 and 1.
  
  @name rand
  @methodOf window
  
  @param {Number} n
  @type Number
  */
  return window.rand = function(n) {
    if (n) {
      return Math.floor(n * Math.random());
    } else {
      return Math.random();
    }
  };
})(jQuery);;
(function($) {
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
  return window.Local = $.extend(window.Local, {
    get: retrieve,
    set: store,
    put: store
  }, (function() {
    /**
    Access an instance of Local with a specified prefix.
    
    @name new
    @methodOf Local
    
    @param {String} prefix
    @type Local
    @returns An interface to local storage with the given prefix applied.
    */
  })(), {
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
  });
})(jQuery);;
/**
Returns true if this string only contains whitespace characters.

@name blank
@methodOf String#

@returns Whether or not this string is blank.
@type Boolean
*/String.prototype.blank = function() {
  return /^\s*$/.test(this);
};
/**
Returns a new string that is a camelCase version.

@name camelize
@methodOf String#
*/
String.prototype.camelize = function() {
  return this.trim().replace(/(\-|_|\s)+(.)?/g, function(match, separator, chr) {
    if (chr) {
      return chr.toUpperCase();
    } else {
      return '';
    }
  });
};
/**
Returns a new string with the first letter capitalized and the rest lower cased.

@name capitalize
@methodOf String#
*/
String.prototype.capitalize = function() {
  return this.charAt(0).toUpperCase() + this.substring(1).toLowerCase();
};
/**
Return the class or constant named in this string.

@name constantize
@methodOf String#

@returns The class or constant named in this string.
@type Object
*/
String.prototype.constantize = function() {
  if (this.match(/[A-Z][A-Za-z0-9]*/)) {
    eval("var that = " + this);
    return that;
  } else {
    throw "String#constantize: '" + this + "' is not a valid constant name.";
  }
};
/**
Returns a new string that is a more human readable version.

@name humanize
@methodOf String#
*/
String.prototype.humanize = function() {
  return this.replace(/_id$/, "").replace(/_/g, " ").capitalize();
};
/**
Returns true.

@name isString
@methodOf String#
@type Boolean
@returns true
*/
String.prototype.isString = function() {
  return true;
};
/**
Parse this string as though it is JSON and return the object it represents. If it
is not valid JSON returns the string itself.

@name parse
@methodOf String#

@returns Returns an object from the JSON this string contains. If it
is not valid JSON returns the string itself.
@type Object
*/
String.prototype.parse = function() {
  try {
    return JSON.parse(this);
  } catch (e) {
    return this.toString();
  }
};
/**
Returns a new string in Title Case.
@name titleize
@methodOf String#
*/
String.prototype.titleize = function() {
  return this.split(/[- ]/).map(function(word) {
    return word.capitalize();
  }).join(' ');
};
/**
Underscore a word, changing camelCased with under_scored.
@name underscore
@methodOf String#
*/
String.prototype.underscore = function() {
  return this.replace(/([A-Z]+)([A-Z][a-z])/g, '$1_$2').replace(/([a-z\d])([A-Z])/g, '$1_$2').replace(/-/g, '_').toLowerCase();
};
/**
Assumes the string is something like a file name and returns the 
contents of the string without the extension.

"neat.png".witouthExtension() => "neat"

@name withoutExtension
@methodOf String#
*/
String.prototype.withoutExtension = function() {
  return this.replace(/\.[^\.]*$/, '');
};;
/**
Non-standard



@name toSource
@methodOf Boolean#
*/
/**
Returns a string representing the specified Boolean object.

<code><em>bool</em>.toString()</code>

@name toString
@methodOf Boolean#
*/
/**
Returns the primitive value of a Boolean object.

<code><em>bool</em>.valueOf()</code>

@name valueOf
@methodOf Boolean#
*/
/**
Returns a string representing the Number object in exponential notation

<code><i>number</i>.toExponential( [<em>fractionDigits</em>] )</code>
@param  fractionDigits
An integer specifying the number of digits after the decimal point. Defaults
to as many digits as necessary to specify the number.
@name toExponential
@methodOf Number#
*/
/**
Formats a number using fixed-point notation

<code><i>number</i>.toFixed( [<em>digits</em>] )</code>
@param  digits   The number of digits to appear after the decimal point; this
may be a value between 0 and 20, inclusive, and implementations may optionally
support a larger range of values. If this argument is omitted, it is treated as
0.
@name toFixed
@methodOf Number#
*/
/**
number.toLocaleString();



@name toLocaleString
@methodOf Number#
*/
/**
Returns a string representing the Number object to the specified precision. 

<code><em>number</em>.toPrecision( [ <em>precision</em> ] )</code>
@param precision An integer specifying the number of significant digits.
@name toPrecision
@methodOf Number#
*/
/**
Non-standard



@name toSource
@methodOf Number#
*/
/**
Returns a string representing the specified Number object

<code><i>number</i>.toString( [<em>radix</em>] )</code>
@param  radix
An integer between 2 and 36 specifying the base to use for representing
numeric values.
@name toString
@methodOf Number#
*/
/**
Returns the primitive value of a Number object.



@name valueOf
@methodOf Number#
*/
/**
Returns the specified character from a string.

<code><em>string</em>.charAt(<em>index</em>)</code>
@param index  An integer between 0 and 1 less than the length of the string.
@name charAt
@methodOf String#
*/
/**
Returns the numeric Unicode value of the character at the given index (except
for unicode codepoints > 0x10000).


@param index  An integer greater than 0 and less than the length of the string;
if it is not a number, it defaults to 0.
@name charCodeAt
@methodOf String#
*/
/**
Combines the text of two or more strings and returns a new string.

<code><em>string</em>.concat(<em>string2</em>, <em>string3</em>[, ..., <em>stringN</em>])</code>
@param string2...stringN  Strings to concatenate to this string.
@name concat
@methodOf String#
*/
/**
Returns the index within the calling String object of the first occurrence of
the specified value, starting the search at fromIndex,
returns -1 if the value is not found.

<code><em>string</em>.indexOf(<em>searchValue</em>[, <em>fromIndex</em>]</code>
@param searchValue  A string representing the value to search for.
@param fromIndex  The location within the calling string to start the search
from. It can be any integer between 0 and the length of the string. The default
value is 0.
@name indexOf
@methodOf String#
*/
/**
Returns the index within the calling String object of the last occurrence of the
specified value, or -1 if not found. The calling string is searched backward,
starting at fromIndex.

<code><em>string</em>.lastIndexOf(<em>searchValue</em>[, <em>fromIndex</em>])</code>
@param searchValue  A string representing the value to search for.
@param fromIndex  The location within the calling string to start the search
from, indexed from left to right. It can be any integer between 0 and the length
of the string. The default value is the length of the string.
@name lastIndexOf
@methodOf String#
*/
/**
Returns a number indicating whether a reference string comes before or after or
is the same as the given string in sort order.

<code> localeCompare(compareString) </code>

@name localeCompare
@methodOf String#
*/
/**
Used to retrieve the matches when matching a string against a regular
expression.

<code><em>string</em>.match(<em>regexp</em>)</code>
@param regexp A regular expression object. If a non-RegExp object obj is passed,
it is implicitly converted to a RegExp by using new RegExp(obj).
@name match
@methodOf String#
*/
/**
Non-standard



@name quote
@methodOf String#
*/
/**
Returns a new string with some or all matches of a pattern replaced by a
replacement.  The pattern can be a string or a RegExp, and the replacement can
be a string or a function to be called for each match.

<code><em>str</em>.replace(<em>regexp|substr</em>, <em>newSubStr|function[</em>, </code><code><em>flags]</em>);</code>
@param regexp  A RegExp object. The match is replaced by the return value of
parameter #2.
@param substr  A String that is to be replaced by newSubStr.
@param newSubStr  The String that replaces the substring received from parameter
#1. A number of special replacement patterns are supported; see the "Specifying
a string as a parameter" section below.
@param function  A function to be invoked to create the new substring (to put in
place of the substring received from parameter #1). The arguments supplied to
this function are described in the "Specifying a function as a parameter"
section below.
@param flags gimy 

Non-standardThe use of the flags parameter in the String.replace method is
non-standard. For cross-browser compatibility, use a RegExp object with
corresponding flags.A string containing any combination of the RegExp flags: g
global match i ignore case m match over multiple lines y Non-standard     
sticky global matchignore casematch over multiple linesNon-standard     sticky
@name replace
@methodOf String#
*/
/**
Executes the search for a match between a regular expression and this String
object.

<code><em>string</em>.search(<em>regexp</em>)</code>
@param regexp  A  regular expression object. If a non-RegExp object obj is
passed, it is implicitly converted to a RegExp by using new RegExp(obj).
@name search
@methodOf String#
*/
/**
Extracts a section of a string and returns a new string.

<code><em>string</em>.slice(<em>beginslice</em>[, <em>endSlice</em>])</code>
@param beginSlice  The zero-based index at which to begin extraction.
@param endSlice  The zero-based index at which to end extraction. If omitted,
slice extracts to the end of the string.
@name slice
@methodOf String#
*/
/**
Splits a String object into an array of strings by separating the string into
substrings.

<code><em>string</em>.split([<em>separator</em>][, <em>limit</em>])</code>
@param separator  Specifies the character to use for separating the string. The
separator is treated as a string or a regular expression. If separator is
omitted, the array returned contains one element consisting of the entire
string.
@param limit  Integer specifying a limit on the number of splits to be found.
@name split
@methodOf String#
*/
/**
Returns the characters in a string beginning at the specified location through
the specified number of characters.

<code><em>string</em>.substr(<em>start</em>[, <em>length</em>])</code>
@param start  Location at which to begin extracting characters.
@param length  The number of characters to extract.
@name substr
@methodOf String#
*/
/**
Returns a subset of a string between one index and another, or through the end
of the string.

<code><em>string</em>.substring(<em>indexA</em>[, <em>indexB</em>])</code>
@param indexA  An integer between 0 and one less than the length of the string.
@param indexB  (optional) An integer between 0 and the length of the string.
@name substring
@methodOf String#
*/
/**
Returns the calling string value converted to lower case, according to any
locale-specific case mappings.

<code> toLocaleLowerCase() </code>

@name toLocaleLowerCase
@methodOf String#
*/
/**
Returns the calling string value converted to upper case, according to any
locale-specific case mappings.

<code> toLocaleUpperCase() </code>

@name toLocaleUpperCase
@methodOf String#
*/
/**
Returns the calling string value converted to lowercase.

<code><em>string</em>.toLowerCase()</code>

@name toLowerCase
@methodOf String#
*/
/**
Non-standard



@name toSource
@methodOf String#
*/
/**
Returns a string representing the specified object.

<code><em>string</em>.toString()</code>

@name toString
@methodOf String#
*/
/**
Returns the calling string value converted to uppercase.

<code><em>string</em>.toUpperCase()</code>

@name toUpperCase
@methodOf String#
*/
/**
Removes whitespace from both ends of the string.

<code><em>string</em>.trim()</code>

@name trim
@methodOf String#
*/
/**
Non-standard



@name trimLeft
@methodOf String#
*/
/**
Non-standard



@name trimRight
@methodOf String#
*/
/**
Returns the primitive value of a String object.

<code><em>string</em>.valueOf()</code>

@name valueOf
@methodOf String#
*/
/**
Non-standard



@name anchor
@methodOf String#
*/
/**
Non-standard



@name big
@methodOf String#
*/
/**
Non-standard

<code>BLINK</code>

@name blink
@methodOf String#
*/
/**
Non-standard



@name bold
@methodOf String#
*/
/**
Non-standard



@name fixed
@methodOf String#
*/
/**
Non-standard

<code>&lt;FONT COLOR="<i>color</i>"&gt;</code>

@name fontcolor
@methodOf String#
*/
/**
Non-standard

<code>&lt;FONT SIZE="<i>size</i>"&gt;</code>

@name fontsize
@methodOf String#
*/
/**
Non-standard



@name italics
@methodOf String#
*/
/**
Non-standard



@name link
@methodOf String#
*/
/**
Non-standard



@name small
@methodOf String#
*/
/**
Non-standard



@name strike
@methodOf String#
*/
/**
Non-standard



@name sub
@methodOf String#
*/
/**
Non-standard



@name sup
@methodOf String#
*/
/**
Removes the last element from an array and returns that element.

<code>
<i>array</i>.pop()
</code>

@name pop
@methodOf Array#
*/
/**
Mutates an array by appending the given elements and returning the new length of
the array.

<code><em>array</em>.push(<em>element1</em>, ..., <em>elementN</em>)</code>
@param element1, ..., elementN The elements to add to the end of the array.
@name push
@methodOf Array#
*/
/**
Reverses an array in place.  The first array element becomes the last and the
last becomes the first.

<code><em>array</em>.reverse()</code>

@name reverse
@methodOf Array#
*/
/**
Removes the first element from an array and returns that element. This method
changes the length of the array.

<code><em>array</em>.shift()</code>

@name shift
@methodOf Array#
*/
/**
Sorts the elements of an array in place.

<code><em>array</em>.sort([<em>compareFunction</em>])</code>
@param compareFunction  Specifies a function that defines the sort order. If
omitted, the array is sorted lexicographically (in dictionary order) according
to the string conversion of each element.
@name sort
@methodOf Array#
*/
/**
Changes the content of an array, adding new elements while removing old
elements.

<code><em>array</em>.splice(<em>index</em>, <em>howMany</em>[, <em>element1</em>[, ...[, <em>elementN</em>]]])</code>
@param index  Index at which to start changing the array. If negative, will
begin that many elements from the end.
@param howMany  An integer indicating the number of old array elements to
remove. If howMany is 0, no elements are removed. In this case, you should
specify at least one new element. If no howMany parameter is specified (second
syntax above, which is a SpiderMonkey extension), all elements after index are
removed.
@param element1, ..., elementN  The elements to add to the array. If you don't
specify any elements, splice simply removes elements from the array.
@name splice
@methodOf Array#
*/
/**
Adds one or more elements to the beginning of an array and returns the new
length of the array.

<code><em>arrayName</em>.unshift(<em>element1</em>, ..., <em>elementN</em>) </code>
@param element1, ..., elementN The elements to add to the front of the array.
@name unshift
@methodOf Array#
*/
/**
Returns a new array comprised of this array joined with other array(s) and/or
value(s).

<code><em>array</em>.concat(<em>value1</em>, <em>value2</em>, ..., <em>valueN</em>)</code>
@param valueN  Arrays and/or values to concatenate to the resulting array.
@name concat
@methodOf Array#
*/
/**
Joins all elements of an array into a string.

<code><em>array</em>.join(<em>separator</em>)</code>
@param separator  Specifies a string to separate each element of the array. The
separator is converted to a string if necessary. If omitted, the array elements
are separated with a comma.
@name join
@methodOf Array#
*/
/**
Returns a one-level deep copy of a portion of an array.

<code><em>array</em>.slice(<em>begin</em>[, <em>end</em>])</code>
@param begin  Zero-based index at which to begin extraction.As a negative index,
start indicates an offset from the end of the sequence. slice(-2) extracts the
second-to-last element and the last element in the sequence.
@param end  Zero-based index at which to end extraction. slice extracts up to
but not including end.slice(1,4) extracts the second element through the fourth
element (elements indexed 1, 2, and 3).As a negative index, end indicates an
offset from the end of the sequence. slice(2,-1) extracts the third element
through the second-to-last element in the sequence.If end is omitted, slice
extracts to the end of the sequence.
@name slice
@methodOf Array#
*/
/**
Non-standard



@name toSource
@methodOf Array#
*/
/**
Returns a string representing the specified array and its elements.

<code><em>array</em>.toString()</code>

@name toString
@methodOf Array#
*/
/**
Returns the first index at which a given element can be found in the array, or
-1 if it is not present.

<code><em>array</em>.indexOf(<em>searchElement</em>[, <em>fromIndex</em>])</code>
@param searchElement fromIndex  Element to locate in the array.The index at
which to begin the search. Defaults to 0, i.e. the whole array will be searched.
If the index is greater than or equal to the length of the array, -1 is
returned, i.e. the array will not be searched. If negative, it is taken as the
offset from the end of the array. Note that even when the index is negative, the
array is still searched from front to back. If the calculated index is less than
0, the whole array will be searched.
@name indexOf
@methodOf Array#
*/
/**
Returns the last index at which a given element can be found in the array, or -1
if it is not present. The array is searched backwards, starting at fromIndex.

<code><em>array</em>.lastIndexOf(<em>searchElement</em>[, <em>fromIndex</em>])</code>
@param searchElement fromIndex  Element to locate in the array.The index at
which to start searching backwards. Defaults to the array's length, i.e. the
whole array will be searched. If the index is greater than or equal to the
length of the array, the whole array will be searched. If negative, it is taken
as the offset from the end of the array. Note that even when the index is
negative, the array is still searched from back to front. If the calculated
index is less than 0, -1 is returned, i.e. the array will not be searched.
@name lastIndexOf
@methodOf Array#
*/
/**
Creates a new array with all elements that pass the test implemented by the
provided function.

<code><em>array</em>.filter(<em>callback</em>[, <em>thisObject</em>])</code>
@param callback thisObject  Function to test each element of the array.Object to
use as this when executing callback.
@name filter
@methodOf Array#
*/
/**
Executes a provided function once per array element.

<code><em>array</em>.forEach(<em>callback</em>[, <em>thisObject</em>])</code>
@param callback thisObject  Function to execute for each element.Object to use
as this when executing callback.
@name forEach
@methodOf Array#
*/
/**
Tests whether all elements in the array pass the test implemented by the
provided function.

<code><em>array</em>.every(<em>callback</em>[, <em>thisObject</em>])</code>
@param callbackthisObject Function to test for each element.Object to use as
this when executing callback.
@name every
@methodOf Array#
*/
/**
Creates a new array with the results of calling a provided function on every
element in this array.

<code><em>array</em>.map(<em>callback</em>[, <em>thisObject</em>])</code>
@param callbackthisObject Function that produces an element of the new Array
from an element of the current one.Object to use as this when executing
callback.
@name map
@methodOf Array#
*/
/**
Tests whether some element in the array passes the test implemented by the
provided function.

<code><em>array</em>.some(<em>callback</em>[, <em>thisObject</em>])</code>
@param callback thisObject  Function to test for each element.Object to use as
this when executing callback.
@name some
@methodOf Array#
*/
/**
Apply a function against an accumulator and each value of the array (from
left-to-right) as to reduce it to a single value.

<code><em>array</em>.reduce(<em>callback</em>[, <em>initialValue</em>])</code>
@param callbackinitialValue Function to execute on each value in the
array.Object to use as the first argument to the first call of the callback.
@name reduce
@methodOf Array#
*/
/**
Apply a function simultaneously against two values of the array (from
right-to-left) as to reduce it to a single value.

<code><em>array</em>.reduceRight(<em>callback</em>[, <em>initialValue</em>])</code>
@param callback initialValue  Function to execute on each value in the
array.Object to use as the first argument to the first call of the callback.
@name reduceRight
@methodOf Array#
*/
/**
Returns a boolean indicating whether the object has the specified property.

<code><em>obj</em>.hasOwnProperty(<em>prop</em>)</code>
@param prop The name of the property to test.
@name hasOwnProperty
@methodOf Object#
*/
/**
Calls a function with a given this value and arguments provided as an array.

<code><em>fun</em>.apply(<em>thisArg</em>[, <em>argsArray</em>])</code>
@param thisArg  Determines the value of this inside fun. If thisArg is null or
undefined, this will be the global object. Otherwise, this will be equal to
Object(thisArg) (which is thisArg if thisArg is already an object, or a String,
Boolean, or Number if thisArg is a primitive value of the corresponding type).
Therefore, it is always true that typeof this == "object" when the function
executes.
@param argsArray  An argument array for the object, specifying the arguments
with which fun should be called, or null or undefined if no arguments should be
provided to the function.
@name apply
@methodOf Function#
*/
/**
Creates a new function that, when called, itself calls this function in the
context of the provided this value, with a given sequence of arguments preceding
any provided when the new function was called.

<code><em>fun</em>.bind(<em>thisArg</em>[, <em>arg1</em>[, <em>arg2</em>[, ...]]])</code>
@param thisValuearg1, arg2, ... The value to be passed as the this parameter to
the target function when the bound function is called.  The value is ignored if
the bound function is constructed using the new operator.Arguments to prepend to
arguments provided to the bound function when invoking the target function.
@name bind
@methodOf Function#
*/
/**
Calls a function with a given this value and arguments provided individually.

<code><em>fun</em>.call(<em>thisArg</em>[, <em>arg1</em>[, <em>arg2</em>[, ...]]])</code>
@param thisArg  Determines the value of this inside fun. If thisArg is null or
undefined, this will be the global object. Otherwise, this will be equal to
Object(thisArg) (which is thisArg if thisArg is already an object, or a String,
Boolean, or Number if thisArg is a primitive value of the corresponding type).
Therefore, it is always true that typeof this == "object" when the function
executes.
@param arg1, arg2, ...  Arguments for the object.
@name call
@methodOf Function#
*/
/**
Non-standard



@name toSource
@methodOf Function#
*/
/**
Returns a string representing the source code of the function.

<code><em>function</em>.toString(<em>indentation</em>)</code>
@param indentation Non-standard     The amount of spaces to indent the string
representation of the source code. If indentation is less than or equal to -1,
most unnecessary spaces are removed.
@name toString
@methodOf Function#
*/
/**
Executes a search for a match in a specified string. Returns a result array, or
null.


@param regexp  The name of the regular expression. It can be a variable name or
a literal.
@param str  The string against which to match the regular expression.
@name exec
@methodOf RegExp#
*/
/**
Executes the search for a match between a regular expression and a specified
string. Returns true or false.

<code> <em>regexp</em>.test([<em>str</em>]) </code>
@param regexp  The name of the regular expression. It can be a variable name or
a literal.
@param str  The string against which to match the regular expression.
@name test
@methodOf RegExp#
*/
/**
Non-standard



@name toSource
@methodOf RegExp#
*/
/**
Returns a string representing the specified object.

<code><i>regexp</i>.toString()</code>

@name toString
@methodOf RegExp#
*/
/**
Returns a reference to the Date function that created the instance's prototype.
Note that the value of this property is a reference to the function itself, not
a string containing the function's name.



@name constructor
@methodOf Date#
*/
/**
Returns the day of the month for the specified date according to local time.

<code>
getDate()
</code>

@name getDate
@methodOf Date#
*/
/**
Returns the day of the week for the specified date according to local time.

<code>
getDay()
</code>

@name getDay
@methodOf Date#
*/
/**
Returns the year of the specified date according to local time.

<code>
getFullYear()
</code>

@name getFullYear
@methodOf Date#
*/
/**
Returns the hour for the specified date according to local time.

<code>
getHours()
</code>

@name getHours
@methodOf Date#
*/
/**
Returns the milliseconds in the specified date according to local time.

<code>
getMilliseconds()
</code>

@name getMilliseconds
@methodOf Date#
*/
/**
Returns the minutes in the specified date according to local time.

<code>
getMinutes()
</code>

@name getMinutes
@methodOf Date#
*/
/**
Returns the month in the specified date according to local time.

<code>
getMonth()
</code>

@name getMonth
@methodOf Date#
*/
/**
Returns the seconds in the specified date according to local time.

<code>
getSeconds()
</code>

@name getSeconds
@methodOf Date#
*/
/**
Returns the numeric value corresponding to the time for the specified date
according to universal time.

<code> getTime() </code>

@name getTime
@methodOf Date#
*/
/**
Returns the time-zone offset from UTC, in minutes, for the current locale.

<code> getTimezoneOffset() </code>

@name getTimezoneOffset
@methodOf Date#
*/
/**
Returns the day (date) of the month in the specified date according to universal
time.

<code>
getUTCDate()
</code>

@name getUTCDate
@methodOf Date#
*/
/**
Returns the day of the week in the specified date according to universal time.

<code>
getUTCDay()
</code>

@name getUTCDay
@methodOf Date#
*/
/**
Returns the year in the specified date according to universal time.

<code>
getUTCFullYear()
</code>

@name getUTCFullYear
@methodOf Date#
*/
/**
Returns the hours in the specified date according to universal time.

<code>
getUTCHours
</code>

@name getUTCHours
@methodOf Date#
*/
/**
Returns the milliseconds in the specified date according to universal time.

<code>
getUTCMilliseconds()
</code>

@name getUTCMilliseconds
@methodOf Date#
*/
/**
Returns the minutes in the specified date according to universal time.

<code>
getUTCMinutes()
</code>

@name getUTCMinutes
@methodOf Date#
*/
/**
Returns the month of the specified date according to universal time.

<code>
getUTCMonth()
</code>

@name getUTCMonth
@methodOf Date#
*/
/**
Returns the seconds in the specified date according to universal time.

<code>
getUTCSeconds()
</code>

@name getUTCSeconds
@methodOf Date#
*/
/**
Deprecated



@name getYear
@methodOf Date#
*/
/**
Sets the day of the month for a specified date according to local time.

<code> setDate(<em>dayValue</em>) </code>
@param dayValue  An integer from 1 to 31, representing the day of the month.
@name setDate
@methodOf Date#
*/
/**
Sets the full year for a specified date according to local time.

<code>
setFullYear(<i>yearValue</i>[, <i>monthValue</i>[, <em>dayValue</em>]])
</code>
@param  yearValue   An integer specifying the numeric value of the year, for
example, 1995.
@param  monthValue   An integer between 0 and 11 representing the months January
through December.
@param  dayValue   An integer between 1 and 31 representing the day of the
month. If you specify the dayValue parameter, you must also specify the
monthValue.
@name setFullYear
@methodOf Date#
*/
/**
Sets the hours for a specified date according to local time.

<code>
setHours(<i>hoursValue</i>[, <i>minutesValue</i>[, <i>secondsValue</i>[, <em>msValue</em>]]])
</code>
@param  hoursValue   An integer between 0 and 23, representing the hour. 
@param  minutesValue   An integer between 0 and 59, representing the minutes. 
@param  secondsValue   An integer between 0 and 59, representing the seconds. If
you specify the secondsValue parameter, you must also specify the minutesValue.
@param  msValue   A number between 0 and 999, representing the milliseconds. If
you specify the msValue parameter, you must also specify the minutesValue and
secondsValue.
@name setHours
@methodOf Date#
*/
/**
Sets the milliseconds for a specified date according to local time.

<code>
setMilliseconds(<i>millisecondsValue</i>)
</code>
@param  millisecondsValue   A number between 0 and 999, representing the
milliseconds.
@name setMilliseconds
@methodOf Date#
*/
/**
Sets the minutes for a specified date according to local time.

<code>
setMinutes(<i>minutesValue</i>[, <i>secondsValue</i>[, <em>msValue</em>]])
</code>
@param  minutesValue   An integer between 0 and 59, representing the minutes. 
@param  secondsValue   An integer between 0 and 59, representing the seconds. If
you specify the secondsValue parameter, you must also specify the minutesValue.
@param  msValue   A number between 0 and 999, representing the milliseconds. If
you specify the msValue parameter, you must also specify the minutesValue and
secondsValue.
@name setMinutes
@methodOf Date#
*/
/**
Set the month for a specified date according to local time.

<code>
setMonth(<i>monthValue</i>[, <em>dayValue</em>])
</code>
@param  monthValue   An integer between 0 and 11 (representing the months
January through December).
@param  dayValue   An integer from 1 to 31, representing the day of the month.
@name setMonth
@methodOf Date#
*/
/**
Sets the seconds for a specified date according to local time.

<code>
setSeconds(<i>secondsValue</i>[, <em>msValue</em>])
</code>
@param  secondsValue   An integer between 0 and 59. 
@param  msValue   A number between 0 and 999, representing the milliseconds.
@name setSeconds
@methodOf Date#
*/
/**
Sets the Date object to the time represented by a number of milliseconds since
January 1, 1970, 00:00:00 UTC.

<code>
setTime(<i>timeValue</i>)
</code>
@param  timeValue   An integer representing the number of milliseconds since 1
January 1970, 00:00:00 UTC.
@name setTime
@methodOf Date#
*/
/**
Sets the day of the month for a specified date according to universal time.

<code>
setUTCDate(<i>dayValue</i>)
</code>
@param  dayValue   An integer from 1 to 31, representing the day of the month.
@name setUTCDate
@methodOf Date#
*/
/**
Sets the full year for a specified date according to universal time.

<code>
setUTCFullYear(<i>yearValue</i>[, <i>monthValue</i>[, <em>dayValue</em>]])
</code>
@param  yearValue   An integer specifying the numeric value of the year, for
example, 1995.
@param  monthValue   An integer between 0 and 11 representing the months January
through December.
@param  dayValue   An integer between 1 and 31 representing the day of the
month. If you specify the dayValue parameter, you must also specify the
monthValue.
@name setUTCFullYear
@methodOf Date#
*/
/**
Sets the hour for a specified date according to universal time.

<code>
setUTCHours(<i>hoursValue</i>[, <i>minutesValue</i>[, <i>secondsValue</i>[, <em>msValue</em>]]])
</code>
@param  hoursValue   An integer between 0 and 23, representing the hour. 
@param  minutesValue   An integer between 0 and 59, representing the minutes. 
@param  secondsValue   An integer between 0 and 59, representing the seconds. If
you specify the secondsValue parameter, you must also specify the minutesValue.
@param  msValue   A number between 0 and 999, representing the milliseconds. If
you specify the msValue parameter, you must also specify the minutesValue and
secondsValue.
@name setUTCHours
@methodOf Date#
*/
/**
Sets the milliseconds for a specified date according to universal time.

<code>
setUTCMilliseconds(<i>millisecondsValue</i>)
</code>
@param  millisecondsValue   A number between 0 and 999, representing the
milliseconds.
@name setUTCMilliseconds
@methodOf Date#
*/
/**
Sets the minutes for a specified date according to universal time.

<code>
setUTCMinutes(<i>minutesValue</i>[, <i>secondsValue</i>[, <em>msValue</em>]])
</code>
@param  minutesValue   An integer between 0 and 59, representing the minutes. 
@param  secondsValue   An integer between 0 and 59, representing the seconds. If
you specify the secondsValue parameter, you must also specify the minutesValue.
@param  msValue   A number between 0 and 999, representing the milliseconds. If
you specify the msValue parameter, you must also specify the minutesValue and
secondsValue.
@name setUTCMinutes
@methodOf Date#
*/
/**
Sets the month for a specified date according to universal time.

<code>
setUTCMonth(<i>monthValue</i>[, <em>dayValue</em>])
</code>
@param  monthValue   An integer between 0 and 11, representing the months
January through December.
@param  dayValue   An integer from 1 to 31, representing the day of the month.
@name setUTCMonth
@methodOf Date#
*/
/**
Sets the seconds for a specified date according to universal time.

<code>
setUTCSeconds(<i>secondsValue</i>[, <em>msValue</em>])
</code>
@param  secondsValue   An integer between 0 and 59. 
@param  msValue   A number between 0 and 999, representing the milliseconds.
@name setUTCSeconds
@methodOf Date#
*/
/**
Deprecated



@name setYear
@methodOf Date#
*/
/**
Returns the date portion of a Date object in human readable form in American
English.

<code><em>date</em>.toDateString()</code>

@name toDateString
@methodOf Date#
*/
/**
Returns a JSON representation of the Date object.

<code><em>date</em>.prototype.toJSON()</code>

@name toJSON
@methodOf Date#
*/
/**
Deprecated



@name toGMTString
@methodOf Date#
*/
/**
Converts a date to a string, returning the "date" portion using the operating
system's locale's conventions.

<code>
toLocaleDateString()
</code>

@name toLocaleDateString
@methodOf Date#
*/
/**
Non-standard



@name toLocaleFormat
@methodOf Date#
*/
/**
Converts a date to a string, using the operating system's locale's conventions.

<code>
toLocaleString()
</code>

@name toLocaleString
@methodOf Date#
*/
/**
Converts a date to a string, returning the "time" portion using the current
locale's conventions.

<code> toLocaleTimeString() </code>

@name toLocaleTimeString
@methodOf Date#
*/
/**
Non-standard



@name toSource
@methodOf Date#
*/
/**
Returns a string representing the specified Date object.

<code> toString() </code>

@name toString
@methodOf Date#
*/
/**
Returns the time portion of a Date object in human readable form in American
English.

<code><em>date</em>.toTimeString()</code>

@name toTimeString
@methodOf Date#
*/
/**
Converts a date to a string, using the universal time convention.

<code> toUTCString() </code>

@name toUTCString
@methodOf Date#
*/
/**
Returns the primitive value of a Date object.

<code>
valueOf()
</code>

@name valueOf
@methodOf Date#
*/;
/*!
Math.uuid.js (v1.4)
http://www.broofa.com
mailto:robert@broofa.com

Copyright (c) 2010 Robert Kieffer
Dual licensed under the MIT and GPL licenses.
*/

/**
Generate a random uuid.

USAGE: Math.uuid(length, radix)

EXAMPLES:
  // No arguments  - returns RFC4122, version 4 ID
  Math.uuid()
  "92329D39-6F5C-4520-ABFC-AAB64544E172"

  // One argument - returns ID of the specified length
  Math.uuid(15)     // 15 character ID (default base=62)
  "VcydxgltxrVZSTV"

  // Two arguments - returns ID of the specified length, and radix. (Radix must be <= 62)
  Math.uuid(8, 2)  // 8 character ID (base=2)
  "01001010"
  Math.uuid(8, 10) // 8 character ID (base=10)
  "47473046"
  Math.uuid(8, 16) // 8 character ID (base=16)
  "098F4D35"
  
@name uuid
@methodOf Math
@param length The desired number of characters
@param radix  The number of allowable values for each character.
 */
(function() {
  // Private array of chars to use
  var CHARS = '0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz'.split(''); 

  Math.uuid = function (len, radix) {
    var chars = CHARS, uuid = [];
    radix = radix || chars.length;

    if (len) {
      // Compact form
      for (var i = 0; i < len; i++) uuid[i] = chars[0 | Math.random()*radix];
    } else {
      // rfc4122, version 4 form
      var r;

      // rfc4122 requires these characters
      uuid[8] = uuid[13] = uuid[18] = uuid[23] = '-';
      uuid[14] = '4';

      // Fill in random data.  At i==19 set the high bits of clock sequence as
      // per rfc4122, sec. 4.1.5
      for (var i = 0; i < 36; i++) {
        if (!uuid[i]) {
          r = 0 | Math.random()*16;
          uuid[i] = chars[(i == 19) ? (r & 0x3) | 0x8 : r];
        }
      }
    }

    return uuid.join('');
  };

  // A more performant, but slightly bulkier, RFC4122v4 solution.  We boost performance
  // by minimizing calls to random()
  Math.uuidFast = function() {
    var chars = CHARS, uuid = new Array(36), rnd=0, r;
    for (var i = 0; i < 36; i++) {
      if (i==8 || i==13 ||  i==18 || i==23) {
        uuid[i] = '-';
      } else if (i==14) {
        uuid[i] = '4';
      } else {
        if (rnd <= 0x02) rnd = 0x2000000 + (Math.random()*0x1000000)|0;
        r = rnd & 0xf;
        rnd = rnd >> 4;
        uuid[i] = chars[(i == 19) ? (r & 0x3) | 0x8 : r];
      }
    }
    return uuid.join('');
  };

  // A more compact, but less performant, RFC4122v4 solution:
  Math.uuidCompact = function() {
    return 'xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'.replace(/[xy]/g, function(c) {
      var r = Math.random()*16|0, v = c == 'x' ? r : (r&0x3|0x8);
      return v.toString(16);
    }).toUpperCase();
  };
})();;
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
    useTimer: false,
    transform: Matrix.IDENTITY
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
    var frames, nextState, sprite, _ref2, _ref3, _ref4, _ref5;
    frames = I.activeAnimation.frames;
    I.hflip = (_ref2 = I.activeAnimation.transform) != null ? (_ref3 = _ref2[I.currentFrameIndex]) != null ? _ref3.hflip : void 0 : void 0;
    I.vflip = (_ref4 = I.activeAnimation.transform) != null ? (_ref5 = _ref4[I.currentFrameIndex]) != null ? _ref5.vflip : void 0 : void 0;
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
        var firstFrame, firstSprite, nextState, _ref2, _ref3, _ref4, _ref5;
        if (nextState = find(state)) {
          I.activeAnimation = nextState;
          firstFrame = I.activeAnimation.frames.first();
          firstSprite = I.spriteLookup[firstFrame];
          I.currentFrameIndex = 0;
          updateSprite(firstSprite);
          I.hflip = (_ref2 = I.activeAnimation.transform) != null ? (_ref3 = _ref2[I.currentFrameIndex]) != null ? _ref3.hflip : void 0 : void 0;
          return I.vflip = (_ref4 = I.activeAnimation.transform) != null ? (_ref5 = _ref4[I.currentFrameIndex]) != null ? _ref5.vflip : void 0 : void 0;
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
    transform: function() {
      return I.transform;
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
/**
Bindable module
@name Bindable
@module
@constructor
*/var Bindable;
var __slice = Array.prototype.slice;
Bindable = function() {
  var eventCallbacks;
  eventCallbacks = {};
  return {
    /**
    The bind method adds a function as an event listener.
    
    @name bind
    @methodOf Bindable#
    
    @param {String} event The event to listen to.
    @param {Function} callback The function to be called when the specified event
    is triggered.
    */
    bind: function(event, callback) {
      eventCallbacks[event] = eventCallbacks[event] || [];
      return eventCallbacks[event].push(callback);
    },
    /**
    The unbind method removes a specific event listener, or all event listeners if
    no specific listener is given.
    
    @name unbind
    @methodOf Bindable#
    
    @param {String} event The event to remove the listener from.
    @param {Function} [callback] The listener to remove.
    */
    unbind: function(event, callback) {
      eventCallbacks[event] = eventCallbacks[event] || [];
      if (callback) {
        return eventCallbacks[event].remove(callback);
      } else {
        return eventCallbacks[event] = [];
      }
    },
    /**
    The trigger method calls all listeners attached to the specified event.
    
    @name trigger
    @methodOf Bindable#
    
    @param {String} event The event to trigger.
    @param {Array} [parameters] Additional parameters to pass to the event listener.
    */
    trigger: function() {
      var callbacks, event, parameters, self;
      event = arguments[0], parameters = 2 <= arguments.length ? __slice.call(arguments, 1) : [];
      callbacks = eventCallbacks[event];
      if (callbacks && callbacks.length) {
        self = this;
        return callbacks.each(function(callback) {
          return callback.apply(self, parameters);
        });
      }
    }
  };
};
window.Bindable = Bindable;;
/**
The Bounded module is used to provide basic data about the
location and dimensions of the including object

Bounded module
@name Bounded
@module
@constructor

@param {Object} I Instance variables
@param {Object} self Reference to including object
*/var Bounded;
Bounded = function(I, self) {
  I || (I = {});
  $.reverseMerge(I, {
    x: 0,
    y: 0,
    width: 8,
    height: 8,
    collisionMargin: Point(0, 0)
  });
  return {
    /**
    The position of this game object, the top left point in the local transform.
    
    @returns The position of this object
    @type Point
    */
    position: function() {
      return Point(I.x, I.y);
    },
    collides: function(bounds) {
      return Collision.rectangular(I, bounds);
    },
    /**
    This returns a modified bounds based on the collision margin.
    The area of the bounds is reduced if collision margin is positive
    and increased if collision margin is negative.
    
    @name collisionBounds
    @methodOf Bounded#
    
    @param {number} xOffset the amount to shift the x position 
    @param {number} yOffset the amount to shift the y position
    */
    collisionBounds: function(xOffset, yOffset) {
      var bounds;
      bounds = self.bounds(xOffset, yOffset);
      bounds.x += I.collisionMargin.x;
      bounds.y += I.collisionMargin.y;
      bounds.width -= 2 * I.collisionMargin.x;
      bounds.height -= 2 * I.collisionMargin.y;
      return bounds;
    },
    /**
    The bounds method returns infomation about the location 
    of the object and its dimensions with optional offsets
    
    @name bounds
    @methodOf Bounded#
    
    @param {number} xOffset the amount to shift the x position 
    @param {number} yOffset the amount to shift the y position
    */
    bounds: function(xOffset, yOffset) {
      return {
        x: I.x + (xOffset || 0),
        y: I.y + (yOffset || 0),
        width: I.width,
        height: I.height
      };
    },
    /**
    The centeredBounds method returns infomation about the center
    of the object along with the midpoint of the width and height
    
    @name centeredBounds
    @methodOf Bounded#
    */
    centeredBounds: function() {
      return {
        x: I.x + I.width / 2,
        y: I.y + I.height / 2,
        xw: I.width / 2,
        yw: I.height / 2
      };
    },
    /**
    The center method returns the {@link Point} that is
    the center of the object
    
    @name center
    @methodOf Bounded#
    */
    center: function() {
      return Point(I.x + I.width / 2, I.y + I.height / 2);
    },
    /**
    Return the circular bounds of the object. The circle is
    centered at the midpoint of the object.
    
    @name circle
    @methodOf Bounded#
    */
    circle: function() {
      var circle;
      circle = self.center();
      circle.radius = I.radius || I.width / 2 || I.height / 2;
      return circle;
    }
  };
};;
/**
Collision holds many useful methods for checking geometric overlap of various objects.

@name Collision
@namespace
*/var Collision;
Collision = {
  /**
    Takes two bounds objects and returns true if they collide (overlap), false otherwise.
    Bounds objects have x, y, width and height properties.
  
    @name rectangular
    @methodOf Collision
  
    @param a
    @param b
    */
  rectangular: function(a, b) {
    return a.x < b.x + b.width && a.x + a.width > b.x && a.y < b.y + b.height && a.y + a.height > b.y;
  },
  /**
  Takes two circle objects and returns true if they collide (overlap), false otherwise.
  Circle objects have x, y, and radius.
  
  @name circular
  @methodOf Collision
  
  @param a
  @param b
  */
  circular: function(a, b) {
    var dx, dy, r;
    r = a.radius + b.radius;
    dx = b.x - a.x;
    dy = b.y - a.y;
    return r * r >= dx * dx + dy * dy;
  },
  rayCircle: function(source, direction, target) {
    var dt, hit, intersection, intersectionToTarget, intersectionToTargetLength, laserToTarget, projection, projectionLength, radius;
    radius = target.radius();
    target = target.position();
    laserToTarget = target.subtract(source);
    projectionLength = direction.dot(laserToTarget);
    if (projectionLength < 0) {
      return false;
    }
    projection = direction.scale(projectionLength);
    intersection = source.add(projection);
    intersectionToTarget = target.subtract(intersection);
    intersectionToTargetLength = intersectionToTarget.length();
    if (intersectionToTargetLength < radius) {
      hit = true;
    }
    if (hit) {
      dt = Math.sqrt(radius * radius - intersectionToTargetLength * intersectionToTargetLength);
      return hit = direction.scale(projectionLength - dt).add(source);
    }
  },
  rayRectangle: function(source, direction, target) {
    var areaPQ0, areaPQ1, hit, p0, p1, t, tX, tY, xval, xw, yval, yw, _ref, _ref2;
    xw = target.xw;
    yw = target.yw;
    if (source.x < target.x) {
      xval = target.x - xw;
    } else {
      xval = target.x + xw;
    }
    if (source.y < target.y) {
      yval = target.y - yw;
    } else {
      yval = target.y + yw;
    }
    if (direction.x === 0) {
      p0 = Point(target.x - xw, yval);
      p1 = Point(target.x + xw, yval);
      t = (yval - source.y) / direction.y;
    } else if (direction.y === 0) {
      p0 = Point(xval, target.y - yw);
      p1 = Point(xval, target.y + yw);
      t = (xval - source.x) / direction.x;
    } else {
      tX = (xval - source.x) / direction.x;
      tY = (yval - source.y) / direction.y;
      if ((tX < tY || ((-xw < (_ref = source.x - target.x) && _ref < xw))) && !((-yw < (_ref2 = source.y - target.y) && _ref2 < yw))) {
        p0 = Point(target.x - xw, yval);
        p1 = Point(target.x + xw, yval);
        t = tY;
      } else {
        p0 = Point(xval, target.y - yw);
        p1 = Point(xval, target.y + yw);
        t = tX;
      }
    }
    if (t > 0) {
      areaPQ0 = direction.cross(p0.subtract(source));
      areaPQ1 = direction.cross(p1.subtract(source));
      if (areaPQ0 * areaPQ1 < 0) {
        return hit = direction.scale(t).add(source);
      }
    }
  }
};;
/*
The Drawable module is used to provide a simple draw method to the including
object.

Binds a default draw listener to draw a rectangle or a sprite, if one exists.

Binds a step listener to update the transform of the object.

Autoloads the sprite specified in I.spriteName, if any.

@name Drawable
@module
@constructor

@param {Object} I Instance variables
@param {Object} self Reference to including object
*/
/**
Triggered every time the object should be drawn. A canvas is passed as
the first argument.

@name draw
@methodOf Drawable#
@event
*/var Drawable;
Drawable = function(I, self) {
  var _ref;
  I || (I = {});
  $.reverseMerge(I, {
    color: "#196",
    hflip: false,
    vflip: false,
    spriteName: null,
    zIndex: 0
  });
  if ((_ref = I.sprite) != null ? typeof _ref.isString === "function" ? _ref.isString() : void 0 : void 0) {
    I.sprite = Sprite.loadByName(I.sprite, function(sprite) {
      I.width = sprite.width;
      return I.height = sprite.height;
    });
  } else if (I.spriteName) {
    I.sprite = Sprite.loadByName(I.spriteName, function(sprite) {
      I.width = sprite.width;
      return I.height = sprite.height;
    });
  }
  self.bind('draw', function(canvas) {
    if (I.sprite) {
      if (I.sprite.draw != null) {
        return I.sprite.draw(canvas, 0, 0);
      } else {
        return typeof warn === "function" ? warn("Sprite has no draw method!") : void 0;
      }
    } else {
      canvas.fillColor(I.color);
      return canvas.fillRect(0, 0, I.width, I.height);
    }
  });
  return {
    /**
    Draw does not actually do any drawing itself, instead it triggers all of the draw events.
    Listeners on the events do the actual drawing.
    
    @name draw
    @methodOf Drawable#
    @returns self
    */
    draw: function(canvas) {
      self.trigger('beforeTransform', canvas);
      canvas.withTransform(self.getTransform(), function(canvas) {
        return self.trigger('draw', canvas);
      });
      self.trigger('afterTransform', canvas);
      return self;
    },
    /**
    Returns the current transform, with translation, rotation, and flipping applied.
    
    @name getTransform
    @methodOf Drawable#
    @type Matrix
    */
    getTransform: function() {
      var centerX, centerY, transform;
      centerX = (I.x + I.width / 2).floor();
      centerY = (I.y + I.height / 2).floor();
      transform = Matrix.translation(centerX, centerY);
      if (I.rotation) {
        transform = transform.concat(Matrix.rotation(I.rotation));
      }
      if (I.hflip) {
        transform = transform.concat(Matrix.HORIZONTAL_FLIP);
      }
      if (I.vflip) {
        transform = transform.concat(Matrix.VERTICAL_FLIP);
      }
      transform = transform.concat(Matrix.translation(-I.width / 2, -I.height / 2));
      if (I.spriteOffset) {
        transform = transform.concat(Matrix.translation(I.spriteOffset.x, I.spriteOffset.y));
      }
      return transform;
    }
  };
};;
/**
The Durable module deactives GameObjects after a specified duration.
If a duration is specified the object will update that many times. If -1 is
specified the object will have an unlimited duration.

@name Durable
@module
@constructor

@param {Object} I Instance variables
*/var Durable;
Durable = function(I) {
  $.reverseMerge(I, {
    duration: -1
  });
  return {
    before: {
      update: function() {
        if (I.duration !== -1 && I.age >= I.duration) {
          return I.active = false;
        }
      }
    }
  };
};;
var Emitter;
Emitter = function(I) {
  var self;
  self = GameObject(I);
  return self.include(Emitterable);
};;
var Emitterable;
Emitterable = function(I, self) {
  var n, particles;
  I || (I = {});
  $.reverseMerge(I, {
    batchSize: 1,
    emissionRate: 1,
    color: "blue",
    width: 0,
    height: 0,
    generator: {},
    particleCount: Infinity,
    particleData: {
      acceleration: Point(0, 0.1),
      age: 0,
      color: "blue",
      duration: 30,
      includedModules: ["Movable"],
      height: 2,
      maxSpeed: 2,
      offset: Point(0, 0),
      sprite: false,
      spriteName: false,
      velocity: Point(-0.25, 1),
      width: 2
    }
  });
  particles = [];
  n = 0;
  return {
    before: {
      draw: function(canvas) {
        return particles.invoke("draw", canvas);
      },
      update: function() {
        I.batchSize.times(function() {
          var center, particleProperties;
          if (n < I.particleCount && rand() < I.emissionRate) {
            center = self.center();
            particleProperties = $.reverseMerge({
              x: center.x,
              y: center.y
            }, I.particleData);
            $.each(I.generator, function(key, value) {
              if (I.generator[key].call) {
                return particleProperties[key] = I.generator[key](n, I);
              } else {
                return particleProperties[key] = I.generator[key];
              }
            });
            particleProperties.x += particleProperties.offset.x;
            particleProperties.y += particleProperties.offset.y;
            particles.push(GameObject(particleProperties));
            return n += 1;
          }
        });
        particles = particles.select(function(particle) {
          return particle.update();
        });
        if (n === I.particleCount && !particles.length) {
          return I.active = false;
        }
      }
    }
  };
};;
(function($) {
  var defaults;
  defaults = {
    FPS: 30,
    age: 0,
    ambientLight: 1,
    backgroundColor: "#00010D",
    cameraTransform: Matrix.IDENTITY,
    excludedModules: [],
    includedModules: [],
    paused: false,
    showFPS: false,
    zSort: false
  };
  document.oncontextmenu = function() {
    return false;
  };
  $(document).bind("keydown", function(event) {
    return event.preventDefault();
  });
  /**
  The Engine controls the game world and manages game state. Once you 
  set it up and let it run it pretty much takes care of itself.
  
  You can use the engine to add or remove objects from the game world.
  
  There are several modules that can include to add additional capabilities 
  to the engine.
  
  The engine fires events that you  may bind listeners to. Event listeners 
  may be bound with <code>engine.bind(eventName, callback)</code>
  
  @name Engine
  @constructor
  @param I
  */
  /**
  Observe or modify the 
  entity data before it is added to the engine.
  @name beforeAdd
  @methodOf Engine#
  @event
  
  @param {Object} entityData
  */
  /**
  Observe or configure a <code>gameObject</code> that has been added 
  to the engine.
  @name afterAdd
  @methodOf Engine#
  @event
  
  @param {GameObject} object The object that has just been added to the
  engine.
  */
  /**
  Called when the engine updates all the game objects.
  
  @name update
  @methodOf Engine#
  @event
  */
  /**
  Called after the engine completes an update. Here it is 
  safe to modify the game objects array.
  
  @name afterUpdate
  @methodOf Engine#
  @event
  */
  /**
  Called before the engine draws the game objects on the canvas.
  
  The current camera transform <b>is</b> applied.
  
  @name beforeDraw
  @methodOf Engine#
  @event
  */
  /**
  Called after the engine draws on the canvas.
  
  The current camera transform <b>is not</b> applied, you may
  choose to apply it yourself using <code>I.cameraTransform</code>.
  
  @name draw
  @methodOf Engine#
  @event
  */
  return window.Engine = function(I) {
    var animLoop, canvas, defaultModules, draw, frameAdvance, lastStepTime, modules, queuedObjects, running, self, startTime, step, update;
    I || (I = {});
    $.reverseMerge(I, {
      objects: []
    }, defaults);
    frameAdvance = false;
    queuedObjects = [];
    running = false;
    startTime = +new Date();
    lastStepTime = -Infinity;
    animLoop = function(timestamp) {
      var delta, msPerFrame, remainder;
      timestamp || (timestamp = +new Date());
      msPerFrame = 1000 / I.FPS;
      delta = timestamp - lastStepTime;
      remainder = delta - msPerFrame;
      if (remainder > 0) {
        lastStepTime = timestamp - Math.min(remainder, msPerFrame);
        step();
      }
      if (running) {
        return window.requestAnimationFrame(animLoop);
      }
    };
    update = function() {
      var toRemove, _ref;
      window.updateKeys();
      self.trigger("update");
      _ref = I.objects.partition(function(object) {
        return object.update();
      }), I.objects = _ref[0], toRemove = _ref[1];
      toRemove.invoke("trigger", "remove");
      I.objects = I.objects.concat(queuedObjects);
      queuedObjects = [];
      return self.trigger("afterUpdate");
    };
    draw = function() {
      canvas.withTransform(I.cameraTransform, function(canvas) {
        var drawObjects;
        if (I.clear) {
          canvas.clear();
        } else if (I.backgroundColor) {
          canvas.fill(I.backgroundColor);
        }
        self.trigger("beforeDraw", canvas);
        if (I.zSort) {
          drawObjects = I.objects.copy().sort(function(a, b) {
            return a.I.zIndex - b.I.zIndex;
          });
        } else {
          drawObjects = I.objects;
        }
        return drawObjects.invoke("draw", canvas);
      });
      return self.trigger("draw", canvas);
    };
    step = function() {
      if (!I.paused || frameAdvance) {
        update();
        I.age += 1;
      }
      return draw();
    };
    canvas = I.canvas || $("<canvas />").powerCanvas();
    self = Core(I).extend({
      /**
      The add method creates and adds an object to the game world.
      
      Events triggered:
      <code>beforeAdd(entityData)</code>
      <code>afterAdd(gameObject)</code>
      
      @name add
      @methodOf Engine#
      @param entityData The data used to create the game object.
      @type GameObject
      */
      add: function(entityData) {
        var obj;
        self.trigger("beforeAdd", entityData);
        obj = GameObject.construct(entityData);
        self.trigger("afterAdd", obj);
        if (running && !I.paused) {
          queuedObjects.push(obj);
        } else {
          I.objects.push(obj);
        }
        return obj;
      },
      /**
      Returns a reference to the canvas.
      
      @name canvas
      @methodOf Engine#
      */
      canvas: function() {
        return canvas;
      },
      objects: function() {
        return I.objects;
      },
      objectAt: function(x, y) {
        var bounds, targetObject;
        targetObject = null;
        bounds = {
          x: x,
          y: y,
          width: 1,
          height: 1
        };
        self.eachObject(function(object) {
          if (object.collides(bounds)) {
            return targetObject = object;
          }
        });
        return targetObject;
      },
      eachObject: function(iterator) {
        return I.objects.each(iterator);
      },
      /**
      Start the game simulation.
      @methodOf Engine#
      @name start
      */
      start: function() {
        if (!running) {
          running = true;
          return window.requestAnimationFrame(animLoop);
        }
      },
      /**
      Stop the simulation.
      @methodOf Engine#
      @name stop
      */
      stop: function() {
        return running = false;
      },
      frameAdvance: function() {
        I.paused = true;
        frameAdvance = true;
        step();
        return frameAdvance = false;
      },
      play: function() {
        return I.paused = false;
      },
      /**
      Pause the simulation
      @methodOf Engine#
      @name pause
      */
      pause: function() {
        return I.paused = true;
      },
      paused: function() {
        return I.paused;
      },
      setFramerate: function(newFPS) {
        I.FPS = newFPS;
        self.stop();
        return self.start();
      }
    });
    self.attrAccessor("ambientLight");
    self.attrAccessor("backgroundColor");
    self.attrAccessor("cameraTransform");
    self.include(Bindable);
    defaultModules = ["Shadows", "HUD", "Developer", "SaveState", "Selector", "Collision", "Tilemap", "FPSCounter"];
    modules = defaultModules.concat(I.includedModules);
    modules = modules.without([].concat(I.excludedModules));
    modules.each(function(moduleName) {
      if (!Engine[moduleName]) {
        throw "#Engine." + moduleName + " is not a valid engine module";
      }
      return self.include(Engine[moduleName]);
    });
    self.trigger("init");
    return self;
  };
})(jQuery);;
/**
The <code>Collision</code> module provides some simple collision detection methods to engine.

@name Collision
@fieldOf Engine
@module

@param {Object} I Instance variables
@param {Object} self Reference to the engine
*/Engine.Collision = function(I, self) {
  return {
    /**
    Detects collisions between a bounds and the game objects.
    
    @name collides
    @methodOf Engine.Collision#
    @param bounds The bounds to check collisions with.
    @param [sourceObject] An object to exclude from the results.
    */
    collides: function(bounds, sourceObject) {
      return I.objects.inject(false, function(collided, object) {
        return collided || (object.solid() && (object !== sourceObject) && object.collides(bounds));
      });
    },
    /**
    Detects collisions between a bounds and the game objects. 
    Returns an array of objects colliding with the bounds provided.
    
    @name collidesWith
    @methodOf Engine.Collision#
    @param bounds The bounds to check collisions with.
    @param [sourceObject] An object to exclude from the results.
    */
    collidesWith: function(bounds, sourceObject) {
      var collided;
      collided = [];
      I.objects.each(function(object) {
        if (!object.solid()) {
          return;
        }
        if (object !== sourceObject && object.collides(bounds)) {
          return collided.push(object);
        }
      });
      if (collided.length) {
        return collided;
      }
    },
    /**
    Detects collisions between a ray and the game objects.
    
    @name rayCollides
    @methodOf Engine.Collision#
    @param source The origin point
    @param direction A point representing the direction of the ray
    @param [sourceObject] An object to exclude from the results.
    */
    rayCollides: function(source, direction, sourceObject) {
      var hits, nearestDistance, nearestHit;
      hits = I.objects.map(function(object) {
        var hit;
        hit = object.solid() && (object !== sourceObject) && Collision.rayRectangle(source, direction, object.centeredBounds());
        if (hit) {
          hit.object = object;
        }
        return hit;
      });
      nearestDistance = Infinity;
      nearestHit = null;
      hits.each(function(hit) {
        var d;
        if (hit && (d = hit.distance(source)) < nearestDistance) {
          nearestDistance = d;
          return nearestHit = hit;
        }
      });
      return nearestHit;
    }
  };
};;
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
          return $.extend(objectToUpdate, GameObject.construct(newProperties));
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

@name FPSCounter
@fieldOf Engine
@module

@param {Object} I Instance variables
@param {Object} self Reference to the engine
*/Engine.FPSCounter = function(I, self) {
  var framerate;
  $.reverseMerge(I, {
    showFPS: false
  });
  framerate = Framerate({
    noDOM: true
  });
  return self.bind("draw", function(canvas) {
    if (I.showFPS) {
      canvas.font("bold 9pt consolas, 'Courier New', 'andale mono', 'lucida console', monospace");
      canvas.fillColor("#FFF");
      canvas.fillText("fps: " + framerate.fps, 6, 18);
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
/**
The <code>SaveState</code> module provides methods to save and restore the current engine state.

@name SaveState
@fieldOf Engine
@module

@param {Object} I Instance variables
@param {Object} self Reference to the engine
*/Engine.SaveState = function(I, self) {
  var savedState;
  savedState = null;
  return {
    rewind: function() {},
    /**
    Save the current game state and returns a JSON object representing that state.
    
    @name saveState
    @methodOf Engine.SaveState#
    */
    saveState: function() {
      return savedState = I.objects.map(function(object) {
        return $.extend({}, object.I);
      });
    },
    /**
    Loads the game state passed in, or the last saved state, if any.
    
    @name loadState
    @methodOf Engine.SaveState#
    @param [newState] The game state to load.
    */
    loadState: function(newState) {
      if (newState || (newState = savedState)) {
        I.objects.invoke("trigger", "remove");
        I.objects = [];
        return newState.each(function(objectData) {
          return self.add($.extend({}, objectData));
        });
      }
    },
    /**
    Reloads the current engine state, useful for hotswapping code.
    
    @name reload
    @methodOf Engine.SaveState#
    */
    reload: function() {
      var oldObjects;
      oldObjects = I.objects;
      I.objects = [];
      return oldObjects.each(function(object) {
        object.trigger("remove");
        return self.add(object.I);
      });
    }
  };
};;
/**
The <code>Selector</code> module provides methods to query the engine to find game objects.

@name Selector
@fieldOf Engine
@module

@param {Object} I Instance variables
@param {Object} self Reference to the engine
*/Engine.Selector = function(I, self) {
  var instanceMethods;
  instanceMethods = {
    set: function(attr, value) {
      return this.each(function(item) {
        return item.I[attr] = value;
      });
    }
  };
  return {
    /**
    Get a selection of GameObjects that match the specified selector criteria. The selector language
    can select objects by id, class, or attributes.
    
    To select an object by id use "#anId"
    
    To select objects by class use "MyClass"
    
    To select objects by properties use ".someProperty" or ".someProperty=someValue"
    
    You may mix and match selectors. "Wall.x=0" to select all objects of class Wall with an x property of 0.
    
    @name find
    @methodOf Engine#
    @param {String} selector
    @type Array
    */
    find: function(selector) {
      var matcher, results;
      results = [];
      matcher = Engine.Selector.generate(selector);
      I.objects.each(function(object) {
        if (matcher.match(object)) {
          return results.push(object);
        }
      });
      return $.extend(results, instanceMethods);
    }
  };
};
$.extend(Engine.Selector, {
  parse: function(selector) {
    return selector.split(",").invoke("trim");
  },
  process: function(item) {
    var result;
    result = /^(\w+)?#?([\w\-]+)?\.?([\w\-]+)?=?([\w\-]+)?/.exec(item);
    if (result) {
      if (result[4]) {
        result[4] = result[4].parse();
      }
      return result.splice(1);
    } else {
      return [];
    }
  },
  generate: function(selector) {
    var ATTR, ATTR_VALUE, ID, TYPE, components;
    components = Engine.Selector.parse(selector).map(function(piece) {
      return Engine.Selector.process(piece);
    });
    TYPE = 0;
    ID = 1;
    ATTR = 2;
    ATTR_VALUE = 3;
    return {
      match: function(object) {
        var attr, attrMatch, component, idMatch, typeMatch, value, _i, _len;
        for (_i = 0, _len = components.length; _i < _len; _i++) {
          component = components[_i];
          idMatch = (component[ID] === object.I.id) || !component[ID];
          typeMatch = (component[TYPE] === object.I["class"]) || !component[TYPE];
          if (attr = component[ATTR]) {
            if ((value = component[ATTR_VALUE]) != null) {
              attrMatch = object.I[attr] === value;
            } else {
              attrMatch = object.I[attr];
            }
          } else {
            attrMatch = true;
          }
          if (idMatch && typeMatch && attrMatch) {
            return true;
          }
        }
        return false;
      }
    };
  }
});;
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
/**
The default base class for all objects you can add to the engine.

GameObjects fire events that you may bind listeners to. Event listeners 
may be bound with <code>object.bind(eventName, callback)</code>

@name GameObject
@extends Core
@constructor
@instanceVariables age, active, created, destroyed, solid, includedModules, excludedModules
*/
/**
Triggered when the object is created.
@name create
@methodOf GameObject#
@event
*/
/**
Triggered when object is destroyed. Use 
the destroy event to add particle effects, play sounds, etc.

@name destroy
@methodOf GameObject#
@event
*/
/**
Triggered during every update step.

@name step
@methodOf GameObject#
@event
*/
/**
Triggered every update after the `step` event is triggered.

@name update
@methodOf GameObject#
@event
*/
/**
Triggered when the object is removed from
the engine. Use the remove event to handle any clean up.

@name remove
@methodOf GameObject#
@event
*/var GameObject;
GameObject = function(I) {
  var autobindEvents, defaultModules, modules, self;
  I || (I = {});
  /**
  @name I
  @memberOf GameObject#
  */
  $.reverseMerge(I, {
    age: 0,
    active: true,
    created: false,
    destroyed: false,
    solid: false,
    includedModules: [],
    excludedModules: []
  });
  self = Core(I).extend({
    /**
    Update the game object. This is generally called by the engine.
    
    @name update
    @methodOf GameObject#
    */
    update: function() {
      if (I.active) {
        self.trigger('step');
        self.trigger('update');
        I.age += 1;
      }
      return I.active;
    },
    /**
    Destroys the object and triggers the destroyed callback.
    
    @name destroy
    @methodOf GameObject#
    */
    destroy: function() {
      if (!I.destroyed) {
        self.trigger('destroy');
      }
      I.destroyed = true;
      return I.active = false;
    }
  });
  defaultModules = [Bindable, Bounded, Drawable, Durable];
  modules = defaultModules.concat(I.includedModules.invoke('constantize'));
  modules = modules.without(I.excludedModules.invoke('constantize'));
  modules.each(function(Module) {
    return self.include(Module);
  });
  self.attrAccessor("solid");
  autobindEvents = ['create', 'destroy', 'step'];
  autobindEvents.each(function(eventName) {
    var event;
    if (event = I[eventName]) {
      if (typeof event === "function") {
        return self.bind(eventName, event);
      } else {
        return self.bind(eventName, eval("(function() {" + event + "})"));
      }
    }
  });
  if (!I.created) {
    self.trigger('create');
  }
  I.created = true;
  return self;
};
/**
Construct an object instance from the given entity data.
@name construct
@memberOf GameObject
@param {Object} entityData
*/
GameObject.construct = function(entityData) {
  if (entityData["class"]) {
    return entityData["class"].constantize()(entityData);
  } else {
    return GameObject(entityData);
  }
};;
var GameUtil;
GameUtil = {
  readImageData: function(data, callback) {
    var ctx, getPixelColor, img;
    getPixelColor = function(imageData, x, y) {
      var index;
      index = (x + y * imageData.width) * 4;
      return [imageData.data[index + 0], imageData.data[index + 1], imageData.data[index + 2]].invoke("toColorPart").join('');
    };
    ctx = document.createElement('canvas').getContext('2d');
    img = new Image();
    img.onload = function() {
      var colors, imageData;
      ctx.drawImage(img, 0, 0);
      imageData = ctx.getImageData(0, 0, img.width, img.height);
      colors = [];
      img.height.times(function(y) {
        return img.width.times(function(x) {
          return colors.push(getPixelColor(imageData, x, y));
        });
      });
      return callback({
        colors: colors,
        width: img.width,
        height: img.height
      });
    };
    return img.src = data;
  }
};;
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
/**
The Movable module automatically updates the position and velocity of
GameObjects based on the velocity and acceleration. It does not check
collisions so is probably best suited to particle effect like things.

@name Movable
@module
@constructor

@param {Object} I Instance variables
*/var Movable;
Movable = function(I) {
  $.reverseMerge(I, {
    acceleration: Point(0, 0),
    velocity: Point(0, 0)
  });
  I.acceleration = Point(I.acceleration.x, I.acceleration.y);
  I.velocity = Point(I.velocity.x, I.velocity.y);
  return {
    before: {
      update: function() {
        var currentSpeed;
        I.velocity = I.velocity.add(I.acceleration);
        if (I.maxSpeed != null) {
          currentSpeed = I.velocity.magnitude();
          if (currentSpeed > I.maxSpeed) {
            I.velocity = I.velocity.scale(I.maxSpeed / currentSpeed);
          }
        }
        I.x += I.velocity.x;
        return I.y += I.velocity.y;
      }
    }
  };
};;
(function() {
  var ResourceLoader, typeTable;
  typeTable = {
    images: "png"
  };
  ResourceLoader = {
    urlFor: function(directory, name) {
      var type, _ref;
      directory = (typeof App !== "undefined" && App !== null ? (_ref = App.directories) != null ? _ref[directory] : void 0 : void 0) || directory;
      type = typeTable[directory];
      return "" + BASE_URL + "/" + directory + "/" + name + "." + type + "?" + MTIME;
    }
  };
  return window["ResourceLoader"] = ResourceLoader;
})();;
var Rotatable;
Rotatable = function(I) {
  I || (I = {});
  $.reverseMerge(I, {
    rotation: 0,
    rotationalVelocity: 0
  });
  return {
    before: {
      update: function() {
        return I.rotation += I.rotationalVelocity;
      }
    }
  };
};;
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
  return $.extend(Sound, {
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
  }, window.Sound = Sound);
})(jQuery);;
/**
The Sprite class provides a way to load images for use in games.

By default, images are loaded asynchronously. A proxy object is 
returned immediately but though it has a draw method it will not
draw anything to the screen until the image has been loaded.

@name Sprite
@constructor
*/(function() {
  var LoaderProxy, Sprite, fromPixieId, pixieSpriteImagePath;
  LoaderProxy = function() {
    return {
      draw: $.noop,
      fill: $.noop,
      frame: $.noop,
      update: $.noop,
      width: null,
      height: null
    };
  };
  Sprite = function(image, sourceX, sourceY, width, height) {
    sourceX || (sourceX = 0);
    sourceY || (sourceY = 0);
    width || (width = image.width);
    height || (height = image.height);
    return {
      /**
      Draw this sprite on the given canvas at the given position.
      
      @name draw
      @methodOf Sprite#
      
      @param canvas
      @param x
      @param y
      */
      draw: function(canvas, x, y) {
        return canvas.drawImage(image, sourceX, sourceY, width, height, x, y, width, height);
      },
      fill: function(canvas, x, y, width, height, repeat) {
        var pattern;
        repeat || (repeat = "repeat");
        pattern = canvas.createPattern(image, repeat);
        canvas.fillColor(pattern);
        return canvas.fillRect(x, y, width, height);
      },
      width: width,
      height: height
    };
  };
  Sprite.loadSheet = function(name, tileWidth, tileHeight) {
    var directory, image, sprites, url, _ref;
    directory = (typeof App !== "undefined" && App !== null ? (_ref = App.directories) != null ? _ref.images : void 0 : void 0) || "images";
    url = "" + BASE_URL + "/" + directory + "/" + name + ".png?" + MTIME;
    console.log(url);
    sprites = [];
    image = new Image();
    image.onload = function() {
      var imgElement;
      imgElement = this;
      return (image.height / tileHeight).times(function(row) {
        return (image.width / tileWidth).times(function(col) {
          return sprites.push(Sprite(imgElement, col * tileWidth, row * tileHeight, tileWidth, tileHeight));
        });
      });
    };
    image.src = url;
    return sprites;
  };
  Sprite.load = function(url, loadedCallback) {
    var img, proxy;
    img = new Image();
    proxy = LoaderProxy();
    img.onload = function() {
      var tile;
      tile = Sprite(this);
      $.extend(proxy, tile);
      if (loadedCallback) {
        return loadedCallback(proxy);
      }
    };
    img.src = url;
    return proxy;
  };
  pixieSpriteImagePath = "http://pixieengine.com/s3/sprites/";
  fromPixieId = function(id, callback) {
    return Sprite.load(pixieSpriteImagePath + id + "/original.png", callback);
  };
  window.Sprite = function(name, callback) {
    var id;
    if (App.Sprites) {
      id = App.Sprites[name];
      if (id) {
        return fromPixieId(id, callback);
      } else {
        return warn("Could not find sprite named: '" + name + "' in App.");
      }
    } else {
      return window.Sprite.fromURL(name, callback);
    }
  };
  /**
  A sprite that draws nothing.
  
  @name EMPTY
  @fieldOf Sprite
  @constant
  @type Sprite
  */
  /**
  A sprite that draws nothing.
  
  @name NONE
  @fieldOf Sprite
  @constant
  @type Sprite
  */
  window.Sprite.EMPTY = window.Sprite.NONE = LoaderProxy();
  /**
  Loads a sprite with the given pixie id.
  
  @name fromPixieId
  @methodOf Sprite
  
  @param id
  @param [callback]
  
  @type Sprite
  */
  window.Sprite.fromPixieId = fromPixieId;
  /**
  Loads a sprite from a given url.
  
  @name fromURL
  @methodOf Sprite
  
  @param {String} url
  @param [callback]
  
  @type Sprite
  */
  window.Sprite.fromURL = Sprite.load;
  /**
  Loads a sprite with the given name.
  
  @name loadByName
  @methodOf Sprite
  
  @param {String} name
  @param [callback]
  
  @type Sprite
  */
  window.Sprite.loadByName = function(name, callback) {
    var directory, url, _ref;
    directory = (typeof App !== "undefined" && App !== null ? (_ref = App.directories) != null ? _ref.images : void 0 : void 0) || "images";
    url = "" + BASE_URL + "/" + directory + "/" + name + ".png?" + MTIME;
    return Sprite.load(url, callback);
  };
  return window.Sprite.create = Sprite;
})();;
(function() {
  var Map, fromPixieId, loadByName;
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
              entityData = $.extend({
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
    return $.extend(data, {
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
  window.Tilemap = function(name, callback, entityCallback) {
    return fromPixieId(App.Tilemaps[name], callback, entityCallback);
  };
  fromPixieId = function(id, callback, entityCallback) {
    var proxy, url;
    url = "http://pixieengine.com/s3/tilemaps/" + id + "/data.json";
    proxy = {
      draw: $.noop
    };
    $.getJSON(url, function(data) {
      $.extend(proxy, Map(data, entityCallback));
      return typeof callback === "function" ? callback(proxy) : void 0;
    });
    return proxy;
  };
  loadByName = function(name, callback, entityCallback) {
    var directory, proxy, url, _ref;
    directory = (typeof App !== "undefined" && App !== null ? (_ref = App.directories) != null ? _ref.tilemaps : void 0 : void 0) || "data";
    url = "" + BASE_URL + "/" + directory + "/" + name + ".tilemap?" + (new Date().getTime());
    proxy = {
      draw: $.noop
    };
    $.getJSON(url, function(data) {
      $.extend(proxy, Map(data, entityCallback));
      return typeof callback === "function" ? callback(proxy) : void 0;
    });
    return proxy;
  };
  window.Tilemap.fromPixieId = fromPixieId;
  return window.Tilemap.load = function(options) {
    if (options.pixieId) {
      return fromPixieId(options.pixieId, options.complete, options.entity);
    } else if (options.name) {
      return loadByName(options.name, options.complete, options.entity);
    }
  };
})();;
;
;$(function(){ undefined });;
var AI;
AI = function(I, self) {
  var arenaCenter, directionAI, roles;
  arenaCenter = Point(WALL_LEFT + WALL_RIGHT, WALL_TOP + WALL_BOTTOM).scale(0.5);
  roles = ["youth", "goalie", "youth"];
  directionAI = {
    goalie: function() {
      var targetPosition;
      targetPosition = engine.find("Goal").select(function(goal) {
        return goal.team() === I.team;
      }).first().center();
      targetPosition = targetPosition.add((arenaCenter.subtract(targetPosition)).norm().scale(16));
      return targetPosition.subtract(self.center()).norm();
    },
    youth: function() {
      var targetPosition;
      if (I.hasPuck) {
        targetPosition = engine.find("Goal").select(function(goal) {
          return goal.team() !== I.team;
        }).first().center();
      } else {
        targetPosition = engine.find("Puck").first().center();
      }
      if (targetPosition) {
        return targetPosition.subtract(self.center()).norm();
      } else {
        return Point(0, 0);
      }
    }
  };
  I.role = roles[(I.controller / 2).floor()];
  return {
    computeDirection: function() {
      return directionAI[I.role]();
    }
  };
};;
var Base;
Base = function(I) {
  var self;
  I || (I = {});
  $.reverseMerge(I, {
    fortitude: 1,
    friction: 0,
    strength: 1,
    mass: 1,
    velocity: Point(0, 0)
  });
  self = GameObject(I).extend({
    bloody: $.noop,
    crush: $.noop,
    puck: function() {
      return I["class"] === "Puck";
    },
    wipeout: $.noop,
    controlPuck: $.noop,
    controlCircle: function() {
      return {
        x: 0,
        y: 0,
        radius: 0
      };
    },
    collides: function() {
      return !I.wipeout;
    },
    collidesWithWalls: function() {
      return true;
    },
    collisionPower: function(normal) {
      return (I.velocity.dot(normal) + I.fortitude) * I.strength;
    },
    center: function(newCenter) {
      if (newCenter != null) {
        I.x = newCenter.x - I.width / 2;
        I.y = newCenter.y - I.height / 2;
        I.center = newCenter;
        return self;
      } else {
        return I.center;
      }
    },
    updatePosition: function(dt, noFriction) {
      var friction, frictionFactor;
      if (noFriction) {
        friction = 0;
      } else {
        friction = I.friction;
      }
      frictionFactor = 1 - friction * dt;
      I.velocity.x *= frictionFactor;
      I.velocity.y *= frictionFactor;
      I.x += I.velocity.x * dt;
      I.y += I.velocity.y * dt;
      I.center.x = I.x + I.width / 2;
      I.center.y = I.y + I.height / 2;
      return self.trigger("positionUpdated");
    }
  });
  if ((I.velocity != null) && (I.velocity.x != null) && (I.velocity.y != null)) {
    I.velocity = Point(I.velocity.x, I.velocity.y);
  }
  self.bind("update", function() {
    return I.zIndex = 1 + (I.y + I.height) / CANVAS_HEIGHT;
  });
  self.bind("drawDebug", function(canvas) {
    var center, x, y;
    if (I.radius) {
      center = self.center();
      x = center.x;
      y = center.y;
      return canvas.fillCircle(x, y, I.radius, "rgba(255, 0, 255, 0.5)");
    }
  });
  self.attrReader("mass");
  I.center = Point(I.x + I.width / 2, I.y + I.height / 2);
  return self;
};;
var Blood;
Blood = function(I) {
  var self;
  $.reverseMerge(I, {
    blood: 1,
    duration: 300,
    radius: 2,
    sprite: Sprite.NONE,
    width: 32,
    height: 32
  });
  self = GameObject(I).extend({
    circle: function() {
      var c;
      c = self.center();
      c.radius = I.radius;
      return c;
    }
  });
  Blood.sprites.rand().draw(bloodCanvas, I.x, I.y);
  return self;
};
Blood.sprites || (Blood.sprites = [Sprite.loadByName("blood")]);;
var Boards;
Boards = function(I) {
  var self;
  $.reverseMerge(I, {
    width: ARENA_WIDTH - 192,
    height: 48,
    x: WALL_LEFT + 96
  });
  self = GameObject(I).extend({
    draw: function(canvas) {
      return canvas.withTransform(Matrix.translation(I.x, I.y), function() {
        return I.sprite.fill(canvas, 0, 0, I.width, I.height);
      });
    }
  });
  return self;
};;
var Bottle;
Bottle = function(I) {
  var addParticleEffect, drawSplat, fluidColor, particleSizes, self, splatSizes;
  $.reverseMerge(I, {
    color: "#A00",
    radius: 8,
    rotation: rand() * Math.TAU,
    rotationalVelocity: (rand() * 2 - 1) * Math.TAU / 16,
    spriteName: "freedomade",
    velocity: Point(rand(5) - 2, 2 + rand(4) + rand(4)),
    z: 48,
    zVelocity: 4 + rand(6),
    gravity: -0.25
  });
  I.width = I.height = I.radius;
  fluidColor = Color(0, 255, 0, 0.5);
  splatSizes = [2, 2, 2, 3, 4, 6];
  drawSplat = function() {
    return splatSizes.each(function(radius) {
      var maxOffset;
      maxOffset = 7 - radius;
      maxOffset *= maxOffset;
      return bloodCanvas.fillCircle(I.x + I.width / 2 + (rand() - 0.5) * maxOffset, I.y + I.height / 2 + (rand() - 0.5) * maxOffset, radius, fluidColor);
    });
  };
  particleSizes = [4, 3, 5];
  addParticleEffect = function() {
    return engine.add({
      "class": "Emitter",
      duration: 10,
      sprite: Sprite.EMPTY,
      velocity: Point(0, 0),
      particleCount: 12,
      batchSize: 4,
      x: I.x + I.width / 2,
      y: I.y - I.z,
      generator: {
        color: fluidColor,
        duration: 3,
        height: function(n) {
          return particleSizes.wrap(n);
        },
        maxSpeed: 5,
        velocity: function(n) {
          return Point.fromAngle(Random.angle()).scale(rand(5) + 1);
        },
        width: function(n) {
          return particleSizes.wrap(n);
        }
      }
    });
  };
  self = Base(I).extend({
    draw: function(canvas) {
      var bonusRadius, center, shadowColor, transform;
      center = self.center();
      shadowColor = "rgba(0, 0, 0, 0.15)";
      bonusRadius = (-4 + 256 / I.z).clamp(-4, 4);
      canvas.fillCircle(center.x, center.y, I.radius + bonusRadius, shadowColor);
      transform = Matrix.translation(I.x + I.width / 2, I.y + I.height / 2 - I.z).concat(Matrix.rotation(I.rotation)).concat(Matrix.translation(-I.width / 2, -I.height / 2));
      return canvas.withTransform(transform, function() {
        return I.sprite.draw(canvas, 0, 0);
      });
    }
  });
  self.bind("destroy", function() {
    addParticleEffect();
    drawSplat();
    return Sound.play("bottle_hit");
  });
  self.bind("step", function() {
    var players;
    self.updatePosition(1);
    I.rotation += I.rotationalVelocity;
    I.z += I.zVelocity;
    I.zVelocity += I.gravity;
    if (I.z < 48) {
      players = engine.find("Player");
      players.each(function(player) {
        if (Collision.circular(player.circle(), self.circle())) {
          player.wipeout(player.center().subtract(self.center()));
          return self.destroy();
        }
      });
    }
    if (I.z < 0) {
      return self.destroy();
    }
  });
  return self;
};;
var CONTROLLERS, Controller, gameControlData, keyActionNames, layouts, selectedLayout;
var __slice = Array.prototype.slice;
Controller = function(actions) {
  actions || (actions = {
    up: "up",
    right: "right",
    down: "down",
    left: "left",
    A: "home",
    B: "end",
    C: "pageup",
    D: "pagedown"
  });
  return {
    actionDown: function() {
      var triggers;
      triggers = 1 <= arguments.length ? __slice.call(arguments, 0) : [];
      return triggers.inject(false, function(down, action) {
        return down || keydown[actions[action]];
      });
    }
  };
};
gameControlData = {};
keyActionNames = {
  A: "SHOOT",
  B: "BOOST",
  C: "?",
  D: "??"
};
CONTROLLERS = [];
selectedLayout = Local.get("controls") || "qwerty_keyboard";
layouts = {
  dvorak_wiimotes: [
    {
      up: "up",
      right: "right",
      down: "down",
      left: "left",
      A: "end",
      B: "home",
      C: "pagedown",
      D: "pageup"
    }, {
      up: "o",
      right: "q",
      down: ";",
      left: "a",
      A: "2",
      B: "1",
      C: ",",
      D: "'"
    }, {
      up: "u",
      right: "k",
      down: "j",
      left: "e",
      A: "4",
      B: "3",
      C: "p",
      D: "."
    }, {
      up: "d",
      right: "b",
      down: "x",
      left: "i",
      A: "6",
      B: "5",
      C: "f",
      D: "y"
    }, {
      up: "t",
      right: "w",
      down: "m",
      left: "h",
      A: "8",
      B: "7",
      C: "c",
      D: "g"
    }, {
      up: "s",
      right: "z",
      down: "v",
      left: "n",
      A: "0",
      B: "9",
      C: "l",
      D: "r"
    }, {
      up: "=",
      right: "return",
      down: "-",
      left: "/",
      A: "]",
      B: "[",
      C: "\\",
      D: "backspace"
    }
  ],
  qwerty_keyboard: [
    {
      up: "up",
      right: "right",
      down: "down",
      left: "left",
      A: "'",
      B: ";"
    }, {
      up: "w",
      right: "d",
      down: "s",
      left: "a",
      A: "b",
      B: "space"
    }, {}, {}, {}, {}, {}
  ]
};
layouts[selectedLayout].each(function(actions, i) {
  var action, key;
  for (action in actions) {
    key = actions[action];
    gameControlData["P" + (i + 1) + ": " + (keyActionNames[action] || action)] = key;
  }
  return CONTROLLERS[i] = Controller(actions);
});
parent.gameControlData = gameControlData;;
var Fan;
Fan = function(I) {
  var self;
  $.reverseMerge(I, {
    duration: 16 + rand(64),
    sprite: Fan.sprites.rand(),
    width: 32,
    height: 32,
    x: rand(App.width).snap(32),
    y: rand(WALL_TOP).snap(32)
  });
  self = GameObject(I);
  if (config.throwBottles && !rand(50)) {
    engine.add({
      "class": "Bottle",
      x: I.x,
      y: I.y
    });
  }
  return self;
};
Fan.sprites || (Fan.sprites = [Sprite.loadByName("fans_active")]);;
var Goal;
Goal = function(I) {
  var DEBUG_DRAW, HEIGHT, WALL_RADIUS, WIDTH, drawWall, self, walls;
  I || (I = {});
  DEBUG_DRAW = false;
  WALL_RADIUS = 2;
  WIDTH = 32;
  HEIGHT = 48;
  $.reverseMerge(I, {
    color: "green",
    height: HEIGHT,
    width: WIDTH,
    x: WALL_LEFT + ARENA_WIDTH / 20 - WIDTH,
    y: WALL_TOP + ARENA_HEIGHT / 2 - HEIGHT / 2,
    spriteOffset: Point(0, -(HEIGHT - 2))
  });
  walls = [
    {
      center: Point(I.x + I.width / 2, I.y),
      halfWidth: I.width / 2,
      halfHeight: WALL_RADIUS,
      horizontal: true
    }, {
      center: Point(I.x + I.width / 2, I.y + I.height),
      halfWidth: I.width / 2,
      halfHeight: WALL_RADIUS,
      horizontal: true
    }
  ];
  if (I.team) {
    walls.push({
      center: Point(I.x + I.width, I.y + I.height / 2),
      halfWidth: WALL_RADIUS,
      halfHeight: I.height / 2,
      killSide: -1
    });
  } else {
    walls.push({
      center: Point(I.x, I.y + I.height / 2),
      halfWidth: WALL_RADIUS,
      halfHeight: I.height / 2,
      killSide: 1
    });
  }
  drawWall = function(wall, canvas) {
    canvas.fillColor("#0F0");
    return canvas.fillRect(wall.center.x - wall.halfWidth, wall.center.y - wall.halfHeight, 2 * wall.halfWidth, 2 * wall.halfHeight);
  };
  self = GameObject(I).extend({
    walls: function() {
      return walls;
    },
    withinGoal: function(circle) {
      if (circle.x - circle.radius > I.x && circle.x + circle.radius < I.x + I.width) {
        if (circle.y - circle.radius > I.y && circle.y + circle.radius < I.y + I.height) {
          return true;
        }
      }
      return false;
    },
    score: function() {
      self.trigger("score");
      return Sound.play("crowd" + (rand(3)));
    }
  });
  self.bind("drawDebug", function(canvas) {
    canvas.fillColor("rgba(255, 0, 255, 0.5)");
    canvas.fillRect(I.x, I.y, I.width, I.height);
    return walls.each(function(wall) {
      return drawWall(wall, canvas);
    });
  });
  self.bind("step", function() {
    if (I.team) {
      I.sprite = tallSprites[7];
    } else {
      I.sprite = tallSprites[6];
    }
    return I.zIndex = 1 + (I.y + I.height) / CANVAS_HEIGHT;
  });
  self.attrReader("team");
  return self;
};;
var Joysticks;
var __slice = Array.prototype.slice;
Joysticks = (function() {
  var AXIS_MAX, DEAD_ZONE, buttonMapping, joysticks, plugin, type;
  type = "application/x-boomstickjavascriptjoysticksupport";
  plugin = null;
  AXIS_MAX = 32767;
  DEAD_ZONE = AXIS_MAX * 0.125;
  joysticks = [];
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
    "L1": 16
  };
  return {
    getController: function(i) {
      return {
        actionDown: function() {
          var buttons, stick;
          buttons = 1 <= arguments.length ? __slice.call(arguments, 0) : [];
          if (stick = joysticks != null ? joysticks[i] : void 0) {
            return buttons.inject(false, function(down, button) {
              return down || stick.buttons & buttonMapping[button];
            });
          } else {
            return false;
          }
        },
        position: function() {
          var stick;
          if (stick = joysticks != null ? joysticks[i] : void 0) {
            return Joysticks.position(stick);
          } else {
            return Point(0, 0);
          }
        },
        axis: function(n) {
          var stick;
          if (stick = joysticks != null ? joysticks[i] : void 0) {
            return stick.axes[n];
          }
        }
      };
    },
    init: function() {
      if (!plugin) {
        plugin = document.createElement("object");
        plugin.type = type;
        plugin.width = 0;
        plugin.height = 0;
        $("body").append(plugin);
        return plugin.maxAxes = 6;
      }
    },
    position: function(stick) {
      var magnitude, p, ratio;
      p = Point(stick.axes[0], stick.axes[1]);
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
    states: function() {
      return plugin != null ? plugin.joysticks : void 0;
    },
    status: function() {
      return plugin != null ? plugin.status : void 0;
    },
    update: function() {
      return joysticks = JSON.parse(plugin.joysticksJSON());
    }
  };
})();;
var Music;
Music = (function() {
  var track;
  track = $("<audio />", {
    loop: "loop"
  }).appendTo('body').get(0);
  track.volume = 0.40;
  return {
    play: function(name) {
      track.src = "" + BASE_URL + "/sounds/" + name + ".mp3";
      return track.play();
    }
  };
})();;
var OptionsScreen;
OptionsScreen = function(I) {
  var createSelect, directory, optionsPanel, optionsScreen, resourceURL, _ref;
  $.reverseMerge(I, {
    backgroundColor: "#00010D",
    callback: $.noop
  });
  directory = (typeof App !== "undefined" && App !== null ? (_ref = App.directories) != null ? _ref.images : void 0 : void 0) || "images";
  resourceURL = function(directory, name, type) {
    var _ref2;
    directory = (typeof App !== "undefined" && App !== null ? (_ref2 = App.directories) != null ? _ref2[directory] : void 0 : void 0) || directory;
    return "" + BASE_URL + "/" + directory + "/" + name + "." + type;
  };
  createSelect = function(name, options) {
    var heading, label, select;
    label = $("<label />");
    select = $("<select />");
    options.each(function(option) {
      var optionElement;
      optionElement = $("<option />", {
        val: option,
        text: option
      });
      return select.append(optionElement);
    });
    heading = $("<h2 />", {
      text: name
    });
    label.append(heading);
    label.append(select);
    return label;
  };
  optionsScreen = $("<div />", {
    css: {
      backgroundColor: I.backgroundColor,
      fontFamily: "monospace",
      fontSize: "20px",
      fontWeight: "bold",
      left: 0,
      margin: "auto",
      position: "absolute",
      textAlign: "center",
      top: 0,
      zIndex: 1001
    }
  }).appendTo("body");
  $("<img />", {
    height: App.height,
    src: "" + BASE_URL + "/" + directory + "/title.png",
    width: App.width
  }).appendTo(optionsScreen);
  $("<div />", {
    text: "Loading...",
    css: {
      bottom: "40%",
      color: "#FFF",
      position: "absolute",
      width: "100%",
      zIndex: -1
    }
  }).appendTo(optionsScreen);
  optionsPanel = $("<div />", {
    css: {
      margin: auto,
      width: "75%",
      zIndex: 1
    }
  }).appendTo(optionsScreen);
  return $(document).one("keydown", function() {
    optionsScreen.remove();
    return I.callback();
  });
};;
var Physics;
Physics = function() {
  var cornerRadius, corners, overlapX, overlapY, rectangularOverlap, resolveCollision, resolveCollisions, threshold, wallCollisions, walls;
  overlapX = function(wall, circle) {
    return (circle.x - wall.center.x).abs() < wall.halfWidth + circle.radius;
  };
  overlapY = function(wall, circle) {
    return (circle.y - wall.center.y).abs() < wall.halfHeight + circle.radius;
  };
  rectangularOverlap = function(wall, circle) {
    return overlapX(wall, circle) && overlapY(wall, circle);
  };
  walls = [
    {
      normal: Point(1, 0),
      position: WALL_LEFT
    }, {
      normal: Point(-1, 0),
      position: -WALL_RIGHT
    }, {
      normal: Point(0, 1),
      position: WALL_TOP
    }, {
      normal: Point(0, -1),
      position: -WALL_BOTTOM
    }
  ];
  cornerRadius = Rink.CORNER_RADIUS;
  corners = [
    {
      position: Point(WALL_LEFT + cornerRadius, WALL_TOP + cornerRadius),
      quadrant: 0
    }, {
      position: Point(WALL_RIGHT - cornerRadius, WALL_TOP + cornerRadius),
      quadrant: 1
    }, {
      position: Point(WALL_LEFT + cornerRadius, WALL_BOTTOM - cornerRadius),
      quadrant: -1
    }, {
      position: Point(WALL_RIGHT - cornerRadius, WALL_BOTTOM - cornerRadius),
      quadrant: -2
    }
  ];
  threshold = 5;
  resolveCollision = function(A, B) {
    var massA, massB, max, normal, powA, powB, pushA, pushB, relativeVelocity, totalMass;
    normal = B.center().subtract(A.center()).norm();
    powA = A.collisionPower(normal);
    powB = -B.collisionPower(normal);
    max = Math.max(powA, powB);
    if (max > threshold) {
      if (powA === max) {
        A.crush(B);
        B.wipeout(normal);
      } else {
        B.crush(A);
        A.wipeout(normal.scale(-1));
      }
    }
    relativeVelocity = A.I.velocity.subtract(B.I.velocity);
    massA = A.mass();
    massB = B.mass();
    totalMass = massA + massB;
    pushA = normal.scale(-2 * (relativeVelocity.dot(normal) * (massB / totalMass) + 1));
    pushB = normal.scale(+2 * (relativeVelocity.dot(normal) * (massA / totalMass) + 1));
    A.I.velocity = A.I.velocity.add(pushA);
    return B.I.velocity = B.I.velocity.add(pushB);
  };
  resolveCollisions = function(objects) {
    return objects.eachPair(function(a, b) {
      if (!(a.collides() && b.collides())) {
        return;
      }
      if (Collision.circular(a.circle(), b.circle())) {
        return resolveCollision(a, b);
      }
    });
  };
  wallCollisions = function(objects, dt) {
    var wallSegments;
    wallSegments = engine.find("Goal").map(function(goal) {
      return goal.walls();
    }).flatten();
    objects.each(function(object) {
      var center, circle, collided, radius, velocity;
      if (!object.collidesWithWalls()) {
        return;
      }
      center = circle = object.circle();
      radius = circle.radius;
      velocity = object.I.velocity;
      collided = false;
      wallSegments.each(function(wall) {
        var capCenter, normal, velocityProjection, wallToObject;
        if (rectangularOverlap(wall, circle)) {
          wallToObject = center.subtract(wall.center);
          if (wall.horizontal) {
            if (wallToObject.x.abs() < wall.halfWidth) {
              normal = Point(0, wallToObject.y.sign());
            } else {
              capCenter = Point(wallToObject.x.sign() * wall.halfWidth, 0).add(wall.center);
              normal = center.subtract(capCenter).norm();
            }
          } else {
            normal = Point(wallToObject.x.sign(), 0);
          }
          velocityProjection = velocity.dot(normal);
          if (velocityProjection < 0) {
            velocity = velocity.subtract(normal.scale(2 * velocityProjection));
            return collided = true;
          }
        }
      });
      if (collided) {
        object.I.velocity = velocity;
        object.updatePosition(dt, true);
        if (object.puck()) {
          Sound.play("clink0");
        }
      }
    });
    objects.each(function(object) {
      var center, radius, velocity;
      if (!object.collidesWithWalls()) {
        return;
      }
      center = object.center();
      radius = object.I.radius;
      velocity = object.I.velocity;
      corners.each(function(corner) {
        var angle, distanceToCenter, normal, position, quadrant, velocityProjection;
        position = corner.position;
        switch (corner.quadrant) {
          case 0:
            if (!(center.x < position.x && center.y < position.y)) {
              return;
            }
            break;
          case 1:
            if (!(center.x > position.x && center.y < position.y)) {
              return;
            }
            break;
          case -1:
            if (!(center.x < position.x && center.y > position.y)) {
              return;
            }
            break;
          case -2:
            if (!(center.x > position.x && center.y > position.y)) {
              return;
            }
        }
        distanceToCenter = position.subtract(center);
        normal = distanceToCenter.norm();
        angle = Point.direction(Point(0, 0), normal);
        quadrant = (4 * angle / Math.TAU).floor();
        if (quadrant === corner.quadrant && radius * radius + distanceToCenter.dot(distanceToCenter) > cornerRadius * cornerRadius) {
          velocityProjection = velocity.dot(normal);
          if (velocityProjection < 0) {
            velocity = velocity.subtract(normal.scale(2 * velocityProjection));
            object.I.velocity = velocity;
            object.updatePosition(dt, true);
            if (object.puck()) {
              return Sound.play("thud0");
            }
          }
        }
      });
    });
    return objects.each(function(object) {
      var center, collided, radius, velocity;
      if (!object.collidesWithWalls()) {
        return;
      }
      center = object.center();
      radius = object.I.radius;
      velocity = object.I.velocity;
      collided = false;
      walls.each(function(wall) {
        var normal, position, velocityProjection;
        position = wall.position, normal = wall.normal;
        if (center.dot(normal) < radius + position) {
          velocityProjection = velocity.dot(normal);
          if (velocityProjection < 0) {
            velocity = velocity.subtract(normal.scale(2 * velocityProjection));
            return collided = true;
          }
        }
      });
      if (collided) {
        object.I.velocity = velocity;
        object.updatePosition(dt, true);
        if (object.puck()) {
          Sound.play("thud0");
        }
      }
    });
  };
  return {
    process: function(objects) {
      var dt, steps;
      steps = 5;
      dt = 1 / steps;
      return steps.times(function() {
        objects.invoke("updatePosition", dt);
        resolveCollisions(objects, dt);
        return wallCollisions(objects, dt);
      });
    }
  };
};;
var Player;
Player = function(I) {
  var PLAYER_COLORS, actionDown, addSprayParticleEffect, axisPosition, boostMeter, controller, drawBloodStreaks, drawControlCircle, drawFloatingNameTag, drawPowerMeters, flyingOffset, heading, lastLeftSkatePos, lastRightSkatePos, leftSkatePos, maxShotPower, movementDirection, particleSizes, playerColor, redTeam, rightSkatePos, self, shootPuck, standingOffset;
  $.reverseMerge(I, {
    boost: 0,
    cooldown: {
      boost: 0,
      shoot: 0
    },
    collisionMargin: Point(2, 2),
    controller: 0,
    falls: 0,
    friction: 0.1,
    blood: {
      face: 0,
      body: 0,
      leftSkate: 0,
      rightSkate: 0
    },
    radius: 16,
    width: 32,
    height: 32,
    x: 192,
    y: 128,
    shootPower: 0,
    wipeout: 0,
    velocity: Point(),
    zIndex: 1
  });
  PLAYER_COLORS = ["#0246E3", "#EB070E", "#388326", "#F69508", "#563495", "#58C4F5", "#FFDE49"];
  playerColor = PLAYER_COLORS[I.id];
  I.team || (I.team = I.controller % 2);
  redTeam = I.team;
  standingOffset = Point(0, -16);
  flyingOffset = Point(-24, -16);
  if (I.joystick) {
    controller = Joysticks.getController(I.controller);
    actionDown = controller.actionDown;
    axisPosition = controller.axis;
  } else {
    actionDown = CONTROLLERS[I.controller].actionDown;
    axisPosition = $.noop;
  }
  maxShotPower = 20;
  boostMeter = 64;
  heading = redTeam ? Math.TAU / 2 : 0;
  movementDirection = 0;
  drawFloatingNameTag = function(canvas) {
    var backgroundColor, center, lineHeight, name, padding, rectHeight, rectWidth, textWidth, topLeft, yOffset;
    if (I.cpu) {
      name = "CPU";
    } else {
      name = "P" + (I.id + 1);
    }
    padding = 6;
    lineHeight = 16;
    textWidth = canvas.measureText(name);
    backgroundColor = Color(playerColor);
    backgroundColor.a("0.5");
    yOffset = 48;
    center = self.center();
    topLeft = center.subtract(Point(textWidth / 2 + padding, lineHeight / 2 + padding + yOffset));
    rectWidth = textWidth + 2 * padding;
    rectHeight = lineHeight + 2 * padding;
    canvas.fillColor(backgroundColor);
    canvas.fillRoundRect(topLeft.x, topLeft.y, rectWidth, rectHeight, 4);
    canvas.fillColor("#FFF");
    return canvas.fillText(name, topLeft.x + padding, topLeft.y + lineHeight + padding / 2);
  };
  drawPowerMeters = function(canvas) {
    var center, height, maxWidth, padding, ratio, start;
    ratio = (boostMeter - I.cooldown.boost) / boostMeter;
    start = self.position().add(Point(0, I.height)).floor();
    padding = 1;
    maxWidth = I.width;
    height = 3;
    canvas.fillColor("#000");
    canvas.fillRoundRect(start.x - padding, start.y - padding, maxWidth + 2 * padding, height + 2 * padding, 2);
    if (I.cooldown.boost === 0) {
      canvas.fillColor("#0F0");
    } else {
      canvas.fillColor("#080");
    }
    canvas.fillRoundRect(start.x, start.y, maxWidth * ratio, height, 2);
    if (I.shootPower) {
      maxWidth = 40;
      height = 5;
      ratio = Math.min(I.shootPower / maxShotPower, 1);
      center = self.center().floor();
      return canvas.withTransform(Matrix.translation(center.x, center.y).concat(Matrix.rotation(movementDirection)), function() {
        canvas.fillColor("#000");
        canvas.fillRoundRect(-(padding + height) / 2, -padding, maxWidth + 2 * padding, height, 2);
        if (I.shootPower >= maxShotPower && (I.age / 2).floor() % 2) {
          canvas.fillColor("#0EF");
        } else {
          canvas.fillColor("#EE0");
        }
        return canvas.fillRoundRect(-height / 2, 0, maxWidth * ratio, height, 2);
      });
    }
  };
  drawControlCircle = function(canvas) {
    var circle, color;
    color = Color(playerColor).lighten(0.10);
    color.a("0.25");
    circle = self.controlCircle();
    return canvas.fillCircle(circle.x, circle.y, circle.radius, color);
  };
  particleSizes = [5, 4, 3];
  addSprayParticleEffect = function(push, color) {
    if (color == null) {
      color = BLOOD_COLOR;
    }
    push = push.norm(13);
    return engine.add({
      "class": "Emitter",
      duration: 9,
      sprite: Sprite.EMPTY,
      velocity: I.velocity,
      particleCount: 5,
      batchSize: 5,
      x: I.x + I.width / 2 + push.x,
      y: I.y + I.height / 2 + push.y,
      zIndex: 1 + (I.y + I.height + 1) / CANVAS_HEIGHT,
      generator: {
        color: color,
        duration: 8,
        height: function(n) {
          return particleSizes.wrap(n);
        },
        maxSpeed: 50,
        velocity: function(n) {
          return Point.fromAngle(Random.angle()).scale(rand(5) + 1).add(push);
        },
        width: function(n) {
          return particleSizes.wrap(n);
        }
      }
    });
  };
  self = Base(I).extend({
    bloody: function() {
      if (I.wipeout) {
        return I.blood.body += rand(5);
      } else {
        I.blood.leftSkate = (I.blood.leftSkate + rand(10)).clamp(0, 60);
        return I.blood.rightSkate = (I.blood.rightSkate + rand(10)).clamp(0, 60);
      }
    },
    controlCircle: function() {
      var c, p, speed;
      p = Point.fromAngle(heading).scale(16);
      c = self.center().add(p);
      speed = I.velocity.magnitude();
      c.radius = 20 + ((100 - speed * speed) / 100 * 8).clamp(-7, 8);
      return c;
    },
    controlPuck: function(puck) {
      var p, positionDelta, puckControl, puckVelocity, targetPuckPosition;
      if (I.cooldown.shoot) {
        return;
      }
      puckControl = 4;
      p = Point.fromAngle(heading).scale(32);
      targetPuckPosition = self.center().add(p);
      puckVelocity = puck.I.velocity;
      positionDelta = targetPuckPosition.subtract(puck.center().add(puckVelocity));
      if (positionDelta.magnitude() > puckControl) {
        positionDelta = positionDelta.norm().scale(puckControl);
      }
      I.hasPuck = true;
      return puck.I.velocity = puck.I.velocity.add(positionDelta);
    },
    drawShadow: function(canvas) {
      var base;
      base = self.center().add(0, I.height / 2 + 4);
      return canvas.withTransform(Matrix.scale(1, -0.5, base), function() {
        var shadowColor;
        shadowColor = "rgba(0, 0, 0, 0.15)";
        canvas.fillCircle(base.x - 4, base.y + 16, 16, shadowColor);
        canvas.fillCircle(base.x, base.y + 8, 16, shadowColor);
        return canvas.fillCircle(base.x + 4, base.y + 16, 16, shadowColor);
      });
    },
    drawFloatingNameTag: drawFloatingNameTag,
    wipeout: function(push) {
      I.falls += 1;
      I.wipeout = 25;
      I.blood.face += rand(20) + rand(20) + rand(20) + I.falls;
      I.shootPower = 0;
      push = push.norm().scale(30);
      Sound.play("hit" + (rand(4)));
      Sound.play("crowd" + (rand(3)));
      addSprayParticleEffect(push);
      (rand(6) + 3).times(function() {
        return engine.add({
          "class": "Fan"
        });
      });
      return engine.add({
        "class": "Blood",
        x: I.x + push.x,
        y: I.y + push.y
      });
    }
  });
  leftSkatePos = function() {
    var p;
    p = Point.fromAngle(heading - Math.TAU / 4).scale(5);
    return self.center().add(p);
  };
  rightSkatePos = function() {
    var p;
    p = Point.fromAngle(heading + Math.TAU / 4).scale(5);
    return self.center().add(p);
  };
  shootPuck = function(direction) {
    var baseShotPower, circle, p, power, puck;
    puck = engine.find("Puck").first();
    power = Math.min(I.shootPower, maxShotPower);
    circle = self.controlCircle();
    baseShotPower = 15;
    if (Collision.circular(circle, puck.circle())) {
      p = Point.fromAngle(direction).scale(baseShotPower + power * 2);
      puck.I.velocity = puck.I.velocity.add(p);
    }
    return I.shootPower = 0;
  };
  lastLeftSkatePos = null;
  lastRightSkatePos = null;
  drawBloodStreaks = function() {
    var blood, color, currentLeftSkatePos, currentPos, currentRightSkatePos, cycle, skateBlood, thickness;
    if ((blood = I.blood.face) && rand(2) === 0) {
      color = Color(BLOOD_COLOR);
      currentPos = self.center();
      (rand(blood) / 3).floor().clamp(0, 2).times(function() {
        var p;
        I.blood.face -= 1;
        p = currentPos.add(Point.fromAngle(Random.angle()).scale(rand() * rand() * 16));
        return bloodCanvas.fillCircle(p.x, p.y, (rand(5) * rand() * rand()).clamp(0, 3), color);
      });
    }
    if (I.wipeout) {
      ;
    } else {
      currentLeftSkatePos = leftSkatePos();
      currentRightSkatePos = rightSkatePos();
      cycle = I.age % 30;
      if ((1 < cycle && cycle < 14)) {
        lastLeftSkatePos = null;
      }
      if ((15 < cycle && cycle < 29)) {
        lastRightSkatePos = null;
      }
      if (lastLeftSkatePos) {
        if (skateBlood = I.blood.leftSkate) {
          I.blood.leftSkate -= 1;
          color = BLOOD_COLOR;
          thickness = (skateBlood / 30).clamp(0, 1.5);
        } else {
          color = ICE_COLOR;
          thickness = 1;
        }
        bloodCanvas.strokeColor(color);
        bloodCanvas.drawLine(lastLeftSkatePos, currentLeftSkatePos, thickness);
      }
      if (lastRightSkatePos) {
        if (skateBlood = I.blood.rightSkate) {
          I.blood.rightSkate -= 1;
          color = BLOOD_COLOR;
          thickness = (skateBlood / 30).clamp(0, 1.5);
        } else {
          color = ICE_COLOR;
          thickness = 1;
        }
        bloodCanvas.strokeColor(color);
        bloodCanvas.drawLine(lastRightSkatePos, currentRightSkatePos, thickness);
      }
      lastLeftSkatePos = currentLeftSkatePos;
      return lastRightSkatePos = currentRightSkatePos;
    }
  };
  self.bind("step", function() {
    var key, value, _ref, _results;
    _ref = I.cooldown;
    _results = [];
    for (key in _ref) {
      value = _ref[key];
      _results.push(I.cooldown[key] = value.approach(0, 1));
    }
    return _results;
  });
  self.bind("step", function() {
    var bonus, movement, movementLength, movementScale, velocityLength, velocityNorm;
    I.boost = I.boost.approach(0, 1);
    I.wipeout = I.wipeout.approach(0, 1);
    if (I.velocity.magnitude() !== 0) {
      heading = Point.direction(Point(0, 0), I.velocity);
    }
    drawBloodStreaks();
    movementScale = 0.625;
    movement = Point(0, 0);
    if (I.cpu) {
      movement = self.computeDirection();
    } else if (controller) {
      movement = controller.position();
    } else {
      if (actionDown("left")) {
        movement = movement.add(Point(-1, 0));
      }
      if (actionDown("right")) {
        movement = movement.add(Point(1, 0));
      }
      if (actionDown("up")) {
        movement = movement.add(Point(0, -1));
      }
      if (actionDown("down")) {
        movement = movement.add(Point(0, 1));
      }
      movement = movement.norm();
    }
    if (movement.x || movement.y) {
      movementDirection = movement.direction();
    }
    if (I.wipeout) {
      lastLeftSkatePos = null;
      return lastRightSkatePos = null;
    } else {
      if (!I.cooldown.shoot && actionDown("B", "X")) {
        I.shootPower += 1;
        movementScale = 0.1;
      } else if (I.shootPower) {
        I.cooldown.shoot = 4;
        shootPuck(movementDirection);
      } else if (I.cooldown.boost < boostMeter && (actionDown("A", "L", "R") || (axisPosition(4) > 0) || (axisPosition(5) > 0))) {
        if (I.cooldown.boost === 0) {
          bonus = 10;
        } else {
          bonus = 2;
        }
        I.cooldown.boost += 4;
        movement = movement.scale(bonus);
      }
      velocityNorm = I.velocity.norm();
      velocityLength = I.velocity.length();
      movementLength = movement.length();
      if ((velocityLength > 4) && (movement.dot(velocityNorm) < (-0.95) * movementLength)) {
        addSprayParticleEffect(I.velocity, "rgba(128, 202, 255, 1)");
        I.velocity.x = 0;
        I.velocity.y = 0;
      } else {
        movement = movement.scale(movementScale);
        I.velocity = I.velocity.add(movement);
      }
      return I.hasPuck = false;
    }
  });
  self.bind('afterTransform', drawPowerMeters);
  self.bind("update", function() {
    var cycle, facingOffset, spriteIndex, teamColor;
    I.hflip = heading > 2 * Math.TAU / 8 || heading < -2 * Math.TAU / 8;
    if (I.wipeout) {
      spriteIndex = 17;
      if (!redTeam) {
        spriteIndex += 1;
      }
      I.spriteOffset = flyingOffset;
      return I.sprite = wideSprites[spriteIndex];
    } else {
      cycle = (I.age / 4).floor() % 2;
      if ((-Math.TAU / 8 <= heading && heading <= Math.TAU / 8)) {
        facingOffset = 0;
      } else if ((-3 * Math.TAU / 8 <= heading && heading <= -Math.TAU / 8)) {
        facingOffset = 4;
      } else if ((Math.TAU / 8 < heading && heading <= 3 * Math.TAU / 8)) {
        facingOffset = 2;
      } else {
        facingOffset = 0;
      }
      teamColor = redTeam * 16;
      spriteIndex = cycle + facingOffset + teamColor;
      I.spriteOffset = standingOffset;
      return I.sprite = sprites[spriteIndex];
    }
  });
  if (I.cpu) {
    self.include(AI);
  }
  return self;
};;
var Puck;
Puck = function(I) {
  var DEBUG_DRAW, drawBloodStreaks, heading, lastPosition, self;
  DEBUG_DRAW = false;
  $.reverseMerge(I, {
    blood: 0,
    color: "black",
    strength: 0.5,
    radius: 8,
    width: 16,
    height: 8,
    x: 512 - 8,
    y: (WALL_BOTTOM + WALL_TOP) / 2 - 4,
    friction: 0.05,
    mass: 0.01,
    zIndex: 10,
    spriteOffset: Point(-10, -32)
  });
  self = Base(I).extend({
    bloody: function() {
      return I.blood = (I.blood + 30).clamp(0, 120);
    },
    wipeout: $.noop
  });
  heading = 0;
  lastPosition = null;
  drawBloodStreaks = function() {
    var blood, color, currentPos;
    heading = Point.direction(Point(0, 0), I.velocity);
    currentPos = self.center();
    if (lastPosition && (blood = I.blood)) {
      I.blood -= 1;
      color = Color(BLOOD_COLOR);
      bloodCanvas.strokeColor(color);
      bloodCanvas.drawLine(lastPosition, currentPos, (blood / 20).clamp(1, 6));
    }
    return lastPosition = currentPos;
  };
  self.bind("drawDebug", function(canvas) {
    var center, scaledVelocity, x, y;
    center = self.center();
    x = center.x;
    y = center.y;
    scaledVelocity = I.velocity.scale(10);
    canvas.strokeColor("orange");
    return canvas.drawLine(x, y, x + scaledVelocity.x, y + scaledVelocity.y);
  });
  self.bind("step", function() {
    return drawBloodStreaks();
  });
  self.bind("positionUpdated", function() {
    var circle;
    if (!I.active) {
      return;
    }
    circle = self.circle();
    if (DEBUG_DRAW) {
      bloodCanvas.fillCircle(circle.x, circle.y, circle.radius, "rgba(0, 255, 0, 0.1)");
    }
    return engine.find("Goal").each(function(goal) {
      if (goal.withinGoal(circle)) {
        self.destroy();
        goal.score();
        return engine.add({
          "class": "Puck"
        });
      }
    });
  });
  self.bind("update", function() {
    return I.sprite = sprites[39];
  });
  return self;
};;
var Rink;
Rink = function(I) {
  var blue, canvas, faceOffCircleRadius, faceOffSpotRadius, fansSprite, red, rinkCornerRadius, x, y;
  I || (I = {});
  canvas = $("<canvas width=" + CANVAS_WIDTH + " height=" + CANVAS_HEIGHT + " />").appendTo("body").css({
    position: "absolute",
    top: 0,
    left: 0,
    zIndex: "-2"
  }).powerCanvas();
  red = "red";
  blue = "blue";
  faceOffSpotRadius = 5;
  faceOffCircleRadius = 38;
  rinkCornerRadius = Rink.CORNER_RADIUS;
  canvas.fillColor("white");
  canvas.strokeColor("#888");
  canvas.fillRoundRect(WALL_LEFT, WALL_TOP, ARENA_WIDTH, ARENA_HEIGHT, rinkCornerRadius);
  canvas.strokeColor(blue);
  x = WALL_LEFT + ARENA_WIDTH / 3;
  canvas.drawLine(x, WALL_TOP, x, WALL_BOTTOM, 4);
  x = WALL_LEFT + ARENA_WIDTH * 2 / 3;
  canvas.drawLine(x, WALL_TOP, x, WALL_BOTTOM, 4);
  canvas.strokeColor(red);
  x = WALL_LEFT + ARENA_WIDTH / 2;
  canvas.drawLine(x, WALL_TOP, x, WALL_BOTTOM, 2);
  x = WALL_LEFT + ARENA_WIDTH / 2;
  y = WALL_TOP + ARENA_HEIGHT / 2;
  canvas.fillCircle(x, y, faceOffSpotRadius, blue);
  canvas.context().lineWidth = 2;
  canvas.strokeCircle(x, y, faceOffCircleRadius, blue);
  canvas.strokeColor(red);
  x = WALL_LEFT + ARENA_WIDTH / 10;
  canvas.drawLine(x, WALL_TOP, x, WALL_BOTTOM, 1);
  canvas.strokeRect(x, WALL_TOP + ARENA_HEIGHT / 2 - 16, 16, 32);
  x = WALL_LEFT + ARENA_WIDTH * 9 / 10;
  canvas.drawLine(x, WALL_TOP, x, WALL_BOTTOM, 1);
  canvas.strokeRect(x - 16, WALL_TOP + ARENA_HEIGHT / 2 - 16, 16, 32);
  [1, 3].each(function(verticalQuarter) {
    y = WALL_TOP + verticalQuarter / 4 * ARENA_HEIGHT;
    return [1 / 5, 1 / 3 + 1 / 40, 2 / 3 - 1 / 40, 4 / 5].each(function(faceOffX, i) {
      x = WALL_LEFT + faceOffX * ARENA_WIDTH;
      canvas.fillCircle(x, y, faceOffSpotRadius, red);
      if (i === 0 || i === 3) {
        canvas.context().lineWidth = 2;
        return canvas.strokeCircle(x, y, faceOffCircleRadius, red);
      }
    });
  });
  return fansSprite = Sprite.loadByName("fans", function() {
    return fansSprite.fill(canvas, 0, 0, App.width, WALL_TOP);
  });
};
Rink.CORNER_RADIUS = 96;;
var Scoreboard;
Scoreboard = function(I) {
  var nextPeriod, self;
  $.reverseMerge(I, {
    gameOver: false,
    score: {
      home: 0,
      away: 0
    },
    period: 0,
    periodTime: 1 * 60 * 30,
    reverse: false,
    sprite: Sprite.loadByName("scoreboard"),
    time: 0,
    x: rand(App.width).snap(32),
    y: rand(WALL_TOP).snap(32),
    zamboniInterval: 30 * 30,
    zIndex: 10
  });
  nextPeriod = function() {
    I.time = I.periodTime;
    I.period += 1;
    if (I.period === 4) {
      return I.gameOver = true;
    }
  };
  nextPeriod();
  self = GameObject(I).extend({
    draw: function(canvas) {
      var minutes, seconds, time;
      I.sprite.draw(canvas, WALL_LEFT + (ARENA_WIDTH - I.sprite.width) / 2, 16);
      time = Math.max(I.time, 0);
      minutes = (time / 30 / 60).floor();
      seconds = ((time / 30).floor() % 60).toString();
      if (seconds.length === 1) {
        seconds = "0" + seconds;
      }
      canvas.fillColor("red");
      canvas.font("bold 24px consolas, 'Courier New', 'andale mono', 'lucida console', monospace");
      canvas.fillText("" + minutes + ":" + seconds, WALL_LEFT + ARENA_WIDTH / 2 - 22, 46);
      canvas.fillText(I.period, WALL_LEFT + ARENA_WIDTH / 2 + 18, 84);
      canvas.fillText(I.score.home, WALL_LEFT + ARENA_WIDTH / 2 - 72, 60);
      canvas.fillText(I.score.away, WALL_LEFT + ARENA_WIDTH / 2 + 90, 60);
      if (I.gameOver) {
        canvas.font("bold 24px consolas, 'Courier New', 'andale mono', 'lucida console', monospace");
        canvas.fillColor("#000");
        return canvas.centerText("GAME OVER", 384);
      }
    },
    score: function(team) {
      if (!I.gameOver) {
        return I.score[team] += 1;
      }
    }
  });
  self.bind("update", function() {
    if (I.time % I.zamboniInterval === 0) {
      if (!(I.time === I.periodTime && I.period === 1)) {
        I.reverse = !I.reverse;
        engine.add({
          "class": "Zamboni",
          reverse: I.reverse
        });
      }
    }
    I.time -= 1;
    if (I.gameOver) {
      ;
    } else {
      if (I.time === 0) {
        return nextPeriod();
      }
    }
  });
  self.attrReader("gameOver");
  return self;
};;
var Shockwave;
Shockwave = function(I) {
  var constructGradient, flameEndColor, flameMiddleColor, flameStartColor, self, shadowColor, transparentColor;
  I || (I = {});
  $.reverseMerge(I, {
    radius: 10,
    maxRadius: 150,
    offsetHeight: -12,
    zIndex: 3
  });
  flameStartColor = "rgba(64, 8, 4, 0.5)";
  flameMiddleColor = "rgba(192, 128, 64, 0.9)";
  flameEndColor = "rgba(192, 32, 16, 1)";
  transparentColor = "rgba(0, 0, 0, 0)";
  shadowColor = "rgba(0, 0, 0, 0.5)";
  constructGradient = function(context, min, max, shadow) {
    var radialGradient, y;
    if (shadow == null) {
      shadow = false;
    }
    if (shadow) {
      y = I.y;
    } else {
      y = I.y + I.offsetHeight;
    }
    radialGradient = context.createRadialGradient(I.x, y, 0, I.x, y, max);
    if (min > 0) {
      radialGradient.addColorStop(0, transparentColor);
      radialGradient.addColorStop((min - 1) / max, transparentColor);
    }
    if (shadow) {
      radialGradient.addColorStop(min / max, shadowColor);
      radialGradient.addColorStop(1, shadowColor);
    } else {
      radialGradient.addColorStop(min / max, flameStartColor);
      radialGradient.addColorStop((min + max) / (2 * max), flameMiddleColor);
      radialGradient.addColorStop(1, flameEndColor);
    }
    return radialGradient;
  };
  self = GameObject(I).extend({
    draw: function(canvas) {
      var g, max, min;
      min = Math.max(I.radius - 20, 0);
      max = I.radius;
      g = constructGradient(canvas.context(), min, max, true);
      canvas.fillCircle(I.x, I.y, max, g);
      g = constructGradient(canvas.context(), min, max);
      return canvas.fillCircle(I.x, I.y + I.offsetHeight, max, g);
    }
  });
  self.bind("step", function() {
    var maxCircle, minCircle;
    maxCircle = I;
    minCircle = {
      x: I.x,
      y: I.y,
      radius: Math.max(I.radius - 20, 0)
    };
    engine.find("Player, Zamboni, Puck").each(function(object) {
      var objectCircle, shockwaveForce;
      objectCircle = object.circle();
      if (Collision.circular(objectCircle, maxCircle) && !Collision.circular(objectCircle, minCircle)) {
        shockwaveForce = object.center().subtract(I).norm(20);
        object.wipeout(shockwaveForce);
        return object.I.velocity = object.I.velocity.add(shockwaveForce);
      }
    });
    I.radius += 10;
    if (I.radius > I.maxRadius) {
      return self.destroy();
    }
  });
  return self;
};;
var TitleScreen;
TitleScreen = function(I) {
  var directory, joysticksConfig, joysticksLabel, loadingText, titleScreen, titleScreenImage, titleScreenText, _ref;
  $.reverseMerge(I, {
    backgroundColor: "#00010D",
    callback: $.noop
  });
  directory = (typeof App !== "undefined" && App !== null ? (_ref = App.directories) != null ? _ref.images : void 0 : void 0) || "images";
  titleScreen = $("<div />", {
    css: {
      backgroundColor: I.backgroundColor,
      fontFamily: "monospace",
      fontSize: "20px",
      fontWeight: "bold",
      left: 0,
      margin: "auto",
      position: "absolute",
      textAlign: "center",
      top: 0,
      zIndex: 1000
    }
  }).appendTo("body");
  titleScreenImage = $("<img />", {
    height: App.height,
    src: "" + BASE_URL + "/" + directory + "/title.png",
    width: App.width
  }).appendTo(titleScreen);
  loadingText = $("<div />", {
    text: "Loading...",
    css: {
      bottom: "40%",
      color: "#FFF",
      position: "absolute",
      width: "100%",
      zIndex: -1
    }
  }).appendTo(titleScreen);
  titleScreenText = $("<div />", {
    text: "Press any key to begin",
    css: {
      bottom: "12.5%",
      color: "#00010D",
      position: "absolute",
      width: "100%",
      zIndex: 1
    }
  }).appendTo(titleScreen);
  joysticksLabel = $("<label />", {
    text: "Joysticks",
    css: {
      position: "absolute",
      bottom: "10px",
      right: "10px",
      zIndex: 2
    }
  }).appendTo(titleScreen);
  joysticksConfig = $("<input />", {
    checked: false,
    type: "checkbox"
  }).appendTo(joysticksLabel);
  return $(document).one("keydown", function() {
    if (config.joysticks = joysticksConfig.attr("checked")) {
      config.joystickPlayers = config.players;
      config.keyboardPlayers = 0;
    }
    titleScreen.remove();
    return I.callback();
  });
};;
var Zamboni;
Zamboni = function(I) {
  var SWEEPER_SIZE, addParticleEffect, bounds, cleanIce, drawScorch, generatePath, heading, lastPosition, particleColors, particleSizes, path, pathIndex, pathfind, self;
  $.reverseMerge(I, {
    blood: 0,
    careening: false,
    color: "yellow",
    fuse: 30,
    strength: 5,
    radius: 16,
    rotation: 0,
    width: 96,
    height: 48,
    speed: 8,
    x: 0,
    y: ARENA_HEIGHT / 2 + WALL_TOP,
    velocity: Point(1, 0),
    mass: 10,
    zIndex: 10
  });
  SWEEPER_SIZE = 48;
  bounds = 256;
  if (I.reverse) {
    I.x = App.width;
  }
  path = [];
  generatePath = function() {
    var horizontalPoints, verticalPoints;
    horizontalPoints = ARENA_WIDTH / SWEEPER_SIZE;
    verticalPoints = ARENA_HEIGHT / SWEEPER_SIZE;
    path.push(Point(0, verticalPoints / 2));
    (horizontalPoints / 2 - 1).floor().times(function(x) {
      var xEnd, y, yEnd;
      x += 0.5;
      y = 3 / 4 * x + 0.5;
      xEnd = horizontalPoints - x;
      yEnd = verticalPoints - y;
      path.push(Point(x, y));
      path.push(Point(xEnd, y));
      path.push(Point(xEnd, yEnd));
      path.push(Point(x, yEnd));
      return path.push(Point(x, y + 3 / 4));
    });
    path.push(Point(0, verticalPoints / 2));
    return path.push(Point(-10, verticalPoints / 2));
  };
  generatePath();
  particleSizes = [8, 4, 8, 16, 24, 12];
  particleColors = ["rgba(255, 0, 128, 0.75)", "#333"];
  addParticleEffect = function() {
    var v;
    v = I.velocity.norm(5);
    return engine.add({
      "class": "Emitter",
      duration: 21,
      sprite: Sprite.EMPTY,
      velocity: I.velocity,
      particleCount: 9,
      batchSize: 5,
      x: I.x + I.width / 2,
      y: I.y + I.height / 2,
      zIndex: 1 + (I.y + I.height + 1) / CANVAS_HEIGHT,
      generator: {
        color: function(n) {
          return particleColors.wrap(n);
        },
        duration: 20,
        height: function(n) {
          return particleSizes.wrap(n);
        },
        maxSpeed: 50,
        velocity: function(n) {
          return Point.fromAngle(Random.angle()).scale(5).add(v);
        },
        width: function(n) {
          return particleSizes.wrap(n);
        }
      }
    });
  };
  drawScorch = function() {
    var scorch;
    scorch = Zamboni.scorchSprite;
    return bloodCanvas.withTransform(Matrix.translation(I.x + I.width / 2 - scorch.width / 2, I.y + I.height / 2 - scorch.height / 2), function() {
      return scorch.fill(bloodCanvas, 0, 0, scorch.width, scorch.height);
    });
  };
  self = Base(I).extend({
    controlCircle: function() {
      return self.circle();
    },
    crush: function(other) {
      if (!other.puck()) {
        return I.blood = (I.blood + 1).clamp(0, 6);
      }
    },
    controlPuck: $.noop,
    collidesWithWalls: function() {
      return I.careening;
    },
    wipeout: function() {
      if (I.careening) {
        return self.destroy();
      } else {
        return I.careening = true;
      }
    }
  });
  heading = 0;
  lastPosition = null;
  pathIndex = 0;
  cleanIce = function() {
    var boxPoints, currentPos;
    currentPos = self.center();
    boxPoints = [Point(SWEEPER_SIZE / 2, 0), Point(SWEEPER_SIZE, 0), Point(SWEEPER_SIZE, SWEEPER_SIZE), Point(SWEEPER_SIZE / 2, SWEEPER_SIZE)].map(function(p) {
      return self.getTransform().transformPoint(p);
    });
    bloodCanvas.compositeOperation("destination-out");
    bloodCanvas.globalAlpha(0.25);
    bloodCanvas.fillColor("#000");
    bloodCanvas.fillCircle(currentPos.x, currentPos.y, SWEEPER_SIZE / 2, "#000");
    bloodCanvas.fillShape.apply(null, boxPoints);
    bloodCanvas.globalAlpha(1);
    return bloodCanvas.compositeOperation("source-over");
  };
  pathfind = function() {
    var center, nextTarget;
    if (path[pathIndex]) {
      nextTarget = path[pathIndex].scale(SWEEPER_SIZE).add(Point(WALL_LEFT, WALL_TOP));
      if (I.reverse) {
        nextTarget = Matrix.scale(-1, 1, Point(WALL_LEFT + ARENA_WIDTH / 2, WALL_TOP + ARENA_HEIGHT / 2)).transformPoint(nextTarget);
      }
      nextTarget.radius = 0;
      center = self.center();
      center.radius = 5;
      if (Collision.circular(center, nextTarget)) {
        pathIndex += 1;
      }
      return I.velocity = nextTarget.subtract(center).norm().scale(I.speed);
    }
  };
  self.bind("step", function() {
    if (I.x < -bounds || I.x > App.width + bounds) {
      I.active = false;
    }
    if (I.careening) {
      I.rotation += Math.TAU / 10;
      I.fuse -= 1;
      if (I.fuse <= 0) {
        self.destroy();
      }
    } else {
      pathfind();
      heading = Point.direction(Point(0, 0), I.velocity);
      if (!(I.age < 1)) {
        cleanIce();
      }
      I.hflip = heading > 2 * Math.TAU / 8 || heading < -2 * Math.TAU / 8;
    }
    return I.sprite = wideSprites[16 + 8 * (I.blood / 3).floor()];
  });
  self.bind("destroy", function() {
    Sound.play("explosion");
    addParticleEffect();
    drawScorch();
    return engine.add({
      "class": "Shockwave",
      x: I.x + I.width / 2,
      y: I.y + I.height / 2
    });
  });
  return self;
};
Zamboni.scorchSprite = Sprite.loadByName("scorch");;
App.entities = {};;
;$(function(){ var DEBUG_DRAW, engineUpdate, physics, restartMatch, rink, startMatch;
Sprite.loadSheet = function(name, tileWidth, tileHeight) {
  var directory, image, sprites, url, _ref;
  directory = (typeof App !== "undefined" && App !== null ? (_ref = App.directories) != null ? _ref.images : void 0 : void 0) || "images";
  url = "" + BASE_URL + "/" + directory + "/" + name + ".png?" + MTIME;
  sprites = [];
  image = new Image();
  image.onload = function() {
    return (image.height / tileHeight).times(function(row) {
      return (image.width / tileWidth).times(function(col) {
        return sprites.push(Sprite.create(image, col * tileWidth, row * tileHeight, tileWidth, tileHeight));
      });
    });
  };
  image.src = url;
  return sprites;
};
window.sprites = Sprite.loadSheet("sprites", 32, 48);
window.wideSprites = Sprite.loadSheet("sprites", 64, 48);
window.tallSprites = Sprite.loadSheet("sprites", 32, 96);
window.CANVAS_WIDTH = App.width;
window.CANVAS_HEIGHT = App.height;
window.WALL_LEFT = 32;
window.WALL_RIGHT = CANVAS_WIDTH - WALL_LEFT;
window.WALL_TOP = 192;
window.WALL_BOTTOM = CANVAS_HEIGHT - (WALL_TOP - 128);
window.ARENA_WIDTH = WALL_RIGHT - WALL_LEFT;
window.ARENA_HEIGHT = WALL_BOTTOM - WALL_TOP;
window.BLOOD_COLOR = "#BA1A19";
window.ICE_COLOR = "rgba(192, 255, 255, 0.2)";
window.config = {
  throwBottles: true,
  players: 6,
  keyboardPlayers: 2,
  joystickPlayers: 0
};
config.joysticks = config.joystickPlayers > 0;
rink = Rink();
physics = Physics();
window.bloodCanvas = $("<canvas width=" + CANVAS_WIDTH + " height=" + CANVAS_HEIGHT + " />").appendTo("body").css({
  position: "absolute",
  top: 0,
  left: 0,
  zIndex: "-1"
}).powerCanvas();
bloodCanvas.strokeColor(BLOOD_COLOR);
DEBUG_DRAW = false;
window.engine = Engine({
  canvas: $("canvas").powerCanvas(),
  clear: true,
  excludedModules: ["HUD"],
  showFPS: true,
  zSort: true
});
Music.play("title_screen");
restartMatch = function() {
  var doRestart;
  doRestart = function() {
    engine.I.objects.clear();
    engine.unbind("afterUpdate", doRestart);
    return startMatch();
  };
  return engine.bind("afterUpdate", doRestart);
};
startMatch = function() {
  var humanPlayers, leftGoal, rightGoal;
  window.scoreboard = engine.add({
    "class": "Scoreboard"
  });
  engine.add({
    sprite: Sprite.loadByName("corner_left"),
    x: 0,
    y: WALL_TOP - 48,
    width: 128,
    zIndex: 1
  });
  engine.add({
    sprite: Sprite.loadByName("corner_left"),
    hflip: true,
    x: WALL_RIGHT - 96,
    y: WALL_TOP - 48,
    width: 128,
    zIndex: 1
  });
  engine.add({
    spriteName: "corner_back_right",
    hflip: true,
    x: 32,
    y: WALL_BOTTOM - 128,
    zIndex: 2
  });
  engine.add({
    spriteName: "corner_back_right",
    x: WALL_RIGHT - 96,
    y: WALL_BOTTOM - 128,
    zIndex: 2
  });
  engine.add({
    "class": "Boards",
    sprite: Sprite.loadByName("boards_front"),
    y: WALL_TOP - 48,
    zIndex: 1
  });
  engine.add({
    "class": "Boards",
    sprite: Sprite.loadByName("boards_back"),
    y: WALL_BOTTOM - 48,
    zIndex: 10
  });
  humanPlayers = config.keyboardPlayers + config.joystickPlayers;
  config.players.times(function(i) {
    var controller, joystick, x, y;
    y = WALL_TOP + ARENA_HEIGHT * ((i / 2).floor() + 1) / 4;
    x = WALL_LEFT + ARENA_WIDTH / 2 + ((i % 2) - 0.5) * ARENA_WIDTH / 6;
    if (i < config.keyboardPlayers) {
      joystick = false;
      controller = i;
    } else {
      joystick = true;
      controller = i - config.keyboardPlayers;
    }
    return engine.add({
      "class": "Player",
      controller: controller,
      id: i,
      team: i % 2,
      cpu: i >= humanPlayers,
      joystick: joystick,
      x: x,
      y: y
    });
  });
  engine.add({
    "class": "Puck"
  });
  leftGoal = engine.add({
    "class": "Goal",
    team: 0,
    x: WALL_LEFT + ARENA_WIDTH / 10 - 32
  });
  leftGoal.bind("score", function() {
    return scoreboard.score("away");
  });
  rightGoal = engine.add({
    "class": "Goal",
    team: 1,
    x: WALL_LEFT + ARENA_WIDTH * 9 / 10
  });
  rightGoal.bind("score", function() {
    return scoreboard.score("home");
  });
  Music.play("music1");
  return engine.start();
};
TitleScreen({
  callback: startMatch
});
engine.bind("beforeDraw", function(canvas) {
  return engine.find("Player").invoke("drawShadow", canvas);
});
engine.bind("draw", function(canvas) {
  if (DEBUG_DRAW) {
    engine.find("Player, Puck, Goal, Bottle").each(function(puck) {
      return puck.trigger("drawDebug", canvas);
    });
  }
  canvas.font("bold 16px consolas, 'Courier New', 'andale mono', 'lucida console', monospace");
  return engine.find("Player").invoke("drawFloatingNameTag", canvas);
});
engineUpdate = function() {
  var objects, players, playersAndPucks, pucks, zambonis;
  if (config.joysticks) {
    Joysticks.update();
  }
  pucks = engine.find("Puck");
  players = engine.find("Player").shuffle();
  zambonis = engine.find("Zamboni");
  objects = players.concat(zambonis, pucks);
  playersAndPucks = players.concat(pucks);
  players.each(function(player) {
    if (player.I.wipeout) {
      return;
    }
    return pucks.each(function(puck) {
      if (Collision.circular(player.controlCircle(), puck.circle())) {
        return player.controlPuck(puck);
      }
    });
  });
  physics.process(objects);
  return playersAndPucks.each(function(player) {
    var splats;
    splats = engine.find("Blood");
    return splats.each(function(splat) {
      if (Collision.circular(player.circle(), splat.circle())) {
        return player.bloody();
      }
    });
  });
};
engine.bind("update", engineUpdate);
Joysticks.init();
log(Joysticks.status());
$(document).bind("keydown", "0", function() {
  return DEBUG_DRAW = !DEBUG_DRAW;
});
(6).times(function(i) {
  var n;
  n = i + 1;
  return $(document).bind("keydown", n.toString(), function() {
    if (scoreboard.gameOver()) {
      window.config.joystickPlayers = n;
      return restartMatch();
    }
  });
}); });