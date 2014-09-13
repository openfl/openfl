package openfl.net;


class URLVariables implements Dynamic {
	
	
	public function new (encoded:String = null) {
		
		if (encoded != null) {
			
			decode (encoded);
			
		}
		
	}
	
	
	public function decode (data:String):Void {
		
		var fields = Reflect.fields (this);
		
		for (field in fields) {
			
			Reflect.deleteField (this, field);
			
		}
		
		var fields = data.split (";").join ("&").split ("&");
		
		for (field in fields) {
			
			var index = field.indexOf("=");
			
			if (index > 0) {
				
				Reflect.setField (this, StringTools.urlDecode (field.substr (0, index)), StringTools.urlDecode (field.substr (index + 1)));
				
			} else if (index != 0) {
				
				Reflect.setField (this, StringTools.urlDecode (field), "");
				
			}
			
		}
		
	}
	
	
	public function toString ():String {
		
		var result = new Array<String> ();
		var fields = Reflect.fields (this);
		
		for (field in fields) {
			
			result.push (StringTools.urlEncode (field) + "=" + StringTools.urlEncode (Reflect.field (this, field)));
			
		}
		
		return result.join ("&");
		
	}
	
	
}