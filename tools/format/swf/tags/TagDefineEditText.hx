package format.swf.tags;

import format.swf.SWFData;
import format.swf.data.SWFRectangle;

class TagDefineEditText implements IDefinitionTag
{
	public static inline var TYPE:Int = 37;
	
	public var type(default, null):Int;
	public var name(default, null):String;
	public var version(default, null):Int;
	public var level(default, null):Int;
	
	public var bounds:SWFRectangle;
	public var variableName:String;
	
	public var hasText:Bool;
	public var wordWrap:Bool;
	public var multiline:Bool;
	public var password:Bool;
	public var readOnly:Bool;
	public var hasTextColor:Bool;
	public var hasMaxLength:Bool;
	public var hasFont:Bool;
	public var hasFontClass:Bool;
	public var autoSize:Bool;
	public var hasLayout:Bool;
	public var noSelect:Bool;
	public var border:Bool;
	public var wasStatic:Bool;
	public var html:Bool;
	public var useOutlines:Bool;
	
	public var fontId:Int;
	public var fontClass:String;
	public var fontHeight:Int;
	public var textColor:Int;
	public var maxLength:Int;
	public var align:Int;
	public var leftMargin:Int;
	public var rightMargin:Int;
	public var indent:Int;
	public var leading:Int;
	public var initialText:String;

	public var characterId:Int;
	
	public function new() {
		
		type = TYPE;
		name = "DefineEditText";
		version = 4;
		level = 1;
		
	}
	
	public function parse(data:SWFData, length:Int, version:Int, async:Bool = false):Void {
		characterId = data.readUI16();
		bounds = data.readRECT();
		var flags1:Int = data.readUI8();
		hasText = ((flags1 & 0x80) != 0);
		wordWrap = ((flags1 & 0x40) != 0);
		multiline = ((flags1 & 0x20) != 0);
		password = ((flags1 & 0x10) != 0);
		readOnly = ((flags1 & 0x08) != 0);
		hasTextColor = ((flags1 & 0x04) != 0);
		hasMaxLength = ((flags1 & 0x02) != 0);
		hasFont = ((flags1 & 0x01) != 0);
		var flags2:Int = data.readUI8();
		hasFontClass = ((flags2 & 0x80) != 0);
		autoSize = ((flags2 & 0x40) != 0);
		hasLayout = ((flags2 & 0x20) != 0);
		noSelect = ((flags2 & 0x10) != 0);
		border = ((flags2 & 0x08) != 0);
		wasStatic = ((flags2 & 0x04) != 0);
		html = ((flags2 & 0x02) != 0);
		useOutlines = ((flags2 & 0x01) != 0);
		if (hasFont) {
			fontId = data.readUI16();
		}
		if (hasFontClass) {
			fontClass = data.readSTRING();
		}
		if (hasFont || hasFontClass) {
			fontHeight = data.readUI16();
		}
		if (hasTextColor) {
			textColor = data.readRGBA();
		}
		if (hasMaxLength) {
			maxLength = data.readUI16();
		}
		if (hasLayout) {
			align = data.readUI8();
			leftMargin = data.readUI16();
			rightMargin = data.readUI16();
			indent = data.readUI16();
			leading = data.readSI16();
		}
		variableName = data.readSTRING();
		if (hasText) {
			initialText = data.readSTRING();
		}
	}
	
	public function publish(data:SWFData, version:Int):Void {
		var body:SWFData = new SWFData();
		body.writeUI16(characterId);
		body.writeRECT(bounds);
		var flags1:Int = 0;
		if(hasText) { flags1 |= 0x80; }
		if(wordWrap) { flags1 |= 0x40; }
		if(multiline) { flags1 |= 0x20; }
		if(password) { flags1 |= 0x10; }
		if(readOnly) { flags1 |= 0x08; }
		if(hasTextColor) { flags1 |= 0x04; }
		if(hasMaxLength) { flags1 |= 0x02; }
		if(hasFont) { flags1 |= 0x01; }
		body.writeUI8(flags1);
		var flags2:Int = 0;
		if(hasFontClass) { flags2 |= 0x80; }
		if(autoSize) { flags2 |= 0x40; }
		if(hasLayout) { flags2 |= 0x20; }
		if(noSelect) { flags2 |= 0x10; }
		if(border) { flags2 |= 0x08; }
		if(wasStatic) { flags2 |= 0x04; }
		if(html) { flags2 |= 0x02; }
		if(useOutlines) { flags2 |= 0x01; }
		body.writeUI8(flags2);
		if (hasFont) {
			body.writeUI16(fontId);
		}
		if (hasFontClass) {
			body.writeSTRING(fontClass);
		}
		if (hasFont || hasFontClass) {
			body.writeUI16(fontHeight);
		}
		if (hasTextColor) {
			body.writeRGBA(textColor);
		}
		if (hasMaxLength) {
			body.writeUI16(maxLength);
		}
		if (hasLayout) {
			body.writeUI8(align);
			body.writeUI16(leftMargin);
			body.writeUI16(rightMargin);
			body.writeUI16(indent);
			body.writeSI16(leading);
		}
		body.writeSTRING(variableName);
		if (hasText) {
			body.writeSTRING(initialText);
		}
		data.writeTagHeader(type, body.length);
		data.writeBytes(body);
	}
	
	public function clone():IDefinitionTag {
		var tag:TagDefineEditText = new TagDefineEditText();
		tag.characterId = characterId;
		tag.bounds = bounds.clone();
		tag.variableName = variableName;
		tag.hasText = hasText;
		tag.wordWrap = wordWrap;
		tag.multiline = multiline;
		tag.password = password;
		tag.readOnly = readOnly;
		tag.hasTextColor = hasTextColor;
		tag.hasMaxLength = hasMaxLength;
		tag.hasFont = hasFont;
		tag.hasFontClass = hasFontClass;
		tag.autoSize = autoSize;
		tag.hasLayout = hasLayout;
		tag.noSelect = noSelect;
		tag.border = border;
		tag.wasStatic = wasStatic;
		tag.html = html;
		tag.useOutlines = useOutlines;
		tag.fontId = fontId;
		tag.fontClass = fontClass;
		tag.fontHeight = fontHeight;
		tag.textColor = textColor;
		tag.maxLength = maxLength;
		tag.align = align;
		tag.leftMargin = leftMargin;
		tag.rightMargin = rightMargin;
		tag.indent = indent;
		tag.leading = leading;
		tag.initialText = initialText;
		return tag;
	}
	
	public function toString(indent:Int = 0):String {
		var str:String = Tag.toStringCommon(type, name, indent) +
			"ID: " + characterId + ", " +
			((hasText && initialText.length > 0) ? "Text: " + initialText + ", " : "") +
			((variableName.length > 0) ? "VariableName: " + variableName + ", " : "") +
			"Bounds: " + bounds;
		return str;
	}
}