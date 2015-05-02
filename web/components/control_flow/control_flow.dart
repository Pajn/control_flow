part of raxa;

var createdNodes = [];
var createdConnections = [];

class ControlFlow extends Component {
  StartDragNodeEvent draggingNode;
  Connection draggingConnection;

  var menuData = new MenuData();

  init() {
    addSubscription(element.onClick.listen((e) {
      menuData..position = e.page
              ..open = true;
      invalidate();
    }));

    addSubscription(element.onMouseMove.listen((e) {
      if (draggingNode != null) {
        draggingNode.node.position = e.page - draggingNode.offset;
        invalidate();
      } else if (draggingConnection != null) {
        draggingConnection.end = e.page;
        invalidate();
      }
    }));

    addSubscription(element.onMouseUp.listen((e) {
      if (draggingNode != null) {
        draggingNode.node.position = e.page - draggingNode.offset;
        dispatcher.add(new StopDragNodeEvent(draggingNode.node));
        draggingNode = null;
        invalidate();
      } else if (draggingConnection != null) {
        draggingConnection.end = e.page;
        createdConnections.remove(draggingConnection);
        dispatcher.add(new StopCreateConnectionEvent(draggingConnection));
      }
    }));

    addSubscription(dispatcher.stream.listen((e) {
      if (e is StartDragNodeEvent) {
        createdNodes.remove(e.node);
        createdNodes.add(e.node);
        draggingNode = e;
        invalidate();
      } else if (e is StartCreateConnectionEvent) {
        createdConnections.add(e.connection);
        draggingConnection = e.connection;
        invalidate();
      } else if (e is StopCreateConnectionEvent) {
        draggingConnection = null;
        invalidate();
      }
    }));
  }

  updateView() {
    var nodesToDraw = createdNodes.map(nodeComponent).toList()..addAll(createdConnections.map(connectionComponent));

    updateRoot(vRoot(classes: ['fill'])([
      vSvgElement('svg', type: 'GraphRoot', attrs: const {'width': '100%', 'height': '100%'})([
        vSvgElement('defs')([
          vSvgElement('pattern', attrs: const {'id': 'grid', 'width': '100', 'height': '100', 'patternUnits': 'userSpaceOnUse'})([
            rect(attrs: const {'x': '0', 'y': '0', 'width': '100', 'height': '100', 'fill': '#555'}),
            path(attrs: const {'d': 'M 100 0 L 100 100', 'stroke': 'rgba(255, 165, 0, .8)'}),
            path(attrs: const {'d': 'M 0 100 L 100 100', 'stroke': 'rgba(255, 165, 0, .8)'}),
            path(attrs: const {'d': 'M 50 0 L 50 100', 'stroke': 'rgba(255, 165, 0, .5)'}),
            path(attrs: const {'d': 'M 0 50 L 100 50', 'stroke': 'rgba(255, 165, 0, .5)'}),
          ]),
        ]),
        rect(attrs: const {
          'id': 'background', 'x': '0', 'y': '0', 'width': '100%', 'height': '100%', 'fill': 'url(#grid)',
        }),
        g()(nodesToDraw)
      ]),
      vComponent(menu([]..addAll(comparisonNodes)..addAll(mathNodes)..addAll(logicNodes)..addAll(otherNodes)),
        data: menuData
      ),
    ]));
  }
}