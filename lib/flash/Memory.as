package flash {
	
	
	import flash.system.ApplicationDomain;
	import flash.utils.ByteArray;
	
	
	/**
	 * @externs
	 */
	public class Memory {
		
		
		public static function getByte (addr:int):int { return 0; }
		public static function getDouble (addr:int):Number { return 0; }
		public static function getI32 (addr:int):int { return 0; }
		public static function getFloat (addr:int):Number { return 0; }
		public static function getUI16 (addr:int):int { return 0; }
		public static function select (b:ByteArray):void {}
		public static function setByte (addr:int, v:int):void {}
		public static function setDouble (addr:int, v:Number):void {}
		public static function setFloat (addr:int, v:Number):void {}
		public static function setI16 (addr:int, v:int):void {}
		public static function setI32 (addr:int, v:int):void {}
		public static function signExtend1 (v:int):int { return 0; }
		public static function signExtend8 (v:int):int { return 0; }
		public static function signExtend16 (v:int):int { return 0; }
		
		
	}
	
	
}