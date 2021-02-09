//
//  Haptics.swift
//  HapticFinder
//
//  Created by Hlib Hraif on 21/01/2021.
//

import Foundation
import UIKit.UIApplication
import CoreHaptics

class HapticsManager {
    static let shared = HapticsManager()
    
    // Constants
    private let initialIntensity: Float = 1.0
    private let initialSharpness: Float = 0.0
    private let supportsHaptics: Bool
    private var engine: CHHapticEngine!
    private var player: CHHapticAdvancedPatternPlayer!
    private var foregroundToken: NSObjectProtocol?
    private var backgroundToken: NSObjectProtocol?
    
    private var _strength: Float = 0
    var strength: Float {
        get {
            self._strength
        }
        set(newValue) {
            self._strength = newValue.clamped(to: 0...1)
            
            let intensityParameter = CHHapticDynamicParameter(parameterID: .hapticIntensityControl,
                                                              value: sqrtf(_strength),
                                                              relativeTime: 0)
            
            let sharpnessParameter = CHHapticDynamicParameter(parameterID: .hapticSharpnessControl,
                                                              value: powf(_strength * 0.887904, 3),
                                                              relativeTime: 0)
            
            // Send dynamic parameters to the haptic player.
            do {
                try player.sendParameters([intensityParameter, sharpnessParameter],
                                          atTime: 0)
            } catch let error {
                print("Dynamic Parameter Error: \(error)")
            }
        }
    }
    
    
    private init() {
        let hapticCapability = CHHapticEngine.capabilitiesForHardware()
        supportsHaptics = hapticCapability.supportsHaptics
        
        do {
            engine = try CHHapticEngine()
        } catch let error {
            fatalError("Engine Creation Error: \(error)")
        }
        
        do {
            try self.engine.start()
        } catch {
            print("Failed to start the engine: \(error)")
        }
        
        engine.resetHandler = { [unowned self] in
        
            print("Reset Handler: Restarting the engine.")
            
            do {
                // Try restarting the engine.
                try self.engine.start()
                        
                // Register any custom resources you had registered, using registerAudioResource.
                // Recreate all haptic pattern players you had created, using createPlayer.

                createPattern()
            } catch {
                fatalError("Failed to restart the engine: \(error)")
            }
        }
        
        createPattern()
    }
    
    private func addObservers() {
        backgroundToken = NotificationCenter.default.addObserver(forName: UIApplication.didEnterBackgroundNotification,
                                                                 object: nil,
                                                                 queue: nil)
        { _ in
            guard self.supportsHaptics else {
                return
            }
            // Stop the haptic engine.
            self.engine.stop(completionHandler: { error in
                if let error = error {
                    print("Haptic Engine Shutdown Error: \(error)")
                    return
                }
            })
        }
        foregroundToken = NotificationCenter.default.addObserver(forName: UIApplication.willEnterForegroundNotification,
                                                                 object: nil,
                                                                 queue: nil)
        { _ in
            guard self.supportsHaptics else {
                return
            }
            // Restart the haptic engine.
            self.engine.start(completionHandler: { error in
                if let error = error {
                    print("Haptic Engine Startup Error: \(error)")
                    return
                }
            })
        }
    }
    
    private func createPattern() {
        // Create an intensity parameter:
        let intensity = CHHapticEventParameter(parameterID: .hapticIntensity,
                                               value: initialIntensity)

        // Create a sharpness parameter:
        let sharpness = CHHapticEventParameter(parameterID: .hapticSharpness,
                                               value: initialSharpness)

        // Create a continuous event with a long duration from the parameters.
        let continuousEvent = CHHapticEvent(eventType: .hapticContinuous,
                                            parameters: [intensity, sharpness],
                                            relativeTime: 0,
                                            duration: 1000)

        do {
            // Create a pattern from the continuous haptic event.
            let pattern = try CHHapticPattern(events: [continuousEvent], parameters: [])
            
            // Create a player from the continuous haptic pattern.
            player = try engine.makeAdvancedPlayer(with: pattern)
            
        } catch let error {
            print("Pattern Player Creation Error: \(error)")
        }
    }
    
    func start() {
        if (supportsHaptics) {
            do {
                // Begin playing continuous pattern.
                try player.start(atTime: CHHapticTimeImmediate)
            } catch let error {
                print("Error starting the continuous haptic player: \(error)")
            }
        }
    }
    
    func stop() {
        // Stop playing the haptic pattern.
        do {
            try player.stop(atTime: CHHapticTimeImmediate)
        } catch let error {
            print("Error stopping the continuous haptic player: \(error)")
        }
    }
}
