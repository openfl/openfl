

var $bind = require('./bind_stub').default;
var HxOverrides = require('./HxOverrides');

exports.default = function $iterator(o) {
    if( o instanceof Array ) {
        return function() {
            return HxOverrides.default.iter(o);
        };
    }
    return typeof(o.iterator) == 'function' ? $bind(o,o.iterator) : o.iterator;
}