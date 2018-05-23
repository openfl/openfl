// Class: openfl.Memory

var $global = typeof window != "undefined" ? window : typeof global != "undefined" ? global : typeof self != "undefined" ? self : this



var __map_reserved = {};

// Imports

var $hxClasses = require("./../hxClasses_stub").default;
var $import = require("./../import_stub").default;
function openfl_utils__$ByteArray_ByteArray_$Impl_$() {return require("./../openfl/utils/_ByteArray/ByteArray_Impl_");}

// Constructor

var Memory = function(){}

// Meta

Memory.__name__ = ["openfl","Memory"];
Memory.prototype = {
	
};
Memory.prototype.__class__ = Memory.prototype.constructor = $hxClasses["openfl.Memory"] = Memory;

// Init



// Statics

Memory._setPositionTemporarily = function(position,action) {
	var oldPosition = Memory.gcRef.position;
	Memory.gcRef.position = position;
	var value = action();
	Memory.gcRef.position = oldPosition;
	return value;
}
Memory.getByte = function(addr) {
	return Memory.gcRef.get(addr);
}
Memory.getDouble = function(addr) {
	return Memory._setPositionTemporarily(addr,function() {
		return Memory.gcRef.readDouble();
	});
}
Memory.getFloat = function(addr) {
	return Memory._setPositionTemporarily(addr,function() {
		return Memory.gcRef.readFloat();
	});
}
Memory.getI32 = function(addr) {
	return Memory._setPositionTemporarily(addr,function() {
		return Memory.gcRef.readInt();
	});
}
Memory.getUI16 = function(addr) {
	return Memory._setPositionTemporarily(addr,function() {
		return Memory.gcRef.readUnsignedShort();
	});
}
Memory.select = function(inBytes) {
	Memory.gcRef = inBytes;
	Memory.len = inBytes != null ? (openfl_utils__$ByteArray_ByteArray_$Impl_$().default).get_length(inBytes) : 0;
}
Memory.setByte = function(addr,v) {
	var this1 = Memory.gcRef;
	this1.__resize(addr + 1);
	this1.set(addr,v);
}
Memory.setDouble = function(addr,v) {
	Memory._setPositionTemporarily(addr,function() {
		Memory.gcRef.writeDouble(v);
	});
}
Memory.setFloat = function(addr,v) {
	Memory._setPositionTemporarily(addr,function() {
		Memory.gcRef.writeFloat(v);
	});
}
Memory.setI16 = function(addr,v) {
	Memory._setPositionTemporarily(addr,function() {
		Memory.gcRef.writeShort(v);
	});
}
Memory.setI32 = function(addr,v) {
	Memory._setPositionTemporarily(addr,function() {
		Memory.gcRef.writeInt(v);
	});
}


// Export

exports.default = Memory;