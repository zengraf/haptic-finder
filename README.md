# Haptic Finder
Application that uses Bluetooth and haptics to find stuff

## Objective
It goes without saying that it is very easy for any small thing to get lost among other things in an apartment. Almost every person has been in a situation when he or she couldn’t find his smartwatch or headphones. In most cases such devices provide functionality like loud sound playback. As for other things that can be easily lost like keys or wallets, a simple Bluetooth tag with a speaker can be attached to them. However, this mechanism cannot be effectively used by people with hearing problems.

This project tries to solve this problem by designing and developing an application called Haptic Finder that would help such people to find their peripherals equipped with Bluetooth using “Hot and Cold” game principles and incorporating haptic and visual cues into the searching process for accessibility.

## Technical details
The application uses `SwiftUI` framework in conjunction with `CoreBluetooth` for managing Bluetooth connectivity and RSSI measurements, `CoreHaptics` for working with the vibration motor and `CoreData` for persistent data management (e.g. saved devices).

## Screenshots
<img src="https://github.com/zengraf/haptic-finder/raw/main/screenshots/main_screen.png" alt="Main screen" width="300"> <img src="https://github.com/zengraf/haptic-finder/raw/main/screenshots/details_screen.png" alt="Details screen" width="300"> <img src="https://github.com/zengraf/haptic-finder/raw/main/screenshots/add_to_favorites.png" alt="Add to favorites" width="300">
