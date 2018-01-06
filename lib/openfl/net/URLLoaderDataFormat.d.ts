declare namespace openfl.net {
	
	/**
	 * The URLLoaderDataFormat class provides values that specify how downloaded
	 * data is received.
	 */
	export enum URLLoaderDataFormat {
		
		/**
		 * Specifies that downloaded data is received as raw binary data.
		 */
		BINARY = 0,
		
		/**
		 * Specifies that downloaded data is received as text.
		 */
		TEXT = 1,
		
		/**
		 * Specifies that downloaded data is received as URL-encoded variables.
		 */
		VARIABLES = 2
		
	}
	
}


export default openfl.net.URLLoaderDataFormat;