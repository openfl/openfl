package openfl._internal.backend.lime_standalone;

package lime.text;

import haxe.io.Bytes;
import lime._internal.backend.native.NativeCFFI;
import lime.app.Future;
import lime.app.Promise;
import lime.graphics.Image;
import lime.graphics.ImageBuffer;
import lime.math.Vector2;
import lime.system.System;
import lime.utils.Assets;
import lime.utils.Log;
import lime.utils.UInt8Array;
#if (js && html5)
import js.html.CanvasElement;
import js.html.CanvasRenderingContext2D;
import js.html.SpanElement;
import js.Browser;
#end
#if (lime_cffi && !macro)
import haxe.io.Path;
#end

#if !lime_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end
#if (!display && !flash && !nodejs && !macro)
@:autoBuild(lime._internal.macros.AssetsMacro.embedFont())
#end
@:access(lime._internal.backend.native.NativeCFFI)
@:access(lime.text.Glyph)
class Font
{
	public var ascender:Int;
	public var descender:Int;
	public var height:Int;
	public var name(default, null):String;
	public var numGlyphs:Int;
	public var src:Dynamic;
	public var underlinePosition:Int;
	public var underlineThickness:Int;
	public var unitsPerEM:Int;

	@:noCompletion private var __fontID:String;
	@:noCompletion private var __fontPath:String;
	#if lime_cffi
	@:noCompletion private var __fontPathWithoutDirectory:String;
	#end
	@:noCompletion private var __init:Bool;

	public function new(name:String = null)
	{
		if (name != null)
		{
			this.name = name;
		}

		if (!__init)
		{
			#if js if (ascender == untyped __js__("undefined")) #end ascender = 0;
			#if js
			if (descender == untyped __js__("undefined"))
			#end
			descender = 0;
			#if js
			if (height == untyped __js__("undefined"))
			#end
			height = 0;
			#if js
			if (numGlyphs == untyped __js__("undefined"))
			#end
			numGlyphs = 0;
			#if js
			if (underlinePosition == untyped __js__("undefined"))
			#end
			underlinePosition = 0;
			#if js
			if (underlineThickness == untyped __js__("undefined"))
			#end
			underlineThickness = 0;
			#if js
			if (unitsPerEM == untyped __js__("undefined"))
			#end
			unitsPerEM = 0;

			if (__fontID != null)
			{
				if (Assets.isLocal(__fontID))
				{
					__fromBytes(Assets.getBytes(__fontID));
				}
			}
			else if (__fontPath != null)
			{
				__fromFile(__fontPath);
			}
		}
	}

	public function decompose():NativeFontData
	{
		#if (lime_cffi && !macro)
		if (src == null) throw "Uninitialized font handle.";
		var data:Dynamic = NativeCFFI.lime_font_outline_decompose(src, 1024 * 20);
		#if hl
		if (data != null)
		{
			data.family_name = @:privateAccess String.fromUCS2(data.family_name);
			data.style_name = @:privateAccess String.fromUTF8(data.style_name);
		}
		#end
		return data;
		#else
		return null;
		#end
	}

	public static function fromBytes(bytes:Bytes):Font
	{
		if (bytes == null) return null;

		var font = new Font();
		font.__fromBytes(bytes);

		#if (lime_cffi && !macro)
		return (font.src != null) ? font : null;
		#else
		return font;
		#end
	}

	public static function fromFile(path:String):Font
	{
		if (path == null) return null;

		var font = new Font();
		font.__fromFile(path);

		#if (lime_cffi && !macro)
		return (font.src != null) ? font : null;
		#else
		return font;
		#end
	}

	public static function loadFromBytes(bytes:Bytes):Future<Font>
	{
		return Future.withValue(fromBytes(bytes));
	}

	public static function loadFromFile(path:String):Future<Font>
	{
		var request = new HTTPRequest<Font>();
		return request.load(path).then(function(font)
		{
			if (font != null)
			{
				return Future.withValue(font);
			}
			else
			{
				return cast Future.withError("");
			}
		});
	}

	public static function loadFromName(path:String):Future<Font>
	{
		#if (js && html5)
		var font = new Font();
		return font.__loadFromName(path);
		#else
		return cast Future.withError("");
		#end
	}

	public function getGlyph(character:String):Glyph
	{
		#if (lime_cffi && !macro)
		return NativeCFFI.lime_font_get_glyph_index(src, character);
		#else
		return -1;
		#end
	}

	public function getGlyphs(characters:String = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789!@#$%^`'\"/\\&*()[]{}<>|:;_-+=?,. "):Array<Glyph>
	{
		#if (lime_cffi && !macro)
		var glyphs:Dynamic = NativeCFFI.lime_font_get_glyph_indices(src, characters);
		return glyphs;
		#else
		return null;
		#end
	}

	public function getGlyphMetrics(glyph:Glyph):GlyphMetrics
	{
		#if (lime_cffi && !macro)
		var value:Dynamic = NativeCFFI.lime_font_get_glyph_metrics(src, glyph);
		var metrics = new GlyphMetrics();

		metrics.advance = new Vector2(value.horizontalAdvance, value.verticalAdvance);
		metrics.height = value.height;
		metrics.horizontalBearing = new Vector2(value.horizontalBearingX, value.horizontalBearingY);
		metrics.verticalBearing = new Vector2(value.verticalBearingX, value.verticalBearingY);

		return metrics;
		#else
		return null;
		#end
	}

	public function renderGlyph(glyph:Glyph, fontSize:Int):Image
	{
		#if (lime_cffi && !macro)
		__setSize(fontSize);

		var bytes = Bytes.alloc(0);
		// bytes.endian = (System.endianness == BIG_ENDIAN ? "bigEndian" : "littleEndian");

		var dataPosition = 0;
		bytes = NativeCFFI.lime_font_render_glyph(src, glyph, bytes);

		if (bytes != null && bytes.length > 0)
		{
			var index = bytes.getInt32(dataPosition);
			dataPosition += 4;
			var width = bytes.getInt32(dataPosition);
			dataPosition += 4;
			var height = bytes.getInt32(dataPosition);
			dataPosition += 4;
			var x = bytes.getInt32(dataPosition);
			dataPosition += 4;
			var y = bytes.getInt32(dataPosition);
			dataPosition += 4;

			var data = bytes.sub(dataPosition, width * height);
			dataPosition += (width * height);

			var buffer = new ImageBuffer(new UInt8Array(data), width, height, 8);
			var image = new Image(buffer, 0, 0, width, height);
			image.x = x;
			image.y = y;

			return image;
		}
		#end

		return null;
	}

	public function renderGlyphs(glyphs:Array<Glyph>, fontSize:Int):Map<Glyph, Image>
	{
		#if (lime_cffi && !macro)
		var uniqueGlyphs = new Map<Int, Bool>();

		for (glyph in glyphs)
		{
			uniqueGlyphs.set(glyph, true);
		}

		var glyphList = [];

		for (key in uniqueGlyphs.keys())
		{
			glyphList.push(key);
		}

		#if hl
		var _glyphList = new hl.NativeArray<Glyph>(glyphList.length);

		for (i in 0...glyphList.length)
		{
			_glyphList[i] = glyphList[i];
		}

		var glyphList = _glyphList;
		#end

		NativeCFFI.lime_font_set_size(src, fontSize);

		var bytes = Bytes.alloc(0);
		bytes = NativeCFFI.lime_font_render_glyphs(src, glyphList, bytes);

		if (bytes != null && bytes.length > 0)
		{
			var bytesPosition = 0;
			var count = bytes.getInt32(bytesPosition);
			bytesPosition += 4;

			var bufferWidth = 128;
			var bufferHeight = 128;
			var offsetX = 0;
			var offsetY = 0;
			var maxRows = 0;

			var width, height;
			var i = 0;

			while (i < count)
			{
				bytesPosition += 4;
				width = bytes.getInt32(bytesPosition);
				bytesPosition += 4;
				height = bytes.getInt32(bytesPosition);
				bytesPosition += 4;

				bytesPosition += (4 * 2) + width * height;

				if (offsetX + width > bufferWidth)
				{
					offsetY += maxRows + 1;
					offsetX = 0;
					maxRows = 0;
				}

				if (offsetY + height > bufferHeight)
				{
					if (bufferWidth < bufferHeight)
					{
						bufferWidth *= 2;
					}
					else
					{
						bufferHeight *= 2;
					}

					offsetX = 0;
					offsetY = 0;
					maxRows = 0;

					// TODO: make this better

					bytesPosition = 4;
					i = 0;
					continue;
				}

				offsetX += width + 1;

				if (height > maxRows)
				{
					maxRows = height;
				}

				i++;
			}

			var map = new Map<Int, Image>();
			var buffer = new ImageBuffer(null, bufferWidth, bufferHeight, 8);
			var dataPosition = 0;
			var data = Bytes.alloc(bufferWidth * bufferHeight);

			bytesPosition = 4;
			offsetX = 0;
			offsetY = 0;
			maxRows = 0;

			var index, x, y, image;

			for (i in 0...count)
			{
				index = bytes.getInt32(bytesPosition);
				bytesPosition += 4;
				width = bytes.getInt32(bytesPosition);
				bytesPosition += 4;
				height = bytes.getInt32(bytesPosition);
				bytesPosition += 4;
				x = bytes.getInt32(bytesPosition);
				bytesPosition += 4;
				y = bytes.getInt32(bytesPosition);
				bytesPosition += 4;

				if (offsetX + width > bufferWidth)
				{
					offsetY += maxRows + 1;
					offsetX = 0;
					maxRows = 0;
				}

				for (i in 0...height)
				{
					dataPosition = ((i + offsetY) * bufferWidth) + offsetX;
					data.blit(dataPosition, bytes, bytesPosition, width);
					bytesPosition += width;
				}

				image = new Image(buffer, offsetX, offsetY, width, height);
				image.x = x;
				image.y = y;

				map.set(index, image);

				offsetX += width + 1;

				if (height > maxRows)
				{
					maxRows = height;
				}
			}

			#if js
			buffer.data = data.byteView;
			#else
			buffer.data = new UInt8Array(data);
			#end

			return map;
		}
		#end

		return null;
	}

	@:noCompletion private function __copyFrom(other:Font):Void
	{
		if (other != null)
		{
			ascender = other.ascender;
			descender = other.descender;
			height = other.height;
			name = other.name;
			numGlyphs = other.numGlyphs;
			src = other.src;
			underlinePosition = other.underlinePosition;
			underlineThickness = other.underlineThickness;
			unitsPerEM = other.unitsPerEM;

			__fontID = other.__fontID;
			__fontPath = other.__fontPath;

			#if lime_cffi
			__fontPathWithoutDirectory = other.__fontPathWithoutDirectory;
			#end

			__init = true;
		}
	}

	@:noCompletion private function __fromBytes(bytes:Bytes):Void
	{
		__fontPath = null;

		#if (lime_cffi && !macro)
		__fontPathWithoutDirectory = null;

		src = NativeCFFI.lime_font_load_bytes(bytes);

		__initializeSource();
		#end
	}

	@:noCompletion private function __fromFile(path:String):Void
	{
		__fontPath = path;

		#if (lime_cffi && !macro)
		__fontPathWithoutDirectory = Path.withoutDirectory(__fontPath);

		src = NativeCFFI.lime_font_load_file(__fontPath);

		__initializeSource();
		#end
	}

	@:noCompletion private function __initializeSource():Void
	{
		#if (lime_cffi && !macro)
		if (src != null)
		{
			if (name == null)
			{
				#if hl
				name = @:privateAccess String.fromUTF8(NativeCFFI.lime_font_get_family_name(src));
				#else
				name = cast NativeCFFI.lime_font_get_family_name(src);
				#end
			}

			ascender = NativeCFFI.lime_font_get_ascender(src);
			descender = NativeCFFI.lime_font_get_descender(src);
			height = NativeCFFI.lime_font_get_height(src);
			numGlyphs = NativeCFFI.lime_font_get_num_glyphs(src);
			underlinePosition = NativeCFFI.lime_font_get_underline_position(src);
			underlineThickness = NativeCFFI.lime_font_get_underline_thickness(src);
			unitsPerEM = NativeCFFI.lime_font_get_units_per_em(src);
		}
		#end

		__init = true;
	}

	@:noCompletion private function __loadFromName(name:String):Future<Font>
	{
		var promise = new Promise<Font>();

		#if (js && html5)
		this.name = name;

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
		#else
		promise.error("");
		#end

		return promise.future;
	}

	#if (js && html5)
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

	@:noCompletion private function __setSize(size:Int):Void
	{
		#if (lime_cffi && !macro)
		NativeCFFI.lime_font_set_size(src, size);
		#end
	}
}

typedef NativeFontData =
{
	var has_kerning:Bool;
	var is_fixed_width:Bool;
	var has_glyph_names:Bool;
	var is_italic:Bool;
	var is_bold:Bool;
	var num_glyphs:Int;
	var family_name:String;
	var style_name:String;
	var em_size:Int;
	var ascend:Int;
	var descend:Int;
	var height:Int;
	var glyphs:Array<NativeGlyphData>;
	var kerning:Array<NativeKerningData>;
}

typedef NativeGlyphData =
{
	var char_code:Int;
	var advance:Int;
	var min_x:Int;
	var max_x:Int;
	var min_y:Int;
	var max_y:Int;
	var points:Array<Int>;
}

typedef NativeKerningData =
{
	var left_glyph:Int;
	var right_glyph:Int;
	var x:Int;
	var y:Int;
}
