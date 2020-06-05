var fs = require("fs");
var path = require("path");
var childProcess = require("child_process")

var cwd = process.cwd();
var testPath = path.resolve(cwd, "test");
var tests = [];

if (fs.existsSync(testPath))
{
	tests = fs.readdirSync(testPath).filter((value) => {
		return fs.lstatSync(path.resolve(testPath, value)).isFile();
	});
}

function getDependencies(dir, moduleList)
{
	if (moduleList == null) moduleList = [];

	var modulePath = path.resolve(dir, "node_modules", "@openfl");
	if (fs.existsSync(modulePath))
	{
		var folders = fs.readdirSync(modulePath);
		folders.forEach(folder => {
			if (moduleList.every(item => path.basename(item) != folder))
			{
				// var module = path.resolve(modulePath, folder);
				var module = path.relative(cwd, "../" + folder);
				moduleList.push(module);
				getDependencies(module, moduleList);
			}
		});
	}

	return moduleList;
}

if (tests.length > 0)
{
	var hxml = [
		"-js test.js",
		"-cp " + path.resolve(cwd, "src"),
		"-cp " + path.resolve(cwd, "test"),
		"-D html5",
		"-D commonjs"
	];

	var haxeDependencies = getDependencies(cwd);
	haxeDependencies.forEach(value => {
		if (value.indexOf("backend-lime") > -1)
		{
			haxeDependencies.push(path.resolve(value, "node_modules/lime"));
			hxml.push("-D lime");
			hxml.push("-D lime-webgl");
		}
	});
	haxeDependencies = haxeDependencies.map(module => path.resolve(module, "src"));

	for (var dependency of haxeDependencies)
	{
		hxml.push("-cp " + dependency);
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

	var exec = childProcess.exec("haxe test.hxml && mocha-chrome test.html", { cwd: libPath });
	exec.stdout.on('data', (data) => {
		console.log(data);
	});
	exec.stderr.on('data', (data) => {
		console.log(data);
	});
	exec.on('exit', (code) => {
		process.exit(code);
	});
}

