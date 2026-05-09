import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:venturepoint/core/theme/app_colors.dart';
import 'package:venturepoint/presentation/pages/profile/profile_data.dart';

class VisitedCountriesPage extends StatelessWidget {
  static const routeName = '/profile/visited_countries';

  const VisitedCountriesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return Scaffold(
        backgroundColor: AppColors.secondary,
        appBar: AppBar(title: const Text('My countries')),
        body: const Center(child: Text('Please login first')),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.secondary,
      appBar: AppBar(title: const Text('My countries'), centerTitle: false),
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
          final visitedCodes = Set<String>.from(
            List<String>.from(
              data['visitedCountryCodes'] as List<dynamic>? ?? [],
            ),
          );
          final visitedCountries = visitedCodes
              .map((code) => countryByCode[code])
              .whereType<CountryInfo>()
              .toList();

          return Column(
            children: [
              Expanded(
                child: visitedCountries.isEmpty
                    ? Center(
                        child: Text(
                          'No countries visited yet. Tap + to add one.',
                          style: TextStyle(color: AppColors.textSecondary),
                        ),
                      )
                    : ListView.separated(
                        padding: const EdgeInsets.all(16),
                        itemCount: visitedCountries.length,
                        separatorBuilder: (_, _) => const SizedBox(height: 12),
                        itemBuilder: (context, index) {
                          final country = visitedCountries[index];
                          return Material(
                            color: AppColors.white,
                            borderRadius: BorderRadius.circular(16),
                            child: ListTile(
                              leading: Text(
                                country.flag,
                                style: const TextStyle(fontSize: 26),
                              ),
                              title: Text(
                                country.name,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              subtitle: Text(
                                country.continent,
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
                    label: const Text('Add countries'),
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
                          builder: (_) => CountrySelectionPage(
                            initialSelection: visitedCodes,
                          ),
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

class CountrySelectionPage extends StatefulWidget {
  final Set<String> initialSelection;

  const CountrySelectionPage({super.key, required this.initialSelection});

  @override
  State<CountrySelectionPage> createState() => _CountrySelectionPageState();
}

class _CountrySelectionPageState extends State<CountrySelectionPage> {
  late final Set<String> _selectedCodes;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _selectedCodes = {...widget.initialSelection};
  }

  void _toggleCountry(String code) {
    setState(() {
      if (_selectedCodes.contains(code)) {
        _selectedCodes.remove(code);
      } else {
        _selectedCodes.add(code);
      }
    });
  }

  Future<void> _saveSelection() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;
    await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
      'visitedCountryCodes': _selectedCodes.toList(),
    }, SetOptions(merge: true));
    if (mounted) {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final filtered = allCountries.where((country) {
      return country.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          country.continent.toLowerCase().contains(_searchQuery.toLowerCase());
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
                hintText: 'Search countries',
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
                final country = filtered[index];
                final isSelected = _selectedCodes.contains(country.code);
                return Material(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(16),
                  child: ListTile(
                    leading: Text(
                      country.flag,
                      style: const TextStyle(fontSize: 28),
                    ),
                    title: Text(country.name),
                    subtitle: Text(country.continent),
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
                    onTap: () => _toggleCountry(country.code),
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
                child: const Text('Save countries'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
