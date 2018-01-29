


import openfl.display.BitmapData;


describe ("TypeScript | Assets", function () {
	
	
	it ("cachedBitmapData", function () {
		
		
		
	});
	
	
	it ("id", function () {
		
		
		
	});
	
	
	it ("library", function () {
		
		
		
	});
	
	
	it ("path", function () {
		
		
		
	});
	
	
	it ("type", function () {
		
		
		
	});
	
	
	
	it ("getBitmapData", function () {
		
		
		
	});
	
	
	it ("getBytes", function () {
		
		
		
	});
	
	
	it ("getFont", function () {
		
		
		
	});
	
	
	it ("getMovieClip", function () {
		
		
		
	});
	
	
	it ("getSound", function () {
		
		
		
	});
	
	
	it ("getText", function () {
		
		
		
	});
	
	
	#if html5
	it ("embedBitmap", function () {
		
		// When an embedded bitmap is loaded more than once, it should
		// reuse the previously loaded image
		var preload = new BitmapData(1, 1, false, 0);
		MacroPreloadTest.preload = preload.image;
		assert.equal(1, new MacroPreloadTest(0, 0).width);
		
	}
	#end
	
});

#if html5
@:bitmap("openfl/1x1.png") class MacroPreloadTest extends BitmapData { }
#end
