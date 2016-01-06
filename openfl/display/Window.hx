package openfl.display;


import lime.app.Application;
import lime.app.Config;
import lime.graphics.Image;
import lime.ui.Window in LimeWindow;
import openfl.geom.Rectangle;
import openfl.Lib;

@:access(openfl.display.Stage)


class Window extends LimeWindow {
	
	
	public function new (config:WindowConfig = null) {
		
		super (config);
		
	}
	
	
	/**
	 * Captures the contents of this window's stage to a BitmapData
	 * @param	callback	function to call when the capture is taken
	 * @param	region	the region of the stage to capture. By default, captures the entire stage.
	 */
	
	@:access(Stage)
	@:access(openfl.geom.Rectangle)
	public function captureBitmap(callback:openfl.display.BitmapData->Void, ?region:Rectangle):Void {
		
		#if flash
			
			if (region == null) region = new Rectangle();
			if (region.x < 0) region.x = 0;
			if (region.y < 0) region.y = 0;
			if (region.width  == 0 || region.right  > stage.stageWidth ) region.right  = stage.stageWidth;
			if (region.height == 0 || region.bottom > stage.stageHeight) region.bottom = stage.stageHeight;
			
			var b:flash.display.BitmapData = new flash.display.BitmapData(Std.int(region.width), Std.int(region.height));
			var m:flash.geom.Matrix = new flash.geom.Matrix(1, 0, 0, 1, -region.x, -region.y);
			b.draw(stage);
			callback(b);
			
		#else
			
			captureImage(function (i:Image) {
				
				callback(BitmapData.fromImage(i, true));
				
			}, region != null ? region.__toLimeRectangle() : null);
			
		#end
		
	}
	
	
	public override function create (application:Application):Void {
		
		super.create (application);
		
		#if (!flash && !openfl_legacy)
		
		stage = new Stage (this, Reflect.hasField (config, "background") ? config.background : 0xFFFFFF);
		application.addModule (stage);
		
		#else
		
		stage = Lib.current.stage;
		
		#end
		
	}
	
	
}