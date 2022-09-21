//
//  AuthCodeInput.swift
//  NovaDAX
//
//  Created by Peixue Yan on 2022/7/26.
//

import UIKit
import SnapKit

class AuthCodeInput: UIView {

    var itemSpace: CGFloat = 14.2
    
    var textField: AuthCodeTextField?
    var currentBox: AuthCodeBox?
    var overFlow: UIView?
    
    /// 验证码位数
    var codeLength: Int = 6
    var boxs: [AuthCodeBox] = []
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = .white
        initUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initUI() {
        textField = AuthCodeTextField()
        textField?.keyboardType = .numberPad
        textField?.font = .boldSystemFont(ofSize: 18)
        textField?.delegate = self
        textField?.addTarget(self, action: #selector(authCodeDidStartInput(tf:)), for: .editingChanged)
        self.addSubview(textField!)
        
        textField?.snp.makeConstraints({ make in
            make.edges.equalTo(self)
        })
        
        overFlow = UIView()
        overFlow?.backgroundColor = .white
        overFlow?.isUserInteractionEnabled = false
        self.addSubview(overFlow!)
        
        overFlow?.snp.makeConstraints({ make in
            make.edges.equalTo(self)
        })

        for index in 0..<codeLength {
            let box = AuthCodeBox()
            box.layer.borderColor = UIColor.lightGray.cgColor
            box.layer.borderWidth = 1
            box.layer.cornerRadius = 8
            box.layer.masksToBounds = true
            box.active = (index == 0)
            box.index = index
            self.addSubview(box)
            self.boxs.append(box)
            
            box.snp.makeConstraints { make in
                make.left.equalTo(self).offset(0)
                make.top.equalTo(self)
                make.size.equalTo(CGSize.zero)
                if index == 0 {
                    make.bottom.equalTo(self)
                }
            }
        }
    }
    
    @objc func authCodeDidStartInput(tf: UITextField) {
        
        guard let text = tf.text else { return }
        if text.count > codeLength {
            self.textField?.text = (text as NSString).substring(with: NSRange(location: 0, length: codeLength))
            return
        }
        
        for (index, box) in boxs.enumerated() {
            box.setSplashHidden(index != text.count)
            box.layer.borderColor = index == text.count ? UIColor.blue.cgColor : UIColor.lightGray.cgColor
            
            if index >= text.count {
                box.setText("")
            } else {
                box.setText((text as NSString).substring(with: NSRange(location: index, length: 1)))
            }

            box.active = ((text.count >= codeLength - 1) ? codeLength - 1 : text.count) == index
        }
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        
        let allSpace = itemSpace * CGFloat(codeLength - 1)
        let boxWidth = (self.frame.width - allSpace) / CGFloat(codeLength)
        for (index, box) in boxs.enumerated() {
            box.snp.updateConstraints { make in
                make.left.equalTo(self).offset( (itemSpace + boxWidth) * CGFloat(index))
                make.size.equalTo(CGSize(width: boxWidth, height: boxWidth))
            }
        }
    }
}

extension AuthCodeInput: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        guard let box = boxs.first(where: { $0.active && $0.index < codeLength - 1}) else {
            return
        }
        box.setSplashHidden(false)
        box.layer.borderColor = UIColor.blue.cgColor
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        let box = boxs.first { box in
            return box.active
        }
        box?.setSplashHidden(true)
        box?.layer.borderColor = UIColor.lightGray.cgColor
    }
}
