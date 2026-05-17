import 'package:flutter/material.dart';
import 'package:venturepoint/core/theme/app_colors.dart';
import 'package:venturepoint/core/theme/app_text_styles.dart';
import 'package:venturepoint/presentation/widgets/search_bar.dart';

import '../destination/country_details_page.dart';
import '../destination/destination_data.dart';
import 'city_details_view.dart';
import '../saved/saved_item_model.dart';
import '../saved/saved_item_service.dart';

class DiscoverPage extends StatefulWidget {
  static const routeName = '/discover';

  const DiscoverPage({super.key});

  @override
  State<DiscoverPage> createState() => _DiscoverPageState();
}

class _DiscoverPageState extends State<DiscoverPage> {
  final _savedService = SavedItemService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.secondary,
      body: SafeArea(
        child: StreamBuilder<Set<String>>(
          stream: _savedService.getSavedItemIds(),
          builder: (context, snapshot) {
            final savedIds = snapshot.data ?? {};
            return ListView(
              padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
              children: [
                _buildHeader(context),
                const SizedBox(height: 16),
                _buildSearchRow(context),
                const SizedBox(height: 20),
                _buildSectionHeader('Top countries', onTap: () {}),
                const SizedBox(height: 12),
                SizedBox(
                  height: 190,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: topCountries.length,
                    separatorBuilder: (_, _) => const SizedBox(width: 16),
                    itemBuilder: (context, index) {
                      final country = topCountries[index];
                      return _buildCountryCard(
                        context,
                        country,
                        savedIds.contains(
                          SavedItem.makeDocId(
                            SavedItemType.country,
                            country.name,
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 20),
                _buildSectionHeader('Top cities', onTap: () {}),
                const SizedBox(height: 12),
                SizedBox(
                  height: 190,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: topCities.length,
                    separatorBuilder: (_, _) => const SizedBox(width: 14),
                    itemBuilder: (context, index) {
                      final city = topCities[index];
                      return _buildCityCard(
                        context,
                        city,
                        savedIds.contains(
                          SavedItem.makeDocId(SavedItemType.city, city.name),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 20),
                _buildSectionHeader('Top experiences', onTap: () {}),
                const SizedBox(height: 12),
                SizedBox(
                  height: 190,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: topExperiences.length,
                    separatorBuilder: (_, _) => const SizedBox(width: 16),
                    itemBuilder: (context, index) {
                      final experience = topExperiences[index];
                      return _buildExperienceCard(
                        context,
                        experience,
                        savedIds.contains(
                          SavedItem.makeDocId(
                            SavedItemType.experience,
                            experience.title,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Discover',
          style: AppTextStyles.displaySmall.copyWith(
            color: AppColors.textPrimary,
          ),
        ),
      ],
    );
  }

  Widget _buildSearchRow(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: SearchBarWidget(
            hintText: 'Where to next?',
            onFilterTap: () {},
            backgroundColor: AppColors.white,
            textColor: AppColors.textPrimary,
            hintColor: AppColors.textSecondary,
          ),
        ),
        const SizedBox(width: 14),
        Container(
          width: 52,
          height: 52,
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: AppColors.textPrimary.withOpacity(0.06),
                blurRadius: 12,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.notifications_none,
              color: AppColors.textPrimary,
            ),
          ),
        ),
      ],
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

  Widget _buildCountryCard(
    BuildContext context,
    CountryData country,
    bool isSaved,
  ) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => CountryDetailsPage(country: country),
          ),
        );
      },
      child: Container(
        width: 142,
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(22),
          boxShadow: [
            BoxShadow(
              color: AppColors.textPrimary.withOpacity(0.06),
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
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.network(
                      country.image,
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
                    Positioned(
                      left: 10,
                      top: 10,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.white.withOpacity(0.85),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Text(
                          country.region,
                          style: AppTextStyles.bodySmall.copyWith(
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      right: 8,
                      top: 8,
                      child: CircleAvatar(
                        radius: 16,
                        backgroundColor: AppColors.white,
                        child: IconButton(
                          onPressed: () {
                            _toggleSave(
                              _savedItemFromCountry(country),
                              isSaved,
                            );
                          },
                          icon: Icon(
                            isSaved ? Icons.favorite : Icons.favorite_border,
                            size: 18,
                            color: isSaved
                                ? AppColors.primary
                                : AppColors.textSecondary,
                          ),
                          splashRadius: 20,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 12, 12, 14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(country.name, style: AppTextStyles.headingSmall),
                  const SizedBox(height: 4),
                  Text(
                    '${country.cityCount} cities',
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.textSecondary,
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

  Widget _buildCityCard(BuildContext context, CityData city, bool isSaved) {
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
              color: AppColors.textPrimary.withOpacity(0.06),
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
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.network(
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
                    Positioned(
                      right: 8,
                      top: 8,
                      child: CircleAvatar(
                        radius: 16,
                        backgroundColor: AppColors.white,
                        child: IconButton(
                          onPressed: () {
                            _toggleSave(_savedItemFromCity(city), isSaved);
                          },
                          icon: Icon(
                            isSaved ? Icons.favorite : Icons.favorite_border,
                            size: 18,
                            color: isSaved
                                ? AppColors.primary
                                : AppColors.textSecondary,
                          ),
                          splashRadius: 20,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    city.name,
                    style: AppTextStyles.headingSmall,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    city.country,
                    style: AppTextStyles.bodySmall.copyWith(
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

  Widget _buildExperienceCard(
    BuildContext context,
    ExperienceDestination experience,
    bool isSaved,
  ) {
    return GestureDetector(
      onTap: () {
        final savedItem = _savedItemFromExperience(experience);
        _toggleSave(savedItem, isSaved);
      },
      child: Container(
        width: 142,
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(22),
          boxShadow: [
            BoxShadow(
              color: AppColors.textPrimary.withOpacity(0.06),
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
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.network(
                      experience.image,
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
                    Positioned(
                      right: 8,
                      top: 8,
                      child: CircleAvatar(
                        radius: 16,
                        backgroundColor: AppColors.white,
                        child: IconButton(
                          onPressed: () {
                            _toggleSave(
                              _savedItemFromExperience(experience),
                              isSaved,
                            );
                          },
                          icon: Icon(
                            isSaved ? Icons.favorite : Icons.favorite_border,
                            size: 18,
                            color: isSaved
                                ? AppColors.primary
                                : AppColors.textSecondary,
                          ),
                          splashRadius: 20,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    experience.title,
                    style: AppTextStyles.headingSmall,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    experience.location,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.textSecondary,
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

  Future<void> _toggleSave(SavedItem item, bool isSaved) async {
    try {
      await _savedService.toggleSavedItem(item, isSaved: isSaved);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              isSaved ? 'Removed from saved' : 'Saved to your list',
            ),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Unable to update saved items: $e')),
        );
      }
    }
  }

  SavedItem _savedItemFromCountry(CountryData country) {
    return SavedItem(
      id: SavedItem.makeDocId(SavedItemType.country, country.name),
      title: country.name,
      subtitle: country.region,
      image: country.image,
      type: SavedItemType.country,
      details: country.description,
    );
  }

  SavedItem _savedItemFromCity(CityData city) {
    return SavedItem(
      id: SavedItem.makeDocId(SavedItemType.city, city.name),
      title: city.name,
      subtitle: city.country,
      image: city.image,
      type: SavedItemType.city,
      details: city.description,
    );
  }

  SavedItem _savedItemFromExperience(ExperienceDestination experience) {
    return SavedItem(
      id: SavedItem.makeDocId(SavedItemType.experience, experience.title),
      title: experience.title,
      subtitle: experience.location.isNotEmpty
          ? experience.location
          : experience.subtitle,
      image: experience.image,
      type: SavedItemType.experience,
      details: experience.subtitle,
    );
  }
}
