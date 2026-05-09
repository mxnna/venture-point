import 'package:flutter/material.dart';
import 'package:venturepoint/core/theme/app_colors.dart';
import 'package:venturepoint/core/theme/app_text_styles.dart';
import 'package:venturepoint/presentation/pages/flight/flight_search_page.dart';
import 'package:venturepoint/presentation/widgets/empty_state_placeholder.dart';

class TripsPage extends StatelessWidget {
  static const routeName = '/trips';

  const TripsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
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
                    Text('Trips', style: AppTextStyles.displaySmall),
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
                  isScrollable: false,
                  dividerColor: Colors.transparent,
                  labelPadding: const EdgeInsets.symmetric(horizontal: 20),
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
                    Tab(text: 'Upcoming'),
                    Tab(text: 'Past'),
                  ],
                ),
              ),
              const SizedBox(height: 28),
              const Expanded(
                child: TabBarView(
                  children: [_TripsPlaceholder(), _TripsPlaceholder()],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TripsPlaceholder extends StatelessWidget {
  const _TripsPlaceholder();

  @override
  Widget build(BuildContext context) {
    return EmptyStatePlaceholder(
      icon: Icons.card_travel,
      title: 'No trips booked yet',
      message: 'Your upcoming adventures will show up here.',
      buttonLabel: 'Search flights',
      onPressed: () {
        Navigator.of(context).pushNamed(FlightSearchPage.routeName);
      },
    );
  }
}
