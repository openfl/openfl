import utest.Runner;
import utest.ui.Report;

class Tests
{
	public static function main()
	{
		var runner = new Runner();
		runner.addCase(new LoaderContextTest());
		runner.addCase(new LoaderInfoTest());
		runner.addCase(new LoaderTest());
		runner.addCase(new UncaughtErrorEventsTest());
		runner.addCase(new UncaughtErrorEventTest());
		Report.create(runner);
		runner.run();
	}
}
