package;

import openfl.geom.PerspectiveProjection;
import utest.Assert;
import utest.Test;

// TODO: Width/Height is 500/500 in tests for FLASH target - is SWF 500x500 ?
class PerspectiveProjectionTest extends Test
{
	public function test_new_()
	{
		var projection = new PerspectiveProjection();

		// TODO: Looks like Flash's default value is 55.0
		#if flash
		Assert.equals(55.0, projection.fieldOfView);
		#else
		Assert.equals(0.0, projection.fieldOfView);
		#end

		// TODO: Flash's focalLength has some round/ceil I cannot reproduce
		#if flash
		var focalLength = (500.0 * 0.5) * (Math.cos((0.5 * projection.fieldOfView * Math.PI) / 180.0) / Math.sin((0.5 * projection.fieldOfView * Math.PI) / 180.0));

		Assert.equals(Math.round(focalLength * 1000.0) / 1000.0, Math.round(projection.focalLength * 1000.0) / 1000.0);
		#else
		Assert.equals(0.0, projection.focalLength);
		#end

		// TODO: Isolate so integration is not needed

		#if integration
		#if flash
		Assert.equals(500 / 2, projection.projectionCenter.x);
		Assert.equals(500 / 2, projection.projectionCenter.y);
		#else
		Assert.equals(openfl.Lib.current.stage.stageWidth / 2, projection.projectionCenter.x);
		Assert.equals(openfl.Lib.current.stage.stageHeight / 2, projection.projectionCenter.y);
		#end
		#end
	}

	public function test_fieldOfView()
	{
		var projection = new PerspectiveProjection();

		// TODO: Looks like Flash's default value is 55.0
		#if flash
		Assert.equals(55.0, projection.fieldOfView);
		#else
		Assert.equals(0.0, projection.fieldOfView);
		#end

		projection.fieldOfView = 40;

		// TODO: Flash is in Degrees, Others are in Radians
		#if flash
		Assert.equals(40.0, projection.fieldOfView);
		#else
		Assert.equals(40.0 * Math.PI / 180.0, projection.fieldOfView);
		#end

		// TODO: Flash's focalLength has some round/ceil I cannot reproduce
		#if flash
		var focalLength = (500.0 * 0.5) * (Math.cos((0.5 * projection.fieldOfView * Math.PI) / 180.0) / Math.sin((0.5 * projection.fieldOfView * Math.PI) / 180.0));

		Assert.equals(Math.round(focalLength * 1000.0) / 1000.0, Math.round(projection.focalLength * 1000.0) / 1000.0);
		#else
		var focalLength = (500 * 0.5) * (1.0 / Math.tan(40.0 * PerspectiveProjection.TO_RADIAN * 0.5));

		Assert.equals(focalLength, projection.focalLength);
		#end
	}

	public function test_focalLength()
	{
		var projection = new PerspectiveProjection();
		projection.fieldOfView = 40;

		// TODO: Flash's focalLength has some round/ceil I cannot reproduce
		#if flash
		var focalLength = (500.0 * 0.5) * (Math.cos((0.5 * projection.fieldOfView * Math.PI) / 180.0) / Math.sin((0.5 * projection.fieldOfView * Math.PI) / 180.0));

		Assert.equals(Math.round(focalLength * 1000.0) / 1000.0, Math.round(projection.focalLength * 1000.0) / 1000.0);
		#else
		var focalLength = (500 * 0.5) * (1.0 / Math.tan(40.0 * PerspectiveProjection.TO_RADIAN * 0.5));

		Assert.equals(focalLength, projection.focalLength);
		#end
	}

	#if !integration
	@Ignored
	#end
	public function test_projectionCenter()
	{
		var projection = new PerspectiveProjection();

		// TODO: Isolate so integration is not needed

		#if integration
		#if flash
		Assert.equals(500 / 2, projection.projectionCenter.x);
		Assert.equals(500 / 2, projection.projectionCenter.y);
		#else
		Assert.equals(openfl.Lib.current.stage.stageWidth / 2, projection.projectionCenter.x);
		Assert.equals(openfl.Lib.current.stage.stageHeight / 2, projection.projectionCenter.y);
		#end
		#end
	}

	public function test_toMatrix3D()
	{
		var projection = new PerspectiveProjection();
		projection.fieldOfView = 40.0;

		var matrix = projection.toMatrix3D();

		// TODO: Check why values are different. SWF is 800x600 but 500.0 is the correct value
		#if flash
		Assert.equals(686.86938, Math.round(matrix.rawData[0] * 100000.0) / 100000.0);
		#else
		Assert.equals(686.86935, Math.round(matrix.rawData[0] * 100000.0) / 100000.0);
		#end

		// TODO: Check why values are different
		#if flash
		Assert.equals(686.86938, Math.round(matrix.rawData[5] * 100000.0) / 100000.0);
		#else
		Assert.equals(686.86935, Math.round(matrix.rawData[5] * 100000.0) / 100000.0);
		#end

		Assert.equals(1.0, matrix.rawData[11]);
		Assert.equals(0.0, matrix.rawData[15]);
	}
}
