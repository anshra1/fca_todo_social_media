import 'package:flutter/material.dart';
import 'package:flutter_learning_go_router/core/enum/sort_criteria.dart';
import 'package:gap/gap.dart';

class SortingBottomSheet {
  SortingBottomSheet._();
  static Future<SortCriteria?> showSortOptionsSheet({
    required BuildContext context,
    required SortCriteria sortCriteria,
    required bool showImportant,
  }) {
    return showModalBottomSheet<SortCriteria?>(
      context: context,
      builder: (context) {
        return SortBottomSheet(
          sortCriteria: sortCriteria,
          showImportant: showImportant,
        );
      },
    );
  }
}

class SortBottomSheet extends StatelessWidget {
  const SortBottomSheet({
    required this.sortCriteria,
    required this.showImportant,
    super.key,
  });

  final SortCriteria sortCriteria;
  final bool showImportant;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(1),
              ),
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Sort by',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const Gap(
            16,
          ),
          if (showImportant)
            _buildSortOption(
              icon: Icons.star_border,
              label: 'Importance',
              color: sortCriteria == SortCriteria.important
                  ? Colors.blue
                  : Colors.black,
              onTap: () {
                Navigator.pop(context, SortCriteria.important);
              },
              selected: sortCriteria == SortCriteria.important,
            ),
          _buildSortOption(
            icon: Icons.calendar_today,
            label: 'Due date',
            color: sortCriteria == SortCriteria.dueDate
                ? Colors.blue
                : Colors.black,
            onTap: () {
              Navigator.pop(context, SortCriteria.dueDate);
            },
            selected: sortCriteria == SortCriteria.dueDate,
          ),
          _buildSortOption(
            icon: Icons.sort_by_alpha,
            label: 'Alphabetically',
            color: sortCriteria == SortCriteria.alphabetical
                ? Colors.blue
                : Colors.black,
            onTap: () {
              Navigator.pop(context, SortCriteria.alphabetical);
            },
            selected: sortCriteria == SortCriteria.alphabetical,
          ),
          _buildSortOption(
            icon: Icons.access_time,
            label: 'Creation date',
            selected: sortCriteria == SortCriteria.creationDate,
            color: sortCriteria == SortCriteria.creationDate
                ? Colors.blue
                : Colors.black,
            onTap: () {
              Navigator.pop(context, SortCriteria.creationDate);
            },
          ),
        ],
      ),
    );
  }
}

Widget _buildSortOption({
  required IconData icon,
  required String label,
  required Color color,
  required void Function()? onTap,
  required bool selected,
}) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
    child: InkWell(
      onTap: onTap,
      child: Ink(
        child: Row(
          children: [
            Icon(
              icon,
              color: color,
            ),
            const Gap(16),
            Text(
              label,
              style: TextStyle(fontSize: 16, color: color),
            ),
            const Spacer(),
            if (selected) const Icon(Icons.check, color: Colors.blue),
          ],
        ),
      ),
    ),
  );
}
