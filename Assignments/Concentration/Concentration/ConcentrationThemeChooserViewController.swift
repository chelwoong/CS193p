//
//  ConcentrationThemeChooserViewController.swift
//  Concentration
//
//  Created by woong on 2021/02/02.
//  Copyright © 2021 woong. All rights reserved.
//

import UIKit

class ConcentrationThemeChooserViewController: UIViewController {

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard
            segue.identifier == "Theme Choose",
            let concentrationVC = segue.destination as? ConcentrationViewController,
            let themeButton = sender as? ThemeButton
        else { return }
        
        concentrationVC.currentTheme = ConcentrationViewController.Theme(rawValue: themeButton.theme) ?? .animal
    }
}
