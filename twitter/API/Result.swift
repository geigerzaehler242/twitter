//
//  Result.swift
//  twitter
//
//  Created by fernando marto on 2019-02-28.
//  Copyright © 2019 f. All rights reserved.
//

import Foundation

enum Result<T> {
    case success(T)
    case error(Error)
}
