part of raxa;

class SelectedComponent extends SvgComponent<Rectangle> {
  final String tag = 'g';

  get width => (data.width + 10).toString();
  get height => (data.height + 10).toString();

  updateView() {
    updateRoot(g(attrs: {'transform': 'translate(${data.left - 5}, ${data.top - 5})'})(
      rect(attrs: {
        'fill': 'none', 'stroke': 'white', 'stroke-width': '5', 'stroke-linecap': 'round',
        'stroke-opacity': '0.5', 'width': width, 'height': height, 'rx': '5', 'ry': '5'
      })
    ));
  }
}

var selectedComponent = () => new SelectedComponent();
