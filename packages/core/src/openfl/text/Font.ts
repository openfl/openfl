import FontStyle from "../text/FontStyle";
import FontType from "../text/FontType";
import Assets from "../utils/Assets";
import ByteArray from "../utils/ByteArray";
import Future from "../utils/Future";
import Promise from "../utils/Promise";

/**
	The Font class is used to manage embedded fonts in SWF files. Embedded
	fonts are represented as a subclass of the Font class. The Font class is
	currently useful only to find out information about embedded fonts; you
	cannot alter a font by using this class. You cannot use the Font class to
	load external fonts, or to create an instance of a Font object by itself.
	Use the Font class as an abstract base class.
**/
export default class Font
{
	/** @hidden */
	public ascender: number;

	/** @hidden */
	public descender: number;

	/**
		The name of an embedded font.
	**/
	public fontName: string;

	/**
		The style of the font. This value can be any of the values defined in the
		FontStyle class.
	**/
	public fontStyle: FontStyle;

	/**
		The type of the font. This value can be any of the constants defined in
		the FontType class.
	**/
	public fontType: FontType;

	/** @hidden */ public unitsPerEM: number;

	protected static __fontByName: Map<String, Font> = new Map();
	protected static __registeredFonts: Array<Font> = new Array();

	protected __initialized: boolean;

	public constructor(name: string = null)
	{
		this.fontName = name;
	}

	/**
		Specifies whether to provide a list of the currently available embedded
		fonts.

		@param enumerateDeviceFonts Indicates whether you want to limit the list
									to only the currently available embedded
									fonts. If this is set to `true`
									then a list of all fonts, both device fonts
									and embedded fonts, is returned. If this is
									set to `false` then only a list of
									embedded fonts is returned.
		@return A list of available fonts as an array of Font objects.
	**/
	public static enumerateFonts(enumerateDeviceFonts: boolean = false): Array<Font>
	{
		return Font.__registeredFonts;
	}

	/**
		Creates a new Font from bytes (a haxe.io.Bytes or openfl.utils.ByteArray)
		synchronously. This means that the Font will be returned immediately (if
		supported).

		@param	bytes	A haxe.io.Bytes or openfl.utils.ByteArray instance
		@returns	A new Font if successful, or `null` if unsuccessful
	**/
	public static fromBytes(bytes: ByteArray): Font
	{
		var font = new Font();
		return font;
	}

	/**
		Creates a new Font from a file path synchronously. This means that the
		Font will be returned immediately (if supported).

		@param	path	A local file path containing a font
		@returns	A new Font if successful, or `null` if unsuccessful
	**/
	public static fromFile(path: string): Font
	{
		var font = new Font();
		return font;
	}

	/**
		Specifies whether a provided string can be displayed using the
		currently assigned font.

		@param str The string to test against the current font.
		@return A value of `true` if the specified string can be fully
				displayed using this font.
	**/
	// /** @hidden */ @:dox(hide) public hasGlyphs (str:String):Bool;

	/**
		Creates a new Font from haxe.io.Bytes or openfl.utils.ByteArray data
		asynchronously. The font decoding will occur in the background.
		Progress, completion and error callbacks will be dispatched in the current
		thread using callbacks attached to a returned Future object.

		@param	bytes	A haxe.io.Bytes or openfl.utils.ByteArray instance
		@returns	A Future Font
	**/
	public static loadFromBytes(bytes: ByteArray): Future<Font>
	{
		return Future.withError("Cannot load font from bytes") as Future<Font>;
	}

	/**
		Creates a new Font from a file path or web address asynchronously. The file
		load and font decoding will occur in the background.
		Progress, completion and error callbacks will be dispatched in the current
		thread using callbacks attached to a returned Future object.

		@param	path	A local file path or web address containing a font
		@returns	A Future Font
	**/
	public static loadFromFile(path: string): Future<Font>
	{
		return Future.withError("Cannot load font from file") as Future<Font>;
	}

	/**
		Creates a new Font from a font name asynchronously. This feature should work
		for embedded CSS fonts on the HTML5 target, but is not implemented for
		registered OS fonts on native targets currently. The file
		load and font decoding will occur in the background.
		Progress, completion and error callbacks will be dispatched in the current
		thread using callbacks attached to a returned Future object.

		@param	path	A font name
		@returns	A Future Font
	**/
	public static loadFromName(path: string): Future<Font>
	{
		var font = new Font();
		return font.__loadFromName(path);
	}

	/**
		Registers a font in the global font list.

	**/
	public static registerFont(font: Object): void
	{
		var instance: Font = null;

		if (false /*Type.getClass(font) == null*/)
		{
			// instance = cast(Type.createInstance(font, []), Font);
		}
		else
		{
			instance = font as Font;
		}

		if (instance != null)
		{
			/*if (Reflect.hasField (font, "resourceName")) {

				instance.fontName = __ofResource (Reflect.field (font, "resourceName"));

			}*/

			Font.__registeredFonts.push(instance);
			Font.__fontByName[instance.fontName] = instance;
		}
	}

	protected __initialize(): boolean
	{
		return this.__initialized;
	}

	protected __loadFromName(name: string): Future<Font>
	{
		var promise = new Promise<Font>();
		// this.name = name;
		this.fontName = name;

		var userAgent = navigator.userAgent.toLowerCase();
		var isSafari = (userAgent.indexOf(" safari/") >= 0 && userAgent.indexOf(" chrome/") < 0);
		var isUIWebView = userAgent.match(/(iPhone|iPod|iPad).*AppleWebKit(?!.*Version)/i).length > 0;

		if (!isSafari && !isUIWebView && document["fonts"] && document["fonts"].load)
		{
			document["fonts"].load("1em '" + name + "'").then(function (_)
			{
				promise.complete(this);
			}, () =>
			{
				console.warn("Could not load web font \"" + name + "\"");
				promise.complete(this);
			});
		}
		else
		{
			var node1 = Font.__measureFontNode("'" + name + "', sans-serif");
			var node2 = Font.__measureFontNode("'" + name + "', serif");

			var width1 = node1.offsetWidth;
			var width2 = node2.offsetWidth;

			var interval = -1;
			var timeout = 3000;
			var intervalLength = 50;
			var intervalCount = 0;
			var loaded, timeExpired;

			var checkFont = () =>
			{
				intervalCount++;

				loaded = (node1.offsetWidth != width1 || node2.offsetWidth != width2);
				timeExpired = (intervalCount * intervalLength >= timeout);

				if (loaded || timeExpired)
				{
					window.clearInterval(interval);
					node1.parentNode.removeChild(node1);
					node2.parentNode.removeChild(node2);
					node1 = null;
					node2 = null;

					if (timeExpired)
					{
						console.warn("Could not load web font \"" + name + "\"");
					}

					promise.complete(this);
				}
			}

			interval = window.setInterval(checkFont, intervalLength);
		}

		return promise.future;
	}

	private static __measureFontNode(fontFamily: string): HTMLSpanElement
	{
		var node: HTMLSpanElement = document.createElement("span");
		node.setAttribute("aria-hidden", "true");
		var text = document.createTextNode("BESbswy");
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
		document.body.appendChild(node);
		return node;
	}
}
