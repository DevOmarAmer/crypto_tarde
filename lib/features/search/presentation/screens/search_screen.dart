import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/custom_app_bar.dart';
import '../../logic/search_cubit.dart';
import '../../logic/search_state.dart';
import '../widgets/recent_searches.dart';
import '../widgets/search_field.dart';
import '../widgets/search_results.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkBackground,
      appBar: const CustomAppBar(showBackButton: true, title: 'Search'),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.fromLTRB(24, 16, 24, 0),
              child: SearchField(),
            ),
            const SizedBox(height: 24),
            Expanded(
              child: BlocBuilder<SearchCubit, SearchState>(
                builder: (context, state) {
                  if (state is SearchLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  return SingleChildScrollView(
                    padding: const EdgeInsets.only(bottom: 120),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24.0),
                      child: _buildBodyContent(state),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBodyContent(SearchState state) {
    if (state is SearchHistoryLoaded) {
      return RecentSearches(history: state.history);
    } else if (state is SearchResultsSuccess) {
      return SearchResults(coins: state.coins);
    } else if (state is SearchError) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.only(top: 100),
          child: Text(
            state.message,
            style: const TextStyle(color: AppColors.white, fontSize: 16),
          ),
        ),
      );
    }
    return const SizedBox.shrink();
  }
}
