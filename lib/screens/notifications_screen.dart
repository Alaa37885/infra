import 'package:flutter/material.dart';
import 'package:inframind/theme/app_theme.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> notifications = [
      {
        'title': 'اكتشاف جديد بالذكاء الاصطناعي',
        'body': 'تم رصد حفرة عميقة في طريق صلاح سالم بمستوى ثقة 92%.',
        'time': 'منذ 10 دقائق',
        'type': 'ai',
        'read': false,
      },
      {
        'title': 'تحديث حالة بلاغ (#INF-9020)',
        'body': 'تم اكتمال أعمال صيانة الشق الطولي في محور الشهيد.',
        'time': 'منذ ساعة',
        'type': 'status',
        'read': false,
      },
      {
        'title': 'تنبيه أولوية عالية (Critical)',
        'body': 'هبوط أرضي جزئي في كورنيش النيل يتطلب توجيه فرقة طوارئ فورية.',
        'time': 'منذ 3 ساعات',
        'type': 'alert',
        'read': true,
      },
      {
        'title': 'تقرير المتابعة الأسبوعي',
        'body': 'تم إصدار تقرير كفاءة الطرق الأسبوعي للقاهرة الكبرى بنجاح.',
        'time': 'أمس',
        'type': 'report',
        'read': true,
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('الإشعارات والتنبيهات', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        actions: [
          IconButton(
            icon: const Icon(Icons.done_all, color: AppColors.gold),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('تم تعليم كافة الإشعارات كمقروءة')),
              );
            },
          ),
        ],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        physics: const BouncingScrollPhysics(),
        itemCount: notifications.length,
        itemBuilder: (context, index) {
          final item = notifications[index];
          final isUnread = !(item['read'] as bool);
          final iconData = switch (item['type']) {
            'ai' => Icons.radar_rounded,
            'status' => Icons.task_alt_rounded,
            'alert' => Icons.warning_rounded,
            _ => Icons.description_rounded,
          };
          final iconColor = switch (item['type']) {
            'ai' => AppColors.gold,
            'status' => AppColors.greenLight,
            'alert' => AppColors.red,
            _ => AppColors.goldLight,
          };

          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: isUnread ? AppColors.surface : AppColors.surface.withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isUnread ? AppColors.gold.withValues(alpha: 0.4) : AppColors.surfaceGlassBorder,
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: iconColor.withValues(alpha: 0.15),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(iconData, color: iconColor, size: 22),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              item['title'],
                              style: TextStyle(
                                fontWeight: isUnread ? FontWeight.bold : FontWeight.w600,
                                fontSize: 14,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          if (isUnread)
                            Container(
                              width: 8,
                              height: 8,
                              decoration: const BoxDecoration(
                                color: AppColors.red,
                                shape: BoxShape.circle,
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        item['body'],
                        style: const TextStyle(fontSize: 12, color: AppColors.textGrayLight, height: 1.3),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        item['time'],
                        style: const TextStyle(fontSize: 10, color: AppColors.textGray),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
