import utest.Runner;
import utest.ui.Report;

class Tests
{
	public static function main()
	{
		var runner = new Runner();
		runner.addCase(new CapsStyleTest());
		runner.addCase(new GradientTypeTest());
		runner.addCase(new GraphicsBitmapFillTest());
		runner.addCase(new GraphicsEndFillTest());
		runner.addCase(new GraphicsGradientFillTest());
		runner.addCase(new GraphicsPathCommandTest());
		runner.addCase(new GraphicsPathTest());
		runner.addCase(new GraphicsPathWindingTest());
		runner.addCase(new GraphicsSolidFillTest());
		runner.addCase(new GraphicsStrokeTest());
		runner.addCase(new GraphicsTest());
		runner.addCase(new InterpolationMethodTest());
		runner.addCase(new JointStyleTest());
		runner.addCase(new LineScaleModeTest());
		runner.addCase(new SpreadMethodTest());
		runner.addCase(new TriangleCullingTest());
		Report.create(runner);
		runner.run();
	}
}
