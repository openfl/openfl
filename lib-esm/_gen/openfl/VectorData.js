// Class: openfl.VectorData

var $global = typeof window != "undefined" ? window : typeof global != "undefined" ? global : typeof self != "undefined" ? self : this



var __map_reserved = {};

// Imports

var $hxClasses = require("./../hxClasses_stub").default;
var $import = require("./../import_stub").default;
function openfl__$Vector_VectorIterator() {return require("./../openfl/_Vector/VectorIterator");}

// Constructor

var VectorData = function(length,fixed,array) {
	this.construct(this,length,fixed);
}

// Meta

VectorData.__name__ = ["openfl","VectorData"];
VectorData.prototype = {
	construct: function(instance,length,fixed) {
		if(length != null) {
			instance.length = length;
		}
		instance.fixed = fixed == true;
		return instance;
	},
	concat: function(a) {
		return VectorData.ofArray(Array.prototype.concat.call (this, a));
	},
	copy: function() {
		return VectorData.ofArray(this);
	},
	get: function(index) {
		return this[index];
	},
	indexOf: function(x,from) {
		if(from == null) {
			from = 0;
		}
		return -1;
	},
	insertAt: function(index,element) {
		if(!this.fixed || index < this.length) {
			Array.prototype.splice.call (this, index, 0, element);
		}
	},
	iterator: function() {
		return new (openfl__$Vector_VectorIterator().default)(this);
	},
	join: function(sep) {
		if(sep == null) {
			sep = ",";
		}
		return null;
	},
	lastIndexOf: function(x,from) {
		if(from == null) {
			return Array.prototype.lastIndexOf.call (this, x);
		} else {
			return Array.prototype.lastIndexOf.call (this, x, from);
		}
	},
	pop: function() {
		if(!this.fixed) {
			return Array.prototype.pop.call (this);
		} else {
			return null;
		}
	},
	push: function(x) {
		if(!this.fixed) {
			return Array.prototype.push.call (this, x);
		} else {
			return this.length;
		}
	},
	removeAt: function(index) {
		if(!this.fixed || index < this.length) {
			return Array.prototype.splice.call (this, index, 1)[0];
		}
		return null;
	},
	reverse: function() {
		return this;
	},
	set: function(index,value) {
		if(!this.fixed || index < this.length) {
			return this[index] = value;
		} else {
			return value;
		}
	},
	shift: function() {
		if(!this.fixed) {
			return Array.prototype.shift.call (this);
		} else {
			return null;
		}
	},
	slice: function(startIndex,endIndex) {
		if(endIndex == null) {
			endIndex = 16777215;
		}
		if(startIndex == null) {
			startIndex = 0;
		}
		return VectorData.ofArray(Array.prototype.slice.call (this, startIndex, endIndex));
	},
	sort: function(f) {
	},
	splice: function(pos,len) {
		return VectorData.ofArray(Array.prototype.splice.call (this, pos, len));
	},
	toString: function() {
		return null;
	},
	unshift: function(x) {
		if(!this.fixed) {
			Array.prototype.unshift.call (this, x);
		}
	},
	get_length: function() {
		return this.length;
	},
	set_length: function(value) {
		if(!this.fixed) {
			this.length = value;
		}
		return value;
	}
};
VectorData.prototype.__class__ = VectorData.prototype.constructor = $hxClasses["openfl.VectorData"] = VectorData;

// Init

var prefix = (typeof openfl_VectorData !== 'undefined');
		var ref = (prefix ? openfl_VectorData : VectorData);
		var p = ref.prototype;
		var construct = p.construct;
		var _VectorDataDescriptor = {
			constructor: { value: null },
			concat: { value: p.concat },
			copy: { value: p.copy },
			get: { value: p.get },
			insertAt: { value: p.insertAt },
			iterator: { value: p.iterator },
			lastIndexOf: { value: p.lastIndexOf },
			pop: { value: p.pop },
			push: { value: p.push },
			removeAt: { value: p.removeAt },
			set: { value: p.set },
			shift: { value: p.shift },
			slice: { value: p.slice },
			splice: { value: p.splice },
			unshift: { value: p.unshift },
			get_length: { value: p.get_length },
			set_length: { value: p.set_length },
		}
		var _VectorData = function (length, fixed) {
			return Object.defineProperties (construct ([], length, fixed), _VectorDataDescriptor);
		}
		_VectorDataDescriptor.constructor.value = _VectorData;
		_VectorData.__name__ = ref.__name__;
		_VectorData.ofArray = ref.ofArray;
		$hxClasses['openfl.VectorData'] = _VectorData;
		_VectorData.prototype = Array.prototype
		if (prefix) openfl_VectorData = _VectorData; else VectorData = _VectorData;
		;

// Statics

VectorData.ofArray = function(a) {
	if(a == null) {
		return null;
	}
	var data = new VectorData();
	var _g1 = 0;
	var _g = a.length;
	while(_g1 < _g) {
		var i = _g1++;
		data[i] = a[i];
	}
	return data;
}


// Export

exports.default = VectorData;