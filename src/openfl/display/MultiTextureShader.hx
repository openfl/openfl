package openfl.display;

#if openfl_experimental_multitexture
import openfl.utils.ByteArray;
import openfl.utils.ObjectPool;
using StringTools;

#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end

// TODO: Currently this feature needs macro for optimization
class MultiTextureShader extends Shader
{
    @:noCompletion private static var __pool:ObjectPool<MultiTextureShader>;

    public static var vertexSource:String = "attribute float openfl_Alpha;
		attribute vec4 openfl_ColorMultiplier;
		attribute vec4 openfl_ColorOffset;
		attribute vec4 openfl_Position;
		attribute vec2 openfl_TextureCoord;
		attribute float openfl_TextureId;

		varying float openfl_Alphav;
		varying vec4 openfl_ColorMultiplierv;
		varying vec4 openfl_ColorOffsetv;
		varying vec2 openfl_TextureCoordv;
		varying float openfl_TextureIdv;

		uniform mat4 openfl_Matrix;
		uniform bool openfl_HasColorTransform;
		uniform vec2 openfl_TextureSize;

		void main(void) {

			openfl_Alphav = openfl_Alpha;
            openfl_TextureCoordv = openfl_TextureCoord;

            if (openfl_HasColorTransform) {

                openfl_ColorMultiplierv = openfl_ColorMultiplier;
                openfl_ColorOffsetv = openfl_ColorOffset / 255.0;

            }

            openfl_TextureIdv = openfl_TextureId;

            gl_Position = openfl_Matrix * openfl_Position;

		}";
    #if emscripten
	public static var fragmentSource:String = "#pragma header

		void main(void) {

			#pragma body

			gl_FragColor = gl_FragColor.bgra;

		}";
	#else
    public static var fragmentSource:String = "varying float openfl_Alphav;
		varying vec4 openfl_ColorMultiplierv;
		varying vec4 openfl_ColorOffsetv;
		varying vec2 openfl_TextureCoordv;
		varying float openfl_TextureIdv;

		uniform bool openfl_HasColorTransform;
		uniform sampler2D SAMPLER_INJECT;

		uniform vec2 openfl_TextureSize;

		void main(void) {

			vec4 color;
		//vec4 color = texture2D (openfl_Texture, openfl_TextureCoordv);
		float vTextureId = openfl_TextureIdv;
		color = texture2D(SAMPLER_INJECT, openfl_TextureCoordv);

		if (color.a == 0.0) {

			gl_FragColor = vec4 (0.0, 0.0, 0.0, 0.0);

		} else if (openfl_HasColorTransform) {

			color = vec4 (color.rgb / color.a, color.a);

			mat4 colorMultiplier = mat4 (0);
			colorMultiplier[0][0] = openfl_ColorMultiplierv.x;
			colorMultiplier[1][1] = openfl_ColorMultiplierv.y;
			colorMultiplier[2][2] = openfl_ColorMultiplierv.z;
			colorMultiplier[3][3] = 1.0; // openfl_ColorMultiplierv.w;

			color = clamp (openfl_ColorOffsetv + (color * colorMultiplier), 0.0, 1.0);

			if (color.a > 0.0) {

				gl_FragColor = vec4 (color.rgb * color.a * openfl_Alphav, color.a * openfl_Alphav);

			} else {

				gl_FragColor = vec4 (0.0, 0.0, 0.0, 0.0);

			}

		} else {

			gl_FragColor = color * openfl_Alphav;

		}

		}";
    #end
    public function new(supportedMultiTextureUnits:Int, code:ByteArray = null)
    {
        __glVertexSource = vertexSource;

        __glFragmentSource = fragmentSource;
        var uSamplerVariableBuffer:String = "";
        for(i in 0...supportedMultiTextureUnits)
        {
            uSamplerVariableBuffer += 'uniform sampler2D uSampler${i};\n';
        }
        __glFragmentSource = __glFragmentSource.replace("uniform sampler2D SAMPLER_INJECT;", uSamplerVariableBuffer);


        var uSamplerBodyBuffer:String = "";
        for(i in 0...supportedMultiTextureUnits)
        {
            if(i == 0)
            {
                uSamplerBodyBuffer += 'if (vTextureId < ${i}.5) {
                    color = texture2D(uSampler${i}, openfl_TextureCoordv);
                }';
            } else if(i == supportedMultiTextureUnits - 1)
            {
                uSamplerBodyBuffer += 'else {
                    color = texture2D(uSampler${i}, openfl_TextureCoordv);
                }';
            }else{
                uSamplerBodyBuffer += 'else if (vTextureId < ${i}.5) {
                    color = texture2D(uSampler${i}, openfl_TextureCoordv);
                }';
            }
        }
        __glFragmentSource = __glFragmentSource.replace("color = texture2D(SAMPLER_INJECT, openfl_TextureCoordv);", uSamplerBodyBuffer);

        super(code);
        this.__initGL();
    }
}
#end