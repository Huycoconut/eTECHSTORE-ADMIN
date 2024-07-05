import 'package:flutter/material.dart';

class Pagination extends StatelessWidget {
  final int currentPage;
  final int itemsPerPage;
  final int totalItems;
  final Function(int) onPageChanged;

  const Pagination({
    super.key,
    required this.currentPage,
    required this.itemsPerPage,
    required this.totalItems,
    required this.onPageChanged,
  });

  @override
  Widget build(BuildContext context) {
    int totalPages = (totalItems / itemsPerPage).ceil();

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          icon: const Icon(Icons.chevron_left),
          onPressed: currentPage > 1 ? () => onPageChanged(currentPage - 1) : null,
        ),
        for (int i = 1; i <= totalPages; i++)
          TextButton(
            onPressed: () => onPageChanged(i),
            child: Text(
              i.toString(),
              style: TextStyle(
                fontWeight: currentPage == i ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ),
        IconButton(
          icon: const Icon(Icons.chevron_right),
          onPressed: currentPage < totalPages ? () => onPageChanged(currentPage + 1) : null,
        ),
      ],
    );
  }
}
