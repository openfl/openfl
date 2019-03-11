package display;

import openfl.Lib;

class Stage3DRenderTest
{
	#if flash
	@Ignore
	#end // TODO
	@AsyncTest public function createContext():Void
	{
		var stage3D = Lib.current.stage.stage3Ds[0];

		if (stage3D != null)
		{
			// TODO: This is unstable in CI testing at the moment
			#if sys
			if (Sys.getEnv("CI") != null) return;
			#end

			stage3D.addEventListener("context3DCreate", function(_)
			{
				Async.handler(this, function()
				{
					Assert.isNotNull(stage3D.context3D);
				})();
			});

			stage3D.requestContext3D();
		}
		else
		{
			Async.handler(this, function() {})();
		}
	}
}
