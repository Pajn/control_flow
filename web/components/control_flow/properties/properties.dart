part of raxa;

class PropertyComponent extends Component<Property> {
  init() {
    addSubscription(element.onKeyUp.listen((e) {
      print(e.target.value);
      data.setValue(e.target.value);
      dispatcher.add(new PropertyChangedEvent());
    }));
    addSubscription(element.onChange.listen((e) {
      if (data.type == bool) {
        data.value = e.target.checked;
      } else {
        data.setValue(e.target.value);
      }
      dispatcher.add(new PropertyChangedEvent());
    }));
  }

  updateView() {
    var input;

    if (data.type == num) {
      input = vElement('input', attrs: {'value': data.value.toString(), 'type': 'number'});
    } else if (data.type == bool && data.value == true) {
      input = vElement('input', attrs: {'checked': '', 'type': 'checkbox'});
    } else if (data.type == bool) {
      input = vElement('input', attrs: const {'type': 'checkbox'});
    } else {
      input = vElement('input', attrs: {'value': data.value.toString()});
    }

    updateRoot(vRoot(type: 'property')([
      vElement('label')([
        vElement('span')(vText(data.name)),
        input,
      ]),
    ]));
  }
}

var propertyComponent = () => new PropertyComponent();

class DetailsComponent extends Component<Node> {
  updateView() {
    var properties = data.properties.map((property) => vComponent(propertyComponent, data: property));

    updateRoot(vRoot()(properties));
  }
}

var detailsComponent = () => new DetailsComponent();

class PropertiesComponent extends Component<Node> {
  updateView() {
    if (data == null) {
      return updateRoot(vRoot());
    }
    updateRoot(vRoot()([
      vElement('h1')(data.nodeClass.name),
      vComponent(detailsComponent, data: data),
    ]));
  }
}

var propertiesComponent = () => new PropertiesComponent();
