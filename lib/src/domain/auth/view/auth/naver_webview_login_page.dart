import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class NaverWebviewLoginPage extends StatefulWidget {
  final String clientId;
  final String redirectUri;

  const NaverWebviewLoginPage({
    super.key,
    required this.clientId,
    required this.redirectUri,
  });

  @override
  State<NaverWebviewLoginPage> createState() => _NaverWebviewLoginPageState();
}

class _NaverWebviewLoginPageState extends State<NaverWebviewLoginPage> {
  late final WebViewController _controller;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    final state = DateTime.now().millisecondsSinceEpoch.toString();
    final authUrl = Uri.parse(
      'https://nid.naver.com/oauth2.0/authorize'
      '?response_type=code'
      '&client_id=${widget.clientId}'
      '&redirect_uri=${Uri.encodeComponent(widget.redirectUri)}'
      '&state=$state',
    );

    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (url) {
            if (mounted) setState(() => _isLoading = true);
          },
          onPageFinished: (url) {
            if (mounted) setState(() => _isLoading = false);
          },
          onNavigationRequest: (NavigationRequest request) {
            // 💡 네이버가 서비스 콜백 URL로 리다이렉트할 때 code 가로채기
            if (request.url.startsWith(widget.redirectUri)) {
              final uri = Uri.parse(request.url);
              final code = uri.queryParameters['code'];
              final error = uri.queryParameters['error'];

              if (!mounted) return NavigationDecision.prevent;

              if (code != null) {
                Navigator.of(context).pop(code); // 인가 코드 전달
                return NavigationDecision.prevent;
              } else if (error != null) {
                Navigator.of(context).pop(null); // 에러 발생 또는 사용자 취소
                return NavigationDecision.prevent;
              }
            }
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(authUrl);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('네이버 로그인'),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.of(context).pop(null),
        ),
      ),
      body: Stack(
        children: [
          WebViewWidget(controller: _controller),
          if (_isLoading) const Center(child: CircularProgressIndicator()),
        ],
      ),
    );
  }
}
