import 'package:flutter/material.dart';

import '../models/change_record.dart';
import '../stores/change_record_store.dart';
import '../utils/cleanup.dart';

// You will stub or implement these widgets next
import '../widgets/tab_filter.dart';
import '../widgets/record_card.dart';
import '../widgets/paid_record_card.dart';
import '../widgets/empty_state.dart';
import '../widgets/loading_state.dart';

enum TabOption { active, paid }

class HomeScreen extends StatefulWidget {
  final ChangeRecordStore store;

  const HomeScreen({super.key, required this.store});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  TabOption _selectedTab = TabOption.active;
  String _searchQuery = '';
  bool _isRefreshing = false;
  bool _isLoading = true;

  List<ChangeRecord> _activeRecords = [];
  List<ChangeRecord> _paidRecords = [];

  @override
  void initState() {
    super.initState();
    _loadRecords();
  }

  Future<void> _loadRecords() async {
    setState(() => _isLoading = true);

    final active = widget.store.activeRecords;
    final paid = widget.store.paidRecords;

    setState(() {
      _activeRecords = active;
      _paidRecords = paid;
      _isLoading = false;
    });
  }

  Future<void> _refresh() async {
    setState(() => _isRefreshing = true);
    await cleanupPaidRecords(widget.store);
    await _loadRecords();
    setState(() => _isRefreshing = false);
  }

  void _markAsPaid(String id) async {
    final record = _activeRecords.firstWhere(
      (r) => r.id == id,
      orElse: () => throw StateError('Record not found'),
    );

    record.markAsPaid();
    await widget.store.updateRecord(record);
    await _loadRecords();
  }

  void _onTabChange(TabOption tab) {
    setState(() {
      _selectedTab = tab;
      _searchQuery = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    final records =
        _selectedTab == TabOption.active ? _activeRecords : _paidRecords;

    final filtered = searchRecords(records, _searchQuery);

    return Scaffold(
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _refresh,
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            physics: const AlwaysScrollableScrollPhysics(),
            itemCount: filtered.isEmpty ? 1 : filtered.length + 1,
            itemBuilder: (context, index) {
              // Header
              if (index == 0) {
                return Column(
                  children: [
                    TabFilter(
                      selected: _selectedTab,
                      activeCount: _activeRecords.length,
                      paidCount: _paidRecords.length,
                      onChanged: _onTabChange,
                    ),
                    const SizedBox(height: 12),
                    SearchBar(
                      hintText: _selectedTab == TabOption.active
                          ? 'Search active records...'
                          : 'Search paid records...',
                      onChanged: (v) =>
                          setState(() => _searchQuery = v),
                    ),
                    const SizedBox(height: 16),
                    if (filtered.isEmpty) _buildEmptyState(),
                  ],
                );
              }

              final record = filtered[index - 1];

              return AnimatedSwitcher(
                duration: const Duration(milliseconds: 250),
                child: _selectedTab == TabOption.active
                    ? RecordCard(
                        key: ValueKey(record.id),
                        record: record,
                        onMarkPaid: () => _markAsPaid(record.id),
                      )
                    : PaidRecordCard(
                        key: ValueKey(record.id),
                        record: record,
                      ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    if (_isLoading) {
      return const LoadingState();
    }

    if (_searchQuery.isNotEmpty) {
      return EmptyState(
        title: 'No results found',
        subtitle: 'No customers match "$_searchQuery"',
      );
    }

    if (_selectedTab == TabOption.paid) {
      return const EmptyState(
        title: 'No paid records',
        subtitle: 'Paid records remain for 30 days',
      );
    }

    return const EmptyState(
      title: 'No outstanding change',
      subtitle: 'Tap + to record change owed',
    );
  }
}

class ChangeTrackerApp extends StatelessWidget {
  const ChangeTrackerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<ChangeRecordStore>(
      future: ChangeRecordStore.create(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const CircularProgressIndicator();
        }
        return MaterialApp(
          title: 'Change Tracker',
          theme: ThemeData.light(),
          darkTheme: ThemeData.dark(),
          home: HomeScreen(store: snapshot.data!),
        );
      },
    );
  }
}
