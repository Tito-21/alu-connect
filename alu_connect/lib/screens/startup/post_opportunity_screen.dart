import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import '../../models/opportunity.dart';
import '../../providers/auth_provider.dart';
import '../../providers/opportunity_provider.dart';
import '../../services/firestore_service.dart';

class PostOpportunityScreen extends StatefulWidget {
  const PostOpportunityScreen({super.key});

  @override
  State<PostOpportunityScreen> createState() => _PostOpportunityScreenState();
}

class _PostOpportunityScreenState extends State<PostOpportunityScreen> {
  final _titleCtrl = TextEditingController();
  final _descCtrl = TextEditingController();
  final _skillsCtrl = TextEditingController();
  String _workType = 'Part-time';
  String _category = 'Engineering';
  bool _isSubmitting = false;

  final _workTypes = const ['Part-time', 'Remote', 'On-campus'];
  final _categories = const ['Design', 'Engineering', 'Marketing', 'Data', 'Other'];

  Future<void> _submit() async {
    if (_titleCtrl.text.trim().isEmpty || _descCtrl.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in the title and description.')),
      );
      return;
    }

    setState(() => _isSubmitting = true);
    final auth = context.read<AuthProvider>();
    final ownerUid = auth.currentUser!.uid;
    final startup = await FirestoreService().watchStartupByOwner(ownerUid).first;

    if (startup == null) {
      setState(() => _isSubmitting = false);
      return;
    }

    final opp = Opportunity(
      id: const Uuid().v4(),
      startupId: startup.id,
      startupName: startup.name,
      title: _titleCtrl.text.trim(),
      description: _descCtrl.text.trim(),
      skillsRequired: _skillsCtrl.text.split(',').map((s) => s.trim()).where((s) => s.isNotEmpty).toList(),
      workType: _workType,
      category: _category,
      postedAt: DateTime.now(),
    );

    await context.read<OpportunityProvider>().postOpportunity(opp);

    if (!mounted) return;
    setState(() => _isSubmitting = false);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Post Opportunity')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: ListView(
          children: [
            TextField(controller: _titleCtrl, decoration: const InputDecoration(labelText: 'Title')),
            const SizedBox(height: 14),
            TextField(
              controller: _descCtrl,
              maxLines: 4,
              decoration: const InputDecoration(labelText: 'Description'),
            ),
            const SizedBox(height: 14),
            TextField(
              controller: _skillsCtrl,
              decoration: const InputDecoration(labelText: 'Skills required (comma separated)'),
            ),
            const SizedBox(height: 14),
            DropdownButtonFormField<String>(
              value: _workType,
              decoration: const InputDecoration(labelText: 'Work type'),
              items: _workTypes.map((t) => DropdownMenuItem(value: t, child: Text(t))).toList(),
              onChanged: (v) => setState(() => _workType = v!),
            ),
            const SizedBox(height: 14),
            DropdownButtonFormField<String>(
              value: _category,
              decoration: const InputDecoration(labelText: 'Category'),
              items: _categories.map((t) => DropdownMenuItem(value: t, child: Text(t))).toList(),
              onChanged: (v) => setState(() => _category = v!),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _isSubmitting ? null : _submit,
              child: _isSubmitting
                  ? const SizedBox(
                      height: 20, width: 20,
                      child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                  : const Text('Post'),
            ),
          ],
        ),
      ),
    );
  }
}
