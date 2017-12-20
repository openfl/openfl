import URLRequestMethod from "openfl/net/URLRequestMethod";
import * as assert from "assert";


describe ("ES6 | URLRequestMethod", function () {
	
	
	it ("test", function () {
		
		switch (URLRequestMethod.DELETE + "") {
			
			case URLRequestMethod.DELETE:
			case URLRequestMethod.GET:
			case URLRequestMethod.HEAD:
			case URLRequestMethod.OPTIONS:
			case URLRequestMethod.POST:
			case URLRequestMethod.PUT:
				break;
			
		}
		
	});
	
	
});