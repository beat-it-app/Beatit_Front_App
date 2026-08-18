import 'package:beatit_front_app/src/core/extensions/app_theme_extension.dart';
import 'package:beatit_front_app/src/core/theme/app_fonts.dart';
import 'package:beatit_front_app/src/core/theme/app_radius.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:beatit_front_app/src/core/theme/app_spacing.dart';
import 'package:beatit_front_app/src/core/widgets/appbars/app_top_appbar.dart';

class PostDetailPage extends StatefulWidget {
  const PostDetailPage({super.key});

  @override
  State<PostDetailPage> createState() => _PostDetailPageState();
}

class _PostDetailPageState extends State<PostDetailPage> {
  final idController = TextEditingController();
  final passwordController = TextEditingController();
  final passwordCheckController = TextEditingController();
  final emailController = TextEditingController();

  bool _isMapVisible = true;
  final likedNum = 100;
  final dislikedNum = 90;
  bool _isLiked = false;
  bool _isDisliked = false;

  void _toggleMapVisibility() {
    setState(() {
      _isMapVisible = !_isMapVisible;
    });
  }

  void _toggleLike() {
    setState(() {
      _isLiked = !_isLiked;
    });
  }

  void _toggleDislike() {
    setState(() {
      _isDisliked = !_isDisliked;
    });
  }

  @override
  void dispose() {
    idController.dispose();
    passwordController.dispose();
    passwordCheckController.dispose();
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Scaffold(
      appBar: AppTopAppBar.backOnly(
        onBackPressed: () {
          Navigator.of(context).maybePop();
        },
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.x16,
                  AppSpacing.x24,
                  AppSpacing.x16,
                  AppSpacing.x24,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '4월 28일 합주',
                      style: FontStyles.bold34.copyWith(
                        color: colors.onSurface,
                        letterSpacing: -0.68,
                      ),
                    ),

                    const SizedBox(height: AppSpacing.x20),

                    Row(
                      children: [
                        MyImageWidget(),

                        const SizedBox(width: AppSpacing.x8),

                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '송하은',
                              style: FontStyles.semi14.copyWith(
                                color: context.grays.black,
                              ),
                            ),
                            Row(
                              children: [
                                Text(
                                  '2026.07.22 15:47',
                                  style: FontStyles.reg12.copyWith(
                                    color: context.grays.gray4,
                                  ),
                                ),
                                Text(
                                  '｜최종수정일 2026.04.03 15:00',
                                  style: FontStyles.reg12.copyWith(
                                    color: context.grays.gray5,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),

                    const SizedBox(height: AppSpacing.x24),

                    Text(
                      '안녕하세요! 오늘 합주는 아래 두 곡 연습 예정입니다.\n\n파일에는 악보를 pdf로 첨부했으니 참고 부탁드려요 !\n합주는 약 3시간 진행 후 함께 점심식사 예정입니다.\n(메뉴는 아마도 닭갈비...)\n\n오늘은 악기 대여를 안 했으니, 본인이 지참해주세요~',
                      style: FontStyles.reg14.copyWith(
                        color: context.grays.black,
                      ),
                    ),
                  ],
                ),
              ),
              Divider(height: 1, thickness: 1, color: context.grays.gray7),

              const SizedBox(height: AppSpacing.x16),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.x16),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        print('좋아요 클릭: $_isLiked');
                        _toggleLike();
                      },
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SvgPicture.asset(
                            _isLiked
                                ? 'assets/icons/post/heart_off.svg'
                                : 'assets/icons/post/heart.svg',
                            width: 24,
                            height: 24,
                            colorFilter: ColorFilter.mode(
                              _isLiked ? context.grays.gray4 : colors.primary,
                              BlendMode.srcIn,
                            ),
                          ),
                          const SizedBox(width: AppSpacing.x4),
                          Text(
                            '좋아요 ${likedNum}',
                            style: FontStyles.reg14.copyWith(
                              color: context.grays.gray4,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: AppSpacing.x10),
                    GestureDetector(
                      onTap: () {
                        print('싫어요 클릭: $_isDisliked');
                        _toggleDislike();
                      },
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            width: 19,
                            height: 19,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: _isDisliked
                                  ? colors.primary
                                  : context.grays.white,
                              border: Border.all(
                                color: _isDisliked
                                    ? colors.primary
                                    : context.grays.gray4,
                                width: 0.9,
                              ),
                            ),
                            child: Center(
                              child: SvgPicture.asset(
                                'assets/icons/post/sad_face.svg',
                                colorFilter: ColorFilter.mode(
                                  _isDisliked
                                      ? context.grays.white
                                      : context.grays.gray4,
                                  BlendMode.srcIn,
                                ),
                                alignment: Alignment.center,
                              ),
                            ),
                          ),
                          const SizedBox(width: AppSpacing.x4),
                          Text(
                            '싫어요 ${dislikedNum}',
                            style: FontStyles.reg14.copyWith(
                              color: context.grays.gray4,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: AppSpacing.x10),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SvgPicture.asset(
                          'assets/icons/post/chat_off.svg',
                          colorFilter: ColorFilter.mode(
                            context.grays.gray4,
                            BlendMode.srcIn,
                          ),
                          alignment: Alignment.center,
                        ),
                        const SizedBox(width: AppSpacing.x4),
                        Text(
                          '댓글 ${dislikedNum}',
                          style: FontStyles.reg14.copyWith(
                            color: context.grays.gray4,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.x16),
              Center(
                child: Expanded(child: Center(child: _nullCommentWidget())),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MyImageWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final String imageUrl = 'https://picsum.photos';

    return Container(
      width: 40,
      height: 40,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppRadius.pill),
        child: Image.network(
          imageUrl,
          fit: BoxFit.cover,
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;
            return Center(child: CircularProgressIndicator());
          },
          errorBuilder: (context, error, stackTrace) {
            return Container(
              color: Colors.grey[300],
              child: Icon(Icons.error, color: Colors.red),
            );
          },
        ),
      ),
    );
  }
}

class _nullCommentWidget extends StatelessWidget {
  const _nullCommentWidget();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.x14),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '아직 단 댓글이 없어요.',
            style: FontStyles.med14.copyWith(color: context.grays.gray4),
          ),
          const SizedBox(height: AppSpacing.x4),
          Text(
            '가장 먼저 댓글을 남겨보세요.',
            style: FontStyles.med14.copyWith(color: context.grays.gray4),
          ),
        ],
      ),
    );
  }
}
