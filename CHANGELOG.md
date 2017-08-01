6.0.0 (07/31/2017)
------------------

* Removed `openfl.gl` typedefs (use `lime.graphics.opengl`)
* Removed TypedArray typedefs (use types from `lime.utils.*`)
* Added (beta) custom shader support for most basic `DisplayObject` types
* Added (beta) `TileArray` API for `Tilemap` rendering
* Added support for OpenGL hardware `colorTransform`
* Added initial support for JS/HScript frame scripts with SWF content
* Added initial sound exporting to SWF content bundles
* Added blend mode support for canvas, Cairo, and improved GL support
* Added support for skipping rendering if the stage has not changed
* Added support for `Tilemap` OpenGL `colorTransform` and custom shaders
* Made `openfl.utils.ByteArray` use Lime `System.endianness` by default
* Changed the output directory to not include the build type by default
* Improved the quality of `MovieClip` animation rendering
* Improved SWF content to support `visible`, `blendMode` and `cacheAsBitmap`
* Improved documentation to be in Markdown format instead of HTML
* Improved SWF font name matching if font name has no spaces
* Improved support for SWF custom base classes
* Improved support for WebAssembly builds
* Fixed support for `cacheAsBitmap` on HTML5 -Ddom rendering
* Fixed use of `bitmapData.draw` on high-DPI HTML5 -Ddom rendering
* Fixed an issue with some kinds of UTF8 text input
* Fixed sorting of event listeners to preserve order if priority is equal
* Fixed rendering of `SimpleButton` on HTML5 -Ddom mode
* Fixed use of insecure WebSocket protocol on https:// sites
* Fixed unknown file extension in generated SWF content with some servers
* Fixed rendering of `stage3D.x`/`stage3D.y` when using a scissor
* Fixed caret not rendering on Cairo when `textField.text` is empty
* Fixed rendering issue on Chrome when resizing canvas in -Ddom mode
* Fixed compilation in JavaScript -Dmodular builds


5.1.5 (06/21/2017)
------------------

* Fixed regression where `loader.unload()` set `contentLoaderInfo` to `null`
* Fixed possible build error in URLLoader


5.1.4 (06/20/2017)
------------------

* Deprecated `handler` callbacks in `openfl.utils.Assets.load*` methods
* Improved the leading of embedded SWF fonts on native
* Improved `addChild` to throw an error when adding a `null` child
* Improved loaded asset libraries to register using `loaderURL` as the name
* Improved the behavior of `ExternalInterface` when errors are thrown
* Improved the behavior of mitered lines in vector shapes
* Improved support for the `rcp` command in AGAL
* Fixed the canvas shape renderer to use even/odd winding like Cairo
* Fixed support for `SimpleButton` rendering in regression cases
* Fixed cases where `Loader.content`/`LoaderInfo.content` were not set
* Fixed an incorrect input buffer position in `openfl.net.Socket`
* Fixed `Socket` to report as not connected immediately on `close()`
* Fixed `opaqueBackground` rendering for `Tilemap`
* Fixed dispatching of `HTTPStatusEvent` from `openfl.net.URLLoader`
* Fixed a case where `Capabilities.screenDPI` could have a `null` error


5.1.3 (06/07/2017)
------------------

* Added `lime.text.UTF8String` internally to improve UTF-8 support
* Improved `XMLSocket` to use `Socket` internally for better support
* Improved the performance of -Dopenfl-disable-graphics-upscaling
* Improved sharpness of text when rendering on HTML5 -Ddom
* Improved support for ATF textures in Stage3D
* Improved internal code to reduce recurrent GC activity
* Improved ByteArray to allow conversion (with position) to BytePointer
* Fixed regressions in rendering `SimpleButton` objects
* Fixed some cases of `<font size="" />` in `textField.htmlText`
* Fixed crash when attempting to attach a null `NetStream` to `Video`
* Fixed support for specific cross-origin requests in HTML5 -Ddom
* Fixed support for Stage3D on HTML5 -Ddom
* Fixed support for cacheAsBitmap on HTML5 -Ddom
* Fixed regression in bounds calculation for some display objects
* Fixed setting `Shader.glVertexSource`
* Fixed support for current Haxe development builds


5.1.2 (05/23/2017)
------------------

* Revert wildcard Lime dependency until it is more stable
* Fixed deprecation of DOMSprite and OpenGLView
* Fixed cacheAsBitmap when making certain visual changes


5.1.1 (05/20/2017)
------------------

* Fixed regression causing incorrect internal bounds calculation
* Fixed an issue compiling `openfl display flash` output
* Fixed regression in path resolution for SWF library handler tools


5.1.0 (05/19/2017)
------------------

* Updated for Lime 5
* Added openfl.text.StaticText (used in SWF assets)
* Added openfl.display.AVM1Movie for better compatibility with Flash
* Added initial support for DisplayObject cacheAsBitmap
* Added support for DisplayObject colorTransform using cacheAsBitmap
* Added support for graphicsPath.cubicCurveTo
* Improved support for graphics.readGraphicsData/drawGraphicsData
* Improved behavior of Stage3D mipmap filtering
* Deprecated openfl.gl.\* types (use lime.graphics.opengl.\*)
* Deprecated openfl.utils.\* typed arrays (use lime.utils.\*)
* Fixed clipping in graphics.cubicCurveTo
* Fixed an issue compiling the output of `openfl display`
* Fixed support for `<window always-on-top="true" />` in template
* Fixed support for synchronous BitmapData.fromBytes on native
* Fixed support for Stage3D on HTML5 DOM target


5.0.0 (05/04/2017)
------------------

* Removed old preloader support (use new preloader format)
* Removed callback in BitmapData.fromBase64 (use .loadFromBase64)
* Removed callback in BitmapData.fromBytes (use .loadFromBytes)
* Removed callbacks in BitmapData.fromFile (use .loadFromFile)
* Removed unused parameter in sound.loadCompressedDataFromByteArray
* Removed openfl.embed support in HTML template (use lime.embed)
* Removed bundled import of asset classes (use openfl.utils.\*)
* Added initial support for compressed Stage3D textures
* Added initial support for Adobe Texture Format in Stage3D
* Added support for GraphicsTrianglePath
* Added support for graphics.drawRoundRectComplex
* Added support for MovieClip.isPlaying
* Added capture phase to Event.ADDED and Event.REMOVED_FROM_STAGE
* Improved alignment and layout grouping in TextField
* Improved the behavior of GraphicsPath
* Improved openfl.display.Shader to optimize better in JavaScript
* Improved behavior of bitmapData.drawWithQuality using StageQuality.LOW
* Improved the behavior of inherited blend modes
* Improved the behavior of Stage3D mipmap filter smoothing
* Improved the way uncaught errors are reported on iOS
* Improved ByteArray to convert to a DataPointer with position preserved
* Improved performance of byteArray.writeFloat when LITTLE_ENDIAN
* Improved vector.toString on Flash to be consistent with other targets
* Improved Vector.reverse to have the correct return type
* Fixed conversion of null openfl.Vector to String
* Fixed inclusion of alpha images in SWF exporter tool
* Fixed some cases where width or height of a Shape was incorrect
* Fixed performance regression when using Stage3D in release
* Fixed binary size of SWF tools to support older Neko releases
* Fixed an issue using Dictionary in some circumstances on HTML5
* Fixed code completion issue when referencing RenderSession
* Fixed static initialization order of CFFI methods


4.9.2 (03/28/2017)
------------------

* Implemented Context3D.drawToBitmapData
* Improved support for embedded SWF libraries on Flash
* Fixed a regression in render-to-texture support with Context3D
* Fixed a minor issue when using OpenFL with Raspberry Pi
* Fixed support for Assets.getBitmapData from a SWF library
* Fixed support for Sound.loadPCMFromByteArray


4.9.1 (03/17/2017)
------------------

* Updated additional classes to build for release
* Fixed a performance regression in Cairo TextField rendering
* Fixed VertexBuffer3D uploadFromVector to generate less GC activity
* Fixed double loading of SWFLite data


4.9.0 (03/15/2017)
------------------

* Updated for Lime 4
* Added initial support for `openfl process` for SWF-based assets
* Added support for loading generated SWFLite bundles in Loader
* Added support for multiple HTML5 embeds on the same page
* Added support for loaderInfo.parameters through the HTML5 embed
* Added support for TextField restrict and maxChars
* Added support for Float-based keys in Dictionary
* Added a hack to add stroke support for TextField
* Improved support for Lime asset manifests in SWF library
* Improved template behavior to work if Lime is included before OpenFL
* Improved the behavior of TextField setTextFormat/replaceText
* Improved support for String-based messages in HTML5 Socket
* Improved support for non-smoothed bitmapData in SWF libraries
* Improved "missing font" warning to only occur once per font name
* Improved "asset not found" warnings to throw errors
* Improved animated mask support in MovieClip
* Fixed support for embedded SWF libraries on Flash
* Fixed the array count calculation in AGAL to GLSL conversion
* Fixed support for CubeTexture in Stage3D renderToTexture
* Fixed the reset position after using byteArray.uncompress
* Fixed a type-cast error when retrieving a missing MovieClip asset
* Fixed a possible bug when rendering an object with no parent
* Fixed wrongful error on Stage3D viewport on OS X
* Fixed cases where stage3D x/y is set before a backbuffer is created
* Fixed support for GL context loss


4.8.1 (02/15/2017)
------------------

* Implemented sound.loadPCMFromByteArray
* Improved behavior of sound.loadCompressedDataFromByteArray
* Fixed version check when running `openfl upgrade`
* Fixed loading cross-domain images on HTML5 without using CORS
* Fixed regressions caused by non-rounded Cairo TextField rendering


4.8.0 (02/13/2017)
------------------

* Added Tile originX/originY
* Added support for Stage3D CubeTexture
* Added `dictionary.each()` to iterate through values
* Added anisotropic filtering modes to Stage3D
* Added initial support for links in TextField
* Disabled pixel rounding by default (fixes flicker issues)
* Improved the quality of the AGALMiniAssembler port
* Improved support for TextField on HTML5 -Ddom
* Improved ExternalInterface to support closures on HTML5
* Improved Loader to better support URLRequest parameters
* Fixed the behavior of bitmapData.hitTest alpha threshold values
* Fixed issue where Matrix3D did not clone data in the constructor
* Fixed Stage3D depth clear when depth mask is disabled
* Fixed the behavior of Stage3D mipmapping
* Fixed hit testing behavior when Bitmap has a scrollRect
* Fixed regressions in Haxe Scout support
* Fixed sync between Flash Tilemap rendering and other DisplayObjects
* Fixed issue with incorrect GLSL version on AGAL converted shaders
* Fixed support for AVM1Movie in SWF library on Flash target
* Fixed culling on when using Stage3D render-to-texture
* Fixed default filename in FileReference dialogs
* Fixed support for multiple filters on the same object
* Fixed shape.graphics line paths in some instances


4.7.3 (01/26/2017)
------------------

* Improved Capabilities to more closely approximate Flash's behavior
* Improved the density of projects targeting HTML5 with high DPI
* Fixed a regression in the calculation of textField.textWidth
* Fixed ExternalInterface.available to return false on native 
* Fixed the visibility of hit-testing on HTML5


4.7.2 (01/25/2017)
------------------

* Fixed incorrect casing (fullscreenWidth should be fullScreenWidth)


4.7.1 (01/25/2017)
------------------

* Improved stage ACTIVATE/DEACTIVATE to be more consistent with Flash
* Improved code completion on the Flash target when using FlashDevelop
* Improved the code output size when targeting HTML5 
* Fixed hiding of stack trace when errors occur in a custom preloader
* Fixed possible cases where stage.x/y and other transforms could be changed
* Fixed support for scale and letterboxing on native targets
* Fixed use of scaleX/scaleY when dead-code elimination is enabled


4.7.0 (01/24/2017)
------------------

* Added support for high-DPI HTML5 output
* Added BitmapData.loadFromBase64/loadFromBytes/loadFromFile
* Added handling for UP/DOWN/HOME/END keyboard shortcuts in TextField
* Added stage.fullscreenWidth/fullscreenHeight
* Added support for Lime 3.7 simulated preloader progress
* Improved selection of multi-line text in TextField
* Improved the behavior of bitmapData.paletteMap
* Improved text measurement for HTML5 input TextField
* Improved sharpness of HTML5 vector shape rendering
* Deprecated async callbacks in BitmapData.fromBase64/fromBytes/fromFile
* Fixed support for the "rect" argument in bitmapData.encode
* Fixed use of textField.setTextFormat when text is empty
* Fixed support for openfl.printing.PrintJob on Flash Player
* Fixed support for SWF-based assets on iOS and Flash
* Fixed use of deprecated NMEPreloader class
* Fixed use of font names on HTML5 that may already be quoted


4.6.0 (01/20/2017)
------------------

* Added (initial) support for openfl.printing.PrintJob on HTML5
* Added a stub for stage.softKeyboardRect to fix compilation
* Made stageWidth and stageHeight read-only on Flash target
* Updated AGALMiniAssembler to a newer release from the Gaming SDK
* Improved rendering for multi-line text selections
* Changed the default font hint style to something more subtle
* Fixed some cases where textField.getCharIndex would work improperly
* Fixed issues where tile.rotation resulted in flipped objects
* Fixed problems with scaleX, scaleY and rotation interacting improperly


4.5.3 (01/16/2017)
------------------

* Updated for Lime 3.6
* Updated AGALMiniAssembler to a fresh port of Adobe's last release
* Added missing Event.FRAME_CONSTRUCTED event
* Added `Dictionary<Object, Object>` support
* Improved support for textField.setTextFormat
* Updated preloader to use Event.UNLOAD instead of Event.COMPLETE to unload
* Updated SWFLite library to preload with the parent application
* Fixed support for slashes in SharedObject names
* Fixed support for preventing default on keyboard events
* Fixed a regression in displaying stack traces on crash errors
* Fixed text measurement on IE 11
* Fixed return value when scaleX or scaleY is negative
* Fixed issues where `new ByteArray` may have values other than zero 
* Fixed an issue with SWFLite assets when using the "generate" option
* Fixed a possible null crash when updating object transforms
* Fixed support for garbage collecting Sound when SoundChannel is finished
* Fixed problems with using textField.appendText
* Fixed the default template for HTML5 when multiple projects are embedded
* Fixed wrong colors when values were larger than expected
* Fixed an issue with needing clearRect on CocoonJS


4.5.2 (12/19/2016)
------------------

* Added sprite.dropTarget
* Improved dispatch of stage ACTIVATE/DEACTIVATE on desktop
* Fixed issues related to @:bitmap, @:file and @:sound
* Fixed issues when marking SWF libraries as embedded
* Fixed an error when compiling to HTML5 -Ddom


4.5.1 (12/16/2016)
------------------

* Revised the custom preloader system to use an ordinary Sprite
* Preloader Sprites now receives PROGRESS events and a cancelable COMPLETE
* Improved SWF-based assets to use self-contained asset libraries
* Removed support for `new Vector<T> ([])` as it breaks on C++
* Improved C++ performance on debug builds, added -Dopenfl-debug
* Fixed support for custom preloaders on the Flash target
* Fixed issues with hit testing on scaled vector graphics
* Fixed hit testing for Video objects and some other hit test issues
* Fixed support for centered SWF-based text
* Fixed file-type detection in Loader when using a query string
* Fixed support for single-pass custom shader filters
* Fixed the initial scale for high DPI windows on OpenGL rendering
* Fixed the position of touch events on high DPI windows
* Fixed creation of framebuffers if filters are not used
* Fixed a regression in shape.graphics quality


4.5.0 (12/07/2016)
------------------

* Merged the "swf" library into OpenFL
* Enabled "strict mode" by default (MovieClip and Event are not Dynamic)
* Context3D is now automatically initialized on OpenGL targets
* Added tools for support of SWF assets
* Added core support for SWF-based symbols
* Added performance optimizations for SWF-based bitmaps
* Added optimizations when objects are re-used during timeline animation
* Added support for custom Haxe base classes from Adobe Animate
* Added support for the `visible` property from Adobe Animate
* Added support for input TextFields from Adobe Animate
* Added support for dynamic child access using -Dopenfl-dynamic
* Added bitmapData.disposeImage() to reduce memory use (beta)
* Added bitmapData.readable for GPU-only BitmapData (beta)
* Added BitmapData.fromTexture() for render-to-texture (experimental)
* Added framebuffer-based bitmapData.draw and fillRect (experimental)
* Added stage.showDefaultContextMenu and implemented for HTML5
* Added a 32 SoundChannel limit (similar to Flash) for better performance
* Added `new Vector([1, 2, 3])` (to approximate `<Vector>[1, 2, 3]`)
* Added initial support for runtime JS script loading
* Added "select all" keyboard shortcut support to TextField
* Added initial support for BlurFilter
* Added support for filters on display object containers
* Updated openfl.Lib.getURL use lime.system.System.openURL
* Updated openfl.net.URLLoader to use lime.net.HTTPRequest
* Updated tilemap width/height to behave similar to TextField
* Improved the behavior of SWF-based library preloading
* Improved SWF class generation to use more exact types
* Improved the behavior of displayObject.loaderInfo
* Improved the behavior of premultiplied alpha on HTML5
* Improved the performance of -Ddom when using canvas-based bitmaps
* Improved support for UncaughtErrorEvents
* Fixed the calculation of textField.bounds
* Fixed an issue in Stage3D that caused flickering in Away3D samples
* Fixed the position of shape.graphics when using bitmapData.draw
* Fixed hit testing for scaled shape.graphics on HTML5
* Fixed repeated dispatching of Event.CONTEXT3D_CREATE
* Fixed support for Stage3D empty textures
* Fixed an issue with document classes extending starling.display.Sprite
* Fixed hit testing on bitmapFill shapes
* Fixed an issue with keyboard shortcut support on TextField for macOS
* Fixed the size of video playback on WebGL
* Fixed hitting the enter key on a single-line TextField
* Fixed optional argument in bitmapData.encode
* Fixed behavior of the border property on SWF-based TextFields
* Fixed support for copy-and-paste on HTML5
* Fixed a crash issue when using Stage3D shaders on macOS
* Fixed the behavior of textField width/height when scaled
* Fixed ByteArray.writeFloat on Neko
* Fixed a minor issue when removing event listeners while dispatching
* Fixed some glyphs that disappeared when using textField.htmlText
* Fixed an issue that could cause textFields to disappear when scaled
* Fixed support for using Class as a key type for openfl.utils.Dictionary
* Fixed support for scaled shape.graphics on -Ddom
* Fixed the position of shape.graphics on -Ddom
* Fixed support for SimpleButton on -Ddom
* Fixed some issues with TextField on -Ddom
* Fixed support for scrollRect on -Ddom
* Fixed sprite.visible support on -Ddom
* Fixed hiding of mask objects on -Ddom


4.4.1 (11/01/2016)
------------------

* Added support for the "ignoresampler" AGAL sampler hint
* Improved the behavior of context3D.setSamplerState
* Minor change to better support Lime `onPreloadComplete` event
* Fixed visibility of TextField cursor on a final blank line
* Fixed a possible null error in EventDispatcher
* Fixed support for -Dmodular


4.4.0 (10/31/2016)
------------------

* Added initial support for modular HTML5 builds (generates separate openfl.js)
* Added initial support for VideoTexture in HTML5 Stage3D
* Added initial high-DPI support for HTML5
* Added an error when using a non-matching Lime version
* Updated several fields with typed values for better performance
* Updated event.target and event.currentTarget to be IEventDispatcher
* Updated shaders to use premultiplied alpha blend mode by default
* Improved behavior of non-renderable TextFields
* Improved support for mipmapping in Stage3D Texture
* Improved the behavior of graphics.drawTriangles
* Improved re-entrant behavior in EventDispatcher
* Improved removeEventListener when called during the same event dispatch
* Improved premultiplied alpha in Stage3D textures
* Improved the preloader system (deprecated NMEPreloader)
* Fixed support for smoothing within sprite.graphics
* Fixed dead-code-elimination when using a static main entry point
* Fixed dispatch of Context3D creation error where Stage3D is not supported
* Fixed sound.length on HTML5
* Fixed support for using the same listener with multiple event phases
* Fixed some issues with event bubbling
* Fixed some issues with TextField caret positioning
* Fixed BIG_ENDIAN support in ByteArray
* Fixed use of ColorMatrixFilter on Flash
* Fixed some issues with -Ddom OpenGL context creation


4.3.1 (10/13/2016)
------------------

* Added basic support for bitmapData.perlinNoise
* Added initial support for `<textformat>` in TextField htmlText
* Improved the behavior of premultiplied alpha on HTML5
* Optimized addChild/addChildAt if child remains at the same depth
* Optimized conversion of Image to Canvas in some cases
* Fixed an issue with cached scissor rectangles in Stage3D
* Fixed htmlText parsing when attributes use single quotes
* Fixed a rendering issue where changing text format could omit one letter
* Fixed the default GL min filter value for Stage3D samplers
* Fixed an GL error caused by switching Stage3D and display list shaders


4.3.0 (10/10/2016)
------------------

* Added support for ColorMatrixFilter and ConvolutionFilter
* Added support for custom shaders with additional uniforms/samplers
* Added ByteArray.fromFile and improved conversion from null values
* Added support for rounding coordinates in the GL renderer
* Updated Sound to rely only on lime.sound.AudioSource
* Updated Capabilities.language to use lime.system.Locale
* Updated HTML5 templates for favicon support
* Updated Flash web template to enable Stage3D support
* Improved the behavior of displayAsPassword input text
* Improved the behavior of Tile rotation
* Improved Graphics to be more efficient with garbage collection
* Improved the behavior of touch events
* Improved use of "-lib openfl" from plain HXML
* Implemented hitTestPoint with shapeFlag
* Fixed width and height values when scaleX or scaleY is negative
* Fixed set of stageX and stageY when dispatching a custom MouseEvent
* Fixed Tilemap smoothing on Flash
* Fixed TextField auto-size remaining too small and cropping text
* Fixed the return value of Multitouch.supportsTouchEvents on macOS
* Fixed retained references after changing stage.focus
* Fixed the "target" field of mouse wheel events
* Fixed unregistration of sound channels when complete
* Fixed display of TextField caret when no text has been entered yet
* Fixed support for AGAL shader sampler states
* Fixed drawTriangles support for HTML5
* Fixed rendering of Graphics with negative scale values
* Fixed Assets.loadBytes to always return a lime.app.Future
* Fixed the behavior of -Dopenfl-disable-graphics-upscaling
* Fixed Tilemap width/height to reflect the scaled value
* Fixed some issues with scaled Cairo and Canvas Tilemap rendering
* Fixed soundChannel.position on native platforms
* Fixed support for `openfl create <lib>`


4.2.0 (09/19/2016)
------------------

* Rewrote support for scrollRect
* Added support for disabling smoothing using StageQuality.LOW
* Added initial changes to support the C# target
* Added support for ROLL_OVER/ROLL_OUT events
* Added tileset.clone
* Implemented support for opaqueBackground
* Cleaned up the renderer with GC optimizations
* Updated Capabilities.language to use lime.system.Locale
* Updated iOS templates for Xcode 8
* Improved Tilemap rendering and consistency
* Improved support for high-DPI windowing
* Improved support for disabled smoothing throughout the renderer
* Improved the behavior of MOUSE_OVER/MOUSE_OUT events
* Improved the removal of items from the openfl.Assets cache
* Improved stage.focus when the object of focus has been removed
* Improved bitmap.bitmapData to set smoothing to false (like Flash)
* Improved Utils3D.projectVectors
* Fixed bitmapData.draw when using colorTransform on canvas
* Fixed coordinate calculation for some off-stage objects
* Fixed an issue when resizing object vectors


4.1.0 (08/29/2016)
------------------

* Added new Stage3D code migrated from the (now defunct) PlayScript project
* Added support for ENTER_FRAME, EXIT_FRAME and RENDER if not on the stage
* Added openfl.ui.MouseCursor and Mouse.cursor support
* Made minor changes to read-only getter properties to reduce code
* Added to/from UInt conversion for standard enum types
* Added duration to HTML5 NetStream onMetaData object
* Added vector.insertAt
* Added dictionary.exists
* Improved stroking in graphics API
* Improved openfl.Vector for better accuracy/performance
* Fixed the order of ADDED and ADDED_TO_STAGE events
* Fixed the behavior of vector.concat with no arguments
* Fixed netStream.seek on HTML5
* Fixed Capabilities.screenResolutionY
* Fixed an issue with HTML5 shape positioning


4.0.3 (07/27/2016)
------------------

* Added openfl.media.SoundMixer
* Added Utils3D.projectVectors
* Added sprite.stopAllMovieClips
* Added bitmapData.drawWithQuality
* Added some support for graphics.readGraphicsData
* Improved support for Matrix3D appendRotation/prependRotation
* Fixed a crash regression on current-generation Android devices


4.0.2 (07/22/2016)
------------------

* Improved the behavior of Tilemap on the GL renderer
* Improved the behavior of stage focus events when leaving the window
* Fixed support for ByteArray deflate/inflate
* Fixed support for increasing ByteArray size using array access
* Fixed an issue where netStream.time was not updated on HTML5 video


4.0.1 (07/20/2016)
------------------

* Added mixing of tilesets in Tilemap, removed TilemapLayer
* Added support for tile.alpha and tile.visible in Tilemap
* Added dictionary.remove to allow deletion of keys
* Implemented Tilemap support in Cairo and DOM renderers
* Added -Dopenfl-disable-graphics-upscaling
* Updated extern enum types for Flash and native
* Minor fix to GL masking


4.0.0 (07/08/2016)
------------------

* Rewrote the OpenGL renderer for simplicity and performance
* Implemented WebGL as the default on HTML5, -Dcanvas/-Ddom still available
* Implemented upscaling in openfl.display.Graphics for better visual quality
* Committed to official support of Stage3D, initial work to conform to API
* Reduced the memory use of off-screen display list objects
* Removed the legacy OpenFL 2.x backend
* Added support for letterboxing when window.resizable = false on mobile
* Added improved Tilemap support, currently in beta
* Added Event.EXIT_FRAME and Event.FULLSCREEN events
* Added m4a support to HTML5
* Added support for ShaderFilter on Bitmap, TextField and Tilemap
* Updated the Tilemap API with scale, rotation and transform support
* Updated the BitmapData class to better handle WebGL
* Improved support for textField.htmlText
* Improved support for scrollRects
* Improved the behavior of SimpleButton events and alpha
* Improved code completion support
* Fixed the default Windows serif bold font path
* Fixed issues with bitmapData draw and copyPixels
* Many other minor fixes


3.6.1 (03/28/2016)
------------------

* Updated for Haxe 3.3.0
* Updated for Lime 2.9.1
* Improved Tilemap for standard support across all renderers
* Merged latest improvements to Stage3D compatibility
* Merged latest console renderer improvements
* Improved the behavior of sprite.hitArea
* Improved stageWidth/stageHeight to update after fullscreen
* Reduced the standard output size of HTML5 builds
* Fixed issues compiling for Flash
* Fixed assignment of Loader.contentType
* Fixed some minor crash issues with cacheAsBitmap
* Added textField.length (legacy)
* Fixed an issue with SystemPath (legacy)


3.6.0 (01/22/2016)
------------------

* Moved to a standard abstract enum style for all core enums
* Moved to inlining on all core constant values (for Haxe 3.3)
* Moved to no-inlining on all core methods (reflection support)
* Standardized the signature of Graphics to be more consistent
* Added support for using a custom backends with an external target
* Added a COMPLETE event to FileReference when choosing a file
* Added TextFormatAlign START and END support to TextField
* Added color offset support to native drawTiles
* Improved the handling of stage.displayState on window changes
* Improved how core externs are imported to not require a macro
* Improved the behavior of CLICK to occur only on the same target object
* Improved the behavior of SimpleButton to ignore "drag over" actions
* Improved support for custom backends that do not use Lime
* Improved the behavior of BitmapData.threshold
* Improved how video width and height are calculated on HTML5
* Improved handling of pixel format for Stage3D
* Fixed the behavior of byteArray.bytesAvailable
* Fixed the extern for PNGEncoderOptions on Flash
* Fixed a possible crash when editing TextField htmlText
* Fixed a crash when using an empty net stream in Video
* Fixed a crash when using graphics.copyFrom with an empty target object
* Fixed some minor issues in URLLoader


3.5.3 (12/16/2015)
------------------

* Improved the extern definitions for Flash
* Moved fullscreen / back button key shortcut behaviors to Lime
* Retained canvas as default HTML5 renderer on current Lime
* Improved look-up for default iOS font paths
* Minor compile fixes


3.5.2 (12/11/2015)
------------------

* Formalized the extern classes more, fixed some Flash behaviors
* Improved the standard HTML5 template for `<window resizable="false" />`
* Fixed the use of binary request data in HTML5 URLLoaders
* Improved compatibility for ByteArrayData (legacy)


3.5.1 (12/09/2015)
------------------

* Improved the behavior of GameInput.getDeviceAt
* Updated GameInputDevice.id to be a GUID, not an internal index value
* Fixed a minor issue in ApplicationDomain.getDefinition
* Fixed "haxelib run openfl setup" when Lime is not installed


3.5.0 (12/07/2015)
------------------

* ByteArray is now abstract -- supports array access and to/from Bytes
* Improved openfl.utils.Object to support array access and for loops
* The Haxe externs for Flash target classes are now integrated/unified
* Multiple inconsistencies with Flash have been resolved
* Implemented initial support for sprite.hitArea
* Re-wrote SimpleButton with more accurate API support
* Repeated SharedObject "get" calls now return the same instance
* Minor improvements to the Stage3D compatibility layer
* Fixed incorrect hit testing with touch events
* Fixed a premature start in projects that use only SWF libraries
* Fixed a regression with graphics.cubicCurveTo support
* Fixed the Tilesheet bounds calculation when TILE_TRANS_2x2 is used
* -Dtelemetry now enables HxScout support on Neko as well
* Ported behavior from legacy for native XMLSocket support


3.4.0 (10/28/2015)
------------------

* Fixed behavior of fillRect without alpha on non-transparent bitmapData
* Fixed behavior of getColorBoundsRect on non-transparent bitmapData
* Fixed red/blue color regression in some instances
* Fixed transforms when using bitmapData.draw
* Fixed support for Lime window scale (used on Mac retina)
* Fixed a crash in Cairo rendering for near-zero dimensions
* Fixed a null rect issue in OpenGL graphics drawTiles
* Fixed access to System.totalMemory on HTML5
* Fixed reference for default Noto Android font
* Minor fixes for better scrollRect support 


3.3.9 (10/15/2015)
------------------

* Preliminary support for custom DisplayObject shaders and filters on GL
* Added support for netStream.close on HTML5
* Fixed an issue where URLLoader would fail when there is no return data
* Fixed an issue using bitmapData.fillRect and an invisible fill color
* Fixed an issue with invisible images appearing on hit testing
* Fixed native URLLoader requests to follow HTTP redirects
* Fixed an issue with remote Loader requests on native


3.3.8 (10/05/2015)
------------------

* Updated for new Lime Joystick support
* Updated to allow SWFLite frame-rate independent MovieClips
* Added MovieClip addFrameScript
* Improved the behavior of SimpleButton
* Improved the behavior of getObjectsUnderPoint


3.3.7 (10/02/2015)
------------------

* Added support for object.FirstChild.SecondChild dynamic reference
* Added FullScreenEvent for when the fullscreen status changes
* Added minor tweaks to support Apple tvOS
* Removed JoystickEvent (still available on legacy)
* Improved the behavior of colorTransform concat
* Improved openfl.utils.Object for better compatibility
* Fixed a regression in reading values for graphics.lineBitmapStyle
* Fixed displayObject mouseX/mouseY values when object not on stage
* Fixed an edge case with bitmapData.getColorBoundsRect for 0 alpha
* Fixed the position offset in graphics drawTiles on HTML5


3.3.6 (09/23/2015)
------------------

* Updated for Lime 2.6.5 changes
* Changed gradient style to use Array<Int> for ratio, not Float
* Improved quality of joint style for closed paths
* Fixed use of deprecated Assets.load syntax (without using futures)


3.3.5 (09/21/2015)
------------------

* Improved support for native URLLoader binary data
* Improved support for native URLLoader GET/POST
* Improved hit testing against certain invisible shapes
* Added a "resolve" method to MovieClip to improve dynamic use
* Fixed some issues with improper positioning of Graphics
* Reduced "unreachable code" warnings in Firefox
* Fixed alpha blending on iOS


3.3.4 (09/19/2015)
------------------

* Improved the calculation of object bounds
* Improved the quality of OpenGL scrollRect support
* Added auto-saving of SharedObject instances on exit
* Improved bounds calculations when using a miter joint
* Improved support for TextField wordWrap
* Fixed cases where invisible shapes took rendering time
* Fixed support for lineStyle widths of zero
* Added missing methods and properties for openfl.net.SharedObject
* Added Lime 2 accelerometer compatibility
* Integrated new improvements to the Stage3D context
* Added bounds calculation to drawTiles calls
* Added support for colorTransform when using bitmapData.draw
* Improved drawTiles on HTML5 to avoid an intermediate canvas element
* Fixed some strange issues that occurred with invisible Graphics
* Fixed an issue that prevented SWF assets from working on Flash
* Made the Android back button move to background by default
* Fixed a minor issue in TextField.getLineIndexAtPoint
* Fixed a minor issue in TextField.getCharIndexAtPoint
* Fixed issues that caused BitmapData to cache pixels too long
* Fixed sound transform balance on HTML5 (some browsers)
* Improved the Event.ADDED/REMOVED events
* Began to implement a new "Tilemap" API
* Reduced allocations made in the Graphics and TextField classes


3.3.3 (09/08/2015)
------------------

* Updated the DisplayObject matrix transform code
* Improved openfl.Assets load calls to return Futures
* Updated for the current Lime release
* Improved URI support in the Socket implementation
* Improved support for ctrlKey/controlKey in KeyboardEvent
* Fixed black OpenGL textures on some devices
* Implemented Capabilities.totalMemory
* Added guards against potential null references (legacy)


3.3.2 (08/26/2015)
------------------

* Renamed bitmapData.__image to image, made it public
* Added FileReference and FileReferenceList
* Added proper shapeFlag support for graphic hit test
* Added bitmapData.compare
* Added clipRect support in bitmapData.draw
* Improved hit testing of masked objects
* Reduced allocations made in graphics render
* Fixed bounds check when object is not visible
* Fixed return value of displayObject.globalToLocal
* Fixed URLLoader to return on the correct thread
* Fixed render update handling in transform.colorTransform
* Fixed calculation of textHeight with negative leading
* Fixed bitmapData.getColorBoundsRect
* Fixed support for scrollRect on bitmaps
* Fixed support for -Dtelemetry builds
* Fixed some issues when setting transform.matrix
* Fixed some issues with scrollRect
* Fixed regression in disabling smoothing on Firefox
* Fixed canvas mask support for drawRoundRect
* Fixed Event.ADDED_TO_STAGE order (legacy)
* Fixed missing callback in Assets.loadLibrary (legacy)


3.3.1 (08/20/2015)
------------------

* Added support for multiple windows
* Updated for Lime 2.6
* Made continued improvements to the TextField implementation
* Improved the rendering of pixel-based fonts
* Fixed edge cases in text selection and replacement
* Fixed support for multiple input text fields
* Improved support for tabEnabled and stage.focus
* Improved support for DOM input text
* Restored SharedObject support
* Added stage.application and OpenFL Application/Window classes
* Improved hit testing for Graphics shapes
* Made the DEACTIVATE event more consistent when exiting
* Fixed support for eventDispatcher.hasEventListener in some cases


3.3.0 (08/13/2015)
------------------

* Brand-new, heavily improved TextField implementation
* Greatly increased the accuracy of TextField rendering
* Implemented all missing TextField methods
* Added text input support for native
* Added openfl.desktop.Clipboard
* Improved hit test support
* Reduced allocations for better GC (thanks HxScout!)
* Made final classes @:final to improve consistency
* Added support for bitmapData.hitTest
* Added support for graphics.drawGraphicsData
* Added support for <config:hxtelemetry port="" allocations="" />
* Added stage.window for access to the parent Lime window
* Implemented Capabilities screenResolutionX/screenResolutionY
* Improved default font handling on Linux
* Fixed event.target for manual dispatchEvent calls
* Fixed local Loader/URLLoader calls that have GET parameters
* Fixed support for Font.enumerateFonts


3.2.2 (07/23/2015)
------------------

* Improved the accuracy of bitmapData.threshold
* Minor improvements to Cairo rendering
* Fixed an issue where Bitmap objects could stop scaling 
* Fixed possible infinite event dispatch loop


3.2.1 (07/22/2015)
------------------

* Updated OpenGLView.isSupported to report false in single canvas mode 
* Fixed a memory leak when using _sans, _serif and _typewriter fonts
* Fixed possible black texture issue on some platforms
* Fixed regression in bitmapData.draw


3.2.0 (07/21/2015)
------------------

* Moved BitmapData to premultiplied BGRA instead of unmultiplied RGBA
* Drastically improved performance of bitmapData.draw
* Reverted scrollRect/transform change from 3.1.2
* Improved support for both local/remote assets in Loader/URLLoader


3.1.4 (07/17/2015)
------------------

* Updated for Lime 2.5 support
* Changed bitmapData.draw to use Cairo/canvas instead of GL.readPixels
* Improved support for GameInput APIs
* Fixed some regressions in world matrix transform calculation
* Made minor improvements to Cairo text leading
* Fixed an issue with repeated bitmapData.draw calls using a matrix
* Fixed a bug that could occur when using <library preload="true" />


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

