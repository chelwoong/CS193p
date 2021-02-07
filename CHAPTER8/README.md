
<img src="https://user-images.githubusercontent.com/23303023/107137868-dd3e9400-6953-11eb-9742-807ac7d59a75.gif" width="25%" />

- [UIView Animation](#uiview-animation)
- [UIViewPropertyAnimator](#uiviewpropertyanimator)
- [뷰 전체 애니메이션](#뷰-전체-애니메이션)
- [Dynamic Animation](#dynamic-animation)
- [Memory Cycle Avoidance](#memory-cycle-avoidance)
- [Closure Capturing](#closure-capturing)

## UIView Animation

`뷰의 일부 속성 애니메이션`

### animate 가능한 UIView 속성

- frame
- bounds
- transform
- alpha
- backgroundColor

### UIViewPropertyAnimator

- animation 컨트롤 가능
- 매우 강력함

    ```swift
    class func runningPropertyAnimator(
        withDuration: TimeInterval,
                     delay: TimeInterval,
                 options: UIViewAnimationOptions,
            animations: () -> Void,
            completion: ((position: UIViewAnimatingPosition) -> Void)? = nil
    )
    ```

- 애니메이션이 중간에 중단되면 completion에서 `position == .current` 이 된다.
- 여러 애니메이터를 동시에 실행할 수 있는데,
    - 동일한 속성을 가진 다른 애니메이션이 실행되면 늦게 실행한 애니메이션이 우선권을 갖는다.
    - 실행 중이던 애니메이터는 중간에 중단됨.
- delay를 준다고 해서 **클로저 자체가 늦게 실행되는 것은 아니다.** 즉시 실행되고 즉시 적용됨
단, 사용자에게 보여지는 것만 늦게 보여진다.
- 아래의 예에서 뷰가 사라지는 건 5초 후지만 실행 즉시 alpha는 0으로 바뀐다.

```swift
if myView.alpha == 0 {
    UIViewPropertyAnimator.runningPropertyAnimator(
        withDuration: 3.0,
                     delay: 2.0,
                 options: [.allowUserInteraction], // 애니메이션 도중에 사용자의 제스처를 받겠다.
            animations: { myView.alpha = 0.9 },
            completion: { if $0 == .end { myView.removeFromSuperview() } }
    )
}
```

### Animation Options

![https://s3-us-west-2.amazonaws.com/secure.notion-static.com/b2d8d03c-f9df-4e14-9804-8f48c788bf03/Untitled.png](https://s3-us-west-2.amazonaws.com/secure.notion-static.com/b2d8d03c-f9df-4e14-9804-8f48c788bf03/Untitled.png)

- beginFromCurrentState: 진행 중인 값을 가져와서 사용함

## 뷰 전체 애니메이션

`카드 뒤집기`

![https://s3-us-west-2.amazonaws.com/secure.notion-static.com/611c5d5e-3105-4c61-aeba-e59f9db03687/Untitled.png](https://s3-us-west-2.amazonaws.com/secure.notion-static.com/611c5d5e-3105-4c61-aeba-e59f9db03687/Untitled.png)

```swift
UIView.transition(with: myPlayingCardView,
                            duration: 0.75,
                             options: [.transitionFlipFromLeft],
                        animations: { cardIsFaceUp = !cardIsFaceUp }
                        completion: nil)
```

## Dynamic Animation

밀도, 마찰, 중력과 같은 물리적 속성을 적용

### 사용법

1. UIDynamicAnimator 만들기
    - 진행 중인 모든 애니메이션이 참고할 좌표계가 될 뷰
    - referenceView가 애니메이션 될 뷰들의 최종적인 슈퍼뷰가 되어야함.

```swift
var animator = UIDynamicAnimator(referenceView: UIView)
```

2. UIDynamicBehavior 인스턴스 생성 및 추가

```swift
let gravity = UIGravityBehavior()
animator.addBehavior(gravity)
let collider = UICollisionBehavior()
animator.addBehavior(collider)
```

3. Behavior에 아이템 추가

```swift
let item1: UIDynamicItem = ... // 보통 UIView
let item2: UIDynamicItem = ... // 보통 UIView
gravity.addItem(item1)
collider.addItem(item2)
gravity.addItem(item2)
```

### UIDynamicItem protocol

```swift
protocol UIDynamicItem : NSObjectProtocol {
    var bounds: CGRect { get } // size 필수
    var center: CGPoint { get set } // 그리고 위치 설정
    var transform: CGAffineTransform { get set } // 회전 가능
    var collisionBoundsType: UIDynamicItemCollisionBoundsType { get }
    var collisionBoundingPath: UIBezierPath { get }
}
```

animator가 동작하는 동안에 Item의 속성을 바꿨다면 animator에게 변경했다고 알려줘야한다.

```swift
func updateItem(usingCurrentState item: UIDynamicItem)
```

### Behaviors

- UIGravityBehavior
- UIAttachmentBehavior
- UICollisionBehavior
    - 객체나 view가 서로 튕기거나 UIBezierPath로 튕기는 것 (기본적으로 백그라운드에서 동작)
- UISnapBehavior
    - 던져지는 느낌을 자연스럽게 할 때 사용. 이동해 부딫히고 부르르 떨면서 멈추는 것 같은 느낌
- UIPushBehavior
    - 대상을 미는 애니메이션. 미는 동작의 각도, 크기 등을 설정할 수 있다.
- UIDynamicItemBehavior
- UIDynamicBehavior

### Stasis

`애니메이션의 정지 캐치` 

- UIDynamicAnimatorDelegate
    - func dynamicAnimatorDidPause
    - func dynamicAnimatorWillResume

### Memory Cycle Avoidance

아래 코드는 메모리릭을 일으킴

- pushBehavior가 closure를 가르키고 있고
- 다시 클로저가 pushBehavior를 가르키고 있음

```swift
if let pushBehavior = UIPushBehavior(items: [...], mode: .instantaneous) {
    pushBehavior.magnitude = ...
    pushBehavior.angle = ...
    // 순환참조!!!
    pushBehavior.action = {
        pushBehavior.dynamicAnimator!.removeBehavior(pushBehavior)
    }
    animator.addBehavior(pushBehavior) // will push right away
}
```

- unowned 참조로 해결가능. weak를 사용해도 되지만, 
이 경우엔 pushBehavior가 힙에 없으면 action 자체가 실행되지 않으므로, 반드시 pushBehavior가 있다고 보장할 수 있으니 unowned를 사용해서 불필요한 옵셔널 체이닝을 줄일 수 있다.

```swift
if let pushBehavior = UIPushBehavior(items: [...], mode: .instantaneous) {
    pushBehavior.magnitude = ...
    pushBehavior.angle = ...
    // unowned 참조
    pushBehavior.action = { [unowned pushBehavior] in
        pushBehavior.dynamicAnimator!.removeBehavior(pushBehavior)
    }
    animator.addBehavior(pushBehavior) // will push right away
}
```

### Closure Capturing

- 클로져 안에 **지역 변수**를 정의할 수 있습니다. `[ ]` 안에 정의합니다.

```swift
var foo = { [x = someInstanceOfClass, y = "hello"] in
    // use x and y here
}
```

- 지역변수를 `weak`나 `unowned`로 선언할 수 있다.
- 얘네들은 힙에 저장되지 않는다.

```swift
var foo = { [[weak x = someInstanceOfClass, y = "hello"] in
    // use x and y here
}

var foo = { [unowned x = someInstanceOfClass, y = "hello"] in
    // use x and y here
}
```

- 순환참조 예

```swift
class Zerg {
    private var foo = { 
        self.bar()
    }
    private func bar() { ... }
}
```

- weak 로 참조해 해결할 수 있다.
- `[weak self]`의 변천사.
    - `[weak weakSelf = self]` 처음엔  와 같은 식으로 weakSelf 지역변수를 정의한다.
    - `[weak self = self]` 바깥의 self와 같은 이름으로 self로 정의할 수 있다.
    - `[weak self]` 너무 흔한 케이스여서 = self 조차 생략이 가능하다.

```swift
class Zerg {
    private var foo = { [weak self] in
        weakSelf?.bar()
    }
    private func bar() { ... }
}
```
