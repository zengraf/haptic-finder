//
//  PeripheralViewModel.swift
//  HapticFinder
//
//  Created by Hlib Hraif on 21/01/2021.
//

import Foundation
import CoreBluetooth

class PeripheralViewModel: NSObject, ObservableObject {
    let id: UUID
    @Published var rssiReadings: [NSNumber] = []
    @Published var name: String
    @Published var connected: Bool
    
    private let peripheral: CBPeripheral
    private let parent: PeripheralsViewModel
    private var timer: Timer?
    
    init(name: String, peripheral: CBPeripheral, parent: PeripheralsViewModel) {
        self.peripheral = peripheral
        self.parent = parent
        self.connected = peripheral.state == .connected
        self.name = name
        self.id = peripheral.identifier
        super.init()
        peripheral.delegate = self
    }
    
    func startReadingRSSI() {
        print("Start reading RSSI for \(name)")
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            if self.connected {
                self.peripheral.readRSSI()
            }
        }
        
        HapticsManager.shared.start()
    }
    
    func stopReadingRSSI() {
        print("Stop reading RSSI for \(name)")
        timer?.invalidate()
        
        HapticsManager.shared.stop()
    }
}

extension PeripheralViewModel: CBPeripheralDelegate {
    func peripheral(_ peripheral: CBPeripheral, didReadRSSI RSSI: NSNumber, error: Error?) {
        rssiReadings.append(RSSI)
        
        HapticsManager.shared.strength = ((1 + RSSI.floatValue / 100) - 0.1) / (0.8 - 0.1)
    }
}
