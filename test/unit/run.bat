haxelib run munit gen || exit /b
openfl test neko || exit /b
openfl test cpp || exit /b
openfl build flash || exit /b
openfl build html5 || exit /b
haxelib run munit test || exit /b