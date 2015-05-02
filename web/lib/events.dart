part of raxa;

class StartDragNodeEvent {
  final Point offset;
  final NodeComponent nodeComponent;
  Node get node => nodeComponent.node;

  StartDragNodeEvent(Point start, NodeComponent nodeComponent):
    offset = start - nodeComponent.node.position,
    this.nodeComponent = nodeComponent {
    nodeComponent.dragging = true;
  }
}

class StopDragNodeEvent {
  final NodeComponent nodeComponent;

  StopDragNodeEvent(this.nodeComponent);
}

class DragNodeEvent {
  final Node node;

  DragNodeEvent(this.node);
}

class StartCreateConnectionEvent {
  final ConnectionComponent connection;

  StartCreateConnectionEvent(this.connection);
}

class StopCreateConnectionEvent {
  final ConnectionComponent connection;
  final bool created;

  StopCreateConnectionEvent(this.connection, {this.created: false});
}

class RemoveConnectionEvent {
  final ConnectionComponent connection;

  RemoveConnectionEvent(this.connection);
}
