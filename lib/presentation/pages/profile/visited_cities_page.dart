import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:venturepoint/core/theme/app_colors.dart';
import 'package:venturepoint/presentation/pages/profile/profile_data.dart';

class VisitedCitiesPage extends StatelessWidget {
  static const routeName = '/profile/visited_cities';

  const VisitedCitiesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return Scaffold(
        backgroundColor: AppColors.secondary,
        appBar: AppBar(title: const Text('My cities')),
        body: const Center(child: Text('Please login first')),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.secondary,
      appBar: AppBar(title: const Text('My cities'), centerTitle: false),
      body: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final data = snapshot.data!.data() ?? <String, dynamic>{};
          final visitedIds = Set<String>.from(
            List<String>.from(data['visitedCityIds'] as List<dynamic>? ?? []),
          );
          final visitedCities = visitedIds
              .map((id) => cityById[id])
              .whereType<CityInfo>()
              .toList();

          return Column(
            children: [
              Expanded(
                child: visitedCities.isEmpty
                    ? Center(
                        child: Text(
                          'No cities visited yet. Tap + to add one.',
                          style: TextStyle(color: AppColors.textSecondary),
                        ),
                      )
                    : ListView.separated(
                        padding: const EdgeInsets.all(16),
                        itemCount: visitedCities.length,
                        separatorBuilder: (_, _) => const SizedBox(height: 12),
                        itemBuilder: (context, index) {
                          final city = visitedCities[index];
                          return Material(
                            color: AppColors.white,
                            borderRadius: BorderRadius.circular(16),
                            child: ListTile(
                              leading: CircleAvatar(
                                radius: 26,
                                backgroundColor: AppColors.secondaryDark,
                                child: Text(
                                  city.flag,
                                  style: const TextStyle(fontSize: 24),
                                ),
                              ),
                              title: Text(
                                city.name,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              subtitle: Text(
                                city.countryName,
                                style: const TextStyle(fontSize: 13),
                              ),
                              trailing: const Icon(
                                Icons.arrow_forward_ios,
                                size: 18,
                              ),
                              onTap: () {},
                            ),
                          );
                        },
                      ),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.add),
                    label: const Text('Add cities'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) =>
                              CitySelectionPage(initialSelection: visitedIds),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class CitySelectionPage extends StatefulWidget {
  final Set<String> initialSelection;

  const CitySelectionPage({super.key, required this.initialSelection});

  @override
  State<CitySelectionPage> createState() => _CitySelectionPageState();
}

class _CitySelectionPageState extends State<CitySelectionPage> {
  late final Set<String> _selectedIds;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _selectedIds = {...widget.initialSelection};
  }

  void _toggleCity(String id) {
    setState(() {
      if (_selectedIds.contains(id)) {
        _selectedIds.remove(id);
      } else {
        _selectedIds.add(id);
      }
    });
  }

  Future<void> _saveSelection() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;
    await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
      'visitedCityIds': _selectedIds.toList(),
    }, SetOptions(merge: true));
    if (mounted) {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final filtered = allCities.where((city) {
      return city.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          city.countryName.toLowerCase().contains(_searchQuery.toLowerCase());
    }).toList();

    return Scaffold(
      backgroundColor: AppColors.secondary,
      appBar: AppBar(title: const Text('Add your visits'), centerTitle: true),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: TextField(
              decoration: const InputDecoration(
                hintText: 'Search cities',
                prefixIcon: Icon(Icons.search),
                filled: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(16)),
                ),
              ),
              onChanged: (value) => setState(() => _searchQuery = value),
            ),
          ),
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              itemCount: filtered.length,
              separatorBuilder: (_, _) => const SizedBox(height: 10),
              itemBuilder: (context, index) {
                final city = filtered[index];
                final isSelected = _selectedIds.contains(city.id);
                return Material(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(16),
                  child: ListTile(
                    leading: CircleAvatar(
                      radius: 26,
                      backgroundColor: AppColors.secondaryDark,
                      child: Text(
                        city.flag,
                        style: const TextStyle(fontSize: 24),
                      ),
                    ),
                    title: Text(city.name),
                    subtitle: Text(city.countryName),
                    trailing: Container(
                      decoration: BoxDecoration(
                        color: isSelected
                            ? AppColors.primary
                            : AppColors.secondaryDark,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      child: Text(
                        isSelected ? 'Visited' : 'Visit',
                        style: TextStyle(
                          color: isSelected
                              ? AppColors.white
                              : AppColors.textPrimary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    onTap: () => _toggleCity(city.id),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                onPressed: _saveSelection,
                child: const Text('Save cities'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
