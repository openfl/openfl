package flash.display;
#if (flash || display)


/**
 * A class that provides constant values for visual blend mode effects. These
 * constants are used in the following:
 * <ul>
 *   <li> The <code>blendMode</code> property of the
 * flash.display.DisplayObject class.</li>
 *   <li> The <code>blendMode</code> parameter of the <code>draw()</code>
 * method of the flash.display.BitmapData class</li>
 * </ul>
 */
@:fakeEnum(String) extern enum BlendMode {

	/**
	 * Adds the values of the constituent colors of the display object to the
	 * colors of its background, applying a ceiling of 0xFF. This setting is
	 * commonly used for animating a lightening dissolve between two objects.
	 *
	 * <p>For example, if the display object has a pixel with an RGB value of
	 * 0xAAA633, and the background pixel has an RGB value of 0xDD2200, the
	 * resulting RGB value for the displayed pixel is 0xFFC833(because 0xAA +
	 * 0xDD > 0xFF, 0xA6 + 0x22 = 0xC8, and 0x33 + 0x00 = 0x33).</p>
	 */
	ADD;

	/**
	 * Applies the alpha value of each pixel of the display object to the
	 * background. This requires the <code>blendMode</code> property of the
	 * parent display object be set to
	 * <code>flash.display.BlendMode.LAYER</code>.
	 *
	 * <p>Not supported under GPU rendering.</p>
	 */
	ALPHA;

	/**
	 * Selects the darker of the constituent colors of the display object and the
	 * colors of the background(the colors with the smaller values). This
	 * setting is commonly used for superimposing type.
	 *
	 * <p>For example, if the display object has a pixel with an RGB value of
	 * 0xFFCC33, and the background pixel has an RGB value of 0xDDF800, the
	 * resulting RGB value for the displayed pixel is 0xDDCC00(because 0xFF >
	 * 0xDD, 0xCC < 0xF8, and 0x33 > 0x00 = 33).</p>
	 *
	 * <p>Not supported under GPU rendering.</p>
	 */
	DARKEN;

	/**
	 * Compares the constituent colors of the display object with the colors of
	 * its background, and subtracts the darker of the values of the two
	 * constituent colors from the lighter value. This setting is commonly used
	 * for more vibrant colors.
	 *
	 * <p>For example, if the display object has a pixel with an RGB value of
	 * 0xFFCC33, and the background pixel has an RGB value of 0xDDF800, the
	 * resulting RGB value for the displayed pixel is 0x222C33(because 0xFF -
	 * 0xDD = 0x22, 0xF8 - 0xCC = 0x2C, and 0x33 - 0x00 = 0x33).</p>
	 */
	DIFFERENCE;

	/**
	 * Erases the background based on the alpha value of the display object. This
	 * process requires that the <code>blendMode</code> property of the parent
	 * display object be set to <code>flash.display.BlendMode.LAYER</code>.
	 *
	 * <p>Not supported under GPU rendering.</p>
	 */
	ERASE;

	/**
	 * Adjusts the color of each pixel based on the darkness of the display
	 * object. If the display object is lighter than 50% gray, the display object
	 * and background colors are screened, which results in a lighter color. If
	 * the display object is darker than 50% gray, the colors are multiplied,
	 * which results in a darker color. This setting is commonly used for shading
	 * effects.
	 *
	 * <p>Not supported under GPU rendering.</p>
	 */
	HARDLIGHT;

	/**
	 * Inverts the background.
	 */
	INVERT;

	/**
	 * Forces the creation of a transparency group for the display object. This
	 * means that the display object is precomposed in a temporary buffer before
	 * it is processed further. The precomposition is done automatically if the
	 * display object is precached by means of bitmap caching or if the display
	 * object is a display object container that has at least one child object
	 * with a <code>blendMode</code> setting other than <code>"normal"</code>.
	 *
	 * <p>Not supported under GPU rendering.</p>
	 */
	LAYER;

	/**
	 * Selects the lighter of the constituent colors of the display object and
	 * the colors of the background(the colors with the larger values). This
	 * setting is commonly used for superimposing type.
	 *
	 * <p>For example, if the display object has a pixel with an RGB value of
	 * 0xFFCC33, and the background pixel has an RGB value of 0xDDF800, the
	 * resulting RGB value for the displayed pixel is 0xFFF833(because 0xFF >
	 * 0xDD, 0xCC < 0xF8, and 0x33 > 0x00 = 33).</p>
	 *
	 * <p>Not supported under GPU rendering.</p>
	 */
	LIGHTEN;

	/**
	 * Multiplies the values of the display object constituent colors by the
	 * constituent colors of the background color, and normalizes by dividing by
	 * 0xFF, resulting in darker colors. This setting is commonly used for
	 * shadows and depth effects.
	 *
	 * <p>For example, if a constituent color(such as red) of one pixel in the
	 * display object and the corresponding color of the pixel in the background
	 * both have the value 0x88, the multiplied result is 0x4840. Dividing by
	 * 0xFF yields a value of 0x48 for that constituent color, which is a darker
	 * shade than the color of the display object or the color of the
	 * background.</p>
	 */
	MULTIPLY;

	/**
	 * The display object appears in front of the background. Pixel values of the
	 * display object override the pixel values of the background. Where the
	 * display object is transparent, the background is visible.
	 */
	NORMAL;

	/**
	 * Adjusts the color of each pixel based on the darkness of the background.
	 * If the background is lighter than 50% gray, the display object and
	 * background colors are screened, which results in a lighter color. If the
	 * background is darker than 50% gray, the colors are multiplied, which
	 * results in a darker color. This setting is commonly used for shading
	 * effects.
	 *
	 * <p>Not supported under GPU rendering.</p>
	 */
	OVERLAY;

	/**
	 * Multiplies the complement(inverse) of the display object color by the
	 * complement of the background color, resulting in a bleaching effect. This
	 * setting is commonly used for highlights or to remove black areas of the
	 * display object.
	 */
	SCREEN;

	/**
	 * Uses a shader to define the blend between objects.
	 *
	 * <p>Setting the <code>blendShader</code> property to a Shader instance
	 * automatically sets the display object's <code>blendMode</code> property to
	 * <code>BlendMode.SHADER</code>. If the <code>blendMode</code> property is
	 * set to <code>BlendMode.SHADER</code> without first setting the
	 * <code>blendShader</code> property, the <code>blendMode</code> property is
	 * set to <code>BlendMode.NORMAL</code> instead. If the
	 * <code>blendShader</code> property is set(which sets the
	 * <code>blendMode</code> property to <code>BlendMode.SHADER</code>), then
	 * later the value of the <code>blendMode</code> property is changed, the
	 * blend mode can be reset to use the blend shader simply by setting the
	 * <code>blendMode</code> property to <code>BlendMode.SHADER</code>. The
	 * <code>blendShader</code> property does not need to be set again except to
	 * change the shader that's used to define the blend mode.</p>
	 *
	 * <p>Not supported under GPU rendering.</p>
	 */
	SHADER;

	/**
	 * Subtracts the values of the constituent colors in the display object from
	 * the values of the background color, applying a floor of 0. This setting is
	 * commonly used for animating a darkening dissolve between two objects.
	 *
	 * <p>For example, if the display object has a pixel with an RGB value of
	 * 0xAA2233, and the background pixel has an RGB value of 0xDDA600, the
	 * resulting RGB value for the displayed pixel is 0x338400(because 0xDD -
	 * 0xAA = 0x33, 0xA6 - 0x22 = 0x84, and 0x00 - 0x33 < 0x00).</p>
	 */
	SUBTRACT;
}


#end
