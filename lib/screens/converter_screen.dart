import 'package:flutter/material.dart';
import '../l10n/app_localizations_manual.dart';
import '../models/calendar_date.dart';
import '../models/calendar_type.dart';
import '../services/calendar_converter.dart';

class ConverterScreen extends StatefulWidget {
  const ConverterScreen({super.key});

  @override
  State<ConverterScreen> createState() => _ConverterScreenState();
}

class _ConverterScreenState extends State<ConverterScreen> {
  DateTime _selectedDate = DateTime.now();
  CalendarType _sourceCalendar = CalendarType.normal;
  CalendarDate? _convertedDate;

  void _convertDate() {
    final sourceDate = CalendarDate(
      year: _selectedDate.year,
      month: _selectedDate.month,
      day: _selectedDate.day,
      calendarType: _sourceCalendar,
    );

    setState(() {
      if (_sourceCalendar == CalendarType.normal) {
        _convertedDate = CalendarConverter.normalToNeutral(sourceDate);
      } else {
        _convertedDate = CalendarConverter.neutralToNormal(sourceDate);
      }
    });
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        _convertedDate = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(title: Text(localizations.converter)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Source Calendar Selection
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      localizations.from,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 16),
                    SegmentedButton<CalendarType>(
                      segments: [
                        ButtonSegment(
                          value: CalendarType.normal,
                          label: Text(localizations.normalCalendar),
                          icon: const Icon(Icons.calendar_today),
                        ),
                        ButtonSegment(
                          value: CalendarType.neutral,
                          label: Text(localizations.neutralCalendar),
                          icon: const Icon(Icons.calendar_month),
                        ),
                      ],
                      selected: {_sourceCalendar},
                      onSelectionChanged: (Set<CalendarType> newSelection) {
                        setState(() {
                          _sourceCalendar = newSelection.first;
                          _convertedDate = null;
                        });
                      },
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Date Selection
            Card(
              child: InkWell(
                onTap: () => _selectDate(context),
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    children: [
                      Icon(
                        Icons.event,
                        size: 48,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        localizations.selectDate,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}',
                        style: Theme.of(context).textTheme.headlineMedium
                            ?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Convert Button
            FilledButton.icon(
              onPressed: _convertDate,
              icon: const Icon(Icons.sync_alt),
              label: Text(localizations.convertDate),
              style: FilledButton.styleFrom(padding: const EdgeInsets.all(20)),
            ),
            const SizedBox(height: 24),

            // Result
            if (_convertedDate != null)
              Card(
                color: Colors.green.shade50,
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    children: [
                      Icon(
                        Icons.check_circle,
                        size: 48,
                        color: Colors.green.shade700,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        _sourceCalendar == CalendarType.normal
                            ? localizations.neutralCalendar
                            : localizations.normalCalendar,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '${_convertedDate!.day}/${_convertedDate!.month}/${_convertedDate!.year}',
                        style: Theme.of(context).textTheme.headlineMedium
                            ?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Colors.green.shade700,
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
