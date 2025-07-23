import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewModels/ProfileViewModel.dart';
import '../../viewModels/UserViewModel.dart';
import '../../providers/theme_provider.dart';
import '../../providers/language_provider.dart';
import '../../utils/colors.dart';
import '../../utils/app_theme.dart';
import '../../l10n/app_localizations.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProfileViewModel>().loadProfile();
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.profile),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () => Navigator.pushNamed(context, '/editProfile'),
          ),
        ],
      ),
      body: Consumer<ProfileViewModel>(
        builder: (context, viewModel, child) {
          if (viewModel.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          return SingleChildScrollView(
            child: Column(
              children: [
                _buildProfileHeader(context, viewModel),
                _buildMenuSection(context),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildProfileHeader(BuildContext context, ProfileViewModel viewModel) {
    final user = viewModel.userProfile;
    final business = viewModel.businessProfile;
    
    return Container(
      padding: const EdgeInsets.all(AppTheme.spacingLarge),
      decoration: BoxDecoration(
        gradient: AppColor.primaryGradient,
      ),
      child: Column(
        children: [
          CircleAvatar(
            radius: 50,
            backgroundColor: AppColor.whiteColor,
            child: Text(
              user?.fullName.isNotEmpty == true 
                  ? user!.fullName.substring(0, 1).toUpperCase()
                  : 'U',
              style: TextStyle(
                fontSize: 36,
                fontWeight: FontWeight.bold,
                color: AppColor.primaryColor,
              ),
            ),
          ),
          const SizedBox(height: AppTheme.spacingMedium),
          Text(
            user?.fullName ?? 'User',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: AppColor.whiteColor,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            business?.businessName ?? 'Business',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: AppColor.whiteColor.withOpacity(0.9),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            user?.email ?? '',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppColor.whiteColor.withOpacity(0.8),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuSection(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    return Column(
      children: [
        _buildMenuCategory(
          context,
          title: 'Account Settings',
          items: [
            _MenuItemData(
              icon: Icons.person_outline,
              title: 'Personal Information',
              onTap: () => Navigator.pushNamed(context, '/personalInfo'),
            ),
            _MenuItemData(
              icon: Icons.business_outlined,
              title: 'Business Information',
              onTap: () => Navigator.pushNamed(context, '/businessInfo'),
            ),
            _MenuItemData(
              icon: Icons.lock_outline,
              title: 'Change Password',
              onTap: () => Navigator.pushNamed(context, '/changePassword'),
            ),
            _MenuItemData(
              icon: Icons.fingerprint,
              title: 'Biometric Settings',
              onTap: () => Navigator.pushNamed(context, '/biometricSettings'),
            ),
          ],
        ),
        _buildMenuCategory(
          context,
          title: 'App Settings',
          items: [
            _MenuItemData(
              icon: Icons.language,
              title: 'Language',
              trailing: Consumer<LanguageProvider>(
                builder: (context, langProvider, _) {
                  return Text(
                    langProvider.currentLanguage.name,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppColor.textColorGray,
                    ),
                  );
                },
              ),
              onTap: () => _showLanguageDialog(context),
            ),
            _MenuItemData(
              icon: Icons.dark_mode,
              title: 'Theme',
              trailing: Consumer<ThemeProvider>(
                builder: (context, themeProvider, _) {
                  return Switch(
                    value: themeProvider.isDarkMode,
                    onChanged: (_) => themeProvider.toggleTheme(),
                  );
                },
              ),
            ),
            _MenuItemData(
              icon: Icons.notifications_outlined,
              title: l10n.notifications,
              onTap: () => Navigator.pushNamed(context, '/notificationSettings'),
            ),
          ],
        ),
        _buildMenuCategory(
          context,
          title: 'Support',
          items: [
            _MenuItemData(
              icon: Icons.help_outline,
              title: l10n.help,
              onTap: () => Navigator.pushNamed(context, '/help'),
            ),
            _MenuItemData(
              icon: Icons.info_outline,
              title: l10n.about,
              onTap: () => Navigator.pushNamed(context, '/about'),
            ),
            _MenuItemData(
              icon: Icons.article_outlined,
              title: 'Terms & Conditions',
              onTap: () => Navigator.pushNamed(context, '/terms'),
            ),
            _MenuItemData(
              icon: Icons.privacy_tip_outlined,
              title: 'Privacy Policy',
              onTap: () => Navigator.pushNamed(context, '/privacy'),
            ),
          ],
        ),
        const SizedBox(height: AppTheme.spacingLarge),
        _buildLogoutButton(context),
        const SizedBox(height: AppTheme.spacingLarge),
      ],
    );
  }

  Widget _buildMenuCategory(
    BuildContext context, {
    required String title,
    required List<_MenuItemData> items,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppTheme.spacingMedium,
            vertical: AppTheme.spacingSmall,
          ),
          child: Text(
            title,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: AppColor.textColorGray,
            ),
          ),
        ),
        Card(
          margin: const EdgeInsets.symmetric(horizontal: AppTheme.spacingMedium),
          child: Column(
            children: items.map((item) {
              final isLast = items.last == item;
              return Column(
                children: [
                  ListTile(
                    leading: Icon(item.icon, color: AppColor.iconColorSecondary),
                    title: Text(item.title),
                    trailing: item.trailing ?? (item.onTap != null 
                        ? const Icon(Icons.arrow_forward_ios, size: 16)
                        : null),
                    onTap: item.onTap,
                  ),
                  if (!isLast) const Divider(height: 1),
                ],
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildLogoutButton(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppTheme.spacingMedium),
      child: OutlinedButton.icon(
        onPressed: () => _showLogoutDialog(context),
        icon: const Icon(Icons.logout, color: AppColor.errorColor),
        label: Text(
          l10n.logout,
          style: const TextStyle(color: AppColor.errorColor),
        ),
        style: OutlinedButton.styleFrom(
          side: const BorderSide(color: AppColor.errorColor),
          padding: const EdgeInsets.symmetric(vertical: 12),
          minimumSize: const Size(double.infinity, 48),
        ),
      ),
    );
  }

  void _showLanguageDialog(BuildContext context) {
    final langProvider = context.read<LanguageProvider>();
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Change Language'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: langProvider.getAvailableLanguages().map((lang) {
            return RadioListTile<String>(
              title: Text(lang.name),
              value: lang.code.toLowerCase(),
              groupValue: langProvider.currentLanguageCode,
              onChanged: (value) {
                if (value != null) {
                  langProvider.changeLanguage(value);
                  Navigator.pop(context);
                }
              },
            );
          }).toList(),
        ),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.logout),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.cancel),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);
              final userViewModel = context.read<UserViewModel>();
              await userViewModel.logout();
              if (!mounted) return;
              Navigator.of(context).pushNamedAndRemoveUntil('/login', (route) => false);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColor.errorColor,
            ),
            child: Text(l10n.logout),
          ),
        ],
      ),
    );
  }
}

class _MenuItemData {
  final IconData icon;
  final String title;
  final Widget? trailing;
  final VoidCallback? onTap;

  _MenuItemData({
    required this.icon,
    required this.title,
    this.trailing,
    this.onTap,
  });
}