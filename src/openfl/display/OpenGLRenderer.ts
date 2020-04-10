import BitmapData from "../display/BitmapData";
import DisplayObjectRenderer from "../display/DisplayObjectRenderer";
import Shader from "../display/Shader";
import Context3D from "../display3D/Context3D";
import ColorTransform from "../geom/ColorTransform";
import Matrix from "../geom/Matrix";
// #if lime
// import lime.math.Matrix4;
// import openfl._internal.bindings.gl.WebGLRenderingContext;
// #elseif openfl_html5
// import openfl._internal.backend.lime_standalone.WebGLRenderContext in WebGLRenderingContext;
// #end

/**
	**BETA**

	The OpenGL3DRenderer API exposes support for OpenGL render instructions within the
	`RenderEvent.RENDER_OPENGL` event.
**/
export default class OpenGLRenderer extends DisplayObjectRenderer
{
	/**
		The current OpenGL render context
	**/
	public gl: WebGLRenderingContext;

	protected constructor(context: Context3D, defaultRenderTarget: BitmapData = null)
	{
		super();
	}

	/**
		Applies an alpha value to the active shader, if compatible with OpenFL core shaders
	**/
	public applyAlpha(alpha: number): void { }

	/**
		Binds a BitmapData object as the first active texture of the current active shader,
		if compatible with OpenFL core shaders
	**/
	public applyBitmapData(bitmapData: BitmapData, smooth: boolean, repeat: boolean = false): void { }

	/**
		Applies a color transform value to the active shader, if compatible with OpenFL
		core shaders
	**/
	public applyColorTransform(colorTransform: ColorTransform): void { }

	/**
		Applies the "has color transform" uniform value for the active shader, if
		compatible with OpenFL core shaders
	**/
	public applyHasColorTransform(enabled: boolean): void { }

	/**
		Applies render matrix to the active shader, if compatible with OpenFL core shaders
	**/
	public applyMatrix(matrix: Array<number>): void { }

	/**
		Converts an OpenFL two-dimensional matrix to a compatible 3D matrix for use with
		OpenGL rendering. Repeated calls to this method will return the same object with
		new values, so it will need to be cloned if the result must be cached
	**/
	public getMatrix(transform: Matrix): any
	{
		return null;
	}

	/**
		Sets the current active shader, which automatically unbinds the previous shader
		if it was bound using an OpenFL Shader object
	**/
	public setShader(shader: Shader): void { }

	/**
		Updates the current OpenGL viewport using the current OpenFL stage coordinates
	**/
	public setViewport(): void { }

	/**
		Updates the current active shader with cached alpha, color transform,
		bitmap data and other uniform or attribute values. This should be called in advance
		of rendering
	**/
	public updateShader(): void { }

	/**
		Updates the active shader to expect an alpha array, if the current shader
		is compatible with OpenFL core shaders
	**/
	public useAlphaArray(): void { }

	/**
		Updates the active shader to expect a color transform array, if the current shader
		is compatible with OpenFL core shaders
	**/
	public useColorTransformArray(): void { }
}
