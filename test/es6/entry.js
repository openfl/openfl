import Application from "openfl/display/Application";
import * as assert from "assert";


before (function () {
	
	var app = new Application ();
	app.create ({
		windows: [{
			width: 550,
			height: 400
		}]
	});
	app.exec ();
	
});