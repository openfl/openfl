package openfl.utils;


#if flash
typedef CompressionAlgorithm = flash.utils.CompressionAlgorithm;
#elseif !openfl_legacy
typedef CompressionAlgorithm = lime.utils.CompressionAlgorithm;
#else
typedef CompressionAlgorithm = openfl._legacy.utils.CompressionAlgorithm;
#end