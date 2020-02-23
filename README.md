# MemoProject

<br>

## 개요
- 제목과 내용, 이미지를 메모로 추가할 수 있는 프로젝트 진행
- 코드+xib / 스토리보드+xib 사용 메모앱 개발 프로젝트
- 코드+xib 프로젝트 내에서는 LineMemoUITests에서 메모 추가/편집/삭제 간 로직 테스트코드 추가 작성
- 내부 프레임워크로만 프로젝트 진행
- 애플 기본 MVC 디자인패턴 활용 프로젝트 진행

<br>

## 프로젝트 구조 및 사용목적
### AppDelegate 
- UserDataManager로부터 기존의 저장된 메모데이터 로드
- MainNavigationController, MainMemoViewController 인스턴스 생성 및 UIWindow의 rootViewController 설정

### Extension
- UIImage+ : imageAsset 관리
- UITextField+ : view/edit모드 별 텍스트필드 설정
- UITextView+ : view/edit모드 별 텍스트뷰 설정
- UIViewController+ : 커스텀 AlertController, 앨범/카메라 오픈, 이벤트 메서드 정의
- UIView+ : 뷰 layer 속성 정의
- UIBarItem+ : XCT 식별자설정
- UIActivityIndicator : 네트워킹 동작 유무에 따른 이벤트 정의
- UIButton+ : 기본 버튼 설정
- UINavigationController+ : 알람 필요 시 띄울 ToastMessage 이벤트 정의
- UIFont+ : main/title/sub 폰트 정의

### Protocol
- RequestImageDelegate : URL 이미지요청 간 Delegate
- SendDataDelegate : ViewController간 데이터 전송 Delegate
- ViewControlerSetting
- ViewSetting

### Model
- UserDataManager : 메모데이터 관리자 싱글턴클래스, UserDefaults 활용 메모데이터 저장/삭제/편집 관리
- RequestImage : URL Image 처리 싱글턴클래스
- ToastView : 이벤트 발생 간 ToastMessage에 사용될 ToastView UI, Event 정의
▼ UserData 
  - MemoData : UI에 사용되는 메모데이터
  - MemoRawData : UserDefaults 저장 용 메모데이터
  - MemoMode : 메모보기 방식 (view/edit) 정의
▼ Constant
