package;

import haxe.rtti.CType;
import lime.math.Rectangle as LimeRectangle;
import openfl.Assets;
import openfl.Lib;
import openfl.display.Application;
import openfl.display.Sprite;
import openfl.geom.Rectangle;
import sys.io.File;

@:rtti
class FunctionalTest {

	static function main () {

		lime.Assets.registerLibrary ("default", new DefaultAssetLibrary ());

		// Import all test groups
		CompileTime.importPackage ("ftests");

		var list = CompileTime.getAllClasses (FunctionalTest);
		var total = 0;
		var passed = 0;
		var ignored = 0;
		var args = Sys.args ();
		var keep = args.length > 0 && args[0] == "-k";
		var dump = args.length > 0 && args[0] == "-d";

		if (keep || dump) {

			args.shift ();

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

				var isTest = false;
				var isIgnored = false;

				for (m in field.meta) {

					isTest = isTest || m.name == ":functionalTest";
					isIgnored = isIgnored || m.name == ":ignore";

				}

				if (!isTest) {

					continue;

				}

				if (tname != null) {

					if (field.name != tname) {

						continue;

					}

				} else {

					if (isIgnored) {

						ignored++;
						Sys.println("  [IGNORING] " + field.name);
						continue;

					}
					else {

						Sys.print("  " + field.name);

					}

				}

				if (cname != null) {

					// Actually do the test
					var cl_name = name.split(".");
					cl_name.shift();
					var truth = cl_name.join("_") + "/" + field.name + ".png";
					launchTest (obj, field.name, truth, keep, dump);

					// If the test didn't exit we had keep on
					Sys.exit (0);

				}
				else {

					// Launch a new process asking for the test
					total++;

				#if neko
					switch (Sys.command ("neko", ["tests.n", name, field.name])) {
				#elseif cpp
					switch (Sys.command ("./bin/FunctionalTest", [name, field.name])) {
				#end
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

		// Print the results
		var success = passed == total;

		Sys.println("==============================");
		Sys.println(success ? "SUCCESS" : "FAILURE");
		Sys.println(total + " tests ran: " + passed + " succedded, " + (total - passed) + " failed and " + ignored + " were ignored");

		Sys.exit (success ? 0 : 1);
	}

	/**
	 * Launch a test function in a clean app,
	 * and then compares its output to the expected truth.
	 */
	public static function launchTest (object:FunctionalTest, testMethod:String, truth:String, keep:Bool, dump:Bool) {

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

			preloader.onComplete.add (report.bind(app, test, truth, dump));

		}

		preloader.create (config);

		// Running app
		app.exec();

	}

	public static function report (app:Application, fn:Void->Void, truth:String, dump:Bool) {

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
		var outputData = outputImage.data;

		if (dump) {

			var b = outputImage.encode ();
			File.saveBytes ("dump.png", b);
			Sys.exit (0);

		}

		// Load truth
		var truthData = Assets.getBitmapData ("truths/" + truth).image.data;

		// Compare output and truth
		var totalDistance = 0.0;
		var l = 800 * 600;
		var nan = 0;
		var differentPixels = 0;

		for (i in 0...l) {

			var p1_r = outputData.__get(i*4 + 0) / 255.0;
			var p1_g = outputData.__get(i*4 + 1) / 255.0;
			var p1_b = outputData.__get(i*4 + 2) / 255.0;

			var p2_b = truthData.__get(i*4 + 0) / 255.0;
			var p2_g = truthData.__get(i*4 + 1) / 255.0;
			var p2_r = truthData.__get(i*4 + 2) / 255.0;

			var p1 = { r: p1_r, g: p1_g, b: p1_b };
			var p2 = { r: p2_r, g: p2_g, b: p2_b };

			if (ColorUtils.equalRGB (p1, p2)) {

				continue;

			}

			differentPixels++;

			var d = ColorUtils.CMC (1, 1, ColorUtils.RGBtoLCHab(p2), ColorUtils.RGBtoLCHab(p1)); // Output to reference truth

			if (!Math.isNaN (d)) {

				totalDistance += d;

			}
			else {

				//TODO Find out the source of the NaN
				nan += 1;

			}

		}

		// Report
		if (differentPixels == 0 || totalDistance/differentPixels < 1) { //TODO find good threshold, find out range of CMC too

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
