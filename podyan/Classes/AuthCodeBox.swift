//
//  AuthCodeBox.swift
//  NovaDAX
//
//  Created by Peixue Yan on 2022/7/26.
//

import UIKit
import Foundation

class AuthCodeBox: UIView {
    
    var splashLayer: CAShapeLayer?
    var numLabel: UILabel?
    var active: Bool = false
    var index : Int  = 0
    
    init() {
        super.init(frame: .zero)
        
        initUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initUI() {
        numLabel = UILabel()
        numLabel?.textColor = .darkText
        numLabel?.font = .boldSystemFont(ofSize: 18)
        numLabel?.textAlignment = .center
        self.addSubview(numLabel!)
        
        numLabel?.snp.makeConstraints { make in
            make.edges.equalTo(self)
        }
        
        splashLayer = CAShapeLayer()
        splashLayer?.fillColor = UIColor.darkText.cgColor
        splashLayer?.opacity = 1.0
        splashLayer?.isHidden = true
        self.layer.addSublayer(splashLayer!)
        
        splashLayer?.add(flashAnimation(), forKey: "opacity")
    }
    
    func setSplashHidden(_ hidden: Bool) {
        splashLayer?.isHidden = hidden
    }
    
    func setText(_ text: String) {
        numLabel?.text = text
    }
    
    func flashAnimation() -> CABasicAnimation {
        let animation = CABasicAnimation(keyPath: "opacity")
        animation.fromValue = 1.0
        animation.toValue = 0.0
        animation.duration = 0.8
        animation.repeatCount = HUGE
        animation.isRemovedOnCompletion = false
//        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName(string: "easeInEaseOut") as String)
        return animation
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        var rect = self.frame
        rect.origin.x = frame.width / 2
        rect.origin.y = (self.frame.width - 16)/2
        rect.size.width = 1.5
        rect.size.height = 16
        let path = UIBezierPath(rect: rect)
        splashLayer?.path = path.cgPath
    }
}
