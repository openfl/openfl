package openfl.geom;

#if !flash
import openfl.Vector;

/**
	The Utils3D class contains static methods that simplify the implementation of
	certain three-dimensional matrix operations.
**/
#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end
class Utils3D
{
	#if false
	/**
		Interpolates the orientation of an object toward a position. The `pointTowards()`
		method combines the functionality of the `Matrix3D.pointAt()` and
		`Matrix3D.interpolateTo()` methods.

		The `pointTowards()` method allows for in-place modification to the orientation.
		It decomposes the Matrix3D of the display object and replaces the rotation
		elements by ones that make a percent turn toward the position of the target. The
		object can make an incremental turn toward the target while still moving in its
		own direction. The consecutive calls to the `pointTowards()` followed by a
		translation method can produce the animation of an object chasing or following a
		moving target. First point the object a percent point toward the target, then
		incrementally move the object along an axis.

		@param	percent	A Number between 0 and 1 that incrementally turns the object
		toward the target.
		@param	mat	The Matrix3D property of the object that is transformed.
		@param	pos	The world-relative position of the target object. World-relative
		defines the transformation of the object relative to the world space and
		coordinates, where all objects are positioned.
		@param	at	The object-relative vector that defines where the display object is
		pointing. Object-relative defines the transformation of the object relative to the
		object space, the object's own frame of reference and coordinate system. Default
		value is (0,0,-1).
		@param	up	The object-relative vector that defines "up" for the display object.
		If the object is drawn looking down from the above, the +z axis is its "up"
		vector. Object-relative defines the transformation of the object relative to the
		object space, the object's own frame of reference and coordinate system. Default
		value is (0,-1,0).
		@returns	A modified version of the Matrix3D object specified in the second
		parameter. To transform the display object using the `pointTowards()` method, set
		the Matrix3D property of the display object to the returned Matrix3D object.
	**/
	// static function pointTowards(percent : Float, mat : Matrix3D, pos : Vector3D, ?at : Vector3D, ?up : Vector3D) : Matrix3D;
	#end

	/**
		Using a projection Matrix3D object, projects a Vector3D object from one space
		coordinate to another. The `projectVector()` method is like the
		`Matrix3D.transformVector()` method except that the `projectVector()` method
		divides the x, y, and z elements of the original Vector3D object by the
		projection depth value. The depth value is the distance from the eye to the
		Vector3D object in view or eye space. The default value for this distance is the
		value of the z element.

		@param	m	A projection Matrix3D object that implements the projection
		transformation. If a display object has a PerspectiveProjection object, you can
		use the `perspectiveProjection.toMatrix()` method to produce a projection Matrix3D
		object that applies to the children of the display object. For more advance
		projections, use the `matrix3D.rawData` property to create a custom projection
		matrix. There is no built-in Matrix3D method for creating a projection Matrix3D
		object.
		@param	v	The Vector3D object that is projected to a new space coordinate.
		@returns	A new Vector3D with a transformed space coordinate.
	**/
	public static function projectVector(m:Matrix3D, v:Vector3D):Vector3D
	{
		var n = m.rawData;
		var l_oProj = new Vector3D();

		l_oProj.x = v.x * n[0] + v.y * n[4] + v.z * n[8] + n[12];
		l_oProj.y = v.x * n[1] + v.y * n[5] + v.z * n[9] + n[13];
		l_oProj.z = v.x * n[2] + v.y * n[6] + v.z * n[10] + n[14];
		var w:Float = v.x * n[3] + v.y * n[7] + v.z * n[11] + n[15];

		l_oProj.z /= w;
		l_oProj.x /= w;
		l_oProj.y /= w;

		return l_oProj;
	}

	/**
		Using a projection Matrix3D object, projects a Vector of three-dimensional space
		coordinates (`verts`) to a Vector of two-dimensional space coordinates
		(`projectedVerts`). The projected Vector object should be pre-allocated before it
		is used as a parameter.

		The `projectVectors()` method also sets the t value of the uvt data. You should
		pre-allocate a Vector that can hold the uvts data for each projected Vector set of
		coordinates. Also specify the u and v values of the uvt data. The uvt data is a
		Vector of normalized coordinates used for texture mapping. In UV coordinates,
		(0,0) is the upper left of the bitmap, and (1,1) is the lower right of the bitmap.

		This method can be used in conjunction with the `Graphics.drawTriangles()` method
		and the GraphicsTrianglePath class.

		@param	m	A projection Matrix3D object that implements the projection
		transformation. You can produce a projection Matrix3D object using the
		`Matrix3D.rawData` property.
		@param	verts	A Vector of Floats, where every three Floats represent the x, y,
		and z coordinates of a three-dimensional space, like `Vector3D(x,y,z)`.
		@param	projectedVerts	A vector of Floats, where every two Floats represent a
		projected two-dimensional coordinate, like Point(x,y). You should pre-allocate the
		Vector. The `projectVectors()` method fills the values for each projected point.
		@param	uvts	A vector of Floats, where every three Floats represent the u, v,
		and t elements of the uvt data. The u and v are the texture coordinate for each
		projected point. The t value is the projection depth value, the distance from
		the eye to the Vector3D object in the view or eye space. You should pre-allocate
		the Vector and specify the u and v values. The projectVectors method fills the t
		value for each projected point.
	**/
	public static function projectVectors(m:Matrix3D, verts:Vector<Float>, projectedVerts:Vector<Float>, uvts:Vector<Float>):Void
	{
		if (verts.length % 3 != 0) return;

		var n = m.rawData;
		var x, y, z, w;
		var x1, y1, z1, w1;
		var i = 0;

		while (i < verts.length)
		{
			x = verts[i];
			y = verts[i + 1];
			z = verts[i + 2];
			w = 1;

			x1 = x * n[0] + y * n[4] + z * n[8] + w * n[12];
			y1 = x * n[1] + y * n[5] + z * n[9] + w * n[13];
			z1 = x * n[2] + y * n[6] + z * n[10] + w * n[14];
			w1 = x * n[3] + y * n[7] + z * n[11] + w * n[15];

			projectedVerts.push(x1 / w1);
			projectedVerts.push(y1 / w1);

			uvts[i + 2] = 1 / w1;

			i += 3;
		}
	}
}
#else
typedef Utils3D = flash.geom.Utils3D;
#end
