var fs = require("fs");
var path = require("path");
var childProcess = require("child_process");

var cwd = process.cwd();
var testPath = path.resolve(cwd, "test");
var libPath = path.resolve(cwd, "lib");
var rootPath = path.resolve(cwd, "../../");
var packageName = path.basename(cwd);

if (fs.existsSync(testPath))
{
	var fork = childProcess.fork(path.resolve(__dirname, "prepare-test.js"), { cwd: process.cwd() });
	fork.on('error', function (err) {
		console.log(err);
    });
    fork.on('exit', function (code) {
		if (code != 0) process.exit(code);
		if (fs.existsSync(path.resolve(libPath, "test.js")))
		{
			var exec = childProcess.spawn("node_modules\\.bin\\karma start karma.conf.js --package=" + packageName, { cwd: rootPath, shell: true, windowsHide: true });
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
    });
}