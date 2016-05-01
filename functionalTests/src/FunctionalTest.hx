package;

import haxe.rtti.CType;
import lime.math.Rectangle in LimeRectangle;
import openfl.Assets;
import openfl.Lib;
import openfl.display.Application;
import openfl.display.Sprite;
import openfl.geom.Rectangle;

@:rtti
class FunctionalTest {

	static function main () {

		// Import all test groups
		CompileTime.importPackage ("ftests");

		var list = CompileTime.getAllClasses (FunctionalTest);
		var total = 0;
		var passed = 0;
		var args = Sys.args ();
		var keep = args.length > 0 && args[0] == "-k";

		if (keep) {

			args.shift();

		}

		var cname = args.length == 2 ? args[0] : null;
		var tname = args.length == 2 ? args[1] : null;

		for (c in list) {

			var name = Type.getClassName(c);

			if (cname != null) {

				if (name != cname) {

					continue;

				}

			}
			else {

				Sys.println("Testing " + name + " ...");

			}

			var obj = Type.createInstance (c, []);

			for (field in haxe.rtti.Rtti.getRtti(c).fields) {

				for (m in field.meta) {

					if (m.name != ":functionalTest") {

						continue;

					}

					if (tname != null) {

						if (field.name != tname) {

							continue;

						}

					} else {

						Sys.print("  " + field.name);

					}

					if (cname != null) {

						// Actually do the test
						var truth = m.params[0];
						truth = truth.substr(1, truth.length-2);
						launchTest (obj, field.name, truth, keep);

						// If the test didn't exit we had keep on
						Sys.exit (0);

					}
					else {

						// Launch a new process asking for the test
						total++;

						switch (Sys.command ("neko", ["tests.n", name, field.name])) {

							case 0:
								passed++;
								Sys.println (" succedded");

							case 1:
								Sys.println(" failed");

							case _:
								Sys.println(" errored");
						}

					}

				}

			}

		}

		// Print the results
		var success = passed == total;

		Sys.println("==============================");
		Sys.println(success ? "SUCCESS" : "FAILURE");
		Sys.println(total + " tests ran " + passed + " succedded and " + (total - passed) + " failed");

		Sys.exit (success ? 0 : 1);
	}

	/**
	 * Launch a test function in a clean app,
	 * and then compares its output to the expected truth.
	 */
	public static function launchTest (object:FunctionalTest, testMethod:String, truth:String, keep:Bool) {

		// Creating a new OpenFL app
		var config = {};
		var app = new Application ();
		app.create (config);

		var window = new DummyWindow ();
		app.createWindow(window);

		var display = new NMEPreloader ();
		var preloader = new openfl.display.Preloader (display);
		@:privateAccess app.setPreloader (preloader);

		// Injecting test code
		var test = function () {  Reflect.callMethod (object, Reflect.field (object, testMethod), [Lib.current]); };

		if (keep) {

			preloader.onComplete.add (test);

		}
		else {

			preloader.onComplete.add (report.bind(app, test, truth));

		}

		preloader.create (config);

		// Running app
		app.exec();

	}

	public static function report (app:Application, fn:Void->Void, truth:String) {

		// Run test code
		try {

			fn();

		}
		catch (e:Dynamic) {

			Sys.stderr().writeString (e);
			Sys.exit (2);

		}

		// Render
		var renderer = app.window.renderer;
		Lib.current.stage.render(renderer);
		@:privateAccess renderer.flip ();

		// Extract output
		var outputImage = renderer.readPixels (new LimeRectangle (0, 0, 800, 600));
		var outputData = outputImage.getPixels (new LimeRectangle (0, 0, outputImage.width, outputImage.height), ARGB32);

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

			Sys.exit (0);

		}
		else {

			Sys.exit (1);

		}

	}

	/**
	 * Required for Type.createInstance
	 */
	public function new () {
	}

}
