package openfl.geom;

import massive.munit.Assert;

class PerspectiveProjectionTest {
	@Test public function new_() {

		var projection = new PerspectiveProjection();

		Assert.areEqual(0.0, projection.focalLength);
		Assert.areEqual(0.0, projection.fieldOfView);

		Assert.areEqual(Lib.current.stage.stageWidth * 0.5, projection.projectionCenter.x);
		Assert.areEqual(Lib.current.stage.stageHeight * 0.5, projection.projectionCenter.y);

	}

	@Test public function fieldOfView() {

		var projection = new PerspectiveProjection();

		Assert.areEqual(0.0, projection.fieldOfView);

		projection.fieldOfView = 40;

		Assert.areEqual(40 * Math.PI / 180.0, projection.fieldOfView);
		Assert.areEqual(686.86935, Math.round(projection.focalLength * 100000.0) / 100000.0);

	}

	@Test public function focalLength() {

		// TODO: Confirm functionality

		var perspectiveProjection = new PerspectiveProjection ();
		var exists = perspectiveProjection.focalLength;

		Assert.isNotNull(exists);

	}

	@Test public function projectionCenter() {

		// TODO: Confirm functionality

		var perspectiveProjection = new PerspectiveProjection ();
		var exists = perspectiveProjection.projectionCenter;

		Assert.isNotNull(exists);

	}

	@Test public function toMatrix3D() {
		var projection = new PerspectiveProjection();
		projection.fieldOfView = 40.0;

		var matrix = projection.toMatrix3D();

		Assert.areEqual(686.86935, Math.round(matrix.rawData[0] * 100000.0) / 100000.0);
		Assert.areEqual(686.86935, Math.round(matrix.rawData[5] * 100000.0) / 100000.0);
		Assert.areEqual(1.0, matrix.rawData[11]);
		Assert.areEqual(0.0, matrix.rawData[15]);

	}

}