package openfl.geom;

#if (display || !flash)
import openfl.Vector;

/**
	The Utils3D class contains static methods that simplify the implementation of
	certain three-dimensional matrix operations.
**/
@:jsRequire("openfl/geom/Utils3D", "default")
extern class Utils3D
{
	#if flash
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
	@:noCompletion @:dox(hide) public static function pointTowards(percent:Float, mat:Matrix3D, pos:Vector3D, ?at:Vector3D, ?up:Vector3D):Matrix3D;
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
	public static function projectVector(m:Matrix3D, v:Vector3D):Vector3D;
	
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
	public static function projectVectors(m:Matrix3D, verts:Vector<Float>, projectedVerts:Vector<Float>, uvts:Vector<Float>):Void;
}
#else
typedef Utils3D = flash.geom.Utils3D;
#end
