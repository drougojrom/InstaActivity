//
//  InstaActivity.swift
//  InstaActivity
//
//  Created by Roman Ustiantcev on 06/04/2017.
//  Copyright © 2017 Roman Ustiantcev. All rights reserved.
//

import UIKit
import QuartzCore

protocol InstaActivityProtocol {
    // segment's animation duration
    var animationDuration: Double {get set}
    
    // indicator animation duration
    var rotationDuration: Double {get set}
    
    // the number of segments in indicator
    var segmentsNumber: Int {get set}
    
    // stroke color of indicator segments
    var strokeColor: UIColor? {get set}
    
    // line width of indicator segments
    var lineWidth: CGFloat {get set}
    
    // is hidden when animation stoppes
    var hideWhenStopped: Bool {get set}
    
    // is indicator animating or not
    var isAnimating: Bool {get set}
    
    // the layer that replicates segments
    var replicationLayer: CAReplicatorLayer! {get set}
    
    // visual layer that replicates around the indicator
    var segmentLayer: CAShapeLayer! {get set}
    
    
    func startAnimation()
    func stopAnimation()
}

@IBDesignable
class InstaActivity: UIView, InstaActivityProtocol {
    
    @IBInspectable public var animationDuration: Double = 1
    @IBInspectable public var rotationDuration: Double = 10
    @IBInspectable public var segmentsNumber: Int = 11 {
        didSet {
            updateSegments()
        }
    }
    @IBInspectable public var strokeColor: UIColor? = .green {
        didSet {
            segmentLayer.strokeColor = strokeColor?.cgColor
        }
    }
    @IBInspectable public var lineWidth: CGFloat = 8 {
        didSet {
            segmentLayer.lineWidth = lineWidth
            updateSegments()
        }
    }
    @IBInspectable public var hideWhenStopped: Bool = true
    @IBInspectable public var isAnimating: Bool = true
    
    var replicationLayer: CAReplicatorLayer!
    var segmentLayer: CAShapeLayer!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    
    func setupView() {
        // create and add the replicator layer
        
        let replicatorLayer = CAReplicatorLayer()
        self.layer.addSublayer(replicatorLayer)
        
        // configure the shape layer that gets replicated
        let dot = CAShapeLayer()
        dot.lineCap = kCALineCapRound
        dot.strokeColor = self.strokeColor?.cgColor
        dot.lineWidth = self.lineWidth
        dot.fillColor = nil
        replicatorLayer.addSublayer(dot)
        
        self.replicationLayer = replicatorLayer
        self.segmentLayer = dot
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let maxSize = max(0,min(bounds.width, bounds.height))
        replicationLayer?.bounds = CGRect(x: 0, y: 0, width: CGFloat(maxSize), height: CGFloat(maxSize))
        replicationLayer?.position = CGPoint(x: bounds.width / 2, y: bounds.height / 2)
        updateSegments()
    }
    
    func updateSegments() {
        if segmentsNumber > 0 {
            let angle = 2 * CGFloat.pi / CGFloat(segmentsNumber)
            replicationLayer?.instanceCount = segmentsNumber
            replicationLayer?.instanceTransform = CATransform3DMakeRotation(angle, 0.0, 0.0, 1.0)
            replicationLayer?.instanceDelay = 1.5 * animationDuration / Double(segmentsNumber)
            
            let maxRadius = max(0,min(replicationLayer.bounds.width, replicationLayer.bounds.height))/2
            let radius: CGFloat = maxRadius - lineWidth/2
            segmentLayer?.bounds = CGRect(x: 0, y: 0, width: 2 * maxRadius, height: 2 * maxRadius)
            segmentLayer?.position = CGPoint(x: (replicationLayer?.bounds.width)!/2, y: (replicationLayer?.bounds.height)! / 2)
            let path = UIBezierPath(arcCenter: CGPoint(x: maxRadius, y: maxRadius), radius: radius, startAngle: -angle/2 - CGFloat.pi/2, endAngle: angle/2 - CGFloat.pi/2, clockwise: true)
            
            segmentLayer.path = path.cgPath
        }
    }
    
    func startAnimation() {
        self.isHidden = false
        isAnimating = true
        
        let rotate = CABasicAnimation(keyPath: "transform.rotation")
        rotate.byValue = CGFloat.pi * 2
        rotate.duration = rotationDuration
        rotate.repeatCount = Float.infinity
        
        
        // add animations to segment
        // multiplying duration changes the time of empty or hidden segments
        let shrinkStart = CABasicAnimation(keyPath:"strokeStart")
        shrinkStart.fromValue = 0.0
        shrinkStart.toValue = 0.5
        shrinkStart.duration = animationDuration // * 1.5
        shrinkStart.autoreverses = true
        shrinkStart.repeatCount = Float.infinity
        shrinkStart.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        
        
        let shrinkEnd = CABasicAnimation(keyPath:"strokeEnd")
        shrinkEnd.fromValue = 1.0
        shrinkEnd.toValue = 0.5
        shrinkEnd.duration = animationDuration // * 1.5
        shrinkEnd.autoreverses = true
        shrinkEnd.repeatCount = Float.infinity
        shrinkEnd.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        
        
        let fade = CABasicAnimation(keyPath:"lineWidth")
        fade.fromValue = lineWidth
        fade.toValue = 0.0
        fade.duration = animationDuration // * 1.5
        fade.autoreverses = true;
        fade.repeatCount = Float.infinity;
        fade.timingFunction = CAMediaTimingFunction(controlPoints: 0.55, 0.0, 0.45, 10)

        replicationLayer?.add(rotate, forKey: "rotate")
        segmentLayer?.add(shrinkStart, forKey: "start")
        segmentLayer?.add(shrinkEnd, forKey: "end")
        segmentLayer?.add(fade, forKey: "fade")
    }
    
    func stopAnimation() {
        isAnimating = false
        replicationLayer?.removeAllAnimations()
        segmentLayer.removeAllAnimations()
        if hideWhenStopped {
            isHidden = true
        }
    }
    
    public override var intrinsicContentSize: CGSize {
        return CGSize(width: 180, height: 180)
    }
}
