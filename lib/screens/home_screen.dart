import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/change_record.dart';
import '../stores/change_record_store.dart';
import '../utils/cleanup.dart';

import '../widgets/tab_filter.dart';
import '../widgets/record_card.dart';
import '../widgets/paid_record_card.dart';
import '../widgets/empty_state.dart';
import '../widgets/loading_state.dart';

enum TabOption { active, paid }

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  TabOption _selectedTab = TabOption.active;
  String _searchQuery = '';
  bool _isRefreshing = false;

  Future<void> _refresh(BuildContext context) async {
    setState(() => _isRefreshing = true);
    await cleanupPaidRecords(context.read<ChangeRecordStore>());
    setState(() => _isRefreshing = false);
  }

  void _markAsPaid(BuildContext context, ChangeRecord record) async {
    record.markAsPaid();
    await context.read<ChangeRecordStore>().updateRecord(record);
  }

  Widget _buildDrawer(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            padding: EdgeInsets.zero,
            child: Stack(
              children: [
                // Background image fills the header
                Image.asset(
                  'assets/images/brand.png',
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: double.infinity,
                ),
                Container(),
                Positioned(
                  left: 16,
                  bottom: 16,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        'cTracker',
                        style: TextStyle(
                          color: Colors.deepPurple,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Track customer change easily',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Settings
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('Settings'),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/settings');
            },
          ),

          // App info
          ListTile(
            leading: const Icon(Icons.info),
            title: const Text('App Info'),
            onTap: () {
              showAboutDialog(
                context: context,
                applicationName: 'cTracker',
                applicationVersion: 'v1.0.0 (1)',
                applicationIcon: Image.asset(
                  'assets/images/splash.png',
                  width: 48,
                  height: 48,
                ),
                children: const [
                  Text('Simple app to track change owed to customers.'),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final store = context.watch<ChangeRecordStore>();

    final activeRecords = store.activeRecords;
    final paidRecords = store.paidRecords;

    final records =
        _selectedTab == TabOption.active ? activeRecords : paidRecords;

    final filtered = searchRecords(records, _searchQuery);

    return Scaffold(
      drawer: _buildDrawer(context),
      appBar: AppBar(
        title: const Text('cTracker'),
      ),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () => _refresh(context),
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            physics: const AlwaysScrollableScrollPhysics(),
            itemCount: filtered.isEmpty ? 1 : filtered.length + 1,
            itemBuilder: (context, index) {
              if (index == 0) {
                return Column(
                  children: [
                    TabFilter(
                      selected: _selectedTab,
                      activeCount: activeRecords.length,
                      paidCount: paidRecords.length,
                      onChanged: (tab) {
                        setState(() {
                          _selectedTab = tab;
                          _searchQuery = '';
                        });
                      },
                    ),
                    const SizedBox(height: 12),
                    SearchBar(
                      hintText: _selectedTab == TabOption.active
                          ? 'Search active records...'
                          : 'Search paid records...',
                      onChanged: (v) => setState(() => _searchQuery = v),
                      shape: WidgetStateProperty.resolveWith((states) {
                        final isFocused = states.contains(WidgetState.focused);

                        return RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                          side: BorderSide(
                            color: isFocused
                                ? Theme.of(context).colorScheme.primary
                                : Theme.of(context).colorScheme.outline,
                            width: 1.2,
                          ),
                        );
                      }),
                      elevation: WidgetStateProperty.all(0),
                      backgroundColor: WidgetStateProperty.all(
                        Theme.of(context).colorScheme.surface,
                      ),
                      surfaceTintColor:
                          WidgetStateProperty.all(Colors.transparent),
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
                        onMarkPaid: () => _markAsPaid(context, record),
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
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.pushNamed(context, '/add'),
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildEmptyState() {
    if (_isRefreshing) {
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
