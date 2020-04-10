import Shader from "../../../display/Shader";

export default class Context3DAlphaMaskShader extends Shader
{
	glFragmentSource = `
		varying vec2 openfl_AlphaTextureCoordv;
		varying vec2 openfl_TextureCoordv;

		uniform sampler2D openfl_AlphaTexture;
		uniform sampler2D openfl_Texture;

		void main(void)
		{
			vec4 mask = texture2D(openfl_AlphaTexture, openfl_AlphaTextureCoordv);

			if (mask.a == 0.0)
			{
				gl_FragColor = vec4(0.0, 0.0, 0.0, 0.0);
			}
			else
			{
				vec4 color = texture2D(openfl_Texture, openfl_TextureCoordv);
				gl_FragColor = color * mask.a;
			}
		}
	`;

	glVertexSource = `
		attribute vec4 openfl_Position;
		attribute vec2 openfl_TextureCoord;
		varying vec2 openfl_AlphaTextureCoordv;
		varying vec2 openfl_TextureCoordv;

		uniform mat4 openfl_AlphaTextureMatrix;
		uniform mat4 openfl_Matrix;

		void main(void)
		{
			openfl_TextureCoordv = openfl_TextureCoord;
			openfl_AlphaTextureCoordv = vec2(vec4(openfl_TextureCoord, 0.0, 0.0) * openfl_AlphaTextureMatrix);

			gl_Position = openfl_Matrix * openfl_Position;
		}
	`;

	public constructor()
	{
		super();
	}
}
