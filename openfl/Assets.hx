package openfl; #if (flash || openfl_next || js || display || html5)
#if !macro


import haxe.Unserializer;
import lime.Assets.AssetLibrary in LimeAssetLibrary;
import lime.Assets in LimeAssets;
import openfl.display.Bitmap;
import openfl.display.BitmapData;
import openfl.display.MovieClip;
import openfl.events.Event;
import openfl.events.EventDispatcher;
import openfl.media.Sound;
import openfl.net.URLRequest;
import openfl.text.Font;
import openfl.utils.ByteArray;

@:access(lime.Assets)
@:access(openfl.AssetLibrary)
@:access(openfl.display.BitmapData)

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
	
	
	public static var cache = new AssetCache ();
	
	private static var dispatcher = new EventDispatcher ();
	
	
	public static function addEventListener (type:String, listener:Dynamic, useCapture:Bool = false, priority:Int = 0, useWeakReference:Bool = false):Void {
		
		dispatcher.addEventListener (type, listener, useCapture, priority, useWeakReference);
		
	}
	
	
	public static function dispatchEvent (event:Event):Bool {
		
		return dispatcher.dispatchEvent (event);
		
	}
	
	
	public static function exists (id:String, type:AssetType = null):Bool {
		
		return LimeAssets.exists (id, cast type);
		
	}
	
	
	/**
	 * Gets an instance of an embedded bitmap
	 * @usage		var bitmap = new Bitmap(Assets.getBitmapData("image.jpg"));
	 * @param	id		The ID or asset path for the bitmap
	 * @param	useCache		(Optional) Whether to use BitmapData from the cache(Default: true)
	 * @return		A new BitmapData object
	 */
	public static function getBitmapData (id:String, useCache:Bool = true):BitmapData {
		
		#if (tools && !display)
		
		if (useCache && cache.enabled && cache.bitmapData.exists (id)) {
			
			var bitmapData = cache.bitmapData.get (id);
			
			if (isValidBitmapData (bitmapData)) {
				
				return bitmapData;
				
			}
			
		}
		
		var image = LimeAssets.getImage (id, false);
		
		if (image != null) {
			
			#if flash
			var bitmapData = image.src;
			#else
			var bitmapData = BitmapData.fromImage (image);
			#end
			
			if (useCache && cache.enabled) {
				
				cache.bitmapData.set (id, bitmapData);
				
			}
			
			return bitmapData;
			
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
		
		return LimeAssets.getBytes (id);
		
	}
	
	
	/**
	 * Gets an instance of an embedded font
	 * @usage		var fontName = Assets.getFont("font.ttf").fontName;
	 * @param	id		The ID or asset path for the font
	 * @return		A new Font object
	 */
	public static function getFont (id:String, useCache:Bool = true):Font {
		
		#if (tools && !display)
		
		if (useCache && cache.enabled && cache.font.exists (id)) {
			
			return cache.font.get (id);
			
		}
		
		var font = LimeAssets.getFont (id, false);
		
		if (font != null) {
			
			return font;
			
		}
		
		#end
		
		return new Font ();
		
	}
	
	
	private static function getLibrary (name:String):lime.Assets.AssetLibrary {
		
		if (name == null || name == "") {
			
			name = "default";
			
		}
		
		// TODO
		
		return cast LimeAssets.libraries.get (name);
		
	}
	
	
	/**
	 * Gets an instance of a library MovieClip
	 * @usage		var movieClip = Assets.getMovieClip("library:BouncingBall");
	 * @param	id		The library and ID for the MovieClip
	 * @return		A new Sound object
	 */
	public static function getMovieClip (id:String):MovieClip {
		
		#if (tools && !display)
		
		var libraryName = id.substring (0, id.indexOf (":"));
		var symbolName = id.substr (id.indexOf (":") + 1);
		var library:AssetLibrary = cast getLibrary (libraryName);
		
		if (library != null) {
			
			if (library.exists (symbolName, cast AssetType.MOVIE_CLIP)) {
				
				if (library.isLocal (symbolName, cast AssetType.MOVIE_CLIP)) {
					
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
		
		#if flash
		var buffer = LimeAssets.getAudioBuffer (id, useCache);
		return (buffer != null) ? buffer.src : null;
		#else
		#if !html5
		return Sound.fromAudioBuffer (LimeAssets.getAudioBuffer (id, useCache));
		#else
		var path = LimeAssets.getPath (id);
		
		if (path != null) {
			
			return new Sound (new URLRequest (path));
			
		}
		
		return null;
		#end
		#end
		
	}
	
	
	/**
	 * Gets the file path (if available) for an asset
	 * @usage		var path = Assets.getPath("image.jpg");
	 * @param	id		The ID or asset path for the asset
	 * @return		The path to the asset (or null)
	 */
	public static function getPath (id:String):String {
		
		return LimeAssets.getPath (id);
		
	}
	
	
	/**
	 * Gets an instance of an embedded sound
	 * @usage		var sound = Assets.getSound("sound.wav");
	 * @param	id		The ID or asset path for the sound
	 * @return		A new Sound object
	 */
	public static function getSound (id:String, useCache:Bool = true):Sound {
		
		#if (tools && !display)
		
		if (useCache && cache.enabled && cache.sound.exists (id)) {
			
			var sound = cache.sound.get (id);
			
			if (isValidSound (sound)) {
				
				return sound;
				
			}
			
		}
		
		#if !html5
		var buffer = LimeAssets.getAudioBuffer (id, false);
		
		if (buffer != null) {
			
			#if flash
			var sound = buffer.src;
			#else
			var sound = Sound.fromAudioBuffer (buffer);
			#end
			
			if (useCache && cache.enabled) {
				
				cache.sound.set (id, sound);
				
			}
			
			return sound;
			
		}
		#else
		var path = LimeAssets.getPath (id);
		
		if (path != null) {
			
			return new Sound (new URLRequest (path));
			
		}
		#end
		
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
		
		return LimeAssets.getText (id);
		
	}
	
	
	public static function hasEventListener (type:String):Bool {
		
		return dispatcher.hasEventListener (type);
		
	}
	
	
	public static function isLocal (id:String, type:AssetType = null, useCache:Bool = true):Bool {
		
		#if (tools && !display)
		
		if (useCache && cache.enabled) {
			
			if (type == AssetType.IMAGE || type == null) {
				
				if (cache.bitmapData.exists (id)) return true;
				
			}
			
			if (type == AssetType.FONT || type == null) {
				
				if (cache.font.exists (id)) return true;
				
			}
			
			if (type == AssetType.SOUND || type == AssetType.MUSIC || type == null) {
				
				if (cache.sound.exists (id)) return true;
				
			}
			
		}
		
		var libraryName = id.substring (0, id.indexOf (":"));
		var symbolName = id.substr (id.indexOf (":") + 1);
		var library = getLibrary (libraryName);
		
		if (library != null) {
			
			return library.isLocal (symbolName, cast type);
			
		}
		
		#end
		
		return false;
		
	}
	
	
	private static function isValidBitmapData (bitmapData:BitmapData):Bool {
		
		#if (tools && !display)
		#if flash
		
		try {
			
			bitmapData.width;
			
		} catch (e:Dynamic) {
			
			return false;
			
		}
		
		#else
		
		return (bitmapData != null);
		
		#end
		#end
		
		return true;
		
	}
	
	
	private static function isValidSound (sound:Sound):Bool {
		
		#if (tools && !display)
		#if (cpp || neko)
		
		return true;
		//return (sound.__handle != null && sound.__handle != 0);
		
		#end
		#end
		
		return true;
		
	}
	
	
	public static function list (type:AssetType = null):Array<String> {
		
		return LimeAssets.list (cast type);
		
	}
	
	
	public static function loadBitmapData (id:String, handler:BitmapData -> Void, useCache:Bool = true):Void {
		
		#if (tools && !display)
		
		if (useCache && cache.enabled && cache.bitmapData.exists (id)) {
			
			var bitmapData = cache.bitmapData.get (id);
			
			if (isValidBitmapData (bitmapData)) {
				
				handler (bitmapData);
				return;
				
			}
			
		}
		
		LimeAssets.loadImage (id, function (image) {
			
			if (image != null) {
				
				#if flash
				var bitmapData = image.src;
				#else
				var bitmapData = BitmapData.fromImage (image);
				#end
				
				if (useCache && cache.enabled) {
					
					cache.bitmapData.set (id, bitmapData);
					
				}
				
				handler (bitmapData);
				
			}
			
		}, false);
		
		#end
		
	}
	
	
	public static function loadBytes (id:String, handler:ByteArray -> Void):Void {
		
		#if (tools && !display)
		
		var libraryName = id.substring (0, id.indexOf (":"));
		var symbolName = id.substr (id.indexOf (":") + 1);
		var library = getLibrary (libraryName);
		
		if (library != null) {
			
			if (library.exists (symbolName, cast AssetType.BINARY)) {
				
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
		
		#if (tools && !display)
		
		if (useCache && cache.enabled && cache.font.exists (id)) {
			
			handler (cache.font.get (id));
			return;
			
		}
		
		var libraryName = id.substring (0, id.indexOf (":"));
		var symbolName = id.substr (id.indexOf (":") + 1);
		var library = getLibrary (libraryName);
		
		if (library != null) {
			
			if (library.exists (symbolName, cast AssetType.FONT)) {
				
				if (useCache && cache.enabled) {
					
					library.loadFont (symbolName, function (font:Font):Void {
						
						cache.font.set (id, font);
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
	
	
	public static function loadLibrary (name:String, handler:LimeAssetLibrary -> Void):Void {
		
		LimeAssets.loadLibrary (name, handler);
		
	}
	
	
	public static function loadMusic (id:String, handler:Sound -> Void, useCache:Bool = true):Void {
		
		#if !html5
		LimeAssets.loadAudioBuffer (id, function (buffer) {
			
			if (buffer != null) {
				
				#if flash
				handler ((buffer != null) ? buffer.src : null);
				#else
				handler (Sound.fromAudioBuffer (buffer));
				#end
				
			}
			
		}, useCache);
		#else
		handler (getMusic (id, useCache));
		#end
		
	}
	
	
	public static function loadMovieClip (id:String, handler:MovieClip -> Void):Void {
		
		#if (tools && !display)
		
		var libraryName = id.substring (0, id.indexOf (":"));
		var symbolName = id.substr (id.indexOf (":") + 1);
		var library:AssetLibrary = cast getLibrary (libraryName);
		
		if (library != null) {
			
			if (library.exists (symbolName, cast AssetType.MOVIE_CLIP)) {
				
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
		
		#if !html5
		LimeAssets.loadAudioBuffer (id, function (buffer) {
			
			if (buffer != null) {
				
				#if flash
				handler ((buffer != null) ? buffer.src : null);
				#else
				handler (Sound.fromAudioBuffer (buffer));
				#end
				
			}
			
		}, useCache);
		#else
		handler (getSound (id, useCache));
		#end
		
	}
	
	
	public static function loadText (id:String, handler:String -> Void):Void {
		
		LimeAssets.loadText (id, handler);
		
	}
	
	
	public static function registerLibrary (name:String, library:AssetLibrary):Void {
		
		LimeAssets.registerLibrary (name, library);
		
	}
	
	
	public static function removeEventListener (type:String, listener:Dynamic, capture:Bool = false):Void {
		
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
		
		LimeAssets.unloadLibrary (name);
		
	}
	
	
	
	
	// Event Handlers
	
	
	
	
	private static function library_onEvent (library:AssetLibrary, type:String):Void {
		
		if (type == "change") {
			
			cache.clear ();
			dispatchEvent (new Event (Event.CHANGE));
			
		}
		
	}
	
	
}


@:dox(hide) class AssetLibrary extends LimeAssetLibrary {
	
	
	public function new () {
		
		super ();
		
	}
	
	
	public function getMovieClip (id:String):MovieClip {
		
		return null;
		
	}
	
	
	public function getMusic (id:String):Sound {
		
		return getSound (id);
		
	}
	
	
	public function getSound (id:String):Sound {
		
		return null;
		
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
	
	
}


@:dox(hide) class AssetCache {
	
	
	public var bitmapData:Map<String, BitmapData>;
	public var enabled:Bool = true;
	public var font:Map<String, Font>;
	public var sound:Map<String, Sound>;
	
	
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
	
	
}


@:dox(hide) @:enum abstract AssetType(String) {
	
	var BINARY = "BINARY";
	var FONT = "FONT";
	var IMAGE = "IMAGE";
	var MOVIE_CLIP = "MOVIE_CLIP";
	var MUSIC = "MUSIC";
	var SOUND = "SOUND";
	var TEMPLATE = "TEMPLATE";
	var TEXT = "TEXT";
	
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
		
		#if html5
		var fields = embedData (":bitmap", true);
		#else
		var fields = embedData (":bitmap");
		#end
		
		if (fields != null) {
			
			var constructor = macro { 
				
				#if html5
				
				super (0, 0, transparent, fillRGBA);
				
				if (preload != null) {
					
					__image = preload;
					width = __image.width;
					height = __image.height;
					
				} else {
					
					__loadFromBase64 (haxe.Resource.getString (resourceName), resourceType, function (b) {
						
						if (preload == null) {
							
							preload = b.__image;
							
						}
						
						if (onload != null) {
							
							onload (b);
							
						}
						
					});
					
				}
				
				#else
				
				super (width, height, transparent, fillRGBA);
				
				var byteArray = openfl.utils.ByteArray.fromBytes (haxe.Resource.getBytes (resourceName));
				__loadFromBytes (byteArray);
				
				#end
				
			};
			
			var args = [ { name: "width", opt: false, type: macro :Int, value: null }, { name: "height", opt: false, type: macro :Int, value: null }, { name: "transparent", opt: true, type: macro :Bool, value: macro true }, { name: "fillRGBA", opt: true, type: macro :Int, value: macro 0xFFFFFFFF } ];
			
			#if html5
			args.push ({ name: "onload", opt: true, type: macro :Dynamic, value: null });
			fields.push ({ kind: FVar(macro :lime.graphics.Image, null), name: "preload", doc: null, meta: [], access: [ APublic, AStatic ], pos: Context.currentPos() });
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
				
				__fromBytes (haxe.Resource.getBytes (resourceName));
				
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
				
				var byteArray = openfl.utils.ByteArray.fromBytes (haxe.Resource.getBytes (resourceName));
				loadCompressedDataFromByteArray (byteArray, byteArray.length, forcePlayAsMusic);
				
			};
			
			var args = [ { name: "stream", opt: true, type: macro :openfl.net.URLRequest, value: null }, { name: "context", opt: true, type: macro :openfl.media.SoundLoaderContext, value: null }, { name: "forcePlayAsMusic", opt: true, type: macro :Bool, value: macro false } ];
			fields.push ({ name: "new", access: [ APublic ], kind: FFun({ args: args, expr: constructor, params: [], ret: null }), pos: Context.currentPos() });
			
			#end
			
		}
		
		return fields;
		
	}
	
	
}


#end
#else
typedef Assets = openfl._v2.Assets;
#if !macro
typedef AssetLibrary = openfl._v2.Assets.AssetLibrary;
typedef AssetCache = openfl._v2.Assets.AssetCache;
typedef AssetData = openfl._v2.Assets.AssetData;
typedef AssetType = openfl._v2.Assets.AssetType;
#end
#end