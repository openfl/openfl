import openfl.display.ShaderData;
import openfl.utils.ByteArray;

class ShaderDataTest
{
	public static function __init__()
	{
		Mocha.describe("ShaderData", function()
		{
			Mocha.it("new", function()
			{
				// TODO: Confirm functionality

				#if !flash
				var shaderData = new ShaderData(new ByteArray());
				var exists = shaderData;

				Assert.notEqual(exists, null);
				#end
			});
		});
	}
}
