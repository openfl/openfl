

exports.default = function $extend(from, fields) {
    function Inherit() {};
    Inherit.prototype = from;
    var proto = new Inherit();
    for (var name in fields) proto[name] = fields[name];
    if(fields.toString !== Object.prototype.toString) proto.toString = fields.toString;
    return proto;
};
