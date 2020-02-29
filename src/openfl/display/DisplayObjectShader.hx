package openfl.display;

import openfl.utils.ByteArray;

#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end
class DisplayObjectShader extends Shader
{
	@:glVertexHeader("attribute float openfl_Alpha;
		attribute vec4 openfl_ColorMultiplier;
		attribute vec4 openfl_ColorOffset;
		attribute vec4 openfl_Position;
		attribute vec2 openfl_TextureCoord;
		attribute float openfl_TextureID;

		varying float openfl_Alphav;
		varying vec4 openfl_ColorMultiplierv;
		varying vec4 openfl_ColorOffsetv;
		varying vec2 openfl_TextureCoordv;
		varying float openfl_TextureIDv;

		uniform mat4 openfl_Matrix;
		uniform bool openfl_HasColorTransform;
		uniform vec2 openfl_TextureSizes[8];")
	@:glVertexBody("openfl_Alphav = openfl_Alpha;
		openfl_TextureCoordv = openfl_TextureCoord;
		openfl_TextureIDv = openfl_TextureID;

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
		varying float openfl_TextureIDv;

		uniform bool openfl_HasColorTransform;
		uniform sampler2D openfl_Textures[8];
		uniform vec2 openfl_TextureSizes[8];")
	@:glFragmentBody("vec4 color;

		for (int k = 0; k < 8; ++k)
		{
			int openfl_TextureID = int(openfl_TextureIDv);
			if (openfl_TextureID == k)
			{
				color = texture2D(openfl_Textures[int(k)], openfl_TextureCoordv);
			}
		}

		if (color.a == 0.0) {

			gl_FragColor = vec4(0.0, 0.0, 0.0, 0.0);

		} else if (openfl_HasColorTransform) {

			color = vec4(color.rgb / color.a, color.a);

			vec4 colorMultiplier = vec4(openfl_ColorMultiplierv.rgb, 1.0);
			color = clamp((color * colorMultiplier) + openfl_ColorOffsetv, 0.0, 1.0);

			if (color.a > 0.0) {

				gl_FragColor = vec4(color.rgb * color.a * openfl_Alphav, color.a * openfl_Alphav);

			} else {

				gl_FragColor = vec4(0.0, 0.0, 0.0, 0.0);

			}

		} else {

			gl_FragColor = color * openfl_Alphav;

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
}
