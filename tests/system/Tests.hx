import utest.Runner;
import utest.ui.Report;

class Tests
{
	public static function main()
	{
		#if (!flash && lime)
		openfl.utils._internal.Lib.current = openfl.Lib.current;
		#end

		var runner = new Runner();
		runner.addCase(new CapabilitiesTest());
		runner.addCase(new SystemTest());
		Report.create(runner);
		runner.run();
	}
}
