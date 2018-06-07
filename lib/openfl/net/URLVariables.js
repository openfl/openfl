Object.defineProperty(exports, "__esModule", {value: true});
var URLVariables_Impl_ = require("./../../_gen/openfl/net/_URLVariables/URLVariables_Impl_").default;

var URLVariables = function (source) {
	if (source != null) {
		URLVariables_Impl_.decode (this, source);
	}
}
URLVariables.prototype.decode = function (source) {
	URLVariables_Impl_.decode (this, source);
}
URLVariables.prototype.toString = function () {
	return URLVariables_Impl_.toString (this);
}
URLVariables.prototype.constructor = URLVariables;

module.exports.default = URLVariables;