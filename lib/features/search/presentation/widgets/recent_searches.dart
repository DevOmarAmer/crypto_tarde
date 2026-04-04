import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_colors.dart';
import '../../logic/search_cubit.dart';

class RecentSearches extends StatelessWidget {
  final List<String> history;

  const RecentSearches({super.key, required this.history});

  @override
  Widget build(BuildContext context) {
    if (history.isEmpty) return const SizedBox.shrink();
    final cubit = context.read<SearchCubit>();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Recent Searches', style: const TextStyle(color: AppColors.white, fontSize: 18, fontWeight: FontWeight.bold)),
            TextButton(
              onPressed: () => cubit.clearHistory(),
              child: const Text(
                'CLEAR ALL',
                style: TextStyle(color: AppColors.primary, fontSize: 12, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: history
              .map(
                (query) => InputChip(
                  label: Text(query, style: const TextStyle(color: AppColors.white, fontSize: 14)),
                  backgroundColor: AppColors.darkSurface,
                  deleteIcon: const Icon(Icons.close, size: 14, color: AppColors.grey),
                  onDeleted: () => cubit.removeQuery(query),
                  onPressed: () {
                    cubit.searchController.text = query;
                    cubit.search(query);
                  },
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                  side: BorderSide.none,
                ),
              )
              .toList(),
        ),
      ],
    );
  }
}

