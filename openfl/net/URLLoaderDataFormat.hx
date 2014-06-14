package openfl.net; #if !flash


enum URLLoaderDataFormat {
	
	BINARY;
	TEXT;
	VARIABLES;
	
}


#else
typedef URLLoaderDataFormat = flash.net.URLLoaderDataFormat;
#end