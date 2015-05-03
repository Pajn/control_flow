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

  Point get center => element.getBoundingClientRect().topLeft - offset;

  SocketComponent(this.socket);

  attached() {
    SvgElement element = this.element;
    offset = element.ownerSvgElement.getBoundingClientRect().topLeft - const Point(5, 5);
  }

  init() {
    attrs = {'stroke': colors[type], 'fill': 'black', 'r': '5', 'stroke-width': '2'};

    addSubscription(element.onMouseDown.listen((e) {
      e.stopPropagation();

      if (e.ctrlKey) {
        dispatcher.add(new OpenDisplayEvent(
            new Display(this)
              ..socketPosition = center
              ..position = center
        ));
      } else {
        draggingConnection = new ConnectionComponent(
          new Connection()
            ..start = center
            ..end = center
            ..type = type
            ..startSocket = socket
        );

        if (socket.socketType == SocketType.input) {
          draggingConnection.connection.endSocket = socket;
        }

        connections.add(draggingConnection);

        dispatcher.add(new StartCreateConnectionEvent(draggingConnection));
      }
    }));

    addSubscription(element.onMouseUp.listen((e) {
      if (draggingConnection != null) {
        e.stopPropagation();

        if (socket.socketType == SocketType.input && connections.isNotEmpty) {
          for (var connection in connections) {
            dispatcher.add(new RemoveConnectionEvent(connection));
          }
        }

        if (draggingConnection.type == dynamic) {
          draggingConnection.connection.type = type;
        }

        if (socket.socketType == SocketType.output) {
          connections.add(
              draggingConnection
                ..connection.start = center
                ..connection.startSocket = socket
          );
        } else {
          connections.add(
              draggingConnection
                ..connection.end = center
                ..connection.endSocket = socket
          );
        }

        draggingConnection.connection.endSocket.connection = draggingConnection.connection;
        dispatcher.add(new StopCreateConnectionEvent(draggingConnection, created: true));
      }
    }));

    addSubscription(dispatcher.stream.listen((e) {
      if (e is StartCreateConnectionEvent) {
        invalidate();
      } else if (e is StopCreateConnectionEvent) {
        draggingConnection = null;
        invalidate();
      } else if (e is RemoveConnectionEvent) {
        connections.remove(e.connection);
      } else if (e is NodeMovedEvent && e.node == node) {
        moved = true;
        invalidate();
      }
    }));
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

      for (var connection in connections) {
        if (socketType == SocketType.output) {
          connection.connection.start = center;
        } else {
          connection.connection.end = center;
        }

        connection.invalidate();
      }
    }
  }
}

var socketComponent = cachedComponent('socket');
