//
//  Snake
//
//  Themes.swift
//
//  Created by João de Vasconcelos.
//  Copyright (c) 2014 João de Vasconcelos. All rights reserved.
//

import UIKit

class Themes {
    
    var theme: NSDictionary
    
    var currentTheme: NSDictionary
    
    /* * * CONTRAST * */
    /* * EACH THEME HAS A BRIGHT OR DARK MODE THAT IS USED AT NIGHT  */
    /**/ var contrast: String
    /* * */
    
    
    init () {
        
        let themesPath = Bundle.main.path(forResource: "Themes", ofType: "plist")
        let themes = NSDictionary(contentsOfFile: themesPath!)!
        
        theme = themes.value(forKey: "pastel") as! NSDictionary
        
        currentTheme = theme.value(forKey: "bright") as! NSDictionary
        
        contrast = "bright"
    
    }
    
    
    func setTheme(_ theme: String) {
        
        let themesPath = Bundle.main.path(forResource: "Themes", ofType: "plist")
        let themes = NSDictionary(contentsOfFile: themesPath!)!
        
        self.theme = themes.value(forKey: theme) as! NSDictionary
        
        currentTheme = self.theme.value(forKey: contrast) as! NSDictionary
        
        checkContrast()
        
    }
    
    
    
    /* * * GET * * */
    
    /* FONTS */
    /* RETRIEVE FONTS FROM CURRENT THEME */
    /* REVIEW DOCUMENTATION SECTION FONTS TO SEE STRUCTURE OF INFORMATION */
    
    func fonts() -> [String?] {
        
        let fonts = currentTheme.value(forKey: "Fonts") as! NSDictionary
        
        let standard = fonts.value(forKey: "Standard") as! String
        let supporting = fonts.value(forKey: "Supporting") as! String
        
        return [standard, supporting]
        
    }
    
    
    
    /* COLORS */
    /* RETRIEVE COLORS FROM CURRENT THEME */
    /* REVIEW DOCUMENTATION SECTION COLORS TO SEE STRUCTURE OF INFORMATION */
    
    func getColor(_ scene: String, element: String) -> UIColor {
        
        var colors = currentTheme.value(forKey: "Colors") as! NSDictionary
        
        var color = (colors.value(forKey: scene) as AnyObject).value(element) as! NSDictionary
        
        var rgb = [color.valueForKey("Red") as! CGFloat, color.valueForKey("Green") as! CGFloat, color.valueForKey("Blue") as! CGFloat]
        
        return UIColor(red: rgb[0] / 255, green: rgb[1] / 255, blue: rgb[2] / 255, alpha: 1)
        
    }
    
    
    func checkContrast() {
        
        let date = Date()
        let calendar = Calendar.current
        let components = calendar.components(.CalendarUnitHour | .CalendarUnitMinute, fromDate: date)
        let hour = components.hour
        
        if hour > 20 || hour < 8 {
            
            contrast = "dark"
        
        } else {
            
            contrast = "bright"
        
        }
        
        currentTheme = theme.value(forKey: contrast) as! NSDictionary
        
    }
    
}
