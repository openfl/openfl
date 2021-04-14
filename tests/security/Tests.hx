import utest.Runner;
import utest.ui.Report;

class Tests
{
	public static function main()
	{
		var runner = new Runner();
		runner.addCase(new ApplicationDomainTest());
		runner.addCase(new SecurityDomainTest());
		runner.addCase(new SecurityErrorEventTest());
		Report.create(runner);
		runner.run();
	}
}
