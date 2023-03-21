import fs from "node:fs/promises";
import child_process from "node:child_process";
import path from "node:path";
import url from "node:url";

const excludedDirs = [
	"application",
	"bitmapdata",
	"functional",
];

async function isValidTestDir(dir) {
	try {
		if (!(await fs.stat(dir)).isDirectory()) {
			return false;
		}
		if (!(await fs.stat(path.resolve(dir, "build.hx"))).isFile()) {
			return false;
		}
	} catch(e) {
		return false;
	}
	if (excludedDirs.includes(path.basename(dir))) {
		return false;
	}
	return true;
}

const basedir = path.dirname(url.fileURLToPath(import.meta.url));
const files = await fs.readdir(basedir);
const dirs = [];
for (const file of files) {
	const dir = path.resolve(basedir, file);
	if (await isValidTestDir(dir)) {
		dirs.push(dir);
	}
}
dirs.forEach((dir, index) => {
	console.log(`running tests: ${dir} (${index + 1}/${dirs.length})`);
	if (dir == "functional") {
		return;
	}
	const srcPath = path.resolve(dir, "src");
	const projectFilePath = path.resolve("functional", "project.xml");
	const result = child_process.spawnSync("haxelib",
		[
			"run",
			"openfl-utest-tools",
			"test",
			"air",
			"--source",
			srcPath,
			"--project",
			projectFilePath
		],
		{
			stdio: "inherit",
		});
	if (result.status !== 0) {
		process.exit(result.status);
	}
});