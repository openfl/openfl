var fs = require('fs');
var path = require('path');

var cwd = process.cwd();
var modulePath = path.resolve(cwd, "node_modules", "@openfl");
var packages = [];

if (fs.existsSync(modulePath))
{
	packages = fs.readdirSync(modulePath);
}

if (packages.length > 0)
{
	var haxelibPath = path.resolve(cwd, ".haxelib");
	if (!fs.existsSync(haxelibPath))
	{
		fs.mkdirSync(haxelibPath);
	}

	for (i = 0; i < packages.length; i++)
	{
		var packagePath = path.resolve(haxelibPath, "openfl," + packages[i]);
		if (!fs.existsSync(packagePath))
		{
			fs.mkdirSync(packagePath);
		}

		var dev = path.resolve(packagePath, ".dev");
		fs.writeFileSync(dev, path.resolve(modulePath, packages[i]));
	}
}