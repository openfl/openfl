package openfl._internal.formats.animate;

import haxe.Json;
import openfl.display.MovieClip;
import openfl.events.Event;
import openfl.events.IOErrorEvent;
import openfl.geom.ColorTransform;
import openfl.geom.Matrix;
import openfl.geom.Rectangle;
import openfl.net.URLLoader;
import openfl.net.URLRequest;
import openfl.utils.Assets;
import openfl.utils.AssetLibrary;
import openfl.utils.AssetType;
import openfl.utils.Future;
#if lime
import lime.app.Promise;
import lime.graphics.Image;
import lime.graphics.ImageChannel;
import lime.math.Vector2;
// import lime.utils.AssetLibrary;
import lime.utils.AssetManifest;
#else
import openfl.utils.AssetManifest;
#end

#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end
@:access(openfl._internal.formats.animate.AnimateSpriteSymbol)
@SuppressWarnings("checkstyle:FieldDocComment")
@:keep class AnimateLibrary extends AssetLibrary
{
	private var alphaCheck:Map<String, Bool>;
	private var bitmapClassNames:Map<String, String>;
	private var bitmapSymbols:Array<AnimateBitmapSymbol>;
	private var frameRate:Float;
	private var id:String;
	private var instanceID:String;
	private var preloading:Bool;
	private var root:AnimateSpriteSymbol;
	private var rootPath:String;
	private var symbols:Map<Int, AnimateSymbol>;
	private var symbolsByClassName:Map<String, AnimateSymbol>;
	private var uuid:String;

	public function new(id:String, uuid:String = null)
	{
		super();

		this.id = id;

		instanceID = uuid != null ? uuid : id;

		alphaCheck = new Map();
		bitmapClassNames = new Map();

		#if (ios || tvos)
		rootPath = "assets/";
		#else
		rootPath = "";
		#end

		// Hack to include filter classes, macro.include is not working properly

		// var filter = flash.filters.BlurFilter;
		// var filter = flash.filters.DropShadowFilter;
		// var filter = flash.filters.GlowFilter;
	}

	#if lime
	public override function exists(id:String, type:String):Bool
	{
		if (symbols != null)
		{
			if (id == "" && type == (cast AssetType.MOVIE_CLIP))
			{
				return true;
			}

			if (type == (cast AssetType.IMAGE) || type == (cast AssetType.MOVIE_CLIP))
			{
				return (symbolsByClassName != null && symbolsByClassName.exists(id));
			}
		}

		return super.exists(id, type);
	}
	#end

	#if lime
	public override function getImage(id:String):Image
	{
		if (bitmapClassNames.exists(id))
		{
			id = bitmapClassNames.get(id);
		}

		// TODO: Better system?

		if (!alphaCheck.exists(id))
		{
			for (bitmapSymbol in bitmapSymbols)
			{
				if (bitmapSymbol.path == id && bitmapSymbol.alpha != null)
				{
					var image = super.getImage(id);
					var alpha = super.getImage(bitmapSymbol.alpha);

					__copyChannel(image, alpha);

					cachedImages.set(id, image);
					cachedImages.remove(bitmapSymbol.alpha);
					alphaCheck.set(id, true);

					return image;
				}
			}
			alphaCheck.set(id, true);
		}

		return super.getImage(id);
	}
	#end

	#if lime
	public override function getMovieClip(id:String):MovieClip
	{
		if (symbols == null) return null;

		if (id == "")
		{
			return cast root.__createObject(this);
		}
		else
		{
			var symbol = symbolsByClassName.get(id);
			if (symbol != null)
			{
				if (Std.is(symbol, AnimateSpriteSymbol))
				{
					return cast(symbol, AnimateSpriteSymbol).__createObject(this);
				}
			}
		}

		return null;
	}
	#end

	#if lime
	public override function isLocal(id:String, type:String):Bool
	{
		return true;
	}
	#end

	#if lime
	public override function load():Future<lime.utils.AssetLibrary>
	{
		if (id != null)
		{
			preload.set(id, true);
		}

		var promise = new Promise<lime.utils.AssetLibrary>();
		preloading = true;

		var onComplete = function(data)
		{
			cachedText.set(id, data);

			var json:Dynamic = Json.parse(data);
			var version = json.version;
			frameRate = json.frameRate;
			uuid = json.uuid;
			var rootIndex = json.root;
			var symbolData:Array<Dynamic> = json.symbols;

			var data, type:SWFSymbolType, symbol:AnimateSymbol = null;
			var bitmapSymbol, spriteSymbol;

			symbols = new Map();
			symbolsByClassName = new Map();
			bitmapSymbols = new Array();

			for (i in 0...symbolData.length)
			{
				data = symbolData[i];
				if (data == null) continue;
				type = data.type;

				switch (type)
				{
					case BITMAP:
						bitmapSymbol = __parseBitmap(data);
						bitmapSymbols.push(bitmapSymbol);
						if (bitmapSymbol.className != null) bitmapClassNames.set(bitmapSymbol.className, bitmapSymbol.path);
						symbol = bitmapSymbol;
					case BUTTON: symbol = __parseButton(data);
					case DYNAMIC_TEXT: symbol = __parseDynamicText(data);
					case FONT: symbol = __parseFont(data);
					case SHAPE: symbol = __parseShape(data);
					case SPRITE:
						spriteSymbol = __parseSprite(data);
						if (i == rootIndex) root = spriteSymbol;
						symbol = spriteSymbol;
					case STATIC_TEXT: symbol = __parseStaticText(data);
					default:
				}

				if (symbol == null) continue;
				symbols.set(symbol.id, symbol);
				if (symbol.className != null) symbolsByClassName.set(symbol.className, symbol);
			}

			// SWFLite.instances.set(instanceID, swf);

			__load().onProgress(promise.progress).onError(promise.error).onComplete(function(_)
			{
				preloading = false;
				promise.complete(this);
			});
		}

		if (exists(id, cast AssetType.TEXT) || exists(id, cast AssetType.BINARY))
		{
			#if (js && html5)
			for (id in paths.keys())
			{
				preload.set(id, true);
			}
			#end

			loadText(id).onError(promise.error).onComplete(onComplete);
		}
		else
		{
			for (id in paths.keys())
			{
				preload.set(id, true);
			}

			var path = null;

			if (paths.exists(id))
			{
				path = paths.get(id);
			}
			else
			{
				path = (rootPath != null && rootPath != "") ? rootPath + "/" + id : id;
			}

			var loader = new URLLoader();
			loader.addEventListener(Event.COMPLETE, function(_) onComplete(loader.data));
			loader.addEventListener(IOErrorEvent.IO_ERROR, function(e) promise.error(e));
			loader.load(new URLRequest(path));
		}

		return promise.future;
	}
	#end

	#if lime
	public override function loadImage(id:String):Future<Image>
	{
		if (bitmapClassNames.exists(id))
		{
			id = bitmapClassNames.get(id);
		}

		if (#if (swf_preload || swflite_preload) true #else !preloading #end && !alphaCheck.exists(id))
		{
			for (bitmapSymbol in bitmapSymbols)
			{
				if (bitmapSymbol.path == id && bitmapSymbol.alpha != null)
				{
					var promise = new Promise<Image>();

					__loadImage(id).onError(promise.error)
						.onComplete(function(image)
						{
							__loadImage(bitmapSymbol.alpha)
								.onError(promise.error)
								.onComplete(function(alpha)
								{
									__copyChannel(image, alpha);

									cachedImages.set(id, image);
									cachedImages.remove(bitmapSymbol.alpha);
									alphaCheck.set(id, true);

									promise.complete(image);
								});
						});

					return promise.future;
				}
				else
				{
					alphaCheck.set(id, true);
				}
			}
		}

		return super.loadImage(id);
	}
	#end

	#if lime
	public override function unload():Void
	{
		if (symbols == null) return;
		// if (swf == null) return;

		// if (SWFLite.instances.exists(instanceID) && SWFLite.instances.get(instanceID) == swf)
		// {
		// 	SWFLite.instances.remove(instanceID);
		// }

		for (bitmapSymbol in bitmapSymbols)
		{
			Assets.cache.removeBitmapData(bitmapSymbol.path);
		}
	}
	#end

	#if lime
	private function __copyChannel(image:Image, alpha:Image):Void
	{
		if (alpha != null)
		{
			image.copyChannel(alpha, alpha.rect, new Vector2(), ImageChannel.RED, ImageChannel.ALPHA);
		}

		image.buffer.premultiplied = true;

		#if !sys
		image.premultiplied = false;
		#end
	}
	#end

	#if lime
	private override function __fromManifest(manifest:AssetManifest):Void
	{
		rootPath = manifest.rootPath;
		super.__fromManifest(manifest);

		bytesTotal = 0;

		for (id in paths.keys())
		{
			bytesTotal += sizes.get(id);
		}
	}
	#end

	#if lime
	private function __load():Future<lime.utils.AssetLibrary>
	{
		return super.load();
	}
	#end

	#if lime
	private function __loadImage(id:String):Future<Image>
	{
		return super.loadImage(id);
	}
	#end

	private function __parseBitmap(data:Dynamic):AnimateBitmapSymbol
	{
		var symbol = new AnimateBitmapSymbol();
		symbol.id = data.id;
		symbol.className = data.className;
		symbol.alpha = data.alpha;
		symbol.path = data.path;
		symbol.smooth = data.smooth;
		return symbol;
	}

	private function __parseButton(data:Dynamic):AnimateButtonSymbol
	{
		var symbol = new AnimateButtonSymbol();
		symbol.id = data.id;
		symbol.className = data.className;
		// TODO: Should these be references?
		symbol.downState = __parseSprite(data.downState);
		symbol.hitState = __parseSprite(data.hitState);
		symbol.overState = __parseSprite(data.overState);
		symbol.upState = __parseSprite(data.upState);
		return symbol;
	}

	private function __parseDynamicText(data:Dynamic):AnimateDynamicTextSymbol
	{
		var symbol = new AnimateDynamicTextSymbol();
		symbol.id = data.id;
		symbol.align = data.align;
		symbol.border = data.border;
		symbol.color = data.color;
		symbol.fontHeight = data.fontHeight;
		symbol.fontID = data.fontID;
		symbol.fontName = data.fontName;
		symbol.height = __pixel(data.bounds[3]);
		symbol.html = data.html;
		symbol.indent = data.indent;
		symbol.input = data.input;
		symbol.leading = data.leading;
		symbol.leftMargin = data.leftMargin;
		symbol.multiline = data.multiline;
		symbol.password = data.password;
		symbol.rightMargin = data.rightMargin;
		symbol.selectable = data.selectable;
		symbol.text = data.text;
		symbol.width = __pixel(data.bounds[2]);
		symbol.wordWrap = data.wordWrap;
		symbol.x = __pixel(data.bounds[0]);
		symbol.y = __pixel(data.bounds[1]);
		return symbol;
	}

	private function __parseFont(data:Dynamic):AnimateFontSymbol
	{
		var symbol = new AnimateFontSymbol();
		symbol.id = data.id;
		symbol.advances = data.advances;
		symbol.ascent = data.ascent;
		symbol.bold = data.bold;
		symbol.codes = data.codes;
		symbol.descent = data.descent;
		symbol.glyphs = data.glyphs;
		symbol.italic = data.italic;
		symbol.leading = data.leading;
		symbol.name = data.name;
		return symbol;
	}

	private function __parseShape(data:Dynamic):AnimateShapeSymbol
	{
		var symbol = new AnimateShapeSymbol();
		symbol.id = data.id;
		symbol.commands = data.commands;
		return symbol;
	}

	private function __parseSprite(data:Dynamic):AnimateSpriteSymbol
	{
		var symbol = new AnimateSpriteSymbol();
		symbol.id = data.id;
		symbol.className = data.className;
		symbol.baseClassName = data.baseClassName;
		symbol.scale9Grid = data.scale9Grid != null ? new Rectangle(__pixel(data.scale9Grid[0]), __pixel(data.scale9Grid[0]), __pixel(data.scale9Grid[0]), __pixel(data.scale9Grid[0])) : null;
		var frames:Array<Dynamic> = data.frames;
		var frame:AnimateFrame, objects:Array<Dynamic>, object:AnimateFrameObject;
		for (frameData in frames)
		{
			frame = new AnimateFrame();
			frame.label = frameData.label;
			// frame.script = frameData.script;
			// frame.scriptSource = frameData.scriptSource;
			objects = frameData.objects;
			if (objects != null && objects.length > 0)
			{
				frame.objects = [];
				for (objectData in objects)
				{
					object = new AnimateFrameObject();
					object.blendMode = objectData.blendMode;
					object.cacheAsBitmap = objectData.cacheAsBitmap;
					object.clipDepth = objectData.clipDepth;
					object.colorTransform = objectData.colorTransform != null ? new ColorTransform(__pixel(objectData.colorTransform[0]), __pixel(objectData.colorTransform[1]), __pixel(objectData.colorTransform[2]), __pixel(objectData.colorTransform[3]), __pixel(objectData.colorTransform[4]), __pixel(objectData.colorTransform[5]), __pixel(objectData.colorTransform[6]), __pixel(objectData.colorTransform[7])) : null;
					object.depth = objectData.depth;
					object.filters = objectData.filters;
					object.id = objectData.id;
					object.matrix = objectData.matrix != null ? new Matrix(__pixel(objectData.matrix[0]), __pixel(objectData.matrix[1]), __pixel(objectData.matrix[2]), __pixel(objectData.matrix[3]), __pixel(objectData.matrix[4]), __pixel(objectData.matrix[5])) : null;
					object.name = objectData.name;
					object.symbol = objectData.symbol;
					object.type = objectData.type;
					object.visible = objectData.visible;
					frame.objects.push(object);
				}
			}
			symbol.frames.push(frame);
		}
		return symbol;
	}

	private function __parseStaticText(data:Dynamic):AnimateStaticTextSymbol
	{
		var symbol = new AnimateStaticTextSymbol();
		symbol.id = data.id;
		symbol.matrix = new Matrix(__pixel(data.matrix[0]), __pixel(data.matrix[1]), __pixel(data.matrix[2]), __pixel(data.matrix[3]), __pixel(data.matrix[4]), __pixel(data.matrix[5]));
		symbol.records = data.records;
		return symbol;
	}

	private inline function __pixel(value:Int):Float
	{
		return value / 20;
	}
}

@:enum abstract SWFSymbolType(Int) from Int to Int
{
	public var BITMAP = 0;
	public var BUTTON = 1;
	public var DYNAMIC_TEXT = 2;
	public var FONT = 3;
	public var SHAPE = 4;
	public var SPRITE = 5;
	public var STATIC_TEXT = 6;
}