import Font from "openfl/text/Font";
import * as assert from "assert";


describe ("TypeScript | Font", function () {
	
	
	it ("fontName", function () {
		
		// TODO: Confirm functionality
		
		var font = new Font ();
		var exists = font.fontName;
		
		assert.equal (exists, null);
		
	});
	
	
	it ("fontStyle", function () {
		
		// TODO: Confirm functionality
		
		var font = new Font ();
		var exists = font.fontStyle;
		
		assert.equal (exists, null);
		
	});
	
	
	it ("fontType", function () {
		
		// TODO: Confirm functionality
		
		var font = new Font ();
		var exists = font.fontType;
		
		assert.equal (exists, null);
		
	});
	
	
	it ("new", function () {
		
		// TODO: Confirm functionality
		
		var font = new Font ();
		assert.notEqual (font, null);
		
	});
	
	
	it ("enumerateFonts", function () {
		
		// TODO: Confirm functionality
		
		var exists = Font.enumerateFonts;
		
		assert.notEqual (exists, null);
		
	});
	
	
	it ("registerFont", function () {
		
		// TODO: Confirm functionality
		
		var exists = Font.registerFont;
		
		assert.notEqual (exists, null);
		
	});
	
	
});