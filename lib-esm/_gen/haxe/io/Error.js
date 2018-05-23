// Enum: haxe.io.Error

var $global = typeof window != "undefined" ? window : typeof global != "undefined" ? global : typeof self != "undefined" ? self : this



// Imports

var $estr = require("./../../estr_stub").default;
var $hxClasses = require("./../../hxClasses_stub").default;

// Definition

var Error = $hxClasses["haxe.io.Error"] = { __ename__: ["haxe","io","Error"], __constructs__: ["Blocked","Overflow","OutsideBounds","Custom"] }

Error.Custom = function(e) { var $x = ["Custom",3,e]; $x.__enum__ = Error; $x.toString = $estr; return $x; }
Error.Blocked = ["Blocked",0];
Error.Blocked.toString = $estr;
Error.Blocked.__enum__ = Error;

Error.Overflow = ["Overflow",1];
Error.Overflow.toString = $estr;
Error.Overflow.__enum__ = Error;

Error.OutsideBounds = ["OutsideBounds",2];
Error.OutsideBounds.toString = $estr;
Error.OutsideBounds.__enum__ = Error;


exports.default = Error;