import 'package:flutter/material.dart';
import '../../../../widgets/custom_shimmer_widget.dart';

class JobCardShimmer extends StatelessWidget {
  final bool isDark;
  const JobCardShimmer({super.key, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xff141D2C) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? Colors.white12 : Colors.black12,
          width: 0.5,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Icon
          CustomShimmerWidget.rectangular(
            height: 48,
            width: 48,
            isDark: isDark,
            shapeBorder: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
          const SizedBox(height: 16),

          // Title
          CustomShimmerWidget.rectangular(
            height: 20,
            width: 200,
            isDark: isDark,
          ),
          const SizedBox(height: 8),

          // Company
          CustomShimmerWidget.rectangular(
            height: 14,
            width: 120,
            isDark: isDark,
          ),
          const SizedBox(height: 16),

          // Tags
          Row(
            children: List.generate(3, (i) => Padding(
              padding: const EdgeInsets.only(right: 8),
              child: CustomShimmerWidget.rectangular(
                height: 24,
                width: 60,
                isDark: isDark,
                shapeBorder: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
            )),
          ),
          const SizedBox(height: 16),

          // Details Row
          Row(
            children: List.generate(3, (i) => Expanded(
              child: Padding(
                padding: const EdgeInsets.only(right: 8),
                child: CustomShimmerWidget.rectangular(
                  height: 12,
                  isDark: isDark,
                ),
              ),
            )),
          ),
        ],
      ),
    );
  }
}
