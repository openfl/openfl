package openfl.net; #if !flash


/**
 * The URLLoaderDataFormat class provides values that specify how downloaded
 * data is received.
 */
enum URLLoaderDataFormat {
	
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


#else
typedef URLLoaderDataFormat = flash.net.URLLoaderDataFormat;
#end