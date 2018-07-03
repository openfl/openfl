package openfl._internal.text; #if (lime >= "7.0.0")


import haxe.io.Bytes;
import lime.math.Vector2;
import lime.system.System;
import lime.text.Font;
import lime.text.Glyph;

#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end


class TextLayout {
	
	
	public var direction (get, set):TextDirection;
	public var font (default, set):Font;
	public var glyphs (get, null):Array<Glyph>;
	public var language (get, set):String;
	 @:isVar public var positions (get, null):Array<GlyphPosition>;
	public var script (get, set):TextScript;
	public var size (default, set):Int;
	public var text (default, set):String;
	
	private var __dirty:Bool;
	
	@:noCompletion private var __buffer:Bytes;
	@:noCompletion private var __direction:TextDirection;
	@:noCompletion private var __handle:Dynamic;
	@:noCompletion private var __language:String;
	@:noCompletion private var __script:TextScript;
	
	
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
		
		// #if (lime_cffi && !macro)
		// __handle = NativeCFFI.lime_text_layout_create (__direction, __script, __language);
		// #end
	}
	
	
	private function __create (direction:TextDirection, script:TextScript, language:String):Void {
		
		// if (strlen (script) != 4) return;
		
		// mFont = 0;
		// mHBFont = 0;
		// mDirection = (hb_direction_t)direction;
		// mLanguage = (void *)hb_language_from_string (language, strlen (language));
		// mScript = hb_script_from_string (script, -1);
		
		// mBuffer = hb_buffer_create ();
		// hb_buffer_set_direction ((hb_buffer_t*)mBuffer, (hb_direction_t)mDirection);
		// hb_buffer_set_script ((hb_buffer_t*)mBuffer, (hb_script_t)mScript);
		// hb_buffer_set_language ((hb_buffer_t*)mBuffer, (hb_language_t)mLanguage);
		
	}
	
	
	@:noCompletion private function __position ():Void {
		
		positions = [];
		
		// if (mFont != font) {
			
		// 	mFont = font;
		// 	hb_font_destroy ((hb_font_t*)mHBFont);
		// 	font->SetSize (size);
		// 	mHBFont = hb_ft_font_create ((FT_Face)font->face, NULL);
		// 	// hb_ft_font_set_funcs ((hb_font_t*)mHBFont);
		// 	hb_ft_font_set_load_flags ((hb_font_t*)mHBFont, FT_LOAD_FORCE_AUTOHINT | FT_LOAD_TARGET_LIGHT);
			
		// } else {
			
		// 	font->SetSize (size);
			
		// }
		
		// // reset buffer
		// hb_buffer_reset ((hb_buffer_t*)mBuffer);
		// hb_buffer_set_direction ((hb_buffer_t*)mBuffer, (hb_direction_t)mDirection);
		// hb_buffer_set_script ((hb_buffer_t*)mBuffer, (hb_script_t)mScript);
		// hb_buffer_set_language ((hb_buffer_t*)mBuffer, (hb_language_t)mLanguage);
		// hb_buffer_set_cluster_level ((hb_buffer_t*)mBuffer, HB_BUFFER_CLUSTER_LEVEL_CHARACTERS);
		
		// // layout the text
		// hb_buffer_add_utf8 ((hb_buffer_t*)mBuffer, text, strlen (text), 0, -1);
		
		// // const hb_tag_t kerningTag = HB_TAG('k', 'e', 'r', 'n');
		// // static hb_feature_t useKerning = { kerningTag, 1, 0, std::numeric_limits<unsigned int>::max() };
		// // std::vector<hb_feature_t> features;
		// // features.push_back (useKerning);
		
		// // hb_shape ((hb_font_t*)mHBFont, (hb_buffer_t*)mBuffer, &features[0], features.size());
		// hb_shape ((hb_font_t*)mHBFont, (hb_buffer_t*)mBuffer, NULL, 0);
		
		// uint32_t glyph_count;
		// hb_glyph_info_t *glyph_info = hb_buffer_get_glyph_infos ((hb_buffer_t*)mBuffer, &glyph_count);
		// hb_glyph_position_t *glyph_pos = hb_buffer_get_glyph_positions ((hb_buffer_t*)mBuffer, &glyph_count);
		
		// //float hres = 100;
		// int posIndex = 0;
		
		// int glyphSize = sizeof (GlyphPosition);
		// uint32_t dataSize = 5 + (glyph_count * glyphSize);
		
		// if (bytes->length < dataSize) {
			
		// 	bytes->Resize (dataSize);
			
		// }
		
		// unsigned char* bytesPosition = bytes->b;
		
		// *(uint32_t *)(bytesPosition) = glyph_count;
		// bytesPosition += 4;
		
		// hb_glyph_position_t pos;
		// hb_position_t kern;
		// GlyphPosition *data;
		
		// for (int i = 0; i < glyph_count; i++) {
			
		// 	pos = glyph_pos[i];
			
		// 	data = (GlyphPosition*)(bytesPosition);
			
		// 	data->codepoint = glyph_info[i].codepoint;
		// 	data->index = glyph_info[i].cluster;
		// 	data->advanceX = (float)(pos.x_advance / (float)(64));
		// 	data->advanceY = (float)(pos.y_advance / (float)64);
		// 	data->offsetX = (float)(pos.x_offset / (float)(64));
		// 	data->offsetY = (float)(pos.y_offset / (float)64);
			
		// 	// if (i < glyph_count - 1) {
				
		// 		// Manually add kerning, hb_shape seems to ignore kern feature?
		// 		// kern = hb_font_get_glyph_h_kerning ((hb_font_t*)mHBFont, glyph_info[i].codepoint, glyph_info[i + 1].codepoint);
		// 		// data->advanceX += (float)(kern / (float)(64));
				
		// 	// }
			
		// 	bytesPosition += glyphSize;
			
		// }
		
		
		// #if (lime_cffi && !macro)
		
		// if (__handle != null && text != null && text != "" && font != null && font.src != null) {
			
		// 	if (__buffer == null) {
				
		// 		__buffer = Bytes.alloc (text.length * 5);
		// 		//__buffer.endian = (System.endianness == BIG_ENDIAN ? "bigEndian" : "littleEndian");
				
		// 	}
			
		// 	var data = NativeCFFI.lime_text_layout_position (__handle, font.src, size, text, #if cs null #else __buffer #end);
		// 	var position = 0;
			
		// 	if (__buffer.length > 4) {
				
		// 		var count = __buffer.getInt32 (position); position += 4;
		// 		var codepoint, index, advanceX, advanceY, offsetX, offsetY;
		// 		var lastIndex = -1;
				
		// 		for (i in 0...count) {
					
		// 			codepoint = __buffer.getInt32 (position); position += 4;
		// 			index = __buffer.getInt32 (position); position += 4;
		// 			advanceX = __buffer.getFloat (position); position += 4;
		// 			advanceY = __buffer.getFloat (position); position += 4;
		// 			offsetX = __buffer.getFloat (position); position += 4;
		// 			offsetY = __buffer.getFloat (position); position += 4;
					
		// 			for (j in lastIndex + 1...index) {
						
		// 				// TODO: Handle differently?
						
		// 				positions.push (new GlyphPosition (0, new Vector2 (0, 0), new Vector2 (0, 0)));
						
		// 			}
					
		// 			positions.push (new GlyphPosition (codepoint, new Vector2 (advanceX, advanceY), new Vector2 (offsetX, offsetY)));
		// 			lastIndex = index;
					
		// 		}
				
		// 	}
		// }
		
		// #end
		
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
		
		
		// mDirection = (hb_direction_t)direction;
		
		
		// #if (lime_cffi && !macro)
		// NativeCFFI.lime_text_layout_set_direction (__handle, value);
		// #end
		
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
		
		
		// mLanguage = (void *)hb_language_from_string (language, strlen (language));
		
		// #if (lime_cffi && !macro)
		// NativeCFFI.lime_text_layout_set_language (__handle, value);
		// #end
		
		__dirty = true;
		
		return value;
		
	}
	
	
	@:noCompletion private function get_script ():TextScript {
		
		return __script;
		
	}
	
	
	@:noCompletion private function set_script (value:TextScript):TextScript {
		
		if (value == __script) return value;
		
		__script = value;
		
		
		// mScript = hb_script_from_string (script, -1);
		
		// #if (lime_cffi && !macro)
		// NativeCFFI.lime_text_layout_set_script (__handle, value);
		// #end
		
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
	
	
	private inline function get_backward ():Bool {
		
		return (this & ~2) == 5;
		
	}
	
	
	private inline function get_forward ():Bool {
		
		return (this & ~2) == 4;
		
	}
	
	
	private inline function get_horizontal ():Bool {
		
		return (this & ~1) == 4;
		
	}
	
	
	private inline function get_vertical ():Bool {
		
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
	
	
	private inline function get_rightToLeft ():Bool {
		
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