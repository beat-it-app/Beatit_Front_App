# Beatit Frontend

Flutter 기반 Beatit 모바일 앱입니다.

이 문서는 처음 합류한 프론트 개발자가 **프로젝트 실행 방법, 기본 구조, theme 사용 방식**을 빠르게 확인할 수 있도록 작성되었습니다.

## 1) 의존성 설치

```bash
flutter pub get
```

FVM을 사용하는 경우 아래 명령어를 사용합니다.

```bash
fvm flutter pub get
```

## 2) 앱 실행

```bash
flutter run
```

FVM을 사용하는 경우 아래 명령어를 사용합니다.

```bash
fvm flutter run
```

## 3) 코드 생성

`freezed`, `json_serializable`, `riverpod_generator` 등을 사용하는 경우 코드 생성 명령어를 실행합니다.

```bash
dart run build_runner build --delete-conflicting-outputs
```

변경 사항을 감지하면서 생성하려면 아래 명령어를 사용합니다.

```bash
dart run build_runner watch --delete-conflicting-outputs
```

> `.g.dart`, `.freezed.dart` 파일은 직접 수정하지 않습니다.

## 4) 코드 품질 확인

작업 완료 후 아래 명령어를 실행합니다.

```bash
flutter format .
flutter analyze
flutter test
```

## 5) 앱 Theme 설정

Beatit은 Light/Dark mode를 모두 지원할 예정입니다.

Theme 관련 파일은 `lib/src/core/theme/` 아래에서 관리합니다.

```plaintext
lib/src/core/theme/
├── app_theme.dart       # ThemeData 설정, light/dark theme 관리
├── app_colors.dart      # Beatit color token
├── app_fonts.dart       # Pretendard text style
├── app_spacing.dart     # spacing token
└── app_radius.dart      # radius token
```

`MaterialApp`에는 아래처럼 theme을 연결합니다.

```dart
MaterialApp.router(
  theme: AppTheme.light,
  darkTheme: AppTheme.dark,
  themeMode: ThemeMode.system,
  routerConfig: appRouter,
)
```

Theme 사용 규칙은 다음과 같습니다.

* 색상은 `AppColor` 또는 `Theme.of(context).colorScheme`을 사용합니다.
* 폰트는 `FontStyles` 또는 `Theme.of(context).textTheme`을 사용합니다.
* 간격은 `AppSpacing`을 사용합니다.
* 둥근 정도는 `AppRadius`를 사용합니다.
* 화면 내부에서 `Color(0x...)`, `TextStyle(...)`, 임의 spacing 값을 반복해서 선언하지 않습니다.

## 6) 폴더 구조

Beatit은 기능별로 코드를 묶는 **가벼운 Feature-first 구조**를 사용합니다.

```plaintext
lib/
├── main.dart
│
└── src/
    ├── app/
    │   ├── app.dart             # MaterialApp, theme, router 연결
    │   └── router.dart          # go_router 설정
    │
    ├── core/
    │   ├── theme/               # 색상, 폰트, spacing, radius, app theme
    │   │   ├── app_theme.dart
    │   │   ├── app_colors.dart
    │   │   ├── app_fonts.dart
    │   │   ├── app_spacing.dart
    │   │   └── app_radius.dart
    │   │
    │   ├── network/             # Dio client, API 공통 설정
    │   │   ├── api_client.dart
    │   │   └── api_exception.dart
    │   │
    │   ├── widgets/             # 앱 전체에서 사용하는 공통 위젯
    │   │   ├── bit_button.dart
    │   │   ├── bit_text_field.dart
    │   │   ├── bit_loading_view.dart
    │   │   ├── bit_error_view.dart
    │   │   └── bit_empty_view.dart
    │   │
    │   ├── utils/               # validator, formatter 등 공통 유틸
    │   └── constants/           # 앱 전역 상수
    │
    └── features/
        ├── auth/
        │   ├── view/            # 로그인/회원가입 화면
        │   ├── widget/          # auth 기능에서만 쓰는 위젯
        │   ├── model/           # 요청/응답 모델
        │   ├── api/             # auth API 호출
        │   └── provider/        # auth 상태관리
        │
        ├── home/
        │   ├── view/
        │   ├── widget/
        │   ├── model/
        │   ├── api/
        │   └── provider/
        │
        ├── practice_room/
        │   ├── view/
        │   ├── widget/
        │   ├── model/
        │   ├── api/
        │   └── provider/
        │
        └── team/
            ├── view/
            ├── widget/
            ├── model/
            ├── api/
            └── provider/
```

## 7) Feature 폴더 역할

각 기능은 기본적으로 아래 구조를 사용합니다.

```plaintext
features/feature_name/
├── view/       # 화면 단위 Page
├── widget/     # 해당 기능에서만 사용하는 UI 조각
├── model/      # request, response, 화면 모델
├── api/        # 서버 통신 코드
└── provider/   # Riverpod 상태관리, 화면 이벤트 처리
```

예시:

```plaintext
features/auth/
├── view/
│   ├── login_page.dart
│   └── signup_page.dart
├── widget/
│   ├── login_form.dart
│   └── signup_form.dart
├── model/
│   ├── login_request.dart
│   ├── login_response.dart
│   └── user.dart
├── api/
│   └── auth_api.dart
└── provider/
    └── auth_provider.dart
```

## 8) 폴더 추가 기준

처음부터 폴더를 깊게 나누지 않습니다.

기능이 커졌을 때만 아래 폴더를 추가합니다.

```plaintext
repository/   # 여러 API를 조합하거나 API 결과 가공이 많을 때
service/      # 계산, 정책, 검증 로직이 복잡할 때
mapper/       # 서버 응답 모델과 앱 내부 모델을 분리해야 할 때
state/        # provider 상태 클래스가 길어질 때
```

예시:

```plaintext
features/practice_room/
├── view/
├── widget/
├── model/
├── api/
├── provider/
└── repository/   # 필요해졌을 때만 추가
```

## 9) 개발 규칙

* 화면 파일은 `view/`에 둡니다.
* 기능 내부에서만 사용하는 위젯은 해당 feature의 `widget/`에 둡니다.
* 여러 기능에서 반복해서 사용하는 위젯은 `core/widgets/`로 이동합니다.
* 서버 통신은 `api/`에서 처리합니다.
* 화면 상태와 이벤트 처리는 `provider/`에서 관리합니다.
* UI에서 Dio client를 직접 생성하지 않습니다.
* 색상, 폰트, spacing, radius는 theme token을 우선 사용합니다.

## 자주 사용하는 명령어

```bash
# 의존성 설치
flutter pub get

# 앱 실행
flutter run

# 코드 생성
dart run build_runner build --delete-conflicting-outputs

# 코드 생성 watch 모드
dart run build_runner watch --delete-conflicting-outputs

# 코드 정리
flutter format .

# 정적 분석
flutter analyze

# 테스트
flutter test
```
