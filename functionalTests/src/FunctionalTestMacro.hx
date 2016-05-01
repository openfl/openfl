package;

import haxe.macro.Context;
import haxe.macro.Expr;

/**
 * Build macro applied to all test classes through @:autoBuild.
 * Adds a run function which call `launchTest(fn, truth)` on all the
 * @:functionalTest functions.
 */
class FunctionalTestMacro {

	macro static public function buildSubClasses ():Array<Field> {

		var fields = Context.getBuildFields();
		var tests = [];

		for (field in fields) {

			for (meta in field.meta) {

				if (meta.name == ":functionalTest") {

					switch (meta.params[0].expr) {

						case EConst(CString(v)):
							tests.push( macro launchTest ( $i{field.name}, $v{v} ) );

						default:
							trace("Truth filename should be string");

					}

				}

			}

		}

		fields.push({
			kind: FFun({ args: [], expr: macro $b{tests}, ret: TPath({ name: "Void", pack: [], params: null, sub: null }), params: [] }),
			pos: Context.currentPos(),
			name: "run",
			access: [AOverride]
		});

		return fields;

	}

}
