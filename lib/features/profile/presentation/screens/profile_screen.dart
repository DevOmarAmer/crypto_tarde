import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/widgets/custom_action_tile.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../auth/presentation/bloc/auth_cubit.dart';
import '../../../auth/presentation/bloc/auth_state.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkBackground,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: const Color(0xFF1E282E),
        elevation: 0,
        title: const Text(
          AppStrings.profile,
          style: TextStyle(
            color: AppColors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),

      ),
      body: BlocBuilder<AuthCubit, AuthState>(
        builder: (context, state) {
          if (state is AuthLoading || state is AuthInitial) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is Authenticated) {
            final user = state.user;
            return Column(
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.only(bottom: 32.0, top: 16.0),
                  decoration: const BoxDecoration(color: Color(0xFF1E282E)),
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: LinearGradient(
                            colors: [
                              AppColors.primary,
                              Colors.blueAccent.withOpacity(0.5),
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                        ),
                        child: const CircleAvatar(
                          radius: 45,
                          backgroundColor: Colors.white,
                          child: Icon(
                            Icons.person,
                            size: 50,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        user.name.isNotEmpty ? user.name : 'Unknown User',
                        style: const TextStyle(
                          color: AppColors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: ListView(
                    children: [
                      CustomActionTile(
                        title: AppStrings.username,
                        trailingText: user.name.isNotEmpty ? user.name : '-',
                        onTap: () {},
                      ),
                      CustomActionTile(
                        title: AppStrings.email,
                        trailingText: user.email.isNotEmpty ? user.email : '-',
                        onTap: () {},
                      ),
                      CustomActionTile(
                        title: AppStrings.mobileNumber,
                        trailingText: user.phone.isNotEmpty ? user.phone : '-',
                        onTap: () {},
                      ),
                      CustomActionTile(
                        title: AppStrings.password,
                        trailingText: user.password.isNotEmpty
                            ? List.generate(
                                user.password.length,
                                (index) => '*',
                              ).join()
                            : '-',
                        onTap: () {},
                      ),
                    ],
                  ),
                ),
              ],
            );
          }

          return const Center(
            child: Text(
              'User not found.',
              style: TextStyle(color: Colors.white),
            ),
          );
        },
      ),
    );
  }
}
