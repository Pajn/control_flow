part of raxa;

class ConnectionComponent extends SvgComponent<Connection> {
  final String tag = 'g';

  get type => data.type;
  get start => data.start;
  get end => data.end;

  updateView() {
    updateRoot(g(type: 'connection')([
      circle(attrs: {'cx': '${start.x}', 'cy': '${start.y}', 'r': '5', 'fill': colors[type], 'stroke-width': '0'}),
      path(attrs: {
        'fill': 'none', 'stroke': colors[type], 'strokeWidth': '2',
        'd': 'M ${start.x} ${start.y} C ${start.x + 70} ${start.y}, ${end.x - 70} ${end.y}, ${end.x} ${end.y}',
      }),
      circle(attrs: {'cx': '${end.x}', 'cy': '${end.y}', 'r': '5', 'fill': colors[type]}),
    ]));
  }
}

connectionComponent(Connection connection) => vComponent(() => new ConnectionComponent(), data: connection);
