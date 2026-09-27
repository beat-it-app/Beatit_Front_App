import 'package:dio/dio.dart';

import 'package:beatit_front_app/src/domain/post/model/post_main_models.dart';
import 'package:beatit_front_app/src/domain/post/model/post_detail_models.dart';
import 'package:beatit_front_app/src/domain/meetit/model/meetit_create_request.dart';
import 'package:beatit_front_app/src/domain/meetit/model/meetit_detail_response.dart';

class PostApi {
  PostApi(this._dio);

  final Dio _dio;

  static const String _noticePath = '/posts/notices';

  // 현재 제공된 백엔드 PollController의 실제 RequestMapping 기준입니다.
  // 문서의 /posts/polls와 다르므로 서버 라우트가 변경되면 이 상수만 맞추면 됩니다.
  static const String _pollPath = '/posts/poll';
  static const String _meetitPath = '/posts/meetit';

  Future<NoticeListResponse> getNotices({
    String? keyword,
    String sort = 'LATEST',
    int page = 0,
    int size = 10,
  }) async {
    try {
      final response = await _dio.get<Map<String, dynamic>>(
        _noticePath,
        queryParameters: {
          if (_hasKeyword(keyword)) 'keyword': keyword!.trim(),
          'sort': sort,
          'page': page,
          'size': size,
        },
      );

      final body = _requireSuccessBody(
        response: response,
        fallbackMessage: '공지 목록을 불러오지 못했습니다.',
      );

      return NoticeListResponse.fromJson(body);
    } on DioException catch (error) {
      throw _mapDioException(error);
    }
  }

  Future<PollListResponse> getPolls({
    String? keyword,
    int page = 0,
    int size = 10,
  }) async {
    try {
      final response = await _dio.get<Map<String, dynamic>>(
        _pollPath,
        queryParameters: {
          if (_hasKeyword(keyword)) 'keyword': keyword!.trim(),
          'page': page,
          'size': size,
        },
      );

      final body = _requireSuccessBody(
        response: response,
        fallbackMessage: '투표 목록을 불러오지 못했습니다.',
      );

      return PollListResponse.fromJson(body);
    } on DioException catch (error) {
      throw _mapDioException(error);
    }
  }

  Future<MeetitListResponse> getMeetits({
    int page = 0,
    int size = 10,
  }) async {
    try {
      final response = await _dio.get<Map<String, dynamic>>(
        _meetitPath,
        queryParameters: {
          'page': page,
          'size': size,
        },
      );

      final body = _requireSuccessBody(
        response: response,
        fallbackMessage: '밋잇 목록을 불러오지 못했습니다.',
      );

      return MeetitListResponse.fromJson(body);
    } on DioException catch (error) {
      throw _mapDioException(error);
    }
  }

  Future<NoticeDetailData> getNotice(int id) async {
    final response = await _dio.get<Map<String, dynamic>>('$_noticePath/$id');
    return NoticeDetailResponse.fromJson(_requireSuccessBody(
      response: response, fallbackMessage: '공지를 불러오지 못했습니다.',
    )).data;
  }

  Future<PollDetailData> getPoll(int id) async {
    final response = await _dio.get<Map<String, dynamic>>('$_pollPath/$id');
    return PollDetailResponse.fromJson(_requireSuccessBody(
      response: response, fallbackMessage: '투표를 불러오지 못했습니다.',
    )).data;
  }

  Future<MeetitDetailData> getMeetit(int id) async {
    final response = await _dio.get<Map<String, dynamic>>(
      '$_meetitPath/$id', queryParameters: {'filter': 'ALL'},
    );
    return MeetitDetailResponse.fromJson(_requireSuccessBody(
      response: response, fallbackMessage: '밋잇을 불러오지 못했습니다.',
    )).data;
  }

  Future<void> createNotice({
    required String title,
    required String content,
    List<String> imagePaths = const [],
  }) async {
    final formData = FormData.fromMap({'title': title, 'content': content});
    for (final path in imagePaths) {
      formData.files.add(MapEntry('images', await MultipartFile.fromFile(path)));
    }
    final response = await _dio.post<Map<String, dynamic>>(
      _noticePath,
      data: formData,
    );
    _requireSuccessBody(response: response, fallbackMessage: '공지 작성에 실패했습니다.');
  }

  Future<void> createPoll(PollCreateRequest request) async {
    final response = await _dio.post<Map<String, dynamic>>(
      _pollPath, data: {
        ...request.toJson(),
        'closeAt': request.closeAt?.toUtc().toIso8601String(),
      },
    );
    _requireSuccessBody(response: response, fallbackMessage: '투표 생성에 실패했습니다.');
  }

  Future<void> createMeetit(MeetitCreateRequest request) async {
    final response = await _dio.post<Map<String, dynamic>>(
      _meetitPath, data: request.toJson(),
    );
    _requireSuccessBody(response: response, fallbackMessage: '밋잇 생성에 실패했습니다.');
  }

  Future<void> submitMeetitResponse(int id, Iterable<DateTime> selected) async {
    final response = await _dio.post<Map<String, dynamic>>(
      '$_meetitPath/$id/responses',
      data: {'slotStartTimes': selected.map((time) {
        final local = time.toLocal();
        return '${local.year.toString().padLeft(4, '0')}-${local.month.toString().padLeft(2, '0')}-${local.day.toString().padLeft(2, '0')}T${local.hour.toString().padLeft(2, '0')}:${local.minute.toString().padLeft(2, '0')}:00';
      }).toList()},
    );
    _requireSuccessBody(response: response, fallbackMessage: '밋잇 응답에 실패했습니다.');
  }

  Future<void> votePoll(int id, List<int> optionIds) async {
    final response = await _dio.post<Map<String, dynamic>>(
      '$_pollPath/$id/votes', data: {'optionIds': optionIds},
    );
    _requireSuccessBody(response: response, fallbackMessage: '투표에 실패했습니다.');
  }

  Future<void> commentNotice(int id, String content) async {
    final response = await _dio.post<Map<String, dynamic>>(
      '$_noticePath/$id/comments', data: {'content': content},
    );
    _requireSuccessBody(response: response, fallbackMessage: '댓글 작성에 실패했습니다.');
  }

  Future<void> commentPoll(int id, String content) async {
    final response = await _dio.post<Map<String, dynamic>>(
      '$_pollPath/$id/comments', data: {'content': content},
    );
    _requireSuccessBody(response: response, fallbackMessage: '댓글 작성에 실패했습니다.');
  }

  Future<void> toggleNoticeLike(int id) async {
    final response = await _dio.post<Map<String, dynamic>>('$_noticePath/$id/like');
    _requireSuccessBody(response: response, fallbackMessage: '좋아요 변경에 실패했습니다.');
  }

  Future<void> toggleNoticeDislike(int id) async {
    final response = await _dio.post<Map<String, dynamic>>('$_noticePath/$id/dislike');
    _requireSuccessBody(response: response, fallbackMessage: '싫어요 변경에 실패했습니다.');
  }

  Future<void> deleteNotice(int id) async {
    final response = await _dio.delete<Map<String, dynamic>>('$_noticePath/$id');
    _requireSuccessBody(response: response, fallbackMessage: '공지 삭제에 실패했습니다.');
  }

  Future<void> deletePoll(int id) async {
    final response = await _dio.delete<Map<String, dynamic>>('$_pollPath/$id');
    _requireSuccessBody(response: response, fallbackMessage: '투표 삭제에 실패했습니다.');
  }

  bool _hasKeyword(String? keyword) => keyword?.trim().isNotEmpty == true;

  Map<String, dynamic> _requireSuccessBody({
    required Response<Map<String, dynamic>> response,
    required String fallbackMessage,
  }) {
    final body = response.data;

    if (body == null) {
      throw const PostApiException(message: '서버 응답이 비어 있습니다.');
    }

    if (body['success'] != true) {
      throw PostApiException(
        message: body['message']?.toString() ?? fallbackMessage,
        code: body['status']?.toString(),
        statusCode: response.statusCode,
      );
    }

    return body;
  }

  PostApiException _mapDioException(DioException error) {
    final rawData = error.response?.data;

    if (rawData is Map) {
      final data = Map<String, dynamic>.from(rawData);
      return PostApiException(
        message: data['message']?.toString() ?? '요청에 실패했습니다.',
        code: data['status']?.toString(),
        statusCode: error.response?.statusCode,
      );
    }

    return PostApiException(
      message: '서버와 통신할 수 없습니다.',
      statusCode: error.response?.statusCode,
    );
  }
}

class PostApiException implements Exception {
  const PostApiException({
    required this.message,
    this.code,
    this.statusCode,
  });

  final String message;
  final String? code;
  final int? statusCode;

  @override
  String toString() => message;
}
