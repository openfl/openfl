/*
 
 This class provides code completion and inline documentation, but it does 
 not contain runtime support. It should be overridden by a compatible
 implementation in an OpenFL backend, depending upon the target platform.
 
*/
package openfl.geom;
#if display

/**
 * The Orientation3D class is an enumeration of constant values for representing the 
 * orientation style of a Matrix3D object. The three types of orientation are Euler 
 * angles, axis angle, and quaternion. The decompose and recompose methods of the 
 * Matrix3D object take one of these enumerated types to identify the rotational 
 * components of the Matrix.
 */
@:fakeEnum(String) extern enum Orientation3D {

	/**
	 * Specifies that the orientation is an axis angle.
	 */
	AXIS_ANGLE;

	/**
	 * Specifies that the orientation is a Euler angle
	 */
	EULER_ANGLES;

	/**
	 * Specifies that the orientation is a quaternion.
	 */
	QUATERNION;

}

#end