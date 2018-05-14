package openfl.geom {
	
	
	/**
	 * @externs
	 */
	public class PerspectiveProjection {
		
		
		//public static inline var TO_RADIAN:Float = 0.01745329251994329577; // Math.PI / 180
		
		public var fieldOfView:Number;
		public var focalLength:Number;
		public var projectionCenter:Point;
		
		
		public function PerspectiveProjection () {}
		
		
		public function toMatrix3D ():Matrix3D { return null; }
		
		
	}
	
	
}