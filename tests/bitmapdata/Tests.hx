import utest.Runner;
import utest.ui.Report;

class Tests
{
	public static function main()
	{
		var runner = new Runner();
		runner.addCase(new BitmapDataChannelTest());
		runner.addCase(new BitmapDataTest());
		runner.addCase(new JPEGEncoderOptionsTest());
		runner.addCase(new PNGEncoderOptionsTest());
		Report.create(runner);
		runner.run();
	}
}
