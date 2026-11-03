import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:beatit_front_app/src/core/extensions/app_gray_colors.dart';
import 'package:beatit_front_app/src/core/extensions/app_theme_extension.dart';
import 'package:beatit_front_app/src/core/theme/app_fonts.dart';
import 'package:beatit_front_app/src/core/theme/app_radius.dart';
import 'package:beatit_front_app/src/core/theme/app_spacing.dart';
import 'package:beatit_front_app/src/core/widgets/appbars/app_top_appbar.dart';

// Flutter LicenseRegistry 데이터 모델
class _PackageLicense {
  final String packageName;
  final List<String> paragraphs;

  _PackageLicense({required this.packageName, required this.paragraphs});
}

class OpenSourceLicensePage extends StatefulWidget {
  const OpenSourceLicensePage({super.key});

  @override
  State<OpenSourceLicensePage> createState() => _OpenSourceLicensePageState();
}

class _OpenSourceLicensePageState extends State<OpenSourceLicensePage> {
  late Future<List<_PackageLicense>> _licensesFuture;

  @override
  void initState() {
    super.initState();
    _licensesFuture = _loadLicenses();
  }

  // Flutter에 내장된 LicenseRegistry에서 설치된 라이선스 목록 로드
  Future<List<_PackageLicense>> _loadLicenses() async {
    final Map<String, List<String>> packageMap = {};

    await for (final LicenseEntry entry in LicenseRegistry.licenses) {
      final paragraphs = entry.paragraphs.map((p) => p.text).toList();
      for (final package in entry.packages) {
        if (!packageMap.containsKey(package)) {
          packageMap[package] = [];
        }
        packageMap[package]!.addAll(paragraphs);
      }
    }

    final sortedKeys = packageMap.keys.toList()..sort();
    return sortedKeys
        .map(
          (pkg) =>
              _PackageLicense(packageName: pkg, paragraphs: packageMap[pkg]!),
        )
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colors.surface,
      appBar: AppTopAppBar.backOnly(
        onBackPressed: () => Navigator.of(context).pop(),
      ),
      body: SafeArea(
        child: FutureBuilder<List<_PackageLicense>>(
          future: _licensesFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            final licenses = snapshot.data ?? [];

            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.x20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: AppSpacing.x16),
                  Text(
                    '오픈소스 라이선스',
                    style: FontStyles.bold34.copyWith(
                      color: colors.onSurface,
                      letterSpacing: -0.68,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.x24),

                  // 1. 상단 오픈소스 라이선스 고지 회색 박스
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(AppSpacing.x16),
                    decoration: BoxDecoration(
                      color: context.grays.gray8,
                      borderRadius: BorderRadius.circular(AppRadius.md),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '오픈소스 라이선스 고지 (Open Source License Notice)',
                          style: FontStyles.bold14.copyWith(
                            color: colors.onSurface,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Beat It(이하 "빗잇")은 서비스 개발을 위해 다양한 오픈소스 소프트웨어를 활용하고 있으며, 오픈소스 커뮤니티의 기여에 깊이 감사드립니다. 본 애플리케이션에 포함된 오픈소스 소프트웨어 목록 및 각 라이선스 전문은 아래와 같습니다.',
                          style: FontStyles.reg14.copyWith(
                            color: colors.onSurface,
                            height: 1.5,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: AppSpacing.x24),

                  // 2. Flutter에 실제로 등록된 라이선스 목록 (아코디언 형태)
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: licenses.length,
                    separatorBuilder: (_, __) =>
                        const SizedBox(height: AppSpacing.x16),
                    itemBuilder: (context, index) {
                      return _LicenseAccordionItem(item: licenses[index]);
                    },
                  ),

                  const SizedBox(height: AppSpacing.x24),

                  // 3. 하단 카피라이트 문구
                  Text(
                    '© 2026 [Beat It]. All rights reserved. 이 앱은 오픈소스 소프트웨어를 포함하고 있으며, 각 라이선스의 조건에 따라 배포됩니다.',
                    style: FontStyles.reg12.copyWith(
                      color: colors.onSurface,
                      height: 1.5,
                    ),
                  ),

                  const SizedBox(height: AppSpacing.x40),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

// 개별 라이선스 아코디언 위젯
class _LicenseAccordionItem extends StatefulWidget {
  final _PackageLicense item;

  const _LicenseAccordionItem({required this.item});

  @override
  State<_LicenseAccordionItem> createState() => _LicenseAccordionItemState();
}

class _LicenseAccordionItemState extends State<_LicenseAccordionItem> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 패키지 이름 + 화살표 토글
        GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () {
            setState(() {
              _isExpanded = !_isExpanded;
            });
          },
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                widget.item.packageName,
                style: FontStyles.bold14.copyWith(color: colors.onSurface),
              ),
              const SizedBox(width: 4),
              Icon(
                _isExpanded
                    ? Icons.arrow_drop_up_rounded
                    : Icons.arrow_drop_down_rounded,
                color: colors.onSurface,
                size: 24,
              ),
            ],
          ),
        ),

        // 펼쳐졌을 때 라이선스 내용 노출
        if (_isExpanded) ...[
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.only(left: 4.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: widget.item.paragraphs.map((paragraph) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 6.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '• ',
                        style: FontStyles.reg14.copyWith(
                          color: context.grays.gray4,
                          height: 1.4,
                        ),
                      ),
                      Expanded(
                        child: Text(
                          paragraph.trim(),
                          style: FontStyles.reg14.copyWith(
                            color: context.grays.gray4,
                            height: 1.4,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ],
    );
  }
}
