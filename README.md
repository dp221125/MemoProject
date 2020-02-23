
<br>
<br>

# 메모앱 프로젝트 MemoProject

<br>
<br>

## 목차 링크
### [프로젝트 개요](https://github.com/applebuddy/MemoProject/blob/master/README.md#개요)
### [앱 구동예시](https://github.com/applebuddy/MemoProject/blob/master/README.md#앱-구동화면)
### [프로젝트 구조](https://github.com/applebuddy/MemoProject/blob/master/README.md#프로젝트-구조--사용목적)

<br>
<br>

## 개요
- 제목과 내용, 이미지를 작성/추가할 수 있는 메모앱 프로젝트
- 코드+xib / 스토리보드+xib 사용 메모앱 개발 프로젝트
- 코드+xib 프로젝트 내에서는 LineMemoUITests에서 메모 추가/편집/삭제 간 로직 테스트코드 추가 작성
- 내부 프레임워크로만 프로젝트 진행
- 애플 기본 MVC 디자인패턴 활용 프로젝트 진행

<br>
<br>

## 앱 구동화면
<div> 
  <img width=250 src="https://user-images.githubusercontent.com/4410021/75112185-b0329c00-5684-11ea-9bec-f16902a39d58.gif">     &nbsp
  <img width=250 src="https://user-images.githubusercontent.com/4410021/75112189-b759aa00-5684-11ea-8698-6e5b2fb4c1c3.gif">
  &nbsp
  <img width=250 src="https://user-images.githubusercontent.com/4410021/75112190-b7f24080-5684-11ea-8b1b-d4bd0e671768.gif"></div>

<br>
<br>

## 프로젝트 구조 & 사용목적
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
- **RequestImageDelegate** : URL 이미지요청 간 Delegate
- **SendDataDelegate** : ViewController간 데이터 전송 Delegate
- ViewControlerSetting
- ViewSetting

### Model
- **UserDataManager** : 메모데이터 관리자 싱글턴클래스, UserDefaults 활용 메모데이터 저장/삭제/편집 관리
- **RequestImage** : URL Image 처리 싱글턴클래스
- **UserData** 
  - MemoData : UI에 사용되는 메모데이터
  - MemoRawData : UserDefaults 저장 용 메모데이터
  - MemoMode : 메모보기 방식 (view/edit) 정의
- ToastView : 이벤트 발생 간 ToastMessage에 사용 될 ToastView UI, Event 정의
- imageEditingMode : 이미지 편집모드 정의
- **Constant**
  - Error
    - UserDataError : 유저 데이터 처리 간 에러 정의
    - RequestImageError : URL Image 요청 간 에러 정의
  - UIIdentifier : UI 식별자 정의
  - XCTIdentifier : XCT 식별자 정의
  - UpdateMode : UI 업데이트 방식 (single/whole) 정의
  - ViewSize : UI 높이/너비/두께 등 정의
  - TitleData : ViewController 타이틀 정의
  
### View
- **MainMemoView** : 메인화면 View, 메모리스트 화면 UI, MainMemoViewController mainView로 사용
- **EditMemoView** : 메모편집 화면 UI, DetailMemoViewController/AddMemoViewController mainView로 사용
- **AddImageURLView** : URL 이미지 추가화면 UI, AddMemoViewController mainView로 사용
- **MainMemoTableViewCell** : xib활용 UI 정의, 메인화면 메모리스트 셀
- **MemoImageCollectionViewCell** : xib활용 UI 정의, 메모 이미지리스트 셀
- FlowLayout
  - MemoImageCollectionViewFlowLayout

### Controller
- **MainNavigationController** : 메인화면을 rootViewController로 하는 메모앱 메인 NavigationController
- **MainMemoViewController** : 메민 메모리스트 화면
- **DetailMemoViewController** : 저장된 메모 정보 확인 및 편집/저장이 가능한 화면
- **AddMemoViewController** : 새로운 메모 추가 화면
- **AddImageURLViewController** : URL Image 추가 화면

<br>

### UITests

- **LineMemoUITests : 메모 UI Test 메서드 정의**
  -  **TestAddingMemoData**
    - 메모 추가 테스트
    - 이미지 추가방식 설정 후 진행 (ImageEditingMode)
      - AddMemoViewController 진입 후 이미지, 메모데이터 입력 및 추가
      - 추가한 메모데이터가 정상적으로 저장되었는지 확인 후 테스트 종료
  - **testEditingMemoData**
    - 메모 편집 테스트
    - 이미지 삭제횟수(deleteImageCount), 추가방식(ImageEditingMode) 설정 후 진행
      - DetailMemoViewController 진입 후 이미지, 메모데이터 편집 후 저장
      - 메모데이터 편집 후 테스트 종료
  - **testDeletingMemoData**
    - 메모 삭제 테스트
    - 존재하는 메모데이터 정보 순차 확인 후 삭제 진행

<br>
<br>
