# CHAPTER4

- Quick demo of mutationg
- protocols
- String
- NSAttributedString
- Closures (and functions as type in general)



value type에서는 copy on write (쓰기 시 복사) 가 일어나기 때문에 언제 바뀌는 작업을 하는지 알아야 미리 사본을 만들어 둘 수 있습니다. 



value type은 힙 메모리에 저장되지 않고 사용할 때마다 매번 복사해야 하기 때문에 매우 비효율적이다. 하지만 **Swift에서는 내용이 변경되었을 때만 복사합니다. 이것을 `copy on write 쓰기 시 복사`** 라고 합니다. 이게 바로 구조체의 다른 점인데, class는 이게 없다. 여러 곳으로 전달될 때 포인터를 주고받는다.



## Protocol

protocl 은 swift 자료구조의 핵심을 중 하나이다.  

protocol 자체는 간단하다. 그저 별도의 구현이 없는 변수와 메소드의 리스트이다.  

하지만 그 용도가 매우 중요하다.



Protocol은 왜 존재할까?

Protocol은 무엇일까?

protocol은 API에서 원하는 것을 불러오는 방식입니다. 어떤 struct, class, enum 상관없이 어떤 것이든 전달할 수 있다. 

프로토콜은 API를 매우 유연하고 더 잘 이해할 수 있도록 만들어줍니다. Blind 커뮤니케이션 구조에 매우 효과적입니다. MVC에서 View와 Controller 간의 커뮤니케이션에서 will, did, should, data at, count 등이 모두 `blind` 상태여야 합니다. 왜냐하면 View는 매우 일반적인 반면 Controller는 구체적입니다. 프로토콜이 이것을 가능하게 해주고 권한을 주는데 유용합니다. 

예를 들어, Dictionary에서 딕셔너리는 해시 테이블입니다. 



**swift에서 protocol은 모든 메소드가 필수적으록 구현되어야 한다.**  
하지만 objective-c에서는 그렇지 않다. objective-c에서는 프로토콜의 메소드 구현이 선택적이다.  
swift에서 앞에 `@objc`를 붙여주면 objective-c 프로토콜처럼 사용할 수가 있다. @objc 는 objective-c를 이용해서 디자인 되었을 때만 사용한다. view와 controller의 블라인드 관계에서 delegate가 objective-c의 프로토콜을 사용한다. 



### protocol 선언

protocol은 protocol을 상속받을 수 있는데 상속받은 protocol의 메소드를 모두 구현해야 한다는 의미이다.

순수 선언이기 때문에 구현 코드는 없고 변수는 get set 속성을 정해주어야 한다.

이 프로토콜이 구조체에서 정의되었는데, 수정되어야 한다면 `mutating` 을 붙여줘야 한다.

만약 확실히 구조체에서 정의되지 않는 protocol이라면  `: class` 를 붙여서 명시해줘야 한다.

```swift
protocol SomeProtocol: InheritedProtocol1, InheritiedProtocol2 {
  var someProperty: Int { get set }
  func aMethod(arg1: Double, anotherAgrument: String) -> SomeType
  mutating func changeIt() // 구조체에서 정의되고 변경 가능성이 있을 때
  init(arg: Type)
}

// struct에서는 정의될 수 없는 녀석이라고 명시해줌.
protocol SomeProtocol: class, InheritedProtocol1, InheritiedProtocol2 {
  var someProperty: Int { get set }
  func aMethod(arg1: Double, anotherAgrument: String) -> SomeType
  func changeIt() // : class 를 사용해 구조체에서 정의되지 않는다고 명시해줬기 때문에 mutating 제거
  init(arg: Type)
}

```



### protocol 사용

```swift
struct SomeStruct: SomeProtocol, AnotherProtocol {
  // SomeProtocol 구현
  // SomeProtocol, AnotherProtocol의 내용을 모두 구현해야 한다.
}
```

정의에서 `:` 뒤에 원하는 protocol을 붙여줌으로써 사용할 수 있는데, 당연히 protocol의 내용을 모두 구현해줘야 하고, Protocol을 몇 개든 상관없다. 이게 protocol이 다중 상속을 지원한다는 의미이다.

만약 protocol 내에 init이 있고 클래스로 구현되려고 한다면, `required` 표시가 되어있어야 한다. 왜냐하면 서브 클래스가 따라오는 것을 원치 않기 때문이다. 서브 클래스가 init을 받아서 더 이상 슈퍼클래스에서 init이 작동하지 않을 수 있다. 서브클래스에서 그렇게 하기를 원치 않는 이유는, 그 서브 클래스는 더 이상 이 프로토콜을 구현하지 않지만 상속받았기 때문에 되는걸로 생각할 수 있기 때문이다.



### extension 활용

클래스나 구조체에서 extension을 사용해 protocol을 구현해줄 수도 있다.

코드를 정리하거나 프로토콜 자체를 구현하기 위해 사용한다. 묶어 놓으면 보기좋아요 🙃

```swift
extension Something: SomeProtocol {
  // protocol 구현
  // stored properties는 사용할 수 없다.
}
```

### protocol을 타입에 맞게 사용하기

```swift
protocol Moveable {
  mutating func move(to point: CGPoint)
}
class Car: Moveable {
  mutating func move(to point: CGPoint) { ... }
  func changeOil()
}
struct Shape: Moveable {
  mutating func move(to point: CGPoint) { ... }
  func draw()
}

let prius: Car = Car()
let square: Shape = Shape()
```

protocol 이런 식으로 정의해서 사용할 수 있다. 

이제 여기에 움직일 수 있는 Moveable 변수를 추가해보자. prius는 Moveable 타입을 상속받고 있기 때문에 당연히 prius를 할당할 수 있다. 하지만 이렇게 하면 thingToMove.move 는 가능하지만, thingToMove.changeOil은 사용할 수 없다. Moveable 타입이기 때문이다.

그리고 thingToMove에는 prius와 마찬가지로 Moveable을 상속받은 square도 할당해줄 수가 있다.
thingsToMove: [Moveable] 라는 Moveable 배열로 완전히 다른 둘을 같은 배열에 둘 수도 있다.

```swift
...
var thingToMove: Moveable: prius
thingToMove.move(to: ...) // Ok
thingToMove.changeOil()		// Error!

thingToMove = square
let thingsToMove: [Moveable] = [prius, square]
```

Moveable 타입의 slider를 받아서 move를 실행하는 slide(slider:) 함수도 만들 수가 있다.

```swift
func slide(slider: Moveable) {
  let positionToSlideTo = ...
  slider.move(to: positiontoSlideTo)
}
slide(prius)
slide(square)
```

여러 개의 프로토콜을 구현해야 하는 인수를 받는 함수를 가질 수도 있습니다.

```swift
func slipAndSlide(x: Slippery & Moveable)
slipAndSlide(prius) // Error!!, prius는 Slippery를 상속받고 있지 않기 때문에 사용할 수 없다.
```



## Protocol의 활용 - Delegation

protocols의 중요한 사용 방식 중 하나는 View와 Controller 사이에 **blind communication**을 구현하는 것입니다.

6가지 과정을 거칩니다.

1. 뷰가 Delegate protocol을 선언합니다.
   여기엔 will, did, should와 같이 보내고자 하는 것이 담겨있습니다.
2. 뷰에는 public 변수로 delegation protocol인 **weak delegate** 변수를 갖고 있습니다.
3. 뷰가 will, did, should와 같이 어떤 것을 보내고 싶을 때 delegate 변수에 보냅니다.
4. 컨트롤러는 delegate protocol을 구현하겠다고 선언합니다.
5. 그리고 view의 delegate를 자기 자신으로 설정합니다.
6. 컨트롤러는 delegate protocol을 구현합니다.

이제 뷰와 컨트롤러가 엮이게 되지만, 뷰에선 여전히 어디서 사용되는지 모른채 그저 delegate 변수에 보내기만 하면 됩니다.



### Example

UIScrollView 에서 delegate 변수를 갖습니다.

```swift
weak var delegate: UIScrollViewDeleagte?
```

왜 weak일까요? 여기서 뷰는 컨트롤러는 가리키는 포인터를 갖고 있고 컨트롤러도 다른 여러 뷰와 연결된 포인터를 갖고 있습니다. Heap 메모리 안에서 유지된 채 말이죠. View에서 하고 싶은 일은 자신의 will, did, should를 **받는** 것을 가리키는 일입니다. 만약 그 대상이 heap을 빠져나가려 한다면, 그냥 그 대상을 nil로 바꾸고 더 이상 메세지를 보내지 않으면 됩니다. 이렇게 더 이상 뷰는 가리키던 대상(controller)을 힙 안에 두지 않게 됩니다.

UIScrollViewDelegate 는 이렇게 생겼습니다.

```swift
@objc protocol UIScrollViewDelegate {
  optional func scrollViewDidScroll(scrollView: UIScrollView)
  optional func viewForZooming(in scrollView: UIScrollView) -> View
  ... and many more ...
}
```

ViewController에서는 이렇게 delegate를 자신으로 설정합니다.

```swift
class MyViewController: UIViewController, UIScrollViewDelegate {
  // @IBOutlet의 didSet 에서
  scrollView.delegate = self
}
```



## Protocol의 활용 - Being a key in Dictionary

dictionary의 key가 되기 위해서는 unique 해야합니다.

**Hashable protocol**은 unique한 hashValue Int(해시값)를 제공하고, Hashable을 상속받아 dictionary의 key가 될 수 있습니다.

```swift
protocol Hashable: Equatable {
  var hashValue: Int { get }
}
```

주목할 점은 Hashable은 **Equatable protocol**을 상속받고 있는데, Equatable을 상속받음으로써 hashValue가 고유한지 확인할 수 있습니다. 

Equatable은 아래와 같이 생겼고 비교하는 == 메소드 하나만을 가지고 있습니다. 정적 메소드로 타입에 직접 관여합니다. 해시 가능한지 확인하기 위해 아래 메소드를 먼저 구현해야 합니다. 해시뿐만 아니라 어떤 클래스에서도 이 프로토콜을 사용한다면 `==` 를 사용할 수 있습니다.

```swift
protocol Equatable {
  static func ==(lhs: Self, rhs: Self) -> Bool
}
```

즉, Dictionary의 key는 Hashable 구현됩니다. Hashable하기만 하다면 어떤 타입이든 key가 될 수 있습니다.

```swift
Dictionary<Key: Hashable, Value>
```

Concentration 게임에서 emoji Dictionary의 key로 Int를 사용했었는데, 위에 배운 것을 활용해 Card를 key로 해줄 수 있습니다. 더 이상 identifire를 공개하지 않아도 됩니다.

```swift
struct Card: Hashable {
  
  static func ==(lhs: Self, rhs: Self) -> Bool {
    return lhs.identifire == rhs.identifire
  }
  
  private var identifier: Int
  ...
}
```



## Protocol의 활용 - Multiple Inheritance 다중 상속

`CountableRange (계수 가능 범위)` 는 많은 protocols를 구현합니다. 그 중 두 가지 Seqeunce, Collection 를 살펴보겠습니다.

`Sequence` : makeIterator, 현재 요소가 있고 다음이 있는 수로 다음 요소로 넘어가는 next 함수 만을 갖고 있습니다. 이걸로 `for in` 을 구현할 수 있습니다.

`Collection` : subscripting ([ ]), index(offsetBy:), index(of:), etc 같은 것들이 있습니다.



왜 이렇게 많은 protocol이 필요할까요?

Array, Set, Dictionary, String 등등 Apple의 많은 Generic 코드들이 같은 것을 구현하고 있기 때문입니다.  이렇게 함으로써 프로그래머는 CountableRange가 수열이라는 사실 하나만 배우면 됩니다.

뿐만 아니라 기본 구현을 제공합니다. min(), max(), index, 등등 하나만 구현해놓으면 Array, Set, Dictionary 등등 여러 곳에서 사용할 수 있습니다.

Swift에서 제공하는 Generic, Value Type, var이나 let같은 불변 변수 제어, protocol을 이용한 제약, protocol extension 등은 함수형 프로그래밍을 지원합니다. Swift의 장점은 객체지향과 함수형 프로그래밍을 모두 지원한다는 점입니다. 



## String

String은 sequnce가 아니라 유니코드로 이루어져있습니다. 유니코드란 바이트 단위의 데이터로 거의 모든 언어를 표현할 수 있습니다. String에서 Character는 단순히 하나의 유니코의 개념은 아닙니다. 하나의 Character는 여러 개의 유니코드일 수도 있습니다.

예를들어, cafe는 c-a-f-é 로 4개의 유니코드일 수도 있고 c-a-f-e-' 로 5개일 수도 있습니다. 이렇기 때문에 String을 Int로 색인하지 않습니다. 대신 `String.Index`라는 특별한 색인을 사용합니다.

이런식으로 사용해볼 수 있습니다.

```swift
var emojiChoices = "👿🎃👻🍭🍬🍎"

...
let randomIndex = emojiChoices.index(emojiChoices.startIndex, offsetBy: emojiChoices.count.arc4random)
emoji[card] = String(emojiChoices.remove(at: randomIndex))
```





## NSAttributedString





````swift
let attributes: [NSAttributedStringKey : Any]
let attributeText = NSAttributedString(string: "Flips: 0", attributes: attributes)
flipCountLabel.attributedText = attributeText
````



## Function Type

"function type"의 변수를 선언할 수 있습니다. 함수와 마찬가지로 받는 인자의 타입과 리턴 타입을 지정해줄 수 있습니다.

```swift
var operation: (Double) -> (Double)
operation = sqrt
let result = operation(4.0) // result will be 2.0
```



## Closure

closure는 인라인 함수입니다. 당연히 함수를 클로저로 만들 수 있습니다.

```swift
func changeSign(operand: Double) -> Double { return -operand }
var operation: (Double) -> (Double)
operation = chagneSign
let result = operation(4.0)

// closure
var operation: (Double) -> (Double)
operation = { (operand: Double) -> Double in return -operand }
let result = operation(4.0)

// return 타입이 추론 가능
var operation: (Double) -> (Double)
operation = { (operand: Double) in return -operand }
let result = operation(4.0)

// 피 연산자 타입도 이미 알고 있음
var operation: (Double) -> (Double)
operation = { (operand) in return -operand }
let result = operation(4.0)

// 이미 어떤 것을 리턴한다는 걸 알고 있음
var operation: (Double) -> (Double)
operation = { (operand) in -operand }
let result = operation(4.0)

// 인자도 적어줄 필요가 없다.
// 첫번째 요소를 0으로 $0, $1, $2 ... 
var operation: (Double) -> (Double)
operation = { -$0 }
let result = operation(4.0)
```



### 언제 클로저를 사용해야할까

#### 원하는 시점에 작업해주고 싶을 때

함수는 무엇을 할 지 알려주는 좋은 방법이다. 어떤 오류가 있을 때, 어떤 작업이 끝났을 때 해야할 일 등 **시간이 걸리는 작업**을 클로저로 넘겨줘서 그 작업이 필요할 때 함수를 불러와 사용할 수 있다.

#### 반복적인 일을 할 때

또 **반복적인 일을 할 때** 사용할 수 있다. 예를 들어, 배열에 같은 작업을 해주고 싶다면 map을 사용해 클로저를 넘겨 작업 해줄 수 있다.

```swift
let primes = [2.0, 3.0, 5.0, 10.0]
let negativePrimes = primes.map { -$0 }
let invertedPrimes = primes.map { 1.0/$0 }
let primeStrings = primes.map { String($0) }
```

#### 속성을 초기화해줄 때

````swift
var someProperty: Type {
  ...
  return Type
}()
````

`lazy` 와 함께 사용하면 더욱 효과적입니다.

#### Capturing

clousure를 사용할 때 주의할 점은 주변 변수를 포착한다는 것입니다. 클로저는 static 변수나 주변 지역 변수 등 다른 변수를 받을 수가 있습니다. 이때 클로저는 **reference type** 이기 때문에 그 변수들이 힙 메모리에 존재하게 됩니다.

```swift
var ltuae = 42
operation = { ltuae * $0 }
arrayOfOperations.append(operation)
```

위 예제에서 `operation` 클로저 안에서 지역변수 ltuae를 사용하고 있습니다. 그리고 operation은 `arrayOfOperation` 배열에 들어가게 되는데 ltuae를 모르면 사용할 수가 없습니다. 따라서 ltuae는 힙 메모리에 들어가게 됩니다.

