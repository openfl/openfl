package flash.geom {
	
	
	import flash.display.DisplayObject;
	
	
	/**
	 * @externs
	 * The Transform class provides access to color adjustment properties and two-
	 * or three-dimensional transformation objects that can be applied to a
	 * display object. During the transformation, the color or the orientation and
	 * position of a display object is adjusted(offset) from the current values
	 * or coordinates to new values or coordinates. The Transform class also
	 * collects data about color and two-dimensional matrix transformations that
	 * are applied to a display object and all of its parent objects. You can
	 * access these combined transformations through the
	 * `concatenatedColorTransform` and `concatenatedMatrix`
	 * properties.
	 *
	 * To apply color transformations: create a ColorTransform object, set the
	 * color adjustments using the object's methods and properties, and then
	 * assign the `colorTransformation` property of the
	 * `transform` property of the display object to the new
	 * ColorTransformation object.
	 *
	 * To apply two-dimensional transformations: create a Matrix object, set
	 * the matrix's two-dimensional transformation, and then assign the
	 * `transform.matrix` property of the display object to the new
	 * Matrix object.
	 *
	 * To apply three-dimensional transformations: start with a
	 * three-dimensional display object. A three-dimensional display object has a
	 * `z` property value other than zero. You do not need to create
	 * the Matrix3D object. For all three-dimensional objects, a Matrix3D object
	 * is created automatically when you assign a `z` value to a
	 * display object. You can access the display object's Matrix3D object through
	 * the display object's `transform` property. Using the methods of
	 * the Matrix3D class, you can add to or modify the existing transformation
	 * settings. Also, you can create a custom Matrix3D object, set the custom
	 * Matrix3D object's transformation elements, and then assign the new Matrix3D
	 * object to the display object using the `transform.matrix`
	 * property.
	 *
	 * To modify a perspective projection of the stage or root object: use the
	 * `transform.matrix` property of the root display object to gain
	 * access to the PerspectiveProjection object. Or, apply different perspective
	 * projection properties to a display object by setting the perspective
	 * projection properties of the display object's parent. The child display
	 * object inherits the new properties. Specifically, create a
	 * PerspectiveProjection object and set its properties, then assign the
	 * PerspectiveProjection object to the `perspectiveProjection`
	 * property of the parent display object's `transform` property.
	 * The specified projection transformation then applies to all the display
	 * object's three-dimensional children.
	 *
	 * Since both PerspectiveProjection and Matrix3D objects perform
	 * perspective transformations, do not assign both to a display object at the
	 * same time. Use the PerspectiveProjection object for focal length and
	 * projection center changes. For more control over the perspective
	 * transformation, create a perspective projection Matrix3D object.
	 */
	public class Transform {
		
		
		/**
		 * A ColorTransform object containing values that universally adjust the
		 * colors in the display object.
		 * 
		 * @throws TypeError The colorTransform is null when being set
		 */
		public var colorTransform:ColorTransform;
		
		protected function get_colorTransform ():ColorTransform { return null; }
		protected function set_colorTransform (value:ColorTransform):ColorTransform { return null; }
		
		/**
		 * A ColorTransform object representing the combined color transformations
		 * applied to the display object and all of its parent objects, back to the
		 * root level. If different color transformations have been applied at
		 * different levels, all of those transformations are concatenated into one
		 * ColorTransform object for this property.
		 */
		public function get concatenatedColorTransform ():ColorTransform { return null; }
		
		/**
		 * A Matrix object representing the combined transformation matrixes of the
		 * display object and all of its parent objects, back to the root level. If
		 * different transformation matrixes have been applied at different levels,
		 * all of those matrixes are concatenated into one matrix for this property.
		 * Also, for resizeable SWF content running in the browser, this property
		 * factors in the difference between stage coordinates and window coordinates
		 * due to window resizing. Thus, the property converts local coordinates to
		 * window coordinates, which may not be the same coordinate space as that of
		 * the Stage.
		 */
		public function get concatenatedMatrix ():Matrix { return null; }
		
		protected function get_concatenatedMatrix ():Matrix { return null; }
		
		/**
		 * A Matrix object containing values that alter the scaling, rotation, and
		 * translation of the display object.
		 *
		 * If the `matrix` property is set to a value(not
		 * `null`), the `matrix3D` property is
		 * `null`. And if the `matrix3D` property is set to a
		 * value(not `null`), the `matrix` property is
		 * `null`.
		 * 
		 * @throws TypeError The matrix is null when being set
		 */
		public var matrix:Matrix;
		
		protected function get_matrix ():Matrix { return null; }
		protected function set_matrix (value:Matrix):Matrix { return null; }
		
		/**
		 * Provides access to the Matrix3D object of a three-dimensional display
		 * object. The Matrix3D object represents a transformation matrix that
		 * determines the display object's position and orientation. A Matrix3D
		 * object can also perform perspective projection.
		 *
		 * If the `matrix` property is set to a value(not
		 * `null`), the `matrix3D` property is
		 * `null`. And if the `matrix3D` property is set to a
		 * value(not `null`), the `matrix` property is
		 * `null`.
		 */
		public var matrix3D:Matrix3D;
		
		protected function get_matrix3D ():Matrix3D { return null; }
		protected function set_matrix3D (value:Matrix3D):Matrix3D { return null; }
		
		// #if flash
		// @:noCompletion @:dox(hide) @:require(flash10) public var perspectiveProjection:PerspectiveProjection;
		// #end
		
		/**
		 * A Rectangle object that defines the bounding rectangle of the display
		 * object on the stage.
		 */
		public function get pixelBounds ():Rectangle { return null; }
		
		
		public function Transform (displayObject:DisplayObject) {}
		
		// #if flash
		// @:noCompletion @:dox(hide) @:require(flash10) public function getRelativeMatrix3D (relativeTo:DisplayObject):Matrix3D;
		// #end
		
		
	}
	
	
}