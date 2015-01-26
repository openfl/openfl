package openfl._v2; #if lime_legacy
#if !macro


import haxe.Json;
import haxe.Unserializer;
import openfl.display.Bitmap;
import openfl.display.BitmapData;
import openfl.display.MovieClip;
import openfl.events.Event;
import openfl.events.EventDispatcher;
import openfl.media.Sound;
import openfl.net.URLRequest;
import openfl.text.Font;
import openfl.utils.ByteArray;

@:access(openfl._v2.AssetLibrary)
@:access(openfl._v2.display.BitmapData)

/**
 * <p>The Assets class provides a cross-platform interface to access 
 * embedded images, fonts, sounds and other resource files.</p>
 * 
 * <p>The contents are populated automatically when an application
 * is compiled using the OpenFL command-line tools, based on the
 * contents of the *.nmml project file.</p>
 * 
 * <p>For most platforms, the assets are included in the same directory
 * or package as the application, and the paths are handled
 * automatically. For web content, the assets are preloaded before
 * the start of the rest of the application. You can customize the 
 * preloader by extending the <code>NMEPreloader</code> class,
 * and specifying a custom preloader using <window preloader="" />
 * in the project file.</p>
 */
class Assets {
	
	
	public static var cache:IAssetCache = new AssetCache ();
	public static var libraries (default, null) = new Map <String, AssetLibrary> ();
	
	private static var dispatcher = new EventDispatcher ();
	private static var initialized = false;
	
	
	public static function addEventListener (type:String, listener:Dynamic, useCapture:Bool = false, priority:Int = 0, useWeakReference:Bool = false):Void {
		
		initialize ();
		
		dispatcher.addEventListener (type, listener, useCapture, priority, useWeakReference);
		
	}
	
	
	public static function dispatchEvent (event:Event):Bool {
		
		initialize ();
		
		return dispatcher.dispatchEvent (event);
		
	}
	
	
	public static function exists (id:String, type:AssetType = null):Bool {
		
		initialize ();
		
		#if (tools && !display)
		
		if (type == null) {
			
			type = BINARY;
			
		}
		
		var libraryName = id.substring (0, id.indexOf (":"));
		var symbolName = id.substr (id.indexOf (":") + 1);
		var library = getLibrary (libraryName);
		
		if (library != null) {
			
			return library.exists (symbolName, type);
			
		}
		
		#end
		
		return false;
		
	}
	
	
	/**
	 * Gets an instance of an embedded bitmap
	 * @usage		var bitmap = new Bitmap(Assets.getBitmapData("image.jpg"));
	 * @param	id		The ID or asset path for the bitmap
	 * @param	useCache		(Optional) Whether to use BitmapData from the cache(Default: true)
	 * @return		A new BitmapData object
	 */
	public static function getBitmapData (id:String, useCache:Bool = true):BitmapData {
		
		initialize ();
		
		#if (tools && !display)
		
		if (useCache && cache.enabled && cache.hasBitmapData (id)) {
			
			var bitmapData = cache.getBitmapData (id);
			
			if (isValidBitmapData (bitmapData)) {
				
				return bitmapData;
				
			}
			
		}
		
		var libraryName = id.substring (0, id.indexOf (":"));
		var symbolName = id.substr (id.indexOf (":") + 1);
		var library = getLibrary (libraryName);
		
		if (library != null) {
			
			if (library.exists (symbolName, IMAGE)) {
				
				if (library.isLocal (symbolName, IMAGE)) {
					
					var bitmapData = library.getBitmapData (symbolName);
					
					if (useCache && cache.enabled) {
						
						cache.setBitmapData (id, bitmapData);
						
					}
					
					return bitmapData;
					
				} else {
					
					trace ("[openfl.Assets] BitmapData asset \"" + id + "\" exists, but only asynchronously");
					
				}
				
			} else {
				
				trace ("[openfl.Assets] There is no BitmapData asset with an ID of \"" + id + "\"");
				
			}
			
		} else {
			
			trace ("[openfl.Assets] There is no asset library named \"" + libraryName + "\"");
			
		}
		
		#end
		
		return null;
		
	}
	
	
	/**
	 * Gets an instance of an embedded binary asset
	 * @usage		var bytes = Assets.getBytes("file.zip");
	 * @param	id		The ID or asset path for the file
	 * @return		A new ByteArray object
	 */
	public static function getBytes (id:String):ByteArray {
		
		initialize ();
		
		#if (tools && !display)
		
		var libraryName = id.substring (0, id.indexOf(":"));
		var symbolName = id.substr (id.indexOf(":") + 1);
		var library = getLibrary (libraryName);
		
		if (library != null) {
			
			if (library.exists (symbolName, BINARY)) {
				
				if (library.isLocal (symbolName, BINARY)) {
					
					return library.getBytes (symbolName);
					
				} else {
					
					trace ("[openfl.Assets] String or ByteArray asset \"" + id + "\" exists, but only asynchronously");
					
				}
				
			} else {
				
				trace ("[openfl.Assets] There is no String or ByteArray asset with an ID of \"" + id + "\"");
				
			}
			
		} else {
			
			trace ("[openfl.Assets] There is no asset library named \"" + libraryName + "\"");
			
		}
		
		#end
		
		return null;
		
	}
	
	
	/**
	 * Gets an instance of an embedded font
	 * @usage		var fontName = Assets.getFont("font.ttf").fontName;
	 * @param	id		The ID or asset path for the font
	 * @return		A new Font object
	 */
	public static function getFont (id:String, useCache:Bool = true):Font {
		
		initialize ();
		
		#if (tools && !display)
		
		if (useCache && cache.enabled && cache.hasFont (id)) {
			
			return cache.getFont (id);
			
		}
		
		var libraryName = id.substring (0, id.indexOf (":"));
		var symbolName = id.substr (id.indexOf (":") + 1);
		var library = getLibrary (libraryName);
		
		if (library != null) {
			
			if (library.exists (symbolName, FONT)) {
				
				if (library.isLocal (symbolName, FONT)) {
					
					var font = library.getFont (symbolName);
					
					if (useCache && cache.enabled) {
						
						cache.setFont (id, font);
						
					}
					
					return font;
					
				} else {
					
					trace ("[openfl.Assets] Font asset \"" + id + "\" exists, but only asynchronously");
					
				}
				
			} else {
				
				trace ("[openfl.Assets] There is no Font asset with an ID of \"" + id + "\"");
				
			}
			
		} else {
			
			trace ("[openfl.Assets] There is no asset library named \"" + libraryName + "\"");
			
		}
		
		#end
		
		return null;
		
	}
	
	
	private static function getLibrary (name:String):AssetLibrary {
		
		if (name == null || name == "") {
			
			name = "default";
			
		}
		
		return libraries.get (name);
		
	}
	
	
	/**
	 * Gets an instance of a library MovieClip
	 * @usage		var movieClip = Assets.getMovieClip("library:BouncingBall");
	 * @param	id		The library and ID for the MovieClip
	 * @return		A new Sound object
	 */
	public static function getMovieClip (id:String):MovieClip {
		
		initialize ();
		
		#if (tools && !display)
		
		var libraryName = id.substring (0, id.indexOf (":"));
		var symbolName = id.substr (id.indexOf (":") + 1);
		var library = getLibrary (libraryName);
		
		if (library != null) {
			
			if (library.exists (symbolName, MOVIE_CLIP)) {
				
				if (library.isLocal (symbolName, MOVIE_CLIP)) {
					
					return library.getMovieClip (symbolName);
					
				} else {
					
					trace ("[openfl.Assets] MovieClip asset \"" + id + "\" exists, but only asynchronously");
					
				}
				
			} else {
				
				trace ("[openfl.Assets] There is no MovieClip asset with an ID of \"" + id + "\"");
				
			}
			
		} else {
			
			trace ("[openfl.Assets] There is no asset library named \"" + libraryName + "\"");
			
		}
		
		#end
		
		return null;
		
	}
	
	
	/**
	 * Gets an instance of an embedded streaming sound
	 * @usage		var sound = Assets.getMusic("sound.ogg");
	 * @param	id		The ID or asset path for the music track
	 * @return		A new Sound object
	 */
	public static function getMusic (id:String, useCache:Bool = true):Sound {
		
		initialize ();
		
		#if (tools && !display)
		
		if (useCache && cache.enabled && cache.hasSound (id)) {
			
			var sound = cache.getSound (id);
			
			if (isValidSound (sound)) {
				
				return sound;
				
			}
			
		}
		
		var libraryName = id.substring (0, id.indexOf (":"));
		var symbolName = id.substr (id.indexOf (":") + 1);
		var library = getLibrary (libraryName);
		
		if (library != null) {
			
			if (library.exists (symbolName, MUSIC)) {
				
				if (library.isLocal (symbolName, MUSIC)) {
					
					var sound = library.getMusic (symbolName);
					
					if (useCache && cache.enabled) {
						
						cache.setSound (id, sound);
						
					}
					
					return sound;
					
				} else {
					
					trace ("[openfl.Assets] Sound asset \"" + id + "\" exists, but only asynchronously");
					
				}
				
			} else {
				
				trace ("[openfl.Assets] There is no Sound asset with an ID of \"" + id + "\"");
				
			}
			
		} else {
			
			trace ("[openfl.Assets] There is no asset library named \"" + libraryName + "\"");
			
		}
		
		#end
		
		return null;
		
	}
	
	
	/**
	 * Gets the file path (if available) for an asset
	 * @usage		var path = Assets.getPath("image.jpg");
	 * @param	id		The ID or asset path for the asset
	 * @return		The path to the asset (or null)
	 */
	public static function getPath (id:String):String {
		
		initialize ();
		
		#if (tools && !display)
		
		var libraryName = id.substring (0, id.indexOf (":"));
		var symbolName = id.substr (id.indexOf (":") + 1);
		var library = getLibrary (libraryName);
		
		if (library != null) {
			
			if (library.exists (symbolName, null)) {
				
				return library.getPath (symbolName);
				
			} else {
				
				trace ("[openfl.Assets] There is no asset with an ID of \"" + id + "\"");
				
			}
			
		} else {
			
			trace ("[openfl.Assets] There is no asset library named \"" + libraryName + "\"");
			
		}
		
		#end
		
		return null;
		
	}
	
	
	/**
	 * Gets an instance of an embedded sound
	 * @usage		var sound = Assets.getSound("sound.wav");
	 * @param	id		The ID or asset path for the sound
	 * @return		A new Sound object
	 */
	public static function getSound (id:String, useCache:Bool = true):Sound {
		
		initialize ();
		
		#if (tools && !display)
		
		if (useCache && cache.enabled && cache.hasSound (id)) {
			
			var sound = cache.getSound (id);
			
			if (isValidSound (sound)) {
				
				return sound;
				
			}
			
		}
		
		var libraryName = id.substring (0, id.indexOf (":"));
		var symbolName = id.substr (id.indexOf (":") + 1);
		var library = getLibrary (libraryName);
		
		if (library != null) {
			
			if (library.exists (symbolName, SOUND)) {
				
				if (library.isLocal (symbolName, SOUND)) {
					
					var sound = library.getSound (symbolName);
					
					if (useCache && cache.enabled) {
						
						cache.setSound (id, sound);
						
					}
					
					return sound;
					
				} else {
					
					trace ("[openfl.Assets] Sound asset \"" + id + "\" exists, but only asynchronously");
					
				}
				
			} else {
				
				trace ("[openfl.Assets] There is no Sound asset with an ID of \"" + id + "\"");
				
			}
			
		} else {
			
			trace ("[openfl.Assets] There is no asset library named \"" + libraryName + "\"");
			
		}
		
		#end
		
		return null;
		
	}
	
	
	/**
	 * Gets an instance of an embedded text asset
	 * @usage		var text = Assets.getText("text.txt");
	 * @param	id		The ID or asset path for the file
	 * @return		A new String object
	 */
	public static function getText (id:String):String {
		
		initialize ();
		
		#if (tools && !display)
		
		var libraryName = id.substring (0, id.indexOf(":"));
		var symbolName = id.substr (id.indexOf(":") + 1);
		var library = getLibrary (libraryName);
		
		if (library != null) {
			
			if (library.exists (symbolName, TEXT)) {
				
				if (library.isLocal (symbolName, TEXT)) {
					
					return library.getText (symbolName);
					
				} else {
					
					trace ("[openfl.Assets] String asset \"" + id + "\" exists, but only asynchronously");
					
				}
				
			} else {
				
				trace ("[openfl.Assets] There is no String asset with an ID of \"" + id + "\"");
				
			}
			
		} else {
			
			trace ("[openfl.Assets] There is no asset library named \"" + libraryName + "\"");
			
		}
		
		#end
		
		return null;
		
	}
	
	
	public static function hasEventListener (type:String):Bool {
		
		initialize ();
		
		return dispatcher.hasEventListener (type);
		
	}
	
	
	private static function initialize ():Void {
		
		if (!initialized) {
			
			#if (tools && !display)
			
			registerLibrary ("default", new DefaultAssetLibrary ());
			
			#end
			
			initialized = true;
			
		}
		
	}
	
	
	public static function isLocal (id:String, type:AssetType = null, useCache:Bool = true):Bool {
		
		initialize ();
		
		#if (tools && !display)
		
		if (useCache && cache.enabled) {
			
			if (type == AssetType.IMAGE || type == null) {
				
				if (cache.hasBitmapData (id)) return true;
				
			}
			
			if (type == AssetType.FONT || type == null) {
				
				if (cache.hasFont (id)) return true;
				
			}
			
			if (type == AssetType.SOUND || type == AssetType.MUSIC || type == null) {
				
				if (cache.hasSound (id)) return true;
				
			}
			
		}
		
		var libraryName = id.substring (0, id.indexOf (":"));
		var symbolName = id.substr (id.indexOf (":") + 1);
		var library = getLibrary (libraryName);
		
		if (library != null) {
			
			return library.isLocal (symbolName, type);
			
		}
		
		#end
		
		return false;
		
	}
	
	
	private static function isValidBitmapData (bitmapData:BitmapData):Bool {
		
		#if (tools && !display)
		#if (cpp || neko)
		
		return (bitmapData.__handle != null);
		
		#elseif flash
		
		try {
			
			bitmapData.width;
			
		} catch (e:Dynamic) {
			
			return false;
			
		}
		
		#elseif openfl_html5
		
		return (bitmapData.__sourceImage != null || bitmapData.__sourceCanvas != null);
		
		#end
		#end
		
		return true;
		
	}
	
	
	private static function isValidSound (sound:Sound):Bool {
		
		#if (tools && !display)
		#if (cpp || neko)
		
		return (sound.__handle != null && sound.__handle != 0);
		
		#end
		#end
		
		return true;
		
	}
	
	
	public static function list (type:AssetType = null):Array<String> {
		
		initialize ();
		
		var items = [];
		
		for (library in libraries) {
			
			var libraryItems = library.list (type);
			
			if (libraryItems != null) {
				
				items = items.concat (libraryItems);
				
			}
			
		}
		
		return items;
		
	}
	
	
	public static function loadBitmapData (id:String, handler:BitmapData -> Void, useCache:Bool = true):Void {
		
		initialize ();
		
		#if (tools && !display)
		
		if (useCache && cache.enabled && cache.hasBitmapData (id)) {
			
			var bitmapData = cache.getBitmapData (id);
			
			if (isValidBitmapData (bitmapData)) {
				
				handler (bitmapData);
				return;
				
			}
			
		}
		
		var libraryName = id.substring (0, id.indexOf (":"));
		var symbolName = id.substr (id.indexOf (":") + 1);
		var library = getLibrary (libraryName);
		
		if (library != null) {
			
			if (library.exists (symbolName, IMAGE)) {
				
				if (useCache && cache.enabled) {
					
					library.loadBitmapData (symbolName, function (bitmapData:BitmapData):Void {
						
						cache.setBitmapData (id, bitmapData);
						handler (bitmapData);
						
					});
					
				} else {
					
					library.loadBitmapData (symbolName, handler);
					
				}
				
				return;
				
			} else {
				
				trace ("[openfl.Assets] There is no BitmapData asset with an ID of \"" + id + "\"");
				
			}
			
		} else {
			
			trace ("[openfl.Assets] There is no asset library named \"" + libraryName + "\"");
			
		}
		
		#end
		
		handler (null);
		
	}
	
	
	public static function loadBytes (id:String, handler:ByteArray -> Void):Void {
		
		initialize ();
		
		#if (tools && !display)
		
		var libraryName = id.substring (0, id.indexOf (":"));
		var symbolName = id.substr (id.indexOf (":") + 1);
		var library = getLibrary (libraryName);
		
		if (library != null) {
			
			if (library.exists (symbolName, BINARY)) {
				
				library.loadBytes (symbolName, handler);
				return;
				
			} else {
				
				trace ("[openfl.Assets] There is no String or ByteArray asset with an ID of \"" + id + "\"");
				
			}
			
		} else {
			
			trace ("[openfl.Assets] There is no asset library named \"" + libraryName + "\"");
			
		}
		
		#end
		
		handler (null);
		
	}
	
	
	public static function loadFont (id:String, handler:Font -> Void, useCache:Bool = true):Void {
		
		initialize ();
		
		#if (tools && !display)
		
		if (useCache && cache.enabled && cache.hasFont (id)) {
			
			handler (cache.getFont (id));
			return;
			
		}
		
		var libraryName = id.substring (0, id.indexOf (":"));
		var symbolName = id.substr (id.indexOf (":") + 1);
		var library = getLibrary (libraryName);
		
		if (library != null) {
			
			if (library.exists (symbolName, FONT)) {
				
				if (useCache && cache.enabled) {
					
					library.loadFont (symbolName, function (font:Font):Void {
						
						cache.setFont (id, font);
						handler (font);
						
					});
					
				} else {
					
					library.loadFont (symbolName, handler);
					
				}
				
				return;
				
			} else {
				
				trace ("[openfl.Assets] There is no Font asset with an ID of \"" + id + "\"");
				
			}
			
		} else {
			
			trace ("[openfl.Assets] There is no asset library named \"" + libraryName + "\"");
			
		}
		
		#end
		
		handler (null);
		
	}
	
	
	public static function loadLibrary (name:String, handler:AssetLibrary -> Void):Void {
		
		initialize();
		
		#if (tools && !display)
		
		var data = getText ("libraries/" + name + ".json");
		
		if (data != null && data != "") {
			
			var info = Json.parse (data);
			var library = Type.createInstance (Type.resolveClass (info.type), info.args);
			libraries.set (name, library);
			library.eventCallback = library_onEvent;
			library.load (handler);
			
		} else {
			
			trace ("[openfl.Assets] There is no asset library named \"" + name + "\"");
			
		}
		
		#end
		
	}
	
	
	public static function loadMusic (id:String, handler:Sound -> Void, useCache:Bool = true):Void {
		
		initialize ();
		
		#if (tools && !display)
		
		if (useCache && cache.enabled && cache.hasSound (id)) {
			
			var sound = cache.getSound (id);
			
			if (isValidSound (sound)) {
				
				handler (sound);
				return;
				
			}
			
		}
		
		var libraryName = id.substring (0, id.indexOf (":"));
		var symbolName = id.substr (id.indexOf (":") + 1);
		var library = getLibrary (libraryName);
		
		if (library != null) {
			
			if (library.exists (symbolName, MUSIC)) {
				
				if (useCache && cache.enabled) {
					
					library.loadMusic (symbolName, function (sound:Sound):Void {
						
						cache.setSound (id, sound);
						handler (sound);
						
					});
					
				} else {
					
					library.loadMusic (symbolName, handler);
					
				}
				
				return;
				
			} else {
				
				trace ("[openfl.Assets] There is no Sound asset with an ID of \"" + id + "\"");
				
			}
			
		} else {
			
			trace ("[openfl.Assets] There is no asset library named \"" + libraryName + "\"");
			
		}
		
		#end
		
		handler (null);
		
	}
	
	
	public static function loadMovieClip (id:String, handler:MovieClip -> Void):Void {
		
		initialize ();
		
		#if (tools && !display)
		
		var libraryName = id.substring (0, id.indexOf (":"));
		var symbolName = id.substr (id.indexOf (":") + 1);
		var library = getLibrary (libraryName);
		
		if (library != null) {
			
			if (library.exists (symbolName, MOVIE_CLIP)) {
				
				library.loadMovieClip (symbolName, handler);
				return;
				
			} else {
				
				trace ("[openfl.Assets] There is no MovieClip asset with an ID of \"" + id + "\"");
				
			}
			
		} else {
			
			trace ("[openfl.Assets] There is no asset library named \"" + libraryName + "\"");
			
		}
		
		#end
		
		handler (null);
		
	}
	
	
	public static function loadSound (id:String, handler:Sound -> Void, useCache:Bool = true):Void {
		
		initialize ();
		
		#if (tools && !display)
		
		if (useCache && cache.enabled && cache.hasSound (id)) {
			
			var sound = cache.getSound (id);
			
			if (isValidSound (sound)) {
				
				handler (sound);
				return;
				
			}
			
		}
		
		var libraryName = id.substring (0, id.indexOf (":"));
		var symbolName = id.substr (id.indexOf (":") + 1);
		var library = getLibrary (libraryName);
		
		if (library != null) {
			
			if (library.exists (symbolName, SOUND)) {
				
				if (useCache && cache.enabled) {
					
					library.loadSound (symbolName, function (sound:Sound):Void {
						
						cache.setSound (id, sound);
						handler (sound);
						
					});
					
				} else {
					
					library.loadSound (symbolName, handler);
					
				}
				
				return;
				
			} else {
				
				trace ("[openfl.Assets] There is no Sound asset with an ID of \"" + id + "\"");
				
			}
			
		} else {
			
			trace ("[openfl.Assets] There is no asset library named \"" + libraryName + "\"");
			
		}
		
		#end
		
		handler (null);
		
	}
	
	
	public static function loadText (id:String, handler:String -> Void):Void {
		
		initialize ();
		
		#if (tools && !display)
		
		var libraryName = id.substring (0, id.indexOf (":"));
		var symbolName = id.substr (id.indexOf (":") + 1);
		var library = getLibrary (libraryName);
		
		if (library != null) {
			
			if (library.exists (symbolName, TEXT)) {
				
				library.loadText (symbolName, handler);
				return;
				
			} else {
				
				trace ("[openfl.Assets] There is no String asset with an ID of \"" + id + "\"");
				
			}
			
		} else {
			
			trace ("[openfl.Assets] There is no asset library named \"" + libraryName + "\"");
			
		}
		
		#end
		
		handler (null);
		
	}
	
	
	public static function registerLibrary (name:String, library:AssetLibrary):Void {
		
		if (libraries.exists (name)) {
			
			unloadLibrary (name);
			
		}
		
		if (library != null) {
			
			library.eventCallback = library_onEvent;
			
		}
		
		libraries.set (name, library);
		
	}
	
	
	public static function removeEventListener (type:String, listener:Dynamic, capture:Bool = false):Void {
		
		initialize ();
		
		dispatcher.removeEventListener (type, listener, capture);
		
	}
	
	
	private static function resolveClass (name:String):Class <Dynamic> {
		
		return Type.resolveClass (name);
		
	}
	
	
	private static function resolveEnum (name:String):Enum <Dynamic> {
		
		var value = Type.resolveEnum (name);
		
		#if flash
		
		if (value == null) {
			
			return cast Type.resolveClass (name);
			
		}
		
		#end
		
		return value;
		
	}
	
	
	public static function unloadLibrary (name:String):Void {
		
		initialize();
		
		#if (tools && !display)
		
		var library = libraries.get (name);
		
		if (library != null) {
			
			cache.clear (name + ":");
			library.eventCallback = null;
			
		}
		
		libraries.remove (name);
		
		#end
		
	}
	
	
	
	
	// Event Handlers
	
	
	
	
	private static function library_onEvent (library:AssetLibrary, type:String):Void {
		
		if (type == "change") {
			
			cache.clear ();
			dispatchEvent (new Event (Event.CHANGE));
			
		}
		
	}
	
	
}


class AssetLibrary {
	
	
	public var eventCallback:Dynamic;
	
	
	public function new () {
		
		
		
	}
	
	
	public function exists (id:String, type:AssetType):Bool {
		
		return false;
		
	}
	
	
	public function getBitmapData (id:String):BitmapData {
		
		return null;
		
	}
	
	
	public function getBytes (id:String):ByteArray {
		
		return null;
		
	}
	
	
	public function getFont (id:String):Font {
		
		return null;
		
	}
	
	
	public function getMovieClip (id:String):MovieClip {
		
		return null;
		
	}
	
	
	public function getMusic (id:String):Sound {
		
		return getSound (id);
		
	}
	
	
	public function getPath (id:String):String {
		
		return null;
		
	}
	
	
	public function getSound (id:String):Sound {
		
		return null;
		
	}
	
	
	public function getText (id:String):String {
		
		#if (tools && !display)
		
		var bytes = getBytes (id);
		
		if (bytes == null) {
			
			return null;
			
		} else {
			
			return bytes.readUTFBytes (bytes.length);
			
		}
		
		#else
		
		return null;
		
		#end
		
	}
	
	
	public function isLocal (id:String, type:AssetType):Bool {
		
		return true;
		
	}
	
	
	public function list (type:AssetType):Array<String> {
		
		return null;
		
	}
	
	
	private function load (handler:AssetLibrary -> Void):Void {
		
		handler (this);
		
	}
	
	
	public function loadBitmapData (id:String, handler:BitmapData -> Void):Void {
		
		handler (getBitmapData (id));
		
	}
	
	
	public function loadBytes (id:String, handler:ByteArray -> Void):Void {
		
		handler (getBytes (id));
		
	}
	
	
	public function loadFont (id:String, handler:Font -> Void):Void {
		
		handler (getFont (id));
		
	}
	
	
	public function loadMovieClip (id:String, handler:MovieClip -> Void):Void {
		
		handler (getMovieClip (id));
		
	}
	
	
	public function loadMusic (id:String, handler:Sound -> Void):Void {
		
		handler (getMusic (id));
		
	}
	
	
	public function loadSound (id:String, handler:Sound -> Void):Void {
		
		handler (getSound (id));
		
	}
	
	
	public function loadText (id:String, handler:String -> Void):Void {
		
		#if (tools && !display)
		
		var callback = function (bytes:ByteArray):Void {
			
			if (bytes == null) {
				
				handler (null);
				
			} else {
				
				handler (bytes.readUTFBytes (bytes.length));
				
			}
			
		}
		
		loadBytes (id, callback);
		
		#else
		
		handler (null);
		
		#end
		
	}
	
	
}


class AssetCache implements IAssetCache {
	
	
	public var bitmapData:Map<String, BitmapData>;
	public var enabled (get, set):Bool;
	public var font:Map<String, Font>;
	public var sound:Map<String, Sound>;
	
	private var __enabled = true;
	
	
	public function new () {
		
		bitmapData = new Map<String, BitmapData> ();
		font = new Map<String, Font> ();
		sound = new Map<String, Sound> ();
		
	}
	
	
	public function clear (prefix:String = null):Void {
		
		if (prefix == null) {
			
			bitmapData = new Map<String, BitmapData> ();
			font = new Map<String, Font> ();
			sound = new Map<String, Sound> ();
			
		} else {
			
			var keys = bitmapData.keys ();
			
			for (key in keys) {
				
				if (StringTools.startsWith (key, prefix)) {
					
					bitmapData.remove (key);
					
				}
				
			}
			
			var keys = font.keys ();
			
			for (key in keys) {
				
				if (StringTools.startsWith (key, prefix)) {
					
					font.remove (key);
					
				}
				
			}
			
			var keys = sound.keys ();
			
			for (key in keys) {
				
				if (StringTools.startsWith (key, prefix)) {
					
					sound.remove (key);
					
				}
				
			}
			
		}
		
	}
	
	
	public function getBitmapData (id:String):BitmapData {
		
		return bitmapData.get (id);
		
	}
	
	
	public function getFont (id:String):Font {
		
		return font.get (id);
		
	}
	
	
	public function getSound (id:String):Sound {
		
		return sound.get (id);
		
	}
	
	
	public function hasBitmapData (id:String):Bool {
		
		return bitmapData.exists (id);
		
	}
	
	
	public function hasFont (id:String):Bool {
		
		return font.exists (id);
		
	}
	
	
	public function hasSound (id:String):Bool {
		
		return sound.exists (id);
		
	}
	
	
	public function removeBitmapData (id:String):Bool {
		
		return bitmapData.remove (id);
		
	}
	
	
	public function removeFont (id:String):Bool {
		
		return font.remove (id);
		
	}
	
	
	public function removeSound (id:String):Bool {
		
		return sound.remove (id);
		
	}
	
	
	public function setBitmapData (id:String, bitmapData:BitmapData):Void {
		
		this.bitmapData.set (id, bitmapData);
		
	}
	
	
	public function setFont (id:String, font:Font):Void {
		
		this.font.set (id, font);
		
	}
	
	
	public function setSound (id:String, sound:Sound):Void {
		
		this.sound.set (id, sound);
		
	}
	
	
	
	
	// Get & Set Methods
	
	
	
	
	private function get_enabled ():Bool {
		
		return __enabled;
		
	}
	
	
	private function set_enabled (value:Bool):Bool {
		
		return __enabled = value;
		
	}
	
	
}


interface IAssetCache {
	
	public var enabled (get, set):Bool;
	
	public function clear (prefix:String = null):Void;
	public function getBitmapData (id:String):BitmapData;
	public function getFont (id:String):Font;
	public function getSound (id:String):Sound;
	public function hasBitmapData (id:String):Bool;
	public function hasFont (id:String):Bool;
	public function hasSound (id:String):Bool;
	public function removeBitmapData (id:String):Bool;
	public function removeFont (id:String):Bool;
	public function removeSound (id:String):Bool;
	public function setBitmapData (id:String, bitmapData:BitmapData):Void;
	public function setFont (id:String, font:Font):Void;
	public function setSound (id:String, sound:Sound):Void;
	
}


class AssetData {
	
	
	public var id:String;
	public var path:String;
	public var type:AssetType;
	
	public function new () {
		
		
		
	}
	
	
}


enum AssetType {
	
	BINARY;
	FONT;
	IMAGE;
	MOVIE_CLIP;
	MUSIC;
	SOUND;
	TEMPLATE;
	TEXT;
	
}


#else


import haxe.crypto.BaseCode;
import haxe.io.Bytes;
import haxe.macro.Context;
import haxe.macro.Expr;
import haxe.macro.Type;
import haxe.Serializer;
import sys.io.File;


class Assets {
	
	
	private static var base64Chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";
	private static var base64Encoder:BaseCode;
	
	
	private static function base64Encode (bytes:Bytes):String {
		
		var extension = switch (bytes.length % 3) {
			
			case 1: "==";
			case 2: "=";
			default: "";
			
		}
		
		if (base64Encoder == null) {
			
			base64Encoder = new BaseCode (Bytes.ofString (base64Chars));
			
		}
		
		return base64Encoder.encodeBytes (bytes).toString () + extension;
		
	}
	
	
	macro public static function embedBitmap ():Array<Field> {
		
		#if (html5 && !openfl_html5_dom)
		var fields = embedData (":bitmap", true);
		#else
		var fields = embedData (":bitmap");
		#end
		
		if (fields != null) {
			
			var constructor = macro { 
				
				#if html5
				#if openfl_html5_dom
				
				super (width, height, transparent, fillRGBA);
				
				var currentType = Type.getClass (this);
				
				if (preload != null) {
					
					___textureBuffer.width = Std.int (preload.width);
					___textureBuffer.height = Std.int (preload.height);
					rect = new openfl.geom.Rectangle (0, 0, preload.width, preload.height);
					setPixels(rect, preload.getPixels(rect));
					__buildLease();
					
				} else {
					
					var byteArray = openfl.utils.ByteArray.fromBytes (haxe.Resource.getBytes(resourceName));
					
					if (onload != null && !Std.is (onload, Bool)) {
						
						__loadFromBytes(byteArray, null, onload);
						
					} else {
						
						__loadFromBytes(byteArray);
						
					}
					
				}
				
				#else
				
				super (0, 0, transparent, fillRGBA);
				
				if (preload != null) {
					
					__sourceImage = preload;
					width = __sourceImage.width;
					height = __sourceImage.height;
					
				} else {
					
					__loadFromBase64 (haxe.Resource.getString(resourceName), resourceType, function (b) {
						
						if (preload == null) {
							
							preload = b.__sourceImage;
							
						}
						
						if (onload != null) {
							
							onload (b);
							
						}
						
					});
					
				}
				
				#end
				#else
				
				super (width, height, transparent, fillRGBA);
				
				var byteArray = openfl.utils.ByteArray.fromBytes (haxe.Resource.getBytes (resourceName));
				__loadFromBytes (byteArray);
				
				#end
				
			};
			
			var args = [ { name: "width", opt: false, type: macro :Int, value: null }, { name: "height", opt: false, type: macro :Int, value: null }, { name: "transparent", opt: true, type: macro :Bool, value: macro true }, { name: "fillRGBA", opt: true, type: macro :Int, value: macro 0xFFFFFFFF } ];
			
			#if html5
			args.push ({ name: "onload", opt: true, type: macro :Dynamic, value: null });
			#if openfl_html5_dom
			fields.push ({ kind: FVar(macro :openfl.display.BitmapData, null), name: "preload", doc: null, meta: [], access: [ APublic, AStatic ], pos: Context.currentPos() });
			#else
			fields.push ({ kind: FVar(macro :js.html.Image, null), name: "preload", doc: null, meta: [], access: [ APublic, AStatic ], pos: Context.currentPos() });
			#end
			#end
			
			fields.push ({ name: "new", access: [ APublic ], kind: FFun({ args: args, expr: constructor, params: [], ret: null }), pos: Context.currentPos() });
			
		}
		
		return fields;
		
	}
	
	
	private static function embedData (metaName:String, encode:Bool = false):Array<Field> {
		
		var classType = Context.getLocalClass().get();
		var metaData = classType.meta.get();
		var position = Context.currentPos();
		var fields = Context.getBuildFields();
		
		for (meta in metaData) {
			
			if (meta.name == metaName) {
				
				if (meta.params.length > 0) {
					
					switch (meta.params[0].expr) {
						
						case EConst(CString(filePath)):
							
							var path = filePath;
							if (!sys.FileSystem.exists(filePath)) {
								path = Context.resolvePath (filePath);
							}
							var bytes = File.getBytes (path);
							var resourceName = "__ASSET__" + metaName + "_" + (classType.pack.length > 0 ? classType.pack.join ("_") + "_" : "") + classType.name;
							
							if (encode) {
								
								var resourceType = "image/png";
								
								if (bytes.get (0) == 0xFF && bytes.get (1) == 0xD8) {
									
									resourceType = "image/jpg";
									
								} else if (bytes.get (0) == 0x47 && bytes.get (1) == 0x49 && bytes.get (2) == 0x46) {
									
									resourceType = "image/gif";
									
								}
								
								var fieldValue = { pos: position, expr: EConst(CString(resourceType)) };
								fields.push ({ kind: FVar(macro :String, fieldValue), name: "resourceType", access: [ APrivate, AStatic ], pos: position });
								
								var base64 = base64Encode (bytes);
								Context.addResource (resourceName, Bytes.ofString (base64));
								
							} else {
								
								Context.addResource (resourceName, bytes);
								
							}
							
							var fieldValue = { pos: position, expr: EConst(CString(resourceName)) };
							fields.push ({ kind: FVar(macro :String, fieldValue), name: "resourceName", access: [ APrivate, AStatic ], pos: position });
							
							return fields;
							
						default:
						
					}
					
				}
				
			}
			
		}
		
		return null;
		
	}
	
	
	macro public static function embedFile ():Array<Field> {
		
		var fields = embedData (":file");
		
		if (fields != null) {
			
			var constructor = macro { 
				
				super();
				
				#if openfl_html5_dom
				nmeFromBytes (haxe.Resource.getBytes (resourceName));
				#else
				__fromBytes (haxe.Resource.getBytes (resourceName));
				#end
				
			};
			
			var args = [ { name: "size", opt: true, type: macro :Int, value: macro 0 } ];
			fields.push ({ name: "new", access: [ APublic ], kind: FFun({ args: args, expr: constructor, params: [], ret: null }), pos: Context.currentPos() });
			
		}
		
		return fields;
		
	}
	
	
	macro public static function embedFont ():Array<Field> {
		
		var fields = null;
		
		var classType = Context.getLocalClass().get();
		var metaData = classType.meta.get();
		var position = Context.currentPos();
		var fields = Context.getBuildFields();
		
		var path = "";
		var glyphs = "32-255";
		
		for (meta in metaData) {
			
			if (meta.name == ":font") {
				
				if (meta.params.length > 0) {
					
					switch (meta.params[0].expr) {
						
						case EConst(CString(filePath)):
							
							path = Context.resolvePath (filePath);
							
						default:
						
					}
					
				}
				
			}
			
		}
		
		if (path != null && path != "") {
			
			#if html5
			Sys.command ("haxelib", [ "run", "openfl", "generate", "-font-hash", sys.FileSystem.fullPath(path) ]);
			path += ".hash";
			#end
			
			var bytes = File.getBytes (path);
			var resourceName = "NME_font_" + (classType.pack.length > 0 ? classType.pack.join ("_") + "_" : "") + classType.name;
			
			Context.addResource (resourceName, bytes);
			
			var fieldValue = { pos: position, expr: EConst(CString(resourceName)) };
			fields.push ({ kind: FVar(macro :String, fieldValue), name: "resourceName", access: [ APublic, AStatic ], pos: position });
			
			//var constructor = macro { 
				//
				//super();
				//
				//fontName = resourceName;
				//
			//};
			//
			//fields.push ({ name: "new", access: [ APublic ], kind: FFun({ args: [], expr: constructor, params: [], ret: null }), pos: Context.currentPos() });
			
			return fields;
			
		}
		
		return fields;
		
	}
	
	
	macro public static function embedSound ():Array<Field> {
		
		var fields = embedData (":sound");
		
		if (fields != null) {
			
			#if (!html5) // CFFILoader.h(248) : NOT Implemented:api_buffer_data
			
			var constructor = macro { 
				
				super();
				
				var byteArray = openfl.utils.ByteArray.fromBytes (haxe.Resource.getBytes(resourceName));
				loadCompressedDataFromByteArray(byteArray, byteArray.length, forcePlayAsMusic);
				
			};
			
			var args = [ { name: "stream", opt: true, type: macro :openfl.net.URLRequest, value: null }, { name: "context", opt: true, type: macro :openfl.media.SoundLoaderContext, value: null }, { name: "forcePlayAsMusic", opt: true, type: macro :Bool, value: macro false } ];
			fields.push ({ name: "new", access: [ APublic ], kind: FFun({ args: args, expr: constructor, params: [], ret: null }), pos: Context.currentPos() });
			
			#end
			
		}
		
		return fields;
		
	}
	
	
}


#end
#end