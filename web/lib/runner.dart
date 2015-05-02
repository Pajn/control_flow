part of raxa;

getValue(Node node, String getter, [List<Node> _visitedNodes]) {
  if (_visitedNodes == null) {
    _visitedNodes = [node];
  } else if (_visitedNodes.contains(node)) {
    return 'Circular';
  } else {
    // TODO: Fix circular check, visiting the same node twice is perfectly valid
//    _visitedNodes.add(node);
  }

  var inputs = {};
  var properties = {};

  for (var socket in node.inputs) {
    try {
      var startSocket = socket.connection.startSocket;
      inputs[socket.name] = getValue(startSocket.node, startSocket.name, _visitedNodes);
    } on NoSuchMethodError catch(e) {
      inputs[socket.name] = null;
    }
  }

  for (var property in node.properties) {
    properties[property.name] = property.value;
  }

  try {
    return node.nodeClass.getters[getter](inputs, properties);
  } catch(e) {
    print(e);
    return 'Error';
  }
}
