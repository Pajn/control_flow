part of raxa;

getValue(Node node, String getter) {
  var inputs = {};
  var properties = {};

  for (var property in node.properties) {
    properties[property.name] = property.value;
  }

  try {
    return node.nodeClass.getters[getter](inputs, properties);
  } catch(_) {
    return 'Error';
  }
}
