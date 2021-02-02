- [draw(rect:)](#draw(rect:))
    - [NSAttributedString](#nsattributedstring)
        - [UIFontMetrics](#uifontmetrics)
        - [NSMutableParagraphStyle](#nsmutableparagraphstyle)
    - [setNeedsDisplay, setNeedsLayouts](#setneedsdisplay,-setneedslayouts)
    - [layoutSubviews()](#layoutsubviews())
    - [sizeToFit()](#sizetofit())
    - [transform](#transform)
    - [traitCollectionDidChange](#traitcollectiondidchange)
    - [@IBDesignable](#@ibdesignable)
    - [@IBInspectable](#@ibinspectable)
- [Gesture](#gesture)
    - [gesture 추가](#gesture-추가)
    - [gesture 처리](#gesture-처리)
    - [PanGestureRecognizer](#pangesturerecognizer)
    - [UIPinchGestureRecognizer](#uipinchgesturerecognizer)
    - [UIRotationGestureRecognizer](#uirotationgesturerecognizer)
    - [UISwipeGestureRecognizer](#uiswipegesturerecognizer)
    - [UITapGestureRecognizer](#uitapgesturerecognizer)
    - [UILongPressRecognizer](#uilongpressrecognizer)

# draw(rect:)

### Core Graphics를 사용한 draw

UIGraphicsGetCurrentContext 는 strokePath()를 할 때 경로를 **따라 그리며 지워버린다**. 따라서 strokePath 이후 fillPath를 할 때는 path가 존재하지 않아서 원 안이 채워지지 않는다.

```swift
if let context = UIGraphicsGetCurrentContext() {
    // 드로잉 경로
    context.addArc(center: CGPoint(x: bounds.midX, y: bounds.midY), radius: 100.0, startAngle: 0, endAngle: 2*CGFloat.pi, clockwise: true)
    context.setLineWidth(5.0)
    UIColor.green.setFill()
    UIColor.red.setStroke()
    context.strokePath()
    context.fillPath()
}
```

### BezierPath를 사용한 draw

UIBezierPath는 class여서 stroke()를 한 이후에도 storke 그대로 유지되고 정상적으로 green color로 원이 채워진다.

```swift
// UIBezierPath 를 사용해 그려보기!
let path = UIBezierPath()
path.addArc(withCenter: CGPoint(x: bounds.midX, y: bounds.midY), radius: 100.0, startAngle: 0, endAngle: 2*CGFloat.pi, clockwise: true)
path.lineWidth = 5.0
UIColor.green.setFill()
UIColor.red.setStroke()
path.stroke()
path.fill()
```

이 상태에서 디바이스를 회전시키면, 그려진 원 비트를 어떻게 할지 contentMode에 따라 결정한다. 기본 설정인 `scaleToFill` 이라면 타원 형태로 늘려지고, 다시 그리고 싶다면 `redraw` 로 설정한다.

## NSAttributedString

### UIFontMetrics

system 설정의 fontSize에 따라 font 크기를 조절해주기 위해 `UIFontMetrics` 를 사용

### NSMutableParagraphStyle

정렬 등과 같은 속성을 가지고 있음

```swift
private func centeredAttributedString(_ string:String, fontSize: CGFloat) -> NSAttributedString {
    // 하트와 모양을 위해 필요한 2가지 속성. 1. 크기, 2. 정렬
    
    // 1. 폰트
    var font = UIFont.preferredFont(forTextStyle: .body).withSize(fontSize)
    font = UIFontMetrics(forTextStyle: .body).scaledFont(for: font) // 크기 사이즈 조절가능하게 함
    
    // 2. 가운데 정렬
    let paragraphStyle = NSMutableParagraphStyle()
    paragraphStyle.alignment = .center
    return NSAttributedString(string: string, attributes: [.paragraphStyle: paragraphStyle, .font:font])
}
```

## setNeedsDisplay, setNeedsLayouts

rank나 suit등이 변해서 다시 draw해줘야 할 때 `setNeedsDisplay` 를 호출한다. 

(→ 그러면 system은 `draw(_ rect:)`를 호출해준다.)

또 이에 따라 subViews를 재배치 해줘야 한다면 `setNeedsLayouts` 를 호출한다.

(→ 그러면 system은 `layoutSubviews()` 를 호출해준다.

```swift

// 변수 타입이 Int, String으로 
// Model에서와는 타입이 완전히 다르다. 하지만 모델은 신경쓸 것 없다 여긴 뷰를 그리는 뷰만 담당하는 곳이니까!!!
var rank: Int = 5 { didSet{ setNeedsDisplay(); setNeedsLayout() }}
	// 값이 바뀌면 새로 그려줘야 한다. 내가 직접 draw를 호출할 수 없으니 setNeedsDisplay()를 사용!!!
	// 뷰에서 멀어지는 서브뷰가 있으면 서브뷰가 서로 다시 배치해줘야 하니 setNeedsLayout() 사용!
var suit: String = "❤️" { didSet{ setNeedsDisplay(); setNeedsLayout() }}
var isFaceUp: Bool = true   { didSet{ setNeedsDisplay(); setNeedsLayout() }}
```

### layoutSubviews()

 서브뷰가 재배치 되어야 한다면 시스템이 `layoutSubviews()` 를 호출한다.

### sizeToFit()

sizeToFit()을 할 때 이미 너비가 설정되어 있다면 너비는 그대로 두고 높이면 바꾼다.

이를 방지하기 위해 **sizeToFit을 호출하기 전에 size를 지워준다.**

```swift
func configureCornerLabel(_ label: UILabel) {
    label.attributedText = cornerString
    label.frame.size = CGSize.zero  // 너비가 바꼈을 때 sizeToFit()은 너비는 두고 높이면 바꾼다. 전체 크기를 조절하고 싶어서 사용!
    label.sizeToFit()
    label.isHidden = !isFaceUp
}
```

### transform

affine 변환을 할 때 이 변수를 사용한다.

뷰의 크기, 평행이동, 회전을 나타내고 **비트 단위의 변환**이다. 

회전을 할 때 origin을 중심으로 회전하기 때문에 원하는 대로 왼쪽 아래 구석에 오지 않는다.

따라서 평행이동과 회전을 함께 해준다.

```swift
// label의 위치 정하기
// 왼쪽 위는 원점과 가까워서 별로 상관이 없지만, 오른쪽 아래는 경계가 바뀔때를 신경써줘야한다!!
override func layoutSubviews() {
    super.layoutSubviews()
    
    configureCornerLabel(upperLeftCornerLabel)
    upperLeftCornerLabel.frame.origin = bounds.origin.offsetBy(dx: cornerOffset, dy: cornerOffset)
    
    configureCornerLabel(lowerRightCornerLable)
    // 회전, 이동 등 평행이동을 시키고 싶을 때 Affine트랜스폼 사용!!!
    // 그냥 180도 회전시키면 원점이 왼쪽 위에 있기 때문에 원래 위치가 아니라 왼쪽위로 가버린다.
    // 그래서 점을 오른쪽 아래로 이동시킨 후에 회전시킨다!!
    lowerRightCornerLable.transform = CGAffineTransform.identity
        .translatedBy(x: lowerRightCornerLable.frame.size.width, y: lowerRightCornerLable.frame.size.height)
        .rotated(by: CGFloat.pi)
    lowerRightCornerLable.frame.origin = CGPoint(x: bounds.maxX, y: bounds.maxY)    // 점부터 정하자! 오른쪽 아래가 기준점이 된다.
        .offsetBy(dx: -cornerOffset, dy: -cornerOffset) // 그냥두면 점 위치가 카드 왼쪽위가 되어 레이아웃 밖에 그려진다. 그래서 레이아웃(roundedRect) 안쪽으로 바꿔줬다!
        .offsetBy(dx: -lowerRightCornerLable.frame.size.width, dy: -lowerRightCornerLable.frame.size.height)
}
```

### traitCollectionDidChange

traitCollection(회전하는지, 가로모드인지 세로모드인지 폰트 크기 등)이 바꼈을 때 호출된다.

```swift
// 폰트 사이즈를 조정했으면, 우리도 바뀐 사실을 알아야 한다! (하지않으면 바로는 적용이 안되고 크기를 이동시켜봐야 함)
// 회전하는지, 가로모드인지 세로모드인지 폰트 크기와도 관련이 있고 이러한 것들이 바뀌었을 때 호출된다.
// 따라서 이런게 바뀌었을 때 다시 호출해주면 되지롱!
override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
    setNeedsDisplay()
    setNeedsLayout()
}
```

### @IBDesignable

코드의 내용을 interface builder에서 확인하고 싶을 때 사용한다. 뷰를 컴파일해서 인터페이스 빌더 화면에 놓는다.

이때 UIImage(named:) 의 이미지는 불러오지 못하는데, 

`UIImage(named: "cardback", in: Bundle(for: self.classForCoder), compatibleWith: traitCollection)` 다음과 같이 사용하면 named로 불러온 이미지도 확인할 수 있다.

### @IBInspectable

코드의 속성을 interface builder에 추가하고 싶을 때 사용한다. 이때는 속성을 명시적으로 지정해줘야 한다.

```swift
@IBInspectable
var rank: Int = 5 { didSet{ setNeedsDisplay(); setNeedsLayout() }}
@IBInspectable
var suit: String = "❤️" { didSet{ setNeedsDisplay(); setNeedsLayout() }}
@IBInspectable
var isFaceUp: Bool = true   { didSet{ setNeedsDisplay(); setNeedsLayout() }}
```

# Gesture

제스처의 처리가 모델에 영향을 받는거라면 controller가, 아니라면 view가 직접 처리한다.

### gesture 추가

주로 didSet을 사용한다.

```swift
@IBOutlet weak var pannableView: UIView {
	didSet {
		let panGestureRecognizer = UIPanGestureRecognizer(
			target: self, action: #selector(ViewController.pan(recognizer:))
		)
		pannableView.addGestureRecognizer(panGestureRecognizer)
	}
}
```

### gesture 처리

### PanGestureRecognizer

panGestureRecognizer같은 경우 3개의 메소드를 갖고 있다.

```swift
func translate(in: UIView?) -> CGRect // cumulative since start of recognition
func velocity(in: UIView?) -> CGFloat // how fast the finger is moving (points/s)
func setTranslation(CGPoint, in: UIView?)
// 해당 점을 기준으로 이동을 0으로 초기화한다. 
// 이동이 마지막으로 일어난 지점을 기준으로 해서 얼마나 움직였는지를 쉽게 얻을 수 있다.
```

상태 정보를 나타내는 변수도 제공한다.

`.began`, `.changed` , `.ended`

.failed : 다른 제스쳐가 더 우위를 점했을 때

.cancelled : 드래그앤드랍 할 때 잘 발생.

```swift
var state: UIGestureRecognizerState { get }
```

### UIPinchGestureRecognizer

```swift
var scale: CGFloat // not-read-only (can reset)
var velocity: CGFloat { get } // scale factor per second
```

### UIRotationGestureRecognizer

```swift
var rotation: CGFloat // not-read-only (can reset)
var velocity: CGFloat { get } // radians per second
```

### UISwipeGestureRecognizer

```swift
var direction: UISwipeGestureRecognizerDirection // which swipe directions you want
var numberOfTouchsRequired: Int // finger count
```

### UITapGestureRecognizer

```swift
var numberOfTapsRequired: Int // single tap, double tap, etc.
var numberOfTouchesRequired: Int // finger count
```

### UILongPressRecognizer

```swift
var minimumPressDuration: TimeInterval // how long to hold before its recognizer
var numberOfTouchesRequired: Int // finger count
var allowableMovement: CGFloat // how far finger can moved and still recognize
```
