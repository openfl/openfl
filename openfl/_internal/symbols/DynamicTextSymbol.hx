package openfl._internal.symbols;


import openfl._internal.swf.SWFLite;
import openfl.text.TextField;

#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end

@:access(openfl.text.TextField)


class DynamicTextSymbol extends SWFSymbol {
	
	
	public var align:/*TextFormatAlign*/String;
	public var border:Bool;
	public var color:Null<Int>;
	public var fontHeight:Int;
	public var fontID:Int;
	public var fontName:String;
	public var height:Float;
	public var html:Bool;
	public var indent:Null<Int>;
	public var input:Bool;
	public var leading:Null<Int>;
	public var leftMargin:Null<Int>;
	public var multiline:Bool;
	public var password:Bool;
	public var rightMargin:Null<Int>;
	public var selectable:Bool;
	public var text:String;
	public var width:Float;
	public var wordWrap:Bool;
	public var x:Float;
	public var y:Float;
	
	
	public function new () {
		
		super ();
		
	}
	
	
	private override function __createObject (swf:SWFLite):TextField {
		
		var textField = new TextField ();
		textField.__fromSymbol (swf, this);
		return textField;
		
	}
	
	
}