//
//  PeripheralsViewModel.swift
//  HapticFinder
//
//  Created by Hlib Hraif on 21/01/2021.
//

import Foundation
import CoreBluetooth

class PeripheralsViewModel: NSObject, ObservableObject {
    @Published var peripherals: [PeripheralViewModel] = []
    
    private let manager = CBCentralManager()
    
    override init() {
        super.init()
        manager.delegate = self
    }
    
    func find(_ id: UUID) -> PeripheralViewModel? {
        peripherals.first(where: { $0.id == id })
    }
}

extension PeripheralsViewModel: CBCentralManagerDelegate {
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        if central.state == .poweredOn {
            central.scanForPeripherals(withServices: nil)
        }
    }
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        let name = advertisementData[CBAdvertisementDataLocalNameKey] as? String ?? "Unknown"
        if let existing = peripherals.first(where: { $0.id == peripheral.identifier }) {
            if !existing.connected {
                manager.connect(peripheral)
            }
        } else {
            peripherals.append(PeripheralViewModel(name: name, peripheral: peripheral, parent: self))
            manager.connect(peripheral)
        }
    }
    
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        if let connected = peripherals.first(where: { $0.id == peripheral.identifier }) {
            connected.name = peripheral.name ?? "Unknown"
            connected.connected = true
        }
    }
    
    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        if let disconnected = peripherals.first(where: { $0.id == peripheral.identifier }) {
            disconnected.connected = false
        }
    }
}
