part of raxa;

class SelectNodeEvent {
  final NodeComponent nodeComponent;

  SelectNodeEvent(this.nodeComponent);
}

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

class NodeMovedEvent {
  final NodeComponent nodeComponent;
  Node get node => nodeComponent.node;

  NodeMovedEvent(this.nodeComponent);
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

class OpenDisplayEvent {
  final Display display;

  OpenDisplayEvent(this.display);
}

class StartDragDisplayEvent {
  final Display display;
  final Point offset;

  StartDragDisplayEvent(this.display, [this.offset = const Point(0, 0)]);
}

class PropertyChangedEvent {}
