import 'package:flutter/material.dart';

class CustomListView extends StatelessWidget {
  final int itemCount;
  final int itemsPerRow;
  final double rowSpacing;
  final double itemSpacing;
  final EdgeInsetsGeometry? padding;
  final IndexedWidgetBuilder itemBuilder;

  const CustomListView({
    super.key,
    required this.itemCount,
    required this.itemsPerRow,
    this.rowSpacing = 0.0,
    this.itemSpacing = 0.0,
    this.padding = EdgeInsets.zero,
    required this.itemBuilder,
  });

  @override
  Widget build(BuildContext context) {
    final rowCount = (itemCount / itemsPerRow).ceil();

    return ListView.separated(
      padding: padding,
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: rowCount,
      separatorBuilder: (_, __) => SizedBox(height: rowSpacing),
      itemBuilder: (context, rowIndex) => _buildRow(context, rowIndex),
    );
  }

  /// Constructs a single row with dynamically calculated items
  Widget _buildRow(BuildContext context, int rowIndex) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: _createRowItems(context, rowIndex),
    );
  }

  /// Generates all items for a single row with proper spacing
  List<Widget> _createRowItems(BuildContext context, int rowIndex) {
    final children = <Widget>[];
    final startIndex = rowIndex * itemsPerRow;
    final endIndex = startIndex + itemsPerRow;
    final lastItemIndex = itemCount - 1;

    for (int i = startIndex; i < endIndex; i++) {
      final isLastInRow = i == endIndex - 1;
      final shouldAddSpacer = itemSpacing > 0 && !isLastInRow;
      final isWithinBounds = i <= lastItemIndex;

      if (isWithinBounds) {
        children.add(Expanded(child: itemBuilder(context, i)));

        if (shouldAddSpacer) {
          children.add(SizedBox(width: itemSpacing));
        }
      } else {
        // Fill remaining row space with empty items
        children.add(const Expanded(child: SizedBox()));
      }
    }

    return children;
  }
}
