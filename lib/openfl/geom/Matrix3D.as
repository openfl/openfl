package openfl.geom {
	
	
	// import openfl.Vector;
	
	
	/**
	 * @externs
	 */
	public class Matrix3D {
		
		
		public function get determinant ():Number { return 0; }
		
		protected function get_determinant ():Number { return 0; }
		protected function set_determinant (value:Number):Number { return 0; }
		
		public var position:Vector3D;
		
		protected function get_position ():Vector3D { return null; }
		protected function set_position (value:Vector3D):Vector3D { return null; }
		
		public var rawData:Vector.<Number>;
		
		
		
		public function Matrix3D (v:Vector.<Number> = null) {}
		
		
		//public inline function append (lhs:Matrix3D):void {}
		public function append (lhs:Matrix3D):void {}
		
		
		//public inline function appendRotation (degrees:Number, axis:Vector3D, pivotPoint:Vector3D = null):void {}
		public function appendRotation (degrees:Number, axis:Vector3D, pivotPoint:Vector3D = null):void {}
		
		
		//public inline function appendScale (xScale:Number, yScale:Number, zScale:Number):void {}
		public function appendScale (xScale:Number, yScale:Number, zScale:Number):void {}
		
		
		//public inline function appendTranslation (x:Number, y:Number, z:Number):void {}
		public function appendTranslation (x:Number, y:Number, z:Number):void {}
		
		
		//public inline function clone ():Matrix3D;
		public function clone ():Matrix3D { return null; }
		
		
		public function copyColumnFrom (column:int, vector3D:Vector3D):void {}
		
		
		public function copyColumnTo (column:int, vector3D:Vector3D):void {}
		
		
		public function copyFrom (other:Matrix3D):void {}
		
		
		public function copyRawDataFrom (vector:Vector.<Number>, index:uint = 0, transpose:Boolean = false):void {}
		
		
		public function copyRawDataTo (vector:Vector.<Number>, index:uint = 0, transpose:Boolean = false):void {}
		
		
		public function copyRowFrom (row:uint, vector3D:Vector3D):void {}
		
		
		public function copyRowTo (row:int, vector3D:Vector3D):void {}
		
		
		public function copyToMatrix3D (other:Matrix3D):void {}
		
		
		//public static function create2D (x:Number, y:Number, scale:Number = 1, rotation:Number = 0):Matrix3D;
		//
		//
		//public static function createABCD (a:Number, b:Number, c:Number, d:Number, tx:Number, ty:Number):Matrix3D;
		//
		//
		//public static function createOrtho (x0:Number, x1:Number,  y0:Number, y1:Number, zNear:Number, zFar:Number):Matrix3D;
		
		
		public function decompose (orientationStyle:String = null):Vector.<Number> { return null; }
		
		
		public function deltaTransformVector (v:Vector3D):Vector3D { return null; }
		
		
		public function identity ():void {}
		
		
		public static function interpolate (thisMat:Matrix3D, toMat:Matrix3D, percent:Number):Matrix3D { return null; }
		
		
		//public inline function interpolateTo (toMat:Matrix3D, percent:Number):void {}
		public function interpolateTo (toMat:Matrix3D, percent:Number):void {}
		
		
		//public inline function invert ():Boolean;
		public function invert ():Boolean { return false; }
		
		
		public function pointAt (pos:Vector3D, at:Vector3D = null, up:Vector3D = null):void {}
		
		
		//public inline function prepend (rhs:Matrix3D):void {}
		public function prepend (rhs:Matrix3D):void {}
		
		
		//public inline function prependRotation (degrees:Number, axis:Vector3D, pivotPoint:Vector3D = null):void {}
		public function prependRotation (degrees:Number, axis:Vector3D, pivotPoint:Vector3D = null):void {}
		
		
		//public inline function prependScale (xScale:Number, yScale:Number, zScale:Number):void {}
		public function prependScale (xScale:Number, yScale:Number, zScale:Number):void {}
		
		
		//public inline function prependTranslation (x:Number, y:Number, z:Number):void {}
		public function prependTranslation (x:Number, y:Number, z:Number):void {}
		
		
		public function recompose (components:Vector.<Number>, orientationStyle:String = null):Boolean { return false; }
		
		
		//public inline function transformVector (v:Vector3D):Vector3D;
		public function transformVector (v:Vector3D):Vector3D { return null; }
		
		
		public function transformVectors (vin:Vector.<Number>, vout:Vector.<Number>):void {}
		
		
		//public inline function transpose ():void {}
		public function transpose ():void {}
		
		
	}
	
	
}