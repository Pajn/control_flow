part of raxa;

class NodeComponent extends SvgComponent<Node> {
  final String tag = 'g';
  var _oldNode;
  var _oldWidth;

  get x => data.position.x;
  get y => data.position.y;
  get width {
    if (_oldNode == data) return _oldWidth;
    int width = math.max(data.nodeClass.name.length * 8 + 20, 70);
    var inputs = data.inputs.keys.toList();
    var outputs = data.outputs.keys.toList();

    for (int i = 0; i < math.max(inputs.length, outputs.length); i++) {
      var row = (inputs.length > i ? inputs[i] : '') +
                (outputs.length > i ? outputs[i] : '');

      width = math.max(width, row.length * 8 + 60);
    }

    _oldNode = data;
    _oldWidth = width;
    return width;
  }
  get height => (math.max(data.inputs.length, data.outputs.length) * 25 + 10).toString();

  init() {
    addSubscription(element.onMouseDown.listen((e) {
      e.stopImmediatePropagation();
      dispatcher.add(new StartDragNodeEvent(e.page, data));
    }));
  }

  updateView() {
    if (x == null || y == null) return null;

    var children = [
      rect(attrs: {'x': '0', 'y': '0', 'width': '$width', 'height': '30', 'fill': 'rgba(50, 250, 50, .9)'}),
      rect(attrs: {'x': '0', 'y': '30', 'width': '$width', 'height': height, 'fill': 'rgba(50, 50, 50, .7)'}),
      text(attrs: const {'x': '5', 'y': '20', 'fill': 'white'})(data.nodeClass.name),
    ];

    var tmpY = 45;
    data.inputs.forEach((name, type) {
      children.add(g(attrs: {'transform': 'translate(10, $tmpY)'})([
        socketComponent(new Socket(type, SocketType.input, data)),
        text(attrs: const {'x': '15', 'y': '5', 'r': '5', 'fill': 'white'})(name),
      ]));
      tmpY += 25;
    });

    tmpY = 45;
    data.outputs.forEach((name, type) {
      children.add(g(attrs: {'transform': 'translate(${width - 10}, $tmpY)'})([
        socketComponent(new Socket(type, SocketType.output, data)),
        text(attrs: const {'x': '75', 'y': '5', 'r': '5', 'fill': 'white', 'textAnchor': 'end'})(name),
      ]));
      tmpY += 25;
    });

    updateRoot(g(type: 'node', attrs: {'transform': 'translate($x, $y)'})(children));
  }
}

nodeComponent(Node node, {bool creating: false}) => vComponent(() => new NodeComponent(), data: node);
