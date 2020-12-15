import utest.Runner;
import utest.ui.Report;

class Tests
{
	public static function main()
	{
		var runner = new Runner();
		runner.addCase(new BitmapFilterQualityTest());
		runner.addCase(new BitmapFilterTest());
		runner.addCase(new BitmapFilterTypeTest());
		runner.addCase(new BlurFilterTest());
		runner.addCase(new ColorMatrixFilterTest());
		runner.addCase(new DropShadowFilterTest());
		runner.addCase(new GlowFilterTest());
		runner.addCase(new ShaderFilterTest());
		Report.create(runner);
		runner.run();
	}
}
