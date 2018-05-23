// Class: haxe.ds.BalancedTree

var $global = typeof window != "undefined" ? window : typeof global != "undefined" ? global : typeof self != "undefined" ? self : this



var __map_reserved = {};

// Imports

var $hxClasses = require("./../../hxClasses_stub").default;
var $import = require("./../../import_stub").default;
function js__$Boot_HaxeError() {return require("./../../js/_Boot/HaxeError");}
function js_Boot() {return require("./../../js/Boot");}
function HxOverrides() {return require("./../../HxOverrides");}
function haxe_ds_TreeNode() {return require("./../../haxe/ds/TreeNode");}
function Reflect() {return require("./../../Reflect");}

// Constructor

var BalancedTree = function() {
}

// Meta

BalancedTree.__name__ = ["haxe","ds","BalancedTree"];
BalancedTree.prototype = {
	set: function(key,value) {
		this.root = this.setLoop(key,value,this.root);
	},
	get: function(key) {
		var node = this.root;
		while(node != null) {
			var c = this.compare(key,node.key);
			if(c == 0) {
				return node.value;
			}
			if(c < 0) {
				node = node.left;
			} else {
				node = node.right;
			}
		}
		return null;
	},
	remove: function(key) {
		try {
			this.root = this.removeLoop(key,this.root);
			return true;
		} catch( e ) {
			if (e instanceof (js__$Boot_HaxeError().default)) e = e.val;
			if( (js_Boot().default).__instanceof(e,String) ) {
				return false;
			} else throw(e);
		}
	},
	exists: function(key) {
		var node = this.root;
		while(node != null) {
			var c = this.compare(key,node.key);
			if(c == 0) {
				return true;
			} else if(c < 0) {
				node = node.left;
			} else {
				node = node.right;
			}
		}
		return false;
	},
	iterator: function() {
		var ret = [];
		this.iteratorLoop(this.root,ret);
		return (HxOverrides().default).iter(ret);
	},
	keys: function() {
		var ret = [];
		this.keysLoop(this.root,ret);
		return (HxOverrides().default).iter(ret);
	},
	setLoop: function(k,v,node) {
		if(node == null) {
			return new (haxe_ds_TreeNode().default)(null,k,v,null);
		}
		var c = this.compare(k,node.key);
		if(c == 0) {
			return new (haxe_ds_TreeNode().default)(node.left,k,v,node.right,node == null ? 0 : node._height);
		} else if(c < 0) {
			var nl = this.setLoop(k,v,node.left);
			return this.balance(nl,node.key,node.value,node.right);
		} else {
			var nr = this.setLoop(k,v,node.right);
			return this.balance(node.left,node.key,node.value,nr);
		}
	},
	removeLoop: function(k,node) {
		if(node == null) {
			throw new (js__$Boot_HaxeError().default)("Not_found");
		}
		var c = this.compare(k,node.key);
		if(c == 0) {
			return this.merge(node.left,node.right);
		} else if(c < 0) {
			return this.balance(this.removeLoop(k,node.left),node.key,node.value,node.right);
		} else {
			return this.balance(node.left,node.key,node.value,this.removeLoop(k,node.right));
		}
	},
	iteratorLoop: function(node,acc) {
		if(node != null) {
			this.iteratorLoop(node.left,acc);
			acc.push(node.value);
			this.iteratorLoop(node.right,acc);
		}
	},
	keysLoop: function(node,acc) {
		if(node != null) {
			this.keysLoop(node.left,acc);
			acc.push(node.key);
			this.keysLoop(node.right,acc);
		}
	},
	merge: function(t1,t2) {
		if(t1 == null) {
			return t2;
		}
		if(t2 == null) {
			return t1;
		}
		var t = this.minBinding(t2);
		return this.balance(t1,t.key,t.value,this.removeMinBinding(t2));
	},
	minBinding: function(t) {
		if(t == null) {
			throw new (js__$Boot_HaxeError().default)("Not_found");
		} else if(t.left == null) {
			return t;
		} else {
			return this.minBinding(t.left);
		}
	},
	removeMinBinding: function(t) {
		if(t.left == null) {
			return t.right;
		} else {
			return this.balance(this.removeMinBinding(t.left),t.key,t.value,t.right);
		}
	},
	balance: function(l,k,v,r) {
		var hl = l == null ? 0 : l._height;
		var hr = r == null ? 0 : r._height;
		if(hl > hr + 2) {
			var _this = l.left;
			var _this1 = l.right;
			if((_this == null ? 0 : _this._height) >= (_this1 == null ? 0 : _this1._height)) {
				return new (haxe_ds_TreeNode().default)(l.left,l.key,l.value,new (haxe_ds_TreeNode().default)(l.right,k,v,r));
			} else {
				return new (haxe_ds_TreeNode().default)(new (haxe_ds_TreeNode().default)(l.left,l.key,l.value,l.right.left),l.right.key,l.right.value,new (haxe_ds_TreeNode().default)(l.right.right,k,v,r));
			}
		} else if(hr > hl + 2) {
			var _this2 = r.right;
			var _this3 = r.left;
			if((_this2 == null ? 0 : _this2._height) > (_this3 == null ? 0 : _this3._height)) {
				return new (haxe_ds_TreeNode().default)(new (haxe_ds_TreeNode().default)(l,k,v,r.left),r.key,r.value,r.right);
			} else {
				return new (haxe_ds_TreeNode().default)(new (haxe_ds_TreeNode().default)(l,k,v,r.left.left),r.left.key,r.left.value,new (haxe_ds_TreeNode().default)(r.left.right,r.key,r.value,r.right));
			}
		} else {
			return new (haxe_ds_TreeNode().default)(l,k,v,r,(hl > hr ? hl : hr) + 1);
		}
	},
	compare: function(k1,k2) {
		return (Reflect().default).compare(k1,k2);
	}
};
BalancedTree.prototype.__class__ = BalancedTree.prototype.constructor = $hxClasses["haxe.ds.BalancedTree"] = BalancedTree;

// Init



// Statics




// Export

exports.default = BalancedTree;