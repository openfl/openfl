package openfl.filters;

import openfl.display.Shader;
import openfl.utils.ByteArray;

#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end
class BitmapFilterShader extends Shader
{
	@:glVertexHeader("attribute vec4 openfl_Position;
		attribute vec2 openfl_TextureCoord;

		varying vec2 openfl_TextureCoordv;

		uniform mat4 openfl_Matrix;
		uniform vec2 openfl_TextureSize;")
	@:glVertexBody("openfl_TextureCoordv = openfl_TextureCoord;

		gl_Position = openfl_Matrix * openfl_Position;")
	@:glVertexSource("#pragma header

		void main(void) {

			#pragma body

		}")
	@:glFragmentHeader("varying vec2 openfl_TextureCoordv;

		uniform sampler2D openfl_Texture;
		uniform vec2 openfl_TextureSize;")
	@:glFragmentBody("gl_FragColor = texture2D (openfl_Texture, openfl_TextureCoordv);")
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
