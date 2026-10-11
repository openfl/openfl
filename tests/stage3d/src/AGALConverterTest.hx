package;

#if !flash
import openfl.display._internal.SamplerState;
import openfl.display3D._internal.AGALConverter;
import openfl.utils.AGALMiniAssembler;
#end
import utest.Assert;
import utest.Test;

class AGALConverterTest extends Test
{
	#if !flash
	private var limitedProfile:Null<Bool>;

	public function setup()
	{
		// unit tests have no GL context to ask for the profile
		limitedProfile = @:privateAccess AGALConverter.limitedProfile;
		@:privateAccess AGALConverter.limitedProfile = true;
	}

	public function teardown()
	{
		@:privateAccess AGALConverter.limitedProfile = limitedProfile;
	}
	#end

	#if flash
	@Ignored
	#end
	public function test_convertToGLSL_texture()
	{
		#if !flash
		var glsl = convertFragment("tex ft0, v0, fs0 <2d, linear, nomip>\nmov oc, ft0", true);

		Assert.isTrue(glsl.indexOf("uniform sampler2D sampler0;") > -1);
		Assert.equals(-1, glsl.indexOf("_alpha"));
		#end
	}

	#if flash
	@Ignored
	#end
	public function test_convertToGLSL_compressedTextureWithAlpha()
	{
		#if !flash
		var source = "tex ft0, v0, fs0 <2d, linear, nomip, dxt5>\nmov oc, ft0";

		// with separate alpha textures (ETC1), the alpha channel comes from an extra sampler
		var glsl = convertFragment(source, true);

		Assert.isTrue(glsl.indexOf("uniform sampler2D sampler0;") > -1);
		Assert.isTrue(glsl.indexOf("uniform sampler2D sampler0_alpha;") > -1);
		Assert.isTrue(glsl.indexOf("uniform bool sampler0_alphaEnabled;") > -1);

		// without them, the texture is sampled like any other one, without extra samplers
		glsl = convertFragment(source, false);

		Assert.isTrue(glsl.indexOf("uniform sampler2D sampler0;") > -1);
		Assert.equals(-1, glsl.indexOf("_alpha"));
		#end
	}

	#if flash
	@Ignored
	#end
	public function test_convertToGLSL_samplerState()
	{
		#if !flash
		var samplerStates = new Array<SamplerState>();
		convertFragment("tex ft0, v0, fs1 <2d, linear, nomip, dxt5>\nmov oc, ft0", false, samplerStates);

		Assert.isNull(samplerStates[0]);
		Assert.isTrue(samplerStates[1].textureAlpha);
		#end
	}

	#if !flash
	private function convertFragment(source:String, separateAlphaTextures:Bool, samplerStates:Array<SamplerState> = null):String
	{
		var agal = new AGALMiniAssembler().assemble("fragment", source);
		return AGALConverter.convertToGLSL(agal, samplerStates, separateAlphaTextures);
	}
	#end
}
