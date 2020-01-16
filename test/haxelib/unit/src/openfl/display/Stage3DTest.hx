package openfl.display;

import massive.munit.Assert;
import openfl.display.Stage3D;
import openfl.display3D.Context3D;

class Stage3DTest
{
	@Test public function context3D()
	{
		// TODO: Confirm functionality
		// TODO: Isolate so integration is not needed

		#if integration
		var stage3D = Lib.current.stage.stage3Ds[0];
		var exists = stage3D.context3D;

		#if flash
		Assert.isNull(exists);
		#end
		#end
	}

	@Test public function visible()
	{
		// TODO: Confirm functionality
		// TODO: Isolate so integration is not needed

		#if integration
		var stage3D = Lib.current.stage.stage3Ds[0];
		var exists = stage3D.visible;

		Assert.isNotNull(exists);
		#end
	}

	@Test public function x()
	{
		// TODO: Confirm functionality
		// TODO: Isolate so integration is not needed

		#if integration
		var stage3D = Lib.current.stage.stage3Ds[0];
		var exists = stage3D.x;

		Assert.isNotNull(exists);
		#end
	}

	@Test public function y()
	{
		// TODO: Confirm functionality
		// TODO: Isolate so integration is not needed

		#if integration
		var stage3D = Lib.current.stage.stage3Ds[0];
		var exists = stage3D.y;

		Assert.isNotNull(exists);
		#end
	}

	@Test public function new_()
	{
		// TODO: Confirm functionality
		// TODO: Isolate so integration is not needed

		#if integration
		var stage3D = Lib.current.stage.stage3Ds[0];
		var exists = stage3D;

		Assert.isNotNull(exists);
		#end
	}

	@Test public function requestContext3D()
	{
		// TODO: Confirm functionality
		// TODO: Isolate so integration is not needed

		#if integration
		var stage3D = Lib.current.stage.stage3Ds[0];
		var exists = stage3D.requestContext3D;

		Assert.isNotNull(exists);
		#end
	}

	@Test public function requestContext3DMatchingProfiles()
	{
		// TODO: Confirm functionality
		// TODO: Isolate so integration is not needed

		#if integration
		var stage3D = Lib.current.stage.stage3Ds[0];
		var exists = stage3D.requestContext3DMatchingProfiles;

		Assert.isNotNull(exists);
		#end
	}

	#if integration
	public static function __getContext3D():Context3D
	{
		// TODO: Create the context in advance?

		#if integration
		var stage3D = Lib.current.stage.stage3Ds[0];

		// This is not currently stable
		return null;

		if (stage3D != null)
		{
			if (stage3D.context3D == null)
			{
				// munit template does not have the correct wmode for Stage3D

				#if !flash
				stage3D.addEventListener("context3DCreate", function(_) {});
				stage3D.requestContext3D();
				#end
			}

			return stage3D.context3D;
		}
		#end

		return null;
	}
	#end
}
