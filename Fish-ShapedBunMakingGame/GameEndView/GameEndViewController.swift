//
//  GameEndViewController.swift
//  Fish-ShapedBunMakingGame
//
//  Created by 신예진 on 2023/01/11.
//

import Foundation
import UIKit

class GameEndViewContoller: UIViewController {
    
    @IBOutlet weak var scoreLabel: UILabel!
    
    // 게임 view에서 받아올 점수
    var score: Int?
    
    
    @IBAction func closeButton(_ sender: UIButton) {
        // 2개의 view 동시에 dismiss
        self.presentingViewController?.presentingViewController?.dismiss(animated: false, completion: nil)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 게임 view에서 가져온 점수로 Label 업데이트
        scoreLabel.text = "\(score!)점"
    }
}
