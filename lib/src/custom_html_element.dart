// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;

import 'package:flutter/material.dart';

/// A widget that allows you to create a custom HTML element
/// that follows this widget position and size.
///
/// This is meant for custom HTML elements that require custom attributes
/// and cannot be rendered through other flutter html packages.
///
/// It is not possible to provide children to the custom HTML element, for now.
class CustomHtmlElement extends StatefulWidget {
  const CustomHtmlElement({
    required this.tag,
    required this.height,
    required this.width,
    required this.id,
    this.layoutObservable,
    this.attributes = const {},
    super.key,
  });

  /// the width of the widget
  final double width;

  /// the height of the widget;
  final double height;

  // the id of the html element
  final String id;

  /// The tag name of the html element
  ///
  /// for example, a <p></p> will be a p.
  final String tag;
  final Map<String, String> attributes;

  /// A listenable that notifies the widget that its position has changed.
  ///
  /// For example, providing a scroll controller here will cause the related
  /// HTML element to be moved to the correct spot according to the flutter
  /// location of the widget.
  final Listenable? layoutObservable;

  @override
  State<CustomHtmlElement> createState() => _CustomHtmlElementState();
}

class _CustomHtmlElementState extends State<CustomHtmlElement>
    with WidgetsBindingObserver {
  late final html.Element _internalElement;
  GlobalKey _key = GlobalKey();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _addInternalElement();
    });

    widget.layoutObservable?.addListener(_onLayoutObservableChanged);
  }

  void _addInternalElement() {
    _internalElement = html.document.createElement(widget.tag);
    if (!mounted) {
      return;
    }

    _internalElement.style.position = 'fixed';
    _internalElement.style.display = 'block';
    _internalElement.id = widget.id;
    _setOffset();

    for (var attribute in widget.attributes.entries) {
      _internalElement.setAttribute(attribute.key, attribute.value);
    }

    html.document.getElementById(widget.tag)?.replaceWith(_internalElement);

    html.document.querySelector('body')?.append(_internalElement);
  }

  void _setOffset() {
    var renderBox = _key.currentContext?.findRenderObject() as RenderBox;

    final offset = renderBox.localToGlobal(Offset.zero);
    _internalElement.style.left = '${offset.dx}px';
    _internalElement.style.top = '${offset.dy}px';
    _internalElement.style.width = '${widget.width}px';
    _internalElement.style.height = '${widget.height}px';
  }

  DateTime _observableLastChanged = DateTime.now();

  void _onLayoutObservableChanged() {
    _setOffset();
    var lastChanged = _observableLastChanged = DateTime.now();
    // autoCorrect after 50 milliseconds;
    Future.delayed(const Duration(milliseconds: 50), () {
      if (_observableLastChanged == lastChanged && mounted) {
        _setOffset();
      }
    });
  }

  @override
  void dispose() {
    super.dispose();

    WidgetsBinding.instance.removeObserver(this);

    widget.layoutObservable?.removeListener(_onLayoutObservableChanged);
    _internalElement.remove();
  }

  @override
  void didChangeMetrics() {
    _setOffset();
  }

  @override
  void didUpdateWidget(covariant CustomHtmlElement oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (!mounted) {
      return;
    }

    if (oldWidget.layoutObservable != widget.layoutObservable) {
      oldWidget.layoutObservable?.removeListener(_onLayoutObservableChanged);
      widget.layoutObservable?.addListener(_onLayoutObservableChanged);
    }

    if (oldWidget.width != widget.width || oldWidget.height != widget.height) {
      _setOffset();
      setState(() {
        _key = GlobalKey();
      });
    }

    var delta = oldWidget.attributes.getDelta(widget.attributes);
    for (var attribute in delta.entries) {
      var value = attribute.value;
      if (value == null) {
        _internalElement.removeAttribute(attribute.key);
      } else {
        _internalElement.setAttribute(attribute.key, value);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      key: _key,
      width: widget.width,
      height: widget.height,
    );
  }
}

extension _MapDelta<K, V> on Map<K, V> {
  /// Get the delta between two maps
  ///
  /// A null value indicates that the value exists in this map,
  /// but that [other] does not contain that value
  ///
  /// This does not perform a recursive delta
  Map<K, V?> getDelta(Map<K, V> other) {
    var delta = <K, V?>{};
    for (var entry in entries) {
      if (!other.containsKey(entry.key)) {
        delta[entry.key] = null;
      }
      if (other[entry.key] != entry.value) {
        delta[entry.key] = other[entry.key];
      }
    }
    for (var entry in other.entries) {
      if (!containsKey(entry.key)) {
        delta[entry.key] = entry.value;
      }
    }
    return delta;
  }
}
