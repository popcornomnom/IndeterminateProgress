//
//  IndeterminateProgressView.swift
//  IndeterminateProgress
//
//  Created by Marharyta Lytvynenko on 24.09.2019.
//  http://www.popcornomnom.com
//  Copyright © 2019 damnLekker. All rights reserved.
//

import UIKit

@IBDesignable
final class IndeterminateProgressView: UIView {
    
    //MARK: - Properties
    //MARK: Private
    
    private let positionKeyPath = "position"
    private let widthKeyPath = "bounds.size.width"
    
    private lazy var progress: CALayer = {
        let progress = CALayer()
        progress.frame = CGRect(x: 0, y: 0, width: progressWidth, height: frame.height)
        progress.backgroundColor = progressBackgroundColor.cgColor
        return progress
    }()
    
    //MARK: Public
    
    enum `Type`: Int {
        case slideThrough = 0, pinPong
    }
    
    var type: Type = .pinPong {
        didSet { setNeedsLayout() }
    }
    
    @IBInspectable var typeValue: Int {
        set { type = Type(rawValue: newValue) ?? .pinPong }
        get { return type.rawValue }
    }
    
    @IBInspectable var progressBackgroundColor: UIColor = .black {
        didSet {
            UIView.animate(withDuration: animationDuration) { [unowned self] in
                self.progress.backgroundColor = self.progressBackgroundColor.cgColor
            }
        }
    }
    @IBInspectable var extendMuptiplier: CGFloat = 2 {
        didSet { setNeedsLayout() }
    }
    @IBInspectable var progressWidth: CGFloat = 64 {
        didSet {
            progress.frame.size.width = progressWidth
            setNeedsLayout()
        }
    }
    @IBInspectable var animationDuration: TimeInterval = 1.5 {
        didSet { setNeedsLayout() }
    }
    
    override var bounds: CGRect {
        didSet {
            if oldValue.height != bounds.height {
                progress.frame.size.height = bounds.height
            }
            setNeedsLayout()
        }
    }
    
    //MARK: - Lifecycle
    
    override func layoutSubviews() {
        startAnimation()
    }
    
    deinit {
        #if DEBUG
        print("\(String(describing: IndeterminateProgressView.self)) is deinited")
        #endif
    }
    
    //MARK: - Setup
    
    private func setup() {
        backgroundColor = backgroundColor ?? .white
        layer.cornerRadius = frame.height / 2
        progress.cornerRadius = frame.height / 2
        clipsToBounds = true
        layer.addSublayer(progress)
    }
    
    //MARK: Animation
    
    private func animate() {
        func addPositionAnimation() {
            let animation = CABasicAnimation(keyPath: positionKeyPath)
            switch type {
            case .pinPong:
                animation.fromValue = progress.position
                animation.toValue = CGPoint(x: frame.width - (progress.frame.width / 2),
                                            y: progress.position.y)
                animation.autoreverses = true
            case .slideThrough:
                animation.fromValue = CGPoint(x: -progressWidth, y: progress.position.y)
                animation.toValue = CGPoint(x: frame.width + progressWidth, y: progress.position.y)
            }
            animation.duration = animationDuration
            animation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
            animation.repeatCount = .infinity
            progress.add(animation, forKey: positionKeyPath)
        }
        
        func addWidthAnimation() {
            guard extendMuptiplier != 1 else { return }
                let widthAnimation = CABasicAnimation(keyPath: widthKeyPath)
                widthAnimation.duration = animationDuration / 2
                widthAnimation.timingFunction = CAMediaTimingFunction(name: .easeIn)
                widthAnimation.fromValue = progress.frame.width
                widthAnimation.toValue = progress.frame.width * extendMuptiplier
                widthAnimation.autoreverses = true
                widthAnimation.repeatCount = .infinity
                progress.add(widthAnimation, forKey: widthKeyPath)
        }

        CATransaction.begin()
        CATransaction.setCompletionBlock {
        }
        addPositionAnimation()
        addWidthAnimation()
        CATransaction.commit()
    }
    
    func startAnimation() {
        setup()
        animate()
    }
    
    func stopAnimation() {
        progress.removeAllAnimations()
    }
    
    func removeFromSuperviewAnimated() {
        UIView.animate(withDuration: 0.25, animations: { [weak self] in
            self?.alpha = 0
        }) { [weak self] _ in
            self?.removeFromSuperview()
        }
    }
}
