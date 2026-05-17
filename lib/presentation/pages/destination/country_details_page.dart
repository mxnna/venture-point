import 'package:flutter/material.dart';
import 'package:venturepoint/core/theme/app_colors.dart';
import 'package:venturepoint/core/theme/app_text_styles.dart';

import '../trips/city_details_view.dart';
import 'destination_data.dart';

enum CountryTab { overview, hotels, flights }

class CountryDetailsPage extends StatefulWidget {
  final CountryData country;
  const CountryDetailsPage({super.key, required this.country});

  @override
  State<CountryDetailsPage> createState() => _CountryDetailsPageState();
}

class _CountryDetailsPageState extends State<CountryDetailsPage> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: CountryTab.values.length,
      child: Scaffold(
        backgroundColor: AppColors.secondary,
        body: SafeArea(
          child: NestedScrollView(
            headerSliverBuilder: (context, innerBoxIsScrolled) {
              return [
                SliverToBoxAdapter(child: _buildHero()),
                SliverToBoxAdapter(child: const SizedBox(height: 8)),
                SliverPersistentHeader(
                  pinned: true,
                  delegate: _CountryTabBarDelegate(child: _buildTabBar()),
                ),
                SliverToBoxAdapter(child: const SizedBox(height: 12)),
              ];
            },
            body: TabBarView(
              children: [
                _buildOverviewContent(),
                _buildHotelsContent(),
                _buildFlightsContent(),
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
          height: 220,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: NetworkImage(widget.country.image),
              fit: BoxFit.cover,
            ),
          ),
        ),
        Container(
          height: 220,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Colors.black.withAlpha(18), Colors.black.withAlpha(140)],
            ),
          ),
        ),
        Positioned(
          left: 16,
          right: 16,
          top: 8,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildBackButton(context),
              Row(
                children: [
                  _buildActionButton(icon: Icons.share_outlined, onTap: () {}),
                  const SizedBox(width: 8),
                  _buildFavoriteButton(),
                ],
              ),
            ],
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
                widget.country.name,
                style: AppTextStyles.displaySmall.copyWith(
                  color: AppColors.white,
                  shadows: const [
                    Shadow(
                      blurRadius: 12,
                      color: Colors.black45,
                      offset: Offset(0, 1.5),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Text(
                    widget.country.flag,
                    style: const TextStyle(fontSize: 22),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    widget.country.region,
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.white,
                    ),
                  ),
                  const SizedBox(width: 18),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.white.withAlpha(41),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.star,
                          color: AppColors.warning,
                          size: 14,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          widget.country.rating.toStringAsFixed(1),
                          style: AppTextStyles.bodySmall.copyWith(
                            color: AppColors.white,
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
    );
  }

  Widget _buildBackButton(BuildContext context) {
    return InkWell(
      onTap: () => Navigator.of(context).pop(),
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: AppColors.white.withAlpha(204),
          borderRadius: BorderRadius.circular(14),
        ),
        child: const Icon(Icons.arrow_back_ios_new, size: 16),
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: AppColors.white.withAlpha(204),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Icon(icon, size: 16, color: AppColors.textPrimary),
      ),
    );
  }

  Widget _buildFavoriteButton() {
    return _buildActionButton(icon: Icons.favorite_border, onTap: () {});
  }

  Widget _buildTabBar() {
    return Container(
      color: AppColors.secondary,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: TabBar(
        padding: EdgeInsets.zero,
        isScrollable: false,
        dividerColor: Colors.transparent,
        labelPadding: const EdgeInsets.symmetric(vertical: 4),
        indicatorPadding: EdgeInsets.zero,
        labelColor: AppColors.primary,
        unselectedLabelColor: AppColors.textSecondary,
        indicatorColor: AppColors.primary,
        indicatorSize: TabBarIndicatorSize.label,
        indicatorWeight: 3,
        overlayColor: const WidgetStatePropertyAll<Color?>(Colors.transparent),
        labelStyle: AppTextStyles.bodyLarge.copyWith(
          fontWeight: FontWeight.w700,
        ),
        unselectedLabelStyle: AppTextStyles.bodyLarge.copyWith(
          fontWeight: FontWeight.w500,
        ),
        tabs: CountryTab.values.map((tab) {
          return Tab(text: _tabLabel(tab));
        }).toList(),
      ),
    );
  }

  String _tabLabel(CountryTab tab) {
    switch (tab) {
      case CountryTab.overview:
        return 'Overview';
      case CountryTab.hotels:
        return 'Hotels';
      case CountryTab.flights:
        return 'Flights';
    }
  }

  Widget _buildOverviewContent() {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'About ${widget.country.name}',
            style: AppTextStyles.headingLarge,
          ),
          const SizedBox(height: 12),
          Text(
            widget.country.description,
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'Read more',
            style: AppTextStyles.labelLarge.copyWith(color: AppColors.primary),
          ),
          const SizedBox(height: 28),
          _buildSectionHeader('Quick facts'),
          const SizedBox(height: 16),
          _buildQuickFacts(),
          const SizedBox(height: 28),
          _buildSectionHeader('Categories'),
          const SizedBox(height: 16),
          _buildCategories(),
          const SizedBox(height: 24),
          _buildSectionHeader('Top cities', showSeeAll: true),
          const SizedBox(height: 16),
          _buildCityList(),
          const SizedBox(height: 28),
          _buildSectionHeader('Travel guide'),
          const SizedBox(height: 16),
          _buildTravelGuide(),
        ],
      ),
    );
  }

  Widget _buildHotelsContent() {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(24, 0, 24, 16),
      child: _buildPlaceholderCard(
        title: 'Find hotels in ${widget.country.name}',
        subtitle: 'Explore curated stays, luxury resorts, and guest favorites.',
        icon: Icons.apartment,
      ),
    );
  }

  Widget _buildFlightsContent() {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(24, 0, 24, 16),
      child: _buildPlaceholderCard(
        title: 'Search flights to ${widget.country.name}',
        subtitle: 'Compare fares for direct and connecting routes.',
        icon: Icons.flight,
      ),
    );
  }

  Widget _buildSectionHeader(String title, {bool showSeeAll = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: AppTextStyles.headingLarge),
        if (showSeeAll)
          GestureDetector(
            onTap: () {},
            child: Row(
              children: [
                Text(
                  'See all',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(width: 6),
                const Icon(
                  Icons.arrow_forward_ios,
                  size: 12,
                  color: AppColors.primary,
                ),
              ],
            ),
          ),
      ],
    );
  }

  Widget _buildQuickFacts() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: widget.country.quickFacts.map((fact) {
        return SizedBox(
          width: 80,
          height: 95,
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: AppColors.textPrimary.withAlpha(10),
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(fact.icon, color: const Color(0xFF808080), size: 20),
                const SizedBox(height: 6),
                Text(
                  fact.label,
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.caption.copyWith(
                    fontWeight: FontWeight.w500,
                    fontSize: 9,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  fact.value,
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.bodySmall.copyWith(
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildTravelGuide() {
    return Column(
      children: [
        ...widget.country.travelGuide.asMap().entries.map((entry) {
          final index = entry.key;
          final guide = entry.value;
          final isLast = index == widget.country.travelGuide.length - 1;

          return Column(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 16,
                ),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.textPrimary.withAlpha(10),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF0F0F0),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        guide.icon,
                        color: const Color(0xFF808080),
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            guide.label,
                            style: AppTextStyles.bodyMedium.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            guide.description,
                            style: AppTextStyles.bodySmall.copyWith(
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    Icon(
                      Icons.arrow_forward_ios,
                      size: 16,
                      color: AppColors.textSecondary,
                    ),
                  ],
                ),
              ),
              if (!isLast) const SizedBox(height: 12),
            ],
          );
        }),
      ],
    );
  }

  Widget _buildCategories() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final spacing = 12.0;
        final crossAxisCount = 4;
        final itemWidth =
            (constraints.maxWidth - spacing * (crossAxisCount - 1)) /
            crossAxisCount;

        return Wrap(
          spacing: spacing,
          runSpacing: 8.0,
          children: destinationCategories.map((category) {
            return SizedBox(
              width: itemWidth,
              child: Material(
                color: category.cardColor,
                borderRadius: BorderRadius.circular(18),
                child: InkWell(
                  borderRadius: BorderRadius.circular(18),
                  onTap: () {},
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 8,
                      horizontal: 10,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ShaderMask(
                          blendMode: BlendMode.srcIn,
                          shaderCallback: (bounds) => LinearGradient(
                            colors: category.iconGradientColors,
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ).createShader(bounds),
                          child: Icon(
                            category.icon,
                            size: 24,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          category.label,
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: AppTextStyles.caption.copyWith(
                            color: category.labelColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        );
      },
    );
  }

  Widget _buildCityList() {
    return SizedBox(
      height: 175,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: widget.country.topCities.length,
        separatorBuilder: (context, index) => const SizedBox(width: 16),
        itemBuilder: (context, index) {
          final city = widget.country.topCities[index];
          return _buildCityCard(context, city);
        },
      ),
    );
  }

  Widget _buildCityCard(BuildContext context, CityData city) {
    return GestureDetector(
      onTap: () {
        Navigator.of(
          context,
        ).push(MaterialPageRoute(builder: (_) => CityDetailsPage(city: city)));
      },
      child: Container(
        width: 142,
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(22),
          boxShadow: [
            BoxShadow(
              color: AppColors.textPrimary.withAlpha(15),
              blurRadius: 18,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(22),
              ),
              child: SizedBox(
                height: 100,
                width: 142,
                child: Image.network(
                  city.image,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: AppColors.secondary,
                      child: const Icon(
                        Icons.broken_image,
                        color: AppColors.textSecondary,
                        size: 28,
                      ),
                    );
                  },
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    city.name,
                    style: AppTextStyles.bodyMedium,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    softWrap: false,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    city.country,
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.textSecondary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlaceholderCard({
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
            color: AppColors.textPrimary.withAlpha(15),
            blurRadius: 18,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppColors.primary.withAlpha(31),
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
          ElevatedButton(onPressed: () {}, child: const Text('View')),
        ],
      ),
    );
  }
}

class _CountryTabBarDelegate extends SliverPersistentHeaderDelegate {
  final Widget child;

  _CountryTabBarDelegate({required this.child});

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return SizedBox(
      height: maxExtent,
      child: Container(color: AppColors.secondary, child: child),
    );
  }

  @override
  double get maxExtent => 48;

  @override
  double get minExtent => 48;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return false;
  }
}
