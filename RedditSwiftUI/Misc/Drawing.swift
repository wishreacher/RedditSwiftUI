//
//  Drawing.swift
//  RedditSwiftUI
//
//  Created by Володимир on 28.04.2025.
//

import Foundation
import UIKit

struct Drawing {
    static func drawBookmark(in view: UIView) {
        let width: CGFloat = 50
        let height: CGFloat = 80

        view.layer.sublayers?.forEach { $0.removeFromSuperlayer() }

        let path = UIBezierPath()

        path.move(to: CGPoint(x: view.frame.midX - width / 2,
                              y: (view.frame.midY / 2)))
        path.addLine(to: CGPoint(x: view.frame.midX + width / 2,
                                 y: (view.frame.midY / 2)))
        path.addLine(to: CGPoint(x: view.frame.midX + width / 2,
                                 y: (view.frame.midY / 2) + height))
        path.addLine(to: CGPoint(x: view.frame.midX,
                                 y: (view.frame.midY / 2) + height * 0.7))
        path.addLine(to: CGPoint(x: view.frame.midX - width / 2,
                                 y: (view.frame.midY / 2) + height))
        path.close()

        let shapeLayer = CAShapeLayer()
        shapeLayer.path = path.cgPath
        shapeLayer.strokeColor = UIColor.black.cgColor
        shapeLayer.fillColor = UIColor(red: 0 / 255, green: 122 / 255, blue: 255 / 255, alpha: 1).cgColor
        shapeLayer.lineWidth = 1
        
        shapeLayer.cornerRadius = 10
        shapeLayer.cornerCurve = .continuous

        view.layer.addSublayer(shapeLayer)
    }
}
