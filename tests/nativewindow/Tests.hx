import utest.Runner;
import utest.ui.Report;

class Tests
{
	public static function main()
	{
		#if ((sys || air) && tools)
		// these tests only work on sys or air targets,
		// and you must use Lime tools
		var runner = new Runner();
		runner.addCase(new NativeWindowTest());
		Report.create(runner);
		runner.run();
		#else
		trace("Skipping NativeWindow tests");
		lime.system.System.exit(0);
		#end
	}
}
