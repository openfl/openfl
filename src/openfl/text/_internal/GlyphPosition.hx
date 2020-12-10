package openfl.text._internal;

#if lime
import lime.math.Vector2;
import lime.text.Glyph;
#end

#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end
@SuppressWarnings(["checkstyle:FieldDocComment", "checkstyle:Dynamic"])
class GlyphPosition
{
	public var advance:#if lime Vector2 #else Dynamic #end;
	public var glyph:#if lime Glyph #else Dynamic #end;
	public var offset:#if lime Vector2 #else Dynamic #end;

	public function new(glyph:#if lime Glyph #else Dynamic #end, advance:#if lime Vector2 #else Dynamic #end,
			offset:#if lime Vector2 #else Dynamic #end = null)
	{
		this.glyph = glyph;
		this.advance = advance;

		if (offset != null)
		{
			this.offset = offset;
		}
		else
		{
			this.offset = #if lime new Vector2() #else {} #end;
		}
	}
}
