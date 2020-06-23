# Contents
- MVC
- Model
- Struct vs Class
- Sequence
- static
- lazy
- indicies

## MVC




## Model

공개 API가 뭔지 먼저 생각해야한다.

이렇게 디자인 하면 근본적으로 뭘 하는지 알고 어떻게 사용할 지 생각하게 되기 때문에 어떻게 디자인 할 지 명료하게 생각할 수 있다.

```swift
struct Card {
  var isFaceUp = false
  var isMatched = false
  var identifier: Int
}

```

**여긴 Model이므로 이모티콘이나 이미지 같은 화면에 어떻게 보여질지에 관한 정보는 담고 있으면 안된다.**



## Struct vs Class

Struct

- 상속성 x
- value type

Class

- 상속성 o
- reference type



`Struct`는 값을 복사하는데, swift는 복사할 때 매우 똑똑하다, 모두 복사하지 않고 누군가 내용을 변경했을 때만 실제로 복사하는 전달방식 - `쓰기 시 복사` 

`Class`는 힙에 자료형이 담겨있고 그 자료형 포인터를 쓸 수 있다. 여러군데서 사용하면 실제 그 자료형을 보내는게 아니라 그 자료형의 포인터를 전달한다. 따라서 코드 안에 한 오브젝트를 가리키는 포인터가 잔뜩 있을 수 있다.



`Class` 는 모든 값이 초기화되면 자동으로 init을 가지게 된다.



`struct` 가 갖는 기본 init은 모든 변수를 초기화한다. **정의시 이미 초기화한게 있더라도**



## Sequence

첫번째 항목에서 시작해 다음으로 갈 수 있는 모든 것을 Sequnce라고 한다.

Array, String을 sequnce라고 할 수 있다.



## static

static method는 특정 클래스 안에 있지만 특정 클래스에게 보낼 수 없다. 특정 클래스는 static을 이해할 수 없다. 오직 클래스 `타입`만 이해할 수 있다. 이렇게 타입 자체에게 요청하는걸 `정적` 이라고 한다.

```swift
struct Card {
  var isFaceUp = false
  var isMatched = false
  var identifier: Int
  
  static var identiferFactory = 0
  
  static func getUniqueIdentifier() -> Int {
    //Card.identifierFactory += 1
    //return Card.identifierFactory
    // Card Class 안 이므로 위처럼 적지 않고 클래스를 생략한다.
    identiferFactory += 1
    return identiferFactory
  }
  
  func init() {
    identifier = Card.getUniqueIdentifer
  }
}
```



## lazy

Swift 에서는 어떤 변수나 메서드든 사용하기 전에 반드시 초기화가 되어야 한다.

아래와 같이 초기화되지 않은 변수를 다른 변수를 초기화 하는 도중에 사용할 수 없다는 문제가 생긴다.

이때 사용할 수 있는 것이 `lazy`

어떤 변수를 lazy로 만들면 이 **변수를 사용하기 전까지는 초기화하지 않는다.**

실제로 초기화되지는 않았지만 초기화되었다고 쳐주기 때문에 문제없이 사용할 수 있다.

```swift
// Error!
// Concentration과 cardButtons는 모두 초기화 되어야 하는 대상
// game을 초기화 하고 있는 도중에 초기화되지 않은 변수를 사용할 수 없다.
var game = Concentration(numberOfPairsOfCards: (cardButtons.count + 1)/2)

// Ok
// 사용하기 전까지 실제로 초기화되지 않지만 초기화되었다고 쳐준다.
lazy var game = Concentration(numberOfPairsOfCards: (cardButtons.count + 1)/2)
```



**하지만 lazy가 되면 didSet과 같은 Property Observer를 사용할 수 없다.**



## indicies

indicies는 배열의 메소드다. 배열의 모든 인덱스의 범위를 리턴해준다. CountableRange 타입이다.



