package openfl.geom; #if !flash


import openfl.Vector;


class Utils3D {
	
	
	//static function pointTowards(percent : Float, mat : Matrix3D, pos : Vector3D, ?at : Vector3D, ?up : Vector3D) : Matrix3D;
	
	
	public static function projectVector (m:Matrix3D, v:Vector3D):Vector3D {
		
		var n = m.rawData;
		var l_oProj = new Vector3D ();
		
		l_oProj.x = v.x * n[0] + v.y * n[4] + v.z * n[8] + n[12];
		l_oProj.y = v.x * n[1] + v.y * n[5] + v.z * n[9] + n[13];
		l_oProj.z = v.x * n[2] + v.y * n[6] + v.z * n[10] + n[14];
		var w:Float = v.x * n[3] + v.y * n[7] + v.z * n[11] + n[15];
		
		l_oProj.z /= w;
		l_oProj.x /= w;
		l_oProj.y /= w;
		
		return l_oProj;
		
	}
	
	
	//static function projectVectors(m : Matrix3D, verts : flash.Vector<Float>, projectedVerts : flash.Vector<Float>, uvts : flash.Vector<Float>) : Void;
	
	
}


#else
typedef Utils3D = flash.geom.Utils3D;
#end