part of raxa;

class SelectedComponent extends SvgComponent<NodeComponent> {
  final String tag = 'g';

  get width => (data.width + 10).toString();
  get height => (data.height + 40).toString();

  init() {
    addSubscription(dispatcher.stream.listen((e) {
      if (e is NodeMovedEvent && e.nodeComponent == data) {
        invalidate();
      }
    }));
  }

  updateView() {
    updateRoot(g(attrs: {'transform': 'translate(${data.x - 5}, ${data.y - 5})'})(
      rect(attrs: {
        'fill': 'none', 'stroke': 'white', 'stroke-width': '5', 'stroke-linecap': 'round',
        'stroke-opacity': '0.5', 'width': width, 'height': height, 'rx': '5', 'ry': '5'
      })
    ));
  }
}

var selectedComponent = () => new SelectedComponent();
