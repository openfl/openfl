package format.swf.lite.symbols;


//import flash.text.TextFormatAlign;


class DynamicTextSymbol extends SWFSymbol {

	@:s public var variableName:String = "";
	@:s public var align:/*TextFormatAlign*/String = "";
	@:s public var border:Bool;
	@:s public var color:Null<Int>;
	@:s public var fontHeight:Int;
	@:s public var fontID:Int;
	@:s public var fontName:String = "";
	@:s public var height:Float;
	@:s public var html:Bool;
	@:s public var indent:Null<Int>;
	@:s public var leading:Null<Int>;
	@:s public var leftMargin:Null<Int>;
	@:s public var multiline:Bool;
	@:s public var password:Bool;
	@:s public var rightMargin:Null<Int>;
	@:s public var selectable:Bool;
	@:s public var text:String = "";
	@:s public var width:Float;
	@:s public var wordWrap:Bool;
	@:s public var x:Float;
	@:s public var y:Float;
	@:s public var maxLength:Null<Int>;


	public function new () {

		super ();

	}


}
