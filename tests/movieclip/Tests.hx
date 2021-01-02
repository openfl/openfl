import utest.Runner;
import utest.ui.Report;

class Tests
{
	public static function main()
	{
		var runner = new Runner();
		runner.addCase(new FrameLabelTest());
		runner.addCase(new MovieClipTest());
		runner.addCase(new SimpleButtonTest());
		Report.create(runner);
		runner.run();
	}
}
