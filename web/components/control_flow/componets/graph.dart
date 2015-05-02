part of raxa;

class GraphComponent extends Component {
  StartDragNodeEvent draggingNode;
  ConnectionComponent draggingConnection;

  var menuData = new MenuData();
  var offset;
  var selectedNode;

  init() {
    addSubscription(element.onClick.matches('#background').listen((MouseEvent e) {
      dispatcher.add(new SelectNodeEvent(null));
      menuData..position = e.page
        ..open = true;
      invalidate();
    }));

    addSubscription(element.onMouseMove.listen((e) {
      if (draggingNode != null) {
        draggingNode.node.position = e.page - offset - draggingNode.offset;
        draggingNode.nodeComponent.invalidate();
        invalidate();
      } else if (draggingConnection != null) {
        if (draggingConnection.connection.startSocket.socketType == SocketType.output) {
          draggingConnection.connection.end = e.page - offset;
        } else {
          draggingConnection.connection.start = e.page - offset;
        }
        draggingConnection.invalidate();
      }
    }));

    addSubscription(element.onMouseUp.listen((e) {
      if (draggingNode != null) {
        draggingNode.node.position = e.page - offset - draggingNode.offset;
        dispatcher.add(new StopDragNodeEvent(draggingNode.nodeComponent));
        draggingNode.nodeComponent.dragging = false;
        draggingNode.nodeComponent.invalidate();
        draggingNode = null;
      } else if (draggingConnection != null) {
        createdConnections.remove(draggingConnection);
        dispatcher.add(new StopCreateConnectionEvent(draggingConnection));
        invalidate();
      }
    }));

    addSubscription(dispatcher.stream.listen((e) {
      if (e is SelectNodeEvent) {
        selectedNode = e.nodeComponent;
      } else if (e is StartDragNodeEvent) {
        dispatcher.add(new SelectNodeEvent(e.nodeComponent));
        createdNodes.remove(e.nodeComponent);
        createdNodes.add(e.nodeComponent);
        draggingNode = e;
        invalidate();
      } else if (e is StartCreateConnectionEvent) {
        createdConnections.add(e.connection);
        draggingConnection = e.connection;
        invalidate();
      } else if (e is StopCreateConnectionEvent) {
        draggingConnection.invalidate();
        draggingConnection = null;
      }
    }));
  }

  updateView() {
    var nodesToDraw = createdNodes.map(nodeComponent).toList()
      ..addAll(createdConnections.map(connectionComponent));
    var selections = const [];

    if (selectedNode != null) {
      selections = [vComponent(selectedComponent, data: selectedNode.position)];
    }

    updateRoot(vRoot(style: const {'display': 'flex', 'flex-direction': 'column'})([
      vSvgElement('svg', type: 'graph', classes: const ['flex'])([
        vSvgElement('defs')([
          vSvgElement('pattern', attrs: const {'id': 'grid', 'width': '100', 'height': '100', 'patternUnits': 'userSpaceOnUse'})([
            rect(attrs: const {'x': '0', 'y': '0', 'width': '100', 'height': '100', 'fill': '#444'}),
            path(attrs: const {'d': 'M 100 0 L 100 100', 'stroke': 'rgba(165, 165, 50, .6)'}),
            path(attrs: const {'d': 'M 0 100 L 100 100', 'stroke': 'rgba(165, 165, 50, .6)'}),
            path(attrs: const {'d': 'M 50 0 L 50 100', 'stroke': 'rgba(165, 165, 50, .3)'}),
            path(attrs: const {'d': 'M 0 50 L 100 50', 'stroke': 'rgba(165, 165, 50, .3)'}),
          ]),
        ]),
        rect(attrs: const {
          'id': 'background', 'x': '0', 'y': '0', 'width': '100%', 'height': '100%', 'fill': 'url(#grid)',
        }),
        g()(selections),
        g()(nodesToDraw),
      ]),
      vComponent(menu(
          []..addAll(comparisonNodes)..addAll(mathNodes)..addAll(logicNodes)..addAll(otherNodes)),
          data: menuData
      ),
    ]));
  }

  updated() {
    if (offset == null) {
      offset = element.querySelector('svg').getBoundingClientRect().topLeft;
    }
  }
}

var graphComponent = () => new GraphComponent();
