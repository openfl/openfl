var fs = require("fs");
var path = require("path");
var childProcess = require("child_process");

var cwd = process.cwd();
var packagesPath = path.resolve(cwd, "packages");
var packages = fs.readdirSync(packagesPath).filter((value) => {
	return fs.lstatSync(path.resolve(packagesPath, value)).isDirectory();
}).map(value => path.resolve(packagesPath, value));

function runTests()
{
	var exec = childProcess.spawn("karma start karma.conf.js", { cwd: cwd, shell: true, windowsHide: true });
	exec.stdout.on('data', (data) => {
		console.log(data.toString());
	});
	exec.stderr.on('data', (data) => {
		console.log(data.toString());
	});
	exec.on('exit', (code) => {
		process.exit(code);
	});
}

console.log("\x1b[36mBuilding Tests\x1b[0m\n");

var i = 0;
function preparePackage()
{
	var current = (i + 1).toString();
	if (current.length == 1) current = "0" + current;
	var packageLabel = path.relative(cwd, packages[i]);

	console.log("\x1b[36m[" + current + "/" + packages.length + "]\x1b[0m " + packageLabel);

	var fork = childProcess.fork(path.resolve(__dirname, "prepare-test.js"), { cwd: packages[i] });
	fork.on('error', function (err) {
		console.log(err);
    });
    fork.on('exit', function (code) {
		if (code != 0) process.exit(code);
		i++;
		if (i < packages.length)
		{
			preparePackage();
		}
		else
		{
			console.log("");
			runTests();
		}
    });
}

preparePackage();