part of raxa;

List<NodeComponent> createdNodes = <NodeComponent>[];
List<ConnectionComponent> createdConnections = <ConnectionComponent>[];

class ControlFlow extends Component {
  Node selectedNode;
  PropertiesComponent propertiesComponent;
  var p;
  VNode graphNode;

  init() {
    propertiesComponent = new PropertiesComponent();
    p = () => propertiesComponent;
    graphNode = vComponent(graphComponent, classes: const ['flex'], key: 'graph');

    addSubscription(dispatcher.stream.listen((e) {
      if (e is SelectNodeEvent) {
        if (e.nodeComponent == null) {
          selectedNode = null;
        } else {
          selectedNode = e.nodeComponent.node;
        }
        propertiesComponent.invalidate();
        graphNode.cref.invalidate();
        invalidate();
      } else if (e is RemoveConnectionEvent) {
        createdConnections.remove(e.connection);
        graphNode.cref.invalidate();
      }
    }));
  }

  updateView() {
    updateRoot(vRoot(type: 'workspace', classes: const ['fill'])([
      vComponent(p, data: selectedNode, key: 'properties', type: 'properties'),
      graphNode,
    ]));
  }
}
