//
//  PeripheralListItem.swift
//  Haptic Finder
//
//  Created by Hlib Hraif on 09.02.2021.
//

import SwiftUI

struct PeripheralListItem: View {
    @ObservedObject private var peripheral: PeripheralViewModel
    private let savedName: String?
    
    init(_ peripheral: PeripheralViewModel, savedName: String? = nil) {
        self.peripheral = peripheral
        self.savedName = savedName
    }
    
    var body: some View {
        if peripheral.connected {
            NavigationLink(
                destination: PeripheralView(peripheral)) {
                HStack {
                    Circle()
                        .fill(Color.green)
                        .frame(width: 10, height: 10)
                    Text(savedName ?? peripheral.name)
                }
            }
        } else {
            HStack {
                Circle()
                    .fill(Color.red)
                    .frame(width: 10, height: 10)
                Text(savedName ?? peripheral.name)
            }
        }
    }
}

struct PeripheralListItem_Previews: PreviewProvider {
    static var previews: some View {
        HStack {
            Circle()
                .fill(Color.red)
                .frame(width: 10, height: 10)
            Text("Item")
        }
    }
}
