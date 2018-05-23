// Class: _List.ListIterator

var $global = typeof window != "undefined" ? window : typeof global != "undefined" ? global : typeof self != "undefined" ? self : this



var __map_reserved = {};

// Imports

var $hxClasses = require("./../hxClasses_stub").default;

// Constructor

var ListIterator = function(head) {
	this.head = head;
}

// Meta

ListIterator.__name__ = ["_List","ListIterator"];
ListIterator.prototype = {
	hasNext: function() {
		return this.head != null;
	},
	next: function() {
		var val = this.head.item;
		this.head = this.head.next;
		return val;
	}
};
ListIterator.prototype.__class__ = ListIterator.prototype.constructor = $hxClasses["_List.ListIterator"] = ListIterator;

// Init



// Statics




// Export

exports.default = ListIterator;