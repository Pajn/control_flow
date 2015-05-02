part of raxa;

const colors = const {
  bool: 'red',
  num: 'cornflowerblue',
  dynamic: 'white',
};

class SocketComponent extends SvgComponent {
  static ConnectionComponent draggingConnection;
  final String tag = 'g';
  final Socket socket;
  ConnectionComponent connection;
  bool moved = false;

  var attrs;

  Node get node => socket.node;
  Type get type => socket.valueType;
  SocketType get socketType => socket.socketType;

  SocketComponent(this.socket);

  init() {
    attrs = {'stroke': colors[type], 'fill': 'black', 'r': '5', 'stroke-width': '2'};

    addSubscription(element.onMouseDown.listen((e) {
      e.stopPropagation();

      Rectangle bb = element.getBoundingClientRect();
      draggingConnection = connection = new ConnectionComponent(new Connection()
        ..start = bb.topLeft + new Point(5, 5)
        ..end = bb.topLeft + new Point(5, 5)
        ..type = type
        ..startSocket = socket
      );

      dispatcher.add(new StartCreateConnectionEvent(connection));
    }));

    addSubscription(element.onMouseUp.listen((e) {
      e.stopPropagation();

      if (socket.socketType == SocketType.input && connection != null) {
        dispatcher.add(new RemoveConnectionEvent(connection));
      }

      Rectangle bb = element.getBoundingClientRect();
      if (socket.socketType == SocketType.output) {
        connection = draggingConnection
          ..connection.start = bb.topLeft + new Point(5, 5);
      } else {
        connection = draggingConnection
          ..connection.end = bb.topLeft + new Point(5, 5);
      }
      dispatcher.add(new StopCreateConnectionEvent(draggingConnection, created: true));
    }));

    addSubscription(dispatcher.stream.listen((e) {
      if (e is StartCreateConnectionEvent) {
        invalidate();
      } else if (e is StopCreateConnectionEvent) {
        draggingConnection = null;
        invalidate();
      }
    }));
  }

  updateConnection() {
    if (connection != null) {
      moved = true;
      invalidate();
    }
  }

  updateView() {
    if (draggingConnection != null && (
        (draggingConnection.type != type && (type != dynamic && draggingConnection.type != dynamic)) ||
        draggingConnection.connection.startSocket.socketType == socketType ||
        draggingConnection.connection.startSocket.node == node
    )) {
      return updateRoot(g());
    };

    updateRoot(g()(circle(attrs: attrs)));
  }

  updated() {
    if (moved) {
      moved = false;

      Rectangle bb = element.getBoundingClientRect();
      if (socketType == SocketType.output) {
        connection.connection.start = bb.topLeft + new Point(5, 5);
      } else {
        connection.connection.end = bb.topLeft + new Point(5, 5);
      }

      connection.invalidate();
    }
  }
}

var socketComponent = cachedComponent('socket');
