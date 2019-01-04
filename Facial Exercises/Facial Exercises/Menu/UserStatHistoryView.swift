//
//  UserStatHistoryView.swift
//  Facial Exercises
//
//  Created by Samantha Gatt on 1/3/19.
//  Copyright © 2019 Vuk Radosavljevic. All rights reserved.
//

import UIKit

/// User stats model
struct UserRecord {
    let date: Date
    let highScore: Float
}

public class UserStatHistoryView: UIView {
    
    var userRecords : [UserRecord] = [] {
        didSet {
            self.userRecords = userRecords.sorted { $0.date < $1.date }
            setNeedsDisplay(bounds)
            //drawChart()
        }
    }
    let path = UIBezierPath()
    var shapeLayer: CAShapeLayer?
    
    override public func draw(_ rect: CGRect) {
        if let first = userRecords.first {
            path.move(to: point(for: first, index: 0))
        }
        for (index, userRecord) in userRecords.dropFirst().enumerated() {
            path.addLine(to: point(for: userRecord, index: index + 1))
        }

        UIColor.cyan.set()
        path.lineWidth = 5
        path.stroke()
    }
    
    private func drawChart() {
        self.shapeLayer?.removeFromSuperlayer()
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.fillColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0).cgColor
        shapeLayer.strokeColor = UIColor.cyan.cgColor
        shapeLayer.lineWidth = 5
        shapeLayer.path = path.cgPath
        
        layer.addSublayer(shapeLayer)
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.fromValue = 0
        animation.duration = 1.5
        shapeLayer.add(animation, forKey: "chartAnimation")
        
        self.shapeLayer = shapeLayer
    }
    
    private func point(for user: UserRecord, index: Int) -> CGPoint {
        
        let numUserRecords = userRecords.count
        
        guard let minScore = userRecords.min(by: { $0.highScore < $1.highScore })?.highScore,
            let maxScore = userRecords.max(by: { $0.highScore < $1.highScore })?.highScore else {
                return .zero
        }
        
        let scoreRange = (maxScore + 0.001) - (minScore - 0.001)
        let scoreStep = bounds.height / CGFloat(scoreRange)
        let userRecordStep = bounds.width / CGFloat(numUserRecords)
        
        let yPosition = bounds.maxY - scoreStep * CGFloat(user.highScore - minScore)
        let xPosition = bounds.minX + CGFloat(index) * userRecordStep
        return CGPoint(x: xPosition, y: yPosition)
    }
}

