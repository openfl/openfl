import Vector from "./../Vector";
import Matrix3D from "./Matrix3D";
import Vector3D from "./Vector3D";


declare namespace openfl.geom {
	
	
	export class Utils3D {
	
	
		// #if flash
		// @:noCompletion @:dox(hide) public static function pointTowards (percent:Float, mat:Matrix3D, pos:Vector3D, ?at:Vector3D, ?up:Vector3D):Matrix3D;
		// #end
		
		
		public static projectVector (m:Matrix3D, v:Vector3D):Vector3D;
		public static projectVectors (m:Matrix3D, verts:Vector<number>, projectedVerts:Vector<number>, uvts:Vector<number>):void;
		
		
	}
	
	
}


export default openfl.geom.Utils3D;