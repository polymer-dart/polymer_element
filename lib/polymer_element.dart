@JS('Polymer')
library polymer_element;

import 'package:html5/html.dart';
import 'dart:js';
import 'package:js/js.dart';
import 'package:js/js_util.dart';
export 'super.dart' show callSuper;
export 'package:polymer_element/annotations.dart';
import 'package:polymer_element/annotations.dart';
export 'package:js/js.dart';
export 'package:js/js_util.dart';

// ignore: UNUSED_IMPORT
import 'metadata_registry.dart';
import 'package:polymer_element/polymerize_js.dart';
export 'package:polymer_element/polymerize_js.dart';
import 'package:polymerize_common/init.dart';
export 'package:polymerize_common/init.dart';
export 'metadata_registry.dart';

const String POLYMER_VERSION = "v2.0.1";
const String WEB_COMPONENTS = "v1.0.1";

const _Undefined = const {};

class EventOptions {
  final bool bubbles;
  final bool cancelable;
  final bool composed;
  final HTMLElement node;

  const EventOptions({this.bubbles: true, this.cancelable: false, this.node, this.composed: true});
}

Event createCustomEvent(String type, [detail, EventOptions opt = const EventOptions()]) {
  Event ev = new CustomEvent(
      type,
      new CustomEventInit()
        ..bubbles = opt.bubbles
        ..cancelable = opt.cancelable
        ..composed = opt.composed
        ..detail = detail);
  return ev;
}

@JS('DomRepeat')
@BowerImport(ref: POLYMER_VERSION, import: 'polymer/lib/elements/dom-repeat.html', name: 'polymer')
@PolymerRegister('dom-repeat', native: true)
abstract class DomRepeat implements PolymerElement {
  external itemForElement(el);
  external indexForElement(el);
}

@JS('DomIf')
@BowerImport(ref: POLYMER_VERSION, import: 'polymer/lib/elements/dom-if.html', name: 'polymer')
@PolymerRegister('dom-if', native: true)
abstract class DomIf implements PolymerElement {}

@JS('Templatizer')
@BowerImport(ref: POLYMER_VERSION, import: 'polymer/lib/legacy/templatizer-behavior.html', name: 'polymer')
abstract class Templatizer {
  external static flush();
  external PolymerElement templatize(HTMLTemplateElement template, options);
  external modelForElement(el);
}

@JS('PropertyEffects')
@BowerImport(ref: POLYMER_VERSION, import: 'polymer/lib/mixins/property-effects.html', name: 'polymer')
abstract class PropertyEffects {
  external notifyPath(String path, [val = _Undefined]);

  external push(String path, item);

  external pop(String path);

  external shift(String path, vals);

  external unshift(String path, item);

  external get(String path, [root]);

  external set(String path, value, [root]);

  external linkPaths(String from, String to);

  external unlinkPaths(String to);

  external notifySplice(String path, splices);
}

@JS('TemplateInstanceBase')
abstract class TemplateInstanceBase implements PropertyEffects {
  external forwardHostProp(prop, value);
  external get parentModel;
}

typedef void forwardHostPropCallback(property, value);
typedef void notifyInstancePropCallback(instance, property, value);

@JS()
@anonymous
class TemplatizeOptions {
  external bool get mutableData;
  external get parentModel;
  external get instanceProps;
  external forwardHostPropCallback get forwardHostProp;
  external notifyInstancePropCallback get notifyInstanceProp;

  external void set mutableData(bool v);
  external void set parentModel(v);
  external void set instanceProps(v);
  external void set forwardHostProp(forwardHostPropCallback v);
  external void set notifyInstanceProp(notifyInstancePropCallback v);
  external factory TemplatizeOptions({bool mutableData,parentModel,instanceProps,forwardHostPropCallback forwardHostProp,notifyInstancePropCallback notifyInstanceProp});
}

@JS()
@anonymous
@BowerImport(ref: POLYMER_VERSION, import: 'polymer/lib/utils/templatize.html', name: 'polymer')
abstract class TemplatizeModule {
  /**
   * Return the template constructor.
   */
  external templatize(HTMLTemplateElement template, owner, [TemplatizeOptions options]);
  external modelForElement(host, Element element);
}

@JS()
@anonymous
abstract class TemplateInstance implements PropertyEffects {
  external List<Node> get children;
  external DocumentFragment get root;
}

// Stamp a templatizer class producing the stamped template
TemplateInstance stamp(templateClass, [List model]) => callConstructor(templateClass, model);

@JS('Templatize')
external TemplatizeModule get Templatize;

/**
 * Polymer hybrid behavior in order to mark the element
 * as a mutable data.
 */
@JS('MutableDataBehavior')
@BowerImport(ref: POLYMER_VERSION, import: 'polymer/lib/legacy/mutable-data-behavior.html', name: 'polymer')
abstract class MutableDataBehavior {}

@JS('OptionalMutableDataBehavior')
@BowerImport(ref: POLYMER_VERSION, import: 'polymer/lib/legacy/mutable-data-behavior.html', name: 'polymer')
abstract class OptionalMutableDataBehavior {}

@JS('MutableData')
@BowerImport(ref: POLYMER_VERSION, import: 'polymer/lib/mixins/mutable-data.html', name: 'polymer')
abstract class MutableData {}

@JS('OptionalMutableData')
@BowerImport(ref: POLYMER_VERSION, import: 'polymer/lib/mixins/mutable-data.html', name: 'polymer')
abstract class OptionalMutableData {}

@JS('ElementMixin')
@BowerImport(ref: POLYMER_VERSION, import: "polymer/lib/mixins/element-mixin.html", name: 'polymer')
abstract class ElementMixin implements PropertyEffects {
  external get $;

  external $$(String selector);
}

@JS('Element')
@BowerImport(ref: POLYMER_VERSION, import: "polymer/polymer.html", name: 'polymer')
abstract class PolymerElement implements HTMLElement, ElementMixin {
  external get $;

  external $$(String selector);

  external ready();

  external connectedCallback();

  external disconnectedCallback();

  external attributeChangedCallback(name, old, value);
}

/**
 * Unfortunately JS-INTEROP doesn't allows for varargs or
 * more complex method mapping, so we have to provide those
 * ugly static utility methods.
 */
class PropertyEffectsUtils {
  static splice(PropertyEffects el, String path, int index, int howmany, List items) => callMethod(el as dynamic, 'splice', [path, index, howmany]..addAll(items));
  static unshift(PropertyEffects el, String path, [items]) => callMethod(el as dynamic, 'unshift', [path]..addAll(items));

  static push(PropertyEffects el, String path, [items]) => callMethod(el as dynamic, 'push', [path]..addAll(items));
}
