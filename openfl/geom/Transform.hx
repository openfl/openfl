package openfl.geom; #if !flash #if !openfl_legacy


import openfl.display.DisplayObject;


/**
 * The Transform class provides access to color adjustment properties and two-
 * or three-dimensional transformation objects that can be applied to a
 * display object. During the transformation, the color or the orientation and
 * position of a display object is adjusted(offset) from the current values
 * or coordinates to new values or coordinates. The Transform class also
 * collects data about color and two-dimensional matrix transformations that
 * are applied to a display object and all of its parent objects. You can
 * access these combined transformations through the
 * <code>concatenatedColorTransform</code> and <code>concatenatedMatrix</code>
 * properties.
 *
 * <p>To apply color transformations: create a ColorTransform object, set the
 * color adjustments using the object's methods and properties, and then
 * assign the <code>colorTransformation</code> property of the
 * <code>transform</code> property of the display object to the new
 * ColorTransformation object.</p>
 *
 * <p>To apply two-dimensional transformations: create a Matrix object, set
 * the matrix's two-dimensional transformation, and then assign the
 * <code>transform.matrix</code> property of the display object to the new
 * Matrix object.</p>
 *
 * <p>To apply three-dimensional transformations: start with a
 * three-dimensional display object. A three-dimensional display object has a
 * <code>z</code> property value other than zero. You do not need to create
 * the Matrix3D object. For all three-dimensional objects, a Matrix3D object
 * is created automatically when you assign a <code>z</code> value to a
 * display object. You can access the display object's Matrix3D object through
 * the display object's <code>transform</code> property. Using the methods of
 * the Matrix3D class, you can add to or modify the existing transformation
 * settings. Also, you can create a custom Matrix3D object, set the custom
 * Matrix3D object's transformation elements, and then assign the new Matrix3D
 * object to the display object using the <code>transform.matrix</code>
 * property.</p>
 *
 * <p>To modify a perspective projection of the stage or root object: use the
 * <code>transform.matrix</code> property of the root display object to gain
 * access to the PerspectiveProjection object. Or, apply different perspective
 * projection properties to a display object by setting the perspective
 * projection properties of the display object's parent. The child display
 * object inherits the new properties. Specifically, create a
 * PerspectiveProjection object and set its properties, then assign the
 * PerspectiveProjection object to the <code>perspectiveProjection</code>
 * property of the parent display object's <code>transform</code> property.
 * The specified projection transformation then applies to all the display
 * object's three-dimensional children.</p>
 *
 * <p>Since both PerspectiveProjection and Matrix3D objects perform
 * perspective transformations, do not assign both to a display object at the
 * same time. Use the PerspectiveProjection object for focal length and
 * projection center changes. For more control over the perspective
 * transformation, create a perspective projection Matrix3D object.</p>
 */

@:access(openfl.display.DisplayObject)
@:access(openfl.geom.ColorTransform)


class Transform {
	
	
	/**
	 * A ColorTransform object containing values that universally adjust the
	 * colors in the display object.
	 * 
	 * @throws TypeError The colorTransform is null when being set
	 */
	public var colorTransform (get, set):ColorTransform;
	
	/**
	 * A ColorTransform object representing the combined color transformations
	 * applied to the display object and all of its parent objects, back to the
	 * root level. If different color transformations have been applied at
	 * different levels, all of those transformations are concatenated into one
	 * ColorTransform object for this property.
	 */
	public var concatenatedColorTransform:ColorTransform;
	
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
	public var concatenatedMatrix:Matrix;
	
	/**
	 * A Matrix object containing values that alter the scaling, rotation, and
	 * translation of the display object.
	 *
	 * <p>If the <code>matrix</code> property is set to a value(not
	 * <code>null</code>), the <code>matrix3D</code> property is
	 * <code>null</code>. And if the <code>matrix3D</code> property is set to a
	 * value(not <code>null</code>), the <code>matrix</code> property is
	 * <code>null</code>.</p>
	 * 
	 * @throws TypeError The matrix is null when being set
	 */
	public var matrix (get, set):Matrix;
	
	/**
	 * Provides access to the Matrix3D object of a three-dimensional display
	 * object. The Matrix3D object represents a transformation matrix that
	 * determines the display object's position and orientation. A Matrix3D
	 * object can also perform perspective projection.
	 *
	 * <p>If the <code>matrix</code> property is set to a value(not
	 * <code>null</code>), the <code>matrix3D</code> property is
	 * <code>null</code>. And if the <code>matrix3D</code> property is set to a
	 * value(not <code>null</code>), the <code>matrix</code> property is
	 * <code>null</code>.</p>
	 */
	public var matrix3D (get, set):Matrix3D;
	
	/**
	 * A Rectangle object that defines the bounding rectangle of the display
	 * object on the stage.
	 */
	public var pixelBounds:Rectangle;
	
	@:noCompletion private var __colorTransform:ColorTransform;
	@:noCompletion private var __displayObject:DisplayObject;
	@:noCompletion private var __hasMatrix:Bool;
	@:noCompletion private var __hasMatrix3D:Bool;
	
	
	public function new (displayObject:DisplayObject) {
		
		__colorTransform = new ColorTransform ();
		concatenatedColorTransform = new ColorTransform ();
		concatenatedMatrix = new Matrix ();
		pixelBounds = new Rectangle ();
		
		__displayObject = displayObject;
		__hasMatrix = true;
		
	}
	
	
	
	
	// Get & Set Methods
	
	
	
	
	@:noCompletion private function get_colorTransform ():ColorTransform {
		
		return __colorTransform;
		
	}
	
	
	@:noCompletion private function set_colorTransform (value:ColorTransform):ColorTransform {
		
		if (!__colorTransform.__equals (value)) {
			
			__colorTransform = value;
			
			if (value != null) {
				
				__displayObject.alpha = value.alphaMultiplier;
				
			}
			
			__displayObject.__setRenderDirty ();
			
		}
		
		return __colorTransform;
		
	}
	
	
	@:noCompletion private function get_matrix ():Matrix {
		
		if (__hasMatrix) {
			
			return __displayObject.__transform.clone ();
			
		}
		
		return null;
		
	}
	
	
	@:noCompletion private function set_matrix (value:Matrix):Matrix {
		
		if (value == null) {
			
			__hasMatrix = false;
			return null;
			
		}
		
		__hasMatrix = true;
		__hasMatrix3D = false;
		
		if (__displayObject != null) {
			
			var rotation = (180 / Math.PI) * Math.atan2 (value.d, value.c) - 90;
			
			if (rotation != __displayObject.__rotation) {
				
				__displayObject.__rotation = rotation;
				var radians = rotation * (Math.PI / 180);
				__displayObject.__rotationSine = Math.sin (radians);
				__displayObject.__rotationCosine = Math.cos (radians);
				
			}
			
			__displayObject.__transform.copyFrom (value);
			__displayObject.__setTransformDirty ();
			
		}
		
		return value;
		
	}
	
	
	@:noCompletion private function get_matrix3D ():Matrix3D {
		
		if (__hasMatrix3D) {
			
			var matrix = __displayObject.__transform;
			return new Matrix3D ([ matrix.a, matrix.b, 0.0, 0.0, matrix.c, matrix.d, 0.0, 0.0, 0.0, 0.0, 1.0, 0.0, matrix.tx, matrix.ty, 0.0, 1.0 ]);
			
		}
		
		return null;
		
	}
	
	
	@:noCompletion private function set_matrix3D (value:Matrix3D):Matrix3D {
		
		if (value == null) {
			
			__hasMatrix3D = false;
			return null;
			
		}
		
		__hasMatrix = false;
		__hasMatrix3D = true;
		
		if (__displayObject != null) {
			
			var rotation = (180 / Math.PI) * Math.atan2 (value.rawData[5], value.rawData[4]) - 90;
			
			if (rotation != __displayObject.__rotation) {
				
				__displayObject.__rotation = rotation;
				var radians = rotation * (Math.PI / 180);
				__displayObject.__rotationSine = Math.sin (radians);
				__displayObject.__rotationCosine = Math.cos (radians);
				
			}
			
			__displayObject.__transform.a = value.rawData[0];
			__displayObject.__transform.b = value.rawData[1];
			__displayObject.__transform.c = value.rawData[5];
			__displayObject.__transform.d = value.rawData[6];
			__displayObject.__transform.tx = value.rawData[12];
			__displayObject.__transform.ty = value.rawData[13];
			
			__displayObject.__setTransformDirty ();
			
		}
		
		return value;
		
	}
	
	
}


#else
typedef Transform = openfl._legacy.geom.Transform;
#end
#else
typedef Transform = flash.geom.Transform;
#end