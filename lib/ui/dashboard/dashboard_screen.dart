import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewModels/DashboardViewModel.dart';
import '../../viewModels/UserViewModel.dart';
import '../../utils/colors.dart';
import '../../utils/app_theme.dart';
import '../../utils/currency_formatter.dart';
import '../../widgets/account_card.dart';
import '../../widgets/transaction_list_item.dart';
import '../../widgets/quick_action_button.dart';
import '../../l10n/app_localizations.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<DashboardViewModel>().loadDashboardData();
    });
  }

  Future<void> _handleRefresh() async {
    await context.read<DashboardViewModel>().refreshDashboard();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final userViewModel = context.watch<UserViewModel>();
    
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest,
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Welcome back,',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            Text(
              userViewModel.currentUser?.fullName ?? 'User',
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () {
              Navigator.pushNamed(context, '/notifications');
            },
          ),
        ],
      ),
      body: Consumer<DashboardViewModel>(
        builder: (context, viewModel, child) {
          if (viewModel.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (viewModel.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(viewModel.errorMessage ?? 'Something went wrong'),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => viewModel.loadDashboardData(),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: _handleRefresh,
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(AppTheme.spacingMedium),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Total Balance Card
                  _buildTotalBalanceCard(context, viewModel),
                  const SizedBox(height: AppTheme.spacingLarge),
                  
                  // Quick Actions
                  _buildQuickActions(context),
                  const SizedBox(height: AppTheme.spacingLarge),
                  
                  // Accounts Section
                  _buildAccountsSection(context, viewModel),
                  const SizedBox(height: AppTheme.spacingLarge),
                  
                  // Recent Transactions
                  _buildRecentTransactionsSection(context, viewModel),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildTotalBalanceCard(BuildContext context, DashboardViewModel viewModel) {
    return Card(
      child: Container(
        padding: const EdgeInsets.all(AppTheme.spacingLarge),
        decoration: BoxDecoration(
          gradient: AppColor.primaryGradient,
          borderRadius: BorderRadius.circular(AppTheme.radiusLarge),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Total Balance',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppColor.whiteColor.withOpacity(0.8),
              ),
            ),
            const SizedBox(height: AppTheme.spacingSmall),
            Text(
              CurrencyFormatter.format(viewModel.totalBalance),
              style: Theme.of(context).textTheme.displaySmall?.copyWith(
                color: AppColor.whiteColor,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: AppTheme.spacingMedium),
            Row(
              children: [
                Icon(
                  Icons.trending_up,
                  color: AppColor.whiteColor,
                  size: 16,
                ),
                const SizedBox(width: 4),
                Text(
                  '+12.5% from last month',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColor.whiteColor,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActions(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.quickActions,
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: AppTheme.spacingMedium),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            QuickActionButton(
              icon: Icons.send,
              label: l10n.transfer,
              onTap: () => Navigator.pushNamed(context, '/transfer'),
            ),
            QuickActionButton(
              icon: Icons.payment,
              label: l10n.payBills,
              onTap: () => Navigator.pushNamed(context, '/payBills'),
            ),
            QuickActionButton(
              icon: Icons.qr_code_scanner,
              label: l10n.scanAndPay,
              onTap: () => Navigator.pushNamed(context, '/scanPay'),
            ),
            QuickActionButton(
              icon: Icons.upload_file,
              label: l10n.bulkUpload,
              onTap: () => Navigator.pushNamed(context, '/bulkUpload'),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildAccountsSection(BuildContext context, DashboardViewModel viewModel) {
    final l10n = AppLocalizations.of(context)!;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              l10n.accounts,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            TextButton(
              onPressed: () {
                // Navigate to accounts tab
              },
              child: Text(l10n.viewAll),
            ),
          ],
        ),
        const SizedBox(height: AppTheme.spacingSmall),
        SizedBox(
          height: 160,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: viewModel.accounts.length,
            separatorBuilder: (context, index) => const SizedBox(width: 12),
            itemBuilder: (context, index) {
              final account = viewModel.accounts[index];
              return AccountCard(account: account);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildRecentTransactionsSection(BuildContext context, DashboardViewModel viewModel) {
    final l10n = AppLocalizations.of(context)!;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              l10n.recentTransactions,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            TextButton(
              onPressed: () {
                // Navigate to transactions tab
              },
              child: Text(l10n.viewAll),
            ),
          ],
        ),
        const SizedBox(height: AppTheme.spacingSmall),
        if (viewModel.recentTransactions.isEmpty)
          Center(
            child: Padding(
              padding: const EdgeInsets.all(AppTheme.spacingLarge),
              child: Text(
                l10n.noTransactions,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColor.textColorGray,
                ),
              ),
            ),
          )
        else
          Card(
            child: ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: viewModel.recentTransactions.length,
              separatorBuilder: (context, index) => const Divider(height: 1),
              itemBuilder: (context, index) {
                final transaction = viewModel.recentTransactions[index];
                return TransactionListItem(transaction: transaction);
              },
            ),
          ),
      ],
    );
  }
}