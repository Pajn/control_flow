part of raxa;

getValue(Node node, String getter, [int _depth = 0]) {
  if (_depth > 50) {
    throw new StackOverflowError();
  }
  _depth++;

  var inputs = {};
  var properties = {};

  try {
    for (var socket in node.inputs) {
      try {
        var startSocket = socket.connection.startSocket;
        inputs[socket.name] = getValue(startSocket.node, startSocket.name, _depth);
      } on NoSuchMethodError catch(e) {
        inputs[socket.name] = null;
      }
    }
  } on StackOverflowError catch(e) {
    if (_depth == 1) {
      return 'To complex';
    } else rethrow;
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
