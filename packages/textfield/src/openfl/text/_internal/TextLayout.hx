package openfl.text._internal;

import haxe.io.Bytes;
#if lime
import lime.math.Vector2;
import lime.text.harfbuzz.HBBuffer;
import lime.text.harfbuzz.HBBufferClusterLevel;
import lime.text.harfbuzz.HBDirection;
import lime.text.harfbuzz.HBFTFont;
import lime.text.harfbuzz.HBLanguage;
import lime.text.harfbuzz.HBScript;
import lime.text.harfbuzz.HB;
import lime.text.Font;
import lime.text.Glyph;
#else
import openfl.text.Font;
#end

#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end
@SuppressWarnings("checkstyle:FieldDocComment")
class TextLayout
{
	private static inline var FT_LOAD_DEFAULT:Int = 0;
	private static inline var FT_LOAD_NO_SCALE:Int = 1;
	private static inline var FT_LOAD_NO_HINTING:Int = 2;
	private static inline var FT_LOAD_RENDER:Int = 4;
	private static inline var FT_LOAD_NO_BITMAP:Int = 8;
	private static inline var FT_LOAD_VERTICAL_LAYOUT:Int = 16;
	private static inline var FT_LOAD_FORCE_AUTOHINT:Int = 32;
	private static inline var FT_LOAD_CROP_BITMAP:Int = 64;
	private static inline var FT_LOAD_PEDANTIC:Int = 128;
	private static inline var FT_LOAD_IGNORE_GLOBAL_ADVANCE_WIDTH:Int = 256;
	private static inline var FT_LOAD_NO_RECURSE:Int = 512;
	private static inline var FT_LOAD_IGNORE_TRANSFORM:Int = 1024;
	private static inline var FT_LOAD_MONOCHROME:Int = 2048;
	private static inline var FT_LOAD_LINEAR_DESIGN:Int = 4096;
	private static inline var FT_LOAD_NO_AUTOHINT:Int = 8192;
	private static inline var FT_LOAD_COLOR:Int = 16384;
	private static inline var FT_LOAD_COMPUTE_METRICS:Int = 32768;
	private static inline var FT_LOAD_BITMAP_METRICS_ONLY:Int = 65536;
	// define FT_LOAD_TARGET_( x )   ( (FT_Int32)( (x) & 15 ) << 16 )
	private static inline var FT_LOAD_TARGET_NORMAL:Int = (0 & 15) << 16; // FT_LOAD_TARGET_( FT_RENDER_MODE_NORMAL )
	private static inline var FT_LOAD_TARGET_LIGHT:Int = ((((0 & 15) << 16) & 15) << 16); //  FT_LOAD_TARGET_( FT_RENDER_MODE_LIGHT  )

	// private static inline var FT_LOAD_TARGET_MONO    FT_LOAD_TARGET_( FT_RENDER_MODE_MONO   )
	// private static inline var FT_LOAD_TARGET_LCD     FT_LOAD_TARGET_( FT_RENDER_MODE_LCD    )
	// private static inline var FT_LOAD_TARGET_LCD_V   FT_LOAD_TARGET_( FT_RENDER_MODE_LCD_V  )
	public var autoHint:Bool;
	public var direction(get, set):TextDirection;
	public var font(default, set):Font;
	@SuppressWarnings("checkstyle:Dynamic") public var glyphs(get, null):Array<#if lime Glyph #else Dynamic #end>;
	public var language(get, set):String;
	public var letterSpacing:Float = 0;
	@:isVar public var positions(get, null):Array<GlyphPosition>;
	public var script(get, set):TextScript;
	public var size(default, set):Int;
	public var text(default, set):String;

	private var __buffer:Bytes;
	private var __direction:TextDirection;
	private var __dirty:Bool;
	@SuppressWarnings("checkstyle:Dynamic") private var __handle:Dynamic;
	private var __language:String;
	private var __script:TextScript;
	private var __font:Font;
	@SuppressWarnings("checkstyle:Dynamic") private var __hbBuffer:#if lime HBBuffer #else Dynamic #end;
	@SuppressWarnings("checkstyle:Dynamic") private var __hbFont:#if lime HBFTFont #else Dynamic #end;

	public function new(text:String = "", font:Font = null, size:Int = 12, direction:TextDirection = LEFT_TO_RIGHT, script:TextScript = COMMON,
			language:String = "en")
	{
		this.text = text;
		this.font = font;
		this.size = size;
		__direction = direction;
		__script = script;
		__language = language;

		positions = [];
		__dirty = true;

		__create(__direction, __script, __language);
	}

	private function __create(direction:TextDirection, script:TextScript, language:String):Void
	{
		if (language.length != 4) return;

		#if lime
		__hbBuffer = new HBBuffer();
		__hbBuffer.direction = direction.toHBDirection();
		__hbBuffer.script = script.toHBScript();
		__hbBuffer.language = new HBLanguage(language);
		#end
	}

	@:noCompletion private function __position():Void
	{
		positions = [];

		#if (lime && lime_cffi && !macro)
		if (text != null && text != "" && font != null && font.src != null)
		{
			if (__buffer == null)
			{
				__buffer = Bytes.alloc(text.length * 5);
				// __buffer.endian = (System.endianness == BIG_ENDIAN ? "bigEndian" : "littleEndian");
			}

			if (__font != font)
			{
				__font = font;
				// 	hb_font_destroy ((hb_font_t*)mHBFont);
				@:privateAccess font.__setSize(size);
				__hbFont = new HBFTFont(font);

				if (autoHint)
				{
					__hbFont.loadFlags = FT_LOAD_FORCE_AUTOHINT | FT_LOAD_TARGET_LIGHT;
				}
			}
			else
			{
				@:privateAccess font.__setSize(size);
			}

			if (__hbBuffer == null)
			{
				__hbBuffer = new HBBuffer();
			}
			else
			{
				__hbBuffer.reset();
			}

			__hbBuffer.direction = direction.toHBDirection();
			__hbBuffer.script = script.toHBScript();
			__hbBuffer.language = new HBLanguage(language);
			__hbBuffer.clusterLevel = HBBufferClusterLevel.CHARACTERS;
			#if (neko || mac)
			// other targets still uses dummy positions to make UTF8 work
			// TODO: confirm
			__hbBuffer.addUTF8(text, 0, -1);
			#elseif (hl)
			__hbBuffer.addUTF16(text, text.length, 0, -1);
			#else
			__hbBuffer.addUTF16(untyped __cpp__('(uintptr_t){0}', text.wc_str()), text.length, 0, -1);
			#end

			HB.shape(__hbFont, __hbBuffer);

			var _info = __hbBuffer.getGlyphInfo();
			var _positions = __hbBuffer.getGlyphPositions();

			if (_info != null && _positions != null)
			{
				var info, position;
				var lastCluster = -1;

				var length = Std.int(Math.min(_info.length, _positions.length));

				for (i in 0...length)
				{
					info = _info[i];
					position = _positions[i];

					for (j in lastCluster + 1...info.cluster)
					{
						// TODO: Handle differently?

						positions.push(new GlyphPosition(0, new Vector2(0, 0), new Vector2(0, 0)));
					}

					positions.push(new GlyphPosition(info.codepoint, new Vector2(position.xAdvance / 64 + letterSpacing, position.yAdvance / 64),
						new Vector2(position.xOffset / 64, position.yOffset / 64)));
					lastCluster = info.cluster;
				}
			}
		}
		#end
	}

	// Get & Set Methods
	@:noCompletion private function get_positions():Array<GlyphPosition>
	{
		if (__dirty)
		{
			__dirty = false;
			__position();
		}

		return positions;
	}

	@:noCompletion private function get_direction():TextDirection
	{
		return __direction;
	}

	@:noCompletion private function set_direction(value:TextDirection):TextDirection
	{
		if (value == __direction) return value;

		__direction = value;
		__dirty = true;

		return value;
	}

	@:noCompletion private function set_font(value:Font):Font
	{
		if (value == this.font) return value;

		this.font = value;
		__dirty = true;
		return value;
	}

	@:noCompletion
	@SuppressWarnings("checkstyle:Dynamic")
	private function get_glyphs():Array<#if lime Glyph #else Dynamic #end>
	{
		var glyphs = [];

		for (position in positions)
		{
			glyphs.push(position.glyph);
		}

		return glyphs;
	}

	@:noCompletion private function get_language():String
	{
		return __language;
	}

	@:noCompletion private function set_language(value:String):String
	{
		if (value == __language) return value;

		__language = value;
		__dirty = true;

		return value;
	}

	@:noCompletion private function get_script():TextScript
	{
		return __script;
	}

	@:noCompletion private function set_script(value:TextScript):TextScript
	{
		if (value == __script) return value;

		__script = value;
		__dirty = true;

		return value;
	}

	@:noCompletion private function set_size(value:Int):Int
	{
		if (value == this.size) return value;

		this.size = value;
		__dirty = true;
		return value;
	}

	@:noCompletion private function set_text(value:String):String
	{
		if (value == this.text) return value;

		this.text = value;
		__dirty = true;
		return value;
	}
}

@SuppressWarnings("checkstyle:FieldDocComment")
@:enum abstract TextDirection(Int) to Int
{
	public var INVALID = 0;
	public var LEFT_TO_RIGHT = 4;
	public var RIGHT_TO_LEFT = 5;
	public var TOP_TO_BOTTOM = 6;
	public var BOTTOM_TO_TOP = 7;
	public var backward(get, never):Bool;
	public var forward(get, never):Bool;
	public var horizontal(get, never):Bool;
	public var vertical(get, never):Bool;

	public inline function reverse():Void
	{
		this = this ^ 1;
	}

	public inline function toString():String
	{
		return switch (this)
		{
			case LEFT_TO_RIGHT: "leftToRight";
			case RIGHT_TO_LEFT: "rightToLeft";
			case TOP_TO_BOTTOM: "topToBottom";
			case BOTTOM_TO_TOP: "bottomToTop";
			default: "";
		}
	}

	#if lime
	@:to public inline function toHBDirection():HBDirection
	{
		return switch (this)
		{
			case LEFT_TO_RIGHT: LTR;
			case RIGHT_TO_LEFT: RTL;
			case TOP_TO_BOTTOM: TTB;
			case BOTTOM_TO_TOP: BTT;
			default: HBDirection.INVALID;
		}
	}
	#end

	@:noCompletion private inline function get_backward():Bool
	{
		return (this & ~2) == 5;
	}

	@:noCompletion private inline function get_forward():Bool
	{
		return (this & ~2) == 4;
	}

	@:noCompletion private inline function get_horizontal():Bool
	{
		return (this & ~1) == 4;
	}

	@:noCompletion private inline function get_vertical():Bool
	{
		return (this & ~1) == 6;
	}
}

@SuppressWarnings("checkstyle:FieldDocComment")
@:enum abstract TextScript(String) to(String)
{
	public var COMMON = "Zyyy";
	public var INHERITED = "Zinh";
	public var UNKNOWN = "Zzzz";
	public var ARABIC = "Arab";
	public var ARMENIAN = "Armn";
	public var BENGALI = "Beng";
	public var CYRILLIC = "Cyrl";
	public var DEVANAGARI = "Deva";
	public var GEORGIAN = "Geor";
	public var GREEK = "Grek";
	public var GUJARATI = "Gujr";
	public var GURMUKHI = "Guru";
	public var HANGUL = "Hang";
	public var HAN = "Hani";
	public var HEBREW = "Hebr";
	public var HIRAGANA = "Hira";
	public var KANNADA = "Knda";
	public var KATAKANA = "Kana";
	public var LAO = "Laoo";
	public var LATIN = "Latn";
	public var MALAYALAM = "Mlym";
	public var ORIYA = "Orya";
	public var TAMIL = "Taml";
	public var TELUGA = "Telu";
	public var THAI = "Thai";
	public var TIBETAN = "Tibt";
	public var BOPOMOFO = "Bopo";
	public var BRAILLE = "Brai";
	public var CANADIAN_SYLLABICS = "Cans";
	public var CHEROKEE = "Cher";
	public var ETHIOPIC = "Ethi";
	public var KHMER = "Khmr";
	public var MONGOLIAN = "Mong";
	public var MYANMAR = "Mymr";
	public var OGHAM = "Ogam";
	public var RUNIC = "Runr";
	public var SINHALA = "Sinh";
	public var SYRIAC = "Syrc";
	public var THAANA = "Thaa";
	public var YI = "Yiii";
	public var DESERET = "Dsrt";
	public var GOTHIC = "Goth";
	public var OLD_ITALIC = "Ital";
	public var BUHID = "Buhd";
	public var HANUNOO = "Hano";
	public var TAGALOG = "Tglg";
	public var TAGBANWA = "Tagb";
	public var CYPRIOT = "Cprt";
	public var LIMBU = "Limb";
	public var LINEAR_B = "Linb";
	public var OSMANYA = "Osma";
	public var SHAVIAN = "Shaw";
	public var TAI_LE = "Tale";
	public var UGARITIC = "Ugar";
	public var BUGINESE = "Bugi";
	public var COPTIC = "Copt";
	public var GLAGOLITIC = "Glag";
	public var KHAROSHTHI = "Khar";
	public var NEW_TAI_LUE = "Talu";
	public var OLD_PERSIAN = "Xpeo";
	public var SYLOTI_NAGRI = "Sylo";
	public var TIFINAGH = "Tfng";
	public var BALINESE = "Bali";
	public var CUNEIFORM = "Xsux";
	public var NKO = "Nkoo";
	public var PHAGS_PA = "Phag";
	public var PHOENICIAN = "Phnx";
	public var CARIAN = "Cari";
	public var CHAM = "Cham";
	public var KAYAH_LI = "Kali";
	public var LEPCHA = "Lepc";
	public var LYCIAN = "Lyci";
	public var LYDIAN = "Lydi";
	public var OL_CHIKI = "Olck";
	public var REJANG = "Rjng";
	public var SAURASHTRA = "Saur";
	public var SUNDANESE = "Sund";
	public var VAI = "Vaii";
	public var AVESTAN = "Avst";
	public var BAMUM = "Bamu";
	public var EGYPTIAN_HIEROGLYPHS = "Egyp";
	public var IMPERIAL_ARAMAIC = "Armi";
	public var INSCRIPTIONAL_PAHLAVI = "Phli";
	public var INSCRIPTIONAL_PARTHIAN = "Prti";
	public var JAVANESE = "Java";
	public var KAITHI = "Kthi";
	public var LISU = "Lisu";
	public var MEETEI_MAYEK = "Mtei";
	public var OLD_SOUTH_ARABIAN = "Sarb";
	public var OLD_TURKIC = "Orkh";
	public var SAMARITAN = "Samr";
	public var TAI_THAM = "Lana";
	public var TAI_VIET = "Tavt";
	public var BATAK = "Batk";
	public var BRAHMI = "Brah";
	public var MANDAIC = "Mand";
	public var CHAKMA = "Cakm";
	public var MEROITIC_CURSIVE = "Merc";
	public var MEROITIC_HIEROGLYPHS = "Mero";
	public var MIAO = "Plrd";
	public var SHARADA = "Shrd";
	public var SORA_SOMPENG = "Sora";
	public var TAKRI = "Takr";
	public var BASSA_VAH = "Bass";
	public var CAUCASIAN_ALBANIAN = "Aghb";
	public var DUPLOYAN = "Dupl";
	public var ELBASAN = "Elba";
	public var GRANTHA = "Gran";
	public var KHOJKI = "Khoj";
	public var KHUDAWADI = "Sind";
	public var LINEAR_A = "Lina";
	public var MAHAJANI = "Mahj";
	public var MANICHAEAN = "Mani";
	public var MENDE_KIKAKUI = "Mend";
	public var MODI = "Modi";
	public var MRO = "Mroo";
	public var NABATAEAN = "Nbat";
	public var OLD_NORTH_ARABIAN = "Narb";
	public var OLD_PERMIC = "Perm";
	public var PAHAWH_HMONG = "Hmng";
	public var PALMYRENE = "Palm";
	public var PAU_CIN_HAU = "Pauc";
	public var PSALTER_PAHLAVI = "Phlp";
	public var SIDDHAM = "Sidd";
	public var TIRHUTA = "Tirh";
	public var WARANG_CITI = "Wara";
	public var rightToLeft(get, never):Bool;

	#if lime
	@:to public inline function toHBScript():HBScript
	{
		return switch (this)
		{
			default: HBScript.COMMON;
		}
	}
	#end

	@:noCompletion private inline function get_rightToLeft():Bool
	{
		return switch (this)
		{
			case HEBREW, ARABIC, SYRIAC, THAANA, NKO, SAMARITAN, MANDAIC, IMPERIAL_ARAMAIC, PHOENICIAN, LYDIAN, CYPRIOT, KHAROSHTHI, OLD_SOUTH_ARABIAN,
				AVESTAN, INSCRIPTIONAL_PAHLAVI, PSALTER_PAHLAVI, OLD_TURKIC:
				true;
			// case KURDISH: true;
			default: false;
		}
	}
}
