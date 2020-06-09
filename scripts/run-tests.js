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
	exec.stdout.pipe(process.stdout);
	exec.stderr.pipe(process.stderr);
	exec.on('exit', (code) => {
		process.exit(code);
	});
}

var i = 0;
var lastMessageLength = 0;

function preparePackage()
{
	var current = i + 1;
	var percent = Math.ceil((current / packages.length) * 100);

	var message = "\x1b[36mBuilding test\x1b[0m - " + current + "/" + packages.length + " (" + percent + "%)";
	var messageLength = message.length;
	if (messageLength < lastMessageLength)
	{
		while (message.length < lastMessageLength)
		{
			message += " ";
		}
	}
	lastMessageLength = messageLength;

	process.stdout.cursorTo(0);
	process.stdout.write(message);

	var fork = childProcess.fork(path.resolve(__dirname, "prepare-test.js"), { cwd: packages[i] });
	fork.on('data', function(data)
	{
		console.log(data.toString());
	});
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
			process.stdout.write(" \x1b[36mSUCCESS\x1b[0m\n\n");
			runTests();
		}
    });
}

preparePackage();