package openfl.text;


import massive.munit.Assert;


class FontTest {
	
	
	@Test public function fontName () {
		
		// TODO: Confirm functionality
		
		var font = new Font ();
		var exists = font.fontName;
		
		Assert.isNull (exists);
		
	}
	
	
	@Test public function fontStyle () {
		
		// TODO: Confirm functionality
		
		var font = new Font ();
		var exists = font.fontStyle;
		
		Assert.isNull (exists);
		
	}
	
	
	@Test public function fontType () {
		
		// TODO: Confirm functionality
		
		var font = new Font ();
		var exists = font.fontType;
		
		Assert.isNull (exists);
		
	}
	
	
	@Test public function new_ () {
		
		// TODO: Confirm functionality
		
		var font = new Font ();
		Assert.isNotNull (font);
		
	}
	
	
	@Test public function enumerateFonts () {
		
		// TODO: Confirm functionality
		
		var exists = Font.enumerateFonts;
		
		Assert.isNotNull (exists);
		
	}
	
	
	@Test public function registerFont () {
		
		// TODO: Confirm functionality
		
		var exists = Font.registerFont;
		
		Assert.isNotNull (exists);
		
	}
	
	
}