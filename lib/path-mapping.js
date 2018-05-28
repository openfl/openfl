
"use strict"

var path = require('path');
var dir = path.resolve(__dirname);

module.exports = function() {
  return {
		"openfl$": "openfl/lib/openfl",
		"openfl/desktop": "openfl/lib/openfl/desktop",
		"openfl/display": "openfl/lib/openfl/display",
		"openfl/display3D": "openfl/lib/openfl/display3D",
		"openfl/errors": "openfl/lib/openfl/errors",
		"openfl/events": "openfl/lib/openfl/events",
		"openfl/external": "openfl/lib/openfl/external",
		"openfl/filters": "openfl/lib/openfl/filters",
		"openfl/geom": "openfl/lib/openfl/geom",
		"openfl/media": "openfl/lib/openfl/media",
		"openfl/net": "openfl/lib/openfl/net",
		"openfl/profiler": "openfl/lib/openfl/profiler",
		"openfl/sensors": "openfl/lib/openfl/sensors",
		"openfl/system": "openfl/lib/openfl/system",
		"openfl/text": "openfl/lib/openfl/text",
		"openfl/ui": "openfl/lib/openfl/ui",
		"openfl/utils": "openfl/lib/openfl/utils",
		"openfl/utils/Assets": "openfl/lib/openfl/utils/Assets",
		"openfl/Lib": "openfl/lib/openfl/Lib",
		"openfl/Memory": "openfl/lib/openfl/Memory",
		"openfl/Vector": "openfl/lib/openfl/Vector",
		"openfl/VectorData": "openfl/lib/openfl/VectorData",
		"openfl/_internal": "openfl/lib/openfl/_internal",
		"openfl/_Vector": "openfl/lib/openfl/_Vector",
		"lime/_backend": "openfl/lib/_gen/lime/_backend",
		"lime/app": "openfl/lib/_gen/lime/app",
		"lime/graphics": "openfl/lib/_gen/lime/graphics",
		"lime/math": "openfl/lib/_gen/lime/math",
		"lime/media": "openfl/lib/_gen/lime/media",
		"lime/net": "openfl/lib/_gen/lime/net",
		"lime/system": "openfl/lib/_gen/lime/system",
		"lime/text": "openfl/lib/_gen/lime/text",
		"lime/ui": "openfl/lib/_gen/lime/ui",
		"lime/utils": "openfl/lib/_gen/lime/utils",
};
}