import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../l10n/app_localizations.dart';
import '../blocs/geofence/geofence_bloc.dart';
import '../blocs/geofence/geofence_event.dart' as bloc_event;
import '../blocs/geofence/geofence_state.dart';
import '../models/geofence_event.dart' as model;

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  String _selectedFilter = 'all'; // all, today, week, month

  @override
  void initState() {
    super.initState();
    // Load events when screen opens
    context.read<GeofenceBloc>().add(const bloc_event.LoadGeofenceEvents());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context)?.geofenceHistory ?? 'Geofence History',
        ),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              setState(() {
                _selectedFilter = value;
              });
            },
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 'all',
                child: Text(
                  AppLocalizations.of(context)?.allEvents ?? 'All Events',
                ),
              ),
              PopupMenuItem(
                value: 'today',
                child: Text(AppLocalizations.of(context)?.today ?? 'Today'),
              ),
              PopupMenuItem(
                value: 'week',
                child: Text(
                  AppLocalizations.of(context)?.thisWeek ?? 'This Week',
                ),
              ),
              PopupMenuItem(
                value: 'month',
                child: Text(
                  AppLocalizations.of(context)?.thisMonth ?? 'This Month',
                ),
              ),
            ],
            child: const Padding(
              padding: EdgeInsets.all(8.0),
              child: Icon(Icons.filter_list),
            ),
          ),
        ],
      ),
      body: BlocBuilder<GeofenceBloc, GeofenceState>(
        builder: (context, state) {
          if (state is GeofenceLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is GeofenceError) {
            return Center(child: Text('Error: ${state.message}'));
          }

          if (state is GeofenceLoaded) {
            final events = _getFilteredEvents(state.events);

            if (events.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.history, size: 64, color: Colors.grey[400]),
                    const SizedBox(height: 16),
                    Text(
                      AppLocalizations.of(context)?.noEventsFound ??
                          'No events found',
                      style: TextStyle(fontSize: 18, color: Colors.grey[600]),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      AppLocalizations.of(context)?.geofenceEventsWillAppear ??
                          'Geofence events will appear here',
                      style: TextStyle(color: Colors.grey[500]),
                    ),
                  ],
                ),
              );
            }

            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: events.length,
              itemBuilder: (context, index) {
                final event = events[index];
                return _buildEventCard(event);
              },
            );
          }

          return const Center(child: Text('No data available'));
        },
      ),
    );
  }

  List<model.GeofenceEvent> _getFilteredEvents(
    List<model.GeofenceEvent> allEvents,
  ) {
    final now = DateTime.now();

    switch (_selectedFilter) {
      case 'today':
        final today = DateTime(now.year, now.month, now.day);
        return allEvents
            .where((event) => event.timestamp.isAfter(today))
            .toList();

      case 'week':
        final weekAgo = now.subtract(const Duration(days: 7));
        return allEvents
            .where((event) => event.timestamp.isAfter(weekAgo))
            .toList();

      case 'month':
        final monthAgo = DateTime(now.year, now.month - 1, now.day);
        return allEvents
            .where((event) => event.timestamp.isAfter(monthAgo))
            .toList();

      default:
        return allEvents;
    }
  }

  Widget _buildEventCard(model.GeofenceEvent event) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: event.eventType == model.EventType.enter
              ? Colors.green
              : Colors.orange,
          child: Text(event.eventIcon, style: const TextStyle(fontSize: 16)),
        ),
        title: Text(
          event.locationName,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${event.eventTypeText} at ${_formatTime(event.timestamp)}',
              style: TextStyle(
                color: event.eventType == model.EventType.enter
                    ? Colors.green
                    : Colors.orange,
                fontWeight: FontWeight.w500,
              ),
            ),
            Text(
              '${event.latitude.toStringAsFixed(6)}, ${event.longitude.toStringAsFixed(6)}',
              style: TextStyle(fontSize: 12, color: Colors.grey[600]),
            ),
            Text(
              _formatDate(event.timestamp),
              style: TextStyle(fontSize: 12, color: Colors.grey[500]),
            ),
          ],
        ),
        trailing: Icon(
          event.eventType == model.EventType.enter ? Icons.login : Icons.logout,
          color: event.eventType == model.EventType.enter
              ? Colors.green
              : Colors.orange,
        ),
        onTap: () => _showEventDetails(event),
      ),
    );
  }

  String _formatTime(DateTime dateTime) {
    return '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
  }

  String _formatDate(DateTime dateTime) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final eventDate = DateTime(dateTime.year, dateTime.month, dateTime.day);

    if (eventDate == today) {
      return AppLocalizations.of(context)?.today ?? 'Today';
    } else if (eventDate == today.subtract(const Duration(days: 1))) {
      return 'Yesterday';
    } else {
      return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
    }
  }

  void _showEventDetails(model.GeofenceEvent event) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(event.locationName),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${AppLocalizations.of(context)?.event ?? 'Event'}: ${event.eventTypeText}',
            ),
            const SizedBox(height: 8),
            Text(
              '${AppLocalizations.of(context)?.date ?? 'Date'}: ${event.timestamp.toString().split('.')[0]}',
            ),
            const SizedBox(height: 8),
            Text(
              '${AppLocalizations.of(context)?.location ?? 'Location'}: ${event.latitude.toStringAsFixed(6)}, ${event.longitude.toStringAsFixed(6)}',
            ),
            if (event.notes != null) ...[
              const SizedBox(height: 8),
              Text(
                '${AppLocalizations.of(context)?.notes ?? 'Notes'}: ${event.notes}',
              ),
            ],
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(AppLocalizations.of(context)?.close ?? 'Close'),
          ),
        ],
      ),
    );
  }
}
