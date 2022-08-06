package;

import haxe.io.BytesOutput;
import utest.Assert;
import utest.Test;
import openfl.display.Shader;
import openfl.filters.ShaderFilter;
#if format
import format.pbj.Data;
import format.pbj.Writer;
#end

class ShaderFilterTest extends Test
{
	private var _shader:Shader;

	public function setupClass():Void
	{
		#if flash
		#if format
		var pbj:PBJ = {
			version: 1,
			name: "Multiply",
			metadatas: [],
			// the parameters are the input/output of the shader
			// see PBJ Reference below for a full description
			parameters: [
				{name: "_OutCoord", p: Parameter(TFloat2, false, RFloat(0, [R, G])), metas: []},
				{name: "background", p: Texture(4, 0), metas: []},
				{name: "foreground", p: Texture(4, 1), metas: []},
				{name: "dst", p: Parameter(TFloat4, true, RFloat(1)), metas: []},
			],
			// this is our assembler code for the shader, you can see it's similar
			// to what we have written in previous section
			code: [
				OpSampleNearest(RFloat(2), RFloat(0, [R, G]), 0),
				OpSampleNearest(RFloat(1), RFloat(0, [R, G]), 1),
				OpMul(RFloat(1), RFloat(2)),
			],
		};

		var output = new BytesOutput();
		var writer = new Writer(output);
		writer.write(pbj);

		_shader = new Shader(output.getBytes());
		#end
		#else
		_shader = new Shader();
		#end
	}

	#if (flash && !format)
	@Ignored
	#end
	public function test_new_()
	{
		// TODO: Confirm functionality

		var shaderFilter = new ShaderFilter(_shader);
		Assert.notNull(shaderFilter);
	}

	#if (flash && !format)
	@Ignored
	#end
	public function test_shader()
	{
		// TODO: Confirm functionality

		var shaderFilter = new ShaderFilter(_shader);
		var exists = shaderFilter.shader;

		Assert.notNull(exists);
	}
}
