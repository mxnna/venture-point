import 'package:flutter/material.dart';
import 'package:venturepoint/core/theme/app_colors.dart';
import 'package:venturepoint/core/theme/app_text_styles.dart';
import 'package:venturepoint/presentation/widgets/empty_state_placeholder.dart';
import 'package:venturepoint/presentation/pages/main_navigation_page.dart';

class SavedItemsPage extends StatelessWidget {
  static const routeName = '/saved';

  const SavedItemsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 5,
      child: Scaffold(
        backgroundColor: AppColors.secondary,
        body: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 16,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Saved', style: AppTextStyles.displaySmall),
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.notifications_none),
                      color: AppColors.textPrimary,
                      iconSize: 24,
                      splashRadius: 24,
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: TabBar(
                  padding: EdgeInsets.zero,
                  isScrollable: true,
                  dividerColor: Colors.transparent,
                  labelPadding: const EdgeInsets.symmetric(horizontal: 14),
                  indicatorPadding: EdgeInsets.zero,
                  tabAlignment: TabAlignment.start,
                  indicatorSize: TabBarIndicatorSize.label,
                  indicatorColor: AppColors.primary,
                  indicatorWeight: 3,
                  overlayColor: const WidgetStatePropertyAll<Color?>(
                    Colors.transparent,
                  ),
                  labelColor: AppColors.primary,
                  unselectedLabelColor: AppColors.textSecondary,
                  labelStyle: const TextStyle(fontWeight: FontWeight.w700),
                  unselectedLabelStyle: const TextStyle(
                    fontWeight: FontWeight.w500,
                  ),
                  tabs: const [
                    Tab(text: 'All'),
                    Tab(text: 'Destinations'),
                    Tab(text: 'Hotels'),
                    Tab(text: 'Flights'),
                    Tab(text: 'Experiences'),
                  ],
                ),
              ),
              const SizedBox(height: 28),
              const Expanded(
                child: TabBarView(
                  children: [
                    _SavedPlaceholder(),
                    _SavedPlaceholder(),
                    _SavedPlaceholder(),
                    _SavedPlaceholder(),
                    _SavedPlaceholder(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SavedPlaceholder extends StatelessWidget {
  const _SavedPlaceholder();

  @override
  Widget build(BuildContext context) {
    return EmptyStatePlaceholder(
      icon: Icons.favorite_border,
      title: 'You haven\'t saved anything yet',
      message: 'Save places, hotels, flights and experiences you love.',
      buttonLabel: 'Explore destinations',
      onPressed: () {
        Navigator.of(
          context,
        ).pushReplacementNamed(MainNavigationPage.routeName);
      },
    );
  }
}
