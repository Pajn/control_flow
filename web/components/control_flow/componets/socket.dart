part of raxa;

const colors = const {
  bool: 'red',
  num: 'cornflowerblue',
  dynamic: 'white',
};

class SocketComponent extends SvgComponent<Socket> {
  final String tag = 'circle';
  static Connection draggingConnection;

  var attrs;

  Node get node => data.node;
  Type get type => data.valueType;
  SocketType get socketType => data.socketType;

  init() {
    attrs = {'stroke': colors[type], 'fill': 'black', 'r': '5', 'stroke-width': '2'};

    addSubscription(element.onMouseDown.listen((e) {
      e.stopPropagation();

      Rectangle bb = element.getBoundingClientRect();
      draggingConnection = new Connection()
        ..start = bb.topLeft + new Point(5, 5)
        ..end = bb.topLeft + new Point(5, 5)
        ..type = type
        ..startSocket = data;

      dispatcher.add(new StartCreateConnectionEvent(draggingConnection));
    }));

    addSubscription(element.onMouseUp.listen((e) {
      e.stopPropagation();

      Rectangle bb = element.getBoundingClientRect();
      draggingConnection
        ..end = bb.topLeft + new Point(5, 5);
      dispatcher.add(new StopCreateConnectionEvent(draggingConnection, created: true));
    }));

    addSubscription(dispatcher.stream.listen((e) {
      if (e is StartCreateConnectionEvent) {
        print('start');
        invalidate();
      } else if (e is StopCreateConnectionEvent) {
        print('end');
        draggingConnection = null;
        invalidate();
      }
    }));
  }


  updateView() {
    if (draggingConnection != null && (
        draggingConnection.type != type ||
        draggingConnection.startSocket.socketType == socketType ||
        draggingConnection.startSocket.node == node
    )) {
      return null;
    };

    updateRoot(circle(type: 'socket', attrs: attrs));
  }

}

socketComponent(Socket socket) => vComponent(() => new SocketComponent(), data: socket);
