package openfl.display {
	
	
	import openfl.events.EventDispatcher;
	
	
	/**
	 * @externs
	 */
	public class ShaderJob extends EventDispatcher {
		
		
		public var width:int;
		public var height:int;
		public function get progress ():Number { return 0; }
		public var shader:Shader;
		public var target:Object;
		
		
		public function ShaderJob (shader:Shader = null, target:Object = null, width:int = 0, height:int = 0) {}
		public function cancel ():void {}
		public function start (waitForCompletion:Boolean = false):void {}
		
		
	}
	
	
}