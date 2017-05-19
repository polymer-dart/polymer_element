@JS('Polymerize')
@HtmlImport('polymerize_js.html')
library polymerize.init;

import 'package:js/js.dart';
import 'package:js/js_util.dart' as u;
import 'package:polymerize_common/html_import.dart';
// ignore: UNUSED_IMPORT
import 'package:html5/html.dart';

@JS()
@anonymous
class ReduxInfo {
  external Function get reducer;

  external factory ReduxInfo({Function reducer});
}

@JS()
@anonymous
class Config {
  external get properties;
  external List<String> get actions;
  external List<String> get observers;
  external List<String> get reduxActions;
  external List<String> get behaviors;
  external ReduxInfo get reduxInfo;

  external factory Config({properties, List<String> actions, List<String> observers, List<String> reduxActions, List<String> behaviors, ReduxInfo reduxInfo});
}

@JS()
@anonymous
class Property {
  external bool get notify;
  external factory Property({bool notify});
}

@JS()
@anonymous
class ReduxProperty {
  external bool get notify;
  external String get statePath;
  external factory ReduxProperty({bool notify, String statePath});
}

@JS()
@anonymous
class Action {
  external factory Action();
}

@JS()
@anonymous
class Summary {
  external factory Summary();
}

@JS()
external register([Type type, String tag, Config config, Summary summary, bool native, String templateUrl]);

@JS()
external defineBehavior([String behaviorName, Type dartClass, Config config]);

summary() => new Summary();

//createMap(Map<String, dynamic> m) => m ; // u.jsify(m);
/*{

  var o = u.newObject();
  m.forEach((k, v) => u.setProperty(o, k, v));
  return o;
}*/