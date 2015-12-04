package openfl.net; #if (!display && !flash)


enum URLLoaderDataFormat {
	
	BINARY;
	TEXT;
	VARIABLES;
	
}


#else


/**
 * The URLLoaderDataFormat class provides values that specify how downloaded
 * data is received.
 */

#if flash
@:native("flash.net.URLLoaderDataFormat")
#end

@:fakeEnum(String) extern enum URLLoaderDataFormat {
	
	/**
	 * Specifies that downloaded data is received as raw binary data.
	 */
	BINARY;
	
	/**
	 * Specifies that downloaded data is received as text.
	 */
	TEXT;
	
	/**
	 * Specifies that downloaded data is received as URL-encoded variables.
	 */
	VARIABLES;
	
}


#end