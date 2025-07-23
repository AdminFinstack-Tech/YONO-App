import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../viewModels/TransactionViewModel.dart';
import '../../models/transaction_model.dart';
import '../../utils/colors.dart';
import '../../utils/app_theme.dart';
import '../../widgets/transaction_list_item.dart';
import '../../l10n/app_localizations.dart';

class TransactionsScreen extends StatefulWidget {
  const TransactionsScreen({super.key});

  @override
  State<TransactionsScreen> createState() => _TransactionsScreenState();
}

class _TransactionsScreenState extends State<TransactionsScreen> {
  final ScrollController _scrollController = ScrollController();
  DateTimeRange? _selectedDateRange;
  String? _selectedType;
  String? _selectedStatus;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<TransactionViewModel>().loadTransactions();
    });
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
      // Load more transactions
    }
  }

  Future<void> _selectDateRange(BuildContext context) async {
    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now(),
      initialDateRange: _selectedDateRange,
    );
    
    if (picked != null && picked != _selectedDateRange) {
      setState(() {
        _selectedDateRange = picked;
      });
      _applyFilters();
    }
  }

  void _applyFilters() {
    context.read<TransactionViewModel>().loadTransactions(
      fromDate: _selectedDateRange?.start,
      toDate: _selectedDateRange?.end,
      transactionType: _selectedType,
      status: _selectedStatus,
    );
  }

  void _clearFilters() {
    setState(() {
      _selectedDateRange = null;
      _selectedType = null;
      _selectedStatus = null;
    });
    context.read<TransactionViewModel>().loadTransactions();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.transactions),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () => _showFilterBottomSheet(context),
          ),
          IconButton(
            icon: const Icon(Icons.download),
            onPressed: () => _showDownloadOptions(context),
          ),
        ],
      ),
      body: Consumer<TransactionViewModel>(
        builder: (context, viewModel, child) {
          if (viewModel.isLoading && viewModel.transactions.isEmpty) {
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
                    onPressed: () => viewModel.loadTransactions(),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () => viewModel.refreshTransactions(),
            child: Column(
              children: [
                if (_hasActiveFilters())
                  _buildActiveFilters(context),
                Expanded(
                  child: viewModel.transactions.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.receipt_long_outlined,
                                size: 64,
                                color: AppColor.textColorGrayLight,
                              ),
                              const SizedBox(height: 16),
                              Text(
                                l10n.noTransactions,
                                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                  color: AppColor.textColorGray,
                                ),
                              ),
                            ],
                          ),
                        )
                      : ListView.separated(
                          controller: _scrollController,
                          padding: const EdgeInsets.all(AppTheme.spacingMedium),
                          itemCount: viewModel.transactions.length + (viewModel.isLoading ? 1 : 0),
                          separatorBuilder: (context, index) => const SizedBox(height: 8),
                          itemBuilder: (context, index) {
                            if (index == viewModel.transactions.length) {
                              return const Center(
                                child: Padding(
                                  padding: EdgeInsets.all(16),
                                  child: CircularProgressIndicator(),
                                ),
                              );
                            }
                            
                            final transaction = viewModel.transactions[index];
                            return Card(
                              child: TransactionListItem(
                                transaction: transaction,
                                onTap: () {
                                  viewModel.selectTransaction(transaction);
                                  Navigator.pushNamed(
                                    context,
                                    '/transactionDetails',
                                    arguments: transaction,
                                  );
                                },
                              ),
                            );
                          },
                        ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  bool _hasActiveFilters() {
    return _selectedDateRange != null || _selectedType != null || _selectedStatus != null;
  }

  Widget _buildActiveFilters(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppTheme.spacingMedium),
      color: AppColor.primaryColor.withOpacity(0.1),
      child: Row(
        children: [
          Expanded(
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                if (_selectedDateRange != null)
                  _buildFilterChip(
                    context,
                    label: '${DateFormat('dd/MM').format(_selectedDateRange!.start)} - ${DateFormat('dd/MM').format(_selectedDateRange!.end)}',
                    onDeleted: () {
                      setState(() => _selectedDateRange = null);
                      _applyFilters();
                    },
                  ),
                if (_selectedType != null)
                  _buildFilterChip(
                    context,
                    label: _selectedType!,
                    onDeleted: () {
                      setState(() => _selectedType = null);
                      _applyFilters();
                    },
                  ),
                if (_selectedStatus != null)
                  _buildFilterChip(
                    context,
                    label: _selectedStatus!,
                    onDeleted: () {
                      setState(() => _selectedStatus = null);
                      _applyFilters();
                    },
                  ),
              ],
            ),
          ),
          TextButton(
            onPressed: _clearFilters,
            child: const Text('Clear All'),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(
    BuildContext context, {
    required String label,
    required VoidCallback onDeleted,
  }) {
    return Chip(
      label: Text(label),
      deleteIcon: const Icon(Icons.close, size: 18),
      onDeleted: onDeleted,
      backgroundColor: AppColor.primaryColor.withOpacity(0.2),
      deleteIconColor: AppColor.primaryColor,
    );
  }

  void _showFilterBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => _buildFilterBottomSheet(context),
    );
  }

  Widget _buildFilterBottomSheet(BuildContext context) {
    return StatefulBuilder(
      builder: (context, setModalState) {
        return Container(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Filter Transactions',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
              ),
              const Divider(height: 1),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Date Range
                    ListTile(
                      title: const Text('Date Range'),
                      subtitle: Text(_selectedDateRange != null
                          ? '${DateFormat('dd/MM/yyyy').format(_selectedDateRange!.start)} - ${DateFormat('dd/MM/yyyy').format(_selectedDateRange!.end)}'
                          : 'Select date range'),
                      trailing: const Icon(Icons.calendar_today),
                      onTap: () async {
                        await _selectDateRange(context);
                        setModalState(() {});
                      },
                    ),
                    const SizedBox(height: 16),
                    
                    // Transaction Type
                    Text(
                      'Transaction Type',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      children: ['All', 'Credit', 'Debit'].map((type) {
                        return ChoiceChip(
                          label: Text(type),
                          selected: _selectedType == type || (type == 'All' && _selectedType == null),
                          onSelected: (selected) {
                            setModalState(() {
                              _selectedType = type == 'All' ? null : type;
                            });
                          },
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 16),
                    
                    // Status
                    Text(
                      'Status',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      children: ['All', 'Completed', 'Pending', 'Failed'].map((status) {
                        return ChoiceChip(
                          label: Text(status),
                          selected: _selectedStatus == status || (status == 'All' && _selectedStatus == null),
                          onSelected: (selected) {
                            setModalState(() {
                              _selectedStatus = status == 'All' ? null : status;
                            });
                          },
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 24),
                    
                    // Apply Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          _applyFilters();
                          Navigator.pop(context);
                        },
                        child: const Text('Apply Filters'),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showDownloadOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Download Statement',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            ListTile(
              leading: const Icon(Icons.picture_as_pdf),
              title: const Text('Download as PDF'),
              onTap: () {
                Navigator.pop(context);
                // Handle PDF download
              },
            ),
            ListTile(
              leading: const Icon(Icons.table_chart),
              title: const Text('Download as Excel'),
              onTap: () {
                Navigator.pop(context);
                // Handle Excel download
              },
            ),
            ListTile(
              leading: const Icon(Icons.text_snippet),
              title: const Text('Download as CSV'),
              onTap: () {
                Navigator.pop(context);
                // Handle CSV download
              },
            ),
          ],
        ),
      ),
    );
  }
}