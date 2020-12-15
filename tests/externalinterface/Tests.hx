import utest.Runner;
import utest.ui.Report;

class Tests
{
	public static function main()
	{
		var runner = new Runner();
		runner.addCase(new ExternalInterfaceTest());
		Report.create(runner);
		runner.run();
	}
}
