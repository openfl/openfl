import utest.Runner;
import utest.ui.Report;

class Tests
{
	public static function main()
	{
		var runner = new Runner();
		runner.addCase(new URLLoaderDataFormatTest());
		runner.addCase(new URLLoaderTest());
		Report.create(runner);
		runner.run();
	}
}
