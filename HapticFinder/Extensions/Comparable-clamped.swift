//
//  Clamped.swift
//  Haptic Bluetooth Analyzer
//
//  Created by Hlib Hraif on 21/01/2021.
//

import Foundation

extension Comparable {
    func clamped(to limits: ClosedRange<Self>) -> Self {
        return min(max(self, limits.lowerBound), limits.upperBound)
    }
}
