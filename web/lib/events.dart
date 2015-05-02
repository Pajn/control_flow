part of raxa;

class StartDragNodeEvent {
  final Point offset;
  final Node node;

  StartDragNodeEvent(Point start, Node node):
    offset = start - node.position,
    this.node = node;
}

class StopDragNodeEvent {
  final Node node;

  StopDragNodeEvent(this.node);
}

class DragNodeEvent {
  final Node node;

  DragNodeEvent(this.node);
}

class StartCreateConnectionEvent {
  final Connection connection;

  StartCreateConnectionEvent(this.connection);
}

class StopCreateConnectionEvent {
  final Connection connection;
  final bool created;

  StopCreateConnectionEvent(this.connection, {this.created: false});
}
