import 'package:flutter/material.dart';
import 'package:venturepoint/core/theme/app_colors.dart';
import 'package:venturepoint/core/theme/app_text_styles.dart';

import '../../widgets/app_header.dart';
import '../../widgets/search_bar.dart';
import '../../widgets/quick_action_buttons.dart';
import '../destination/destination_data.dart';
import '../flight/flight_search_page.dart';
import '../hotel/hotel_search_page.dart';
import '../trips/discover_page.dart';

const _flightDeals = [
  {
    'route': 'Cairo (CAI) → Dubai (DXB)',
    'dates': '18 May – 25 May',
    'price': 'from \$210',
    'image': 'https://www.flightsfrom.com/routes/CAI-DXB.png',
  },
  {
    'route': 'Cairo (CAI) → London (LHR)',
    'dates': '5 Mar – 12 Mar',
    'price': 'from \$580',
    'image': 'https://www.flightsfrom.com/routes/CAI-LHR.png',
  },
  {
    'route': 'Cairo (CAI) → Paris (CDG)',
    'dates': '11 Apr – 18 Apr',
    'price': 'from \$430',
    'image': 'https://www.flightsfrom.com/routes/CAI-CDG.png',
  },
];

const _featuredHotels = [
  {
    'name': 'Hôtel Plaza Athénée',
    'location': 'Paris, France',
    'price': '\$450 / night',
    'rating': '4.8',
    'image':
        'https://upload.wikimedia.org/wikipedia/commons/3/33/Plaza_Ath%C3%A9n%C3%A9e_1.jpg',
  },
  {
    'name': 'Selina Cancun',
    'location': 'Cancun, Mexico',
    'price': '\$55 / night',
    'rating': '4.2',
    'image':
        'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSKBljtO2UUxztq4MhSAApLMnQuaKdJ2-ZDCw&s',
  },
  {
    'name': 'Atlantis The Palm',
    'location': 'Dubai, UAE',
    'price': '\$750 / night',
    'rating': '4.7',
    'image':
        'https://www.visitdubai.com/-/media/gathercontent/article/o/one-day-at-atlantis/fallback-image/media/atp-hero08v3-1.jpg',
  },
];

const _homepageExperiences = <ExperienceDestination>[
  ExperienceDestination(
    title: 'Kayaking on the Nile',
    subtitle: 'River adventure through Cairo',
    image:
        'https://www.detourstravel.com/content/ck-editor-uploads/2023/01/19/egypt_4.jpg',
    rating: 4.8,
    location: 'Cairo, Egypt',
  ),
  ExperienceDestination(
    title: 'Skiing in the Alps',
    subtitle: 'Snowy mountain slopes',
    image:
        'https://theluxuryvacationguide.com/wp-content/uploads/2017/07/5courchevel-saulares-peak.jpg',
    rating: 4.9,
    location: 'Chamonix, France',
  ),
  ExperienceDestination(
    title: 'Water diving',
    subtitle: 'Explore coral reefs',
    image:
        'https://drhoffman.com/wp-content/uploads/2024/03/is_scubareef_sh.jpg',
    rating: 4.8,
    location: 'Great Barrier Reef',
  ),
];

const _homepageEvents = <DestinationEvent>[
  DestinationEvent(
    title: 'Van Gogh Immersive Experience',
    dateRange: '8 Jun – 30 Jun 2026',
    location: 'Amsterdam, Netherlands',
    category: 'Exhibition',
    image:
        'https://images.unsplash.com/photo-1682944596871-892f20a98275?q=80&w=1470&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
  ),
  DestinationEvent(
    title: 'Opera Night at La Scala',
    dateRange: '12 Jul 2026 · 7:30 PM',
    location: 'Milan, Italy',
    category: 'Performance',
    image:
        'https://luxoitalia.com/wp-content/uploads/2024/10/Teatro-alla-scala_.jpg',
  ),
  DestinationEvent(
    title: 'Rio Carnival',
    dateRange: '21 Feb – 24 Feb 2026',
    location: 'Rio de Janeiro, Brazil',
    category: 'Festival',
    image:
        'https://images.squarespace-cdn.com/content/v1/66dccb3e76bb65492220b367/6db213ea-e794-4274-bcaf-af9f5f3ddac5/RIO-CARNIVAL-2025-THE-WORLD%27S-MOST-ICONIC-FESTIVAL-EAST-WEST-SPACE-Barcelona.jpg',
  ),
];

class HomePage extends StatelessWidget {
  static const routeName = '/home';

  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final featuredEvents = _homepageEvents;

    return Scaffold(
      backgroundColor: AppColors.secondary,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(vertical: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppHeader(
                      logoPath: 'assets/images/logo.png',
                      appName: 'Venture Point',
                      onNotificationTap: () {
                        // Handle notification tap
                      },
                    ),
                    const SizedBox(height: 24),
                    SearchBarWidget(
                      hintText: 'Search destinations, hotels, flights...',
                      onFilterTap: () {
                        // Handle filter tap
                      },
                      backgroundColor: AppColors.white,
                      textColor: AppColors.textPrimary,
                      hintColor: AppColors.textSecondary,
                    ),
                    const SizedBox(height: 28),
                    QuickActionButtons(
                      buttons: [
                        QuickActionButton(
                          label: 'Discover',
                          icon: Icons.explore,
                          onPressed: () {
                            Navigator.of(
                              context,
                            ).pushNamed(DiscoverPage.routeName);
                          },
                        ),
                        QuickActionButton(
                          label: 'Hotels',
                          icon: Icons.apartment,
                          onPressed: () {
                            Navigator.of(
                              context,
                            ).pushNamed(HotelSearchPage.routeName);
                          },
                        ),
                        QuickActionButton(
                          label: 'Flights',
                          icon: Icons.flight,
                          onPressed: () {
                            Navigator.of(
                              context,
                            ).pushNamed(FlightSearchPage.routeName);
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 28),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: _buildSectionHeader('Flight deals', onTap: () {}),
              ),
              const SizedBox(height: 14),
              SizedBox(
                height: 190,
                child: ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  scrollDirection: Axis.horizontal,
                  primary: false,
                  physics: const BouncingScrollPhysics(),
                  itemCount: _flightDeals.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 16),
                  itemBuilder: (context, index) {
                    final deal = _flightDeals[index];
                    return _buildFlightDealCard(deal);
                  },
                ),
              ),
              const SizedBox(height: 24),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: _buildSectionHeader('Featured stays', onTap: () {}),
              ),
              const SizedBox(height: 14),
              SizedBox(
                height: 240,
                child: ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  scrollDirection: Axis.horizontal,
                  primary: false,
                  physics: const BouncingScrollPhysics(),
                  itemCount: _featuredHotels.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 16),
                  itemBuilder: (context, index) {
                    final hotel = _featuredHotels[index];
                    return _buildHotelCard(hotel);
                  },
                ),
              ),
              const SizedBox(height: 24),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: _buildSectionHeader(
                  'Popular destinations',
                  onTap: () {},
                ),
              ),
              const SizedBox(height: 14),
              SizedBox(
                height: 190,
                child: ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  scrollDirection: Axis.horizontal,
                  primary: false,
                  physics: const BouncingScrollPhysics(),
                  itemCount: topCountries.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 16),
                  itemBuilder: (context, index) {
                    final country = topCountries[index];
                    return _buildCountrySuggestionCard(country);
                  },
                ),
              ),
              const SizedBox(height: 24),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: _buildSectionHeader('Top experiences', onTap: () {}),
              ),
              const SizedBox(height: 14),
              SizedBox(
                height: 240,
                child: ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  scrollDirection: Axis.horizontal,
                  primary: false,
                  physics: const BouncingScrollPhysics(),
                  itemCount: _homepageExperiences.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 16),
                  itemBuilder: (context, index) {
                    final experience = _homepageExperiences[index];
                    return _buildExperienceSuggestionCard(experience);
                  },
                ),
              ),
              const SizedBox(height: 24),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: _buildSectionHeader('Upcoming events', onTap: () {}),
              ),
              const SizedBox(height: 14),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  children: featuredEvents.map(_buildEventCard).toList(),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, {VoidCallback? onTap}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: AppTextStyles.headingLarge),
        GestureDetector(
          onTap: onTap,
          child: Row(
            children: const [
              Text(
                'See all',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primary,
                ),
              ),
              SizedBox(width: 6),
              Icon(Icons.arrow_forward_ios, size: 12, color: AppColors.primary),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildFlightDealCard(Map<String, String> deal) {
    return Container(
      width: 260,
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: AppColors.textPrimary.withOpacity(0.08),
            blurRadius: 18,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Stack(
                children: [
                  Positioned.fill(
                    child: Image.network(deal['image']!, fit: BoxFit.cover),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.black.withOpacity(0.35),
                          Colors.transparent,
                        ],
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                      ),
                    ),
                  ),
                  Positioned(
                    left: 16,
                    right: 16,
                    bottom: 16,
                    child: Text(
                      deal['route']!,
                      style: AppTextStyles.headingSmall.copyWith(
                        color: AppColors.textLight,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 14.0,
                vertical: 14.0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    deal['dates']!,
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    deal['price']!,
                    style: AppTextStyles.headingSmall.copyWith(
                      color: AppColors.primary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCountrySuggestionCard(CountryData country) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        width: 155,
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: AppColors.textPrimary.withOpacity(0.08),
              blurRadius: 18,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Image.network(
                  country.image,
                  fit: BoxFit.cover,
                  width: double.infinity,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12.0,
                  vertical: 12.0,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(country.name, style: AppTextStyles.headingSmall),
                    const SizedBox(height: 4),
                    Text(
                      '${country.cityCount} cities',
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildExperienceSuggestionCard(ExperienceDestination experience) {
    return Container(
      width: 180,
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: AppColors.textPrimary.withOpacity(0.08),
            blurRadius: 18,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
            child: Image.network(
              experience.image,
              fit: BoxFit.cover,
              width: double.infinity,
              height: 120,
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 12, 12, 14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(experience.title, style: AppTextStyles.headingSmall),
                const SizedBox(height: 6),
                Text(
                  experience.location,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.star, size: 14, color: AppColors.primary),
                    const SizedBox(width: 6),
                    Text(
                      experience.rating.toStringAsFixed(1),
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHotelCard(Map<String, String> hotel) {
    return Container(
      width: 210,
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: AppColors.textPrimary.withOpacity(0.08),
            blurRadius: 18,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
            child: Image.network(
              hotel['image']!,
              fit: BoxFit.cover,
              width: double.infinity,
              height: 120,
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 12, 12, 14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(hotel['name']!, style: AppTextStyles.headingSmall),
                const SizedBox(height: 4),
                Text(
                  hotel['location']!,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      hotel['price']!,
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.primary,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.star,
                            size: 14,
                            color: AppColors.primary,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            hotel['rating']!,
                            style: AppTextStyles.bodySmall.copyWith(
                              color: AppColors.primary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEventCard(DestinationEvent event) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.textPrimary.withOpacity(0.06),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Image.network(
              event.image,
              width: 88,
              height: 88,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(event.title, style: AppTextStyles.bodyLarge),
                const SizedBox(height: 6),
                Text(
                  event.dateRange,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  event.location,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.14),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              event.category,
              style: AppTextStyles.bodySmall.copyWith(color: AppColors.primary),
            ),
          ),
        ],
      ),
    );
  }
}
