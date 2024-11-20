# OpenFL Release Checklist

- Add release notes to _CHANGELOG.md_
	- Compare to previous tag on GitHub:
		`https://github.com/openfl/openfl/compare/a.b.c...develop`
	- Compare to previous tag in terminal:
		```sh
		git log a.b.c...develop --oneline
		```
	- Sometimes, commits from previous releases show up, but most should be correct
- Update release note in _haxelib.json_
- Update version in _haxelib.json_ (may be updated already)
- Update release date in _CHANGELOG.md_
- Tag release and push
	```sh
	git tag -s x.y.z -m "version x.y.z"
	git push origin x.y.z
	```
- Download _openfl-haxelib_ and _openfl-docs_ artifacts for tag from GitHub Actions
- Submit _.zip_ file to Haxelib with following command:
	```sh
	haxelib submit openfl-haxelib.zip
	```
- Create new release for tag on GitHub
	- Upload _openfl-haxelib.zip_ and _openfl-docs.zip_
	- Link to _CHANGELOG.md_ from tag and to _https://community.openfl.org_ announcement thread
		- _CHANGELOG.md_ tag URL format: `https://github.com/openfl/openfl/blob/x.y.z/CHANGELOG.md`
		- It's okay to skip link to announcement at first, and edit the release to add it later
- Deploy API reference by updating Git refs in _.github/workflows/deploy.yml_ in _openfl/api.openfl.org_ repo
	```yaml
    - uses: actions/checkout@v4
      with:
        repository: openfl/openfl
        path: openfl
        ref: x.y.z
    
    - uses: actions/checkout@v4
      with:
        repository: openfl/lime
        path: lime
        ref: a.b.c
	```
- Make announcement on _https://community.openfl.org_ in _Announcements_ category
	- For feature releases, it's good to write a summary of noteworthy new features
	- For bugfix releases, intro can be short
	- Include full list of changes from _CHANGELOG.md_
	- If also releasing Lime at the same time, announcement thread should be combined
	- After posting, go back and add link to thread GitHub release description, if needed

## OpenFL JS

- Update version in _package.json_ (may be updated already)
- Update openfl, lime, and swf repo tags in _package.json_
	```json
	"lime": "github:openfl/lime#8.2.0",
  "openfl-haxelib": "github:openfl/openfl#9.4.0",
  "swf": "github:openfl/swf#3.2.0",
  ```
- Delete _node\_modules_ and _package-lock.json_.
- Run **`npm install`**.
	- On macOS, **`arch -x86_64 npm install`** may be required
- Commit new _package.json_ and _package-lock.json_
- Tag release and push
	```sh
	git tag -s x.y.z -m "version x.y.z"
	git push origin x.y.z
	```
- Download _openfl-npm_ artifact for tag from GitHub Actions
- Submit _.tgz file to Haxelib with following command:
		```sh
		npm publish openfl-npm.tgz
		```