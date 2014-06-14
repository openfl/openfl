package openfl.net; #if !flash


class URLVariables implements Dynamic {
	
	
	public function new (inEncoded:String = null) {
		
		if (inEncoded != null) {
			
			decode (inEncoded);
			
		}
		
	}
	
	
	public function decode (inVars:String):Void {
		
		var fields = Reflect.fields (this);
		
		for (f in fields) {
			
			Reflect.deleteField (this, f);
			
		}
		
		var fields = inVars.split (";").join ("&").split ("&");
		
		for (f in fields) {
			
			var eq = f.indexOf ("=");
			
			if (eq > 0) {
				
				Reflect.setField (this, StringTools.urlDecode (f.substr(0, eq)), StringTools.urlDecode (f.substr(eq + 1)));
				
			} else if (eq != 0) {
				
				Reflect.setField (this, StringTools.urlDecode (f), "");
				
			}
			
		}
		
	}
	
	
	public function toString ():String {
		
		var result = new Array<String> ();
		var fields = Reflect.fields (this);
		
		for (f in fields) {
			
			result.push (StringTools.urlEncode (f) + "=" + StringTools.urlEncode (Reflect.field (this, f)));
			
		}
		
		return result.join ("&");
		
	}
	
	
}


#else
typedef URLVariables = flash.net.URLVariables;
#end