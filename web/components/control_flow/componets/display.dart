part of raxa;

class Display {
  final SocketComponent socketComponent;
  Point socketPosition;
  Point position;

  get socket => socketComponent.socket;

  Display(this.socketComponent);

  operator ==(other) =>
      socket == other.socket && socketPosition == other.socketPosition && position == other.position;
}

class DisplayComponent extends SvgComponent<Display> {
  final String tag = 'g';
  var _value;

  get lineX => data.position.x + 30;
  get lineY => data.position.y - 15 > data.socketPosition.y ? data.position.y : data.position.y + 30;
  get value {
    if (_value == null) {
      updateValue();
    }

    return _value;
  }

  updateValue() {
    _value = getValue(data.socket.node, data.socket.name).toString();
  }

  init() {
    addSubscription(element.onMouseDown.matches('rect').listen((e) {
      e.stopPropagation();

      dispatcher.add(new StartDragDisplayEvent(data, e.offset - data.position));
    }));
    addSubscription(dispatcher.stream.listen((e) {
      if (e is PropertyChangedEvent) {
        updateValue();
        invalidate();
      } else if (e is NodeMovedEvent && e.node == data.socket.node) {
        data.socketPosition = data.socketComponent.center;
        invalidate();
      }
    }));
  }

  updateView() {
    updateRoot(g()([
      path(classes: const ['no-pointer'], attrs: {
        'fill': 'none', 'stroke': 'white', 'stroke-width': '1',
        'd': 'M ${data.socketPosition.x} ${data.socketPosition.y} L $lineX $lineY',
      }),
      rect(attrs: {
        'fill': '#999', 'width': '60', 'height': '30', 'rx': '5', 'ry': '5',
        'x': '${data.position.x}', 'y': '${data.position.y}'
      }),
      text(attrs: {
        'fill': 'white', 'text-anchor': 'end',
        'x': '${data.position.x + 55}', 'y': '${data.position.y + 20}',
      })(value),
    ]));
  }
}

var displayComponent = () => new DisplayComponent();
