@JS()
@HtmlImport('observe_support.html')
library observe;

import 'dart:async';
import 'package:html5/html.dart';
import 'package:polymer_element/dart_callbacks_behavior.dart';
import 'package:polymer_element/property_observer_behavior.dart';
import 'package:polymerize_common/init.dart';
import 'package:polymer_element/polymer_element.dart';
import 'package:polymer_element/require.dart';
import 'package:js/js.dart';
import 'package:js/js_util.dart';
import 'package:polymerize_common/html_import.dart';

@JS()
@anonymous
class _Support {
  external makeObservable(obj, observer callback, callbackFactory factory);
  external cancelObserver(obj, observer callback, callbackFactory factory);
  external List<String> findProps(obj);
}

typedef CallbackFactoryResult callbackFactory(String property, value);

@JS()
@anonymous
class CallbackFactoryResult {
  external observer get callback;
  external callbackFactory get factory;
  external factory CallbackFactoryResult({observer callback, callbackFactory factory});
}

typedef observer(String propertyName, oldValue, newValue);

class ObserveSupport {
  var _observe_support;

  ObserveSupport._(this._observe_support);

  static ObserveSupport _loaded;

  static Future<ObserveSupport> load() async =>
      _loaded ??
      await requireOne('polymer_element/observe_support').then((_observe_support) {
        _loaded = new ObserveSupport._(_observe_support);
        return _loaded;
      });

  /***
   * Makes an observable version of "obj". When properties are changed
   * the callback is called.
   *
   * Calling it on an already observable object returns the same object but
   * adds a listener.
   */
  X makeObservable<X>(X obj, {observer callback, callbackFactory factory}) => _observe_support.makeObservable(obj, callback, factory);

  cancelObserver(obj, observer callback, [callbackFactory factory]) => _observe_support.cancelObserver(obj, callback, factory);

  List<String> findProps(obj) => _observe_support.findProps(obj);
}

ObserveSupport observeSupport;

@init
preloadObserveSupport() {
  ObserveSupport.load().then((x) {
    observeSupport = x;
  });
}

@JS('Object')
external _JSObject get JSObject;

@JS()
@anonymous
class _JSObject {
  external List<String> keys(obj);
}

@PolymerBehavior('Polymerize.AutonotifyBehavior')
abstract class AutonotifyBehavior implements DartCallbacksBehavior, PropertyObserverBehavior {
  //PropertyChangeHandler _rootHandler;
  //Set<String> _topLevelProps;
  Notifier _mainNotifier;
  void readyPreHook() {
    _mainNotifier = new Notifier(this, "", (prop) => onNotify(prop));
  }

  void onPropertiesChangedPreHook(data, changedProps, oldData) {
    JSObject.keys(changedProps).forEach((propName) {
      var oldv = getProperty(oldData, propName);
      var newv = getProperty(data, propName);

      if (oldv != newv) {
        _mainNotifier.install(propName, oldv, newv);
      }
    });
  }

  void onNotify(String propName) {
    // Filter on top level listened props

    (this as PolymerElement).notifyPath(propName);
  }
}

typedef void Notify(String path);

class Notifier {
  String _path;
  Notify _notify;
  var _obj;
  observer _callback;
  callbackFactory _factory;

  Notifier(this._obj, this._path, this._notify) {
    _callback = (String propName, oldv, newv) {
      _notify("${_path}${propName}");
    };

    _factory = (String property, value) => new Notifier(null, "${_path}${property}.", _notify)._asResult();

  }

  CallbackFactoryResult _asResult() => new CallbackFactoryResult(callback: _callback,factory: _factory);

  void uninstall(String propName, oldv) {
    if (oldv != null) {
      var pxy = observeSupport.makeObservable(oldv);
      CallbackFactoryResult res = _topLevel.remove(propName);
      if (pxy != null && res != null) {
        observeSupport.cancelObserver(pxy, res.callback, res.factory);
      }
    }
  }

  Map<String, CallbackFactoryResult> _topLevel = {};

  void install(String propName, oldv, newv) {
    uninstall(propName, oldv);
    var p = newv;
    if (newv != null) {
      p = observeSupport.makeObservable(newv);
      if (p != null) {
        CallbackFactoryResult res = _factory(propName, newv);
        _topLevel[propName] = res;
        observeSupport.makeObservable(newv, callback: res.callback, factory: res.factory);

        // When new replace (autoinstall option)
        if (p != newv) {
          new Future(() => setProperty(_obj, propName, p));
        }
      }
    }

    // NOTE : there's no need to notify first level props...
    //_callback(propName);
  }
}

toObservable(obj) => observeSupport.makeObservable(obj);
