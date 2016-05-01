package;

import lime.math.Rectangle in LimeRectangle;
import openfl.Assets;
import openfl.Lib;
import openfl.display.Application;
import openfl.display.Sprite;
import openfl.geom.Rectangle;

@:autoBuild(FunctionalTestMacro.buildSubClasses())
class FunctionalTest {

	static function main () {

		// Import all test groups
		CompileTime.importPackage("ftests");
		var list = CompileTime.getAllClasses(FunctionalTest);

		var total = 0;
		var passed = 0;

		// For each test group, run it
		for (c in list) {

			var name = Type.getClassName(c).split(".");
			name.shift();
			Sys.print("Testing " + name.join(".") + ": ");

			var obj = Type.createInstance(c, []);
			obj.run();

			total += obj.total;
			passed += obj.passed;

			Sys.println("");

		}

		// Print the results
		var success = passed == total;

		Sys.println("==============================");
		Sys.println(success ? "SUCCESS" : "FAILURE");
		Sys.println(total + " tests ran " + passed + " succedded and " + (total - passed) + " failed");

		Sys.exit (success ? 0 : 1);

	}

	/** Number of tests which passed. */
	public var passed:Int = 0;

	/** Number of test ran. */
	public var total:Int = 0;

	// Necessary for Type.createInstance to work
	public function new () {
	}

	// Will be overriden in the test classes
	public function run () {
	}

	/**
	 * Launch a test function in a clean app,
	 * and then compares its output to the expected truth.
	 */
	@:access(lime.app.Application)
	public function launchTest (fn:Sprite->Void, truth:String) {

		total++;

		try {

			// Creating a new OpenFL app
			var config = {};
			var app = new Application ();
			app.create (config);

			var window = new DummyWindow ();
			app.createWindow(window);

			var display = new NMEPreloader ();
			var preloader = new openfl.display.Preloader (display);
			app.setPreloader (preloader);

			// Injecting test code
			preloader.onComplete.add (report.bind(app, fn.bind(Lib.current), truth));
			preloader.create (config);

			// Running app
			app.exec();
		}
		catch (e:String) {

			if (e != "testdone") {

				throw e;

			}

		}

	}

	public function report (app:Application, fn:Void->Void, truth:String) {

		// Run test code
		try {

			fn();

		}
		catch (e:Dynamic) {

			Sys.println(" ");
			Sys.println("    [ERROR] " + e);

			testDone (app);

		}

		// Render
		var renderer = app.window.renderer;
		Lib.current.stage.render(renderer);
		@:privateAccess renderer.flip ();

		// Extract output
		var outputImage = renderer.readPixels (new LimeRectangle (0, 0, 800, 600));
		var outputData = outputImage.getPixels (new LimeRectangle (0, 0, outputImage.width, outputImage.height), ARGB32);

		//sys.io.File.saveBytes ("output/" + truth, outputImage.encode ()); //TEMP

		// Load truth
		var truthImage = Assets.getBitmapData ("truths/" + truth);
		var truthData = truthImage.getPixels (new Rectangle (0, 0, truthImage.width, truthImage.height));

		// Compare output and truth
		var totalDistance = -1.0;
		var l = truthData.length;
		var i = 0;
		var p1, p2, d;
		var nan = 0;

		while (i < l)
		{
			i += 4;

			p1 = ColorUtils.getLCHab (outputData);
			p2 = ColorUtils.getLCHab (truthData);

			d = ColorUtils.CMC (1, 1, p2, p1); // Output to reference truth

			if (!Math.isNaN (d)) {

				totalDistance += d;

			}
			else {

				//TODO Find out the source of the NaN
				nan += 1;

			}

		}

		//trace(totalDistance, nan, totalDistance/(800*600));

		// Report
		if (totalDistance/(800*600) < 0.5) { //TODO find good threshold, note that 17 seems to be the max so that 0.5 would be 3%
			passed++;
			Sys.print(".");
		}
		else {
			Sys.print("!");
		}

		testDone (app);
	}

	@:access(lime.app.Application)
	function testDone (app:Application) {

		app.backend.exit();
		throw "testdone";

	}

}
