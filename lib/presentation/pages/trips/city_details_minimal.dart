import 'package:cached_network_image/cached_network_image.dart';
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
  CityTab selectedTab = CityTab.overview;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.secondary,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(child: _buildHero()),
            SliverToBoxAdapter(child: const SizedBox(height: 16)),
            SliverToBoxAdapter(child: _buildTabBar()),
            SliverToBoxAdapter(child: const SizedBox(height: 16)),
            SliverToBoxAdapter(child: _buildContent()),
          ],
        ),
      ),
    );
  }

  Widget _buildHero() {
    return Stack(
      children: [
        Container(
          height: 240,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: _cachedImageProvider(widget.city.image),
              fit: BoxFit.cover,
            ),
          ),
        ),
        Container(
          height: 240,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.black.withValues(alpha: 0.12),
                Colors.black.withValues(alpha: 0.46),
              ],
            ),
          ),
        ),
        Positioned(
          left: 24,
          right: 24,
          top: 12,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [_buildBackButton(), _buildFavoriteButton()],
          ),
        ),
        Positioned(
          left: 24,
          right: 24,
          bottom: 18,
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

  ImageProvider _cachedImageProvider(String url) {
    return CachedNetworkImageProvider(url);
  }

  Widget _cachedNetworkImage(
    String url, {
    BoxFit fit = BoxFit.cover,
    double? width,
    double? height,
  }) {
    return CachedNetworkImage(
      imageUrl: url,
      width: width,
      height: height,
      fit: fit,
      placeholder: (_, _) => Container(
        width: width,
        height: height,
        color: AppColors.textPrimary.withValues(alpha: 0.08),
      ),
      errorWidget: (_, _, _) => Container(
        width: width,
        height: height,
        color: AppColors.textPrimary.withValues(alpha: 0.08),
        child: const Icon(Icons.broken_image, color: Colors.grey),
      ),
    );
  }

  Widget _buildBackButton() {
    return InkWell(
      onTap: () => Navigator.of(context).pop(),
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: AppColors.white.withValues(alpha: 0.85),
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Icon(Icons.arrow_back_ios_new, size: 18),
      ),
    );
  }

  Widget _buildFavoriteButton() {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: AppColors.white.withValues(alpha: 0.85),
        borderRadius: BorderRadius.circular(16),
      ),
      child: const Icon(Icons.favorite_border, size: 18),
    );
  }

  Widget _buildTabBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: CityTab.values.map((tab) {
            final title = _tabLabel(tab);
            final selected = tab == selectedTab;
            return Padding(
              padding: const EdgeInsets.only(right: 12),
              child: GestureDetector(
                onTap: () => setState(() => selectedTab = tab),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 8,
                    horizontal: 16,
                  ),
                  decoration: BoxDecoration(
                    color: selected ? AppColors.primary : AppColors.white,
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(
                      color: selected ? AppColors.primary : AppColors.divider,
                    ),
                  ),
                  child: Text(
                    title,
                    style: AppTextStyles.bodySmall.copyWith(
                      color: selected ? AppColors.white : AppColors.textPrimary,
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
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

  Widget _buildContent() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (selectedTab == CityTab.overview) ...[
            _buildAboutSection(),
            const SizedBox(height: 32),
            _buildEssentialInfoSection(),
            const SizedBox(height: 32),
            _buildGettingAroundSection(),
            const SizedBox(height: 32),
            _buildCityAtGlanceSection(),
            const SizedBox(height: 32),
            _buildLocalCultureSection(),
            const SizedBox(height: 32),
            _buildFoodSceneSection(),
          ] else if (selectedTab == CityTab.hotels) ...[
            _buildActionSpot(
              title: 'Stay near the city center',
              subtitle: 'Hotels and resorts with easy access to attractions.',
              icon: Icons.bed,
            ),
          ] else if (selectedTab == CityTab.flights) ...[
            _buildActionSpot(
              title: 'Book flights to ${widget.city.name}',
              subtitle: 'Choose direct flights or easy layovers.',
              icon: Icons.flight,
            ),
          ] else if (selectedTab == CityTab.experiences) ...[
            Text('Things to do all year', style: AppTextStyles.headingLarge),
            const SizedBox(height: 16),
            Column(
              children: widget.city.experiences
                  .map(_buildExperienceTile)
                  .toList(),
            ),
          ] else ...[
            Text('Upcoming events', style: AppTextStyles.headingLarge),
            const SizedBox(height: 16),
            Column(children: widget.city.events.map(_buildEventTile).toList()),
          ],
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _buildAboutSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('About ${widget.city.name}', style: AppTextStyles.headingLarge),
        const SizedBox(height: 12),
        Text(
          widget.city.description,
          style: AppTextStyles.bodyMedium.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }

  Widget _buildGettingAroundSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Getting around', style: AppTextStyles.headingSmall),
            Text(
              'See all',
              style: AppTextStyles.caption.copyWith(
                color: AppColors.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Column(
          children: List.generate(
            _transportOptions.length,
            (index) => Padding(
              padding: EdgeInsets.only(
                bottom: index == _transportOptions.length - 1 ? 0 : 12,
              ),
              child: _buildTransportCard(_transportOptions[index]),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTransportCard(Map<String, Object> transport) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: AppColors.textPrimary.withValues(alpha: 0.05),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.textSecondary.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              transport['icon'] as IconData,
              color: AppColors.textSecondary.withValues(alpha: 0.85),
              size: 20,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  transport['label'] as String,
                  style: AppTextStyles.bodyMedium,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  transport['subtitle'] as String,
                  style: AppTextStyles.captionSmall.copyWith(
                    color: AppColors.textSecondary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Text(
            transport['price'] as String,
            textAlign: TextAlign.right,
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.textSecondary.withValues(alpha: 0.85),
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  List<Map<String, Object>> get _transportOptions => [
    {
      'icon': Icons.train,
      'label': 'Metro',
      'subtitle': 'Fast & affordable',
      'price': 'EGP 10 – 20',
    },
    {
      'icon': Icons.car_rental,
      'label': 'Uber / Careem',
      'subtitle': 'Convenient & safe',
      'price': 'EGP 40+',
    },
    {
      'icon': Icons.local_taxi,
      'label': 'Taxi',
      'subtitle': 'Metered & app-based',
      'price': 'EGP 50+',
    },
    {
      'icon': Icons.directions_bus,
      'label': 'Bus',
      'subtitle': 'Very budget friendly',
      'price': 'EGP 12 – 25',
    },
    {
      'icon': Icons.sailing,
      'label': 'Nile Ferry',
      'subtitle': 'Scenic way across the Nile',
      'price': 'EGP 10 – 30',
    },
    {
      'icon': Icons.directions_walk,
      'label': 'Walking',
      'subtitle': 'Great for short distances',
      'price': 'Free',
    },
  ];

  Widget _buildFoodSceneSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Food scene', style: AppTextStyles.headingSmall),
        const SizedBox(height: 12),
        Text(
          'A clean, curated look at the city’s most iconic dishes and dining spots.',
          style: AppTextStyles.bodyMedium.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Must-try dishes', style: AppTextStyles.headingSmall),
            Text(
              'See all',
              style: AppTextStyles.caption.copyWith(
                color: AppColors.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 220,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: _mustTryDishes.length,
            separatorBuilder: (_, _) => const SizedBox(width: 16),
            itemBuilder: (context, index) {
              return _buildDishCard(_mustTryDishes[index]);
            },
          ),
        ),
        const SizedBox(height: 22),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Dining atmosphere', style: AppTextStyles.headingSmall),
            Text(
              'See all',
              style: AppTextStyles.caption.copyWith(
                color: AppColors.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 180,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: _diningAtmosphere.length,
            separatorBuilder: (_, _) => const SizedBox(width: 16),
            itemBuilder: (context, index) {
              return _buildDiningAtmosphereCard(_diningAtmosphere[index]);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildDishCard(Map<String, String> dish) {
    return Container(
      width: 170,
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.textPrimary.withValues(alpha: 0.08)),
        boxShadow: [
          BoxShadow(
            color: AppColors.textPrimary.withValues(alpha: 0.03),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(24),
              topRight: Radius.circular(24),
            ),
            child: Stack(
              children: [
                _cachedNetworkImage(
                  dish['image']!,
                  width: 170,
                  height: 130,
                  fit: BoxFit.cover,
                ),
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  height: 42,
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withValues(alpha: 0.25),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 14, 14, 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  dish['title']!,
                  style: AppTextStyles.bodyMedium.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                Text(
                  'Traditional favorite',
                  style: AppTextStyles.captionSmall.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<Map<String, String>> get _mustTryDishes => [
    {
      'title': 'Koshary',
      'image':
          'https://images.unsplash.com/photo-1517248135467-4c7edcad34c4?auto=format&fit=crop&w=500&q=80',
    },
    {
      'title': 'Arobi & Taameya',
      'image':
          'https://images.unsplash.com/photo-1543353071-873f17a7a088?auto=format&fit=crop&w=500&q=80',
    },
    {
      'title': 'Molokhia',
      'image':
          'https://images.unsplash.com/photo-1504674900247-0877df9cc836?auto=format&fit=crop&w=500&q=80',
    },
    {
      'title': 'Hawawshi',
      'image':
          'https://images.unsplash.com/photo-1552332386-f8dd00dc2f85?auto=format&fit=crop&w=500&q=80',
    },
    {
      'title': 'Shawarma',
      'image':
          'https://images.unsplash.com/photo-1512058564366-c9e6c7c331ce?auto=format&fit=crop&w=500&q=80',
    },
    {
      'title': 'Kunafa',
      'image':
          'https://images.unsplash.com/photo-1504674900247-0877df9cc836?auto=format&fit=crop&w=500&q=80',
    },
  ];

  List<Map<String, String>> get _diningAtmosphere => [
    {
      'title': 'Rooftop Nile Dining',
      'image':
          'https://images.unsplash.com/photo-1498654896293-37aacf113fd9?auto=format&fit=crop&w=600&q=80',
    },
    {
      'title': 'Historic Cafés',
      'image':
          'https://images.unsplash.com/photo-1541542684-4f4c2a0cf548?auto=format&fit=crop&w=600&q=80',
    },
    {
      'title': 'Street Food Markets',
      'image':
          'https://images.unsplash.com/photo-1511688878350-ce7b6c8e02bb?auto=format&fit=crop&w=600&q=80',
    },
    {
      'title': 'Luxury Fine Dining',
      'image':
          'https://images.unsplash.com/photo-1528605248644-14dd04022da1?auto=format&fit=crop&w=600&q=80',
    },
    {
      'title': 'Traditional Egyptian Grills',
      'image':
          'https://images.unsplash.com/photo-1552332386-f8dd00dc2f85?auto=format&fit=crop&w=600&q=80',
    },
  ];

  Widget _buildDiningAtmosphereCard(Map<String, String> item) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: Container(
        width: 220,
        height: 180,
        decoration: BoxDecoration(
          color: AppColors.white,
          border: Border.all(color: AppColors.textPrimary.withValues(alpha: 0.08)),
          boxShadow: [
            BoxShadow(
              color: AppColors.textPrimary.withValues(alpha: 0.03),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Stack(
          children: [
            Positioned.fill(
              child: _cachedNetworkImage(item['image']!, fit: BoxFit.cover),
            ),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.transparent, Colors.black.withValues(alpha: 0.35)],
                ),
              ),
            ),
            Positioned(
              left: 14,
              right: 14,
              bottom: 14,
              child: Text(
                item['title']!,
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.white,
                  fontWeight: FontWeight.w700,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLocalCultureSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Local culture', style: AppTextStyles.headingSmall),
            Text(
              'Learn more',
              style: AppTextStyles.caption.copyWith(
                color: AppColors.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: _cultureHighlights.map(_buildCultureCard).toList(),
        ),
      ],
    );
  }

  Widget _buildCultureCard(Map<String, String> item) {
    return Container(
      width: 110,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.textPrimary.withValues(alpha: 0.05),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: AppColors.textSecondary.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              _cultureHighlightIcon(item['label']!),
              color: AppColors.textSecondary.withValues(alpha: 0.85),
              size: 18,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            item['label']!,
            style: AppTextStyles.bodySmall,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),
          Text(
            item['subtitle']!,
            style: AppTextStyles.captionSmall.copyWith(
              color: AppColors.textSecondary,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  IconData _cultureHighlightIcon(String label) {
    switch (label) {
      case 'Warm Hospitality':
        return Icons.favorite;
      case 'Dress Code':
        return Icons.checkroom;
      case 'Greetings':
        return Icons.chat;
      case 'Friday':
        return Icons.calendar_today;
      case 'Tipping':
        return Icons.monetization_on;
      case 'Bargaining':
        return Icons.local_atm;
      default:
        return Icons.info;
    }
  }

  List<Map<String, String>> get _cultureHighlights => [
    {'label': 'Warm Hospitality', 'subtitle': 'Friendly locals ready to help.'},
    {
      'label': 'Dress Modestly',
      'subtitle': 'Cover shoulders at mosques and markets.',
    },
    {'label': 'Greetings', 'subtitle': 'Say "Salam Alaikum" with a smile.'},
    {'label': 'Friday', 'subtitle': 'Holiday day, shops may open late.'},
    {'label': 'Tipping', 'subtitle': '10–15% is standard in cafes.'},
    {
      'label': 'Bargaining',
      'subtitle': 'Negotiate prices politely in markets.',
    },
  ];

  Widget _buildEssentialInfoSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Essential info', style: AppTextStyles.headingSmall),
            Text(
              'View all',
              style: AppTextStyles.caption.copyWith(
                color: AppColors.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: _essentialInfo.map(_buildInfoCard).toList(),
        ),
      ],
    );
  }

  Widget _buildInfoCard(Map<String, String> info) {
    return Container(
      width: 110,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.textPrimary.withValues(alpha: 0.04),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: AppColors.textSecondary.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              _infoIcon(info['label']!),
              color: AppColors.textSecondary.withValues(alpha: 0.85),
              size: 18,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            info['label']!,
            style: AppTextStyles.bodySmall,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),
          Text(
            info['detail']!,
            style: AppTextStyles.captionSmall.copyWith(
              color: AppColors.textSecondary,
            ),
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  IconData _infoIcon(String label) {
    switch (label) {
      case 'SIM & internet':
        return Icons.wifi;
      case 'Currency':
        return Icons.currency_exchange;
      case 'Emergency':
        return Icons.call;
      case 'Safety':
        return Icons.shield;
      case 'Health':
        return Icons.health_and_safety;
      case 'Language':
        return Icons.language;
      default:
        return Icons.info;
    }
  }

  List<Map<String, String>> get _essentialInfo => [
    {
      'label': 'SIM & internet',
      'detail': 'Good coverage. SIMs at the airport.',
    },
    {
      'label': 'Currency',
      'detail': 'Egyptian Pound (EGP). Cards accepted widely.',
    },
    {
      'label': 'Emergency',
      'detail': 'Police 122, Ambulance 123, Tourist Police 126.',
    },
    {'label': 'Safety', 'detail': 'Generally safe. Watch pockets in crowds.'},
    {
      'label': 'Health',
      'detail': 'Pharmacies are everywhere. Use bottled water.',
    },
    {
      'label': 'Language',
      'detail': 'Arabic is official. English is common in tourist areas.',
    },
  ];

  Widget _buildCityAtGlanceSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('City highlights', style: AppTextStyles.headingSmall),
            Text(
              'See all',
              style: AppTextStyles.caption.copyWith(
                color: AppColors.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 240,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: _glanceHighlights.length,
            padding: const EdgeInsets.only(right: 6),
            separatorBuilder: (_, _) => const SizedBox(width: 16),
            itemBuilder: (context, index) {
              return _buildGlanceCard(_glanceHighlights[index]);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildGlanceCard(Map<String, String> item) {
    return Container(
      width: 190,
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.textPrimary.withValues(alpha: 0.08)),
        boxShadow: [
          BoxShadow(
            color: AppColors.textPrimary.withValues(alpha: 0.04),
            blurRadius: 18,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(24),
              topRight: Radius.circular(24),
            ),
            child: _cachedNetworkImage(
              item['image']!,
              width: 190,
              height: 140,
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 14, 14, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item['title']!,
                  style: AppTextStyles.bodyLarge.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 6),
                Text(
                  item['subtitle']!,
                  style: AppTextStyles.captionSmall.copyWith(
                    color: AppColors.textSecondary,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<Map<String, String>> get _glanceHighlights => [
    {
      'title': 'Pyramids of Giza',
      'subtitle': 'Ancient wonder',
      'image':
          'https://images.unsplash.com/photo-1549893078-1502b8a9b25c?auto=format&fit=crop&w=800&q=80',
    },
    {
      'title': 'Nile River',
      'subtitle': 'Iconic waterway',
      'image':
          'https://images.unsplash.com/photo-1512453979798-5ea266f8880c?auto=format&fit=crop&w=800&q=80',
    },
    {
      'title': 'Khan El Khalili Bazaar',
      'subtitle': 'Historic market',
      'image':
          'https://images.unsplash.com/photo-1457264635001-828d77a1f0f3?auto=format&fit=crop&w=800&q=80',
    },
    {
      'title': 'The Egyptian Museum',
      'subtitle': 'History & artifacts',
      'image':
          'https://images.unsplash.com/photo-1526481280698-3cfa69e1fb08?auto=format&fit=crop&w=800&q=80',
    },
    {
      'title': 'Citadel of Cairo',
      'subtitle': 'Panoramic city views',
      'image':
          'https://images.unsplash.com/photo-1528909514045-2fa4ac7a08ba?auto=format&fit=crop&w=800&q=80',
    },
  ];

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
            color: AppColors.textPrimary.withValues(alpha: 0.06),
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
              color: AppColors.primary.withValues(alpha: 0.12),
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

  Widget _buildExperienceTile(ExperienceDestination experience) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: AppColors.textPrimary.withValues(alpha: 0.05),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.horizontal(
              left: Radius.circular(22),
            ),
            child: _cachedNetworkImage(
              experience.image,
              width: 110,
              height: 110,
              fit: BoxFit.cover,
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(experience.title, style: AppTextStyles.bodyLarge),
                  const SizedBox(height: 8),
                  Text(
                    experience.subtitle,
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(
                        Icons.star,
                        color: AppColors.primary,
                        size: 16,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        experience.rating.toStringAsFixed(1),
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEventTile(DestinationEvent event) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: AppColors.textPrimary.withValues(alpha: 0.05),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(event.title, style: AppTextStyles.bodyLarge),
          const SizedBox(height: 10),
          Text(
            event.dateRange,
            style: AppTextStyles.bodySmall.copyWith(color: AppColors.primary),
          ),
          const SizedBox(height: 6),
          Text(
            event.location,
            style: AppTextStyles.caption.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Text(
              event.category,
              style: AppTextStyles.caption.copyWith(color: AppColors.primary),
            ),
          ),
        ],
      ),
    );
  }
}
