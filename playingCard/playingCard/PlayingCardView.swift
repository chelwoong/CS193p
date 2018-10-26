//
//  PlayingCardView.swift
//  playingCard
//
//  Created by woong on 2018. 10. 19..
//  Copyright © 2018년 woong. All rights reserved.
//

import UIKit

@IBDesignable
class PlayingCardView: UIView {
    
    @IBInspectable  // 스토리보드 인스펙터에 추가
    // Model에서와는 타입이 완전히 다르다. 하지만 모델은 신경쓸 것 없다 여긴 뷰를 그리는 뷰만 담당하는 곳이니까!!!
    var rank: Int = 5 { didSet{ setNeedsDisplay(); setNeedsLayout() }}
        // 값이 바뀌면 새로 그려줘야 한다. 내가 직접 draw를 호출할 수 없으니 setNeedsDisplay()를 사용!!!
        // 뷰에서 멀어지는 서브뷰가 있으면 서브뷰가 서로 다시 배치해줘야 하니 setNeedsLayout() 사용!
    @IBInspectable
    var suit: String = "❤️" { didSet{ setNeedsDisplay(); setNeedsLayout() }}
    @IBInspectable
    var isFaceUp: Bool = true   { didSet{ setNeedsDisplay(); setNeedsLayout() }}
    
    var faceCardScale: CGFloat = SizeRatio.faceCardImageSizeToBoundsSize { didSet{setNeedsDisplay()}}
    
    @objc func adjustFaceCardScale(byHandlingGestureRecognizedBy recognizer: UIPinchGestureRecognizer) {
        switch recognizer.state {
        case .changed, .ended:
            faceCardScale *= recognizer.scale
            recognizer.scale = 1.0
        default:
            break
        }
    }
    
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
    
    private var cornerString: NSAttributedString {
        return centeredAttributedString(rankString+"\n"+suit, fontSize: cornerFontSize)
    }
    
    // MARK: -LAZY!!
    // 함수를 초기화하기 전까지는 함수를 사용할 수 없다. 그래서 사용하는 것이 lazy!!!!
    private lazy var upperLeftCornerLabel = createCornerLabel()
    private lazy var lowerRightCornerLable = createCornerLabel()
    
    // label 생성완료!
    private func createCornerLabel() -> UILabel {
        let label = UILabel()
        label.numberOfLines = 0 // 가능한 라인의 수. 0으로 두면 제한없이 사용가능
        addSubview(label)
        return label
    }
    
    func configureCornerLabel(_ label: UILabel) {
        label.attributedText = cornerString
        label.frame.size = CGSize.zero  // 너비가 바꼈을 때 sizeToFit()은 너비는 두고 높이면 바꾼다. 전체 크기를 조절하고 싶어서 사용!
        label.sizeToFit()
        label.isHidden = !isFaceUp
    }
    
    // 폰트 사이즈를 조정했으면, 우리도 바뀐 사실을 알아야 한다! (하지않으면 바로는 적용이 안되고 크기를 이동시켜봐야 함)
    // 회전하는지, 가로모드인지 세로모드인지 폰트 크기와도 관련이 있고 이러한 것들이 바뀌었을 때 호출된다.
    // 따라서 이런게 바뀌었을 때 다시 호출해주면 되지롱!
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        setNeedsDisplay()
        setNeedsLayout()
    }
    
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
    
    private func drawPips()
    {
        let pipsPerRowForRank = [[0],[1],[1,1],[1,1,1],[2,2],[2,1,2],[2,2,2],[2,1,2,2],[2,2,2,2],[2,2,1,2,2],[2,2,2,2,2]]
        
        func createPipString(thatFits pipRect: CGRect) -> NSAttributedString {
            let maxVerticalPipCount = CGFloat(pipsPerRowForRank.reduce(0) { max($1.count, $0) })
            let maxHorizontalPipCount = CGFloat(pipsPerRowForRank.reduce(0) { max($1.max() ?? 0, $0) })
            let verticalPipRowSpacing = pipRect.size.height / maxVerticalPipCount
            let attemptedPipString = centeredAttributedString(suit, fontSize: verticalPipRowSpacing)
            let probablyOkayPipStringFontSize = verticalPipRowSpacing / (attemptedPipString.size().height / verticalPipRowSpacing)
            let probablyOkayPipString = centeredAttributedString(suit, fontSize: probablyOkayPipStringFontSize)
            if probablyOkayPipString.size().width > pipRect.size.width / maxHorizontalPipCount {
                return centeredAttributedString(suit, fontSize: probablyOkayPipStringFontSize / (probablyOkayPipString.size().width / (pipRect.size.width / maxHorizontalPipCount)))
            } else {
                return probablyOkayPipString
            }
        }
        
        if pipsPerRowForRank.indices.contains(rank) {
            let pipsPerRow = pipsPerRowForRank[rank]
            var pipRect = bounds.insetBy(dx: cornerOffset, dy: cornerOffset).insetBy(dx: cornerString.size().width, dy: cornerString.size().height / 2)
            let pipString = createPipString(thatFits: pipRect)
            let pipRowSpacing = pipRect.size.height / CGFloat(pipsPerRow.count)
            pipRect.size.height = pipString.size().height
            pipRect.origin.y += (pipRowSpacing - pipRect.size.height) / 2
            for pipCount in pipsPerRow {
                switch pipCount {
                case 1:
                    pipString.draw(in: pipRect)
                case 2:
                    pipString.draw(in: pipRect.leftHalf)
                    pipString.draw(in: pipRect.rightHalf)
                default:
                    break
                }
                pipRect.origin.y += pipRowSpacing
            }
        }
    }

    override func draw(_ rect: CGRect) {
//        if let context = UIGraphicsGetCurrentContext() {
//            // 드로잉 경로
//            context.addArc(center: CGPoint(x: bounds.midX, y: bounds.midY), radius: 100.0, startAngle: 0, endAngle: 2*CGFloat.pi, clockwise: true)
//            context.setLineWidth(5.0)
//            UIColor.green.setFill()
//            UIColor.red.setStroke()
//            context.strokePath()
//            context.fillPath()
//        }
        
            // UIBezierPath 를 사용해 그려보기!
//        let path = UIBezierPath()
//        path.addArc(withCenter: CGPoint(x: bounds.midX, y: bounds.midY), radius: 100.0, startAngle: 0, endAngle: 2*CGFloat.pi, clockwise: true)
//        path.lineWidth = 5.0
//        UIColor.green.setFill()
//        UIColor.red.setStroke()
//        path.stroke()
//        path.fill()
        
        // 둥근 사각형을 위해 UIBezierPath를 사용해 바로 그려보기. roundedRect생성자를 사용.
        let roundedRect = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius)
        // 테두리 안쪽만 사용하기 위해 오려내기. 안쪽에서만 드로잉 될 것이다.
        roundedRect.addClip()
        UIColor.white.setFill()
        roundedRect.fill()
        
        if isFaceUp {
            if let faceCardImage = UIImage(named: rankString+suit, in: Bundle(for: self.classForCoder), compatibleWith: traitCollection) {
                faceCardImage.draw(in: bounds.zoom(by: faceCardScale))
            } else {
                drawPips()
            }
        } else {
            if let cardBackImage = UIImage(named: "cardback", in: Bundle(for: self.classForCoder), compatibleWith: traitCollection) {
                cardBackImage.draw(in: bounds)  // 뒷면은 겹칠게 없으니 그냥 이걸로해도 된다
            }
        }
        
        
    }
}

extension PlayingCardView {
    private struct SizeRatio {
        static let cornerFontSizeToBoundsHeight: CGFloat = 0.085
        static let cornerRadiusToBoundHeight: CGFloat = 0.06
        static let cornerOffsetToCornerRadius: CGFloat = 0.33
        static let faceCardImageSizeToBoundsSize: CGFloat = 0.75
    }
    private var cornerRadius: CGFloat {
        return bounds.size.height * SizeRatio.cornerRadiusToBoundHeight
    }
    private var cornerOffset: CGFloat {
        return cornerRadius * SizeRatio.cornerOffsetToCornerRadius
    }
    private var cornerFontSize: CGFloat {
        return bounds.size.height * SizeRatio.cornerFontSizeToBoundsHeight
    }
    private var rankString: String {
        switch rank {
        case 1: return "A"
        case 2...10: return String(rank)
        case 11: return "J"
        case 12: return "Q"
        case 13: return "K"
        default: return "?"
        }
    }
}

extension CGRect {
    var leftHalf: CGRect {
        return CGRect(x: minX, y:minY, width: width/2, height: height)
    }
    var rightHalf: CGRect {
        return CGRect(x: midX, y:minY, width: width/2, height: height)
    }
    func inset(by size: CGSize) -> CGRect {
        return insetBy(dx: size.width, dy: size.height)
    }
    func size(to size: CGSize) -> CGRect {
        return CGRect(origin: origin, size: size)
    }
    func zoom(by scale: CGFloat) ->  CGRect {
        let newWidth = width * scale
        let newHeight = height * scale
        return insetBy(dx: (width - newWidth), dy: (height - newHeight) / 2)
    }
}

extension CGPoint {
    func offsetBy(dx: CGFloat, dy: CGFloat) -> CGPoint {
        return CGPoint(x: x+dx, y: y+dy)
    }
}
