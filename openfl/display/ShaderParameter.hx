package openfl.display;


@:final class ShaderParameter implements Dynamic {
	
	
	public var index (default, null):Dynamic;
	public var type (default, null):ShaderParameterType;
	public var value (get, set):Array<Dynamic>;
	
	private var __boolValues:Array<Bool>;
	private var __floatValues:Array<Float>;
	private var __intValues:Array<Int>;
	private var __isUniform:Bool;
	private var __name:String;
	private var __value:Array<Dynamic>;
	
	
	public function new () {
		
		index = 0;
		
	}
	
	
	
	
	// Get & Set Methods
	
	
	
	
	private inline function get_value ():Dynamic {
		
		return __value;
		
	}
	
	
	private function set_value (value:Array<Dynamic>):Dynamic {
		
		__value = value;
		
		switch (type) {
			
			case BOOL, BOOL2, BOOL3, BOOL4:
				
				return __boolValues = cast value;
			
			case INT, INT2, INT3, INT4:
				
				return __intValues = cast value;
			
			default:
				
				return __floatValues = cast value;
			
		}
		
	}
	
	
}