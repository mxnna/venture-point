import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:venturepoint/core/theme/app_colors.dart';
import 'package:venturepoint/core/theme/app_text_styles.dart';
import 'package:venturepoint/presentation/pages/flight/flight_search_page.dart';
import 'package:venturepoint/presentation/pages/flight/models/booking_model.dart';
import 'package:venturepoint/presentation/pages/flight/screens/booking_details_screen.dart';
import 'package:venturepoint/presentation/pages/flight/services/flight_services.dart';
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
              Expanded(
                child: TabBarView(
                  children: [_TripsBookingTab(true), _TripsBookingTab(false)],
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

class _TripsBookingTab extends StatelessWidget {
  final bool upcoming;
  const _TripsBookingTab(this.upcoming);

  bool _matchesType(BookingModel booking) {
    try {
      final depart = DateFormat('d MMM yyyy').parse(booking.departDate);
      final today = DateTime.now();
      return upcoming
          ? !depart.isBefore(DateTime(today.year, today.month, today.day))
          : depart.isBefore(DateTime(today.year, today.month, today.day));
    } catch (_) {
      return upcoming;
    }
  }

  @override
  Widget build(BuildContext context) {
    final userId = FirebaseAuth.instance.currentUser?.uid ?? 'user_demo';
    return StreamBuilder<List<BookingModel>>(
      stream: FlightService().getUserBookings(userId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(color: AppColors.primary),
          );
        }
        if (snapshot.hasError) {
          return Center(
            child: Text(
              'Failed to load trips',
              style: TextStyle(color: AppColors.textMuted),
            ),
          );
        }

        final bookings = snapshot.data ?? [];
        final filtered = bookings.where(_matchesType).toList();
        if (filtered.isEmpty) {
          return const _TripsPlaceholder();
        }

        return ListView.separated(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          itemCount: filtered.length,
          separatorBuilder: (context, index) => const SizedBox(height: 16),
          itemBuilder: (context, index) {
            final booking = filtered[index];
            return _BookingCard(
              booking: booking,
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => BookingDetailsScreen(booking: booking),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }
}

class _BookingCard extends StatelessWidget {
  final BookingModel booking;
  final VoidCallback onTap;

  const _BookingCard({required this.booking, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(13),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.primaryLight,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    booking.airline,
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primary,
                    ),
                  ),
                ),
                const Spacer(),
                Text(
                  booking.status.toUpperCase(),
                  style: const TextStyle(
                    fontSize: 11,
                    color: AppColors.success,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              '${booking.fromCode} → ${booking.toCode}',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              '${booking.departDate} · ${booking.departTime} · Seat ${booking.seatNumber}',
              style: const TextStyle(fontSize: 12, color: AppColors.textMuted),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Text(
                  '\$${booking.totalPrice.toInt()}',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primary,
                  ),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.secondaryDark,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Text(
                    'View',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
