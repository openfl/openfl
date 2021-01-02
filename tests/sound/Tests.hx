import utest.Runner;
import utest.ui.Report;

class Tests
{
	public static function main()
	{
		var runner = new Runner();
		runner.addCase(new ID3InfoTest());
		runner.addCase(new SampleDataEventTest());
		runner.addCase(new SoundChannelTest());
		runner.addCase(new SoundLoaderContextTest());
		runner.addCase(new SoundTest());
		runner.addCase(new SoundTransformTest());
		Report.create(runner);
		runner.run();
	}
}
