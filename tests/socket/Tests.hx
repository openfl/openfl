import utest.Runner;
import utest.ui.Report;

class Tests
{
	public static function main()
	{
		var runner = new Runner();
		runner.addCase(new ServerSocketTest());
		runner.addCase(new DatagramSocketTest());
		Report.create(runner);
		runner.run();
	}
}
