//
//  UIView+extensions.swift
//  MyGitHub
//
//  Created by Vaibhav Singh on 06/08/22.
//

import Foundation
import UIKit

extension UIView {
    func fillIn(container: UIView, withInsets insets: UIEdgeInsets = .zero) {
        translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(self)

        NSLayoutConstraint.activate([
            topAnchor.constraint(equalTo: container.topAnchor, constant: insets.top),
            rightAnchor.constraint(equalTo: container.rightAnchor, constant: -insets.right),
            bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -insets.bottom),
            leftAnchor.constraint(equalTo: container.leftAnchor, constant: insets.left)
        ])
    }
}
