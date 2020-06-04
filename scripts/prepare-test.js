var fs = require("fs");
var path = require("path");
var childProcess = require("child_process")

var cwd = process.cwd();
var modulePath = path.resolve(cwd, "node_modules", "@openfl");
var testPath = path.resolve(cwd, "test");

var haxeDependencies = [];
var tests = [];

if (fs.existsSync(testPath))
{
	tests = fs.readdirSync(testPath).filter((value) => {
		return fs.lstatSync(path.resolve(testPath, value)).isFile();
	})
}

if (tests.length > 0)
{
	if (fs.existsSync(modulePath))
	{
		haxeDependencies = fs.readdirSync(modulePath);
	}

	var hxml = [
		"-js test.js",
		"-cp ../src",
		"-cp ../test"
	]

	for (i = 0; i < haxeDependencies.length; i++)
	{
		hxml.push("-cp " + path.resolve(modulePath, haxeDependencies[i], "src"));
	}

	hxml = hxml.concat(tests);

	var libPath = path.resolve(cwd, "lib");
	var templateFile = fs.readFileSync(path.resolve(__dirname, "..", "packages", "mocha", "dist", "test.html"));

	if (!fs.existsSync(libPath))
	{
		fs.mkdirSync(libPath);
	}

	fs.writeFileSync(path.resolve(libPath, "test.hxml"), hxml.join("\n"));
	fs.writeFileSync(path.resolve(libPath, "test.html"), templateFile);
}

