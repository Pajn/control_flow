part of raxa;

class NodeComponent extends SvgComponent<Node> {
  final String tag = 'g';
  bool dragging = false;
  Node node;
  var sockets = {};
  var _oldNode;
  var _oldWidth;

  get x => node.position.x;
  get y => node.position.y;
  get width {
    if (_oldNode == node) return _oldWidth;
    int width = math.max(node.nodeClass.name.length * 8 + 20, 70);
    var inputs = node.inputs;
    var outputs = node.outputs;

    for (int i = 0; i < math.max(inputs.length, outputs.length); i++) {
      var row = (inputs.length > i ? inputs[i].name : '') +
                (outputs.length > i ? outputs[i].name : '');

      width = math.max(width, row.length * 8 + 60);
    }

    _oldNode = node;
    _oldWidth = width;
    return width;
  }
  get height => (math.max(node.inputs.length, node.outputs.length) * 25 + 10).toString();

  NodeComponent(this.node);

  init() {
    for (var socket in node.inputs) {
      sockets[socket] = new SocketComponent(socket);
    }
    for (var socket in node.outputs) {
      sockets[socket] = new SocketComponent(socket);
    }

    addSubscription(element.onMouseDown.listen((e) {
      e.stopPropagation();

      dispatcher.add(new StartDragNodeEvent(e.page, this));
    }));

    addSubscription(dispatcher.stream.listen((e) {
      if (e is StopDragNodeEvent && e.nodeComponent == this) {
        updateSockets();
      }
    }));
  }

  updateSockets() {
    for (SocketComponent socket in sockets.values) {
      socket.updateConnection();
    }
  }

  updateView() {
    var children = [
      rect(attrs: {'x': '0', 'y': '0', 'width': '$width', 'height': '30', 'fill': dragging ? 'rgba(50, 250, 50, .5)' : 'rgba(50, 250, 50, .9)'}),
      rect(attrs: {'x': '0', 'y': '30', 'width': '$width', 'height': height, 'fill': dragging ? 'rgba(50, 50, 50, .5)' : 'rgba(50, 50, 50, .7)'}),
      text(attrs: const {'x': '5', 'y': '20', 'fill': 'white'})(node.nodeClass.name),
    ];

    var tmpY = 20;
    children.addAll(node.inputs.map((socket) {
      tmpY += 25;
      return g(attrs: {'transform': 'translate(10, $tmpY)'})([
        socketComponent(sockets[socket]),
        text(attrs: const {'x': '15', 'y': '5', 'r': '5', 'fill': 'white'}, key: socket.name)(socket.name),
      ]);
    }));

    tmpY = 20;
    children.addAll(node.outputs.map((socket) {
      tmpY += 25;
      return g(attrs: {'transform': 'translate(${width - 10}, $tmpY)'})([
        socketComponent(sockets[socket]),
        text(attrs: const {'x': '75', 'y': '5', 'r': '5', 'fill': 'white', 'textAnchor': 'end'}, key: socket.name)(socket.name),
      ]);
    }));

    updateRoot(g(attrs: {'transform': 'translate($x, $y)'})(children));
  }

  updated() {
    if (dragging) {
      updateSockets();
    }
  }
}

var nodeComponent = cachedComponent('node');
