import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:venturepoint/core/theme/app_colors.dart';
import 'package:venturepoint/core/theme/app_text_styles.dart';
import 'package:venturepoint/presentation/pages/trips/discover_page.dart';
import 'package:venturepoint/presentation/widgets/empty_state_placeholder.dart';

import 'saved_item_model.dart';
import 'saved_item_service.dart';

class SavedItemsPage extends StatefulWidget {
  static const routeName = '/saved';

  const SavedItemsPage({super.key});

  @override
  State<SavedItemsPage> createState() => _SavedItemsPageState();
}

enum _SavedTab { all, destinations, hotels, flights, experiences }

class _SavedItemsPageState extends State<SavedItemsPage> {
  final _savedService = SavedItemService();

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
              Expanded(
                child: StreamBuilder<List<SavedItem>>(
                  stream: _savedService.getSavedItems(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    final savedItems = snapshot.data ?? [];
                    return TabBarView(
                      children: [
                        _buildTabContent(savedItems, _SavedTab.all),
                        _buildTabContent(savedItems, _SavedTab.destinations),
                        _buildTabContent(savedItems, _SavedTab.hotels),
                        _buildTabContent(savedItems, _SavedTab.flights),
                        _buildTabContent(savedItems, _SavedTab.experiences),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTabContent(List<SavedItem> items, _SavedTab tab) {
    final filtered = items.where((item) {
      switch (tab) {
        case _SavedTab.all:
          return true;
        case _SavedTab.destinations:
          return item.type == SavedItemType.country ||
              item.type == SavedItemType.city;
        case _SavedTab.hotels:
          return item.type == SavedItemType.hotel;
        case _SavedTab.flights:
          return item.type == SavedItemType.flight;
        case _SavedTab.experiences:
          return item.type == SavedItemType.experience ||
              item.type == SavedItemType.event;
      }
    }).toList();

    if (filtered.isEmpty) {
      return const _SavedPlaceholder();
    }

    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
      itemCount: filtered.length,
      separatorBuilder: (context, index) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final item = filtered[index];
        return _SavedItemCard(
          item: item,
          onRemove: () => _removeItem(item.id),
          onDetails: () => _openDetails(item),
          onBook: () => _bookItem(item),
          onShare: () => _shareItem(item),
        );
      },
    );
  }

  Future<void> _removeItem(String itemId) async {
    try {
      await _savedService.removeItem(itemId);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Removed from saved items.')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Unable to remove item: $e')));
      }
    }
  }

  void _openDetails(SavedItem item) {
    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (_) => SavedItemDetailsPage(item: item)));
  }

  void _bookItem(SavedItem item) {
    final message = item.type == SavedItemType.flight
        ? 'Start booking your flight now.'
        : item.type == SavedItemType.hotel
        ? 'Start booking your hotel now.'
        : 'Ready to book this trip?';

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  void _shareItem(SavedItem item) {
    Clipboard.setData(
      ClipboardData(text: '${item.title}\n${item.subtitle}\n${item.details}'),
    );
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Saved item copied to clipboard.')),
    );
  }
}

class _SavedItemCard extends StatelessWidget {
  const _SavedItemCard({
    required this.item,
    required this.onRemove,
    required this.onDetails,
    required this.onBook,
    required this.onShare,
  });

  final SavedItem item;
  final VoidCallback onRemove;
  final VoidCallback onDetails;
  final VoidCallback onBook;
  final VoidCallback onShare;

  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: BorderRadius.circular(22),
      color: AppColors.white,
      child: InkWell(
        borderRadius: BorderRadius.circular(22),
        onTap: onDetails,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(22),
              ),
              child: SizedBox(
                height: 190,
                width: double.infinity,
                child: Image.network(
                  item.image,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: AppColors.secondary,
                      child: const Center(
                        child: Icon(
                          Icons.broken_image,
                          color: AppColors.textSecondary,
                          size: 28,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          item.title,
                          style: AppTextStyles.headingSmall,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      IconButton(
                        onPressed: onRemove,
                        icon: const Icon(Icons.delete_outline),
                        color: AppColors.textSecondary,
                        splashRadius: 20,
                        constraints: const BoxConstraints(
                          minWidth: 32,
                          minHeight: 32,
                        ),
                        padding: const EdgeInsets.all(8),
                      ),
                      IconButton(
                        onPressed: onShare,
                        icon: const Icon(Icons.share_outlined),
                        color: AppColors.primary,
                        splashRadius: 20,
                        constraints: const BoxConstraints(
                          minWidth: 32,
                          minHeight: 32,
                        ),
                        padding: const EdgeInsets.all(8),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          item.subtitle,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTextStyles.bodySmall.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ),
                      if (item.price != null)
                        Text(
                          '\$${item.price!.toStringAsFixed(0)}',
                          style: AppTextStyles.headingSmall.copyWith(
                            color: AppColors.primary,
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      TextButton(
                        onPressed: onDetails,
                        style: TextButton.styleFrom(
                          minimumSize: const Size(68, 32),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          visualDensity: VisualDensity.compact,
                        ),
                        child: const Text('Details'),
                      ),
                      const SizedBox(width: 8),
                      TextButton(
                        onPressed: onBook,
                        style: TextButton.styleFrom(
                          minimumSize: const Size(68, 32),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          visualDensity: VisualDensity.compact,
                        ),
                        child: const Text('Book'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SavedItemDetailsPage extends StatelessWidget {
  const SavedItemDetailsPage({required this.item, super.key});

  final SavedItem item;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.secondary,
      appBar: AppBar(
        backgroundColor: AppColors.secondary,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.textPrimary),
        title: Text(
          '${item.type.label} details',
          style: AppTextStyles.headingLarge,
        ),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
          children: [
            const SizedBox(height: 16),
            ClipRRect(
              borderRadius: BorderRadius.circular(24),
              child: Image.network(
                item.image,
                height: 240,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  height: 240,
                  color: AppColors.secondary,
                  child: const Center(
                    child: Icon(
                      Icons.broken_image,
                      color: AppColors.textSecondary,
                      size: 36,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 22),
            Text(item.title, style: AppTextStyles.displaySmall),
            const SizedBox(height: 8),
            Text(
              item.subtitle,
              style: AppTextStyles.bodyLarge.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            if (item.price != null) ...[
              const SizedBox(height: 12),
              Text(
                '\$${item.price!.toStringAsFixed(0)}',
                style: AppTextStyles.headingLarge.copyWith(
                  color: AppColors.primary,
                ),
              ),
            ],
            const SizedBox(height: 16),
            Text(
              item.details.isNotEmpty
                  ? item.details
                  : 'No additional details available.',
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 28),
            ElevatedButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Booking started for ${item.title}.')),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: const Text('Start booking'),
            ),
          ],
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
        Navigator.of(context).pushReplacementNamed(DiscoverPage.routeName);
      },
    );
  }
}
