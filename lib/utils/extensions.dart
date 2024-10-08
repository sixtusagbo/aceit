import 'package:flutter/material.dart';

extension MapX<K, V> on Map<K, V> {
  /// Return this map without `null` values.
  ///
  /// ie `{1:1, 2:null}.withoutNullValues == {1:1}`
  Map<K, V> get withoutNullValues =>
      {...this}..removeWhere((key, value) => value == null);
}

extension WidgetIterableExtension on Iterable<Widget> {
  /// Add a specified widget between each pair of widgets.
  List<Widget> separatedBy(Widget child) {
    final iterator = this.iterator;
    final result = <Widget>[];

    if (iterator.moveNext()) result.add(iterator.current);

    while (iterator.moveNext()) {
      result
        ..add(child)
        ..add(iterator.current);
    }

    return result;
  }
}

extension TextThemeExtension on BuildContext {
  TextTheme get textTheme => Theme.of(this).textTheme;
}
