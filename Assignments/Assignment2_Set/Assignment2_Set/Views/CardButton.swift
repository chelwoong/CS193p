//
//  CardButton.swift
//  Assignment2_Set
//
//  Created by woong on 2020/07/21.
//  Copyright © 2020 woong. All rights reserved.
//

import UIKit

class CardButton: UIButton {
    
    var card: Card? {
        didSet {
            
        }
    }
    
    private var shapeSize: CGSize {
        guard let card = card else { return .zero }
        switch card.shapeCount {
            case .one:
                return CGSize(width: bounds.width * 0.5, height: bounds.height * 0.5)
            case .two:
                return CGSize(width: bounds.width * 0.3, height: bounds.height * 0.4)
            case .three:
                return CGSize(width: bounds.width * 0.5, height: bounds.height * 0.3)
        }
    }
    
    private var color: UIColor {
        guard let card = card else { return .brown }
        switch card.color {
            case .green: return .green
            case .blue: return .blue
            case .red: return .red
        }
    }
    
    func drawPath(of card: Card, to rect: CGRect) -> UIBezierPath {
        let path = UIBezierPath()
        switch card.shape {
            case .circle:
                var center = CGPoint(x: rect.midX, y: rect.midY - shapeSize.height)
                if card.shapeCount == .two {
                    center.y -= shapeSize.height * 0.5
                } else if card.shapeCount == .three {
                    center.y -= shapeSize.height
                }
                
                for _ in 1...card.shapeCount.rawValue {
                    center.y += shapeSize.height
                    path.addArc(withCenter: center, radius: shapeSize.height/2, startAngle: 0, endAngle: .pi*2, clockwise: true)
                }
            case .rectangle:
                path.move(to: CGPoint(x: rect.midX - (shapeSize.width*0.5), y: rect.midY - (shapeSize.height*0.5)))
                path.addLine(to: CGPoint(x: rect.midX + (shapeSize.width*0.5), y: rect.midY - (shapeSize.height*0.5)))
                path.addLine(to: CGPoint(x: rect.midX + (shapeSize.width*0.5), y: rect.midY + (shapeSize.height*0.5)))
                path.addLine(to: CGPoint(x: rect.midX - (shapeSize.width*0.5), y: rect.midY + (shapeSize.height*0.5)))
                path.close()
            case .triangle:
                path.move(to: CGPoint(x: rect.midX, y: rect.midY - (shapeSize.width*0.5)))
                path.addLine(to: CGPoint(x: rect.midX - (shapeSize.width * 0.5), y: rect.midY + (shapeSize.height * 0.5)))
                path.addLine(to: CGPoint(x: rect.midX + (shapeSize.width * 0.5), y: rect.midY + (shapeSize.height * 0.5)))
                path.close()
        }
        return path
    }

    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        
        guard let card = card else { return }
        let path = drawPath(of: card, to: rect)
        color.setFill()
        path.fill()
        
        
//        let borderPath = UIBezierPath(rect: rect)
//        borderPath.lineWidth = 1
//        UIColor.black.setStroke()
//        borderPath.stroke()
//        print(path, borderPath)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

}
