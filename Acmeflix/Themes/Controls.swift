//
//  BaseView.swift
//  Acmeflix
//
//  Created by Manish Katoch on 06/08/19.
//  Copyright © 2019 Manish Katoch. All rights reserved.
//

import Foundation
import UIKit
import Cosmos

class BaseView: UIView {}
class FailureLabel: UILabel {}
class InfoLabel: UILabel {}

class AppearanceProperties: NSObject {
    var cornerRadius : CGFloat?
    var borderWidth : CGFloat?
    var borderColor: UIColor?
    var backgroundColor: UIColor?
    var font: UIFont?
    var tintColor: UIColor?
}

@IBDesignable class StarControlView: CosmosView {
    
    var disabled: Bool = false {
        didSet {
            layoutSubviews()
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.settings.fillMode = .precise
        self.settings.emptyBorderColor = .yellow
        self.settings.filledBorderColor = .yellow
        self.settings.filledColor = .yellow
        self.settings.minTouchRating = 0.1
    }
}


@IBDesignable open class AcmeButton: UIButton {
    
    private var _enabledButtonProperties: AppearanceProperties? {
        didSet {
            layoutSubviews()
        }
    }
    private var _disabledButtonProperties: AppearanceProperties? {
        didSet {
            layoutSubviews()
        }
    }
    
    @objc dynamic var enabledProperties: AppearanceProperties? {
        get { return _enabledButtonProperties }
        set {
            _enabledButtonProperties = newValue
        }
    }
    @objc dynamic var disabledProperties: AppearanceProperties? {
        get { return _disabledButtonProperties }
        set {
            _disabledButtonProperties = newValue
        }
    }
    
    @IBInspectable open var disabled: Bool = false {
        didSet {
            self.disabled = true
            layoutSubviews()
        }
    }
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        if disabled {
            applyProperties(_disabledButtonProperties)
        } else {
            applyProperties(_enabledButtonProperties)
        }
        
    }
    
    func applyProperties(_ buttonProperties: AppearanceProperties?) {
        if let propsUnwrapped = buttonProperties {
            self.layer.cornerRadius = propsUnwrapped.cornerRadius ?? 0.0
            self.layer.borderWidth = propsUnwrapped.borderWidth ?? 0.0
            self.titleLabel?.font = propsUnwrapped.font
            self.layer.borderColor = propsUnwrapped.borderColor?.cgColor
            self.backgroundColor = propsUnwrapped.backgroundColor
            self.tintColor = propsUnwrapped.tintColor
            self.contentEdgeInsets = UIEdgeInsets.init(top: 5, left: 7, bottom: 5, right: 7)
        }
    }
}
