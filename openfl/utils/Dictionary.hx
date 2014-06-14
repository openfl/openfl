package openfl.utils; #if !flash


class Dictionary implements ArrayAccess<Dynamic> {
	
	
	public function new (weakKeys:Bool = false) {
		
		
		
	}
	
	
}


#else
typedef Dictionary = flash.utils.Dictionary;
#end