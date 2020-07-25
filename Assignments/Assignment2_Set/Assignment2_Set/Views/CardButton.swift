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
            guard let card = card else { return }
            layer.borderWidth = borderWidth
            layer.borderColor = borderColor.cgColor
        }
    }
    
    private var shapeSize: CGSize {
        guard let card = card else { return .zero }
        switch card.shapeCount {
            case .one:
                return CGSize(width: bounds.height * 0.5, height: bounds.height * 0.5)
            case .two:
                return CGSize(width: bounds.height * 0.4, height: bounds.height * 0.4)
            case .three:
                return CGSize(width: bounds.height * 0.3, height: bounds.height * 0.3)
        }
    }
    
    private var shapeSpace: CGFloat {
        return 2
    }
    
    private var borderWidth: CGFloat {
        guard let card = card else { return 0.5 }
        if !card.onGame {
            return 0
        }
        
        if card.isMatched {
            return 2
        } else if card.isSelected {
            return 2
        } else {
            return 0.5
        }
    }
    
    private var borderColor: UIColor {
        guard let card = card else { return .brown }
        if card.isMatched {
            return .systemGreen
        } else if card.isSelected {
            return .systemRed
        } else {
            return .gray
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
    
    private func drawPath(of card: Card, to rect: CGRect) -> UIBezierPath {
        var path = UIBezierPath()
        switch card.shape {
            case .circle:
                var center = CGPoint(x: rect.midX, y: rect.midY - shapeSize.height)
                if card.shapeCount == .two {
                    center.y -= shapeSize.height * 0.5
                } else if card.shapeCount == .three {
                    center.y -= shapeSize.height
                }
                
                for order in 1...card.shapeCount.rawValue {
                    center.y += shapeSize.height
                    if order != 1 {
                        center.y += shapeSpace
                    }
                    path.move(to: CGPoint(x: center.x + (shapeSize.width*0.5), y: center.y))
                    path.addArc(withCenter: center, radius: shapeSize.height/2, startAngle: 0, endAngle: .pi*2, clockwise: true)
                    
                }
            case .rectangle:
                let originX = rect.midX - (shapeSize.width * 0.5)
                var originY = rect.midY - (shapeSize.height * 0.5)
                if card.shapeCount == .two {
                    originY = rect.midY - (shapeSize.height + (shapeSpace*0.5))
                } else if card.shapeCount == .three {
                    originY = rect.midY - (shapeSize.height * 1.5)
                }
                
                for order in 1...card.shapeCount.rawValue {
                    if order != 1 {
                        originY += shapeSize.height + shapeSpace
                    }
                    drawRectangle(origin: CGPoint(x: originX, y: originY), path: &path)
                }
            case .triangle:
                let originX = rect.midX
                var originY = rect.midY - (shapeSize.height * 0.5)
                if card.shapeCount == .two {
                    originY = rect.midY - (shapeSize.height + (shapeSpace*0.5))
                } else if card.shapeCount == .three {
                    originY = rect.midY - (shapeSize.height * 1.5)
                }
                
                for order in 1...card.shapeCount.rawValue {
                    if order != 1 {
                        originY += shapeSize.height + shapeSpace
                    }
                    drawTriangle(origin: CGPoint(x: originX, y: originY), path: &path)
                }
        }
        return path
    }
    
    private func drawRectangle(origin: CGPoint, path: inout UIBezierPath) {
        path.move(to: CGPoint(x: origin.x, y: origin.y))
        path.addLine(to: CGPoint(x: origin.x + shapeSize.width, y: origin.y))
        path.addLine(to: CGPoint(x: origin.x + shapeSize.width, y: origin.y + shapeSize.height))
        path.addLine(to: CGPoint(x: origin.x, y: origin.y + shapeSize.height))
        path.close()
    }
    
    private func drawTriangle(origin: CGPoint, path: inout UIBezierPath) {
        path.move(to: CGPoint(x: origin.x, y: origin.y))
        path.addLine(to: CGPoint(x: origin.x - (shapeSize.width*0.5), y: origin.y + shapeSize.height))
        path.addLine(to: CGPoint(x: origin.x + (shapeSize.width*0.5), y: origin.y + shapeSize.height))
        path.close()
    }

    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        guard let card = card else { return }
        let path = drawPath(of: card, to: rect)
        
        switch card.pattern {
            case .empty:
                color.setStroke()
                path.stroke()
            case .fill:
                color.setFill()
                path.fill()
            case .dashed:
                color.setStroke()
                let dashes: [ CGFloat ] = [ 5.0 ]
                path.setLineDash(dashes, count: dashes.count, phase: 0)
                path.stroke()
        }
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        layer.cornerRadius = 5
    }

}
