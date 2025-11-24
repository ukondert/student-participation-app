import 'package:flutter/material.dart';
import 'base_page_template.dart';
import '../../core/theme/tokens/spacing.dart';

/// Form Page Template
/// 
/// Standard template for form-based pages with scrollable content.
class FormPageTemplate extends StatelessWidget {
  final String title;
  final Widget form;
  final List<Widget>? actions;
  final bool showBottomNavigation;

  const FormPageTemplate({
    super.key,
    required this.title,
    required this.form,
    this.actions,
    this.showBottomNavigation = false,
  });

  @override
  Widget build(BuildContext context) {
    return BasePageTemplate(
      title: title,
      body: SingleChildScrollView(
        padding: EdgeInsets.all(AppSpacing.screenPadding),
        child: form,
      ),
      actions: actions,
      showBottomNavigation: showBottomNavigation,
    );
  }
}
