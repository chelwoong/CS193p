# Contents

- [Thrown Errors](#thrown-errors)
- [Any & AnyObject](#any-&-anyobject)
- Custom Drawing
- [Other Interesting Classes](#other-interesting-classes)
  - NSObject
  - NSNumber
  - Date
  - Data
- [Views](#views)
- [Coordinate System Data Structures](#coordinate-system-data-structures)
- [View Coordiante System](#view-coordiante-system)
- [Fonts](#fonts)
- [Drawing Images](#drawing-images)
- [CustomStringConvertible](#customstringconvertible)



# Thrown Errors

맨 뒤에 `throws` 키워드를 붙여서 에러를 발생시킬 수 있는 함수를 만들 수 있습니다.

```swift
func save() throws
```

throws 가 붙은 함수는 에러를 던질 수 있기 때문에 던져진 에러를 잡아줘야 합니다.

### do-catch

`do-catch` 구문으로 throws 함수를 처리해줍니다. 에러를 발생시킬 수 있지만 한번 실행해본다는 의미로 함수 앞에 `try` 를 붙여서 사용합니다. 

에러가 발생하면 catch 구문으로 가고 Error 프로토콜의 구현체 `NSError` 도 함께 확인할 수 있습니다.

```swift
do {
	try context.save()
} catch let error {
	// 에러가 발생하면 이곳으로 날라온다.
  // let error는 발생한 error의 지역변수로 Error protocl의 구현체이다.
}
```



### try!

do-catch 구문이 싫다면, `try!` 를 사용할 수도 있는데, 에러가 발생하면 앱을 강제 종료시킵니다. 에러가 발생하지 않는다고 확신할 수 있는 경우에만 사용해야 합니다. 즉 잘 쓰이지 않습니다.

```swift
try! context.save()
```

### try?

마찬가지로 do-catch 가 싫고 심각하지 않은 에러라면, 다른 방법으로 `try?` 를 사용할 수 있습니다. 에러가 발생하면 앱을 멈추지 말고 에러를 무시합니다. 만약 값을 반환하려고 한다면 `optional`로 바꿔서 리턴해줍니다. 에러가 발생하지 않으면 값을 주고 아니라면 nil을 반환합니다.

```swift
let x = try? errorProneFunctionThatReturnsAnInt() // x: Int?
```



# Any & AnyObject

`Any` 타입과 동일한 `AnyObject` 라는 타입도 있습니다. 클래스 타입에 한해서 사용할 수 있는 any를 의미합니다. 역시 swift 입장에선 달갑지 않은 녀석으로 any와 마찬가지로 Objective-C 와의 호환성을 위해서 존재합니다. 

Objective-C에는 id 라는 중요한 타입이 있는데, id는 어떤 것도 될 수 있고 거의 모든 api에서 사용됩니다.

Any 타입 변수는 구조체, 열거형, 클래스 등 다양한 타입이 될 수 있습니다.



### as

Any 타입을 사용할 때는 우리가 아는 타입으로 바꿔줘야 합니다. 이때 `as?` 를 사용하고 타입을 변환할 수 있으면 바꿔주고 아니라면 nil을 반환합니다. 따라서 as? 로 변환시켜주면 Optional 타입이 됩니다.

```swift
let unknown: Any
if let foo = unknown as? MYType {
  // foo: Mytype
}
```





## Casting

as는 Any 뿐만 아니라 다른 타입에도 사용할 수 있습니다. 주로 상위 클래스 하위 클래스로 변환할 때도 사용할 수 있습니다. 이를 `downcasting` 이라고 합니다. class 뿐만 아니라 `protocol` 에도 마찬가지로 사용될 수 있습니다.

```swift
let vc: UIViewController = ConcentrationViewController()
if let cvc = vc as? ConcentrationViewContrller {
  cvc.flipCard(...)	// UIViewController가 아닌 ConcentrationViewController의 메소드
}
```



# Other Interesting Classes

### NSObject

NSObject는 모든 objective-c 클래스의 root 클래스 입니다. 

UIViewController 같은 UIKit의 모든 클래스가 Objective-C 에서 개발되었는데, 여전히 Objective-C와 호환이 가능하고 이 클래스들이 모두 `NSObject` 클래스를 상속받고 있습니다. 

Objective-C 에서는 NSObject 클래스를 상속받지 않으면 런타임 에러가 발생하지만,
Swift 에서는 NSObject 클래스를 상속받을 필요는 없습니다. 단, 몇몇 소수의 API 들이 NSObject 클래스를 요구하기도 합니다.



### NSNumber

Objective-C 에서는 숫자를 전달할 때 이 Class를 이용합니다. Swift에서는 Double 이나 Int는 Struct이기 때문에 클래스가 없지만, Objective-C 에는 존재합니다. 

객체지향 적으로 사용하고 싶다면 `NSNumber` 를 사용합니다. NSNumber는 소수나 정수 뿐만 아니라 Boolean 까지도 가능합니다. 

iOS에서 많은 API가 NSNumber 클래스를 취하지만, 자동으로 Swift 타입으로 bridge 됩니다.
따라서 NSNumber 따로 알 필요는 없고 Swift에서 NSNumber로 뭔가가 날라왔더라도 그냥 어떤 타입으로 생각해도 무방합니다.

```swift
let n = NSNumber(35.5) or let n: NSNumber = 35.5
let intified: Int = n.intValue // or doubleValue, boolValue, etc ...
let boolean: Bool = n.boolValue // true
```



### Date

Date는 날짜나 시간을 표현하는 타입입니다. 내부적으로는 1970년 이후로 몇 초가 흘렀는지 표현되고, 아주 정밀한 단위로 백만분의 1초 단위로 측정합니다. 

`Calendar`,` DateFormatter`,` DateComponents` 등의 클래스가 종종 함께 사용됩니다. 왜냐하면 Date를 곧바로 UI을 때는 매우 조심해서 사용해야 하기 떄문입니다. 전 세계에서 날짜는 다양한 방식으로 표현됩니다. 



### Data

Data는 bit가 담겨있는 가방입니다. iOS API 간에 데이터를 전송할 때 사용합니다. 예를 들어, 인터넷의 어떤 URL에서 이미지를 얻고 싶다면 bit 가방인 Data를 확인해서 원하는 UIImage 등으로 만들 수 있습니다. 마찬가지로 JSON 등으로도 사용할 수 있습니다.

Data는 그저 bit 가방이므로 원하는 형태로 꺼내서 사용할 수 있습니다. bit를 다양한 클래스로 바꿀 수 있는 메소드들이 존재합니다. 



# Views

`View` 는 두 가지 의미로 해석됩니다.

1. MVC 의 `V` 로 ViewController에 붙어있는 많은 view 들을 의미합니다.

2. iOS의 클래스인 UIVIew의 서브 클래스를 의미합니다.



### UIView의 Subclass

`UIView의 서브 클래스`는 좌표계를 정의하는 화면의 직사각형을 말합니다. 이 좌표계는 drawing 할 때 사용하고 손가락을 이용해 멀티터치를 할 때에도 사용합니다. 



### Hierarchical

직사각형 안에 직사각형, 즉 View 안에 View가 있는 `계층 구조(Hierarchical)`를 갖습니다.
View는 그 View가 속해있는 **하나의** Superview를 가질 수 있습니다. 없을 수도 있기 때문에 UIView? 타입이 됩니다. 
또 View는 많은 **Subviews**를 가질 수 있습니다.

```swfit
var superview: UIView?
var subviews: [UIView]
```

### UIWindow

View 들의 최상위에 `UIWindow`를 갖습니다. iOS 앱에서 딱 하나만 존재합니다. 역시 View이므로 UIView의 서브클래스 입니다. 



### View Hierarchy

View의 계층 구조는 xcode의 storyboard 같은 interface builder 를 사용할 수도 있지만, code로도 할 수 있습니다. 

추가할 때는 **상위 뷰**에 `func addSubview(_ view: UIView)` 메소드를 사용해 하위 뷰를 추가할 수 있습니다.

제거할 때는 **하위 뷰** 에 `func removeFromSuperview()` 메소드를 사용해 상위 뷰에서 하위 뷰를 제거할 수 있습니다.

```swift
var superView = UIView()
var secondView = UIView()
var thirdView = UIView()

supverView.addSubview(subView)
subView.addSubview(thirdView)
/*
superView
	ﾤ subView
		ﾤ thridView
*/
thridView.removeFromSuperview()
/*
superView
	ﾤ subView
*/
```

ViewController 에서 `var view: UIView`  가 view의 최상위에 위치합니다.



## Intializing a UIView

보통 가능하면 initializing는 피하려고 노력합니다. 하지만 방법을 찾을 수 없다면 사용해야 합니다. 

뷰에는 보통 두 종류의 initialze가 존재합니다. 

- init(frame: CGRect)	// 코드로 생성할 때

- init(coder: NSCoder)  // interface builder(스토리보드)로 생성할 때

  > NSCoder라는 coder는 인터페이스 빌더를 잠시 중단시켰다가 앱이 실행되면 다시 살려내는 매커니즘을 갖고 있는 프로토콜입니다. 

이 두 가지를 모두 구현해야 합니다. 

왜냐하면 frame과 함께 쓰이는 init은 지정된 이니셜라이저라서 코드에서 뷰를 생성한 뒤 코드를 실행하고 싶다면 필요합니다.

coder와 함께 쓰이는 Init은 UIView가 NSCoder 프로토콜을 구현하는 데 필요합니다. 

setup과 같은 공통 함수를 만들고 두 경우에 모두 호출할 수 있습니다. 이때 변수는 super.init을 전에 모두 초기화가 되어야 하므로, setup 안에서 변수를 사용하려면 미리 초기화가 되어있어야 합니다.

```swfit
func setup() { ... }

override init(frame: CGRect) {
	super.init(frame: frame)
	setup()
}

required init?(coder aDecoder: NSCoder) {
	super.init(coder: aDecoder)
	setup()
}
```



UIView를 초기화하는 또 다른 방법은 `awakeFromNib()`를 쓰는 것입니다. awakeFromNib()는 인터페이스 빌더에서 나온 모든 오브젝트에게 보내집니다. 인터페이스 빌더 파일에서 나온 뷰만 awakeFromNib가 호출되는데, 인터페이스 빌더가 다시 살아났을 때, 즉 인터페이스 빌더의 중단이 해제되었을 때만 awakeFromNib가 호출 됩니다. **frame 을 사용해 생성된 View에서는 이 함수가 호출되지 않습니다.** 

Nib는 인터페이스 빌더 파일의 옛날 이름입니다. Ib와 Nib가 인터페이스 빌더를 뜻합니다. 



# Coordinate System Data Structures

화면에 뷰를 그리기에 앞서 먼저 기본적으로 알아야 할 자료구조를 배워볼 차례입니다.

앞에 모두 **CG**가 붙는데 CG는 **Core Graphics** 를 뜻합니다.

일반적으로 iOS에서 코어 그래픽스는 **2차원 드로잉**을 하기 위한 시스템을 뜻합니다. 

코어 그래픽스는 4개의 타입을 갖고 있습니다.

### CGFloat

드로잉은 **부동 소수점** 숫자를 좌표로 하는 시스템에서 이루어집니다. 뷰의 좌표 시스템에서 정수나 Double, Float이 아닌 CGFloat이 기본 좌표값이 됩니다. 물론 CGFloat에도 initializer가 있어서 Double 이나 Float 으로 만들 수 있습니다.

```swift
let cgf = CGFloat(aDouble)
```



### CGPoint

CGFloat 타입인 변수 x, y 가 들어있는 구조체 입니다.

### CGSize

CGFloat 타입의 높이, 너비가 들어있는 구조체 입니다.

### CGRect

CGPoint와 CGSize를 결합한 구조체 입니다. CGRect는 직사각형을 뜻합니다. 

많은 이니셜라이저와 값을 변경하기 위한 메소드를 가지고 있습니다.

```swift
struct CGRect {
  var origin: CGPoint
  var size: CGSize
}

// example
var minY: CGFloat						// 왼쪽 위 모서리
var midY: CGFloat 					// 수직 중간 값
intersects(CGRect) -> Bool 	// 다른 직사각형과 겹치는지 확인
intersect(CGRect)						// 두 직사각형이 겹치는 부분을 리턴
contains(CGPoint) -> Bool		// 해당 점이 포함되는지 확인
```



# View Coordiante System

### origin

뷰가 그려질 2차원 좌표계입니다. iOS 에서 좌표계는 왼쪽 위 (0, 0) 를 시작점으로 합니다.

### points 단위, not pixels

이 좌표계의 단위는 **포인트** **points** 라고 합니다. 픽셀 pixels 과는 다른 개념입니다.

한 포인트 당 픽셀이 얼마나 많냐에 따라 해상도가 결정됩니다.

픽셀은 스크린을 구성하고 있는 작은 점으로 레티나 디스플레이 같은 화면에는 픽셀이 많아 해상도가 높습니다. 픽셀이 많으면 좋은 이유는 포인트의 경계를 그릴 때 더 세세하게 그릴 수 있기 때문입니다. 
27포인트에서 28포인트로 옮겨간다고 할때, 저 해상도에서 픽셀을 하나씩 찍는다고 한다면 고해상도에서는 27.2, 27.5 등 더 세세하게 그릴 수 있습니다. 

### bounds

뷰가 가지고 있는 CGRect 변수 입니다. 뷰는 각각 자신의 좌표계를 가지고 있습니다. bounds 는 자기 자신에 대한 좌표계 정보입니다. 즉, 기본적으로 bounds의 origin은 항상 (0, 0)이 되고 자신의 너비와 높이를 가지고 있습니다. 따라서 뷰를 그릴 때는 bounds를 사용합니다. 

이와는 다르게 **frame** 변수도 있는데, frame은 드로잉과는 전혀 관계가 없습니다. frame도 CGRect 타입이지만 슈퍼 뷰에서 자신이 어디 있는지를 나타냅니다. frame은 자신의 좌표계가 아니라 슈퍼 뷰의 좌표계를 말합니다.

또 비슷하게 center 또한 지금 드로잉하는 영역의 중심이 아니라 슈퍼 뷰의 입장에서 본 뷰의 중심을 의미합니다.

즉 **frame과 center**는 지금 **어디서 그리고 있는지**에 대한 정보를 나타내고, 
**bounds**는 **지금 그리는 곳**에 대한 정보를 나타냅니다.

>  frame과 bounds의 높이와 너비가 같다고 생각할 수 있는데, 같을 필요가 없고 항상 같지도 않습니다.
>
> 뷰를 회전한다고 생각하면 뷰 자체의 높이와 너비는 변하지 않기 때문에 bounds는 그대로겠지만, 회전하는 영역을 모두 감싸야 하기 때문에 frame은 더 커집니다.





# Creating Views

뷰의 생성은 인터페이스 빌더와 코드로 할 수 있습니다. 인터페이스 빌드에서는 뷰 오브젝트를 끌어다 놓으면 되고

코드로는 해당 뷰의 프레임을 줘서 생성할 수 있습니다. 만약 프레임을 따로 지정해주지 않는다면 뷰의 좌상단 모서리인 (0,0)에 맞춰집니다. 

addSubview를 통해 뷰를 추가해줍니다.

```swift
let myView = UIView(frame: otherView) // otherView의 프레임과 동일한 뷰 생성
let defaultView = UIView()	// origin (0,0)에 뷰 생성

view.addSubview(myView)
```



# Custom Views

iOS에서 직접 뷰를 그릴 수 있는 방법은 한 가지밖에 없습니다.

```swift
override func draw(_ rect: CGRect)
```

UIView의 draw 메소드로 뷰의 경계를 그릴 수 있습니다.



단, 이 draw 함수는 **절대** 직접 호출해서는 안됩니다. 

만약 뷰를 다시 그리고 싶다면, 다음 두 메소드 중 하나를 호출합니다. draw 함수는 오직 iOS 시스템만 호출할 수 있습니다. 

setNeedsDisplay(_ rect: CGRect) 메소드에서 rect는 최적화를 위해 사용됩니다. 뷰 전체가 아니라 특정 뷰만 다시 그려도 된다면 그렇게 하는게 효율적이겠죠. 그러나 너무 많은 자원을 쓰거나 3D 그래픽이 아니라 쉽게 그릴 수 있는 뷰라면 rect는 무시해도 괜찮습니다.

```swift
setNeedsDisplay()
setNeedsDisplay(_ rect: CGRect) // 필요한 부분만 다시 그린다.
```



그렇다면 이제 진짜 뷰를 그리는 방법을 알아보겠습니다. 코어 그래픽스를 이용하거나 객체지향적으로 UIBezierPath 클래스를 가져와 사용할 수도 있습니다. 먼저 코어 그래픽스에서 드로잉하는 것의 핵심 개념부터 알아보겠습니다.



### Core Graphics Concepts

1. Contexts 가져오기

코어 그래픽스는 **컨텍스트 contexts**를 기반으로 합니다. UIBezierPath는 자동으로 컨텍스트를 얻어오지만, UIBezierPath를 사용하지 않는다면 컨텍스트를 얻어와야 합니다. 

Swift의 전역변수인 `UIGraphicsGetCurrentContext()` 를 사용해 가져올 수 있습니다. 드로잉 할 컨텍스트를 알려줍니다.

하지만 출력을 하거나 화면에서 드로잉을 껐다 켰다 할 수 있는 다른 컨텍스트도 있을 수 있는데, draw(_ rect: CGRect) 에서는 UIGraphicsGetCurrentContext() 만으로 충분합니다.

2. Path 생성 (out of lines or arcs, etc)
3. attributes 설정 (colors, fonts, textures lineWidths, lineCaps, etc)
4. 위에 설정한 path와 attributes에 따라 선을 그리거나 채웁니다. (stroke or fill)

### UIBezierPath

위에서 직접 작업해주는 path, attributes, stroke 등등의 작업들이 담겨있는 가방이라고 생각하면 좋습니다.



## Defining a Path

이제 구체적으로 그려보겠습니다. 

UIBezierPath를 사용해 삼각형을 그린다면 이렇게 할 수 있습니다.

```swift
// UIBezierPath 생성
let path = UIBezierPath()

// 경로 그리기
path.move(to: CGPoint(80, 50))
path.addLine(to: CGPoint(140, 150))
path.addLine(to: CGPoint(10, 150))

// 필요하다면 close를 시작 위치로 마무리
path.close
```



하지만 이렇게 하면 화면에는 아무런 변화도 일어나지 않습니다. 이건 단순히 경로를 설정했을 뿐, 화면에 그리려면 attributes 와 stroke, fill 등을 설정해 어떻게 그릴지 알려줘야 합니다.

```swift
UIColor.green.setFill()
UIColor.red.setStroke()
path.lineWidth = 3.0
path.fill()
path.stroke()
```

이밖에도 clip 등 다양한 일을 할 수 있습니다.





# Fonts



### preferred font

preferred font` 를 상황에 맞춰 잘 사용하는 것이 중요합니다. preferred font를 사용하면 사용자의 설정에 글자의 크기를 가변적으로 적용할 수 있습니다.

Interface Builder에서 쉽게 설정할 수 있고 코드로도 할 수 있습니다.

코드로는 `UIFont`의 static 메소드를 사용합니다.

```swift
static func preferredFont(forTextStlye: UIFonteTextStyle) -> UIFont

UIFontTextStyle
	.headline
	.body
	.footnode
	...
```



### custom font

Custom Font 를 사용할 수도 있습니다.

```swift
let font = UIFont(name: "Helvetica", size: 36.0)
```

하지만 이렇게 하면 size가 36으로 고정되어 있기 때문에 가변적으로 변할 수가 없습니다.

그럴때 `metrics` 를 사용합니다.

```swift
let metrics = UIFontMetrics(forTextStyle: .body)
let fontToUse = metrics.scaledFont(for: font)
```



### system font

주로 버튼 제목 같은 곳에만 사용되는 폰트입니다. 

```swift
static func systemFont(ofSize: CGSize) -> UIFont
static func boldSystemFont(ofSize: CGSize) -> UIFont
```



# Drawing Images

`UIImageView` 를 사용하는데 이미지는 `UIImage` 객체를 생성해서 사용해줘야 합니다.

Image를 얻어오는 방법은 여러 가지가 있습니다.

`Asset.xcasset` 에 있는 이미지 가져오기

```swift
let image: UIImage? = UIImage(name: "foo")
```

filesystem에 있는 파일을 가져오거나 인터넷에서 bit 가방인 Data 타입을 받아와 사용할 수도 있습니다.

```swift
let image: UIImage? = UIImage(contentsOfFile: pathString)
let image: UIImage? = UIImage(data: aData)
```

`UIGraphicsBeginImageContext(CGSize)` 를 사용해 Core Graphics로 직접 그럴 수도 있습니다.





UIImage를 얻어왔다면 다양한 방식으로 그려낼 수 있습니다.

```swift
let image: UIImage = ...
image.draw(at point: aCGPoint)  // image를 왼쪽 상단 모서리에 그립니다.
image.draw(in rect: aCGRect) // rect에 맞춰 이미지를 그립니다.
image.drawAsPattern(in rect: aCGRect) // rect에 맞춰 이미지를 타일처럼 반복적으로 그려냅니다.
```



## bounds가 변했을 때 다시 그리기

대표적으로 기기를 회전시켰을 때 이미지를 다시 그려줄 필요가 있습니다. 하지만 iOS에서 기본적으로는 다시 그려주지 않습니다.

이럴 때 UIView의 content mode 를 사용합니다. view가 어떤 종류의 content를 가지고 있는지 나타냅니다.

```swift
var contentMode: UIViewContentMode
```

### UIViewContentMode

3가지 종류가 있습니다.

1. 비트 유지
   새로 그리지 않고 크기도 조절하지 않고 비트만 움직입니다. 거의 사용되지 않습니다.
   .left/.right/.top/.bottom/.topRight/...
2. 비트 늘이기
   비트를 늘이거나 줄여서 새로운 공간에 맞춥니다. 화면의 비율을 잘 고려하지 않습니다. 
   .sacleToFill / .scaleAspectFill / .scaleAspectFit // scaleToFil 을 기본값으로 갖습니다. 
3. 다시 그리기 (redraw)
   경계가 바뀌었을 때 draw(rect)를 호출해서 새로 드로잉합니다. draw(rect)를 호출했을 때 경계의 위치를 알아서 경계에 맞게 드로잉할 수 있습니다.



### bounds가 변할 때

bounds가 변화하면 subviews를 재배치해야 할 수 있습니다. 

subview들에 **Autolayout 을 설정해두지 않았다면**, `layoutSubviews()` 를 사용해  수동으로 레이아웃을 재배치할 수 있습니다. 
즉, layoutSubviews() 는 subview에 autolayout이 적용되어 있지 않을 때 사용합니다.

```swift
override func layoutSubviews() {
  super.layoutSubviews()
}
```



## CustomStringConvertible

이 프로토콜을 상속받으면 `var description: String` 을 구현해야 합니다. 이를 통해서 객체의 description을 만들어줄 수 있습니다.

```swift
struct PlayingCard: CustomStringConvertible {
    
    var description: String { return "\(suit)\(rank)" }
    
    var suit: Suit
    var rank: Rank
  	...
}
```



