//
//  SharedInstances.swift
//  navProcessor
//
//  Copyright © 2017 Berklee EP-P453. All rights reserved.
//

import UIKit
import CsoundiOS

class SharedInstances {
    static let csound = CsoundObj() // The shared instance of CsoundObj. Accessed as SharedInstances.csound
    private init() { }  // So that we can't create an instance of SharedInstances
}

