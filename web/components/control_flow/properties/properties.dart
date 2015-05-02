part of raxa;

class PropertyComponent extends Component<Property> {
  init() {
    addSubscription(element.onKeyUp.listen((e) {
      print(e.target.value);
      data.setValue(e.target.value);
    }));
    addSubscription(element.onChange.listen((e) {
      print(e.target.value);
      data.setValue(e.target.value);
    }));
  }

  updateView() {
    updateRoot(vRoot(type: 'property')([
      vElement('label')([
        vElement('span')(vText(data.name)),
        vElement('input', attrs: {'value': data.value.toString()}),
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
