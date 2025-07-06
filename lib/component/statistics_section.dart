import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class StatisticsSection extends StatelessWidget {
  const StatisticsSection();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Statistics',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Color(0xFF333333),
          ),
        ),
        const SizedBox(height: 5),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Expanded(
              flex: 2,
              child: _WeightChartCard(),
            ),
            const SizedBox(width: 16),
            Expanded(
              flex: 1,
              child: Column(
                children: [
                  _InfoCard(
                    icon: Icons.edit_note_outlined,
                    iconColor: Colors.orange,
                    label: 'FCR',
                    value: '0.086',
                    unit: '',
                  ),
                  const SizedBox(height: 5),
                  _InfoCard(
                    icon: Icons.calendar_month,
                    iconColor: Colors.purple,
                    label: 'Umur',
                    value: '25',
                    unit: 'Hari',
                  ),
                ],
              ),
            ),
          ],
        )
      ],
    );
  }
}

// Anda bisa menamai ulang class ini, misalnya menjadi _WeightChartCard
class _WeightChartCard extends StatelessWidget {
  const _WeightChartCard({super.key});

  @override
  Widget build(BuildContext context) {
    // Definisikan data bobot ayam Anda di sini
    final List<FlSpot> dataBobotAyam = [
      FlSpot(1, 45), FlSpot(7, 180), FlSpot(14, 450),
      FlSpot(21, 900), FlSpot(28, 1500), FlSpot(35, 2100),
    ];

    // Ambil data bobot terakhir untuk ditampilkan
    final lastWeight = dataBobotAyam.last.y.toInt();

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(
          colors: [
            Colors.green.withOpacity(0.1), // GANTI: Warna gradasi
            Colors.white.withOpacity(0.5),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.1), // GANTI: Warna ikon
                  borderRadius: BorderRadius.circular(12),
                ),
                // GANTI: Ikon yang lebih sesuai, misal ikon hewan atau grafik
                child: const Icon(Icons.show_chart, color: Colors.green, size: 20),
              ),
              const SizedBox(width: 8),
              const Text(
                'Bobot Ayam',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 70,
            child: LineChart(
              LineChartData(
                gridData: const FlGridData(show: false),
                titlesData: const FlTitlesData(show: false),
                borderData: FlBorderData(show: false),
                lineBarsData: [
                  LineChartBarData(
                    // GANTI: Gunakan data bobot ayam
                    spots: dataBobotAyam,
                    isCurved: true,
                    // GANTI: Warna garis grafik agar sesuai tema
                    color: Colors.green,
                    barWidth: 4,
                    isStrokeCapRound: true,
                    dotData: const FlDotData(show: false),
                    belowBarData: BarAreaData(show: false),
                  )
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          // GANTI: Tampilkan data bobot terakhir
          Text(
            '$lastWeight', // Menampilkan bobot terakhir dari data
            style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
          ),
          // GANTI: Satuan menjadi "Gram"
          const Text(
            'Gram',
            style: TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String label;
  final String value;
  final String unit;

  const _InfoCard({
    required this.icon,
    required this.iconColor,
    required this.label,
    required this.value,
    required this.unit,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 10,
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                label,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: iconColor.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(icon, color: iconColor, size: 20)),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Flexible(
                fit: FlexFit.loose,
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    value,
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 4),
              Text(unit),
            ],
          )
        ],
      ),
    );
  }
}

