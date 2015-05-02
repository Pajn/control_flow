part of raxa;

class ConnectionComponent extends SvgComponent {
  final String tag = 'g';
  final Connection connection;

  ConnectionComponent(this.connection);

  get type => connection.type;
  get start => connection.start;
  get end => connection.end;

  updateView() {
    updateRoot(g()([
      circle(attrs: {'cx': '${start.x}', 'cy': '${start.y}', 'r': '5', 'fill': colors[type], 'stroke-width': '0'}),
      path(attrs: {
        'fill': 'none', 'stroke': colors[type], 'strokeWidth': '2',
        'd': 'M ${start.x} ${start.y} C ${start.x + 70} ${start.y}, ${end.x - 70} ${end.y}, ${end.x} ${end.y}',
      }),
      circle(attrs: {'cx': '${end.x}', 'cy': '${end.y}', 'r': '5', 'fill': colors[type]}),
    ]));
  }
}

var connectionComponent = cachedComponent('connection');
