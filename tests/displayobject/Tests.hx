import utest.Runner;
import utest.ui.Report;

class Tests
{
	public static function main()
	{
		var runner = new Runner();
		runner.addCase(new BitmapTest());
		runner.addCase(new BlendModeTest());
		runner.addCase(new DisplayObjectContainerTest());
		runner.addCase(new DisplayObjectTest());
		runner.addCase(new FocusEventTest());
		runner.addCase(new InteractiveObjectTest());
		runner.addCase(new PixelSnappingTest());
		runner.addCase(new ShapeTest());
		runner.addCase(new SpriteTest());
		Report.create(runner);
		runner.run();
	}
}
