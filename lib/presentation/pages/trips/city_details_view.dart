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
        ],
      ),
    );
  }

  Widget _buildGettingAroundSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Getting around', style: AppTextStyles.headingLarge),
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
            color: AppColors.textPrimary.withOpacity(0.05),
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
              color: AppColors.textSecondary.withOpacity(0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              transport['icon'] as IconData,
              color: AppColors.textSecondary.withOpacity(0.85),
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
              color: AppColors.textSecondary.withOpacity(0.85),
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
      'price': 'EGP 6 – 20',
    },
    {
      'icon': Icons.car_rental,
      'label': 'Uber / Careem',
      'subtitle': 'Convenient & safe',
      'price': 'From EGP 40',
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
      'price': 'EGP 5 – 10',
    },
    {
      'icon': Icons.sailing,
      'label': 'Nile Ferry',
      'subtitle': 'Scenic way across the Nile',
      'price': 'EGP 5 – 15',
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
            separatorBuilder: (_, __) => const SizedBox(width: 16),
            itemBuilder: (context, index) {
              return _buildDishCard(_mustTryDishes[index]);
            },
          ),
        ),
        const SizedBox(height: 24),
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
            separatorBuilder: (_, __) => const SizedBox(width: 16),
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
        border: Border.all(color: AppColors.textPrimary.withOpacity(0.08)),
        boxShadow: [
          BoxShadow(
            color: AppColors.textPrimary.withOpacity(0.03),
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
                Image.network(
                  dish['image']!,
                  width: 170,
                  height: 130,
                  fit: BoxFit.cover,
                ),
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  height: 44,
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withOpacity(0.3),
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

  List<Map<String, String>> get _mustTryDishes =>
      _mustTryDishesForCountry(widget.city.country);

  List<Map<String, String>> get _diningAtmosphere =>
      _diningAtmosphereForCountry(widget.city.country);

  Widget _buildDiningAtmosphereCard(Map<String, String> item) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: Container(
        width: 220,
        height: 180,
        decoration: BoxDecoration(
          color: AppColors.white,
          border: Border.all(color: AppColors.textPrimary.withOpacity(0.08)),
          boxShadow: [
            BoxShadow(
              color: AppColors.textPrimary.withOpacity(0.03),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Stack(
          children: [
            Positioned.fill(
              child: Image.network(item['image']!, fit: BoxFit.cover),
            ),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.transparent, Colors.black.withOpacity(0.35)],
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
            Text('Local culture', style: AppTextStyles.headingLarge),
            Text(
              'Learn more',
              style: AppTextStyles.bodySmall.copyWith(
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
            color: AppColors.textPrimary.withOpacity(0.05),
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
              color: AppColors.textSecondary.withOpacity(0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              _cultureHighlightIcon(item['label']!),
              color: AppColors.textSecondary.withOpacity(0.85),
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

  List<Map<String, String>> get _cultureHighlights =>
      _cultureHighlightsForCountry(widget.city.country);

  Widget _buildEssentialInfoSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Essential info', style: AppTextStyles.headingLarge),
            Text(
              'View all',
              style: AppTextStyles.bodySmall.copyWith(
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
            color: AppColors.textPrimary.withOpacity(0.04),
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
              color: AppColors.textSecondary.withOpacity(0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              _infoIcon(info['label']!),
              color: AppColors.textSecondary.withOpacity(0.85),
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

  List<Map<String, String>> _mustTryDishesForCountry(String country) {
    switch (country.toLowerCase()) {
      case 'japan':
        return [
          {
            'title': 'Sushi',
            'image':
                'https://images.unsplash.com/photo-1553621042-f6e147245754?q=80&w=1470&auto=format&fit=crop',
          },
          {
            'title': 'Ramen',
            'image':
                'https://images.unsplash.com/photo-1516685018646-549d2f91f0a9?q=80&w=1470&auto=format&fit=crop',
          },
          {
            'title': 'Matcha Desserts',
            'image':
                'https://images.unsplash.com/photo-1551024601-bec78aea704b?q=80&w=1470&auto=format&fit=crop',
          },
          {
            'title': 'Izakaya Snacks',
            'image':
                'https://images.unsplash.com/photo-1603086247079-46c4f6475e19?q=80&w=1470&auto=format&fit=crop',
          },
          {
            'title': 'Yakiniku',
            'image':
                'https://images.unsplash.com/photo-1517248135467-4c7edcad34c4?q=80&w=1470&auto=format&fit=crop',
          },
        ];
      case 'france':
        return [
          {
            'title': 'Croissant',
            'image':
                'https://images.unsplash.com/photo-1499636136210-6f4ee915583e?q=80&w=1470&auto=format&fit=crop',
          },
          {
            'title': 'Coq au Vin',
            'image':
                'https://images.unsplash.com/photo-1543353071-873f17a7a088?q=80&w=1470&auto=format&fit=crop',
          },
          {
            'title': 'Cheese Platter',
            'image':
                'https://images.unsplash.com/photo-1517248135467-4c7edcad34c4?q=80&w=1470&auto=format&fit=crop',
          },
          {
            'title': 'Macarons',
            'image':
                'https://images.unsplash.com/photo-1467003909585-2f8a72700288?q=80&w=1470&auto=format&fit=crop',
          },
          {
            'title': 'Baguette',
            'image':
                'https://images.unsplash.com/photo-1509042239860-f550ce710b93?q=80&w=1470&auto=format&fit=crop',
          },
        ];
      case 'egypt':
        return [
          {
            'title': 'Koshary',
            'image':
                'https://kitchen.sayidaty.net/uploads/small/de/de1813a0dac89c5572e9191d77b14e11_w750_h500.jpg',
          },
          {
            'title': 'Kunafa',
            'image':
                'https://www.arabnews.com/sites/default/files/styles/n_670_395/public/main-image/2018/05/27/1201981-948289307.jpg?itok=zMqp-Xrb',
          },
          {
            'title': 'Molokhia',
            'image':
                'https://amazingfoodanddrink.com/wp-content/uploads/2022/09/What-is-Molokhia-1024x640.jpg',
          },
          {
            'title': 'Shawarma',
            'image':
                'https://egyvacations.com/wp-content/uploads/2025/09/Great-picture-of-Egyptian-shawarma-sandwiches.jpg',
          },
          {
            'title': 'Hawawshi',
            'image':
                'https://images.deliveryhero.io/image/hungerstation/restaurant/android_cover_photo/fecc11cf78febb5b0f6a8b3f1f32f399.png',
          },
        ];
      default:
        return [
          {
            'title': 'Street Food Classics',
            'image':
                'https://images.unsplash.com/photo-1540189549336-e6e99c3679fe?q=80&w=1470&auto=format&fit=crop',
          },
          {
            'title': 'Market Snacks',
            'image':
                'https://images.unsplash.com/photo-1504674900247-0877df9cc836?q=80&w=1470&auto=format&fit=crop',
          },
          {
            'title': 'Rooftop Dining',
            'image':
                'https://images.unsplash.com/photo-1498654896293-37aacf113fd9?q=80&w=1470&auto=format&fit=crop',
          },
          {
            'title': 'Café Culture',
            'image':
                'https://images.unsplash.com/photo-1498654896293-37aacf113fd9?q=80&w=1470&auto=format&fit=crop',
          },
          {
            'title': 'Local Markets',
            'image':
                'https://images.unsplash.com/photo-1523986371872-9d3ba2e2f4c6?q=80&w=1470&auto=format&fit=crop',
          },
        ];
    }
  }

  List<Map<String, String>> _diningAtmosphereForCountry(String country) {
    switch (country.toLowerCase()) {
      case 'japan':
        return [
          {
            'title': 'Traditional Tea Houses',
            'image':
                'https://images.unsplash.com/photo-1556910103-1e62f2a8b04e?q=80&w=1470&auto=format&fit=crop',
          },
          {
            'title': 'Sushi Bars',
            'image':
                'https://images.unsplash.com/photo-1546069901-ba9599a7e63c?q=80&w=1470&auto=format&fit=crop',
          },
          {
            'title': 'Izakaya Nights',
            'image':
                'https://images.unsplash.com/photo-1517248135467-4c7edcad34c4?q=80&w=1470&auto=format&fit=crop',
          },
          {
            'title': 'Ramen Shops',
            'image':
                'https://images.unsplash.com/photo-1553621042-f6e147245754?q=80&w=1470&auto=format&fit=crop',
          },
          {
            'title': 'Street Food Markets',
            'image':
                'https://images.unsplash.com/photo-1533777324565-a040eb52fac2?q=80&w=1470&auto=format&fit=crop',
          },
        ];
      case 'france':
        return [
          {
            'title': 'Parisian Bistros',
            'image':
                'https://images.unsplash.com/photo-1504754524776-8f4f37790ca0?q=80&w=1470&auto=format&fit=crop',
          },
          {
            'title': 'Patisseries',
            'image':
                'https://images.unsplash.com/photo-1499636136210-6f4ee915583e?q=80&w=1470&auto=format&fit=crop',
          },
          {
            'title': 'Riverside Dining',
            'image':
                'https://images.unsplash.com/photo-1517248135467-4c7edcad34c4?q=80&w=1470&auto=format&fit=crop',
          },
          {
            'title': 'Wine Bars',
            'image':
                'https://images.unsplash.com/photo-1519241047957-be31d7379a5d?q=80&w=1470&auto=format&fit=crop',
          },
          {
            'title': 'Market Cafés',
            'image':
                'https://images.unsplash.com/photo-1478145046317-39f10e56b5e9?q=80&w=1470&auto=format&fit=crop',
          },
        ];
      case 'egypt':
        return [
          {
            'title': 'Luxury Fine Dining',
            'image':
                'https://www.listonegiordano.com/wp-content/uploads/2025/01/Khufus_Bistro_08.jpg',
          },
          {
            'title': 'Rooftop Nile Dining',
            'image':
                'https://assets.cairo360.com/app/uploads/2022/11/01/Revolving-restaurant-1024x684.jpg',
          },
          {
            'title': 'Historic Cafés',
            'image':
                'https://cairoscene.com/Content/Admin/Uploads/Articles/ArticlesMainPhoto/1154163/7cbb75be-7509-44f1-991c-1cd0d51bef92.jpg',
          },
          {
            'title': 'Street Food Markets',
            'image':
                'https://i0.wp.com/blog.onevasco.com/wp-content/uploads/egypt-food-market.jpg?ssl=1',
          },
          {
            'title': 'Traditional Egyptian Grills',
            'image':
                'https://media.cntraveler.com/photos/656776bdd0d3aebbada692f6/master/w_1600%2Cc_limit/Naguib%2520Mahfouz%2520JULY%252023%2520PR.jpg',
          },
        ];
      default:
        return [
          {
            'title': 'Street Food Markets',
            'image':
                'https://images.unsplash.com/photo-1523986371872-9d3ba2e2f4c6?q=80&w=1470&auto=format&fit=crop',
          },
          {
            'title': 'Rooftop Dining',
            'image':
                'https://images.unsplash.com/photo-1498654896293-37aacf113fd9?q=80&w=1470&auto=format&fit=crop',
          },
          {
            'title': 'Café Culture',
            'image':
                'https://images.unsplash.com/photo-1481833761820-0509d3217039?q=80&w=1470&auto=format&fit=crop',
          },
          {
            'title': 'Market Cafés',
            'image':
                'https://images.unsplash.com/photo-1478145046317-39f10e56b5e9?q=80&w=1470&auto=format&fit=crop',
          },
          {
            'title': 'Global Fine Dining',
            'image':
                'https://images.unsplash.com/photo-1517248135467-4c7edcad34c4?q=80&w=1470&auto=format&fit=crop',
          },
        ];
    }
  }

  List<Map<String, String>> _cultureHighlightsForCountry(String country) {
    switch (country.toLowerCase()) {
      case 'japan':
        return [
          {
            'label': 'Respect',
            'subtitle': 'Bowing is a common greeting in Japan.',
          },
          {
            'label': 'Shoes Off',
            'subtitle': 'Remove shoes before entering homes and temples.',
          },
          {
            'label': 'Quiet Trains',
            'subtitle': 'Keep phone conversations low or avoid them.',
          },
          {
            'label': 'Seasonal Festivals',
            'subtitle': 'Enjoy cherry blossoms and lantern festivals.',
          },
          {
            'label': 'Cash Friendly',
            'subtitle': 'Carry cash even though cards are widely accepted.',
          },
        ];
      case 'france':
        return [
          {
            'label': 'Bon Appétit',
            'subtitle': 'Enjoy long meals with friends and family.',
          },
          {
            'label': 'Bonjour First',
            'subtitle': 'Greet shopkeepers before asking questions.',
          },
          {
            'label': 'Cafe Culture',
            'subtitle': 'Relax in cafés and people-watch.',
          },
          {
            'label': 'Fashion Sense',
            'subtitle': 'Dress smartly in cities like Paris.',
          },
        ];
      case 'egypt':
        return [
          {
            'label': 'Warm Hospitality',
            'subtitle': 'Friendly locals ready to help.',
          },
          {
            'label': 'Dress Modestly',
            'subtitle': 'Cover shoulders at mosques and markets.',
          },
          {
            'label': 'Greetings',
            'subtitle': 'Say "Salam Alaikum" with a smile.',
          },
          {'label': 'Friday', 'subtitle': 'Holiday day, shops may open late.'},
          {'label': 'Tipping', 'subtitle': '10–15% is standard in cafes.'},
          {
            'label': 'Bargaining',
            'subtitle': 'Negotiate prices politely in markets.',
          },
        ];
      default:
        return [
          {
            'label': 'Warm Hospitality',
            'subtitle': 'Respect local customs and be friendly.',
          },
          {
            'label': 'Travel Light',
            'subtitle': 'Pack layers and adapt to changing weather.',
          },
          {
            'label': 'Local Greetings',
            'subtitle': 'Learn a few phrases in the local language.',
          },
          {
            'label': 'Opening Hours',
            'subtitle': 'Check hours for markets, museums, and transport.',
          },
          {
            'label': 'Cash & Cards',
            'subtitle': 'Carry a mix of cash and cards for convenience.',
          },
          {
            'label': 'Stay Aware',
            'subtitle': 'Keep an eye on belongings in busy areas.',
          },
        ];
    }
  }

  List<Map<String, String>> _essentialInfoForCountry(String country) {
    switch (country.toLowerCase()) {
      case 'japan':
        return [
          {
            'label': 'SIM & internet',
            'detail': 'Excellent coverage; prepaid SIM cards are easy to find.',
          },
          {
            'label': 'Currency',
            'detail': 'Japanese Yen (JPY). Many places accept cards.',
          },
          {
            'label': 'Emergency',
            'detail': 'Dial 110 for police, 119 for ambulance/fire.',
          },
          {
            'label': 'Safety',
            'detail': 'Very safe, but keep an eye on belongings in crowds.',
          },
          {
            'label': 'Health',
            'detail': 'Tap water is safe. Pharmacies are widely available.',
          },
          {
            'label': 'Language',
            'detail':
                'Japanese is the local language; English is common in tourist areas.',
          },
        ];
      case 'france':
        return [
          {
            'label': 'SIM & internet',
            'detail': 'Good mobile coverage and free Wi-Fi in many cafés.',
          },
          {
            'label': 'Currency',
            'detail': 'Euro (EUR). Cards are accepted in most places.',
          },
          {
            'label': 'Emergency',
            'detail': 'Dial 112 for police, ambulance, or fire services.',
          },
          {
            'label': 'Safety',
            'detail':
                'Stay aware in busy tourist areas and near transport hubs.',
          },
          {
            'label': 'Health',
            'detail': 'Pharmacies are easy to find; look for the green cross.',
          },
          {
            'label': 'Language',
            'detail':
                'French is spoken everywhere; English is also available in tourist zones.',
          },
        ];
      case 'egypt':
        return [
          {
            'label': 'SIM & internet',
            'detail': 'Good coverage. SIMs available at airports.',
          },
          {
            'label': 'Currency',
            'detail': 'Egyptian Pound (EGP). Cards accepted in most spots.',
          },
          {
            'label': 'Emergency',
            'detail': 'Police 122, Ambulance 123, Tourist Police 126.',
          },
          {
            'label': 'Safety',
            'detail': 'Generally safe, stay aware in busy areas.',
          },
          {
            'label': 'Health',
            'detail': 'Pharmacies are easy to find. Drink bottled water.',
          },
          {
            'label': 'Language',
            'detail': 'Arabic is official. English is common in tourist areas.',
          },
        ];
      default:
        return [
          {
            'label': 'SIM & internet',
            'detail': 'Good coverage. Prepaid SIMs are easy to find.',
          },
          {
            'label': 'Currency',
            'detail': 'Carry local currency and a backup card when possible.',
          },
          {
            'label': 'Emergency',
            'detail': 'Check local emergency numbers before traveling.',
          },
          {
            'label': 'Safety',
            'detail':
                'Stay aware in busy tourist areas and near transport hubs.',
          },
          {
            'label': 'Health',
            'detail': 'Use bottled water if local tap water is uncertain.',
          },
          {
            'label': 'Language',
            'detail': 'Learn a few key phrases in the local language.',
          },
        ];
    }
  }

  List<Map<String, String>> _cityHighlightsForCity(String cityName) {
    switch (cityName.toLowerCase()) {
      case 'kyoto':
        return [
          {
            'title': 'Fushimi Inari Shrine',
            'subtitle': 'Iconic torii gate path',
            'image':
                'https://images.unsplash.com/photo-1709822663068-d74b32e646c5?q=80&w=1470&auto=format&fit=crop',
          },
          {
            'title': 'Bamboo Grove',
            'subtitle': 'Peaceful forest walk',
            'image':
                'https://images.unsplash.com/photo-1632923754832-60642c12a7ed?q=80&w=1470&auto=format&fit=crop',
          },
          {
            'title': 'Kiyomizu-dera',
            'subtitle': 'Temple with mountain views',
            'image':
                'https://images.unsplash.com/photo-1551927055-45d049d1a97d?q=80&w=1470&auto=format&fit=crop',
          },
          {
            'title': 'Gion District',
            'subtitle': 'Geisha streets and wooden machiya',
            'image':
                'https://images.unsplash.com/photo-1562157876-c8015841a0cb?q=80&w=1470&auto=format&fit=crop',
          },
          {
            'title': 'Tea Ceremonies',
            'subtitle': 'Traditional matcha experiences',
            'image':
                'https://images.unsplash.com/photo-1461319806924-8c9353d2c300?q=80&w=1470&auto=format&fit=crop',
          },
        ];
      case 'luxor':
        return [
          {
            'title': 'Valley of the Kings',
            'subtitle': 'Royal tombs & hieroglyphs',
            'image':
                'https://images.unsplash.com/photo-1512580917878-a3bc118d8fe9?q=80&w=1470&auto=format&fit=crop',
          },
          {
            'title': 'Karnak Temple',
            'subtitle': 'Sacred columns and carvings',
            'image':
                'https://images.unsplash.com/photo-1632944398987-494eebe663be?q=80&w=2071&auto=format&fit=crop',
          },
          {
            'title': 'Luxor Temple',
            'subtitle': 'Ancient riverbank sanctuary',
            'image':
                'https://images.unsplash.com/photo-1512453979798-5ea266f8880c?q=80&w=1470&auto=format&fit=crop',
          },
          {
            'title': 'Felucca Ride',
            'subtitle': 'Sunset cruise on the Nile',
            'image':
                'https://images.unsplash.com/photo-1507525428034-b723cf961d3e?q=80&w=1470&auto=format&fit=crop',
          },
          {
            'title': 'West Bank Tombs',
            'subtitle': 'Explore ancient burial sites',
            'image':
                'https://images.unsplash.com/photo-1593098230021-7f2c059daca4?q=80&w=1470&auto=format&fit=crop',
          },
        ];
      case 'paris':
        return [
          {
            'title': 'Eiffel Tower',
            'subtitle': 'Iconic landmark & city views',
            'image':
                'https://images.unsplash.com/photo-1502602898657-3e91760cbb34?q=80&w=1470&auto=format&fit=crop',
          },
          {
            'title': 'Louvre Museum',
            'subtitle': 'World-class art collections',
            'image':
                'https://images.unsplash.com/photo-1511739001486-6bfe10ce785f?q=80&w=1470&auto=format&fit=crop',
          },
          {
            'title': 'Montmartre',
            'subtitle': 'Bohemian neighborhood vibes',
            'image':
                'https://images.unsplash.com/photo-1502602898657-3e91760cbb34?q=80&w=1470&auto=format&fit=crop',
          },
          {
            'title': 'Seine Cruise',
            'subtitle': 'River views & bridges',
            'image':
                'https://images.unsplash.com/photo-1502602898657-3e91760cbb34?q=80&w=1470&auto=format&fit=crop',
          },
          {
            'title': 'Rue Cler Market',
            'subtitle': 'Food stalls & local shopping',
            'image':
                'https://images.unsplash.com/photo-1481833761820-0509d3217039?q=80&w=1470&auto=format&fit=crop',
          },
        ];
      case 'cairo':
        return [
          {
            'title': 'The Egyptian Museum',
            'subtitle': 'History & artifacts',
            'image':
                'https://cdn.gem.eg/media/5742/20221104-dsc_4372-edit-copy.jpeg?ver=2025.10.27.02',
          },
          {
            'title': 'Citadel of Cairo',
            'subtitle': 'Panoramic city views',
            'image':
                'https://egypttourmagic.com/wp-content/uploads/2024/10/The-Citadel-of-Saladin-A-Fortress-of-History-1.jpg',
          },
          {
            'title': 'Pyramids of Giza',
            'subtitle': 'Ancient wonder',
            'image':
                'https://images.unsplash.com/photo-1574864745093-5566c5be5855?q=80&w=2070&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
          },
          {
            'title': 'Nile River',
            'subtitle': 'Iconic waterway',
            'image':
                'https://images.unsplash.com/photo-1609254009350-e8802119df6c?q=80&w=1471&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
          },
          {
            'title': 'Khan El Khalili Bazaar',
            'subtitle': 'Historic market',
            'image':
                'https://upload.wikimedia.org/wikipedia/commons/7/74/%D8%AE%D8%A7%D9%86_%D8%A7%D9%84%D8%AE%D9%84%D9%8A%D9%84%D9%8A_1.jpg',
          },
        ];
      default:
        return [
          {
            'title': 'City Skyline',
            'subtitle': 'A stunning urban panorama',
            'image':
                'https://images.unsplash.com/photo-1505761671935-60b3a7427bad?q=80&w=1470&auto=format&fit=crop',
          },
          {
            'title': 'Historic District',
            'subtitle': 'Classic streets and heritage sites',
            'image':
                'https://images.unsplash.com/photo-1494526585095-c41746248156?q=80&w=1470&auto=format&fit=crop',
          },
          {
            'title': 'Waterfront Views',
            'subtitle': 'Scenic river or seaside walks',
            'image':
                'https://images.unsplash.com/photo-1500530855697-b586d89ba3ee?q=80&w=1470&auto=format&fit=crop',
          },
          {
            'title': 'Local Markets',
            'subtitle': 'Vibrant shopping and street foods',
            'image':
                'https://images.unsplash.com/photo-1498654896293-37aacf113fd9?q=80&w=1470&auto=format&fit=crop',
          },
          {
            'title': 'Art & Culture',
            'subtitle': 'Museums, galleries, and live events',
            'image':
                'https://images.unsplash.com/photo-1510936111840-02b6a7dca23e?q=80&w=1470&auto=format&fit=crop',
          },
        ];
    }
  }

  List<Map<String, String>> get _essentialInfo =>
      _essentialInfoForCountry(widget.city.country);

  Widget _buildCityAtGlanceSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('City highlights', style: AppTextStyles.headingLarge),
            Text(
              'See all',
              style: AppTextStyles.bodySmall.copyWith(
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
            separatorBuilder: (_, __) => const SizedBox(width: 16),
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
        border: Border.all(color: AppColors.textPrimary.withOpacity(0.08)),
        boxShadow: [
          BoxShadow(
            color: AppColors.textPrimary.withOpacity(0.04),
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
            child: Image.network(
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

  List<Map<String, String>> get _glanceHighlights =>
      _cityHighlightsForCity(widget.city.name);

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
          maxLines: 4,
          overflow: TextOverflow.ellipsis,
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
              Icons.favorite_border,
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
              separatorBuilder: (_, _) => const SizedBox(width: 10),
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
              separatorBuilder: (_, _) => const SizedBox(width: 10),
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
      child: Stack(
        children: [
          Row(
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
                  padding: const EdgeInsets.fromLTRB(14, 10, 52, 10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            event.title,
                            style: AppTextStyles.bodyLarge.copyWith(
                              fontSize: 15,
                            ),
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
            ],
          ),
          Positioned(
            top: 12,
            right: 12,
            child: Icon(
              Icons.favorite_border,
              color: AppColors.textSecondary,
              size: 22,
            ),
          ),
        ],
      ),
    );
  }
}
