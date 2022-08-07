//
//  GitPRCollectionViewFlowLayout.swift
//  MyGitHub
//
//  Created by Vaibhav Singh on 06/08/22.
//

import Foundation
import UIKit

class GitPRCollectionViewFlowLayout: UICollectionViewFlowLayout {
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        if newBounds.width == UIScreen.main.bounds.width {
            return false
        }
        if newBounds.height == UIScreen.main.bounds.height {
            return false
        }
        return true
    }
}
