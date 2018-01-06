var workingDirectory = require ('path').resolve (__dirname, '..');

var command = "docker";
var args = [ "run", "--rm", "--volume", workingDirectory + ":/opt/openfl-js", "--workdir", "/opt/openfl-js", process.argv[2], "/bin/bash -c \"" + process.argv[3] + "\"" ];

// console.log (command + " " + args.join (" "));

var docker = require ('child_process').spawn ("docker", args, {
	cwd: workingDirectory,
	shell: true,
	windowsHide: true
});

docker.stdout.on ("data", function (data) {
	console.log (data.toString ());
});

docker.stderr.on ("data", function (data) {
	console.error (data.toString ());
});

docker.on ("exit", function (code) {
	process.exit (code);
});