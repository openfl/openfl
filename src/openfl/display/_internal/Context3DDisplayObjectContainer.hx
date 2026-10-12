package openfl.display._internal;

#if !flash
import openfl.display.Bitmap;
import openfl.display.BlendMode;
import openfl.display.DisplayObject;
import openfl.display.DisplayObjectContainer;
import openfl.display.Shader;
import openfl.filters.ColorMatrixFilter;
import openfl.utils.ByteArray;

#if !openfl_debug
@:fileXml(' tags="haxe,release" ')
@:noDebug
#end

@:access(openfl.display.DisplayObject)
@:access(openfl.display.DisplayObjectContainer)
@:access(openfl.display.BitmapData)
@:access(openfl.display.Graphics)
@:access(openfl.display.OpenGLRenderer)
@:access(openfl.display.Shader)
@:access(openfl.display._internal.Context3DGraphics)
@:access(openfl.filters.BitmapFilter)
@:access(openfl.filters.ColorMatrixFilter)
class Context3DDisplayObjectContainer
{
	private static var __colorMatrixDisplayObjectShader:ColorMatrixDisplayObjectShader;

	public static function renderDrawable(displayObjectContainer:DisplayObjectContainer, renderer:OpenGLRenderer):Void
	{
		displayObjectContainer.__cleanupRemovedChildren();

		if (!displayObjectContainer.__renderable || displayObjectContainer.__worldAlpha <= 0) return;

		if (__renderSingleBitmapColorMatrixFilter(displayObjectContainer, renderer))
		{
			renderer.__renderEvent(displayObjectContainer);
			return;
		}

		Context3DDisplayObject.renderDrawable(displayObjectContainer, renderer);

		if (displayObjectContainer.__cacheBitmap != null && !displayObjectContainer.__isCacheBitmapRender) return;

		if (displayObjectContainer.__children.length > 0)
		{
			renderer.__pushMaskObject(displayObjectContainer);
			// renderer.filterManager.pushObject (this);

			if (renderer.__stage != null)
			{
				for (child in displayObjectContainer.__children)
				{
					renderer.__renderDrawable(child);
					child.__renderDirty = false;
				}

				displayObjectContainer.__renderDirty = false;
			}
			else
			{
				for (child in displayObjectContainer.__children)
				{
					renderer.__renderDrawable(child);
				}
			}
		}

		if (displayObjectContainer.__children.length > 0)
		{
			// renderer.filterManager.popObject (this);
			renderer.__popMaskObject(displayObjectContainer);
		}
	}

	private static function __renderSingleBitmapColorMatrixFilter(displayObjectContainer:DisplayObjectContainer, renderer:OpenGLRenderer):Bool
	{
		#if openfl_disable_filters
		return false;
		#else
		if (displayObjectContainer.__filters == null) return false;
		if (renderer.__type != OPENGL) return __rejectColorMatrixFastPath(displayObjectContainer, "renderer-not-opengl", null);
		if (displayObjectContainer.__cacheAsBitmap) return __rejectColorMatrixFastPath(displayObjectContainer, "explicit-cache-as-bitmap", null);
		if (__hasDrawableGraphics(displayObjectContainer)) return __rejectColorMatrixFastPath(displayObjectContainer, "root-graphics", displayObjectContainer);
		if (displayObjectContainer.opaqueBackground != null) return __rejectColorMatrixFastPath(displayObjectContainer, "root-opaque-background", null);
		if (displayObjectContainer.__mask != null) return __rejectColorMatrixFastPath(displayObjectContainer, "root-mask", null);
		if (displayObjectContainer.__scrollRect != null) return __rejectColorMatrixFastPath(displayObjectContainer, "root-scroll-rect", null);
		if (displayObjectContainer.__filters.length != 1)
		{
			return __rejectColorMatrixFastPath(displayObjectContainer, "multiple-filters", null);
		}

		var filter = displayObjectContainer.__filters[0];
		if (!__isColorMatrixFilter(filter))
		{
			return __rejectColorMatrixFastPath(displayObjectContainer, "not-color-matrix", null);
		}
		if (filter.__numShaderPasses != 1) return __rejectColorMatrixFastPath(displayObjectContainer, "multiple-shader-passes", null);
		if (filter.__preserveObject) return __rejectColorMatrixFastPath(displayObjectContainer, "preserve-object", null);

		var colorMatrixFilter:ColorMatrixFilter = cast filter;
		if (__isIdentityColorMatrix(colorMatrixFilter.__matrix))
		{
			__renderIdentityColorMatrixContainer(displayObjectContainer, colorMatrixFilter, renderer);
			return true;
		}

		var rejection = null;
		var leaf = __getSingleRenderableColorMatrixLeaf(displayObjectContainer, true, colorMatrixFilter, rejection);
		if (leaf != null)
		{
			Context3DDisplayObject.render(displayObjectContainer, renderer);
			if (!__isEmptyColorMatrixLeaf(leaf))
			{
				__renderColorMatrixLeaf(leaf, colorMatrixFilter, renderer);
			}
			filter.__renderDirty = false;
			leaf.__renderDirty = false;
			displayObjectContainer.__renderDirty = false;
			return true;
		}

		var leaves = [];
		var multiRejection = null;
		if (__collectRenderableColorMatrixLeaves(displayObjectContainer, true, colorMatrixFilter, leaves, multiRejection) && leaves.length > 0)
		{
			Context3DDisplayObject.render(displayObjectContainer, renderer);

			for (multiLeaf in leaves)
			{
				__renderColorMatrixLeaf(multiLeaf, colorMatrixFilter, renderer);
				multiLeaf.__renderDirty = false;
			}

			filter.__renderDirty = false;
			displayObjectContainer.__renderDirty = false;
			return true;
		}

		return __rejectColorMatrixFastPath(displayObjectContainer, multiRejection != null && multiRejection.length > 0 ? multiRejection[0] : (rejection != null
			&& rejection.length > 0 ? rejection[0] : "not-single-leaf"), null);
		#end
	}

	private static function __renderIdentityColorMatrixContainer(displayObjectContainer:DisplayObjectContainer, filter:ColorMatrixFilter,
			renderer:OpenGLRenderer):Void
	{
		var filters = displayObjectContainer.__filters;
		displayObjectContainer.__filters = null;

		try
		{
			Context3DDisplayObject.render(displayObjectContainer, renderer);

			if (displayObjectContainer.__children.length > 0)
			{
				renderer.__pushMaskObject(displayObjectContainer);

				if (renderer.__stage != null)
				{
					for (child in displayObjectContainer.__children)
					{
						renderer.__renderDrawable(child);
						child.__renderDirty = false;
					}

					displayObjectContainer.__renderDirty = false;
				}
				else
				{
					for (child in displayObjectContainer.__children)
					{
						renderer.__renderDrawable(child);
					}
				}

				renderer.__popMaskObject(displayObjectContainer);
			}

			filter.__renderDirty = false;
			displayObjectContainer.__renderDirty = false;
			displayObjectContainer.__filters = filters;
		}
		catch (e:Dynamic)
		{
			displayObjectContainer.__filters = filters;
			throw e;
		}
	}

	private static function __getSingleRenderableColorMatrixLeaf(displayObject:DisplayObject, isFilterRoot:Bool, rootFilter:ColorMatrixFilter,
			rejection:Array<String>):DisplayObject
	{
		if (!displayObject.__renderable) return __setSingleLeafRejection(rejection, "not-renderable", displayObject);
		if (displayObject.__worldAlpha <= 0) return __setSingleLeafRejection(rejection, "zero-alpha", displayObject);
		if (displayObject.__mask != null) return __setSingleLeafRejection(rejection, "child-mask", displayObject);
		if (displayObject.__scrollRect != null) return __setSingleLeafRejection(rejection, "child-scroll-rect", displayObject);
		if (displayObject.opaqueBackground != null) return __setSingleLeafRejection(rejection, "child-opaque-background", displayObject);
		if (displayObject.__customRenderEvent != null) return __setSingleLeafRejection(rejection, "custom-render-event", displayObject);
		if (!isFilterRoot && displayObject.__filters != null && !__canIgnoreNestedColorMatrixFilters(rootFilter, displayObject))
		{
			return __setSingleLeafRejection(rejection, "nested-filters", displayObject);
		}
		if (displayObject.__blendMode != BlendMode.NORMAL) return __setSingleLeafRejection(rejection, "non-normal-blend-mode", displayObject);

		var bitmap:Bitmap = __isBitmap(displayObject) ? cast displayObject : null;
		if (bitmap != null)
		{
			if (bitmap.__bitmapData == null) return __setSingleLeafRejection(rejection, "bitmap-without-bitmapdata", displayObject);
			if (!bitmap.__bitmapData.__isValid) return __setSingleLeafRejection(rejection, "invalid-bitmapdata", displayObject);
			return bitmap;
		}

		var container:DisplayObjectContainer = __isDisplayObjectContainer(displayObject) ? cast displayObject : null;
		if (__hasDrawableGraphics(displayObject))
		{
			if (container != null && container.__children != null && container.__children.length > 0)
			{
				return __setSingleLeafRejection(rejection, "graphics-with-children", displayObject);
			}
			if (displayObject.__graphics.__usedShaderBuffers.length > 0)
			{
				return __setSingleLeafRejection(rejection, "graphics-shader-fill", displayObject);
			}
			if (!Context3DGraphics.isCompatible(displayObject.__graphics))
			{
				return __setSingleLeafRejection(rejection, "graphics-software-render", displayObject);
			}
			return displayObject;
		}

		if (container == null) return __setSingleLeafRejection(rejection, "not-leaf-or-container", displayObject);
		if (container.__children == null) return __setSingleLeafRejection(rejection, "container-without-children", displayObject);
		if (container.__children.length == 0)
		{
			if (isFilterRoot) return container;
			return __setChildCountRejection(rejection, rootFilter, container);
		}
		if (container.__children.length != 1) return __setChildCountRejection(rejection, rootFilter, container);

		return __getSingleRenderableColorMatrixLeaf(container.__children[0], false, rootFilter, rejection);
	}

	private static inline function __hasDrawableGraphics(displayObject:DisplayObject):Bool
	{
		return displayObject.__graphics != null && displayObject.__graphics.__commands.length > 0;
	}

	private static inline function __isEmptyColorMatrixLeaf(displayObject:DisplayObject):Bool
	{
		var container:DisplayObjectContainer = __isDisplayObjectContainer(displayObject) ? cast displayObject : null;
		return container != null && !__hasDrawableGraphics(displayObject) && container.__children != null && container.__children.length == 0;
	}

	private static function __collectRenderableColorMatrixLeaves(displayObject:DisplayObject, isFilterRoot:Bool, rootFilter:ColorMatrixFilter,
			leaves:Array<DisplayObject>, rejection:Array<String>):Bool
	{
		if (!displayObject.__renderable) return __setMultiLeafRejection(rejection, "not-renderable", displayObject);
		if (displayObject.__worldAlpha <= 0) return __setMultiLeafRejection(rejection, "zero-alpha", displayObject);
		if (displayObject.__mask != null) return __setMultiLeafRejection(rejection, "child-mask", displayObject);
		if (displayObject.__scrollRect != null) return __setMultiLeafRejection(rejection, "child-scroll-rect", displayObject);
		if (displayObject.opaqueBackground != null) return __setMultiLeafRejection(rejection, "child-opaque-background", displayObject);
		if (displayObject.__customRenderEvent != null) return __setMultiLeafRejection(rejection, "custom-render-event", displayObject);
		if (!isFilterRoot && displayObject.__filters != null && !__canIgnoreNestedColorMatrixFilters(rootFilter, displayObject))
		{
			return __setMultiLeafRejection(rejection, "nested-filters", displayObject);
		}
		if (displayObject.__blendMode != BlendMode.NORMAL) return __setMultiLeafRejection(rejection, "non-normal-blend-mode", displayObject);

		var bitmap:Bitmap = __isBitmap(displayObject) ? cast displayObject : null;
		if (bitmap != null)
		{
			if (bitmap.__bitmapData == null) return __setMultiLeafRejection(rejection, "bitmap-without-bitmapdata", displayObject);
			if (!bitmap.__bitmapData.__isValid) return __setMultiLeafRejection(rejection, "invalid-bitmapdata", displayObject);
			leaves.push(bitmap);
			return __checkColorMatrixLeafLimit(leaves, rejection, displayObject);
		}

		var container:DisplayObjectContainer = __isDisplayObjectContainer(displayObject) ? cast displayObject : null;
		if (__hasDrawableGraphics(displayObject))
		{
			if (container != null && container.__children != null && container.__children.length > 0)
			{
				return __setMultiLeafRejection(rejection, "graphics-with-children", displayObject);
			}
			if (displayObject.__graphics.__usedShaderBuffers.length > 0)
			{
				return __setMultiLeafRejection(rejection, "graphics-shader-fill", displayObject);
			}
			if (!Context3DGraphics.isCompatible(displayObject.__graphics))
			{
				return __setMultiLeafRejection(rejection, "graphics-software-render", displayObject);
			}
			leaves.push(displayObject);
			return __checkColorMatrixLeafLimit(leaves, rejection, displayObject);
		}

		if (container == null) return __setMultiLeafRejection(rejection, "not-leaf-or-container", displayObject);
		if (container.__children == null) return __setMultiLeafRejection(rejection, "container-without-children", displayObject);
		if (container.__children.length == 0) return true;
		if (container.__children.length > 4) return __setMultiLeafRejection(rejection, "too-many-children-" + container.__children.length, container);

		for (child in container.__children)
		{
			if (!__collectRenderableColorMatrixLeaves(child, false, rootFilter, leaves, rejection)) return false;
		}

		return true;
	}

	private static inline function __checkColorMatrixLeafLimit(leaves:Array<DisplayObject>, rejection:Array<String>, displayObject:DisplayObject):Bool
	{
		if (leaves.length > 4) return __setMultiLeafRejection(rejection, "too-many-leaves", displayObject);
		return true;
	}

	private static function __setMultiLeafRejection(rejection:Array<String>, reason:String, displayObject:DisplayObject):Bool
	{
		return false;
	}

	private static function __renderColorMatrixLeaf(displayObject:DisplayObject, filter:ColorMatrixFilter, renderer:OpenGLRenderer):Void
	{
		if (__colorMatrixDisplayObjectShader == null) __colorMatrixDisplayObjectShader = new ColorMatrixDisplayObjectShader();
		renderer.__initDisplayShader(__colorMatrixDisplayObjectShader);
		__colorMatrixDisplayObjectShader.init(filter.matrix);

		var filters = displayObject.__filters;
		var ignoreIdentityFilters = filters != null && __hasOnlyIdentityColorMatrixFilters(displayObject);
		if (ignoreIdentityFilters) displayObject.__filters = null;

		renderer.__setBlendMode(displayObject.__worldBlendMode);
		renderer.__pushMaskObject(displayObject);
		var previous = renderer.__pushShaderOverride(__colorMatrixDisplayObjectShader);
		renderer.__renderDrawable(displayObject);
		renderer.__popShaderOverride(previous);
		renderer.__popMaskObject(displayObject);

		if (ignoreIdentityFilters)
		{
			displayObject.__filters = filters;
			for (nestedFilter in filters)
			{
				nestedFilter.__renderDirty = false;
			}
		}
	}

	private static function __setSingleLeafRejection(rejection:Array<String>, reason:String, displayObject:DisplayObject):DisplayObject
	{
		return null;
	}

	private static function __canIgnoreNestedColorMatrixFilters(rootFilter:ColorMatrixFilter, displayObject:DisplayObject):Bool
	{
		return __hasOnlyIdentityColorMatrixFilters(displayObject);
	}

	private static function __setChildCountRejection(rejection:Array<String>, rootFilter:ColorMatrixFilter, container:DisplayObjectContainer):DisplayObject
	{
		return __setSingleLeafRejection(rejection, "child-count-" + container.__children.length, container);
	}

	private static function __hasOnlyIdentityColorMatrixFilters(displayObject:DisplayObject):Bool
	{
		if (displayObject.__filters == null || displayObject.__filters.length == 0) return false;

		for (filter in displayObject.__filters)
		{
			if (!__isColorMatrixFilter(filter)) return false;
			var colorMatrixFilter:ColorMatrixFilter = cast filter;
			if (!__isIdentityColorMatrix(colorMatrixFilter.__matrix)) return false;
		}

		return true;
	}

	private static function __isIdentityColorMatrix(matrix:Array<Float>):Bool
	{
		return __matrixClose(matrix[0], 1) && __matrixClose(matrix[1], 0) && __matrixClose(matrix[2], 0) && __matrixClose(matrix[3], 0)
			&& __matrixClose(matrix[4], 0) && __matrixClose(matrix[5], 0) && __matrixClose(matrix[6], 1) && __matrixClose(matrix[7], 0)
			&& __matrixClose(matrix[8], 0) && __matrixClose(matrix[9], 0) && __matrixClose(matrix[10], 0) && __matrixClose(matrix[11], 0)
			&& __matrixClose(matrix[12], 1) && __matrixClose(matrix[13], 0) && __matrixClose(matrix[14], 0) && __matrixClose(matrix[15], 0)
			&& __matrixClose(matrix[16], 0) && __matrixClose(matrix[17], 0) && __matrixClose(matrix[18], 1) && __matrixClose(matrix[19], 0);
	}

	private static inline function __matrixClose(value:Float, target:Float):Bool
	{
		return Math.abs(value - target) < 0.0001;
	}

	#if (haxe_ver >= 4.2)
	private static inline function __isBitmap(value:Dynamic):Bool
		return Std.isOfType(value, Bitmap);

	private static inline function __isColorMatrixFilter(value:Dynamic):Bool
		return Std.isOfType(value, ColorMatrixFilter);

	private static inline function __isDisplayObjectContainer(value:Dynamic):Bool
		return Std.isOfType(value, DisplayObjectContainer);
	#else
	private static inline function __isBitmap(value:Dynamic):Bool
		return Std.is(value, Bitmap);

	private static inline function __isColorMatrixFilter(value:Dynamic):Bool
		return Std.is(value, ColorMatrixFilter);

	private static inline function __isDisplayObjectContainer(value:Dynamic):Bool
		return Std.is(value, DisplayObjectContainer);
	#end

	private static function __rejectColorMatrixFastPath(displayObject:DisplayObject, reason:String, rejectionObject:DisplayObject):Bool
	{
		return false;
	}

	public static function renderDrawableMask(displayObjectContainer:DisplayObjectContainer, renderer:OpenGLRenderer):Void
	{
		displayObjectContainer.__cleanupRemovedChildren();

		if (displayObjectContainer.__graphics != null)
		{
			// Context3DGraphics.renderMask (displayObjectContainer.__graphics, renderer);
			Context3DShape.renderMask(displayObjectContainer, renderer);
		}

		for (child in displayObjectContainer.__children)
		{
			renderer.__renderDrawableMask(child);
		}
	}
}

#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end
@SuppressWarnings("checkstyle:FieldDocComment")
private class ColorMatrixDisplayObjectShader extends Shader
{
	@:glVertexHeader("attribute float openfl_Alpha;
		attribute vec4 openfl_ColorMultiplier;
		attribute vec4 openfl_ColorOffset;
		attribute vec4 openfl_Position;
		attribute vec2 openfl_TextureCoord;

		varying float openfl_Alphav;
		varying vec4 openfl_ColorMultiplierv;
		varying vec4 openfl_ColorOffsetv;
		varying vec2 openfl_TextureCoordv;

		uniform mat4 openfl_Matrix;
		uniform bool openfl_HasColorTransform;
		uniform vec2 openfl_TextureSize;")
	@:glVertexBody("openfl_Alphav = openfl_Alpha;
		openfl_TextureCoordv = openfl_TextureCoord;

		if (openfl_HasColorTransform) {

			openfl_ColorMultiplierv = openfl_ColorMultiplier;
			openfl_ColorOffsetv = openfl_ColorOffset / 255.0;

		}

		gl_Position = openfl_Matrix * openfl_Position;")
	@:glVertexSource("#pragma header

		void main(void) {

			#pragma body

		}")
	@:glFragmentHeader("varying float openfl_Alphav;
		varying vec4 openfl_ColorMultiplierv;
		varying vec4 openfl_ColorOffsetv;
		varying vec2 openfl_TextureCoordv;

		uniform bool openfl_HasColorTransform;
		uniform sampler2D openfl_Texture;
		uniform vec2 openfl_TextureSize;
		uniform mat4 uMultipliers;
		uniform vec4 uOffsets;")
	@:glFragmentBody("vec4 color = texture2D (openfl_Texture, openfl_TextureCoordv);

		if (color.a == 0.0) {

			gl_FragColor = vec4 (0.0, 0.0, 0.0, 0.0);

		} else {

			color = vec4 (color.rgb / color.a, color.a);

			if (openfl_HasColorTransform) {

				mat4 colorMultiplier = mat4 (0);
				colorMultiplier[0][0] = openfl_ColorMultiplierv.x;
				colorMultiplier[1][1] = openfl_ColorMultiplierv.y;
				colorMultiplier[2][2] = openfl_ColorMultiplierv.z;
				colorMultiplier[3][3] = 1.0; // openfl_ColorMultiplierv.w;

				color = clamp (openfl_ColorOffsetv + (color * colorMultiplier), 0.0, 1.0);

			}

			color = uOffsets + color * uMultipliers;

			if (color.a > 0.0) {

				gl_FragColor = vec4 (color.rgb * color.a * openfl_Alphav, color.a * openfl_Alphav);

			} else {

				gl_FragColor = vec4 (0.0, 0.0, 0.0, 0.0);

			}

		}")
	#if emscripten
	@:glFragmentSource("#pragma header

		void main(void) {

			#pragma body

			gl_FragColor = gl_FragColor.bgra;

		}")
	#else
	@:glFragmentSource("#pragma header

		void main(void) {

			#pragma body

		}")
	#end
	public function new(code:ByteArray = null)
	{
		super(code);
	}

	public function init(matrix:Array<Float>):Void
	{
		#if !macro
		if (uMultipliers.value == null)
		{
			uMultipliers.value = [1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1];
		}
		if (uOffsets.value == null)
		{
			uOffsets.value = [0, 0, 0, 0];
		}

		var multipliers = uMultipliers.value;
		var offsets = uOffsets.value;

		multipliers[0] = matrix[0];
		multipliers[1] = matrix[1];
		multipliers[2] = matrix[2];
		multipliers[3] = matrix[3];
		multipliers[4] = matrix[5];
		multipliers[5] = matrix[6];
		multipliers[6] = matrix[7];
		multipliers[7] = matrix[8];
		multipliers[8] = matrix[10];
		multipliers[9] = matrix[11];
		multipliers[10] = matrix[12];
		multipliers[11] = matrix[13];
		multipliers[12] = matrix[15];
		multipliers[13] = matrix[16];
		multipliers[14] = matrix[17];
		multipliers[15] = matrix[18];

		offsets[0] = matrix[4] / 255.0;
		offsets[1] = matrix[9] / 255.0;
		offsets[2] = matrix[14] / 255.0;
		offsets[3] = matrix[19] / 255.0;
		#end
	}
}
#end
