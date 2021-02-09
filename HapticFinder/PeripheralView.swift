//
//  PeripheralView.swift
//  HapticFinder
//
//  Created by Hlib Hraif on 21/01/2021.
//

import SwiftUI
import SwiftUICharts
import CoreBluetooth

struct PeripheralView: View {
    @ObservedObject private var peripheralViewModel: PeripheralViewModel
    
    init(_ periferalViewModel: PeripheralViewModel) {
        self.peripheralViewModel = periferalViewModel
    }
    
    var body: some View {
        VStack {
            LineView(data: peripheralViewModel.rssiReadings.map { $0.doubleValue }, title: peripheralViewModel.name)
            Text("Current strength: ") + Text("\(peripheralViewModel.rssiReadings.last?.intValue ?? 0)").bold()
        }
        .onAppear {
            peripheralViewModel.startReadingRSSI()
        }
        .onDisappear() {
            peripheralViewModel.stopReadingRSSI()
        }
        .navigationBarTitle(Text("Details"), displayMode: .inline)
        .padding()
    }
}

struct PeripheralView_Previews: PreviewProvider {
    static var previews: some View {
        Text("Strength: 0.0")
    }
}
