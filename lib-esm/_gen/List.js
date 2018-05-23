// Class: List

var $global = typeof window != "undefined" ? window : typeof global != "undefined" ? global : typeof self != "undefined" ? self : this



var __map_reserved = {};

// Imports

var $hxClasses = require("./hxClasses_stub").default;
var $import = require("./import_stub").default;
function _$List_ListNode() {return require("./_List/ListNode");}
function _$List_ListIterator() {return require("./_List/ListIterator");}

// Constructor

var List = function() {
	this.length = 0;
}

// Meta

List.__name__ = ["List"];
List.prototype = {
	add: function(item) {
		var x = new (_$List_ListNode().default)(item,null);
		if(this.h == null) {
			this.h = x;
		} else {
			this.q.next = x;
		}
		this.q = x;
		this.length++;
	},
	pop: function() {
		if(this.h == null) {
			return null;
		}
		var x = this.h.item;
		this.h = this.h.next;
		if(this.h == null) {
			this.q = null;
		}
		this.length--;
		return x;
	},
	clear: function() {
		this.h = null;
		this.q = null;
		this.length = 0;
	},
	remove: function(v) {
		var prev = null;
		var l = this.h;
		while(l != null) {
			if(l.item == v) {
				if(prev == null) {
					this.h = l.next;
				} else {
					prev.next = l.next;
				}
				if(this.q == l) {
					this.q = prev;
				}
				this.length--;
				return true;
			}
			prev = l;
			l = l.next;
		}
		return false;
	},
	iterator: function() {
		return new (_$List_ListIterator().default)(this.h);
	}
};
List.prototype.__class__ = List.prototype.constructor = $hxClasses["List"] = List;

// Init



// Statics




// Export

exports.default = List;