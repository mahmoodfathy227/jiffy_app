import 'dart:math' as math;
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

class HorizontalListWheelViewportWidget extends SingleChildRenderObjectWidget {
  HorizontalListWheelViewportWidget({
    required this.offset,
    required this.itemExtent,
    required this.diameterRatio,
    required this.childDelegate,
  });

  final ViewportOffset offset;
  final double itemExtent;
  final double diameterRatio;
  final ListWheelChildDelegate childDelegate;

  @override
  RenderHorizontalListWheelViewport createRenderObject(BuildContext context) {
    return RenderHorizontalListWheelViewport(
      offset: offset,
      itemExtent: itemExtent,
      diameterRatio: diameterRatio,
      childDelegate: childDelegate,
    );
  }

  @override
  void updateRenderObject(
      BuildContext context, RenderHorizontalListWheelViewport renderObject) {
    renderObject
      ..offset = offset
      ..itemExtent = itemExtent
      ..diameterRatio = diameterRatio
      ..childDelegate = childDelegate;
  }
}

class HorizontalListWheelScrollView extends StatefulWidget {
  HorizontalListWheelScrollView({
    required this.itemExtent,
    required this.childDelegate,
    this.controller,
    this.physics,
    this.diameterRatio = 2.0,
  });

  final double itemExtent;
  final ListWheelChildDelegate childDelegate;
  final ScrollController? controller;
  final ScrollPhysics? physics;
  final double diameterRatio;

  @override
  _HorizontalListWheelScrollViewState createState() =>
      _HorizontalListWheelScrollViewState();
}

class _HorizontalListWheelScrollViewState
    extends State<HorizontalListWheelScrollView> {
  @override
  Widget build(BuildContext context) {
    return Scrollable(
      axisDirection: AxisDirection.right, // Horizontal scrolling
      controller: widget.controller,
      physics: widget.physics,
      viewportBuilder: (context, offset) {
        return HorizontalListWheelViewportWidget(
          offset: offset,
          itemExtent: widget.itemExtent,
          diameterRatio: widget.diameterRatio,
          childDelegate: widget.childDelegate,
        );
      },
    );
  }
}

class RenderHorizontalListWheelViewport extends RenderBox
    with
        ContainerRenderObjectMixin<RenderBox, ListWheelParentData>,
        RenderBoxContainerDefaultsMixin<RenderBox, ListWheelParentData>
    implements RenderAbstractViewport {
  RenderHorizontalListWheelViewport({
    required ViewportOffset offset,
    required double itemExtent,
    required double diameterRatio,
    required ListWheelChildDelegate childDelegate,
  })  : _offset = offset,
        _itemExtent = itemExtent,
        _diameterRatio = diameterRatio,
        _childDelegate = childDelegate;

  double _itemExtent;
  double _diameterRatio;
  ViewportOffset _offset;
  ListWheelChildDelegate _childDelegate;

  // Setters for the properties
  set itemExtent(double value) {
    if (value != _itemExtent) {
      _itemExtent = value;
      markNeedsLayout(); // Re-layout when itemExtent changes
    }
  }

  set diameterRatio(double value) {
    if (value != _diameterRatio) {
      _diameterRatio = value;
      markNeedsLayout(); // Re-layout when diameterRatio changes
    }
  }

  set offset(ViewportOffset value) {
    if (value != _offset) {
      _offset = value;
      markNeedsLayout(); // Re-layout when offset changes
    }
  }

  set childDelegate(ListWheelChildDelegate value) {
    if (value != _childDelegate) {
      _childDelegate = value;
      markNeedsLayout(); // Re-layout when the delegate changes
    }
  }

  @override
  void performLayout() {
    size = constraints.biggest;
    final double viewportWidth = size.width;

    final double horizontalOffset = _offset.pixels;

    RenderBox? child = firstChild;
    double currentHorizontalOffset = 0;

    while (child != null) {
      child.layout(constraints.copyWith(
        minWidth: _itemExtent,
        maxWidth: _itemExtent,
      ));
      final ListWheelParentData childParentData =
          child.parentData as ListWheelParentData;
      childParentData.offset =
          Offset(currentHorizontalOffset - horizontalOffset, 0);
      currentHorizontalOffset += _itemExtent;
      child = childParentData.nextSibling;
    }
  }

  @override
  bool hitTestChildren(BoxHitTestResult result, {required Offset position}) {
    RenderBox? child = firstChild;
    while (child != null) {
      final ListWheelParentData childParentData =
          child.parentData as ListWheelParentData;
      if (child.hitTest(result, position: position - childParentData.offset)) {
        return true;
      }
      child = childParentData.nextSibling;
    }
    return false;
  }

  @override
  double computeMaxScrollExtent() {
    return _childDelegate.estimatedChildCount! * _itemExtent;
  }

  // Implementation of getOffsetToReveal (required by RenderAbstractViewport)
  @override
  RevealedOffset getOffsetToReveal(
    RenderObject target,
    double alignment, {
    Rect? rect,
    Axis? axis,
  }) {
    final ListWheelParentData parentData =
        target.parentData as ListWheelParentData;

    final double targetOffset = parentData.offset.dx;
    final double viewportOffset = size.width * alignment;

    return RevealedOffset(
      offset: targetOffset - viewportOffset,
      rect: target.semanticBounds,
    );
  }
}
