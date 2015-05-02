part of raxa;

const colors = const {
  bool: 'red',
  num: 'cornflowerblue',
  String: 'gold',
  dynamic: 'white',
};

class SocketComponent extends SvgComponent {
  static ConnectionComponent draggingConnection;
  final String tag = 'g';
  final Socket socket;
  List<ConnectionComponent> connections = [];
  bool moved = false;

  var attrs;
  var offset;

  Node get node => socket.node;
  Type get type => socket.valueType;
  SocketType get socketType => socket.socketType;

  SocketComponent(this.socket);

  attached() {
    offset = element.ownerSvgElement.getBoundingClientRect().topLeft - new Point(5, 5);
  }

  init() {
    attrs = {'stroke': colors[type], 'fill': 'black', 'r': '5', 'stroke-width': '2'};

    addSubscription(element.onMouseDown.listen((e) {
      e.stopPropagation();

      Rectangle bb = element.getBoundingClientRect();
      draggingConnection = new ConnectionComponent(new Connection()
        ..start = bb.topLeft - offset
        ..end = bb.topLeft - offset
        ..type = type
        ..startSocket = socket
      );

      connections.add(draggingConnection);

      dispatcher.add(new StartCreateConnectionEvent(draggingConnection));
    }));

    addSubscription(element.onMouseUp.listen((e) {
      e.stopPropagation();

      if (socket.socketType == SocketType.input && connections.isNotEmpty) {
        for (var connection in connections) {
          dispatcher.add(new RemoveConnectionEvent(connection));
        }
      }

      if (draggingConnection.type == dynamic) {
        draggingConnection.connection.type = type;
      }

      Rectangle bb = element.getBoundingClientRect();
      if (socket.socketType == SocketType.output) {
        connections.add(
            draggingConnection
              ..connection.start = bb.topLeft - offset
        );
      } else {
        connections.add(
            draggingConnection
              ..connection.end = bb.topLeft - offset
        );
      }
      dispatcher.add(new StopCreateConnectionEvent(draggingConnection, created: true));
    }));

    addSubscription(dispatcher.stream.listen((e) {
      if (e is StartCreateConnectionEvent) {
        invalidate();
      } else if (e is StopCreateConnectionEvent) {
        draggingConnection = null;
        invalidate();
      } else if (e is RemoveConnectionEvent) {
        connections.remove(e.connection);
      }
    }));
  }

  updateConnections() {
    if (connections.isNotEmpty) {
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
      for (var connection in connections) {
        if (socketType == SocketType.output) {
          connection.connection.start = bb.topLeft - offset;
        } else {
          connection.connection.end = bb.topLeft - offset;
        }

        connection.invalidate();
      }
    }
  }
}

var socketComponent = cachedComponent('socket');
