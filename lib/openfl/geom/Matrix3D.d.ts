import Vector from "./../Vector";
import Orientation3D from "./Orientation3D";
import Vector3D from "./Vector3D";


declare namespace openfl.geom {
	
	
	export class Matrix3D {
		
		
		public readonly determinant:number;
		
		protected get_determinant ():number;
		protected set_determinant (value:number):number;
		
		public position:Vector3D;
		
		protected get_position ():Vector3D;
		protected set_position (value:Vector3D):Vector3D;
		
		public rawData:Vector<number>;
		
		
		
		public constructor (v?:Vector<number>);
		
		
		//public inline append (lhs:Matrix3D):void;
		public append (lhs:Matrix3D):void;
		
		
		//public inline appendRotation (degrees:number, axis:Vector3D, pivotPoint:Vector3D = null):void;
		public appendRotation (degrees:number, axis:Vector3D, pivotPoint?:Vector3D):void;
		
		
		//public inline appendScale (xScale:number, yScale:number, zScale:number):void;
		public appendScale (xScale:number, yScale:number, zScale:number):void;
		
		
		//public inline appendTranslation (x:number, y:number, z:number):void;
		public appendTranslation (x:number, y:number, z:number):void;
		
		
		//public inline clone ():Matrix3D;
		public clone ():Matrix3D;
		
		
		public copyColumnFrom (column:number, vector3D:Vector3D):void;
		
		
		public copyColumnTo (column:number, vector3D:Vector3D):void;
		
		
		public copyFrom (other:Matrix3D):void;
		
		
		public copyRawDataFrom (vector:Vector<number>, index?:number, transpose?:boolean):void;
		
		
		public copyRawDataTo (vector:Vector<number>, index?:number, transpose?:boolean):void;
		
		
		public copyRowFrom (row:number, vector3D:Vector3D):void;
		
		
		public copyRowTo (row:number, vector3D:Vector3D):void;
		
		
		public copyToMatrix3D (other:Matrix3D):void;
		
		
		//public static create2D (x:number, y:number, scale:number = 1, rotation:number = 0):Matrix3D;
		//
		//
		//public static createABCD (a:number, b:number, c:number, d:number, tx:number, ty:number):Matrix3D;
		//
		//
		//public static createOrtho (x0:number, x1:number,  y0:number, y1:number, zNear:number, zFar:number):Matrix3D;
		
		
		public decompose (orientationStyle?:Orientation3D):Vector<Vector3D>;
		
		
		public deltaTransformVector (v:Vector3D):Vector3D;
		
		
		public identity ():void;
		
		
		public static interpolate (thisMat:Matrix3D, toMat:Matrix3D, percent:number):Matrix3D;
		
		
		//public inline interpolateTo (toMat:Matrix3D, percent:number):void;
		public interpolateTo (toMat:Matrix3D, percent:number):void;
		
		
		//public inline invert ():boolean;
		public invert ():boolean;
		
		
		public pointAt (pos:Vector3D, at?:Vector3D, up?:Vector3D):void;
		
		
		//public inline prepend (rhs:Matrix3D):void;
		public prepend (rhs:Matrix3D):void;
		
		
		//public inline prependRotation (degrees:number, axis:Vector3D, pivotPoint:Vector3D = null):void;
		public prependRotation (degrees:number, axis:Vector3D, pivotPoint?:Vector3D):void;
		
		
		//public inline prependScale (xScale:number, yScale:number, zScale:number):void;
		public prependScale (xScale:number, yScale:number, zScale:number):void;
		
		
		//public inline prependTranslation (x:number, y:number, z:number):void;
		public prependTranslation (x:number, y:number, z:number):void;
		
		
		public recompose (components:Vector<Vector3D>, orientationStyle?:Orientation3D):boolean;
		
		
		//public inline transformVector (v:Vector3D):Vector3D;
		public transformVector (v:Vector3D):Vector3D;
		
		
		public transformVectors (vin:Vector<number>, vout:Vector<number>):void;
		
		
		//public inline transpose ():void;
		public transpose ():void;
		
		
	}
	
	
}


export default openfl.geom.Matrix3D;