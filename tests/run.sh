cd unit
haxelib run munit gen

if [[ "${1-html5}" = "html5" ]]; then
  lime build html5 -nocffi
  haxelib run munit test -browser phantomjs -nocffi
fi

if [[ "${1-neko}" = "neko" ]]; then
  lime build neko -nocffi
  lime build neko -Ddisable-cffi -nocffi
fi

if [[ "${1-cpp}" = "cpp" ]]; then
  lime test cpp --window-hardware=false
fi

if [[ "${1-flash}" = "flash" ]]; then
  lime build flash -nocffi
  haxelib run munit test -as3 -norun -nocffi
fi

if [[ "${1-docs}" = "docs" ]]; then
  cd ../../docs
  haxe build.hxml
fi