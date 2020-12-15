package;

import openfl.display.Stage3D;
import openfl.display3D.Context3D;
import openfl.Lib;
import utest.Assert;
import utest.Test;

class Stage3DTest extends Test
{
	#if !integration
	@Ignored
	#end
	public function test_context3D()
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

	#if !integration
	@Ignored
	#end
	public function test_visible()
	{
		// TODO: Confirm functionality
		// TODO: Isolate so integration is not needed

		#if integration
		var stage3D = Lib.current.stage.stage3Ds[0];
		var exists = stage3D.visible;

		Assert.notNull(exists);
		#end
	}

	#if !integration
	@Ignored
	#end
	public function test_x()
	{
		// TODO: Confirm functionality
		// TODO: Isolate so integration is not needed

		#if integration
		var stage3D = Lib.current.stage.stage3Ds[0];
		var exists = stage3D.x;

		Assert.notNull(exists);
		#end
	}

	#if !integration
	@Ignored
	#end
	public function test_y()
	{
		// TODO: Confirm functionality
		// TODO: Isolate so integration is not needed

		#if integration
		var stage3D = Lib.current.stage.stage3Ds[0];
		var exists = stage3D.y;

		Assert.notNull(exists);
		#end
	}

	#if !integration
	@Ignored
	#end
	public function test_new_()
	{
		// TODO: Confirm functionality
		// TODO: Isolate so integration is not needed

		#if integration
		var stage3D = Lib.current.stage.stage3Ds[0];
		var exists = stage3D;

		Assert.notNull(exists);
		#end
	}

	#if !integration
	@Ignored
	#end
	public function test_requestContext3D()
	{
		// TODO: Confirm functionality
		// TODO: Isolate so integration is not needed

		#if integration
		var stage3D = Lib.current.stage.stage3Ds[0];
		var exists = stage3D.requestContext3D;

		Assert.notNull(exists);
		#end
	}

	#if !integration
	@Ignored
	#end
	public function test_requestContext3DMatchingProfiles()
	{
		// TODO: Confirm functionality
		// TODO: Isolate so integration is not needed

		#if integration
		var stage3D = Lib.current.stage.stage3Ds[0];
		var exists = stage3D.requestContext3DMatchingProfiles;

		Assert.notNull(exists);
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
