import utest.Runner;
import utest.ui.Report;

class Tests
{
	public static function main()
	{
		var runner = new Runner();
		runner.addCase(new TilemapTest());
		runner.addCase(new TilesetTest());
		runner.addCase(new TileTest());
		Report.create(runner);
		runner.run();
	}
}
