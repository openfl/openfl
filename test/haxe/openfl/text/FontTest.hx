package openfl.text;


class FontTest { public static function __init__ () { Mocha.describe ("Haxe | Font", function () {
	
	
	Mocha.it ("fontName", function () {
		
		// TODO: Confirm functionality
		
		var font = new Font ();
		var exists = font.fontName;
		
		Assert.equal (exists, null);
		
	});
	
	
	Mocha.it ("fontStyle", function () {
		
		// TODO: Confirm functionality
		
		var font = new Font ();
		var exists = font.fontStyle;
		
		Assert.equal (exists, null);
		
	});
	
	
	Mocha.it ("fontType", function () {
		
		// TODO: Confirm functionality
		
		var font = new Font ();
		var exists = font.fontType;
		
		Assert.equal (exists, null);
		
	});
	
	
	Mocha.it ("new", function () {
		
		// TODO: Confirm functionality
		
		var font = new Font ();
		Assert.notEqual (font, null);
		
	});
	
	
	Mocha.it ("enumerateFonts", function () {
		
		// TODO: Confirm functionality
		
		var exists = Font.enumerateFonts;
		
		Assert.notEqual (exists, null);
		
	});
	
	
	Mocha.it ("registerFont", function () {
		
		// TODO: Confirm functionality
		
		var exists = Font.registerFont;
		
		Assert.notEqual (exists, null);
		
	});
	
	
}); }}