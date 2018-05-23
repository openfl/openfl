

// exports.default = function $import(obj) {
// 	if(obj && obj.__esModule) {
// 		// if(!obj.hasOwnProperty('default')) obj.default = obj;
// 		return obj;
// 	} else { 
// 		var newObj = {};
// 		if (obj != null) {
// 			for (var key in obj) {
// 				if (Object.prototype.hasOwnProperty.call(obj, key))
// 					newObj[key] = obj[key];
// 			}
// 		} 
// 		newObj.default = obj;
// 		return newObj;
// 	}
// }
exports.default = function $import(obj) {
	return obj && obj.__esModule ? obj : {default: obj};
}
