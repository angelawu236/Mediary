import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:mediary/app_styles.dart' as myColors;
import 'package:mediary/app_constants.dart' as constants;
import 'animation.dart';
import 'scaffold_wrapper.dart';
import 'all_media_screen.dart';

final _firestore = FirebaseFirestore.instance;
User? loggedInUser;

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    _getCurrentUser();
  }

  void _getCurrentUser() {
    try {
      final user = _auth.currentUser;
      if (user != null) loggedInUser = user;
      setState(() {});
    } catch (e) {
      debugPrint('getCurrentUser error: $e');
    }
  }

  String _displayUsername(User? u) {
    // Prefer displayName if you ever set it at registration/login
    final dn = u?.displayName?.trim();
    if (dn != null && dn.isNotEmpty) return dn;

    // Fallback: derive from email/alias (strip domain)
    final e = u?.email ?? '';
    if (e.isEmpty) return 'Not logged in';
    final at = e.indexOf('@');
    return at > 0 ? e.substring(0, at) : e;
  }


  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: myColors.bgColor,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: myColors.bgColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: myColors.lightTextColor),
          onPressed: () {
            final route = cupertinoBackRoute(const Home());
            Navigator.of(context).pushReplacement(route);
          },
        ),
        title: Text(
          'Profile',
          style: textTheme.titleLarge?.copyWith(
            color: myColors.lightTextColor,
            fontSize: 24,
          ),
        ),
      ),
      body: AppScaffoldWrapper(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
          children: [

            _SectionLabel('Account'),
            _ProfileHeaderCard(userEmail: _displayUsername(loggedInUser)),
            const SizedBox(height: 16),

            // Quick actions / links
            _SectionLabel('About & Privacy'),
            const SizedBox(height: 8),
            _ClickableCard(
              title: 'Privacy Policy',
              subtitle: 'Learn how Mediarie handles your data',
              icon: Icons.privacy_tip_outlined,
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => const PrivacyPolicyScreen(),
                  ),
                );
              },
            ),
            const SizedBox(height: 12),
            _ClickableCard(
              title: 'TMDB Attribution',
              subtitle: 'This product uses the TMDB API',
              icon: Icons.movie_outlined,
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const TmdbAttributionScreen()),
                );
              },
            ),
            const SizedBox(height: 16),

            _SectionLabel('Support'),
            const SizedBox(height: 8),
            _ClickableCard(
              title: 'Contact',
              subtitle: 'Questions or feedback? Email zhu740513@gmail.com.',
              icon: Icons.email_outlined,
            ),
          ],
        ),
      ),
      bottomNavigationBar: SizedBox(
        height: 70,
        width: double.infinity,
        child: TextButton(
          style: TextButton.styleFrom(
            backgroundColor: myColors.brightOutlineColor,
            foregroundColor: Colors.black,
            padding: const EdgeInsets.only(bottom: 7),
            shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
          ),
          onPressed: () async {
            await FirebaseAuth.instance.signOut();
            if (!mounted) return;
            Navigator.pushNamedAndRemoveUntil(
              context,
              constants.RoutePaths.LoginScreen,
                  (route) => false,
            );
          },
          child: const Text('Log Out', style: TextStyle(fontSize: 20)),
        ),
      ),
    );
  }
}

class _ProfileHeaderCard extends StatelessWidget {
  const _ProfileHeaderCard({required this.userEmail});
  final String? userEmail;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: myColors.darkImageColor.withOpacity(0.5),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              height: 48,
              width: 48,
              decoration: BoxDecoration(
                color: myColors.mediaCardColor.withOpacity(0.25),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.person_outline, color: myColors.lightTextColor),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Logged in as',
                    style: TextStyle(fontSize: 13, color: myColors.lightTextColor),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    userEmail ?? 'Not logged in',
                    style: const TextStyle(
                      fontSize: 16,
                      color: myColors.brightOutlineColor,
                    ),
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
}

class _ClickableCard extends StatelessWidget {
  const _ClickableCard({
    required this.title,
    this.subtitle,
    required this.icon,
    this.trailing,
    this.onTap,
  });

  final String title;
  final String? subtitle;
  final IconData icon;
  final Widget? trailing;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: onTap,
      child: Ink(
        decoration: BoxDecoration(
          color: myColors.darkImageColor.withOpacity(0.5),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: myColors.categoryCardColor.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: myColors.lightTextColor),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: myColors.lightTextColor,
                      ),
                    ),
                    if (subtitle != null) ...[
                      const SizedBox(height: 4),
                      Text(
                        subtitle!,
                        style: const TextStyle(fontSize: 13, color: myColors.brightOutlineColor),
                      ),
                    ],
                  ],
                ),
              ),
              trailing ?? const Icon(Icons.chevron_right, color: myColors.lightTextColor),
            ],
          ),
        ),
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel(this.text);
  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        color: myColors.lightTextColor,
        fontSize: 14,
        fontWeight: FontWeight.w600,
      ),
    );
  }
}

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: myColors.bgColor,
      appBar: AppBar(
        backgroundColor: myColors.bgColor,
        elevation: 0,
        iconTheme: const IconThemeData(color: myColors.lightTextColor),
        title: Text(
          'Privacy Policy',
          style: textTheme.titleLarge?.copyWith(color: myColors.lightTextColor),
        ),
      ),
      body: AppScaffoldWrapper(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
          children: const [
            _PolicyCard(
              title: 'Information We Collect',
              paragraphs: [
                'Account Information: When you sign in, Mediarie uses Firebase Authentication to create a unique user ID (e.g., your email address or Firebase UID).',
                'User Content: You can add shows, movies, and other media to your personal watchlist. This content is stored in Firebase and associated with your account so it can sync across devices.',
                'Mediarie does not collect location data, contacts, health information, financial data, or other sensitive categories.',
              ],
            ),
            SizedBox(height: 12),
            _PolicyCard(
              title: 'How We Use Your Information',
              bullets: [
                'App Functionality: Sign-in, save/sync your watchlist, and keep your data associated with your account.',
                'Personalization: Display your saved media inside the app.',
                'We do not use your information for advertising, marketing, or cross-app tracking.',
              ],
            ),
            SizedBox(height: 12),
            _PolicyCard(
              title: 'Third-Party Services',
              paragraphs: [
                'Firebase (Google): Provides authentication and cloud storage for your account and watchlist.',
                'TMDB (The Movie Database): Mediarie uses the TMDB API to fetch public movie and TV metadata such as titles, posters, and descriptions. Mediarie does not send your personal information to TMDB. As with any web request, TMDB may receive technical information like your device\'s IP address to provide their service.',
                'Attribution: This product uses the TMDB API but is not endorsed or certified by TMDB.',
              ],
            ),
            SizedBox(height: 12),
            _PolicyCard(
              title: 'Data Sharing',
              paragraphs: [
                'We do not sell your data or share it with advertisers, data brokers, or unrelated third parties. Your data is used only to provide the app\'s core functionality.',
              ],
            ),
            SizedBox(height: 12),
            _PolicyCard(
              title: 'Data Retention',
              paragraphs: [
                'Your watchlist and account information are stored as long as your account remains active.',
              ],
            ),
            SizedBox(height: 12),
            _PolicyCard(
              title: 'Contact Us',
              paragraphs: [
                'zhu740513@gmail.com',
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _PolicyCard extends StatelessWidget {
  const _PolicyCard({
    required this.title,
    this.paragraphs,
    this.bullets,
  });

  final String title;
  final List<String>? paragraphs;
  final List<String>? bullets;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: myColors.darkGreenColor,
              ),
            ),
            const SizedBox(height: 8),
            if (paragraphs != null)
              ...paragraphs!.map(
                    (p) => Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Text(
                    p,
                    style: const TextStyle(fontSize: 14, color: myColors.darkImageColor),
                  ),
                ),
              ),
            if (bullets != null)
              ...bullets!.map(
                    (b) => Padding(
                  padding: const EdgeInsets.only(bottom: 6),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('• ', style: TextStyle(color: myColors.darkGreenColor)),
                      Expanded(
                        child: Text(
                          b,
                          style: const TextStyle(fontSize: 14, color: myColors.darkImageColor),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class TmdbAttributionScreen extends StatelessWidget {
  const TmdbAttributionScreen({super.key});

  static const String _tmdbHome = 'https://www.themoviedb.org';
  static const String _tmdbTerms = 'https://www.themoviedb.org/terms-of-use';
  static const String _tmdbPrivacy = 'https://www.themoviedb.org/privacy-policy';

  Future<void> _open(String url, BuildContext context) async {
    final uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not open link')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: myColors.bgColor,
      appBar: AppBar(
        backgroundColor: myColors.bgColor,
        elevation: 0,
        iconTheme: const IconThemeData(color: myColors.lightTextColor),
        title: Text(
          'TMDB Attribution',
          style: textTheme.titleLarge?.copyWith(color: myColors.lightTextColor),
        ),
      ),
      body: AppScaffoldWrapper(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
          children: [
            Card(
              color: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'This product uses the TMDB API but is not endorsed or certified by TMDB.',
                      style: TextStyle(fontSize: 14, color: myColors.darkImageColor),
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 12,
                      runSpacing: 8,
                      children: [
                        TextButton(
                          onPressed: () => _open(_tmdbHome, context),
                          child: const Text('TMDB Home'),
                        ),
                        TextButton(
                          onPressed: () => _open(_tmdbTerms, context),
                          child: const Text('TMDB Terms'),
                        ),
                        TextButton(
                          onPressed: () => _open(_tmdbPrivacy, context),
                          child: const Text('TMDB Privacy'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
