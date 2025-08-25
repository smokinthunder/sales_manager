import 'package:flutter/material.dart';

class ConsolidatedAnalyticScreen extends StatefulWidget {
  const ConsolidatedAnalyticScreen({super.key});

  @override
  State<ConsolidatedAnalyticScreen> createState() =>
      _ConsolidatedAnalyticScreenState();
}

class _ConsolidatedAnalyticScreenState
    extends State<ConsolidatedAnalyticScreen> {
  // Form state
  String shopName = 'ABC Plumbing';
  String shopLocation = 'Kochi';
  String shopArea = 'Aluva';

  bool purchaseAnalysis = true;
  bool bestSelling = true;
  bool salesReport = true;

  String compareFrom = '2023';
  String compareTo = '2024';

  int currentIndex = 1; // bottom nav selected (Analytics)

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _FilterCard(
                shopName: shopName,
                shopLocation: shopLocation,
                shopArea: shopArea,
                purchaseAnalysis: purchaseAnalysis,
                bestSelling: bestSelling,
                salesReport: salesReport,
                onChanged: (s) => setState(() {
                  shopName = s.shopName;
                  shopLocation = s.shopLocation;
                  shopArea = s.shopArea;
                  purchaseAnalysis = s.purchaseAnalysis;
                  bestSelling = s.bestSelling;
                  salesReport = s.salesReport;
                }),
              ),
              const SizedBox(height: 16),

              // Purchase Analysis (bar sparkline style)
              _SectionTitle(
                title: 'Purchase Analysis',
                legend: const [
                  LegendItem('Purchase', Color(0xFF8BC34A)),
                  LegendItem('Not Purchase', Colors.grey),
                ],
              ),
              const SizedBox(height: 8),
              const _MonthlyBarChart(),

              const SizedBox(height: 16),

              // Best Selling Products (pie + legend)
              const _SectionTitle(title: 'Best Selling Products'),
              const SizedBox(height: 8),
              const _BestSellingPie(),

              const SizedBox(height: 16),

              // Sales report line
              const _SectionTitle(title: 'Sales Report'),
              const SizedBox(height: 8),
              const _LineChart(height: 120),

              const SizedBox(height: 16),

              // Comparing Analytics
              _CompareCard(
                from: compareFrom,
                to: compareTo,
                onChanged: (a, b) => setState(() {
                  compareFrom = a;
                  compareTo = b;
                }),
              ),

              const SizedBox(height: 12),
              FilledButton(onPressed: () {}, child: const Text('Compare')),

              const SizedBox(height: 16),

              const _SectionTitle(
                title: 'Purchase Analysis',
                legend: [
                  LegendItem('Purchase', Color(0xFF8BC34A)),
                  LegendItem('Not Purchase', Colors.grey),
                ],
              ),
              const SizedBox(height: 8),

              // Monthly purchase value cards
              Row(
                children: const [
                  Expanded(
                    child: _InfoCard(
                      title: '2023',
                      lines: ['Purchase : 10 Month', 'Not purchase : 2 Month'],
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: _InfoCard(
                      title: '2024',
                      lines: ['Purchase : 11 Month', 'Not purchase : 1 Month'],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.expand_less_rounded),
                  label: const Text('More details'),
                ),
              ),

              // Month grid indicators
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Expanded(child: _MonthStatusColumn(year: '2023')),
                  SizedBox(width: 16),
                  Expanded(child: _MonthStatusColumn(year: '2024')),
                ],
              ),

              const SizedBox(height: 16),

              // Best Selling Products list by year
              const _SectionTitle(title: 'Best Selling Products'),
              const SizedBox(height: 12),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Expanded(
                    child: _BulletedList(
                      year: '2023',
                      items: [
                        'ELBOW SOCKET 90',
                        'RAIN WATER CHAMBER',
                        'RAIN WATER PIPES',
                        'ELBOW SOCKET 60',
                      ],
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: _BulletedList(
                      year: '2024',
                      items: [
                        'RAIN WATER CHAMBER',
                        'RAIN WATER PIPES',
                        'RAIN WATER CHAMBER',
                        'ELBOW SOCKET 90',
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              const _SectionTitle(
                title: 'Sales Report',
                legend: [
                  LegendItem('2023', Color(0xFF2196F3)),
                  LegendItem('2024', Color(0xFF8BC34A)),
                ],
              ),
              const SizedBox(height: 8),
              const _LineChart(height: 140),

              const SizedBox(height: 8),
              Row(
                children: [
                  TextButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.download_rounded),
                    label: const Text('Download Report'),
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.share_outlined),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ===== Widgets =====

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.title, this.legend});
  final String title;
  final List<LegendItem>? legend;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          title,
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
        ),
        const Spacer(),
        if (legend != null)
          Row(
            children: [
              for (final item in legend!)
                Padding(
                  padding: const EdgeInsets.only(left: 8),
                  child: Row(
                    children: [
                      _Dot(color: item.color),
                      const SizedBox(width: 4),
                      Text(
                        item.label,
                        style: Theme.of(context).textTheme.labelSmall,
                      ),
                    ],
                  ),
                ),
            ],
          ),
      ],
    );
  }
}

class LegendItem {
  final String label;
  final Color color;
  const LegendItem(this.label, this.color);
}

class _Dot extends StatelessWidget {
  const _Dot({required this.color, this.size = 12});
  final Color color;
  final double size;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    );
  }
}

class _FilterCard extends StatelessWidget {
  const _FilterCard({
    required this.shopName,
    required this.shopLocation,
    required this.shopArea,
    required this.purchaseAnalysis,
    required this.bestSelling,
    required this.salesReport,
    required this.onChanged,
  });

  final String shopName;
  final String shopLocation;
  final String shopArea;
  final bool purchaseAnalysis;
  final bool bestSelling;
  final bool salesReport;
  final void Function(_FilterState) onChanged;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: Color(0xFFEAEAEA)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: _LabeledDropdown(
                    label: 'Select shop name',
                    value: shopName,
                    items: const [
                      'ABC Plumbing',
                      'XYZ Traders',
                      'PQR Hardware',
                    ],
                    onChanged: (v) => onChanged(
                      _FilterState(
                        shopName: v!,
                        shopLocation: shopLocation,
                        shopArea: shopArea,
                        purchaseAnalysis: purchaseAnalysis,
                        bestSelling: bestSelling,
                        salesReport: salesReport,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: _LabeledDropdown(
                    label: 'Select shop location',
                    value: shopLocation,
                    items: const ['Kochi', 'Thrissur', 'Calicut'],
                    onChanged: (v) => onChanged(
                      _FilterState(
                        shopName: shopName,
                        shopLocation: v!,
                        shopArea: shopArea,
                        purchaseAnalysis: purchaseAnalysis,
                        bestSelling: bestSelling,
                        salesReport: salesReport,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _LabeledDropdown(
                    label: 'Select shop area',
                    value: shopArea,
                    items: const ['Aluva', 'Palarivattom', 'Edappally'],
                    onChanged: (v) => onChanged(
                      _FilterState(
                        shopName: shopName,
                        shopLocation: shopLocation,
                        shopArea: v!,
                        purchaseAnalysis: purchaseAnalysis,
                        bestSelling: bestSelling,
                        salesReport: salesReport,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text('More details', style: Theme.of(context).textTheme.labelSmall),
            const SizedBox(height: 6),
            Row(
              children: [
                Expanded(
                  child: _ToggleLine(
                    label: 'Purchase Analysis',
                    value: purchaseAnalysis,
                    onChanged: (v) => onChanged(
                      _FilterState(
                        shopName: shopName,
                        shopLocation: shopLocation,
                        shopArea: shopArea,
                        purchaseAnalysis: v,
                        bestSelling: bestSelling,
                        salesReport: salesReport,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _ToggleLine(
                    label: 'Best Selling Product',
                    value: bestSelling,
                    onChanged: (v) => onChanged(
                      _FilterState(
                        shopName: shopName,
                        shopLocation: shopLocation,
                        shopArea: shopArea,
                        purchaseAnalysis: purchaseAnalysis,
                        bestSelling: v,
                        salesReport: salesReport,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _ToggleLine(
                    label: 'Sales Report',
                    value: salesReport,
                    onChanged: (v) => onChanged(
                      _FilterState(
                        shopName: shopName,
                        shopLocation: shopLocation,
                        shopArea: shopArea,
                        purchaseAnalysis: purchaseAnalysis,
                        bestSelling: bestSelling,
                        salesReport: v,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            FilledButton(onPressed: () {}, child: const Text('Find Analytics')),
          ],
        ),
      ),
    );
  }
}

class _FilterState {
  final String shopName;
  final String shopLocation;
  final String shopArea;
  final bool purchaseAnalysis;
  final bool bestSelling;
  final bool salesReport;
  _FilterState({
    required this.shopName,
    required this.shopLocation,
    required this.shopArea,
    required this.purchaseAnalysis,
    required this.bestSelling,
    required this.salesReport,
  });
}

class _LabeledDropdown extends StatelessWidget {
  const _LabeledDropdown({
    required this.label,
    required this.value,
    required this.items,
    required this.onChanged,
  });
  final String label;
  final String value;
  final List<String> items;
  final ValueChanged<String?> onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: Theme.of(context).textTheme.labelSmall),
        const SizedBox(height: 6),
        DropdownButtonFormField<String>(
          value: value,
          borderRadius: BorderRadius.circular(12),
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 12,
            ),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
            ),
          ),
          items: [
            for (final s in items) DropdownMenuItem(value: s, child: Text(s)),
          ],
          onChanged: onChanged,
        ),
      ],
    );
  }
}

class _ToggleLine extends StatelessWidget {
  const _ToggleLine({
    required this.label,
    required this.value,
    required this.onChanged,
  });
  final String label;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(label, style: Theme.of(context).textTheme.bodyMedium),
        ),
        Switch(value: value, onChanged: onChanged),
      ],
    );
  }
}

class _MonthlyBarChart extends StatelessWidget {
  const _MonthlyBarChart();
  @override
  Widget build(BuildContext context) {
    final months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    final purchase = [2, 3, 3, 2, 3, 3, 4, 3, 2, 3, 2, 3];
    final notPurchase = [1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1];

    return Column(
      children: [
        SizedBox(
          height: 110,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              for (int i = 0; i < months.length; i++) ...[
                _BarPair(
                  purchase: purchase[i].toDouble(),
                  notPurchase: notPurchase[i].toDouble(),
                ),
                if (i != months.length - 1) const SizedBox(width: 8),
              ],
            ],
          ),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            for (final m in months)
              Expanded(
                child: Center(
                  child: Text(m, style: Theme.of(context).textTheme.labelSmall),
                ),
              ),
          ],
        ),
      ],
    );
  }
}

class _BarPair extends StatelessWidget {
  const _BarPair({required this.purchase, required this.notPurchase});
  final double purchase;
  final double notPurchase;
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Container(
            height: 12 * notPurchase,
            decoration: BoxDecoration(
              color: Colors.grey.shade400,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          const SizedBox(height: 4),
          Container(
            height: 24 * purchase,
            decoration: BoxDecoration(
              color: const Color(0xFF8BC34A),
              borderRadius: BorderRadius.circular(4),
            ),
          ),
        ],
      ),
    );
  }
}

class _BestSellingPie extends StatelessWidget {
  const _BestSellingPie();
  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          width: 140,
          height: 140,
          child: CustomPaint(
            painter: _PiePainter([
              _Slice(0.60, const Color(0xFF4CAF50)),
              _Slice(0.30, const Color(0xFFFFB300)),
              _Slice(0.10, const Color(0xFF1E88E5)),
            ]),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              _LegendRow(color: Color(0xFF1E88E5), text: 'RAIN WATER CHAMBER'),
              SizedBox(height: 6),
              _LegendRow(color: Color(0xFFFFB300), text: 'RAIN WATER PIPES'),
              SizedBox(height: 6),
              _LegendRow(color: Color(0xFF4CAF50), text: 'ELBOW SOCKET 90'),
            ],
          ),
        ),
      ],
    );
  }
}

class _LegendRow extends StatelessWidget {
  const _LegendRow({required this.color, required this.text});
  final Color color;
  final String text;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 14,
          height: 14,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 8),
        Expanded(child: Text(text)),
      ],
    );
  }
}

class _Slice {
  final double ratio;
  final Color color;
  const _Slice(this.ratio, this.color);
}

class _PiePainter extends CustomPainter {
  final List<_Slice> slices;
  _PiePainter(this.slices);
  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    double start = -90 * 3.14159 / 180; // start at top
    final paint = Paint()..style = PaintingStyle.fill;
    for (final s in slices) {
      final sweep = s.ratio * 6.28318;
      paint.color = s.color;
      canvas.drawArc(rect, start, sweep, true, paint);
      start += sweep;
    }
    // inner hole (donut look)
    canvas.drawCircle(
      size.center(Offset.zero),
      size.width * 0.28,
      Paint()..color = Colors.white,
    );
  }

  @override
  bool shouldRepaint(covariant _PiePainter oldDelegate) =>
      oldDelegate.slices != slices;
}

class _LineChart extends StatelessWidget {
  const _LineChart({this.height = 120});
  final double height;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: CustomPaint(
        painter: _LinePainter(),
        child: const SizedBox.expand(),
      ),
    );
  }
}

class _LinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final grid = Paint()
      ..color = Colors.grey.shade300
      ..strokeWidth = 1;
    for (int i = 1; i < 4; i++) {
      final y = size.height * (i / 4);
      canvas.drawLine(Offset(0, y), Offset(size.width, y), grid);
    }

    final path2023 = Path();
    final path2024 = Path();

    List<double> v1 = [10, 14, 12, 18, 30, 22, 16, 14, 18, 15, 20, 24];
    List<double> v2 = [12, 11, 14, 16, 20, 28, 22, 18, 16, 19, 17, 26];

    double dx = size.width / (v1.length - 1);
    double maxY = 32; // simple scale

    path2023.moveTo(0, size.height * (1 - v1[0] / maxY));
    path2024.moveTo(0, size.height * (1 - v2[0] / maxY));
    for (int i = 1; i < v1.length; i++) {
      path2023.lineTo(dx * i, size.height * (1 - v1[i] / maxY));
      path2024.lineTo(dx * i, size.height * (1 - v2[i] / maxY));
    }

    final p1 = Paint()
      ..color = const Color(0xFF2196F3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    final p2 = Paint()
      ..color = const Color(0xFF8BC34A)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    canvas.drawPath(path2023, p1);
    canvas.drawPath(path2024, p2);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _InfoCard extends StatelessWidget {
  const _InfoCard({required this.title, required this.lines});
  final String title;
  final List<String> lines;
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: Color(0xFFEAEAEA)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            for (final l in lines)
              Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Text(l),
              ),
          ],
        ),
      ),
    );
  }
}

class _MonthStatusColumn extends StatelessWidget {
  const _MonthStatusColumn({required this.year});
  final String year;
  @override
  Widget build(BuildContext context) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          year,
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),
        for (final m in months)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Row(
              children: [
                SizedBox(width: 30, child: Text(m)),
                const SizedBox(width: 8),
                Container(
                  width: 10,
                  height: 10,
                  decoration: const BoxDecoration(
                    color: Colors.grey,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 6),
                Container(
                  width: 10,
                  height: 10,
                  decoration: const BoxDecoration(
                    color: Color(0xFF8BC34A),
                    shape: BoxShape.circle,
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}

class _BulletedList extends StatelessWidget {
  const _BulletedList({required this.year, required this.items});
  final String year;
  final List<String> items;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          year,
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),
        for (final it in items)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 6),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('\u2022 '),
                Expanded(child: Text(it)),
              ],
            ),
          ),
      ],
    );
  }
}

class _CompareCard extends StatelessWidget {
  const _CompareCard({
    required this.from,
    required this.to,
    required this.onChanged,
  });
  final String from;
  final String to;
  final void Function(String from, String to) onChanged;
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: Color(0xFFEAEAEA)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Comparing Analytics',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: _LabeledDropdown(
                    label: 'Select year to compare',
                    value: from,
                    items: const ['2022', '2023', '2024'],
                    onChanged: (v) => onChanged(v!, to),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _LabeledDropdown(
                    label: '',
                    value: to,
                    items: const ['2022', '2023', '2024'],
                    onChanged: (v) => onChanged(from, v!),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
