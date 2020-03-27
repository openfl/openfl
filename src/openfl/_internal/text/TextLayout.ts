namespace openfl._internal.text;

#if lime
import haxe.io.Bytes;
import lime.math.Vector2;
import lime.text.Font;
import lime.text.Glyph;
import openfl._internal.bindings.harfbuzz.HBBuffer;
import openfl._internal.bindings.harfbuzz.HBBufferClusterLevel;
import openfl._internal.bindings.harfbuzz.HBDirection;
import openfl._internal.bindings.harfbuzz.HBFTFont;
import openfl._internal.bindings.harfbuzz.HBLanguage;
import openfl._internal.bindings.harfbuzz.HBScript;
import openfl._internal.bindings.harfbuzz.HB;
import openfl.text.Font;

#if!openfl_debug
@: fileXml('tags="haxe,release"')
@: noDebug
#end
@SuppressWarnings("checkstyle:FieldDocComment")
class TextLayout
{
	private static readonly FT_LOAD_DEFAULT: number = 0;
	private static readonly FT_LOAD_NO_SCALE: number = 1;
	private static readonly FT_LOAD_NO_HINTING: number = 2;
	private static readonly FT_LOAD_RENDER: number = 4;
	private static readonly FT_LOAD_NO_BITMAP: number = 8;
	private static readonly FT_LOAD_VERTICAL_LAYOUT: number = 16;
	private static readonly FT_LOAD_FORCE_AUTOHINT: number = 32;
	private static readonly FT_LOAD_CROP_BITMAP: number = 64;
	private static readonly FT_LOAD_PEDANTIC: number = 128;
	private static readonly FT_LOAD_IGNORE_GLOBAL_ADVANCE_WIDTH: number = 256;
	private static readonly FT_LOAD_NO_RECURSE: number = 512;
	private static readonly FT_LOAD_IGNORE_TRANSFORM: number = 1024;
	private static readonly FT_LOAD_MONOCHROME: number = 2048;
	private static readonly FT_LOAD_LINEAR_DESIGN: number = 4096;
	private static readonly FT_LOAD_NO_AUTOHINT: number = 8192;
	private static readonly FT_LOAD_COLOR: number = 16384;
	private static readonly FT_LOAD_COMPUTE_METRICS: number = 32768;
	private static readonly FT_LOAD_BITMAP_METRICS_ONLY: number = 65536;
	// define FT_LOAD_TARGET_( x )   ( (FT_Int32)( (x) & 15 ) << 16 )
	private static readonly FT_LOAD_TARGET_NORMAL: number = (0 & 15) << 16; // FT_LOAD_TARGET_( FT_RENDER_MODE_NORMAL )
	private static readonly FT_LOAD_TARGET_LIGHT: number = ((((0 & 15) << 16) & 15) << 16); //  FT_LOAD_TARGET_( FT_RENDER_MODE_LIGHT  )

	// private static readonly FT_LOAD_TARGET_MONO    FT_LOAD_TARGET_( FT_RENDER_MODE_MONO   )
	// private static readonly FT_LOAD_TARGET_LCD     FT_LOAD_TARGET_( FT_RENDER_MODE_LCD    )
	// private static readonly FT_LOAD_TARGET_LCD_V   FT_LOAD_TARGET_( FT_RENDER_MODE_LCD_V  )
	public autoHint: boolean;
	public direction(get, set): TextDirection;
	public font(default , set): Font;
	@SuppressWarnings("checkstyle:Dynamic") public glyphs(get, null): Array<#if lime Glyph #else Dynamic #end >;
public language(get, set): string;
public letterSpacing: number = 0;
@: isVar public positions(get, null): Array<GlyphPosition>;
public script(get, set): TextScript;
public size(default, set) : number;
public text(default, set): string;

private __buffer: Bytes;
private __direction: TextDirection;
private __dirty: boolean;
@SuppressWarnings("checkstyle:Dynamic") private __handle: Dynamic;
private __language: string;
private __script: TextScript;
private __font: Font;
@SuppressWarnings("checkstyle:Dynamic") private __hbBuffer: #if lime HBBuffer #else Dynamic #end;
@SuppressWarnings("checkstyle:Dynamic") private __hbFont: #if lime HBFTFont #else Dynamic #end;

public constructor(text: string = "", font: Font = null, size : number = 12, direction: TextDirection = LEFT_TO_RIGHT, script: TextScript = COMMON,
	language: string = "en")
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

private __create(direction: TextDirection, script: TextScript, language: string): void
	{
		if(language.length != 4) return;

		#if lime
	__hbBuffer = new HBBuffer();
		__hbBuffer.direction = direction.toHBDirection();
		__hbBuffer.script = script.toHBScript();
		__hbBuffer.language = new HBLanguage(language);
		#end
}

	protected __position(): void
	{
		positions =[];

		#if(lime && lime_cffi && !macro)
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
		@: privateAccess font.__setSize(size);
		__hbFont = new HBFTFont(font);

		if (autoHint)
		{
			__hbFont.loadFlags = FT_LOAD_FORCE_AUTOHINT | FT_LOAD_TARGET_LIGHT;
		}
	}
	else
	{
		@: privateAccess font.__setSize(size);
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
			#if(neko || mac || linux || hl)
	// other targets still uses dummy positions to make UTF8 work
	// TODO: confirm
	__hbBuffer.addUTF8(text, 0, -1);
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
	public get positions(): Array < GlyphPosition >
{
	if(__dirty)
	{
		__dirty = false;
		__position();
	}

	return positions;
}

	public get direction(): TextDirection
{
	return __direction;
}

	public set direction(value: TextDirection): TextDirection
{
	if (value == __direction) return value;

	__direction = value;
	__dirty = true;

	return value;
}

	public set font(value: Font): Font
{
	if (value == this.font) return value;

	this.font = value;
	__dirty = true;
	return value;
}

/** @hidden */
@SuppressWarnings("checkstyle:Dynamic")
private get_glyphs(): Array <#if lime Glyph #else Dynamic #end >
{
	var glyphs = [];

	for(position in positions)
		{
	glyphs.push(position.glyph);
}

return glyphs;
	}

	public get language(): string
{
	return __language;
}

	public set language(value: string): string
{
	if (value == __language) return value;

	__language = value;
	__dirty = true;

	return value;
}

	public get script(): TextScript
{
	return __script;
}

	public set script(value: TextScript): TextScript
{
	if (value == __script) return value;

	__script = value;
	__dirty = true;

	return value;
}

	public set size(value : number) : number
{
	if (value == this.size) return value;

	this.size = value;
	__dirty = true;
	return value;
}

	public set text(value: string): string
{
	if (value == this.text) return value;

	this.text = value;
	__dirty = true;
	return value;
}
}

@SuppressWarnings("checkstyle:FieldDocComment")
@: enum abstract TextDirection(Int) to Int
{
	public INVALID = 0;
	public LEFT_TO_RIGHT = 4;
	public RIGHT_TO_LEFT = 5;
	public TOP_TO_BOTTOM = 6;
	public BOTTOM_TO_TOP = 7;
	public backward(get, never) : boolean;
	public forward(get, never) : boolean;
	public horizontal(get, never) : boolean;
	public vertical(get, never) : boolean;

	public inline reverse(): void
		{
			this = this ^ 1;
		}

	public inline toString(): string
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
	@: to public inline toHBDirection(): HBDirection
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

	protected inline get_backward() : boolean
	{
		return (this & ~2) == 5;
	}

	protected inline get_forward() : boolean
	{
		return (this & ~2) == 4;
	}

	protected inline get_horizontal() : boolean
	{
		return (this & ~1) == 4;
	}

	protected inline get_vertical() : boolean
	{
		return (this & ~1) == 6;
	}
}

@SuppressWarnings("checkstyle:FieldDocComment")
@: enum abstract TextScript(String) to(String)
{
	public COMMON = "Zyyy";
	public INHERITED = "Zinh";
	public UNKNOWN = "Zzzz";
	public ARABIC = "Arab";
	public ARMENIAN = "Armn";
	public BENGALI = "Beng";
	public CYRILLIC = "Cyrl";
	public DEVANAGARI = "Deva";
	public GEORGIAN = "Geor";
	public GREEK = "Grek";
	public GUJARATI = "Gujr";
	public GURMUKHI = "Guru";
	public HANGUL = "Hang";
	public HAN = "Hani";
	public HEBREW = "Hebr";
	public HIRAGANA = "Hira";
	public KANNADA = "Knda";
	public KATAKANA = "Kana";
	public LAO = "Laoo";
	public LATIN = "Latn";
	public MALAYALAM = "Mlym";
	public ORIYA = "Orya";
	public TAMIL = "Taml";
	public TELUGA = "Telu";
	public THAI = "Thai";
	public TIBETAN = "Tibt";
	public BOPOMOFO = "Bopo";
	public BRAILLE = "Brai";
	public CANADIAN_SYLLABICS = "Cans";
	public CHEROKEE = "Cher";
	public ETHIOPIC = "Ethi";
	public KHMER = "Khmr";
	public MONGOLIAN = "Mong";
	public MYANMAR = "Mymr";
	public OGHAM = "Ogam";
	public RUNIC = "Runr";
	public SINHALA = "Sinh";
	public SYRIAC = "Syrc";
	public THAANA = "Thaa";
	public YI = "Yiii";
	public DESERET = "Dsrt";
	public GOTHIC = "Goth";
	public OLD_ITALIC = "Ital";
	public BUHID = "Buhd";
	public HANUNOO = "Hano";
	public TAGALOG = "Tglg";
	public TAGBANWA = "Tagb";
	public CYPRIOT = "Cprt";
	public LIMBU = "Limb";
	public LINEAR_B = "Linb";
	public OSMANYA = "Osma";
	public SHAVIAN = "Shaw";
	public TAI_LE = "Tale";
	public UGARITIC = "Ugar";
	public BUGINESE = "Bugi";
	public COPTIC = "Copt";
	public GLAGOLITIC = "Glag";
	public KHAROSHTHI = "Khar";
	public constructor_TAI_LUE = "Talu";
	public OLD_PERSIAN = "Xpeo";
	public SYLOTI_NAGRI = "Sylo";
	public TIFINAGH = "Tfng";
	public BALINESE = "Bali";
	public CUNEIFORM = "Xsux";
	public NKO = "Nkoo";
	public PHAGS_PA = "Phag";
	public PHOENICIAN = "Phnx";
	public CARIAN = "Cari";
	public CHAM = "Cham";
	public KAYAH_LI = "Kali";
	public LEPCHA = "Lepc";
	public LYCIAN = "Lyci";
	public LYDIAN = "Lydi";
	public OL_CHIKI = "Olck";
	public REJANG = "Rjng";
	public SAURASHTRA = "Saur";
	public SUNDANESE = "Sund";
	public VAI = "Vaii";
	public AVESTAN = "Avst";
	public BAMUM = "Bamu";
	public EGYPTIAN_HIEROGLYPHS = "Egyp";
	public IMPERIAL_ARAMAIC = "Armi";
	public INSCRIPTIONAL_PAHLAVI = "Phli";
	public INSCRIPTIONAL_PARTHIAN = "Prti";
	public JAVANESE = "Java";
	public KAITHI = "Kthi";
	public LISU = "Lisu";
	public MEETEI_MAYEK = "Mtei";
	public OLD_SOUTH_ARABIAN = "Sarb";
	public OLD_TURKIC = "Orkh";
	public SAMARITAN = "Samr";
	public TAI_THAM = "Lana";
	public TAI_VIET = "Tavt";
	public BATAK = "Batk";
	public BRAHMI = "Brah";
	public MANDAIC = "Mand";
	public CHAKMA = "Cakm";
	public MEROITIC_CURSIVE = "Merc";
	public MEROITIC_HIEROGLYPHS = "Mero";
	public MIAO = "Plrd";
	public SHARADA = "Shrd";
	public SORA_SOMPENG = "Sora";
	public TAKRI = "Takr";
	public BASSA_VAH = "Bass";
	public CAUCASIAN_ALBANIAN = "Aghb";
	public DUPLOYAN = "Dupl";
	public ELBASAN = "Elba";
	public GRANTHA = "Gran";
	public KHOJKI = "Khoj";
	public KHUDAWADI = "Sind";
	public LINEAR_A = "Lina";
	public MAHAJANI = "Mahj";
	public MANICHAEAN = "Mani";
	public MENDE_KIKAKUI = "Mend";
	public MODI = "Modi";
	public MRO = "Mroo";
	public NABATAEAN = "Nbat";
	public OLD_NORTH_ARABIAN = "Narb";
	public OLD_PERMIC = "Perm";
	public PAHAWH_HMONG = "Hmng";
	public PALMYRENE = "Palm";
	public PAU_CIN_HAU = "Pauc";
	public PSALTER_PAHLAVI = "Phlp";
	public SIDDHAM = "Sidd";
	public TIRHUTA = "Tirh";
	public WARANG_CITI = "Wara";
	public rightToLeft(get, never) : boolean;

	#if lime
	@: to public inline toHBScript(): HBScript
	{
		return switch (this)
		{
			default: HBScript.COMMON;
		}
	}
	#end

	protected inline get_rightToLeft() : boolean
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
#end
