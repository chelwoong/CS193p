# CHAPTER3

## stride

`stride` 는 셀 수 있는 범위를 지정해주 는 메소드이다.

이걸 이용하면 소수와 같은 부동소수점도 셀 수가 있다.

```swift
for i in stride(from: 0.5, throught: 15.25, by: 0.3) {
  
}
```



## Tuple

튜플은 메소드나 변수가 없는 소형 `구조체`이다.

 값만 있는 형태의 매우 가벼운 구조체로 요소의 이름을 유연하게 설정할 수 있다.

```swift
let x: (String, Int, Double) = ("hello", 5, 0.85)
let (word, number, value) = x
print(word)		// print "hello"
print(number)	// print 5
print(value)	// print 0.85

let x: (w: String, i: Int, v: Double) = ("hello", 5, 0.85)
print(x.w) 	// print "hello"
print(x.i)	// print 5
print(x.v)	// print 0.85
let (wrd, num, val) = x
```



## Computed Property

값을 어디에 저장하지 않고 계산된 형태로 사용할 수 있다.

다른 언어에서 흔히 보이는 get set을 사용하는데,

get없이 set만 있을 수는 없다. 그러면 함수를 만드는 편이 낫다. 

### Get

get은 값을 얻고자 하는 경우에 사용한다. 따라서 get 안에서는 값을 리턴해주면 된다. set없이 get만 사용할 때는 굳이 get을 사용해주지 않아도 된다.

```swift
// lazy var game = Concentration(numberOfPairsOfCards: (cardButtons.count+1)/2)

lazy var game = Concentration(numberOfPairsOfCards: numberOfPairsOfCards)

var numberOfPairsOfCards: Int {
  return (cardButtons.count+1) / 2
}

```



### Set

set에서 newValue는 생략해줄 수 있다. 잘 활용하면 코드를 간결하고 직관적이게 만들어준다.

````swift
var indexOfOneAndOnlyFaceUpCard: Int?

func chooseCard(at index: Int) {
  if let matchIndex = indexOfOneAndOnlyFaceUpCard, matchIndex != index {
    if cards[matchIndex].identifire == cards[index].identifire {
      cards[matchIndex].isMatched = true
      cards[index].isMatched = true
    }
    cards[index].isFaceUp = true
    indexOfOneAndOnlyFaceUpCard = nil
  } else {
    for downFlipIndex in cards.indices {
      cards[downFlipIndex].isFaceUp = false
    }
    cards[index].isFaceUp = true
    indexOfOneAndOnlyFaceUpCard = index
  }
}
````

이 코드를 이렇게 개선해줄 수 있다. 이렇게 computed Property를 사용함으로써 chooseCard에서는 진짜 카드를 선택하는 일에만 집중할 수 있게된다.

```swift
var indexOfOneAndOnlyFaceUpCard: Int? {
  get {
    var foundIndex: Int?
    for index in cards.indicies {
      if cards[index].isFaceUp {
      	if indexOfOneAndOnlyFaceUpCard == nil {
          foundIndex = index
        } else {
					return nil
        }
      }
    }
    return foundIndex
  }
  
  set {
    for index in cards.indicies {
    	cards[index].isFaceUp = (index == newValue)
    }
  }
}

func chooseCard(at index: Int) {
  if let matchIndex = indexOfOneAndOnlyFaceUpCard, matchIndex != index {
    if cards[matchIndex].identifire == cards[index].identifire {
      cards[matchIndex].isMatched = true
      cards[index].isMatched = true
    }
    cards[index].isFaceUp = true
    //indexOfOneAndOnlyFaceUpCard = nil
  } else {
    /*
    for downFlipIndex in cards.indices {
      cards[downFlipIndex].isFa0ceUp = false
    }
    cards[index].isFaceUp = true
    */
    indexOfOneAndOnlyFaceUpCard = index
  }
}
```





## Access Control

접근제어자는 변수나 함수, 클래스 구조체 등 앞에 붙여서 접근을 제한할 수 있다.

### internal

기본값으로 따로 접근제어자를 설정하지 않는다면 internal이 기본값으로 들어간다.
internal은 앱이나 프레임워크의 모든 요소가 접근가능한 코드이다.

### private

외부에서 읽고 쓰는 것을 차단한다.

### private(set)

외부에서 읽는 것은 가능하지만 수정은 차단한다.

### fileprivate

파일 안에서는 자유롭게 읽고 쓸 수 있다.

### public

외부에서 읽을 수 있지만 수정은 차단한다

### open

외부에서 읽고 쓰는 것을 완전 개방한다.



## Assertion

assert(조건문, 경고 메세지) 와 같은 식으로 사용한다.

조건문이 아닐 경우 에러를 발생시키고 경고 메세지를 출력한다.

```swift
assert(cards.indicies.contains(index)), "Concentration.chooseCard(at: \(index)): chosen index not in the cards")
```



## Extensions

extension을 이용해 변수와 함수를 다른 클래스에 추가할 수 있다.

값을 저장할 수 없다.
기존 것을 확장하는 형태이기 때문에 저장하는 변수는 둘 수 없다.

해당 클래스에 어울리지 않는 변수나 함수를 추가하지 않도록 주의한다.

```swift
extension Int {
  var arc4random: Int {
  	return arc4random_uniform
  }
}
```

## enum

연관된 값을 묶어서 정의할 수 있다. 구조체나 클래스와 같이 하나의 타입이다.

```swift
enum FastFoodItem {
  case hamburger
  case fries
  case drink
  case cookie
}
```

enum은 필수는 아니지만 원하는 경우에 연관값을 가질 수 있는데, 튜플과 유사하다

```swift
enum FastFoodItem {
  case hamburger(numberOfPatties: Int)
  case fries(size: FryOrderSize)
  case drink(String, ounces: Int)
  case cookie
}
```

enum은 구조체와 마찬가지로 저장 값을 가질 수 없지만 변수나 메소드는 가질 수 있다. switch를 사용해 정의해둔 연관값 또한 사용할 수 있다. fires, cookies처럼 `,` 로 묶어서 사용할 수도 있고 `_` 를 사용해 생략할 수도 있다. 

```swift
enum FastFoodItem {
  ...
  func isIncludedInSpecialOrder(number: Int) -> Bool {
    switch self {
      case .hamburger(let patteyCount): return patteyCount == number
      case .fires, .cookies: return true
      case .drink(_, let ounces): return ounces == 16
    }
  }
  case hamburger(numberOfPatties: Int)
  case fries(size: FryOrderSize)
  case drink(String, ounces: Int)
  case cookie
}
```

enum의 값을 변경할 수도 있는데, 구조체나 enum은 내부 상태를 변경할 때는 반드시 `mutating` 을 붙여줘야 한다. 

enum과 구조체 같은 value type은 쓰기를 할 때 복제가 일어난다. 쓰기를 실행하기 전에는 복제가 일어나지 않기 때문에 어떤 함수가 쓰기를 원하는지 알려줘야한다. 이를 알려주는게 `mutating` 이다.



## Optional

옵셔널은 enum으로 개념상 아래와 같이 볼 수 있다.

```swift
enum Optional<T> {
  case none
  case some(<T>)
}

var hello: String?							var hello: Optional<String> = .none
var hello: String? = "hello"		var hello: Optional<String> = .some("hello")
var hello: String? = nil				var hello: Optional<String> = .none
```

매번 switch를 사용하면 코드가 길어지기 때문에 `if let`, `guard`, `??`, `!` 등 다양한 방법을 제공한다.

````swift
/* 강제 언래핑 사용시 */
let hello: String? = ...
print(hello!)

// 값이 없다면 크래시
switch hello {
  case .none: // raise an exception (crash)
  case .some(let data): print(data)
}

/* guard */
if let greeting = hello {
 	print(greeting)
} else {
  // do something
}

// 값이 없을 때 경우 처리
switch hello {
  case .some(let data): print(data)
  case .none: { /* do something */ }
}
````



### Optional Chaining

옵셔널 체이닝이란 개념상 아래와 같은 방식이다, 중간에 어느 하나라도 nil 값이 있다면 nil이 된다.

```swift
/* Optional Chaining */
let x: String? = ...
let y = x?.foo()?.bar?.z

switch x {
  case .none: y = nil
  case .some(let data1):
  	switch data1.foo() {
      case .none: y = nil
      case .some(let data2):
      	switch data2.bar {
          case .none: y = nil
          case .some(let data3): y = data3.z
        }
    }
}
```

## Data Structures

**Swift에서 알아야 할 필수 자료구조 4가지**

- class
- struct
- enum
- protocol



### Class

클래스는 객체지향 디자인을 지원한다.  

기능과 데이터 모두에게 단일 상속을 지닌다. 즉, 데이터를 상속  

Reference Type (클래스는 힙에 저장되고 포인터를 전달한다)  



## *Memory Management

### ARC(Automatic Reference Counting)
레퍼런스 타입은 힙 내에 존재하게 되는데 언제 어떻게 사라질까? 
이를 위해서 Swift에서는 ARC 방식을 사용한다. Swift는 힙 내에 참조 카운트를 만들 때마다 Swift는 어딘가에 있는 카운터에 1을 더한다. 그리고 가리키는 것이 없어지거나 더 이상 가리키지 않게 되었을 때 nil로 설정되고 카운트가 1 줄어들게 된다. 그래서 **카운트가 0이 되면 힙에서 제거한다.**
가비지 콜렉션처럼 흔적을 쫓거나 마킹해서 쓸어버리는게 아니라 더 이상 가리키는 포인터가 없는 즉시 삭제하는 방식이다.



### Influencing ARC

reference type을 지정해줌으로써 ARC 방식에 영향을 줄 수 있다.

- strong
- weak
- unowned

#### strong - 포인터

`strong` 은 기본값으로 평범한 참조 방식이다. 만약 어떤 포인터가 strong이라면 포인터가 가리키고 있는 한 힙 내에 계속 두게된다. 

#### weak - 옵셔널 포인터!

`weak` 은 상대가 나한테 관심이 있을 때만 관심을 갖는다. 

힙 내에 있는 어떤 것을 가리키고 있지만, 나로인해 가리키는 대상을 힙 내에 두지 않는다.

모든 strong 포인터가 사라지면 nil을 받아서 힙에서 제거한다. 따라서 weak는 옵셔널 포인터이다.

**대표적으로 oultet이나 delegate에서 많이 사용된다.**

#### unowned 

참조하지 않는다는 의미이다. 만약 힙 내의 어떤 것을 가리키고 있을 때 strong 포인터로 인식하지 않고 힙에서 사라졌을 때 접근하지 않는 것을 의미한다. 

메모리 사이클을 피하기 위해 사용한다.

주로 클로저에서 많이 사용된다.

> 메모리 사이클이란 힙 내의 어떤 것이 힙 내의 다른 어떤 것을 가리키고 그게 다시 가리키는 것을 의미한다. 서로 가리키면서 힙 내에 유지되지만 서로를 가리키는 것을 제외하고는 아무것도 가리키지 않아서 쓸모없는 메모리 낭비를 초래한다.



### struct

value 타입이기 때문에 힙 내에 존재하지 않고 복제된다. 

**"copy on write"**  방식인데 이를 사용하기 위해서는 `mutating` 키워드가 필요하다.

상속이 없다.

### enum

value 타입, 연관 값을 가질 수 있으며

funtional inheritance (기능 상속)을 가질 수 있다.

### protocol

 기능 상속이란 protocol을 통해 이루어진다. 

