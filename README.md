# Flutter Web Custom HTML Element Widget

A widget that allows you to use custom html elements tracked on top of your flutter widget.

> This package is Web only!

## Features

Create a custom html element through javascript and track it on top of your flutter widget. 
You can change size, position or make it part of scrollable views and it will follow the widget.
There is a bit of a delay, but we are looking for a way to fix that.

You can also change the attributes, which will change the html elements attributes.

## Getting started


Add the following to your pubspec.yaml
```yaml
custom_html_element_web:
  git:
    url: git@bitbucket.org:iconicadevs/flutter_custom_html_element_web.git
    ref: 0.0.1
```

## Usage

See the example for more Information.

```dart
return CustomHtmlElement(
    width: 160,
    height: 90.0 + increment,
    tag: 'my-counter',
    // by providing the controller, the html element can update
    // every time the scroll controller updates.
    layoutObservable: controller,
    attributes: {
        'data-initial-count': '12',
        'data-increment-amount': '$increment',
        'data-on-count-changed': 'onUpdateCount',
    },
);
```

The provided tag needs to be an html element that already exists or that you created. 
The example also shows how to communicate between your custom element and your 

## Issues

Please file any issues, bugs or feature request as an issue on our [GitHub](https://github.com/Iconica-Development/flutter_community_chat/pulls) page. Commercial support is available if you need help with integration with your app or services. You can contact us at [support@iconica.nl](mailto:support@iconica.nl).

## Want to contribute

If you would like to contribute to the plugin (e.g. by improving the documentation, solving a bug or adding a cool new feature), please carefully review our [contribution guide](../CONTRIBUTING.md) and send us your [pull request](https://github.com/Iconica-Development/flutter_community_chat/pulls).

## Author

This `custom_html_element_web` for Flutter is developed by [Iconica](https://iconica.nl). You can contact us at <support@iconica.nl>