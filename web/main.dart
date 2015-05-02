library raxa;

import 'dart:async';
import 'dart:html';
import 'dart:math' as math;

import 'package:uix/uix.dart';

part 'components/control_flow/control_flow.dart';
part 'components/control_flow/componets/connection.dart';
part 'components/control_flow/componets/menu.dart';
part 'components/control_flow/componets/node.dart';
part 'components/control_flow/componets/socket.dart';
part 'lib/entities.dart';
part 'lib/events.dart';

var circle, g, path, rect, text;

initHelpers() {
  createHelper(String tag) =>
      ({Object key, String type, Map<String, String> attrs, Map<String, String> style,
        List<String> classes, List<VNode> children, bool content: false}) =>
      vSvgElement(tag, key: key, type: type, attrs: attrs, style: style,
                       classes: classes, children: children, content: content);

  circle = createHelper('circle');
  g = createHelper('g');
  path = createHelper('path');
  rect = createHelper('rect');
  text = createHelper('text');
}

var dispatcher = new StreamController.broadcast();

main() {
  initHelpers();
  initUix();

  injectComponent(new ControlFlow(), querySelector('#content'));
}
