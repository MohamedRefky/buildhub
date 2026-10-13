import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/localization/app_localization.dart';
import '../../../../core/theme/app_colors.dart';
import '../../data/repositories/buildhub_repository.dart';
import '../../domain/entities/home_entities.dart';

class AddProjectDialog extends StatefulWidget {
  const AddProjectDialog({super.key});

  static Future<void> show(BuildContext context) {
    return showDialog(
      context: context,
      builder: (_) => const AddProjectDialog(),
    );
  }

  @override
  State<AddProjectDialog> createState() => _AddProjectDialogState();
}

class _AddProjectDialogState extends State<AddProjectDialog> {
  final _nameArCtrl = TextEditingController();
  final _nameEnCtrl = TextEditingController();
  final _budgetCtrl = TextEditingController(text: '15000000');
  final _locationCtrl = TextEditingController(text: 'Dubai, UAE');

  @override
  void dispose() {
    _nameArCtrl.dispose();
    _nameEnCtrl.dispose();
    _budgetCtrl.dispose();
    _locationCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final loc = context.watch<AppLocalization>();
    final repo = context.read<BuildHubRepository>();

    return AlertDialog(
      backgroundColor: AppColors.darkSurface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
        side: const BorderSide(color: AppColors.darkBorder, width: 0.8),
      ),
      title: Text(
        loc.tr('إضافة مشروع جديد', 'Add New Project'),
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _nameArCtrl,
              style: const TextStyle(color: Colors.white, fontSize: 13),
              decoration: InputDecoration(
                labelText: loc.tr('اسم المشروع (بالعربية)', 'Project Name (Arabic)'),
                labelStyle: const TextStyle(color: Colors.white60, fontSize: 12),
                hintText: 'برج الخليج التجاري...',
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _nameEnCtrl,
              style: const TextStyle(color: Colors.white, fontSize: 13),
              decoration: InputDecoration(
                labelText: loc.tr('اسم المشروع (بالإنجليزية)', 'Project Name (English)'),
                labelStyle: const TextStyle(color: Colors.white60, fontSize: 12),
                hintText: 'Business Bay Tower...',
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _budgetCtrl,
              keyboardType: TextInputType.number,
              style: const TextStyle(color: Colors.white, fontSize: 13),
              decoration: InputDecoration(
                labelText: loc.tr('الميزانية المعتمدة (AED)', 'Approved Budget (AED)'),
                labelStyle: const TextStyle(color: Colors.white60, fontSize: 12),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _locationCtrl,
              style: const TextStyle(color: Colors.white, fontSize: 13),
              decoration: InputDecoration(
                labelText: loc.tr('الموقع', 'Location'),
                labelStyle: const TextStyle(color: Colors.white60, fontSize: 12),
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(loc.tr('إلغاء', 'Cancel')),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.accentCyan,
            foregroundColor: Colors.black,
          ),
          onPressed: () {
            final budget = double.tryParse(_budgetCtrl.text) ?? 15000000.0;
            final codeNum = 100 + (DateTime.now().millisecond % 900);
            final newProj = Project(
              id: 'prj-${DateTime.now().millisecondsSinceEpoch}',
              nameAr: _nameArCtrl.text.trim().isNotEmpty
                  ? _nameArCtrl.text.trim()
                  : (_nameEnCtrl.text.trim().isNotEmpty ? _nameEnCtrl.text.trim() : 'مشروع جديد'),
              nameEn: _nameEnCtrl.text.trim().isNotEmpty
                  ? _nameEnCtrl.text.trim()
                  : 'New Project',
              code: 'SND-$codeNum',
              clientAr: 'حكومة دبي',
              clientEn: 'Dubai Government',
              locationAr: _locationCtrl.text.trim().isNotEmpty ? _locationCtrl.text.trim() : 'دبي، الإمارات',
              locationEn: _locationCtrl.text.trim().isNotEmpty ? _locationCtrl.text.trim() : 'Dubai, UAE',
              budgetAed: budget,
              spentAed: budget * 0.1,
              completionPercent: 10,
              daysRemaining: 240,
              cpi: 1.02,
              spi: 0.99,
            );
            repo.addProject(newProj);
            Navigator.pop(context);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  loc.tr('تم حفظ وتفعيل المشروع بنجاح', 'Project created and activated successfully'),
                ),
                backgroundColor: AppColors.darkCardElevated,
                behavior: SnackBarBehavior.floating,
              ),
            );
          },
          child: Text(loc.tr('حفظ المشروع', 'Save Project')),
        ),
      ],
    );
  }
}
