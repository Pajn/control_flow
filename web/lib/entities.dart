part of raxa;

typedef Getter(Map<String, dynamic> inputs, Map<String, dynamic> properties);

class NodeClass {
  final String name;
  final Map<String, Type> inputs;
  final Map<String, Type> outputs;
  final Map<String, Type> properties;
  final Map<String, Getter> getters;

  const NodeClass(this.name, {
    this.inputs: const {},
    this.outputs: const {},
    this.properties: const {},
    this.getters: const {}
  });
}

class Node {
  final NodeClass nodeClass;
  final List<InputSocket> inputs = [];
  final List<Socket> outputs = [];
  final List<Property> properties = [];
  Point position;
  int id;

  Node(this.nodeClass) {
    nodeClass.inputs.forEach((name, type) {
      inputs.add(new InputSocket(type, SocketType.input, this, name));
    });
    nodeClass.outputs.forEach((name, type) {
      outputs.add(new Socket(type, SocketType.output, this, name));
    });
    nodeClass.properties.forEach((name, type) => properties.add(new Property(name, type)));
  }
}

class Property {
  final String name;
  final Type type;
  var value;

  Property(this.name, this.type);

  setValue(newValue) {
    if (newValue is String && type != String) {
      if (type == num) {
        return value = num.parse(newValue);
      }
    }

    value = newValue;
  }
}

enum SocketType {input, output}

class Socket {
  final Type valueType;
  final SocketType socketType;
  final Node node;
  final String name;

  Socket(this.valueType, this.socketType, this.node, this.name);
}

class InputSocket extends Socket {
  Connection connection;

  InputSocket(Type valueType, SocketType socketType, Node node, String name) :
    super(valueType, socketType, node, name);
}

class Connection {
  int id;
  Point start, end;
  Type type;
  Socket startSocket;
  InputSocket endSocket;
}

var comparisonNodes = [
  new NodeClass(
      'Less Than',
      inputs: {'a': num, 'b': num},
      outputs: {'': bool},
      getters: {'': (inputs, properties) => inputs['a'] < inputs['b']}
  ),
  new NodeClass(
      'Less Than or Equal To',
      inputs: {'a': num, 'b': num},
      outputs: {'': bool},
      getters: {'': (inputs, properties) => inputs['a'] <= inputs['b']}
  ),
  new NodeClass(
      'Greater Than',
      inputs: {'a': num, 'b': num},
      outputs: {'': bool},
      getters: {'': (inputs, properties) => inputs['a'] > inputs['b']}
  ),
  new NodeClass(
      'Greater Than or Equal To',
      inputs: {'a': num, 'b': num},
      outputs: {'': bool},
      getters: {'': (inputs, properties) => inputs['a'] >= inputs['b']}
  ),
  new NodeClass(
      'Equal To',
      inputs: {'a': dynamic, 'b': dynamic},
      outputs: {'': bool},
      getters: {'': (inputs, properties) => inputs['a'] == inputs['b']}
  ),
  new NodeClass(
      'Not Equal To',
      inputs: {'a': dynamic, 'b': dynamic},
      outputs: {'': bool},
      getters: {'': (inputs, properties) => inputs['a'] != inputs['b']}
  ),
];

var mathNodes = [
  new NodeClass(
      '+',
      inputs: {'a': num, 'b': num},
      outputs: {'': num},
      getters: {'': (inputs, properties) => inputs['a'] + inputs['b']}
  ),
  new NodeClass(
      '-',
      inputs: {'a': num, 'b': num},
      outputs: {'': num},
      getters: {'': (inputs, properties) => inputs['a'] - inputs['b']}
  ),
  new NodeClass(
      '*',
      inputs: {'a': num, 'b': num},
      outputs: {'': num},
      getters: {'': (inputs, properties) => inputs['a'] * inputs['b']}
  ),
  new NodeClass(
      '/',
      inputs: {'a': num, 'b': num},
      outputs: {'': num},
      getters: {'': (inputs, properties) => inputs['a'] / inputs['b']}
  ),

  new NodeClass(
      'Max',
      inputs: {'a': num, 'b': num},
      outputs: {'': num},
      getters: {'': (inputs, properties) => math.max(inputs['a'], inputs['b'])}
  ),
  new NodeClass(
      'Min',
      inputs: {'a': num, 'b': num},
      outputs: {'': num},
      getters: {'': (inputs, properties) => math.min(inputs['a'], inputs['b'])}
  ),

  new NodeClass(
      'Square root',
      inputs: {'': num},
      outputs: {'': num},
      getters: {'': (inputs, properties) => math.sqrt(inputs[''])}
  ),
  new NodeClass(
      'Power',
      inputs: {'': num, 'exponent': num},
      outputs: {'': num},
      getters: {'': (inputs, properties) => math.pow(inputs[''], inputs['exponent'])}
  ),
];

var logicNodes = [
  new NodeClass(
      'And',
      inputs: {'a': bool, 'b': bool},
      outputs: {'': bool},
      getters: {'': (inputs, properties) => inputs['a'] && inputs['b']}
  ),
  new NodeClass(
      'Or',
      inputs: {'a': bool, 'b': bool},
      outputs: {'': bool},
      getters: {'': (inputs, properties) => inputs['a'] || inputs['b']}
  ),
  new NodeClass(
      'Not',
      inputs: {'': bool},
      outputs: {'': bool},
      getters: {'': (inputs, properties) => !inputs['']}
  ),
];

var otherNodes = [
  new NodeClass(
      'Constant String',
      outputs: {'': String},
      properties: {'value': String},
      getters: {'': (inputs, properties) => properties['value']}
  ),
  new NodeClass(
      'Constant Number',
      outputs: {'': num},
      properties: {'value': num},
      getters: {'': (inputs, properties) => properties['value']}
  ),
];
