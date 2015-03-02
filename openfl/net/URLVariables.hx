package openfl.net; #if !flash


/**
 * The URLVariables class allows you to transfer variables between an
 * application and a server. Use URLVariables objects with methods of the
 * URLLoader class, with the <code>data</code> property of the URLRequest
 * class, and with flash.net package functions.
 */
class URLVariables implements Dynamic {
	
	
	/**
	 * Creates a new URLVariables object. You pass URLVariables objects to the
	 * <code>data</code> property of URLRequest objects.
	 *
	 * <p>If you call the URLVariables constructor with a string, the
	 * <code>decode()</code> method is automatically called to convert the string
	 * to properties of the URLVariables object.</p>
	 * 
	 * @param source A URL-encoded string containing name/value pairs.
	 */
	public function new (inEncoded:String = null) {
		
		if (inEncoded != null) {
			
			decode (inEncoded);
			
		}
		
	}
	
	
	/**
	 * Converts the variable string to properties of the specified URLVariables
	 * object.
	 *
	 * <p>This method is used internally by the URLVariables events. Most users
	 * do not need to call this method directly.</p>
	 * 
	 * @param source A URL-encoded query string containing name/value pairs.
	 * @throws Error The source parameter must be a URL-encoded query string
	 *               containing name/value pairs.
	 */
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
	
	
	/**
	 * Returns a string containing all enumerable variables, in the MIME content
	 * encoding <i>application/x-www-form-urlencoded</i>.
	 * 
	 * @return A URL-encoded string containing name/value pairs.
	 */
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