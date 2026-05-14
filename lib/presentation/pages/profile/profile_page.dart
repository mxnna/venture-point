import 'dart:convert';
import 'dart:typed_data';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:venturepoint/core/theme/app_colors.dart';
import 'package:venturepoint/presentation/pages/profile/profile_data.dart';
import 'package:venturepoint/presentation/pages/profile/visited_cities_page.dart';
import 'package:venturepoint/presentation/pages/profile/visited_countries_page.dart';

import '../../bloc/auth/auth_bloc.dart';
import '../../bloc/auth/auth_event.dart';
import '../../bloc/auth/auth_state.dart';
import '../auth/login_page.dart';

class ProfilePage extends StatefulWidget {
  static const routeName = '/profile';

  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _picker = ImagePicker();
  bool _isSaving = false;
  bool _createdDefaultProfile = false;

  CollectionReference<Map<String, dynamic>> get _usersCollection =>
      FirebaseFirestore.instance.collection('users');

  DocumentReference<Map<String, dynamic>> _userDoc(String uid) =>
      _usersCollection.doc(uid);

  Future<String> _encodeProfilePicture(XFile file) async {
    final bytes = await file.readAsBytes();
    return base64Encode(bytes);
  }

  Future<void> _createDefaultProfile(User user) async {
    final defaultProfile = UserProfile(
      displayName: user.displayName?.trim().isNotEmpty == true
          ? user.displayName!
          : 'Traveler',
      email: user.email ?? 'unknown@venturepoint.app',
      photoUrl: user.photoURL,
      continents: [],
      countries: [],
      cities: [],
      visitedCountryCodes: [],
      visitedCityIds: [],
    );

    await _userDoc(
      user.uid,
    ).set(defaultProfile.toMap(), SetOptions(merge: true));
  }

  Future<void> _saveProfile(
    User user,
    String displayName,
    XFile? pickedImage,
  ) async {
    setState(() {
      _isSaving = true;
    });

    try {
      String? photoBase64;
      if (pickedImage != null) {
        photoBase64 = await _encodeProfilePicture(pickedImage);
      }

      final updatedData = <String, dynamic>{
        'displayName': displayName.trim().isEmpty
            ? 'Traveler'
            : displayName.trim(),
        'email': user.email ?? 'unknown@venturepoint.app',
      };

      if (photoBase64 != null) {
        updatedData['photoBase64'] = photoBase64;
      }

      await _userDoc(user.uid).set(updatedData, SetOptions(merge: true));
      if (mounted) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profile updated successfully')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Unable to save profile: $e')));
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
      }
    }
  }

  Future<XFile?> _pickImage() async {
    try {
      final pickedFile = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
        maxWidth: 800,
      );
      return pickedFile;
    } catch (_) {
      return null;
    }
  }

  void _showEditSheet(User user, UserProfile profile) {
    final displayNameController = TextEditingController(
      text: profile.displayName,
    );
    XFile? selectedImage;
    Uint8List? selectedImageBytes;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return GestureDetector(
              onTap: () => FocusScope.of(context).unfocus(),
              child: Container(
                decoration: const BoxDecoration(
                  color: AppColors.secondary,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                ),
                padding: EdgeInsets.only(
                  left: 20,
                  right: 20,
                  top: 16,
                  bottom: MediaQuery.of(context).viewInsets.bottom + 24,
                ),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Edit profile',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          IconButton(
                            icon: const Icon(
                              Icons.close,
                              color: AppColors.textPrimary,
                            ),
                            onPressed: () => Navigator.of(context).pop(),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Center(
                        child: Stack(
                          alignment: Alignment.bottomRight,
                          children: [
                            CircleAvatar(
                              radius: 46,
                              backgroundColor: AppColors.secondaryDark,
                              backgroundImage: selectedImageBytes != null
                                  ? MemoryImage(selectedImageBytes!)
                                  : profile.photoBase64 != null
                                  ? MemoryImage(
                                      base64Decode(profile.photoBase64!),
                                    )
                                  : profile.photoUrl != null
                                  ? CachedNetworkImageProvider(
                                      profile.photoUrl!,
                                    )
                                  : const AssetImage('assets/images/person.png')
                                        as ImageProvider,
                            ),
                            Positioned(
                              right: 0,
                              bottom: 0,
                              child: GestureDetector(
                                onTap: () async {
                                  final picked = await _pickImage();
                                  if (picked != null) {
                                    final bytes = await picked.readAsBytes();
                                    setState(() {
                                      selectedImage = picked;
                                      selectedImageBytes = bytes;
                                    });
                                  }
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: AppColors.primary,
                                    borderRadius: BorderRadius.circular(999),
                                  ),
                                  child: const Icon(
                                    Icons.camera_alt,
                                    color: AppColors.white,
                                    size: 20,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 18),
                      TextField(
                        controller: displayNameController,
                        decoration: const InputDecoration(
                          labelText: 'Name',
                          hintText: 'Traveler',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 12),
                      _buildSectionButton(
                        title: 'Edit visited countries',
                        icon: Icons.flag,
                        onTap: () async {
                          await Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => CountrySelectionPage(
                                initialSelection:
                                    (profile.visitedCountryCodes.isNotEmpty
                                            ? profile.visitedCountryCodes
                                            : profile.countries
                                                  .map(
                                                    (countryName) =>
                                                        countryInfoFromName(
                                                          countryName,
                                                        )?.code ??
                                                        countryName,
                                                  )
                                                  .toList())
                                        .toSet(),
                              ),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 12),
                      _buildSectionButton(
                        title: 'Edit visited cities',
                        icon: Icons.location_city,
                        onTap: () async {
                          await Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => CitySelectionPage(
                                initialSelection:
                                    (profile.visitedCityIds.isNotEmpty
                                            ? profile.visitedCityIds
                                            : profile.cities
                                                  .map(
                                                    (cityName) =>
                                                        cityInfoFromName(
                                                          cityName,
                                                        )?.id ??
                                                        cityName,
                                                  )
                                                  .toList())
                                        .toSet(),
                              ),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 18),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _isSaving
                              ? null
                              : () async {
                                  await _saveProfile(
                                    user,
                                    displayNameController.text,
                                    selectedImage,
                                  );
                                },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                          child: Text(
                            _isSaving ? 'Saving...' : 'Save changes',
                            style: const TextStyle(fontSize: 16),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton.icon(
                          onPressed: () {
                            Navigator.of(context).pop();
                            context.read<AuthBloc>().add(
                              AuthSignOutRequested(),
                            );
                          },
                          icon: const Icon(
                            Icons.logout,
                            color: AppColors.primary,
                          ),
                          label: const Text(
                            'Log out',
                            style: TextStyle(
                              color: AppColors.primary,
                              fontSize: 16,
                            ),
                          ),
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: AppColors.primary),
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _showSettings() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Settings will be available soon')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthUnauthenticated) {
          Navigator.of(context, rootNavigator: true).pushNamedAndRemoveUntil(
            LoginPage.routeName,
            (route) => false,
          );
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.secondary,
        appBar: AppBar(
          backgroundColor: AppColors.secondary,
          elevation: 0,
          centerTitle: false,
          title: const Text(
            'Profile',
            style: TextStyle(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.bold,
            ),
          ),
          iconTheme: const IconThemeData(color: AppColors.textPrimary),
          actions: [
            IconButton(
              icon: const Icon(Icons.settings_outlined),
              onPressed: _showSettings,
            ),
            IconButton(
              icon: const Icon(Icons.edit_outlined),
              onPressed: () async {
                final user = FirebaseAuth.instance.currentUser;
                if (user != null) {
                  final snapshot = await _userDoc(user.uid).get();
                  final profile = snapshot.exists
                      ? UserProfile.fromSnapshot(snapshot)
                      : UserProfile.initialFromUser(user);
                  _showEditSheet(user, profile);
                }
              },
            ),
          ],
        ),
        body: SafeArea(
          child: StreamBuilder<User?>(
            stream: FirebaseAuth.instance.userChanges(),
            builder: (context, authSnapshot) {
              if (!authSnapshot.hasData || authSnapshot.data == null) {
                return const Center(child: CircularProgressIndicator());
              }
              final user = authSnapshot.data!;
              return StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                stream: _userDoc(user.uid).snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  final profile = snapshot.hasData && snapshot.data!.exists
                      ? UserProfile.fromSnapshot(snapshot.data!)
                      : UserProfile.initialFromUser(user);

                  if (!_createdDefaultProfile &&
                      (!snapshot.hasData || !snapshot.data!.exists)) {
                    _createdDefaultProfile = true;
                    _createDefaultProfile(user);
                  }

                  final visitedCountryCode =
                      profile.visitedCountryCodes.isNotEmpty
                      ? profile.visitedCountryCodes
                      : <String>[];
                  final visitedCityId = profile.visitedCityIds.isNotEmpty
                      ? profile.visitedCityIds
                      : <String>[];

                  final visitedCountries = visitedCountryCode
                      .map((code) => countryByCode[code])
                      .whereType<CountryInfo>()
                      .toList();
                  final visitedCities = visitedCityId
                      .map((id) => cityById[id])
                      .whereType<CityInfo>()
                      .toList();
                  final continentCounts = _buildContinentCounts(
                    visitedCountries,
                  );

                  return ListView(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 16,
                    ),
                    physics: const BouncingScrollPhysics(),
                    children: [
                      Center(
                        child: Stack(
                          alignment: Alignment.bottomRight,
                          children: [
                            CircleAvatar(
                              radius: 62,
                              backgroundColor: AppColors.secondaryDark,
                              backgroundImage: profile.photoBase64 != null
                                  ? MemoryImage(
                                      base64Decode(profile.photoBase64!),
                                    )
                                  : profile.photoUrl != null
                                  ? CachedNetworkImageProvider(
                                      profile.photoUrl!,
                                    )
                                  : const AssetImage('assets/images/person.png')
                                        as ImageProvider,
                            ),
                            GestureDetector(
                              onTap: () => _showEditSheet(user, profile),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: AppColors.primary,
                                  borderRadius: BorderRadius.circular(999),
                                ),
                                padding: const EdgeInsets.all(10),
                                child: const Icon(
                                  Icons.camera_alt,
                                  color: AppColors.white,
                                  size: 20,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        profile.displayName,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        profile.email,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 24),
                      _buildSectionTitle(
                        'My continents',
                        onViewAll: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => const VisitedCountriesPage(),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        height: 220,
                        child: ListView.separated(
                          scrollDirection: Axis.vertical,
                          itemCount: continentTotals.length,
                          separatorBuilder: (context, index) =>
                              const SizedBox(height: 12),
                          itemBuilder: (context, index) {
                            final continent = continentTotals.keys.elementAt(
                              index,
                            );
                            final total = continentTotals[continent]!;
                            final visited = continentCounts[continent] ?? 0;
                            final percent = total == 0 ? 0.0 : visited / total;
                            return _buildContinentCard(
                              continent,
                              visited,
                              total,
                              percent,
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 24),
                      _buildSectionTitle(
                        'My countries',
                        onViewAll: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => const VisitedCountriesPage(),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 12),
                      SizedBox(
                        height: 120,
                        child: visitedCountries.isEmpty
                            ? _buildEmptyState(
                                'No visited countries yet. Tap edit or View all to add them.',
                              )
                            : ListView.separated(
                                scrollDirection: Axis.horizontal,
                                shrinkWrap: true,
                                primary: false,
                                physics: const BouncingScrollPhysics(),
                                itemBuilder: (context, index) =>
                                    _buildCountryCard(visitedCountries[index]),
                                separatorBuilder: (context, index) =>
                                    const SizedBox(width: 12),
                                itemCount: visitedCountries.length,
                              ),
                      ),
                      const SizedBox(height: 24),
                      _buildSectionTitle(
                        'My cities',
                        onViewAll: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => const VisitedCitiesPage(),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 12),
                      SizedBox(
                        height: 210,
                        child: visitedCities.isEmpty
                            ? _buildEmptyState(
                                'No visited cities yet. Tap edit or View all to add them.',
                              )
                            : ListView.separated(
                                scrollDirection: Axis.horizontal,
                                shrinkWrap: true,
                                primary: false,
                                physics: const BouncingScrollPhysics(),
                                itemBuilder: (context, index) =>
                                    _buildCityCard(visitedCities[index]),
                                separatorBuilder: (context, index) =>
                                    const SizedBox(width: 12),
                                itemCount: visitedCities.length,
                              ),
                      ),
                      const SizedBox(height: 24),
                    ],
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title, {required VoidCallback onViewAll}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        TextButton(onPressed: onViewAll, child: const Text('View all')),
      ],
    );
  }

  Widget _buildEmptyState(String message) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Text(
          message,
          textAlign: TextAlign.center,
          style: const TextStyle(color: AppColors.textSecondary),
        ),
      ),
    );
  }

  Widget _buildSectionButton({
    required String title,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.secondaryDark),
        ),
        child: Row(
          children: [
            Icon(icon, color: AppColors.primary),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios,
              size: 18,
              color: AppColors.textSecondary,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContinentCard(
    String continent,
    int visited,
    int total,
    double percent,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(
            color: Color.fromRGBO(0, 0, 0, 0.04),
            blurRadius: 12,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  continent,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '$visited/$total visited',
                  style: const TextStyle(
                    fontSize: 13,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 12),
                LinearProgressIndicator(
                  value: percent,
                  color: AppColors.primary,
                  backgroundColor: AppColors.secondaryDark,
                  minHeight: 6,
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Text(
            '${(percent * 100).round()}%',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _buildCountryCard(CountryInfo country) {
    return Container(
      width: 140,
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(
            color: Color.fromRGBO(0, 0, 0, 0.04),
            blurRadius: 12,
            offset: Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(14),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(country.flag, style: const TextStyle(fontSize: 32)),
          const SizedBox(height: 12),
          Text(
            country.name,
            textAlign: TextAlign.center,
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }

  Widget _buildCityCard(CityInfo city) {
    return Container(
      width: 180,
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: const [
          BoxShadow(
            color: Color.fromRGBO(0, 0, 0, 0.04),
            blurRadius: 12,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
            child: SizedBox(
              height: 120,
              width: double.infinity,
              child: CachedNetworkImage(
                imageUrl: city.imageUrl,
                fit: BoxFit.cover,
                placeholder: (context, url) =>
                    Container(color: AppColors.secondaryDark),
                errorWidget: (context, url, error) =>
                    Container(color: AppColors.secondaryDark),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  city.name,
                  style: const TextStyle(fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Text(city.flag, style: const TextStyle(fontSize: 14)),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        city.countryName,
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.textSecondary,
                        ),
                        overflow: TextOverflow.ellipsis,
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

  Map<String, int> _buildContinentCounts(List<CountryInfo> countries) {
    final counts = {for (var key in continentTotals.keys) key: 0};
    for (final country in countries) {
      counts[country.continent] = (counts[country.continent] ?? 0) + 1;
    }
    return counts;
  }
}

class UserProfile {
  final String displayName;
  final String email;
  final String? photoUrl;
  final String? photoBase64;
  final List<String> continents;
  final List<String> countries;
  final List<String> cities;
  final List<String> visitedCountryCodes;
  final List<String> visitedCityIds;

  UserProfile({
    required this.displayName,
    required this.email,
    this.photoUrl,
    this.photoBase64,
    required this.continents,
    required this.countries,
    required this.cities,
    required this.visitedCountryCodes,
    required this.visitedCityIds,
  });

  factory UserProfile.initialFromUser(User user) {
    return UserProfile(
      displayName: user.displayName?.trim().isNotEmpty == true
          ? user.displayName!
          : 'Traveler',
      email: user.email ?? 'unknown@venturepoint.app',
      photoUrl: user.photoURL,
      continents: [],
      countries: [],
      cities: [],
      visitedCountryCodes: [],
      visitedCityIds: [],
    );
  }

  factory UserProfile.fromSnapshot(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
  ) {
    final data = snapshot.data() ?? <String, dynamic>{};

    return UserProfile(
      displayName: data['displayName'] as String? ?? 'Traveler',
      email: data['email'] as String? ?? 'unknown@venturepoint.app',
      photoUrl: data['photoUrl'] as String?,
      photoBase64: data['photoBase64'] as String?,
      continents: [],
      countries: [],
      cities: [],
      visitedCountryCodes: List<String>.from(
        data['visitedCountryCodes'] as List<dynamic>? ?? [],
      ),
      visitedCityIds: List<String>.from(
        data['visitedCityIds'] as List<dynamic>? ?? [],
      ),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'displayName': displayName,
      'email': email,
      'photoUrl': photoUrl,
      'photoBase64': photoBase64,
      'continents': continents,
      'countries': countries,
      'cities': cities,
      'visitedCountryCodes': visitedCountryCodes,
      'visitedCityIds': visitedCityIds,
    };
  }
}
