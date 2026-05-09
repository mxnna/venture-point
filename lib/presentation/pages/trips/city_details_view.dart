import 'package:flutter/material.dart';
import 'package:venturepoint/core/theme/app_colors.dart';
import 'package:venturepoint/core/theme/app_text_styles.dart';

import '../destination/destination_data.dart';

enum CityTab { overview, hotels, flights, experiences, events }

class CityDetailsPage extends StatefulWidget {
  final CityData city;
  const CityDetailsPage({super.key, required this.city});

  @override
  State<CityDetailsPage> createState() => _CityDetailsPageState();
}

class _CityDetailsPageState extends State<CityDetailsPage> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: CityTab.values.length,
      child: Scaffold(
        backgroundColor: AppColors.secondary,
        body: SafeArea(
          child: NestedScrollView(
            headerSliverBuilder: (context, innerBoxIsScrolled) {
              return [
                SliverToBoxAdapter(child: _buildHero()),
                SliverToBoxAdapter(child: const SizedBox(height: 8)),
                SliverToBoxAdapter(child: _buildTabBar()),
                SliverToBoxAdapter(child: const SizedBox(height: 12)),
              ];
            },
            body: TabBarView(
              children: [
                _buildOverviewContent(),
                _buildHotelsContent(),
                _buildFlightsContent(),
                _buildExperiencesContent(),
                _buildEventsContent(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHero() {
    return Stack(
      children: [
        Container(
          height: 200,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: NetworkImage(widget.city.image),
              fit: BoxFit.cover,
            ),
          ),
        ),
        Container(
          height: 200,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.black.withOpacity(0.12),
                Colors.black.withOpacity(0.46),
              ],
            ),
          ),
        ),
        Positioned(
          left: 16,
          right: 16,
          top: 8,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [_buildBackButton(), _buildFavoriteButton()],
          ),
        ),
        Positioned(
          left: 16,
          right: 16,
          bottom: 12,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.city.name,
                style: AppTextStyles.displaySmall.copyWith(
                  color: AppColors.white,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Text(
                    widget.city.country,
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.white,
                    ),
                  ),
                  const SizedBox(width: 16),
                  const Icon(Icons.star, color: AppColors.primary, size: 18),
                  const SizedBox(width: 4),
                  Text(
                    widget.city.rating.toStringAsFixed(1),
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.white,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildBackButton() {
    return InkWell(
      onTap: () => Navigator.of(context).pop(),
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: AppColors.white.withOpacity(0.85),
          borderRadius: BorderRadius.circular(14),
        ),
        child: const Icon(Icons.arrow_back_ios_new, size: 16),
      ),
    );
  }

  Widget _buildFavoriteButton() {
    return Container(
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: AppColors.white.withOpacity(0.85),
        borderRadius: BorderRadius.circular(14),
      ),
      child: const Icon(Icons.favorite_border, size: 16),
    );
  }

  Widget _buildTabBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: TabBar(
        padding: EdgeInsets.zero,
        isScrollable: true,
        dividerColor: Colors.transparent,
        labelPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
        indicatorPadding: EdgeInsets.zero,
        tabAlignment: TabAlignment.start,
        labelColor: AppColors.primary,
        unselectedLabelColor: AppColors.textSecondary,
        indicatorColor: AppColors.primary,
        indicatorSize: TabBarIndicatorSize.label,
        indicatorWeight: 3,
        overlayColor: const WidgetStatePropertyAll<Color?>(Colors.transparent),
        labelStyle: const TextStyle(fontWeight: FontWeight.w700),
        unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w500),
        tabs: CityTab.values.map((tab) => Tab(text: _tabLabel(tab))).toList(),
      ),
    );
  }

  String _tabLabel(CityTab tab) {
    switch (tab) {
      case CityTab.overview:
        return 'Overview';
      case CityTab.hotels:
        return 'Hotels';
      case CityTab.flights:
        return 'Flights';
      case CityTab.experiences:
        return 'Experiences';
      case CityTab.events:
        return 'Events';
    }
  }

  Widget _buildOverviewContent() {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(24, 0, 24, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // About Section
          _buildAboutSection(),
          const SizedBox(height: 32),

          // Things to do all year
          _buildThingsToDoSection(),
          const SizedBox(height: 32),

          // Upcoming Events
          _buildUpcomingEventsSection(),
        ],
      ),
    );
  }

  Widget _buildAboutSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('About ${widget.city.name}', style: AppTextStyles.headingSmall),
        const SizedBox(height: 12),
        Text(
          widget.city.description,
          style: AppTextStyles.bodyMedium.copyWith(
            color: AppColors.textSecondary,
          ),
          maxLines: 3,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 12),
        GestureDetector(
          onTap: () {
            // Handle "Read more" tap
          },
          child: Text(
            'Read more',
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildThingsToDoSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Things to do all year', style: AppTextStyles.headingSmall),
        const SizedBox(height: 16),
        // Category filter chips
        SizedBox(
          height: 36,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              _buildCategoryChip('All', isSelected: true),
              const SizedBox(width: 8),
              _buildCategoryChip('History'),
              const SizedBox(width: 8),
              _buildCategoryChip('Culture'),
              const SizedBox(width: 8),
              _buildCategoryChip('Adventure'),
              const SizedBox(width: 8),
              _buildCategoryChip('Nature'),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Column(
          children: widget.city.experiences.map(_buildExperienceCard).toList(),
        ),
      ],
    );
  }

  Widget _buildCategoryChip(String label, {bool isSelected = false}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: isSelected ? AppColors.primary : AppColors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: isSelected
              ? Colors.transparent
              : AppColors.textSecondary.withOpacity(0.16),
        ),
      ),
      child: Text(
        label,
        style: AppTextStyles.bodySmall.copyWith(
          color: isSelected ? AppColors.white : AppColors.textPrimary,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildExperienceCard(ExperienceDestination experience) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.textPrimary.withOpacity(0.06),
            blurRadius: 14,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.horizontal(
              left: Radius.circular(20),
            ),
            child: Image.network(
              experience.image,
              width: 100,
              height: 110,
              fit: BoxFit.cover,
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(14, 14, 10, 14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    experience.title,
                    style: AppTextStyles.bodyLarge,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    experience.subtitle,
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.textSecondary,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      _experienceCategory(experience),
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 12, top: 12),
            child: Icon(
              Icons.bookmark_border,
              color: AppColors.textSecondary,
              size: 22,
            ),
          ),
        ],
      ),
    );
  }

  String _experienceCategory(ExperienceDestination experience) {
    final title = experience.title.toLowerCase();
    if (title.contains('museum') ||
        title.contains('history') ||
        title.contains('pyramids')) {
      return 'History';
    }
    if (title.contains('cruise') ||
        title.contains('river') ||
        title.contains('adventure')) {
      return 'Adventure';
    }
    if (title.contains('market') ||
        title.contains('bazaar') ||
        title.contains('temple') ||
        title.contains('shrine')) {
      return 'Culture';
    }
    return 'Nature';
  }

  Widget _buildUpcomingEventsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Upcoming events', style: AppTextStyles.headingSmall),
        const SizedBox(height: 16),
        // Category filter chips
        SizedBox(
          height: 36,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              _buildCategoryChip('All', isSelected: true),
              const SizedBox(width: 8),
              _buildCategoryChip('Exhibitions'),
              const SizedBox(width: 8),
              _buildCategoryChip('Workshops'),
              const SizedBox(width: 8),
              _buildCategoryChip('Concerts'),
              const SizedBox(width: 8),
              _buildCategoryChip('Festivals'),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Column(children: widget.city.events.map(_buildEventCard).toList()),
      ],
    );
  }

  Widget _buildHotelsContent() {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(24, 0, 24, 16),
      child: _buildActionSpot(
        title: 'Stay near the city center',
        subtitle: 'Hotels and resorts with easy access to attractions.',
        icon: Icons.bed,
      ),
    );
  }

  Widget _buildFlightsContent() {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(24, 0, 24, 16),
      child: _buildActionSpot(
        title: 'Book flights to ${widget.city.name}',
        subtitle: 'Choose direct flights or easy layovers.',
        icon: Icons.flight,
      ),
    );
  }

  Widget _buildExperiencesContent() {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(24, 0, 24, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Things to do all year', style: AppTextStyles.headingLarge),
          const SizedBox(height: 18),
          SizedBox(
            height: 40,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: 5,
              padding: const EdgeInsets.only(left: 2),
              separatorBuilder: (_, __) => const SizedBox(width: 10),
              itemBuilder: (context, index) {
                const labels = [
                  'All',
                  'History',
                  'Culture',
                  'Adventure',
                  'Nature',
                ];
                return _buildCategoryChip(
                  labels[index],
                  isSelected: index == 0,
                );
              },
            ),
          ),
          const SizedBox(height: 18),
          Column(
            children: widget.city.experiences
                .map(_buildExperienceCard)
                .toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildEventsContent() {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(24, 0, 24, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Upcoming events', style: AppTextStyles.headingLarge),
          const SizedBox(height: 18),
          SizedBox(
            height: 40,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: 5,
              padding: const EdgeInsets.only(left: 2),
              separatorBuilder: (_, __) => const SizedBox(width: 10),
              itemBuilder: (context, index) {
                const labels = [
                  'All',
                  'Exhibitions',
                  'Workshops',
                  'Concerts',
                  'Festivals',
                ];
                return _buildCategoryChip(
                  labels[index],
                  isSelected: index == 0,
                );
              },
            ),
          ),
          const SizedBox(height: 18),
          Column(children: widget.city.events.map(_buildEventCard).toList()),
        ],
      ),
    );
  }

  Widget _buildActionSpot({
    required String title,
    required String subtitle,
    required IconData icon,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: AppColors.textPrimary.withOpacity(0.06),
            blurRadius: 18,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.12),
              borderRadius: BorderRadius.circular(18),
            ),
            child: Icon(icon, color: AppColors.primary, size: 24),
          ),
          const SizedBox(width: 18),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: AppTextStyles.headingSmall),
                const SizedBox(height: 6),
                Text(
                  subtitle,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          ElevatedButton(onPressed: () {}, child: const Text('Search')),
        ],
      ),
    );
  }

  Widget _buildEventCard(DestinationEvent event) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      height: 118,
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.textPrimary.withOpacity(0.05),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.horizontal(
              left: Radius.circular(20),
            ),
            child: SizedBox(
              width: 110,
              height: double.infinity,
              child: event.image.isNotEmpty
                  ? Image.network(
                      event.image,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: AppColors.secondaryDark,
                          child: const Icon(
                            Icons.image_not_supported,
                            color: AppColors.textSecondary,
                            size: 30,
                          ),
                        );
                      },
                    )
                  : Container(
                      color: AppColors.secondaryDark,
                      child: const Icon(
                        Icons.image_not_supported,
                        color: AppColors.textSecondary,
                        size: 30,
                      ),
                    ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(14, 10, 10, 10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        event.title,
                        style: AppTextStyles.bodyLarge.copyWith(fontSize: 15),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        event.location,
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.textSecondary,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          event.dateRange,
                          style: AppTextStyles.captionSmall.copyWith(
                            color: AppColors.textSecondary,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.secondaryDark,
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Text(
                          event.category,
                          style: AppTextStyles.captionSmall.copyWith(
                            color: AppColors.textPrimary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 12, top: 12),
            child: Icon(
              Icons.bookmark_border,
              color: AppColors.textSecondary,
              size: 22,
            ),
          ),
        ],
      ),
    );
  }
}
