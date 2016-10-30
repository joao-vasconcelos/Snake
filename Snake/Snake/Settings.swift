//
//  Snake
//
//  Settings.swift
//
//  Created by João de Vasconcelos.
//  Copyright (c) 2014 João de Vasconcelos. All rights reserved.
//

import Foundation

class Settings {
    
    let preferences: NSDictionary
    
    init () {
        
        let preferencesPath = Bundle.main.path(forResource: "Preferences", ofType: "plist")
        preferences = NSDictionary(contentsOfFile: preferencesPath!)!
        
    }
    
    
    
    /* * * GET * * */
    
    func get(_ set: String, key: String) -> AnyObject? {
        
        return (preferences.value(forKey: set)? as AnyObject).value(forKey: key)
        
    }
    
    
    
    /* GENERAL */
    
    func blockSize() -> Int {
        
        return (preferences.value(forKey: "General") as AnyObject).value("blockSize") as! Int
        
    }
    
    
    func tapsToPause() -> Int {
        
        return (preferences.value(forKey: "General") as AnyObject).value("tapsToPause") as! Int
        
    }
    
    
    func getHighScore(_ score: Int) -> String {
        
        let defaults = UserDefaults.standard
        
        if let firstNameIsNotNill = defaults.object(forKey: "highScore") as? Int {
            
            let best = defaults.object(forKey: "highScore") as! Int
            
            if score < best {
                
                return "(\(best))"
                
            }
            
        }
        
        return ""
        
    }
    
    
    
    /* THEMES */
    
    func getDefaultTheme() -> String {
        
        return (preferences.value(forKey: "Themes") as AnyObject).value("defaultTheme") as! String
        
    }
    
    
    
    /* SNAKE */
    
    func snakeSpeed() -> Int {
        
        return (preferences.value(forKey: "Snake") as AnyObject).value("speed") as! Int
        
    }
    
    func initialSnakeLenght() -> Int {
        
        return (preferences.value(forKey: "Snake") as AnyObject).value("initialLenght") as! Int
        
    }
    
    
    
    /* ELEMENTS */
    
    func elementCount(_ name: String) -> Int {
        
        return (preferences.value(forKey: name) as AnyObject).value("max") as! Int
        
    }
    
    
    // HELPER METHODS
    
    func foodCount() -> Int {
        
        return elementCount("Food")
        
    }
    
    func dizyCount() -> Int {
        
        return elementCount("Dizy")
        
    }
    
    func deadCount() -> Int {
        
        return elementCount("Dead")
        
    }
    
    
    
    
    /* * * SET * * */
    
    func set(_ root: String, key: String) {
        
        /* EMPTY */
        
    }
    
    
    
    /* GENERAL */
    
    func blockSize(_ value: Int) {
        
        /* EMPTY */
        
    }
    
    func tapsToPause(_ value: Int) {
        
        /* EMPTY */
        
    }
    
    
    
    /* THEMES */
    
    func setDefaultTheme(_ name: String) {
        
        /* EMPTY */
        
    }
    
    func changeThemeOnTime(_ ON: Bool) {
        
        /* EMPTY */
        
    }
    
    
    
    /* SNAKE */
    
    func snakeSpeed(_ value: Int) {
        
        /* EMPTY */
        
    }
    
    func initialSnakeLenght(_ value: Int) {
        
        /* EMPTY */
        
    }
    
    
    
    /* ELEMENTS */
    
    func elementON(_ name: String, value: Bool) {
        
        /* EMPTY */
        
    }
    
    func elementCount(_ name: String, value: Bool) {
        
        /* EMPTY */
        
    }
    
}
