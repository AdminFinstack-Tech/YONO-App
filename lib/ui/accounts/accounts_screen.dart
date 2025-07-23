import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewModels/AccountViewModel.dart';
import '../../utils/colors.dart';
import '../../utils/app_theme.dart';
import '../../utils/currency_formatter.dart';
import '../../widgets/account_card.dart';
import '../../l10n/app_localizations.dart';

class AccountsScreen extends StatefulWidget {
  const AccountsScreen({super.key});

  @override
  State<AccountsScreen> createState() => _AccountsScreenState();
}

class _AccountsScreenState extends State<AccountsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AccountViewModel>().loadAccounts();
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.accounts),
      ),
      body: Consumer<AccountViewModel>(
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
                    onPressed: () => viewModel.loadAccounts(),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () => viewModel.loadAccounts(),
            child: CustomScrollView(
              slivers: [
                // Total Balance Summary
                SliverToBoxAdapter(
                  child: _buildTotalBalanceSection(context, viewModel),
                ),
                
                // Accounts List
                SliverPadding(
                  padding: const EdgeInsets.all(AppTheme.spacingMedium),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final account = viewModel.accounts[index];
                        return Padding(
                          padding: const EdgeInsets.only(bottom: AppTheme.spacingMedium),
                          child: AccountCard(
                            account: account,
                            onTap: () {
                              viewModel.selectAccount(account);
                              Navigator.pushNamed(
                                context,
                                '/accountDetails',
                                arguments: account,
                              );
                            },
                          ),
                        );
                      },
                      childCount: viewModel.accounts.length,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildTotalBalanceSection(BuildContext context, AccountViewModel viewModel) {
    final totalBalance = viewModel.accounts.fold<double>(
      0.0,
      (sum, account) => sum + account.availableBalance,
    );
    
    return Container(
      margin: const EdgeInsets.all(AppTheme.spacingMedium),
      padding: const EdgeInsets.all(AppTheme.spacingLarge),
      decoration: BoxDecoration(
        gradient: AppColor.primaryGradient,
        borderRadius: BorderRadius.circular(AppTheme.radiusLarge),
        boxShadow: [
          BoxShadow(
            color: AppColor.shadowColor.withOpacity(0.2),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            'Total Available Balance',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: AppColor.whiteColor.withOpacity(0.9),
            ),
          ),
          const SizedBox(height: AppTheme.spacingSmall),
          Text(
            CurrencyFormatter.format(totalBalance),
            style: Theme.of(context).textTheme.displayMedium?.copyWith(
              color: AppColor.whiteColor,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: AppTheme.spacingMedium),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildBalanceDetail(
                context,
                'Total Accounts',
                viewModel.accounts.length.toString(),
              ),
              _buildBalanceDetail(
                context,
                'Active',
                viewModel.accounts.where((a) => a.isActive).length.toString(),
              ),
              _buildBalanceDetail(
                context,
                'Primary',
                viewModel.accounts.where((a) => a.isPrimary).length.toString(),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBalanceDetail(BuildContext context, String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            color: AppColor.whiteColor,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: AppColor.whiteColor.withOpacity(0.7),
          ),
        ),
      ],
    );
  }
}