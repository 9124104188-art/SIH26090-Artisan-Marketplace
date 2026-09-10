import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class FilterScreen extends StatefulWidget {
  final ValueChanged<String> onApply;
  const FilterScreen({super.key, required this.onApply});
  @override
  State<FilterScreen> createState() => _FilterScreenState();
}

class _FilterScreenState extends State<FilterScreen> {
  String selected = 'Relevance';
  double max = 2500;
  @override
  Widget build(BuildContext context) => Scaffold(
      appBar: AppBar(title: const Text('Filter & Sort')),
      body: ListView(padding: const EdgeInsets.all(18), children: [
        const Text('Sort By',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900)),
        RadioGroup<String>(
            groupValue: selected,
            onChanged: (v) => setState(() => selected = v!),
            child: Column(children: [
              ...[
                'Relevance',
                'Price: Low to High',
                'Price: High to Low',
                'Newest First',
                'Top Rated'
              ].map((s) => RadioListTile<String>(
                  value: s, title: Text(s), activeColor: AppColors.green))
            ])),
        const Divider(),
        const Text('Price Range',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900)),
        RangeSlider(
            values: RangeValues(0, max),
            min: 0,
            max: 3000,
            divisions: 30,
            activeColor: AppColors.green,
            onChanged: (v) => setState(() => max = v.end)),
        Text('₹0 - ₹${max.toInt()}'),
        const SizedBox(height: 22),
        Row(children: [
          Expanded(
              child: OutlinedButton(
                  onPressed: () => setState(() => selected = 'Relevance'),
                  child: const Text('Reset'))),
          const SizedBox(width: 12),
          Expanded(
              child: ElevatedButton(
                  onPressed: () {
                    widget.onApply(selected);
                    Navigator.pop(context);
                  },
                  child: const Text('Apply')))
        ])
      ]));
}
