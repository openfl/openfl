package;

import haxe.ds.Option;
import haxe.macro.JSGenApi;
import haxe.macro.Type;
import genjs.processor.*;
import genjs.generator.*;

#if tink_macro
using tink.MacroApi;
#end
using haxe.io.Path;
using StringTools;
using genjs.template.CodeTools;


class CustomClassGenerator implements IClassGenerator {
	public function new() {}

	public function generate(api:JSGenApi, c:ProcessedClass) {

		function superClassName(c:ClassType) 
			return switch c.superClass {
				case null: null;
				case {t: sc}:
					var sc = ClassProcessor.process(api, sc.toString(), sc.get());
					return sc.id.asAccessName(sc.externType);
			}		
		
		if(c.type.isExtern)
			return None;
		
		var filepath = c.id.asFilePath() + '.js';
		var name = c.type.name;
		
		var data = {};
		Reflect.setField(data, 'className', name);
		Reflect.setField(data, c.id.asTemplateHolder(), name);
		for(dependency in c.dependencies) switch dependency {
			case DType(TypeProcessor.process(api, _) => Some(PClass(c))):
				Reflect.setField(data, c.id.asTemplateHolder(), c.id.asAccessName(c.externType));
			
			case DType(TypeProcessor.process(api, _) => Some(PEnum(e))): 
				Reflect.setField(data, e.id.asTemplateHolder(), e.id.asAccessName());
				
			default:
		}
		// HACK: Runtime type values from Std
		Reflect.setField(data, 'Date', 'Date');
		Reflect.setField(data, 'Int', '$$hxClasses["Int"]');
		Reflect.setField(data, 'Dynamic', '$$hxClasses["Dynamic"]');
		Reflect.setField(data, 'Float', '$$hxClasses["Float"]');
		Reflect.setField(data, 'Bool', '$$hxClasses["Bool"]');
		Reflect.setField(data, 'Class', '$$hxClasses["Class"]');
		Reflect.setField(data, 'Enum', '$$hxClasses["Enum"]');
		Reflect.setField(data, 'Void', '$$hxClasses["Void"]');
		
		var requireStatements = new RequireGenerator().generate(api, filepath.directory(), c.dependencies);
		
		var ctor = 'var $name = ' + switch c.constructor {
			case null | {template: null}: 'function(){}';
			case {template: template}: template.execute(data);
		}
		#if (js_es==6)
			switch ctor.indexOf('function(') {
				case -1: throw 'assert';
				case v: //DO NOT DO THIS AT HOME!!!!
					ctor = {
						var ctor = 'constructor' + ctor.substr(v + 'function'.length);
						var cls = 
							'class $name ' + switch superClassName(c.type) {
								case null: '{\n${ctor.indent(1)}';
								case v: 
									var superCall = '$v.call(this';
									switch ctor.indexOf(superCall) {
										case -1: 
											if (c.constructor == null)
												ctor = '';
											else {
												if (c.type.superClass.t.get().constructor == null) {
													switch ctor.indexOf('{') {
														case -1: throw 'assert';
														case v: 
															ctor = [
																ctor.substr(0, v+1),
																"super()".indent(1),
																ctor.substr(v + 1),
															].join('\n');
													}
												}
												else
													c.constructor.field.pos.error('Could not find super call'); 
											}
										case v:
										    var pretext = ctor.substr(0, v);
											if (~/this[^a-zA-Z0-9_\$]/.match(pretext)) 
												c.constructor.field.pos.warning('cannot access `this` before calling `super`');
									}
									ctor = 
										ctor
											.replace('$v.call(this,', 'super(')
											.replace('$v.call(this', 'super(');
									'extends $v {\n${ctor.indent(1)}';
							}
						cls + '\n';
					}
		  	}
		#end
		// Fields
		#if (js_es >= 6) 
			var statics = [];
			ctor += [for (f in c.fields) 
				if (f.template != null)
					switch f.template.execute(data) {
						case method if (method.startsWith('function(')):
							(if (f.isStatic) 'static ' else '') 
							+ f.field.name 
							+ method.substr('function'.length);
						case v:
							if (f.isStatic) {
								var name = f.field.name;
								statics.push('var $name = $v;');
								[
									'static get $name() { return $name; }',
									'static set $name(value) { $name = value; }',
								].join('\n');
							} 
							else f.field.pos.error('field impossible to generate on ES6');
							//c.type.pos.warning(v);
							//v;
					}
			].join('\n').indent(1) + '\n}\n';
			var statics = statics.join('\n');
		#else 
			var fields = [];
			for(field in c.fields.filter(function(f) return !f.isStatic)) {
				switch new FieldGenerator().generate(api, field, data) {
					case Some(v): fields.push(v);
					case None:
				}
			}		
			var fields = '{\n' + fields.join(',\n').indent(1) + '\n}';
			// Statics
			var staticFunctions = [];
			var staticVariables = [];
			for(field in c.fields.filter(function(f) return f.isStatic)) {
				switch new FieldGenerator().generate(api, field, data) {
					case Some(v): (field.isFunction ? staticFunctions : staticVariables).push(v);
					case None:
				}
			}
			
			var statics = staticFunctions.join('\n') + '\n' + staticVariables.join('\n');
		#end
		// Meta
		var cname = c.id.split('.').map(api.quoteString).join(',');
		var meta = ['$name.__name__ = [$cname];'];
		
		switch c.type.interfaces {
			case null | []: // do nothing;
			case v:
				var inames = [for(i in v) ClassProcessor.process(api, i.t.toString(), i.t.get()).id.asAccessName()];
				meta.push('$name.__interfaces__ = [${inames.join(',')}];');
		}
		
		#if (js_es < 6)
		switch superClassName(c.type) {
			case null:
				meta.push('$name.prototype = $fields;');
			case scname:
				meta.push('$name.__super__ = $scname;');
				meta.push('$name.prototype = $$extend($scname.prototype, $fields);');
		}
		#end
		meta.push('$name.prototype.__class__ = $$hxClasses["${c.id}"] = $name;');
		// __init__
		var init = 
			if(c.init != null) c.init.template.execute(data) + ';';
			else '';
		
		
		// var code = '';
		// for(field in c.fields) if(field.template != null) code += '\n' + field.template.execute({});
		// for(field in c.statics) if(field.template != null) code += '\n' + field.template.execute({});
		// if(code != '') {
		// 	trace(filepath);
		// 	trace(code);
		// }
		var re = ~/\/\/\/\s*#(if|endif)\s*(.*);\s*?(\r\n|\r|\n)/g;
		var metaContent = meta.join('\n');
		if (metaContent.indexOf('///') > -1) {
			// Purpose of this replace call is to remove the trailing semicolon 
			// from triple slash lines like: /// #if debug;
			metaContent = re.replace(metaContent, '/// #$1 $2$3');
		}
		if (init.indexOf('///') > -1) {
			init = re.replace(init, '/// #$1 $2$3');
		}
		if (ctor.indexOf('///') > -1) {
			ctor = re.replace(ctor, '/// #$1 $2$3');
		}
		if (statics.indexOf('///') > -1) {
			statics = re.replace(statics, '/// #$1 $2$3');
		}
		return Some([
			'// Class: ${c.id}',
			'var $$global = typeof window != "undefined" ? window : typeof global != "undefined" ? global : typeof self != "undefined" ? self : this',
			'$$global.Object.defineProperty(exports, "__esModule", {value: true});',
			'var __map_reserved = {};', // TODO: add only if needed
			'// Imports',
			requireStatements,
			'// Constructor',
			ctor,
			'// Meta',
			metaContent,
			'// Init',
			init,
			'// Statics',
			statics,
			'// Export',
			'exports.default = $name;',
		].join('\n\n'));
	}
}
