import ShaderData from "openfl/display/ShaderData";
import ShaderInput from "openfl/display/ShaderInput";
import ShaderParameter from "openfl/display/ShaderParameter";
import ByteArray from "openfl/utils/ByteArray";
import * as assert from "assert";

describe("TypeScript | ShaderData", function ()
{


	it("new", function ()
	{

		// TODO: Confirm functionality

		// #if !flash
		var shaderData = new ShaderData(new ByteArray());
		var exists = shaderData;

		var checkParameter = shaderData.fakeParam as ShaderParameter;
		var checkInput = shaderData.fakeInput as ShaderInput;

		// shaderData.testIsDynamic = true;

		assert.notEqual(exists, null);
		// #end

	});


});
