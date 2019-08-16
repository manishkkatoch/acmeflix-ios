//
//  Theming.swift
//  Acmeflix
//
//  Created by Manish Katoch on 06/08/19.
//  Copyright © 2019 Manish Katoch. All rights reserved.
//

import Foundation
import UIKit
import Cosmos

protocol Theming {
    var tintColor: UIColor {get}
    var disabledColor: UIColor {get}
    var primaryButtonColor: UIColor {get}
    var backgroundColor: UIColor {get}
    var textColor: UIColor {get}
}


extension Theming {
    func apply(for application: UIApplication) {
        let textFont = UIFont.init(name: "HelveticaNeue-Light", size: 17.0)
        let headerFont = UIFont.init(name: "HelveticaNeue-CondensedBlack", size: 22.0)
        
        application.keyWindow?.tintColor = tintColor
        UIView.appearance().tintColor = tintColor
        
        BaseView.appearance().backgroundColor = backgroundColor
        
        
        let enabledButtonProps = AppearanceProperties()
        enabledButtonProps.cornerRadius = 5
        enabledButtonProps.borderWidth = 1
        enabledButtonProps.borderColor = tintColor
        enabledButtonProps.font = textFont
        enabledButtonProps.backgroundColor = backgroundColor
        
        let disabledButtonProps = AppearanceProperties()
        disabledButtonProps.cornerRadius = 5
        disabledButtonProps.borderWidth = 1
        disabledButtonProps.tintColor = disabledColor
        disabledButtonProps.borderColor = disabledColor
        disabledButtonProps.font = textFont
        disabledButtonProps.backgroundColor = backgroundColor
        
        AcmeButton.appearance().enabledProperties = enabledButtonProps
        AcmeButton.appearance().disabledProperties = disabledButtonProps
        
        UILabel.appearance().textColor = textColor
        UILabel.appearance().font = textFont
        FailureLabel.appearance().textColor = textColor
        FailureLabel.appearance().font = textFont?.withSize(20.0)
        FailureLabel.appearance().textAlignment = .center
        
        InfoLabel.appearance().textColor = tintColor
        InfoLabel.appearance().font = textFont
        UINavigationBar.appearance().barTintColor = backgroundColor
        UINavigationBar.appearance().tintColor = backgroundColor
        UINavigationBar.appearance().titleTextAttributes =
            [NSAttributedString.Key.font : headerFont!, NSAttributedString.Key.foregroundColor : tintColor]
        UINavigationBar.appearance().isTranslucent = false
        UINavigationBar.appearance().shadowImage = UIImage()
        UINavigationBar.appearance().backIndicatorImage = UIImage()
        UIBarButtonItem.appearance().setTitleTextAttributes([
            NSAttributedString.Key.font : headerFont!,
            NSAttributedString.Key.foregroundColor: tintColor
            ], for: .normal)
        UICollectionView.appearance().backgroundColor = backgroundColor
    }
}


struct DefaultTheme: Theming {
    let tintColor: UIColor = UIColor.init(red: 10/255, green: 195/255, blue: 199/255, alpha: 1)
    let disabledColor: UIColor = UIColor.gray
    let primaryButtonColor: UIColor = UIColor.init(red: 10/255, green: 195/255, blue: 199/255, alpha: 1)
    let backgroundColor: UIColor = UIColor.black
    let textColor: UIColor = UIColor.white
}
