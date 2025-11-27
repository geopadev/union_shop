import 'package:flutter/material.dart';

class SharedFooter extends StatelessWidget {
  final Widget? additionalContent;

  const SharedFooter({
    super.key,
    this.additionalContent,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      key: const Key('footer_main'),
      width: double.infinity,
      color: Colors.grey[50],
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Placeholder Footer',
            style: TextStyle(
              color: Colors.grey,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          if (additionalContent != null) ...[
            const SizedBox(height: 16),
            additionalContent!,
          ],
        ],
      ),
    );
  }
}
