//
//  EntryError.swift
//  CloudKitJournal
//
//  Created by River McCaine on 2/1/21.
//  Copyright © 2021 Zebadiah Watson. All rights reserved.
//

import Foundation

enum EntryError: LocalizedError {
    case ckError(Error)
    case unableToUnwrap
    
    var errorDescription: String? {
        switch self {
        case .ckError(let error):
            return "Error: \(error.localizedDescription) -> \(error)"
        case .unableToUnwrap:
            return "Data could not be found"
        }
    }
}
