import 'package:dio/dio.dart';
import 'package:beatit_front_app/src/domain/post/model/poll_voter.dart';

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
    return (await getPollWithMetadata(id)).data;
  }

  Future<PollDetailLoadResult> getPollWithMetadata(int id) async {
    try {
      final response = await _dio.get<Map<String, dynamic>>('$_pollPath/$id');
      final body = _requireSuccessBody(
        response: response,
        fallbackMessage: '투표를 불러오지 못했습니다.',
      );
      final dataJson = body['data'];
      final remindBeforeClose = dataJson is Map
          ? dataJson['remindBeforeClose']?.toString() == 'REMIND'
          : false;

      return PollDetailLoadResult(
        data: PollDetailResponse.fromJson(body).data,
        remindBeforeClose: remindBeforeClose,
      );
    } on DioException catch (error) {
      throw _mapDioException(error);
    }
  }

  Future<List<PollVoter>> getPollOptionVoters(int pollId, int optionId) async {
    try {
      final response = await _dio.get<Map<String, dynamic>>(
        '$_pollPath/$pollId/options/$optionId/voters',
      );
      final body = _requireSuccessBody(
        response: response,
        fallbackMessage: '투표자 명단을 불러오지 못했습니다.',
      );
      final data = body['data'];
      if (data is! List) {
        throw const FormatException('투표자 명단 응답 형식이 올바르지 않습니다.');
      }
      return data.whereType<Map>().map((item) => PollVoter.fromJson(
        Map<String, dynamic>.from(item),
      )).toList(growable: false);
    } on DioException catch (error) {
      throw _mapDioException(error);
    }
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

  Future<void> editNotice({
    required int noticeId,
    required String title,
    required String content,
    bool imagesChanged = false,
    List<String> retainedImageUrls = const [],
    List<String> newImagePaths = const [],
  }) async {
    final formData = FormData.fromMap({
      'title': title,
      'content': content,
    });

    if (imagesChanged) {
      for (final url in retainedImageUrls) {
        final image = await _multipartFromRemoteImage(url);
        if (image != null) {
          formData.files.add(MapEntry('images', image));
        }
      }

      for (final path in newImagePaths) {
        formData.files.add(
          MapEntry('images', await MultipartFile.fromFile(path)),
        );
      }

      // 백엔드는 images == null이면 기존 이미지를 그대로 유지하고,
      // images가 전달되면 기존 이미지를 전부 교체한다. 모든 이미지를 삭제하는
      // 경우에도 images 파트 자체가 존재해야 하므로 0바이트 파일을 전달한다.
      if (retainedImageUrls.isEmpty && newImagePaths.isEmpty) {
        formData.files.add(
          MapEntry(
            'images',
            MultipartFile.fromBytes(const <int>[], filename: 'empty'),
          ),
        );
      }
    }

    try {
      final response = await _dio.post<Map<String, dynamic>>(
        '$_noticePath/$noticeId',
        data: formData,
      );
      _requireSuccessBody(
        response: response,
        fallbackMessage: '공지 수정에 실패했습니다.',
      );
    } on DioException catch (error) {
      throw _mapDioException(error);
    }
  }

  Future<MultipartFile?> _multipartFromRemoteImage(String url) async {
    try {
      final response = await _dio.get<List<int>>(
        url,
        options: Options(responseType: ResponseType.bytes),
      );
      final bytes = response.data;
      if (bytes == null || bytes.isEmpty) {
        return null;
      }

      final uri = Uri.tryParse(url);
      final filename = uri != null && uri.pathSegments.isNotEmpty
          ? uri.pathSegments.last
          : 'image.jpg';

      return MultipartFile.fromBytes(bytes, filename: filename);
    } on DioException catch (error) {
      throw _mapDioException(error);
    }
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

  Future<void> updatePoll(int id, PollCreateRequest request) async {
    try {
      final response = await _dio.patch<Map<String, dynamic>>(
        '$_pollPath/$id',
        data: {
          ...request.toJson(),
          'closeAt': request.closeAt?.toUtc().toIso8601String(),
        },
      );
      _requireSuccessBody(
        response: response,
        fallbackMessage: '투표 수정에 실패했습니다.',
      );
    } on DioException catch (error) {
      throw _mapDioException(error);
    }
  }

  Future<void> createMeetit(MeetitCreateRequest request) async {
    final payload = <String, dynamic>{
      'title': request.title,
      'candidateDates': request.candidateDates,
      'dateOnly': request.dateOnly,
      'participantUserIds': request.participantUserIds,
      'startTime': request.dateOnly ? null : request.startTime,
      'endTime': request.dateOnly ? null : request.endTime,
    };

    try {
      final response = await _dio.post<Map<String, dynamic>>(
        _meetitPath,
        data: payload,
      );
      _requireSuccessBody(
        response: response,
        fallbackMessage: '밋잇 생성에 실패했습니다.',
      );
    } on DioException catch (error) {
      throw _mapDioException(error);
    }
  }

  Future<void> submitMeetitResponse(
    int id,
    Iterable<DateTime> selected, {
    bool dateOnly = false,
  }) async {
    final normalized = selected
        .map((time) {
          if (dateOnly) {
            return DateTime(time.year, time.month, time.day);
          }
          return DateTime(
            time.year,
            time.month,
            time.day,
            time.hour,
            time.minute,
          );
        })
        .toSet()
        .toList()
      ..sort();

    try {
      final response = await _dio.post<Map<String, dynamic>>(
        '$_meetitPath/$id/responses',
        data: {
          'slotStartTimes': normalized.map((time) {
            return '${time.year.toString().padLeft(4, '0')}-${time.month.toString().padLeft(2, '0')}-${time.day.toString().padLeft(2, '0')}T${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}:00';
          }).toList(),
        },
      );
      _requireSuccessBody(
        response: response,
        fallbackMessage: '밋잇 응답에 실패했습니다.',
      );
    } on DioException catch (error) {
      throw _mapDioException(error);
    }
  }

  Future<void> deleteMeetit(int id) async {
    try {
      final response = await _dio.delete<Map<String, dynamic>>(
        '$_meetitPath/$id',
      );
      _requireSuccessBody(
        response: response,
        fallbackMessage: '밋잇 삭제에 실패했습니다.',
      );
    } on DioException catch (error) {
      throw _mapDioException(error);
    }
  }

  Future<void> votePoll(int id, List<int> optionIds) async {
    final response = await _dio.post<Map<String, dynamic>>(
      '$_pollPath/$id/votes', data: {'optionIds': optionIds},
    );
    _requireSuccessBody(response: response, fallbackMessage: '투표에 실패했습니다.');
  }

  Future<void> commentNotice(int id, String content, {
    int? parentCommentId,
    List<int> mentionedUserIds = const [],
  }) async {
    final response = await _dio.post<Map<String, dynamic>>(
      '$_noticePath/$id/comments', data: {
        'content': content,
        'parentCommentId': parentCommentId,
        'mentionedUserIds': mentionedUserIds,
      },
    );
    _requireSuccessBody(response: response, fallbackMessage: '댓글 작성에 실패했습니다.');
  }

  Future<void> commentPoll(int id, String content, {
    int? parentCommentId,
    List<int> mentionedUserIds = const [],
  }) async {
    final response = await _dio.post<Map<String, dynamic>>(
      '$_pollPath/$id/comments', data: {
        'content': content,
        'parentCommentId': parentCommentId,
        'mentionedUserIds': mentionedUserIds,
      },
    );
    _requireSuccessBody(response: response, fallbackMessage: '댓글 작성에 실패했습니다.');
  }

  Future<void> deleteNoticeComment(int noticeId, int commentId) async {
    final response = await _dio.delete<Map<String, dynamic>>(
      '$_noticePath/$noticeId/comments/$commentId',
    );
    _requireSuccessBody(response: response, fallbackMessage: '댓글 삭제에 실패했습니다.');
  }

  Future<void> deletePollComment(int pollId, int commentId) async {
    final response = await _dio.delete<Map<String, dynamic>>(
      '$_pollPath/$pollId/comments/$commentId',
    );
    _requireSuccessBody(response: response, fallbackMessage: '댓글 삭제에 실패했습니다.');
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

class PollDetailLoadResult {
  const PollDetailLoadResult({
    required this.data,
    required this.remindBeforeClose,
  });

  final PollDetailData data;
  final bool remindBeforeClose;
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
