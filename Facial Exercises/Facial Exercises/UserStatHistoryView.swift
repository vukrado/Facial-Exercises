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
    
    override public func draw(_ rect: CGRect) {
        let path = UIBezierPath()
        if let first = userRecords.first {
            path.move(to: point(for: first))
        }
        for exchangeRate in userRecords.dropFirst() {
            path.addLine(to: point(for: exchangeRate))
        }
        
        UIColor.cyan.set()
        path.lineWidth = 5
        path.stroke()
    }
    
    private func point(for exchangeRate: UserRecord) -> CGPoint {
        
        let calendar = Calendar.current
        
        guard let minDate = userRecords.first?.date,
            let maxDate = userRecords.last?.date,
            let minRate = userRecords.min(by: { $0.highScore < $1.highScore })?.highScore,
            let maxRate = userRecords.max(by: { $0.highScore < $1.highScore })?.highScore,
            let numDays = calendar.dateComponents([.day], from: minDate, to: maxDate).day,
            maxDate != minDate,
            minRate != maxRate else {
                return .zero
        }
        
        let rateRange = maxRate - minRate
        let rateStep = bounds.height / CGFloat(rateRange)
        let dayStep = bounds.width / CGFloat(numDays)
        
        let yPosition = bounds.maxY - rateStep * CGFloat(exchangeRate.highScore - minRate)
        guard let daysSinceBeginning = calendar.dateComponents([.day], from: minDate, to: exchangeRate.date).day else { return .zero }
        let xPosition = bounds.minX + CGFloat(daysSinceBeginning) * dayStep
        return CGPoint(x: xPosition, y: yPosition)
    }
    
    var userRecords : [UserRecord] = [] {
        didSet {
            self.userRecords = userRecords.sorted { $0.date < $1.date }
            setNeedsDisplay(bounds)
        }
    }
}

// To be deleted -- Just for testing purposes
func generateRandomDate(daysBack: Int)-> Date?{
    let day = arc4random_uniform(UInt32(daysBack))+1
    let hour = arc4random_uniform(23)
    let minute = arc4random_uniform(59)
    
    let today = Date(timeIntervalSinceNow: 0)
    let gregorian  = NSCalendar(calendarIdentifier: NSCalendar.Identifier.gregorian)
    var offsetComponents = DateComponents()
    offsetComponents.day = Int(day - 1)
    offsetComponents.hour = Int(hour)
    offsetComponents.minute = Int(minute)
    
    let randomDate = gregorian?.date(byAdding: offsetComponents, to: today, options: .init(rawValue: 0) )
    return randomDate
}

class VC: UIViewController {
    
    let graph : UserStatHistoryView = {
        let graph = UserStatHistoryView()
        graph.userRecords = [UserRecord(date: generateRandomDate(daysBack: 10)!, highScore: 0.0),
                             UserRecord(date: generateRandomDate(daysBack: 10)!, highScore: 10.0),
                             UserRecord(date: generateRandomDate(daysBack: 10)!, highScore: 3.0),
                             UserRecord(date: generateRandomDate(daysBack: 10)!, highScore: 15.0)]
        return graph
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        view.addSubview(graph)
        graph.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.safeAreaLayoutGuide.leadingAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: view.safeAreaLayoutGuide.trailingAnchor)
    }
}
