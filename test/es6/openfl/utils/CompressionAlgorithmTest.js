import CompressionAlgorithm from "openfl/utils/CompressionAlgorithm";
import * as assert from "assert";


describe ("ES6 | CompressionAlgorithm", function () {
	
	
	it ("test", function () {
		
		switch (""+CompressionAlgorithm.DEFLATE) {
			
			case CompressionAlgorithm.DEFLATE:
			case CompressionAlgorithm.ZLIB:
			case CompressionAlgorithm.LZMA:
				break;
			default: //CompressionAlgorithm.GZIP:
			
		}
		
	});
	
	
});