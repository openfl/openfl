package test;


import haxe.Timer;
import lime.app.Application;
import lime.graphics.opengl.GL;
import openfl.display.Bitmap;
import openfl.display.Sprite;
import openfl.events.Event;
import openfl.text.TextField;
import openfl.text.TextFieldAutoSize;
import openfl.text.TextFormat;
import openfl.utils.Assets;


class ContextLossTest1 extends FunctionalTest {
	
	
	private var bitmap:Bitmap;
	private var contextID = 0;
	private var direction = 1;
	private var extension:Dynamic;
	private var frame = 0;
	private var framesPerReset = 20;
	private var margin = 100;
	private var status:TextField;
	
	
	public function new () {
		
		super ();
		
	}
	
	
	public override function start ():Void {
		
		var bitmapData = Assets.getBitmapData ("assets/openfl.png");
		bitmap = new Bitmap (bitmapData);
		bitmap.x = margin;
		bitmap.y = margin;
		content.addChild (bitmap);
		content.addEventListener (Event.ENTER_FRAME, content_onEnterFrame);
		
		var textFormat = new TextFormat ("_sans", 24, 0, false);
		status = new TextField ();
		status.selectable = false;
		status.defaultTextFormat = textFormat;
		status.x = 0;
		status.y = 0;
		status.autoSize = TextFieldAutoSize.LEFT;
		status.textColor = 0xe8c343;
		content.addChild (status);
		
		if (GL.context != null) {
			
			extension = GL.getExtension ("WEBGL_lose_context");
			
			if (extension != null) {
				
				status.text = "Context Loss: " + contextID;
				Application.current.onUpdate.add (application_onUpdate);
				
			} else {
				
				status.text = "Context Loss: (Not supported)";
				
			}
			
		}
		
	}
	
	
	public override function stop ():Void {
		
		content.removeEventListener (Event.ENTER_FRAME, content_onEnterFrame);
		Application.current.onUpdate.remove (application_onUpdate);
		
		content.removeChild (bitmap);
		content.removeChild (status);
		
	}
	
	
	// Event Handlers
	
	
	private function application_onUpdate (deltaTime:Int):Void {
		
		// Event.ENTER_FRAME stops dispatching when context is lost
		
		frame++;
		
		if (frame == framesPerReset) {
			
			extension.loseContext ();
			
		} else if (frame > framesPerReset) {
			
			frame = 0;
			
			contextID++;
			status.text = "Context Loss: " + contextID;
			
			extension.restoreContext ();
			
		}
		
	}
	
	
	private function content_onEnterFrame (event:Event):Void {
		
		bitmap.x += direction;
		
		if (bitmap.x >= contentWidth - margin || bitmap.x <= margin) {
			
			direction *= -1;
			
		}
		
	}
	
	
}