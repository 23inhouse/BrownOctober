//
//  String.swift
//  Sink the Floater
//
//  Created by Benjamin Lewis on 7/5/19.
//  Copyright © 2019 Benjamin Lewis. All rights reserved.
//

import Foundation

extension String {

    func spaced(width: Int, with: String) -> String {
        guard width > self.count else { return self }
        return String(repeating: with, count: width - self.count) + self
    }

}
