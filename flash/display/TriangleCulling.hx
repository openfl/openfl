package flash.display;
#if (flash || display)


/**
 * Defines codes for culling algorithms that determine which triangles not to
 * render when drawing triangle paths.
 *
 * <p> The terms <code>POSITIVE</code> and <code>NEGATIVE</code> refer to the
 * sign of a triangle's normal along the z-axis. The normal is a 3D vector
 * that is perpendicular to the surface of the triangle. </p>
 *
 * <p> A triangle whose vertices 0, 1, and 2 are arranged in a clockwise order
 * has a positive normal value. That is, its normal points in a positive
 * z-axis direction, away from the current view point. When the
 * <code>TriangleCulling.POSITIVE</code> algorithm is used, triangles with
 * positive normals are not rendered. Another term for this is backface
 * culling. </p>
 *
 * <p> A triangle whose vertices are arranged in a counter-clockwise order has
 * a negative normal value. That is, its normal points in a negative z-axis
 * direction, toward the current view point. When the
 * <code>TriangleCulling.NEGATIVE</code> algorithm is used, triangles with
 * negative normals will not be rendered. </p>
 */
@:fakeEnum(String) extern enum TriangleCulling {

	/**
	 * Specifies culling of all triangles facing toward the current view point.
	 */
	NEGATIVE;

	/**
	 * Specifies no culling. All triangles in the path are rendered.
	 */
	NONE;

	/**
	 * Specifies culling of all triangles facing away from the current view
	 * point. This is also known as backface culling.
	 */
	POSITIVE;
}


#end
