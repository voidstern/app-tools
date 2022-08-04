//
//  XIbLoadable.swift
//  Dozzzer 4
//
//  Created by Lukas Burgstaller on 27/10/2016.
//  Copyright © 2016 Lukas Burgstaller. All rights reserved.
//

import Foundation
import UIKit

public protocol XibLoadable {
    associatedtype Loadable
    static var xibName: String { get }
    static func loadFromXib() -> Loadable
}

public extension XibLoadable {
    static func nib() -> UINib {
        let bundle: Bundle = Bundle.main
        return UINib(nibName: xibName, bundle: bundle)
    }
    
    static func loadFromXib() -> Self {
        let bundle: Bundle = Bundle.main

        guard let nib = bundle.loadNibNamed(xibName, owner: nil, options: nil) else {
			fatalError("Could not load nib for " + xibName)
        }

        guard let view = nib.first as? Self else {
            fatalError("Could not load view for " + xibName)
        }

        return view
    }
}
