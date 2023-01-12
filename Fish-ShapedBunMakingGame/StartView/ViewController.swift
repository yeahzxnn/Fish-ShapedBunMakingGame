//
//  ViewController.swift
//  Fish-ShapedBunMakingGame
//
//  Created by 신예진 on 2023/01/09.
//
import Foundation
import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
     //화면 시작하자마자 하는 방법 바로 나오고 나는 Start누르고 시작하면 됨!ㅊ
    @IBAction func clickedGameStart(_ sender: Any) {
      let vc = GameViewController()
      present(vc, animated: false, completion: nil)
    }
    
}

