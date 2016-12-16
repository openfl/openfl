package openfl.geom;


import openfl.Vector;

#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end


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
	
	
	public static function projectVectors (m:Matrix3D, verts:Vector<Float>, projectedVerts:Vector<Float>, uvts:Vector<Float>):Void {
		
		if ( verts.length % 3 != 0 ) return;
		
		var n = m.rawData,
			x:Float, y:Float, z:Float, w:Float,
			x1:Float, y1:Float, z1:Float, w1:Float,
			i:Int = 0;
		
		while ( i < verts.length ) {
			x = verts[i];
			y = verts[i + 1];
			z = verts[i + 2];
			w = 1;
			
			x1 = x * n[0] + y * n[4] + z * n[8] + w * n[12];
			y1 = x * n[1] + y * n[5] + z * n[9] + w * n[13];
			z1 = x * n[2] + y * n[6] + z * n[10] + w * n[14];
			w1 = x * n[3] + y * n[7] + z * n[11] + w * n[15];
			
			projectedVerts.push( x1 / w1 );
			projectedVerts.push( y1 / w1 );
			
			uvts[i + 2] = 1 / w1;
			
			i += 3;
		}
		
	}
	
	
}
