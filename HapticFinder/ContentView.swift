//
//  ContentView.swift
//  HapticFinder
//
//  Created by Hlib Hraif on 20/01/2021.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @ObservedObject private var peripheralsViewModel = PeripheralsViewModel()
    
    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \Peripheral.name, ascending: true)], animation: .default)
    private var savedPeripherals: FetchedResults<Peripheral>
    
    @State private var showPeripheralsSheet = false
    
    var body: some View {
        NavigationView {
            List {
                Section(header: Text("Favorite")) {
                    ForEach(savedPeripherals, id: \.id) { peripheral in
                        if let viewModel = peripheralsViewModel.find(peripheral.id!) {
                            PeripheralListItem(viewModel, savedName: peripheral.name)
                        } else {
                            HStack {
                                Circle()
                                    .fill(Color.red)
                                    .frame(width: 10, height: 10)
                                Text(peripheral.name ?? "Unknown")
                            }
                        }
                    }
                    .onDelete(perform: deletePeripherals)
                }
                
                Section(header: Text("Nearby")) {
                    ForEach(peripheralsViewModel.peripherals, id: \.id) { peripheral in
                        PeripheralListItem(peripheral)
                    }
                }
            }
            .sheet(isPresented: $showPeripheralsSheet) {
                PeripheralSelector(peripheralsViewModel, isPresented: $showPeripheralsSheet, action: addPeripheral)
            }
            .listStyle(GroupedListStyle())
            .navigationBarTitle(Text("Peripherals"))
            .navigationBarItems(trailing: Button(action: {
                showPeripheralsSheet.toggle()
            }) {
                Image(systemName: "star")
            })
        }
    }
    
    func addPeripheral(peripheral: PeripheralViewModel) -> Void {
        let newSavedPeripheral = Peripheral(context: viewContext)
        newSavedPeripheral.id = peripheral.id
        newSavedPeripheral.name = peripheral.name
        
        do {
            try viewContext.save()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func deletePeripherals(at offsets: IndexSet) {
        for index in offsets {
            let peripheral = savedPeripherals[index]
            viewContext.delete(peripheral)
        }
        do {
            try viewContext.save()
        } catch {
            print(error.localizedDescription)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
