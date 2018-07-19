package openfl._internal.text; #if (lime >= "7.0.0")


import haxe.io.Bytes;
import lime.math.Vector2;
import lime.system.System;
import lime.text.harfbuzz.HBBuffer;
import lime.text.harfbuzz.HBBufferClusterLevel;
import lime.text.harfbuzz.HBDirection;
import lime.text.harfbuzz.HBFTFont;
import lime.text.harfbuzz.HBLanguage;
import lime.text.harfbuzz.HBScript;
import lime.text.harfbuzz.HB;
import lime.text.Font;
import lime.text.Glyph;

#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end


class TextLayout {
	
	
	private static inline var FT_LOAD_DEFAULT = 0;
	private static inline var FT_LOAD_NO_SCALE = 1;
	private static inline var FT_LOAD_NO_HINTING = 2;
	private static inline var FT_LOAD_RENDER = 4;
	private static inline var FT_LOAD_NO_BITMAP = 8;
	private static inline var FT_LOAD_VERTICAL_LAYOUT = 16;
	private static inline var FT_LOAD_FORCE_AUTOHINT = 32;
	private static inline var FT_LOAD_CROP_BITMAP = 64;
	private static inline var FT_LOAD_PEDANTIC = 128;
	private static inline var FT_LOAD_IGNORE_GLOBAL_ADVANCE_WIDTH = 256;
	private static inline var FT_LOAD_NO_RECURSE = 512;
	private static inline var FT_LOAD_IGNORE_TRANSFORM = 1024;
	private static inline var FT_LOAD_MONOCHROME = 2048;
	private static inline var FT_LOAD_LINEAR_DESIGN = 4096;
	private static inline var FT_LOAD_NO_AUTOHINT = 8192;
	private static inline var FT_LOAD_COLOR = 16384;
	private static inline var FT_LOAD_COMPUTE_METRICS = 32768;
	private static inline var FT_LOAD_BITMAP_METRICS_ONLY = 65536;
	
	// define FT_LOAD_TARGET_( x )   ( (FT_Int32)( (x) & 15 ) << 16 )

	private static inline var FT_LOAD_TARGET_NORMAL = (0 & 15) << 16; //FT_LOAD_TARGET_( FT_RENDER_MODE_NORMAL )
	private static inline var FT_LOAD_TARGET_LIGHT = ((((0 & 15) << 16) & 15) << 16);//  FT_LOAD_TARGET_( FT_RENDER_MODE_LIGHT  )
	// private static inline var FT_LOAD_TARGET_MONO    FT_LOAD_TARGET_( FT_RENDER_MODE_MONO   )
	// private static inline var FT_LOAD_TARGET_LCD     FT_LOAD_TARGET_( FT_RENDER_MODE_LCD    )
	// private static inline var FT_LOAD_TARGET_LCD_V   FT_LOAD_TARGET_( FT_RENDER_MODE_LCD_V  )
	
	public var autoHint:Bool;
	public var direction (get, set):TextDirection;
	public var font (default, set):Font;
	public var glyphs (get, null):Array<Glyph>;
	public var language (get, set):String;
	public var letterSpacing:Float;
	@:isVar public var positions (get, null):Array<GlyphPosition>;
	public var script (get, set):TextScript;
	public var size (default, set):Int;
	public var text (default, set):String;
	
	private var __buffer:Bytes;
	private var __direction:TextDirection;
	private var __dirty:Bool;
	private var __handle:Dynamic;
	private var __language:String;
	private var __script:TextScript;
	
	private var __font:Font;
	private var __hbBuffer:HBBuffer;
	private var __hbFont:HBFTFont;
	
	
	public function new (text:String = "", font:Font = null, size:Int = 12, direction:TextDirection = LEFT_TO_RIGHT, script:TextScript = COMMON, language:String = "en") {
		
		this.text = text;
		this.font = font;
		this.size = size;
		__direction = direction;
		__script = script;
		__language = language;
		
		positions = [];
		__dirty = true;
		
		__create (__direction, __script, __language);
		
	}
	
	
	private function __create (direction:TextDirection, script:TextScript, language:String):Void {
		
		if (language.length != 4) return;
		
		__hbBuffer = new HBBuffer ();
		__hbBuffer.direction = direction;
		__hbBuffer.script = script;
		__hbBuffer.language = new HBLanguage (language);
		
	}
	
	
	@:noCompletion private function __position ():Void {
		
		positions = [];
		
		#if (lime_cffi && !macro)
		if (text != null && text != "" && font != null && font.src != null) {
			
			if (__buffer == null) {
				
				__buffer = Bytes.alloc (text.length * 5);
				//__buffer.endian = (System.endianness == BIG_ENDIAN ? "bigEndian" : "littleEndian");
				
			}
			
			if (__font != font) {
				
				__font = font;
				// 	hb_font_destroy ((hb_font_t*)mHBFont);
				@:privateAccess font.__setSize (size);
				__hbFont = new HBFTFont (font);
				
				if (autoHint) {
					
					__hbFont.loadFlags = FT_LOAD_FORCE_AUTOHINT | FT_LOAD_TARGET_LIGHT;
					
				}
				
			} else {
				
				@:privateAccess font.__setSize (size);
				
			}
			
			if (__hbBuffer == null) {
				
				__hbBuffer = new HBBuffer ();
				
			} else {
				
				__hbBuffer.reset ();
				
			}
			
			__hbBuffer.direction = direction;
			__hbBuffer.script = script;
			__hbBuffer.language = new HBLanguage (language);
			__hbBuffer.clusterLevel = HBBufferClusterLevel.CHARACTERS;
			__hbBuffer.addUTF8 (text, 0, -1);
			
			HB.shape (__hbFont, __hbBuffer);
			
			var _info = __hbBuffer.getGlyphInfo ();
			var _positions = __hbBuffer.getGlyphPositions ();
			
			var info, position;
			var lastCluster = -1;
			
			for (i in 0..._info.length) {
				
				info = _info[i];
				position = _positions[i];
				
				for (j in lastCluster + 1...info.cluster) {
					
					// TODO: Handle differently?
					
					positions.push (new GlyphPosition (0, new Vector2 (0, 0), new Vector2 (0, 0)));
					
				}
				
				positions.push (new GlyphPosition (info.codepoint, new Vector2 (position.xAdvance / 64 + letterSpacing, position.yAdvance / 64), new Vector2 (position.xOffset / 64, position.yOffset / 64)));
				lastCluster = info.cluster;
				
			}
			
		}
		
		#end
		
	}
	
	
	
	
	// Get & Set Methods
	
	
	
	
	@:noCompletion private function get_positions ():Array<GlyphPosition> {
		
		if (__dirty) {
			
			__dirty = false;
			__position ();
			
		}
		
		return positions;
		
	}
	
	
	@:noCompletion private function get_direction ():TextDirection {
		
		return __direction;
		
	}
	
	
	@:noCompletion private function set_direction (value:TextDirection):TextDirection {
		
		if (value == __direction) return value;
		
		__direction = value;
		__dirty = true;
		
		return value;
		
	}
	
	
	@:noCompletion private function set_font (value:Font):Font {
		
		if (value == this.font) return value;
		
		this.font = value;
		__dirty = true;
		return value;
		
	}
	
	
	@:noCompletion private function get_glyphs ():Array<Glyph> {
		
		var glyphs = [];
		
		for (position in positions) {
			
			glyphs.push (position.glyph);
			
		}
		
		return glyphs;
		
	}
	
	
	@:noCompletion private function get_language ():String {
		
		return __language;
		
	}
	
	
	@:noCompletion private function set_language (value:String):String {
		
		if (value == __language) return value;
		
		__language = value;
		__dirty = true;
		
		return value;
		
	}
	
	
	@:noCompletion private function get_script ():TextScript {
		
		return __script;
		
	}
	
	
	@:noCompletion private function set_script (value:TextScript):TextScript {
		
		if (value == __script) return value;
		
		__script = value;
		__dirty = true;
		
		return value;
		
	}
	
	
	@:noCompletion private function set_size (value:Int):Int {
		
		if (value == this.size) return value;
		
		this.size = value;
		__dirty = true;
		return value;
		
	}
	
	
	@:noCompletion private function set_text (value:String):String {
		
		if (value == this.text) return value;
		
		this.text = value;
		__dirty = true;
		return value;
		
	}
	
	
}


@:enum abstract TextDirection(Int) to (Int) {
	
	
	var INVALID = 0;
	var LEFT_TO_RIGHT = 4;
	var RIGHT_TO_LEFT = 5;
	var TOP_TO_BOTTOM = 6;
	var BOTTOM_TO_TOP = 7;
	
	
	public var backward (get, never):Bool;
	public var forward (get, never):Bool;
	public var horizontal (get, never):Bool;
	public var vertical (get, never):Bool;
	
	
	public inline function reverse ():Void {
		
		this = this ^ 1;
		
	}
	
	
	public inline function toString ():String {
		
		return switch (this) {
			
			case LEFT_TO_RIGHT: "leftToRight";
			case RIGHT_TO_LEFT: "rightToLeft";
			case TOP_TO_BOTTOM: "topToBottom";
			case BOTTOM_TO_TOP: "bottomToTop";
			default: "";
			
		}
		
	}
	
	
	@:to private inline function toHBDirection ():HBDirection {
		
		return switch (this) {
			
			case LEFT_TO_RIGHT: LTR;
			case RIGHT_TO_LEFT: RTL;
			case TOP_TO_BOTTOM: TTB;
			case BOTTOM_TO_TOP: BTT;
			default: HBDirection.INVALID;
			
		}
		
	}
	
	
	@:noCompletion private inline function get_backward ():Bool {
		
		return (this & ~2) == 5;
		
	}
	
	
	@:noCompletion private inline function get_forward ():Bool {
		
		return (this & ~2) == 4;
		
	}
	
	
	@:noCompletion private inline function get_horizontal ():Bool {
		
		return (this & ~1) == 4;
		
	}
	
	
	@:noCompletion private inline function get_vertical ():Bool {
		
		return (this & ~1) == 6;
		
	}
	
	
}



@:enum abstract TextScript(String) to (String) {
	
	var COMMON = "Zyyy";
	var INHERITED = "Zinh";
	var UNKNOWN = "Zzzz";
	
	var ARABIC = "Arab";
	var ARMENIAN = "Armn";
	var BENGALI = "Beng";
	var CYRILLIC = "Cyrl";
	var DEVANAGARI = "Deva";
	var GEORGIAN = "Geor";
	var GREEK = "Grek";
	var GUJARATI = "Gujr";
	var GURMUKHI = "Guru";
	var HANGUL = "Hang";
	var HAN = "Hani";
	var HEBREW = "Hebr";
	var HIRAGANA = "Hira";
	var KANNADA = "Knda";
	var KATAKANA = "Kana";
	var LAO = "Laoo";
	var LATIN = "Latn";
	var MALAYALAM = "Mlym";
	var ORIYA = "Orya";
	var TAMIL = "Taml";
	var TELUGA = "Telu";
	var THAI = "Thai";
	
	var TIBETAN = "Tibt";
	
	var BOPOMOFO = "Bopo";
	var BRAILLE = "Brai";
	var CANADIAN_SYLLABICS = "Cans";
	var CHEROKEE = "Cher";
	var ETHIOPIC = "Ethi";
	var KHMER = "Khmr";
	var MONGOLIAN = "Mong";
	var MYANMAR = "Mymr";
	var OGHAM = "Ogam";
	var RUNIC = "Runr";
	var SINHALA = "Sinh";
	var SYRIAC = "Syrc";
	var THAANA = "Thaa";
	var YI = "Yiii";
	
	var DESERET = "Dsrt";
	var GOTHIC = "Goth";
	var OLD_ITALIC = "Ital";
	
	var BUHID = "Buhd";
	var HANUNOO = "Hano";
	var TAGALOG = "Tglg";
	var TAGBANWA = "Tagb";
	
	var CYPRIOT = "Cprt";
	var LIMBU = "Limb";
	var LINEAR_B = "Linb";
	var OSMANYA = "Osma";
	var SHAVIAN = "Shaw";
	var TAI_LE = "Tale";
	var UGARITIC = "Ugar";
	
	var BUGINESE = "Bugi";
	var COPTIC = "Copt";
	var GLAGOLITIC = "Glag";
	var KHAROSHTHI = "Khar";
	var NEW_TAI_LUE = "Talu";
	var OLD_PERSIAN = "Xpeo";
	var SYLOTI_NAGRI = "Sylo";
	var TIFINAGH = "Tfng";
	
	var BALINESE = "Bali";
	var CUNEIFORM = "Xsux";
	var NKO = "Nkoo";
	var PHAGS_PA = "Phag";
	var PHOENICIAN = "Phnx";
	
	var CARIAN = "Cari";
	var CHAM = "Cham";
	var KAYAH_LI = "Kali";
	var LEPCHA = "Lepc";
	var LYCIAN = "Lyci";
	var LYDIAN = "Lydi";
	var OL_CHIKI = "Olck";
	var REJANG = "Rjng";
	var SAURASHTRA = "Saur";
	var SUNDANESE = "Sund";
	var VAI = "Vaii";
	
	var AVESTAN = "Avst";
	var BAMUM = "Bamu";
	var EGYPTIAN_HIEROGLYPHS = "Egyp";
	var IMPERIAL_ARAMAIC = "Armi";
	var INSCRIPTIONAL_PAHLAVI = "Phli";
	var INSCRIPTIONAL_PARTHIAN = "Prti";
	var JAVANESE = "Java";
	var KAITHI = "Kthi";
	var LISU = "Lisu";
	var MEETEI_MAYEK = "Mtei";
	var OLD_SOUTH_ARABIAN = "Sarb";
	var OLD_TURKIC = "Orkh";
	var SAMARITAN = "Samr";
	var TAI_THAM = "Lana";
	var TAI_VIET = "Tavt";
	
	var BATAK = "Batk";
	var BRAHMI = "Brah";
	var MANDAIC = "Mand";
	
	var CHAKMA = "Cakm";
	var MEROITIC_CURSIVE = "Merc";
	var MEROITIC_HIEROGLYPHS = "Mero";
	var MIAO = "Plrd";
	var SHARADA = "Shrd";
	var SORA_SOMPENG = "Sora";
	var TAKRI = "Takr";
	
	var BASSA_VAH = "Bass";
	var CAUCASIAN_ALBANIAN = "Aghb";
	var DUPLOYAN = "Dupl";
	var ELBASAN = "Elba";
	var GRANTHA = "Gran";
	var KHOJKI = "Khoj";
	var KHUDAWADI = "Sind";
	var LINEAR_A = "Lina";
	var MAHAJANI = "Mahj";
	var MANICHAEAN = "Mani";
	var MENDE_KIKAKUI = "Mend";
	var MODI = "Modi";
	var MRO = "Mroo";
	var NABATAEAN = "Nbat";
	var OLD_NORTH_ARABIAN = "Narb";
	var OLD_PERMIC = "Perm";
	var PAHAWH_HMONG = "Hmng";
	var PALMYRENE = "Palm";
	var PAU_CIN_HAU = "Pauc";
	var PSALTER_PAHLAVI = "Phlp";
	var SIDDHAM = "Sidd";
	var TIRHUTA = "Tirh";
	var WARANG_CITI = "Wara";
	
	
	public var rightToLeft (get, never):Bool;
	
	
	@:to private inline function toHBScript ():HBScript {
		
		return switch (this) {
			
			default: HBScript.COMMON;
			
		}
		
	}
	
	
	@:noCompletion private inline function get_rightToLeft ():Bool {
		
		return switch (this) {
			
			case HEBREW, ARABIC, SYRIAC, THAANA, NKO, SAMARITAN, MANDAIC, IMPERIAL_ARAMAIC, PHOENICIAN, LYDIAN, CYPRIOT, KHAROSHTHI, OLD_SOUTH_ARABIAN, AVESTAN, INSCRIPTIONAL_PAHLAVI, PSALTER_PAHLAVI, OLD_TURKIC: true;
			//case KURDISH: true;
			default: false;
			
		}
		
	}
	
}


#else
typedef TextLayout = lime.text.TextLayout;
#end