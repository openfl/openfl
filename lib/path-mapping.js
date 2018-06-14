
"use strict"

var path = require('path');
// Get the absolute path to this directory
var dir = path.resolve(__dirname);

// Must use absolute paths to the openfl modules or else 3rd party libraries 
// installed under node_modules may import different version of openfl modules
module.exports = function() {
  return {
		"openfl$": path.join(dir, "openfl"),
		"openfl/desktop": path.join(dir, "openfl/desktop"),
		"openfl/display": path.join(dir, "openfl/display"),
		"openfl/display3D": path.join(dir, "openfl/display3D"),
		"openfl/errors": path.join(dir, "openfl/errors"),
		"openfl/events": path.join(dir, "openfl/events"),
		"openfl/external": path.join(dir, "openfl/external"),
		"openfl/filters": path.join(dir, "openfl/filters"),
		"openfl/geom": path.resolve (__dirname, "openfl/geom"),
		"openfl/media": path.resolve (__dirname, "openfl/media"),
		"openfl/net": path.join(dir, "openfl/net"),
		"openfl/profiler": path.join(dir, "openfl/profiler"),
		"openfl/sensors": path.join(dir, "openfl/sensors"),
		"openfl/system": path.join(dir, "openfl/system"),
		"openfl/text": path.join(dir, "openfl/text"),
		"openfl/ui": path.join(dir, "openfl/ui"),
		"openfl/utils": path.join(dir, "openfl/utils"),
		"openfl/utils/Assets": path.join(dir, "openfl/utils/Assets"),
		"openfl/Lib": path.join(dir, "openfl/Lib"),
		"openfl/Memory": path.join(dir, "openfl/Memory"),
		"openfl/Vector": path.join(dir, "openfl/Vector"),
		"openfl/VectorData": path.join(dir, "openfl/VectorData"),
		"openfl/_internal": path.join(dir, "openfl/_internal"),
		"openfl/_Vector": path.join(dir, "openfl/_Vector"),
		"lime/_backend": path.join(dir, "_gen/lime/_backend"),
		"lime/app": path.join(dir, "_gen/lime/app"),
		"lime/graphics": path.join(dir, "_gen/lime/graphics"),
		"lime/math": path.join(dir, "_gen/lime/math"),
		"lime/media": path.join(dir, "_gen/lime/media"),
		"lime/net": path.join(dir, "_gen/lime/net"),
		"lime/system": path.join(dir, "_gen/lime/system"),
		"lime/text": path.join(dir, "_gen/lime/text"),
		"lime/ui": path.join(dir, "_gen/lime/ui"),
		"lime/utils": path.join(dir, "_gen/lime/utils"),
};
}