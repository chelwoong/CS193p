//
//  ConcentrationThemeChooserViewController.swift
//  Concentration
//
//  Created by woong on 2021/02/02.
//  Copyright © 2021 woong. All rights reserved.
//

import UIKit

class ConcentrationThemeChooserViewController: UIViewController, UISplitViewControllerDelegate {
    
    override func awakeFromNib() {
        splitViewController?.delegate = self
    }
    
    private var lastSeguedToConcentrationViewController: ConcentrationViewController?
    private var splitDetailViewController: ConcentrationViewController? {
        return splitViewController?.viewControllers.last as? ConcentrationViewController
    }
    
    func splitViewController(
        _ splitViewController: UISplitViewController,
        collapseSecondary secondaryViewController: UIViewController,
        onto primaryViewController: UIViewController
    ) -> Bool {
        guard
            let concentrationVC = secondaryViewController as? ConcentrationViewController,
            concentrationVC.currentTheme == nil
        else { return false }
        return true
    }

    @IBAction private func changeTheme(_ sender: ThemeButton) {
        if let concentrationVC = splitDetailViewController {
            concentrationVC.currentTheme = ConcentrationViewController.Theme(rawValue: sender.theme) ?? .animal
        } else if let concentrationVC = lastSeguedToConcentrationViewController {
            concentrationVC.currentTheme = ConcentrationViewController.Theme(rawValue: sender.theme) ?? .animal
            navigationController?.pushViewController(concentrationVC, animated: true)
        } else {
            performSegue(withIdentifier: "Theme Choose", sender: sender)
        }
    }
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard
            segue.identifier == "Theme Choose",
            let concentrationVC = segue.destination as? ConcentrationViewController,
            let themeButton = sender as? ThemeButton
        else { return }
        
        concentrationVC.currentTheme = ConcentrationViewController.Theme(rawValue: themeButton.theme) ?? .animal
        lastSeguedToConcentrationViewController = concentrationVC
    }
}
