import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_colors.dart';
import '../../logic/search_cubit.dart';

class SearchField extends StatelessWidget {
  const SearchField({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<SearchCubit>();
    return TextField(
      controller: cubit.searchController,
      style: const TextStyle(color: AppColors.white, fontSize: 16),
      onSubmitted: (value) {
        final query = value.trim();
        if (query.isNotEmpty) {
          cubit.addToHistory(query);
          cubit.search(query);
        }
      },
      decoration: InputDecoration(
        hintText: 'Search for a coin...',
        hintStyle: const TextStyle(
          color: AppColors.grey,
        ),
        prefixIcon: const Icon(Icons.search, color: AppColors.grey),
        suffixIcon: IconButton(
          icon: const Icon(
            Icons.arrow_forward_rounded,
            color: AppColors.primary,
          ),
          onPressed: () {
            final query = cubit.searchController.text.trim();
            if (query.isNotEmpty) {
              cubit.addToHistory(query);
              cubit.search(query);
            }
          },
        ),
        filled: true,
        fillColor: AppColors.darkSurface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}

