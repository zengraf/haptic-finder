//
//  PeripheralSelector.swift
//  HapticFinder
//
//  Created by Hlib Hraif on 07.02.2021.
//

import SwiftUI

struct PeripheralSelector: View {
    @ObservedObject private var peripheralsViewModel: PeripheralsViewModel
    private let action: (PeripheralViewModel) -> Void
    @Binding private var isPresented: Bool
    
    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \Peripheral.name, ascending: true)], animation: .default)
    private var savedPeripherals: FetchedResults<Peripheral>
    
    init(_ viewModel: PeripheralsViewModel, isPresented: Binding<Bool>, action: @escaping (PeripheralViewModel) -> Void) {
        self.peripheralsViewModel = viewModel
        self.action = action
        self._isPresented = isPresented
    }
    
    var body: some View {
        NavigationView {
            List(peripheralsViewModel.peripherals.filter { peripheral in
                !savedPeripherals.contains(where: { $0.id == peripheral.id })
            }, id: \.id) { peripheral in
                Button(action: {
                    isPresented.toggle()
                    action(peripheral)
                }) {
                    Text(peripheral.name)
                }
            }
            .navigationBarTitle(Text("Add to Favorites"), displayMode: .inline)
        }
    }
}

struct PeripheralSelector_Previews: PreviewProvider {
    static var previews: some View {
        Text("Text")
    }
}
