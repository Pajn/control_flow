part of raxa;

class MenuData {
  Point<int> position = new Point(0, 0);
  bool open = false;
}

class MenuComponent extends Component<MenuData> {
  final backdropStyle = {
    'position': 'fixed',
    'top': '0',
    'left': '0',
    'width': '100%',
    'height': '100%',
  };
  static const menuStyle = const {
    'position': 'fixed',
    'top': '0',
    'left': '0',
  };
  static const closedStyle = const {
    'display': 'none',
  };

  var items;

  MenuComponent(this.items);

  closeMenu() {
    dispatcher.add(CLOSE_MENU);
  }

  init() {
    addSubscription(element.onMouseDown.matches('button').listen((e) {
      e.stopImmediatePropagation();
      data.open = false;
      invalidate();
      var nodeClass = items[int.parse(e.matchingTarget.getAttribute('data-index'))];
      var node = new Node(nodeClass)..position = e.page;
      createdNodes.add(node);
      dispatcher.add(new StartDragNodeEvent(e.page, node));
    }));
    addSubscription(element.onClick.listen((e) {
      e.stopPropagation();
      data.open = false;
      invalidate();
    }));
  }

  updateView() {
    if (!data.open) return updateRoot(vRoot(style: closedStyle));

    var menuIndex = 0;
    var menuItems = items.map((node) => vElement('li')([vElement('button', attrs: {'data-index': '${menuIndex++}'})(node.name)])).toList();

    updateRoot(vRoot(style: backdropStyle)([
      vElement('ul', type: 'menu',
                     style: {'transform': 'translate(${data.position.x}px, ${data.position.y}px)'}..addAll(menuStyle)
      )(menuItems)
    ]));
  }
}

menu(items) => () => new MenuComponent(items);
