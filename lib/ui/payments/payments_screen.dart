import 'package:flutter/material.dart';
import '../../utils/colors.dart';
import '../../utils/app_theme.dart';
import '../../l10n/app_localizations.dart';

class PaymentsScreen extends StatefulWidget {
  const PaymentsScreen({super.key});

  @override
  State<PaymentsScreen> createState() => _PaymentsScreenState();
}

class _PaymentsScreenState extends State<PaymentsScreen> {
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.payments),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppTheme.spacingMedium),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildQuickPaymentActions(context),
            const SizedBox(height: AppTheme.spacingLarge),
            _buildPaymentOptions(context),
            const SizedBox(height: AppTheme.spacingLarge),
            _buildRecentPayees(context),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickPaymentActions(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Quick Actions',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: AppTheme.spacingMedium),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildActionCard(
              context,
              icon: Icons.account_balance,
              label: 'Bank Transfer',
              color: AppColor.primaryColor,
              onTap: () => Navigator.pushNamed(context, '/bankTransfer'),
            ),
            _buildActionCard(
              context,
              icon: Icons.qr_code_scanner,
              label: 'Scan & Pay',
              color: AppColor.secondaryColor,
              onTap: () => Navigator.pushNamed(context, '/scanPay'),
            ),
            _buildActionCard(
              context,
              icon: Icons.upload_file,
              label: 'Bulk Upload',
              color: AppColor.infoColor,
              onTap: () => Navigator.pushNamed(context, '/bulkUpload'),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildActionCard(
    BuildContext context, {
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 100,
        padding: const EdgeInsets.all(AppTheme.spacingMedium),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
        ),
        child: Column(
          children: [
            Icon(icon, size: 32, color: color),
            const SizedBox(height: AppTheme.spacingSmall),
            Text(
              label,
              style: Theme.of(context).textTheme.bodySmall,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentOptions(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Payment Options',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: AppTheme.spacingMedium),
        Card(
          child: Column(
            children: [
              _buildPaymentOption(
                context,
                icon: Icons.person,
                title: 'Pay to Beneficiary',
                subtitle: 'Transfer to saved beneficiaries',
                onTap: () => Navigator.pushNamed(context, '/payBeneficiary'),
              ),
              const Divider(height: 1),
              _buildPaymentOption(
                context,
                icon: Icons.receipt,
                title: 'Pay Bills',
                subtitle: 'Utilities, credit cards, and more',
                onTap: () => Navigator.pushNamed(context, '/payBills'),
              ),
              const Divider(height: 1),
              _buildPaymentOption(
                context,
                icon: Icons.groups,
                title: 'Salary Payments',
                subtitle: 'Bulk salary disbursements',
                onTap: () => Navigator.pushNamed(context, '/salaryPayments'),
              ),
              const Divider(height: 1),
              _buildPaymentOption(
                context,
                icon: Icons.business,
                title: 'Vendor Payments',
                subtitle: 'Pay your suppliers',
                onTap: () => Navigator.pushNamed(context, '/vendorPayments'),
              ),
              const Divider(height: 1),
              _buildPaymentOption(
                context,
                icon: Icons.account_balance_wallet,
                title: 'Tax Payments',
                subtitle: 'GST, income tax, and more',
                onTap: () => Navigator.pushNamed(context, '/taxPayments'),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPaymentOption(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: AppColor.primaryColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
        ),
        child: Icon(icon, color: AppColor.primaryColor),
      ),
      title: Text(title),
      subtitle: Text(subtitle),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: onTap,
    );
  }

  Widget _buildRecentPayees(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Recent Payees',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            TextButton(
              onPressed: () => Navigator.pushNamed(context, '/beneficiaries'),
              child: const Text('View All'),
            ),
          ],
        ),
        const SizedBox(height: AppTheme.spacingMedium),
        SizedBox(
          height: 100,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: 5,
            separatorBuilder: (context, index) => const SizedBox(width: 12),
            itemBuilder: (context, index) {
              return _buildRecentPayeeCard(context, index);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildRecentPayeeCard(BuildContext context, int index) {
    final names = ['John Doe', 'ABC Corp', 'XYZ Ltd', 'Jane Smith', 'Tech Solutions'];
    final initials = ['JD', 'AC', 'XL', 'JS', 'TS'];
    
    return GestureDetector(
      onTap: () {
        // Handle payee selection
      },
      child: Container(
        width: 80,
        child: Column(
          children: [
            CircleAvatar(
              radius: 30,
              backgroundColor: AppColor.primaryColor.withOpacity(0.1),
              child: Text(
                initials[index],
                style: TextStyle(
                  color: AppColor.primaryColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              names[index],
              style: Theme.of(context).textTheme.bodySmall,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}