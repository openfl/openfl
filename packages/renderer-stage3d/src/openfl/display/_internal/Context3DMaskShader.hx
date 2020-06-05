package openfl.display._internal;

import openfl.display.BitmapData;
import openfl.display.Shader;

#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end
class Context3DMaskShader extends Shader
{
	public static var opaqueBitmapData:BitmapData = new BitmapData(1, 1, false, 0);

	@:glFragmentSource("varying vec2 openfl_TextureCoordv;

		uniform sampler2D openfl_Texture;

		void main(void) {

			vec4 color = texture2D (openfl_Texture, openfl_TextureCoordv);

			if (color.a == 0.0) {

				discard;

			} else {

				gl_FragColor = color;

			}

		}")
	@:glVertexSource("attribute vec4 openfl_Position;
		attribute vec2 openfl_TextureCoord;
		varying vec2 openfl_TextureCoordv;

		uniform mat4 openfl_Matrix;

		void main(void) {

			openfl_TextureCoordv = openfl_TextureCoord;

			gl_Position = openfl_Matrix * openfl_Position;

		}")
	public function new()
	{
		super();
	}
}
