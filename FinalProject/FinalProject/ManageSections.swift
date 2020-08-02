//
//  ManageSections.swift
//  FinalProject
//
//  Created by Linghao Du on 4/23/20.
//  Copyright © 2020 Linghao Du. All rights reserved.
//

enum ManagementSection: Int, CaseIterable, CustomStringConvertible {
    case Manage
    case test
    
    var description: String {
        switch self {
        case .Manage:
            return "Manage"
        case .test:
            return "Test"
        }
    }
}

enum ManageOptions: Int, CaseIterable, CustomStringConvertible {
    case CleanData
    
    var description: String {
        switch self {
        case .CleanData:
            return "Clean Data"
        }
    }
}

enum testOptions: Int, CaseIterable, CustomStringConvertible {
    case someFunction
    
    var description: String {
        switch self {
        case .someFunction:
            return "Some Functions"
        }
    }
}
