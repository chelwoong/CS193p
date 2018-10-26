//
//  ConcentrationThemeChooserViewController.swift
//  Concentration
//
//  Created by woong on 2018. 10. 22..
//  Copyright © 2018년 woong. All rights reserved.
//

import UIKit

class ConcentrationThemeChooserViewController: UIViewController, UISplitViewControllerDelegate {
    
    let themes = [
        "Sports": "⚽️🏀🏈⚾️🎾🏐🏉🎱🏓⛷🎳⛳️",
        "Animals": "🐶🦆🐹🐸🐘🦍🐓🐩🐦🦋🐙🐏",
        "Faces": "😀😌😎🤓😠😤😭😰😱😳😜😇"
    ]
    
    override func awakeFromNib() {
        splitViewController?.delegate = self
    }
    
    // secondary는 디테일, primary는 마스터
    func splitViewController(
        _ splitViewController: UISplitViewController,
        collapseSecondary secondaryViewController: UIViewController,
        onto primaryViewController: UIViewController
    ) -> Bool {
        // 첫째가 위에 나오게 하려면 false
        // 가림이 안일어나게 하려면 true 리턴해야한다!
        if let cvc = secondaryViewController as? ConcentrationViewController {
            if cvc.theme == nil {
                return true
            }
        }
        return false
    }
    
    @IBAction func changeTheme(_ sender: Any) {
        if let cvc = splitViewDetailConcentrationViewController {
            // 테마를 바꿔도 게임을 리셋시키지 않기 위해 세그웨이를 사용하지 않고,
            // 스플릿 뷰에게 직접 디테일을 찾아보고 있으면 그걸 쓰라고 한다!
            if let themeName = (sender as? UIButton)?.currentTitle, let theme = themes[themeName] {
                cvc.theme = theme
            }
        } else if let cvc = lastSeguedToConcentrationViewController {
            if let themeName = (sender as? UIButton)?.currentTitle, let theme = themes[themeName] {
                cvc.theme = theme
            }
            navigationController?.pushViewController(cvc, animated: true)
        } else {
            performSegue(withIdentifier: "Choose Theme", sender: sender)
        }
    }
    /*
     // 아이폰에서 적용해보자
     아이폰은 splitViewController에 디테일이 없다 대신 탐색컨트롤러를 사용한다!
     아이폰은 세그웨이가 향하고 있는 MVC를 포인터를 사용해 계속 잡고 있다.
     네비게이션 스택을 벗어나도 힙을 벗어나지 않은 채 그대로 쥐고있다.
     그래서 다음에 원하는 사람이 있으면 그대로 네비게이션 컨트롤러로 바로 가져온다.
    */
    private var lastSeguedToConcentrationViewController: ConcentrationViewController?
    
    // 스플릿 뷰 찾기
    private var splitViewDetailConcentrationViewController: ConcentrationViewController? {
        // .last는 detail 을 의미함
        return splitViewController? .viewControllers.last as? ConcentrationViewController
        
    }
    

    // MARK: - Navigation

    // 각 테마에 맞는 게임을 하기 위해 prepare를 작성해보자.
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // 현재는 세그웨이가 하나밖에 없다. 우선 세그웨이가 Choose Theme인지 확인한다.
        if segue.identifier == "Choose Theme" {
            // sender는 세그웨이를 부른 주체를 뜻함.
            // any?가 나오면 거의 as?를 같이 쓰게될 것!!
            // 이렇게만 하면 sender가 옵셔녈 애니 타입이기 때문에 currentTitle을 불러올 수 없다. 그래서 as를 사용할거다
            if let themeName = (sender as? UIButton)?.currentTitle, let theme = themes[themeName] {
                if let cvc = segue.destination as? ConcentrationViewController {
                    cvc.theme = theme
                    lastSeguedToConcentrationViewController = cvc
                }
            }
        }
        
    }

}
