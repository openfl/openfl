package openfl;
#if !macro


import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.display.MovieClip;
import flash.media.Sound;
import flash.net.URLRequest;
import flash.text.Font;
import flash.utils.ByteArray;
import haxe.Unserializer;


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
@:access(openfl.AssetLibrary) class Assets {
	
	
	public static var cache = new AssetCache ();
	public static var libraries (default, null) = new Map <String, AssetLibrary> ();
	
	private static var initialized = false;
	
	
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
		
		if (useCache && cache.enabled && cache.bitmapData.exists (id)) {
			
			var bitmapData = cache.bitmapData.get (id);
			
			if (isValidBitmapData (bitmapData)) {
				
				return bitmapData;
				
			}
			
		}
		
		var libraryName = id.substring (0, id.indexOf (":"));
		var symbolName = id.substr (id.indexOf (":") + 1);
		var library = getLibrary (libraryName);
		
		if (library != null) {
			
			if (library.exists (symbolName, IMAGE)) {
				
				var bitmapData = library.getBitmapData (symbolName);
				
				if (useCache && cache.enabled) {
					
					cache.bitmapData.set (id, bitmapData);
					
				}
				
				return bitmapData;
				
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
				
				return library.getBytes (symbolName);
				
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
		
		if (useCache && cache.enabled && cache.font.exists (id)) {
			
			return cache.font.get (id);
			
		}
		
		var libraryName = id.substring (0, id.indexOf (":"));
		var symbolName = id.substr (id.indexOf (":") + 1);
		var library = getLibrary (libraryName);
		
		if (library != null) {
			
			if (library.exists (symbolName, FONT)) {
				
				var font = library.getFont (symbolName);
				
				if (useCache && cache.enabled) {
					
					cache.font.set (id, font);
					
				}
				
				return font;
				
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
				
				return library.getMovieClip (symbolName);
				
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
		
		if (useCache && cache.enabled && cache.sound.exists (id)) {
			
			return cache.sound.get (id);
			
		}
		
		var libraryName = id.substring (0, id.indexOf (":"));
		var symbolName = id.substr (id.indexOf (":") + 1);
		var library = getLibrary (libraryName);
		
		if (library != null) {
			
			if (library.exists (symbolName, SOUND)) {
				
				var sound = library.getSound (symbolName);
				
				if (useCache && cache.enabled) {
					
					cache.sound.set (id, sound);
					
				}
				
				return sound;
				
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
		
		var bytes = getBytes (id);
		
		if (bytes == null) {
			
			return null;
			
		} else {
			
			return bytes.readUTFBytes (bytes.length);
			
		}
		
	}
	
	
	private static function initialize ():Void {
		
		if (!initialized) {
			
			#if (tools && !display)
			
			registerLibrary ("default", new DefaultAssetLibrary ());
			
			#end
			
			initialized = true;
			
		}
		
	}
	
	
	private static function isValidBitmapData (bitmapData:BitmapData):Bool {
		
		#if (cpp || neko)
		
		return (bitmapData.__handle != null);
		
		#elseif flash
		
		try {
			
			bitmapData.width;
			
		} catch (e:Dynamic) {
			
			return false;
			
		}
		
		#end
		
		return true;
		
	}
	
	
	public static function loadBitmapData (id:String, handler:BitmapData -> Void, useCache:Bool = true):Void {
		
		initialize ();
		
		#if (tools && !display)
		
		if (useCache && cache.enabled && cache.bitmapData.exists (id)) {
			
			var bitmapData = cache.bitmapData.get (id);
			
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
						
						cache.bitmapData.set (id, bitmapData);
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
		
		if (useCache && cache.enabled && cache.font.exists (id)) {
			
			handler (cache.font.get (id));
			return;
			
		}
		
		var libraryName = id.substring (0, id.indexOf (":"));
		var symbolName = id.substr (id.indexOf (":") + 1);
		var library = getLibrary (libraryName);
		
		if (library != null) {
			
			if (library.exists (symbolName, FONT)) {
				
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
	
	
	public static function loadLibrary (name:String, handler:AssetLibrary -> Void):Void {
		
		initialize();
		
		#if (tools && !display)
		
		var data = getText ("libraries/" + name + ".dat");
		
		if (data != null && data != "") {
			
			var unserializer = new Unserializer (data);
			unserializer.setResolver (cast { resolveEnum: resolveEnum, resolveClass: resolveClass });
			
			var library:AssetLibrary = unserializer.unserialize ();
			libraries.set (name, library);
			library.load (handler);
			
		} else {
			
			trace ("[openfl.Assets] There is no asset library named \"" + name + "\"");
			
		}
		
		#end
		
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
		
		if (useCache && cache.enabled && cache.sound.exists (id)) {
			
			handler (cache.sound.get (id));
			return;
			
		}
		
		var libraryName = id.substring (0, id.indexOf (":"));
		var symbolName = id.substr (id.indexOf (":") + 1);
		var library = getLibrary (libraryName);
		
		if (library != null) {
			
			if (library.exists (symbolName, SOUND)) {
				
				if (useCache && cache.enabled) {
					
					library.loadSound (symbolName, function (sound:Sound):Void {
						
						cache.sound.set (id, sound);
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
	
	
	public static function registerLibrary (name:String, library:AssetLibrary):Void {
		
		if (libraries.exists (name)) {
			
			unloadLibrary (name);
			
		}
		
		libraries.set (name, library);
		
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
		
		var keys = cache.bitmapData.keys ();
		
		for (key in keys) {
			
			var libraryName = key.substring (0, key.indexOf (":"));
			var symbolName = key.substr (key.indexOf (":") + 1);
			
			if (libraryName == name) {
				
				cache.bitmapData.remove (key);
				
			}
			
		}
		
		libraries.remove (name);
		
		#end
		
	}
	
	
}


class AssetLibrary {
	
	
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
	
	
	public function getPath (id:String):String {
		
		return null;
		
	}
	
	
	public function getSound (id:String):Sound {
		
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
	
	
	public function loadSound (id:String, handler:Sound -> Void):Void {
		
		handler (getSound (id));
		
	}
	
	
}


class AssetCache {
	
	
	public var bitmapData:Map<String, BitmapData>;
	public var enabled:Bool;
	public var font:Map<String, Font>;
	public var sound:Map<String, Sound>;
	
	
	public function new () {
		
		bitmapData = new Map<String, BitmapData> ();
		font = new Map<String, Font> ();
		sound = new Map<String, Sound> ();
		
	}
	
	
	public function clear ():Void {
		
		bitmapData = new Map<String, BitmapData> ();
		font = new Map<String, Font> ();
		sound = new Map<String, Sound> ();
		
	}
	
	
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


import haxe.io.Bytes;
import haxe.macro.Context;
import haxe.macro.Expr;
import haxe.macro.Type;
import haxe.Serializer;
import sys.io.File;


class Assets {
	
	
	macro public static function embedBitmap ():Array<Field> {
		
		var fields = embedData (":bitmap");
		
		if (fields != null) {
			
			var constructor = macro { 
				
				super(width, height, transparent, fillRGBA);
				
				#if html5
				
				var currentType = Type.getClass (this);
				
				if (preload != null) {
					
					_nmeTextureBuffer.width = Std.int (preload.width);
					_nmeTextureBuffer.height = Std.int (preload.height);
					rect = new flash.geom.Rectangle (0, 0, preload.width, preload.height);
					setPixels(rect, preload.getPixels(rect));
					nmeBuildLease();
					
				} else {
					
					var byteArray = flash.utils.ByteArray.fromBytes (haxe.Resource.getBytes(resourceName));
					
					if (onload != null && !Std.is (onload, Bool)) {
						
						nmeLoadFromBytes(byteArray, null, onload);
						
					} else {
						
						nmeLoadFromBytes(byteArray);
						
					}
					
				}
				
				#else
				
				var byteArray = flash.utils.ByteArray.fromBytes (haxe.Resource.getBytes (resourceName));
				__loadFromBytes (byteArray);
				
				#end
				
			};
			
			var args = [ { name: "width", opt: false, type: macro :Int, value: null }, { name: "height", opt: false, type: macro :Int, value: null }, { name: "transparent", opt: true, type: macro :Bool, value: macro true }, { name: "fillRGBA", opt: true, type: macro :Int, value: macro 0xFFFFFFFF } ];
			
			#if html5
			args.push ({ name: "onload", opt: true, type: macro :Dynamic, value: null });
			fields.push ({ kind: FVar(macro :flash.display.BitmapData, null), name: "preload", doc: null, meta: [], access: [ APublic, AStatic ], pos: Context.currentPos() });
			#end
			
			fields.push ({ name: "new", access: [ APublic ], kind: FFun({ args: args, expr: constructor, params: [], ret: null }), pos: Context.currentPos() });
			
		}
		
		return fields;
		
	}
	
	
	private static function embedData (metaName:String):Array<Field> {
		
		var classType = Context.getLocalClass().get();
		var metaData = classType.meta.get();
		var position = Context.currentPos();
		var fields = Context.getBuildFields();
		
		for (meta in metaData) {
			
			if (meta.name == metaName) {
				
				if (meta.params.length > 0) {
					
					switch (meta.params[0].expr) {
						
						case EConst(CString(filePath)):
							
							var path = Context.resolvePath (filePath);
							var bytes = File.getBytes (path);
							var resourceName = "NME_" + metaName + "_" + (classType.pack.length > 0 ? classType.pack.join ("_") + "_" : "") + classType.name;
							
							Context.addResource (resourceName, bytes);
							
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
				
				#if html5
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
				
				var byteArray = flash.utils.ByteArray.fromBytes (haxe.Resource.getBytes(resourceName));
				loadCompressedDataFromByteArray(byteArray, byteArray.length, forcePlayAsMusic);
				
			};
			
			var args = [ { name: "stream", opt: true, type: macro :flash.net.URLRequest, value: null }, { name: "context", opt: true, type: macro :flash.media.SoundLoaderContext, value: null }, { name: "forcePlayAsMusic", opt: true, type: macro :Bool, value: macro false } ];
			fields.push ({ name: "new", access: [ APublic ], kind: FFun({ args: args, expr: constructor, params: [], ret: null }), pos: Context.currentPos() });
			
			#end
			
		}
		
		return fields;
		
	}
	
	
}


#end