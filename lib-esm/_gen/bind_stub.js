// Haxe uses its own caching bind method.  It's faster, but less standard than Function.bind.
// This version is slightly modified for compressability, modularization and readability.
// https://github.com/HaxeFoundation/haxe/issues/1349
// http://stackoverflow.com/a/17638540/1732990



var $fid = 0;

exports.default = function $bind(obj, method) {
    var func, mId;

    if( method == null ) { return null; }
    mId = method._i = method._i || $fid++;

    if( obj._c == null ) {
        obj._c = {};
    } else {
        func = obj._c[mId];
    }
    if( func == null ) {
        func = function(){
            return func._m.apply(func._s, arguments);
        };
        func._s = obj;
        func._m = method;
        obj._c[mId] = func;
    }
    return func;
};