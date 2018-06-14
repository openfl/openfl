package openfl.printing {
	
	
	import openfl.display.Sprite;
	import openfl.geom.Rectangle;
	
	
	/**
	 * @externs
	 */
	public class PrintJob {
		
		
		public static function get isSupported ():Boolean { return false; }
		
		public var orientation:String;
		public function get pageHeight ():int { return 0; }
		public function get pageWidth ():int { return 0; }
		public function get paperHeight ():int { return 0; }
		public function get paperWidth ():int { return 0; }
		
		
		public function PrintJob () {}
		
		public function addPage (sprite:Sprite, printArea:Rectangle = null, options:PrintJobOptions = null, frameNum:int = 0):void {}
		public function send ():void {}
		public function start ():Boolean { return false; }
		
		
	}
	
	
}