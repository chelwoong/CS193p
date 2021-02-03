
## Contents
- [MVCs 연결](#mvcs-연결)
    - [prepare(for segue:)](#prepare(for-segue:))
    - [shouldPerformSegue](#shouldperformsegue)
- [SplitViewController & NavigationController](#splitviewcontroller-&-navigationcontroller)
- [awakeFromNib](#awakefromnib)
- [Timer](#timer)
- [Animation](#animation)


---

`다른 MVC를 뷰로 갖는 ViewController`

- UITabBarController
    - 각각의 탭이 MVC가 됨
- UISplitViewController
    - Master - Detail
    - 세로로 돌리면 Detail만 표시됨
- UINavigationController
    - MVC Stack

## MVCs 연결

`segue 를 사용` 

### prepare(for segue:)

- segue는 항상 **새로운 MVC instance를 만든다**. 재사용하지 않는다!! 주의!!
- MVC를 `preparing` 할 때 사용한다
- segue에서는 아직 다음 MVC **outlets는 nil** 이다!

### shouldPerformSegue

`shouldPerform(withIdentifier identifier: String?, sender: Any?) → Bool`

- segue 되는 걸 막을 수 있다.

### SplitViewController & NavigationController

SplitViewController는 iPad에서만 동작한다. iOS와 iPad에서 모두 동작하게 하려면 SplitViewController의 **Master**를 **NavigationController**로 감싸주면된다.

## awakeFromNib

인터페이스 빌드 파일에서 나온 모든 객체에 대해 호출되는 함수

## Timer

### Stopping a repeating timer

`timer.invalidate()` 호출. 만약 타이머가 wear var로 선언되어 있다면 nil이 할당된다.

### Tolerance

오차 범위 설정. 배터리 효율을 위해 설정한다.

0으로 설정해도 마이크로 단위까지 정확하게 동작하지는 않는다.

Q. 앱이 백그라운드에 있을 때도 사용할 수 있나요?

동작하지 않는다. 하지만 앱이 백그라운드로 바뀌기 전 30초 가량은 짧은 시간 실행될 수도 있다.

# Animation

- Animating UIView Properties
    - frame이나 transparency 같은 것들이 바뀔 때
    - frame/center
    - bounds
    - transform(translation, rotation, scale)
    - alpha(opacity)
    - backgroundColor
- Animating Controllers transitiion (as in a UINavigationController)
- Core Animation
- Open GL and Metal
    - 3D
- SpriteKit
    - 2.5D, 슈퍼마리오 같은 애니메이션 이미지를 갖고 있고 3D 처럼 이미지를 겹치지만 실제 드로잉은 2D
- Dynamic Animation
    - "Physics"-based animation. 뷰의 질량과 속도, 탄성 등
