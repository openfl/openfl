import utest.Runner;
import utest.ui.Report;

class Tests
{
	public static function main()
	{
		var runner = new Runner();
		runner.addCase(new ColorTransformTest());
		runner.addCase(new Matrix3DTest());
		runner.addCase(new MatrixTest());
		runner.addCase(new Orientation3DTest());
		runner.addCase(new PerspectiveProjectionTest());
		runner.addCase(new PointTest());
		runner.addCase(new RectangleTest());
		runner.addCase(new TransformTest());
		runner.addCase(new Utils3DTest());
		runner.addCase(new Vector3DTest());
		Report.create(runner);
		runner.run();
	}
}
