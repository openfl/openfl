3.1.3 (07/13/2015)
------------------

* Added support for bitmapData.scroll
* Updated to support newer openfl-samples
* Updated to include a default project icon
* Fixed a regression in bitmapData.draw
* Improved Assets.load* to share one background thread (legacy)


3.1.2 (07/09/2015)
------------------

* Improved Assets.load* to be asynchronous on native platforms
* Improved URLLoader to be asynchronous on native platforms
* Improved Loader to be asynchronous on native platforms
* Improved scrollRect support in canvas and GL renderers
* Fixed TextField bounds calculations in the Cairo renderer
* Fixed over-multiplication of text in the Cairo renderer
* Improved Loader to not be picky about file extensions (legacy)
* Fixed support for hxscout (legacy)


3.1.1 (07/02/2015)
------------------

* Improved the behavior of EventDispatcher
* Changed relevant TextFormat values to be Int, not Float
* Improved support for TextField leading values
* Improved multi-touch support on desktop targets
* Improved support for using NEAREST filter mode in Stage3D
* Fixed rendering when TextField autoSize increases the width
* Fixed some issues that occurred with too-large alpha values
* Fixed support for sound.length on native targets
* Fixed support for keyboardEvent.keyLocation


3.1.0 (06/08/2015)
------------------

* Enabled Cairo graphics in GL mode by default
* Added initial hooks for Haxe telemetry (hxscout)
* Fixed bug in image premultiplication
* Fixed black textures when mixing Cairo with OpenGL
* Fixed crash in HTML5 when using sparse graphics


3.0.8 (05/31/2015)
------------------

* Guard hybrid Cairo + GL behavior behind #if cairo_graphics for now


3.0.7 (05/30/2015)
------------------

* Added hybrid Cairo + GL renderer support for native
* Switched to use canvas graphics when targeting WebGL/HTML5
* Many improvements to the Cairo renderer, improved canvas rendering
* Improved GL blend mode support
* Improved support for scrollRect
* Added stage focus in and out events
* Added an initial implementation of the GameInput API
* Improved the behavior of event.target
* Improved add/remove event listener behavior when dispatching
* Improved bounds check for bezier curves
* Improved the behavior of mouse event buttonDown
* Initial re-implementation of URLLoader for native 
* Added handling for Lime application.frameRate
* Fixed SystemPath (legacy)


3.0.6 (05/14/2015)
------------------

* Fix regression in event dispatch behavior


3.0.5 (05/13/2015)
------------------

* Improved formatting for thrown errors on HTML5
* Separated the behavior of event preventDefault from stopPropagation
* Fixed the event dispatch order for DisplayObjectContainer
* Fixed support for -Dhybrid using latest Lime release


3.0.4 (05/12/2015)
------------------

* Improved accuracy of HTML5 canvas Graphics renderer
* Added support for window hardware=false
* Added initial Cairo renderer support
* Made big improvements to HTML5 canvas TextField input
* Added MouseEvent.MOUSE_LEAVE event support
* Improved HTML5 canvas linear gradient support
* Improved Stage3D texture uploads
* Implemented BitmapData.getColorBoundsRect
* Improved checks for invalid BitmapData in Assets
* Improved beginBitmapFill for GL Graphics
* Improved pixel snapping support for GL rendering
* Improved cleanup of native sound channels
* Improved compatibility between Stage3D and internal GL rendering
* Fixed HTML5 canvas scrollRect
* Fixed handling of embedded fonts in some cases
* Fixed some issues with bounds calculations
* Fixed support for initial SoundTransform volume on native
* Improved non-blocking HTTPS support (legacy)


3.0.3 (04/21/2015)
------------------

* Improved hit test when there are interactive and non-interactive matches
* Improved accuracy of text metrics
* Improved accuracy of GL TextField glyph positioning
* Added wordWrap support to canvas TextField
* Added handling of stage.focus on mouse down
* Fixed the start time and loop count for native sounds
* Fixed the behavior of sprite.contains to loop recursively
* Fixed upside-down BitmapData in some cases when using GL bitmapData.draw
* Fixed layering of GL bitmapData.draw over existing BitmapData contents
* Improved performance of getRGBAPixels (legacy)


3.0.2 (04/15/2015)
------------------

* Improved handling of keyCode/charCode in keyboard events
* Improved the frame timing when using hybrid mode
* Improved the font lookup behavior of GL TextField
* Added better auto-size left support to GL TextField
* Added basic text line metrics in TextField
* Added support for compilation with -Ddisable-cffi
* Added dynamic DisplayObject field support for MovieClip
* Fixed UVs when using drawTiles with bitmapData.draw (GL)
* Fixed blendMode setting when using bitmapData.draw (GL)


3.0.1 (04/09/2015)
------------------

* Improved -Dhybrid support
* Improved handling of key codes in events
* Fixed alpha and blendMode for bitmapData.draw in GL


3.0.0 (04/08/2015)
------------------

* Added -Dhybrid support (Lime 2 + OpenFL legacy)
* Added initial support for gradient fills in canvas
* Added -Ddisable-legacy-audio for use with hybrid builds
* Added -Ddisable-legacy-networking for use with hybrid builds
* Improved the behavior of graphics.drawRoundRect in GL
* Updated OpenFL legacy for use with Lime 2.3.1
* Improved the transparency of bitmapData.draw renders in GL
* Fixed the count for HTML5 sound looping
* Fixed the solid and bitmap fill positioning in GL
* Fixed displayObject.getBounds for objects with graphics
* Fixed the default font paths used for Linux systems
* Fixed displayObject.hitTestPoint to use stage (not local) coordinates
* Added support for stage.softKeyboardRect in iOS (legacy)


3.0.0-beta.3 (03/26/2015)
-------------------------

* Updated for Lime 2.3
* Improved handling of default framebuffer on iOS
* Fixed mapping of the meta/command key
* Fixed System.exit


3.0.0-beta.2 (03/25/2015)
-------------------------

* Added support for default fonts in GL TextField
* Fixed an issue when unserializing SharedObjects
* Fixed an issue when embedding images
* Fixed builds when using "-Dlegacy" with the HTML5 target
* Fixed the GL window background color


3.0.0-beta (03/20/2015)
-----------------------

_Legacy OpenFL v2 behavior is available using -Dv2 or -Dlegacy_

* Added support for Haxe 3.2
* Added support for using OpenFL as a Lime module
* Added initial support for GL colorTransform
* Added initial support for GL masks
* Added initial support for OpenGL BitmapData.draw
* Added initial OpenGL TextField support
* Added fullscreen toggle support
* Implemented key modifiers for mouse events
* Implemented support for mouse wheel events
* Implemented Sound.fromFile
* Made drawTiles respect the parent (x, y) position
* Made drawTiles respect the parent alpha value
* Made Stage inherit from DisplayObjectContainer, not Sprite
* Fixed the implied (0, 0) start position in Graphics
* Fixed line thickness evaluation in Graphics
* Fixed an issue with SoundChannel peak in Neko
* Improved support for node.js


2.2.8 (03/02/2015)
------------------

#### Flash

* Fixed Tilesheet TILE_ROTATION

#### HTML5, Native (next)

* Added modifier support to keyboard events
* Added initial MOUSE_OVER/MOUSE_OUT support
* Added initial SimpleButton support
* Added initial input TextField support on HTML5

#### Native (v2)

* Added stage.softKeyboardRect for Android
* Added support for Mac fullscreen keyboard shortcut
* Fixed GLShader isValid/isInvalid
* Fixed dead-code elimination with TextFormat class
* Fixed GL.getParameter


2.2.7 (02/20/2015)
------------------

#### General

* Added TILE_BLEND_SUBTRACT to drawTiles
* Fixed issue calling "openfl" from a batch file

#### HTML5, Native (next)

* Updated the style of the default preloader
* Improved handling of HTML5 loaderInfo.url
* Improved calculation of HTML5 TextField height
* Restored support for displayObject.mask in HTML5
* Fixed difficulty changing stage align/scaleMode


2.2.6 (02/13/2015)
------------------

#### General

* Fixed regression in HTML5 font asset embedding
* Minor Stage3D improvements

#### HTML5, Native (next)

* Added support for Emscripten
* Improved handling of conflicting main class names


2.2.5 (02/11/2015)
------------------

#### General

* Improved documentation
* Implemented Capabilities.version
* Switched to Lime 2.1 System.getTimer where appropriate
* Improved Stage3D render-to-texture support
* Switched #if lime_legacy to #if !openfl_next, internally

#### HTML5, Native (next)

* Fixed conflicts with projects that use an "app" package
* Added initial alpha support for transform.colorTransform

#### Native (v2)

* Fixed support for the BlackBerry 10.3 simulator
* Fixed SAMPLE_DATA sounds on Android
* Fixed bindFramebuffer (null) behavior on iOS
* Improved the behavior of GL.getParameter


2.2.4 (01/22/2015)
------------------

#### General

* Added bitmapData.encode
* Added transform.matrix3D (using 2D matrix values for now)
* Added openfl.system.TouchscreenType
* Updated Sound.js, added error event dispatching for it
* Improved compatibility for the Stage3D layer

#### HTML5, Native (next)

* Combined js-flatten, DCE full and -minify for "html5 -final"
* Added graphics.drawPath
* Added graphics.lineStyle with alpha support to canvas
* Added support for Tilesheet.TILE_BLEND_ADD in canvas
* Improved bitmapData.getVector performance
* Fixed the event.target in Event.ADDED events

#### Native (v2)

* Reverted the Int32 change in bitmapData.getPixel32
* Improved Lib.getTimer on Neko
* Fixed sprite.getBounds (null)


2.2.3 (01/13/2015)
------------------

#### General

* Merged in the Away3D compatibility layer for Stage3D
* Added support for creating new empty SoundChannel instances
* Added support for bitmapData.merge()
* Improved compatibility with Haxe dead-code elimination

#### HTML5, Native (next)

* Improved the correctness of getPixels/setPixels
* Improved text align for HTML5 canvas TextField
* Fixed a minor issue in the Flash/HTML5 preloader

#### Native (v2)

* Added Event.COMPLETE/IOErrorEvent.IO_ERROR events to Sound
* Fixed large bitmapData.getPixel32() values on Neko
* Fixed the color order for getRGBAPixels
* Improved the load order for native fonts


2.2.2 (01/02/2015)
------------------

#### HTML5, Native (next)

* Improved the behavior of getObjectsUnderPoint
* Fixed an error in Graphics.lineStyle on Neko


2.2.1 (01/01/2015)
------------------

#### HTML5, Native (next)

* Now the document class is added to stage before new ()
* Improved the hitTest logic for both Sprite and Shape
* Fixed inline text styles in HTML5 TextField
* Expanded Capabilities to better match the Flash API
* Fixed Matrix.createBox

#### Native (v2)

* Expanded Capabilities to better match the Flash API
* Fixed Matrix.createBox


2.2.0 (12/31/2014)
------------------

#### HTML5, Native (next)

* Added MouseEvent.DOUBLE_CLICK event
* Added Mouse hide/show support
* Added support for buttonMode/useHandCursor
* Added Point.copyFrom
* Improved the behavior of getRect and related functions
* Improved the behavior of getObjectsUnderPoint
* Improved Graphics.lineStyle color
* Fixed font.fontName for embedded HTML5 fonts
* Fixed event.target when clicking a Bitmap
* Fixed BitmapData getPixels/paletteMap
* Fixed removeEventListener on Neko
* Updated the behavior of SampleDataEvent
* Updated to match Flash 12 addEventListener behavior

#### Native (v2)

* Improved the behavior of MouseEvent.DOUBLE_CLICK
* Migrated to the "next" EventDispatcher to fix issues
* Fixed support for Windows icons
* Fixed BitmapData paletteMap
* Moved "pixelSnapping" from DisplayObject to Bitmap
* Updated BitmapData.getRGBAPixels
* Fixed removeEventListener on Neko
* Updated to match Flash 12 addEventListener behavior
* Minor fix for development Haxe releases


2.1.8 (12/21/2014)
------------------

#### HTML5

* Fixed positioning for DOM shape rendering
* Fixed the "dirty" flag on HTML5 TextField

#### Java

* Implemented improvements for beta Java support


2.1.7 (12/04/2014)
------------------

#### HTML5, Native (next)

* Improved Graphics.drawRoundRect
* Improved OpenGL Tilesheet.drawTiles
* Restored middle/right mouse button events
* Fixed HTML5 support of openfl.media.Video

#### Native (v2)

* Fixes for DisplayObject.hitTestObject
* Fixed compilation when openfl.media.Video is imported
* Added non-op Graphics.cubicCurveTo for compatibility


2.1.6 (11/20/2014)
------------------

#### General

* Fixed API documentation script

#### Flash

* Improved the openfl.Assets cache

#### HTML5, Native (next)

* Added OpenGL Tilesheet.drawTiles
* Improved OpenGL Graphics.drawTriangles
* Made other improvements OpenGL Graphics class
* Improved Graphics.drawRect on canvas
* Fixed a divide-by-zero issue in Matrix3D.decompose
* Improved openfl.Vector array access in Neko
* Improved openfl.display.SimpleButton
* Improved the openfl.Assets cache

#### Native (v2)

* Added OpenGLView.dispose() (similar to "next")
* Improved cleanup in openfl.display.LoaderInfo
* Fixed typed array use in GL uniformMatrix
* Removed v2 openfl.Vector, preferring the "next" implementation


2.1.5 (11/01/2014)
------------------

#### HTML5, Native (next)

* Matrix fix in OpenGL display list rendering
* Improved OpenGL Graphics rendering
* Improved font handling to use true font names
* Embedded fonts are now automatically registered

#### Native (v2)

* Improved font handling to use true font names
* Embedded fonts are now automatically registered


2.1.4 (10/28/2014)
------------------

#### HTML5, Native (next)

* Fixed masking in canvas renderer

#### Native (v2)

* Fixed Assets.getText when asset is type BINARY


2.1.3 (10/23/2014)
------------------

#### General

* Added support for the "openfl" command again
* Fixed install of Lime using "openfl setup"

#### HTML5, Native (next)

* Improvements to OpenGL Graphics.drawTriangles


2.1.2 (10/20/2014)
------------------

#### General

* Added support for `<library path="" preload="" />`
* Added support for Tilesheet TILE_RECT
* Improved code completion in FlashDevelop

#### Flash

* Fixed mapping of openfl.geom.Matrix3D to flash.geom.Matrix3D
* Fixed mapping of openfl.geom.Orientation3D to flash.geom.Orientation3D
* Made Matrix3D use openfl.Vector instead of flash.Vector for consistency


2.1.1 (10/16/2014)
------------------

#### HTML5, Native (next)

* Fixed openfl.display.OpenGLView

#### Native (v2)

* Fix compilation of openfl.utils.JNI when not targeting Android


2.1.0 (10/14/2014)
------------------

#### General

* Migrated Flash and native (-Dnext) to Lime 2.0
* Unified each target backend under a single openfl.* class set
* Preserved the older native backend under openfl._v2, used by default

#### Flash

* Added Graphics.drawTiles
* Improved Tilesheet.drawTiles
* Fixed ArrayBufferView

#### HTML5, Native (next)

* Added openfl.geom.Orientation3D
* Improved openfl.geom.Matrix3D
* Fixed loading of images with GET parameters
* Improved embedded asset behavior
* Added OpenGL premultiplied alpha
* Added DisplayObject.hitTestPoint
* Added Graphics.drawRoundRect
* Improved OpenGL display list support
* Added initial OpenGL Graphics API support
* Added OpenGL BitmapData support
* Added Graphics.copyFrom
* Using -Djs-flatten on HTML5

#### Native (v2)

* Initial version (using Lime legacy)


2.0.1 (06/24/2014)
------------------

#### Native

* Added joystick input filtering to prevent redundant events
* Improved compatibility of openfl.net.SharedObject
* Added a userAgent property for openfl.net.URLRequest

#### HTML5

* Migrated to the new Lime 2.0, removed unnecessary code
* Added openfl.events.UncaughtErrorEvent
* Added BitmapData paletteMap, threshold and histogram
* Added BitmapData getVector/setVector
* Added Sprite startDrag/stopDrag
* Added openfl.net.Socket using web sockets
* Added a "count" parameter to Tilesheet.drawTiles
* Improved BitmapData.copyPixels
* Improved Graphics bitmap fill
* Fixed TextField multiline support in canvas
* Fixed webfont handling (Chrome)
* Fixed CSS transforms (Chrome)
* Fixed fullscreen stageWidth/stageHeight in DOM mode
* Minor fixes for ExternalInterface
* Added an initial WebGL renderer
* Improved openfl.Vector for older Haxe releases

#### Flash

* Added a non-op userAgent property for compatibility


2.0.0 (05/29/2014)
------------------

#### General

* Implemented support for live asset reloading (desktop)
* Many consistency improvements between target backends
* Combined "openfl-native" and "openfl-html5" into one "openfl" library
* Move from "flash" to "openfl" for all classes
* Improved the behavior of FocusEvent
* Added a new fast Vector implementation
* Added Assets.list

#### Native

* Fixed issues in the Android JNI class
* Added Event.isDefaultPrevented
* Improved the behavior of Event.CHANGE on native
* Fixed focus event behavior

#### HTML5

* Fixed ByteArray embedding in HTML5
* Exposed "openfl.embed" to allow control of HTML5 embeds from JavaScript
* Fixed coordinates reported from HTML5 touch events
* Added support for OpenGLView when targeting HTML5 -Ddom
* Added support for HTML5 "dependencies" to link additional scripts

#### Flash

* Fixed an issue with Stage focus when leaving the Flash preloader


1.4.2 (04/30/2014)
------------------

#### HTML5

* Improved the behavior of "textWidth" and "textHeight" for flash.text.TextField
* Fix for "over bubbling" of certain events
* Implemented "scrollRect" support for DOM (-Ddom) projects
* Fixed cases where world transforms could be invalid when calculating positions and sizes
* Increased caching to change styles less often when using DOM rendering
* Fixed z-ordering for DOM rendered projects
* Optimized flash.display.Graphics to not render when a fill is fully transparent
* Improved HTML text when using DOM renderering
* No longer keep events queue, allow events to dispatch immediately


1.4.1 (04/25/2014)
------------------

#### HTML5

* Improvements to DOM render caching behavior
* Fixed "border" and "background" properties for flash.text.TextField
* Fixed cases where flash.display.Graphics was considered invisible and not rendered
* Improved the behavior of "scrollRect" for flash.display.DisplayObject
* Fixes for alpha fades on flash.display.Sprite or flash.display.Shape "graphics"
* Added openfl.display.DOMSprite
* Implemented support for flash.media.Video
* Implemented better measurement for flash.text.TextField
* Added Event.ADDED and Event.REMOVED events
* Added a much smarter system for managing dirty transforms
* Fixes for flash.display.Graphics lines
* Fix when embedding assets of type "music"
* Implemented flash.ui.Mouse "show" and "hide"
* Fixed a small error in flash.display.BitmapData "copyPixels"


1.4.0 (04/22/2014)
------------------

#### General

* Updated to new OpenFL logo and icon
* Install hxcpp instead of hxlibc during setup

#### Native

* Now openfl.gl.GL accepts both Array<Float> and Float32Array values, where appropriate
* Implemented "cullFace" in openfl.gl.GL, as well as other minor fixes
* Fixed lime_bitmap_data_set_flags to use the right number of parameters
* Fixed a position offset error in openfl.utils.UInt8Array
* Implemented "followRedirects" in flash.net.URLLoader, still true by default
* Implemented "responseHeaders" in flash.net.HTTPStatusEvent
* Set hxcpp critical errors to throw in Haxe instead of stderr in debug builds

#### HTML5

* Fix (possible) infinite loop in flash.display.BitmapData.floodFill
* Fix bounds calculation for display objects
* Added Event.ACTIVATE and Event.DEACTIVATE when leaving/entering window
* Added "copyFrom" and "setTo" for flash.geom.Matrix
* Added "copyFrom" to flash.geom.Rectangle and fixed internal "expand" method
* Copied additional classes from "openfl-html5-dom"
* Changed flash.display.DisplayObject to allow override of more core properties
* Skipped creation of a canvas for flash.display.Graphics with a size of zero
* Improved the "transform.matrix" property for flash.display.DisplayObject
* Created a DOM render path (use -Ddom while compiling or <haxedef name="dom" />)
* Silenced keyLocation warnings on certain browsers
* Toggling canvas smoothing based upon "smoothing" value of flash.display.Bitmap
* Added "unload" to flash.net.Loader and "invalidate" to flash.display.Stage
* Fixed issue when using "drawTiles" with tiles with a width or height <= 0
* Fixed "rect" for flash.display.BitmapData
* Switched from Howler.js to SoundJS for audio backend
* Implemented support for automatically embedding of webfonts
* Disabled "image drag" behavior in Firefox
* Added support for older Haxe releases, tested on Haxe 3.1, possibly compatible with 3.0
* Added Event.ADDED_TO_STAGE event for the document class
* Populating the "content" property of flash.display.Loader
* Added flash.events.FocusEvent support
* Consistency fixes to the event capture/target/bubble implementation
* Fixed bubbling for manually dispatched events
* Made KeyboardEvents dispatch through the currently focused object
* Added initial "scrollRect" support for flash.display.DisplayObject
* Fixed bounds checking for objects that have an alpha of 0 but are visible
* Added initial support for bitmap fill matrix in flash.display.Graphics


1.3.0 (03/18/2014)
------------------

#### General

* Improved the Assets.embedBitmap macro
* Fixed Assets.getBitmapData when the BitmapData was disposed
* Added Firefox OS support

#### Native

* Fixed touch event duplication
* Minor fixes for flash.net.SharedObject
* Added initial stereoscopic 3D support

#### HTML5

* Added a brand-new HTML5 target, too many improvements to list!

#### Flash

* Improved default Flash preloader


1.2.3 (03/04/2014)
------------------

#### General

* Add references for JoystickEvent.DEVICE_ADDED and JoystickEvent.DEVICE_REMOVED
* Add "currentFPS" to openfl.display.FPS
* Add "count" parameter for openfl.display.Tilesheet drawTiles
* Do not add --no-inline to Flash debug builds (this can be added on the command-line)
* Remove custom UInt type, since Haxe 3.1 supports UInt
* Restore Flash UInt types, since Haxe now converts between Int and UInt naturally
* Updated for automated builds: http://openfl.org/builds/openfl

#### Native

* Fix behavior of "removeChildren" in flash.display.DisplayObjectContainer
* flash.filters.GlowFilter no longer extends flash.filters.DropShadowFilter
* Dispatch MouseEvent.MOUSE_OVER/MOUSE_OUT/ROLL_OVER/ROLL_OUT events when using touch as well
* Added support for JoystickEvent.DEVICE_ADDED and JoystickEvent.DEVICE_REMOVED
* Added "setTo" to flash.geom.Rectangle
* Improved working directory behavior in Linux
* Updates to flash.net.XMLSocket
* Improvements to threaded audio behavior
* Added support for Android "immersive mode"
* Fixes to Android joystick handling, supporting newer OUYA gamepad hardware
* Updates to improve support for pre-multiplied alpha
* Improvements to "paletteMap" in flash.display.BitmapData
* Improved Android timing scheme to prevent over-eager render or update calls
* Added "count" parameter to openfl.display.Tileshet drawTiles
* Moved template files to Lime
* Fixed support for "perlinNoise" in flash.display.BitmapData
* Added flash.display.FrameLabel
* Fixes to flash.net.URLLoader


1.2.2 (12/31/2013)
------------------

#### General

* Fixed case where Assets.getMusic could return disposed sound

#### Native

* Minor fix for haxe.Timer
* Minor fix in Android showKeyboard
* Prevented infinite loop in EventDispatcher

#### HTML5

* Improved handling of flash.media.Video
* Minor compile fixes


1.2.1 (12/18/2013)
------------------

#### General

* Merged the "create project" template into OpenFL
* Cleaned up the run scripts to rely upon Lime
* Fix case where Assets.getSound could return disposed sound

#### Native

* Improved handling of haxe.Timer
* Updated for Tizen emulator support

#### HTML5

* Added Rectangle.setTo
* Added DisplayObjectContainer.removeChildren
* Fixed support for GIF images
* Minor compile fixes


1.2.0 (12/10/2013)
------------------

#### General

* Added a new Tizen target
* Added Assets.getMusic

#### Native

* Added support for threaded audio streaming
* Added BitmapData.paletteMap
* Added stage.color
* Fixed case where tiny text rendered improperly
* Fixed issues in openfl.utils.JNI
* Fix to Sound bytesLoaded/bytesTotal
* Fixes for flash.net.Socket
* Minor improvement to Android -debug handling
* Improved support for UncaughtErrorEvent

#### HTML5

* Added Stage.color
* Fixed Bitmap reference optimization
* Fixed ByteArray.writeBytes
* Improved ErrorEvent
* Minor compile fixes


1.1.4 (11/05/2013)
------------------

#### Native

* Improved support for OpenAL audio
* Minor fixes


1.1.3 (11/02/2013)
------------------

#### Native

* Fixed Stage.quality setting
* Add a cap to Android framerate to <= 60 FPS for better performance
* Add hook for GL readPixels
* Fix file boundaries when streaming sound on Android


1.1.2 (10/31/2013)
------------------

#### Native

* Made improvements to typed arrays
* Added DisplayObjectContainer.removeChildren
* Fixed _sans for OS X Mavericks and iOS 7
* Improved handling of unsupported filters


1.1.1 (10/27/2013)
=====

#### Native

* Updated OpenAL for Android
* Fixed OpenAL audio looping
* Added ARMv7 binaries for Android by default

#### HTML5

* Added Matrix3D.copyFrom
* Added GL.getExtension
* Fixed openfl.Assets embedded assets
* Minor fixes


1.1.0 (10/26/2013)
------------------

#### General

* Added a new "asset library" system
* Added Assets isLocal, exists, getPath
* Added Assets loadBitmapData, loadFont, loadSound
* Added Assets loadText, loadBytes
* Added Assets.cache.enabled
* Starting caching fonts and sounds in addition to BitmapData
* Added Tilesheet getTileCenter, getTileRect, getTileUVs
* Improved the "openfl rebuild" command
* Made it easier to override default OpenFL backends
* Added support for middle and right mouse events

#### Native

* Moved to SDL2 and OpenAL on Windows, Mac and Linux
* Moved to OpenAL on Android
* Created a new Android extension system
* Added 64-bit Neko support
* Added additional iOS icon sizes
* Added JNI.createInterface
* Fixed --no-traces on Android
* Fixed NMEFont, renamed to AbstractFont
* Fixed ByteArray.readUTFBytes on Neko
* Made the Android permissions dynamic
* Added a non-op SharedObject.close for compatibility
* Fixed support of dead-code elimination
* Fixes for SoundChannel
* Improved flash.net.Socket
* Fixed target/relatedObject for MOUSE_OVER events
* Added flash.events.UncaughtErrorEvents

#### HTML5

* Added Point.setTo
* Added "target" support in Lib.getURL
* Fixed `<assets path="" embed="true" />`
* Fixed getObjectUnderPoint when using scaled bitmaps
* Fixed SoundChannel Event.SOUND_COMPLETE

#### Flash

* Moved to a standard trace(), removed override


1.0.8 (08/30/2013)
------------------

#### Native

* Improved the behavior of Stage.frameRate for consistency
* Implemented many openfl.utils.JNI improvements
* Improved handling of the iOS status bar


1.0.7
-----

#### Native

* Added flash.net.Socket and flash.net.XMLSocket
* Improved relative path handling on Windows and Linux


1.0.6
-----

#### General

* Improved handling of SWF assets
* Improved API documentation
* Forwarding defines when using "openfl rebuild"
* Improved the FPS counter

#### Native

* Fixed support for Mac64 NDLL type


1.0.5 (07/23/2013)
------------------

#### General

* Added support for overriding target backends

#### Native

* Added Point.setTo
* Added Rectangle copyFrom, toString
* Added Matrix copyFrom, copyRowTo, copyRowFrom
* Added Matrix copyColumnTo, copyColumnFrom, setTo, toString
* Fixed a rare issue in the static initialization order
* Fixed displayObjectContainer.contains
* Improved bitmapData.dispose

#### HTML5

* Improved Lib.getURL
* Fixed loaderInfo.parameters
* Added flash.external.ExternalInterface
* Improved handling of touch and mouse events


1.0.4
-----

#### General

* Fixed handling of UInt type

#### Native

* Added improvements to gamepad support
* Fixed keyboard for Android 2.3

#### HTML5

* Improve mouse and touch event coordinates
* Fix DisplayObjectContainer .visible handling
* Improvements to DisplayObjectContainer behavior
* Improved Graphics.drawRoundRect
* Improved focus and keyboard event handling
* Minor Graphics path fix
* Other minor fixes


1.0.3
-----

#### General

* Improved the "openfl setup" command

#### Native

* Added improvements for OUYA

#### HTML5

* Update x/y values when setting transform matrices
* Fixed recovery from a width and height of zero


1.0.2
-----

#### General

* Fixed handling of inline macros

#### Native

* Fixed default ALT+ENTER behavior on Windows and Linux
* Added joystick support for Android

#### HTML5

* Added ByteArray.toString


1.0.1 (06/19/2013)
------------------

#### General

* Minor code completion fixes

#### HTML5

* Improved handling of applicationDomain


1.0.0 (06/15/2013)
------------------

* Initial release: http://www.openfl.org/blog/2013/07/10/introducing-openfl/

