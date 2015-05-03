part of raxa;

class GraphComponent extends Component {
  StartDragNodeEvent draggingNode;
  ConnectionComponent draggingConnection;
  StartDragDisplayEvent draggingDisplay;

  var menuData = new MenuData();
  var offset;
  var selectedNode;
  var openDisplays = [];

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
        dispatcher.add(new NodeMovedEvent(draggingNode.nodeComponent));
        invalidate();
      } else if (draggingConnection != null) {
        if (draggingConnection.connection.startSocket.socketType == SocketType.output) {
          draggingConnection.connection.end = e.page - offset;
        } else {
          draggingConnection.connection.start = e.page - offset;
        }
        draggingConnection.invalidate();
      } else if (draggingDisplay != null) {
        draggingDisplay.display.position = e.page - offset - draggingDisplay.offset;
        invalidate();
      }
    }));

    addSubscription(element.onMouseUp.listen((e) {
      if (draggingNode != null) {
        draggingNode.node.position = e.page - offset - draggingNode.offset;
        dispatcher.add(new NodeMovedEvent(draggingNode.nodeComponent));
        dispatcher.add(new StopDragNodeEvent(draggingNode.nodeComponent));
        draggingNode = null;
      } else if (draggingConnection != null) {
        createdConnections.remove(draggingConnection);
        dispatcher.add(new StopCreateConnectionEvent(draggingConnection));
        invalidate();
      } else if (draggingDisplay != null) {
        draggingDisplay.display.position = e.page - offset - draggingDisplay.offset;
        draggingDisplay = null;
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
      } else if (e is OpenDisplayEvent) {
        openDisplays.add(e.display);
        dispatcher.add(new StartDragDisplayEvent(e.display));
        invalidate();
      } else if (e is StartDragDisplayEvent) {
        draggingDisplay = e;
      }
    }));
  }

  updateView() {
    var nodesToDraw = createdNodes.map(nodeComponent).toList()
      ..addAll(createdConnections.map(connectionComponent));
    var displaysToDraw = openDisplays.map((display) => vComponent(displayComponent, data: display, key: display.position));
    var selections = const [];

    if (selectedNode != null) {
      selections = [vComponent(selectedComponent, data: selectedNode)];
    }

    updateRoot(vRoot(style: const {'display': 'flex', 'flex-direction': 'column'})([
      vSvgElement('svg', type: 'graph', classes: const ['flex'])([
        vSvgElement('defs')([
          vSvgElement('pattern', attrs: const {'id': 'grid', 'width': '100', 'height': '100', 'patternUnits': 'userSpaceOnUse'})([
            rect(attrs: const {'x': '0', 'y': '0', 'width': '100', 'height': '100', 'fill': '#2B2B2B'}),
            path(attrs: const {'d': 'M 100 0 L 100 100', 'stroke': 'rgba(165, 165, 165, .6)'}),
            path(attrs: const {'d': 'M 0 100 L 100 100', 'stroke': 'rgba(165, 165, 165, .6)'}),
            path(attrs: const {'d': 'M 25 0 L 25 100', 'stroke': 'rgba(165, 165, 165, .2)'}),
            path(attrs: const {'d': 'M 50 0 L 50 100', 'stroke': 'rgba(165, 165, 165, .2)'}),
            path(attrs: const {'d': 'M 75 0 L 75 100', 'stroke': 'rgba(165, 165, 165, .2)'}),
            path(attrs: const {'d': 'M 0 25 L 100 25', 'stroke': 'rgba(165, 165, 165, .2)'}),
            path(attrs: const {'d': 'M 0 50 L 100 50', 'stroke': 'rgba(165, 165, 165, .2)'}),
            path(attrs: const {'d': 'M 0 75 L 100 75', 'stroke': 'rgba(165, 165, 165, .2)'}),
          ]),
        ]),
        rect(attrs: const {
          'id': 'background', 'x': '0', 'y': '0', 'width': '100%', 'height': '100%', 'fill': 'url(#grid)',
        }),
        g()(selections),
        g()(nodesToDraw),
        g()(displaysToDraw),
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
