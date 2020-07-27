package openfl.display;

import openfl.utils.ByteArray;

#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end
class GraphicsShaderFast extends Shader
{
	@:glVertexHeader("
		attribute float openfl_Alpha;
		attribute vec4 openfl_ColorMultiplier;
		attribute vec4 openfl_ColorOffset;
		attribute vec4 openfl_Position;
		attribute vec2 openfl_TextureCoord;

		varying float openfl_Alphav;
		varying vec4 openfl_ColorMultiplierv;
		varying vec4 openfl_ColorOffsetv;
		varying vec2 openfl_TextureCoordv;
		varying vec4 vColor;

		uniform mat4 openfl_Matrix;
		uniform bool openfl_HasColorTransform;
		uniform vec2 openfl_TextureSize;
		")
	@:glVertexBody("
		openfl_Alphav = openfl_Alpha;
		openfl_TextureCoordv = openfl_TextureCoord;

		vColor = vec4 (1.0, 1.0, 1.0, 1.0);

		if (openfl_HasColorTransform) {

			openfl_ColorMultiplierv = openfl_ColorMultiplier;
			openfl_ColorOffsetv = openfl_ColorOffset / 255.0;

			mat4 colorMultiplier = mat4 (0);
			colorMultiplier[0][0] = openfl_ColorMultiplierv.x;
			colorMultiplier[1][1] = openfl_ColorMultiplierv.y;
			colorMultiplier[2][2] = openfl_ColorMultiplierv.z;
			colorMultiplier[3][3] = 1.0; // openfl_ColorMultiplierv.w;

			vColor = clamp (vColor * colorMultiplier, 0.0, 1.0);
		}

		vColor *= openfl_Alphav;

		gl_Position = openfl_Matrix * openfl_Position;
		")
	@:glVertexSource("#pragma header
		void main(void) {
			#pragma body
		}")
	@:glFragmentHeader(
		#if android
		"precision mediump float;" +
		#end
		"varying float openfl_Alphav;
		varying vec4 openfl_ColorMultiplierv;
		varying vec4 openfl_ColorOffsetv;
		varying vec2 openfl_TextureCoordv;
		varying vec4 vColor;

		uniform bool openfl_HasColorTransform;
		uniform vec2 openfl_TextureSize;
		uniform sampler2D bitmap;
		")
	@:glFragmentBody("
		gl_FragColor = texture2D (bitmap, openfl_TextureCoordv) * vColor;
		")
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
}