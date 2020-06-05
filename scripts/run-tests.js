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
	var jsFiles = packages.map(value => path.resolve(value, "lib/test.js")).filter(value => fs.existsSync(value));
	var htmlPath = path.resolve(cwd, "packages/mocha/dist/test-page.marko");
	console.log(fs.existsSync(htmlPath));

	var exec = childProcess.spawn("mocha-puppeteer", jsFiles.concat([ "--testPagePath", htmlPath ]), { cwd: cwd, shell: true, windowsHide: true });
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

var i = 0;
function preparePackage()
{
	console.log("Building tests: " + packages[i]);
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
			runTests();
		}
    });
}

// preparePackage();
runTests();