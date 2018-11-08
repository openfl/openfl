import SharedObjectFlushStatus from "openfl/net/SharedObjectFlushStatus";
import * as assert from "assert";


describe ("ES6 | SharedObjectFlushStatus", function () {
	
	
	it ("test", function () {
		
		switch (""+SharedObjectFlushStatus.FLUSHED) {
			
			case SharedObjectFlushStatus.FLUSHED:
			case SharedObjectFlushStatus.PENDING:
				break;
			
		}
		
	});
	
	
});