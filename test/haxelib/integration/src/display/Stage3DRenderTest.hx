package display;

import openfl.Lib;

class Stage3DRenderTest
{
	#if flash
	@Ignore
	#end // TODO
	@AsyncTest public function createContext(factory:AsyncFactory):Void
	{
		var stage3D = Lib.current.stage.stage3Ds[0];

		var handler = factory.createHandler(this, function()
		{
			#if sys
			if (Sys.getEnv("CI") != null) return;
			#end

			if (stage3D != null)
			{
				Assert.isNotNull(stage3D.context3D);
			}
		});

		stage3D.addEventListener("context3DCreate", function(_)
		{
			handler();
		});

		stage3D.requestContext3D();
	}
}
