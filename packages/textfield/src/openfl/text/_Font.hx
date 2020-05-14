package openfl.text;

import openfl._internal.utils.Log;
import openfl.utils.Assets;
import openfl.utils.ByteArray;
import openfl.utils.Future;
import openfl.utils.Promise;
#if lime
import lime.text.Font as LimeFont;
#end
#if openfl_html5
import js.html.SpanElement;
import js.Browser;
#end

#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end
@:access(lime.text.Font) // TODO: No private access
@:access(openfl.text.Font)
@:noCompletion
class _Font
{
	public var fontName(get, set):String;
	public var fontStyle:FontStyle;
	public var fontType:FontType;
	public var limeFont:LimeFont;

	public static var __fontByName:Map<String, Font> = new Map();
	public static var __registeredFonts:Array<Font> = new Array();

	private var __initialized:Bool;
	private var font:Font;

	public function new(font:Font)
	{
		this.font = font;
		#if lime
		limeFont = new LimeFont();
		#end
	}

	public static function enumerateFonts(enumerateDeviceFonts:Bool = false):Array<Font>
	{
		return __registeredFonts;
	}

	public static function fromBytes(bytes:ByteArray):Font
	{
		var font = new Font();
		#if lime
		font._.limeFont.__fromBytes(bytes);
		#end

		#if lime_cffi
		return (font._.limeFont.src != null) ? font : null;
		#else
		return font;
		#end
	}

	public static function fromFile(path:String):Font
	{
		var font = new Font();
		#if lime
		font.limeFont.__fromFile(path);
		#end

		#if lime_cffi
		return (font.limeFont.src != null) ? font : null;
		#else
		return font;
		#end
	}

	public static function fromLimeFont(limeFont:LimeFont):Font
	{
		var font = new Font();
		font._.__fromLimeFont(limeFont);
		return font;
	}

	public static function loadFromBytes(bytes:ByteArray):Future<Font>
	{
		#if lime
		return LimeFont.loadFromBytes(bytes).then(function(limeFont)
		{
			var font = new Font();
			font._.__fromLimeFont(limeFont);

			return Future.withValue(font);
		});
		#else
		return cast Future.withError("Cannot load font from bytes");
		#end
	}

	public static function loadFromFile(path:String):Future<Font>
	{
		#if lime
		return LimeFont.loadFromFile(path).then(function(limeFont)
		{
			var font = new Font();
			font._.__fromLimeFont(limeFont);

			return Future.withValue(font);
		});
		#else
		return cast Future.withError("Cannot load font from file");
		#end
	}

	public static function loadFromName(path:String):Future<Font>
	{
		#if (!lime && openfl_html5)
		var font = new Font();
		return font._.__loadFromName(path);
		#elseif lime
		return LimeFont.loadFromName(path).then(function(limeFont)
		{
			var font = new Font();
			font._.__fromLimeFont(limeFont);

			return Future.withValue(font);
		});
		#else
		return cast Future.withError("Cannot load font from name");
		#end
	}

	public static function registerFont(font:Dynamic):Void
	{
		var instance:Font = null;

		if (Type.getClass(font) == null)
		{
			instance = cast(Type.createInstance(font, []), Font);
		}
		else
		{
			instance = cast(font, Font);
		}

		if (instance != null)
		{
			/*if (Reflect.hasField (font, "resourceName")) {

				instance.fontName = __ofResource (Reflect.field (font, "resourceName"));

			}*/

			__registeredFonts.push(instance);
			__fontByName[instance.fontName] = instance;
		}
	}

	#if lime
	public function __fromLimeFont(font:LimeFont):Void
	{
		this.font.limeFont.__copyFrom(font);
	}
	#end

	public function __initialize():Bool
	{
		#if native
		if (!__initialized)
		{
			if (limeFont.src != null)
			{
				// TODO: How does src get defined without being initialized in Lime?
				if (limeFont.unitsPerEM == 0) limeFont.__initializeSource();
				__initialized = true;
			}
			else if (limeFont.src == null && limeFont.__fontID != null && Assets.isLocal(limeFont.__fontID))
			{
				limeFont.__fromBytes(Assets.getBytes(limeFont.__fontID));
				__initialized = true;
			}
		}
		#end

		return __initialized;
	}

	#if (!lime && openfl_html5)
	private function __loadFromName(name:String):Future<Font>
	{
		var promise = new Promise<Font>();
		// this.name = name;
		this.fontName = name;

		var userAgent = Browser.navigator.userAgent.toLowerCase();
		var isSafari = (userAgent.indexOf(" safari/") >= 0 && userAgent.indexOf(" chrome/") < 0);
		var isUIWebView = ~/(iPhone|iPod|iPad).*AppleWebKit(?!.*Version)/i.match(userAgent);

		if (!isSafari && !isUIWebView && untyped (Browser.document).fonts && untyped (Browser.document).fonts.load)
		{
			untyped (Browser.document).fonts.load("1em '" + name + "'").then(function(_)
			{
				promise.complete(this);
			}, function(_)
			{
				Log.warn("Could not load web font \"" + name + "\"");
				promise.complete(this);
			});
		}
		else
		{
			var node1 = __measureFontNode("'" + name + "', sans-serif");
			var node2 = __measureFontNode("'" + name + "', serif");

			var width1 = node1.offsetWidth;
			var width2 = node2.offsetWidth;

			var interval = -1;
			var timeout = 3000;
			var intervalLength = 50;
			var intervalCount = 0;
			var loaded, timeExpired;

			var checkFont = function()
			{
				intervalCount++;

				loaded = (node1.offsetWidth != width1 || node2.offsetWidth != width2);
				timeExpired = (intervalCount * intervalLength >= timeout);

				if (loaded || timeExpired)
				{
					Browser.window.clearInterval(interval);
					node1.parentNode.removeChild(node1);
					node2.parentNode.removeChild(node2);
					node1 = null;
					node2 = null;

					if (timeExpired)
					{
						Log.warn("Could not load web font \"" + name + "\"");
					}

					promise.complete(this);
				}
			}

			interval = Browser.window.setInterval(checkFont, intervalLength);
		}

		return promise.future;
	}

	private static function __measureFontNode(fontFamily:String):SpanElement
	{
		var node:SpanElement = cast Browser.document.createElement("span");
		node.setAttribute("aria-hidden", "true");
		var text = Browser.document.createTextNode("BESbswy");
		node.appendChild(text);
		var style = node.style;
		style.display = "block";
		style.position = "absolute";
		style.top = "-9999px";
		style.left = "-9999px";
		style.fontSize = "300px";
		style.width = "auto";
		style.height = "auto";
		style.lineHeight = "normal";
		style.margin = "0";
		style.padding = "0";
		style.fontVariant = "normal";
		style.whiteSpace = "nowrap";
		style.fontFamily = fontFamily;
		Browser.document.body.appendChild(node);
		return node;
	}
	#end

	// Get & Set Methods
	private inline function get_fontName():String
	{
		#if lime
		return limeFont.name;
		#else
		return null;
		#end
	}

	private inline function set_fontName(value:String):String
	{
		#if lime
		return limeFont.name = value;
		#else
		return value;
		#end
	}
}
