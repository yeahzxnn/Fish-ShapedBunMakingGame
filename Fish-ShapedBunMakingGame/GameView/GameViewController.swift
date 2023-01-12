//
//  GameViewController.swift
//  Fish-ShapedBunMakingGame
//
//  Created by 신예진 on 2023/01/09.
//

import UIKit
import AVFoundation

class GameViewController: UIViewController {
    
    // MARK: - //UI연결
    
    //붕어빵 개수
    @IBOutlet weak var customerOrder: UILabel!
    
    //목숨 개수
    @IBOutlet weak var heart1: UIImageView!
    @IBOutlet weak var heart2: UIImageView!
    @IBOutlet weak var heart3: UIImageView!
    
    //scorelabel
    @IBOutlet weak var scoreLabel: UILabel!
    
    //재료
    @IBOutlet weak var FishDoughButton: UIButton!
    @IBOutlet weak var redBeanButton: UIButton!
    @IBOutlet weak var handButton: UIButton!
    
    
    //재료 image
    @IBOutlet weak var FishDough: UIImageView!
    @IBOutlet weak var redBean: UIImageView!
    @IBOutlet weak var hand: UIImageView!
    
    
    //붕어빵 틀
    @IBOutlet weak var button1: UIButton!
    @IBOutlet weak var button2: UIButton!
    @IBOutlet weak var button3: UIButton!
    @IBOutlet weak var button4: UIButton!
    @IBOutlet weak var button5: UIButton!
    @IBOutlet weak var button6: UIButton!
    @IBOutlet weak var finishedBreadLabel: UILabel!
    
    
    
    //붕어빵 이미지
    @IBOutlet weak var image1: UIImageView!
    @IBOutlet weak var image2: UIImageView!
    @IBOutlet weak var image3: UIImageView!
    @IBOutlet weak var image4: UIImageView!
    
    @IBOutlet weak var image5: UIImageView!
    @IBOutlet weak var image6: UIImageView!
    
    //붕어빵 전체 타이머
    @IBOutlet weak var gameTimerProgressView: UIProgressView!
    
    //목숨개수 코드
    var heartPoint: Int = 3 {
        willSet {
            DispatchQueue.main.async { [self] in
                if newValue == 2 {
                    heart3.image = UIImage(systemName: "heart")
                }
                if newValue == 1 {
                    heart2.image = UIImage(systemName: "heart")
                }
                if newValue == 0 {
                    heart1.image = UIImage(systemName: "heart")
                }
            }
        }
    }
    
    //스코어 코드
    var score : Int = 0
    
    //고객이 주문한 붕어빵
    var orderCount: Int?
    
    //완성된 붕어빵 수량
    var finishedBreadCount: Int = 0
    
    // 빵틀 상태
    var currentTrayState: [String: TrayState] = [
        "1": .비어있음,
        "2": .비어있음,
        "3": .비어있음,
        "4": .비어있음,
        "5": .비어있음,
        "6": .비어있음
    ]
    
    //빵 burn
    var breadBurnTime: Int?
    
    //재료 선택
    var selectedIngredients: Ingredients?
    
    let globalQueue = DispatchQueue.global()
    

    //붕어빵 지급하기
    
    @IBAction func giveBreadButton(_ sender: UIButton) {
        if finishedBreadCount >= orderCount! {
            //보유 붕어빵과 스코어 계산
            finishedBreadCount -= orderCount!
            score += 100 * orderCount!
            updateNumberOfBread()
            updateScore()
            
            //붕어빵 N개 사라짐
            self.customerOrder.isHidden = true
            
            //손님 타이머와 루프 해제
//            // 손님 타이머와 루프 해제
//            customerTimer.invalidate()
//            customerLoopSwitch = false
            
        }else{
            score -= 100
            updateScore()
        }
    }
    
    // MARK: - View Did Load
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // burnTimer들 배열로 저장
        burnTimers = [burnTimer1, burnTimer2, burnTimer3, burnTimer4, burnTimer5, burnTimer6]
        
        // 붕어빵 버튼들에 함수 연결
        button1.addTarget(self, action: #selector(didTouchedTrayButton(_:)), for: .touchUpInside)
        button2.addTarget(self, action: #selector(didTouchedTrayButton(_:)), for: .touchUpInside)
        button3.addTarget(self, action: #selector(didTouchedTrayButton(_:)), for: .touchUpInside)
        button4.addTarget(self, action: #selector(didTouchedTrayButton(_:)), for: .touchUpInside)
        button5.addTarget(self, action: #selector(didTouchedTrayButton(_:)), for: .touchUpInside)
        button6.addTarget(self, action: #selector(didTouchedTrayButton(_:)), for: .touchUpInside)
        
        
        // 재료 선택 버튼들 함수 연결
        FishDoughButton.addTarget(self, action: #selector(didTouchedIngredientsButton(_:)), for: .touchUpInside)
        redBeanButton.addTarget(self, action: #selector(didTouchedIngredientsButton(_:)), for: .touchUpInside)
        handButton.addTarget(self, action: #selector(didTouchedIngredientsButton(_:)), for: .touchUpInside)
    }
    
    
    
    // MARK: - View Did Appear
    override func viewDidAppear(_ animated: Bool) {
        mainLoop()
    }
    
    // MARK: - View Did Disappear
    override func viewWillDisappear(_ animated: Bool){
        
    }
    
    
    // MARK: - 함수
    
    //게임 종료하는 함수
    func gameOver(){
        
        // 메인 타이머 해제
        mainTimer.invalidate()
        mainTimerSwitch = false
        
        //고객 타이머 해제
//        customerTimer.invalidate()
//        customerLoopSwitch = false
        
        print("게임종료!!!!!!!!!!!!!!!!!")
        
        DispatchQueue.main.async {
            guard let resultVC = self.storyboard?.instantiateViewController(withIdentifier: "GameEndViewContoller") as? GameEndViewContoller else {
                return
            }
            resultVC.score = self.score
            resultVC.modalPresentationStyle = .overCurrentContext
            self.present(resultVC, animated: true, completion: nil)
        }
    }
    
    //메인 루프
    func mainLoop() {
        globalQueue.async { [self] in
            mainTimerSwitch = true
            let runLoop = RunLoop.current
            mainTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(mainTimerCounter), userInfo: nil,repeats: true)
            
            
            while mainTimerSwitch {
                runLoop.run(until: Date().addingTimeInterval(0.1))
            }
        }
    }
    
    // 메인(게임) 타이머
    var mainTimer: Timer = Timer()
    var mainCount: Int = 0
    var mainTimerSwitch: Bool = false
    
    @objc func mainTimerCounter() {
        mainCount = mainCount + 1
                
        if(mainCount<=100){
            DispatchQueue.main.async { [self] in
                gameTimerProgressView.setProgress(gameTimerProgressView.progress - 0.01, animated: true)
            }
        } else {
            gameOver()
        }
    }
    
    // 랜덤 숫자 반환 (1~6)
    func getRandomNumber() -> Int {
        return Int.random(in: 1...6)
    }
    
    // 붕어빵 태우는지 여부 확인하는 타이머
    var burnTimer1 = Timer()
    var burnTimer2 = Timer()
    var burnTimer3 = Timer()
    var burnTimer4 = Timer()
    var burnTimer5 = Timer()
    var burnTimer6 = Timer()
    var burnTimers: [Timer] = []
    var burnTimersCount: [Int] = [0, 0, 0, 0, 0, 0]
    var burnLoopSwitch: [Bool] = [false, false, false, false, false, false]
    
    // 붕어빵이 다 익으면 작동할 타이머
    // 1번째 붕어빵 트레이면 매개변수로 0을 받도록 할것
    func burnLoop(_ index: Int) {
        burnTimersCount[index] = 0
        
        globalQueue.async { [weak self] in
            guard let self = self else {
                return
            }
            self.burnLoopSwitch[index] = true
            let runLoop = RunLoop.current
            
            self.burnTimers[index] = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.burnTimerCounter(_:)), userInfo: ["index": index], repeats: true)
            
            while self.burnLoopSwitch[index] {
                runLoop.run(until: Date().addingTimeInterval(0.1))
            }
        }
    }
    
    // 타는지 여부 확인할 타이머 카운터
    @objc func burnTimerCounter(_ timer: Timer) {
        guard let receivedData = timer.userInfo as? Dictionary<String, Int> else {
            return
        }
        let index: Int = receivedData["index"]!
        
        burnTimersCount[index] += 1
        if burnTimersCount[index] == breadBurnTime {
            burnLoopSwitch[index] = false
            burnTimers[index].invalidate()
            currentTrayState[String(index+1)] = .탐
//            print("\(index+1)번 붕어빵 탔어요.")
        }
    }
    
    // 시간 맞춰서 뒤집으면 burn timer 멈추는 함수
    func stopBurnTimer(_ index: Int) {
        burnLoopSwitch[index] = false
        burnTimers[index].invalidate()
    }
    
    // 붕어빵 틀 눌리면 동작할 함수
    @objc func didTouchedTrayButton(_ sender: UIButton) {
        // 눌린 버튼(sender)의 titleLabel을 가져와서 눌린 붕어빵 틀 정보 저장
        let buttonKey: String = (sender.titleLabel?.text)!
        let trayIndex: Int = Int(buttonKey)! - 1
        
        // 현재 붕어빵 틀의 상태를 가져옴
        let trayState: TrayState = currentTrayState[buttonKey]!
        
        // 현재 붕어빵 틀 상태로 조건문 돌리기
        switch trayState {
        case .비어있음:
            if selectedIngredients == .반죽 {
                currentTrayState[buttonKey] = .반죽
                updateTrayImgae(state: .반죽, trayNumber: buttonKey)
            }
        case .반죽:
            if selectedIngredients == .팥 {
                currentTrayState[buttonKey] = .팥
                updateTrayImgae(state: .팥, trayNumber: buttonKey)
            }
        case .팥:
            if selectedIngredients == .손 {
                currentTrayState[buttonKey] = .뒤집기1
                updateTrayImgae(state: .뒤집기1, trayNumber: buttonKey)
                globalQueue.async {
                    let runLoop = RunLoop.current
                    Timer.scheduledTimer(withTimeInterval: 2, repeats: false, block: { _ in
                        // 뒤집고 2초 후 붕어빵 틀 상태 변경
                        self.currentTrayState[buttonKey] = .뒤집기2가능
                        // 다 익으면 동시에 burn timer 시작
                        self.burnLoop(trayIndex)
                    })
                    runLoop.run(until: Date().addingTimeInterval(8))
                }
                
            }
        case .뒤집기2가능:
            if selectedIngredients == .손 {
                // 전단계에서 진행되던 burn timer 멈춤
                stopBurnTimer(trayIndex)
                
                currentTrayState[buttonKey] = .뒤집기2
                updateTrayImgae(state: .뒤집기2, trayNumber: buttonKey)
                globalQueue.async {
                    let runLoop = RunLoop.current
                    Timer.scheduledTimer(withTimeInterval: 2, repeats: false, block: { _ in
                        self.currentTrayState[buttonKey] = .뒤집기3가능
                        self.burnLoop(trayIndex)
                    })
                    runLoop.run(until: Date().addingTimeInterval(8))
                }
            }
        case .뒤집기3가능:
            if selectedIngredients == .손 {
                stopBurnTimer(trayIndex)
                currentTrayState[buttonKey] = .뒤집기3
                updateTrayImgae(state: .뒤집기3, trayNumber: buttonKey)
                globalQueue.async {
                    let runLoop = RunLoop.current
                    Timer.scheduledTimer(withTimeInterval: 2, repeats: false, block: { _ in
                        self.currentTrayState[buttonKey] = .뒤집기4가능
                        self.burnLoop(trayIndex)
                    })
                    runLoop.run(until: Date().addingTimeInterval(8))
                }
            }
        case .뒤집기4가능:
            if selectedIngredients == .손 {
                stopBurnTimer(trayIndex)
                currentTrayState[buttonKey] = .뒤집기4
                updateTrayImgae(state: .뒤집기4, trayNumber: buttonKey)
                burnLoop(trayIndex)
            }
        case .뒤집기4:
            if selectedIngredients == .손 {
                stopBurnTimer(trayIndex)
                currentTrayState[buttonKey] = .비어있음
                updateTrayImgae(state: .비어있음, trayNumber: buttonKey)
                finishedBreadCount += 1
                updateNumberOfBread()
            }
        case .탐:
            if selectedIngredients == .손 {
                currentTrayState[buttonKey] = .탄거확인
                updateTrayImgae(state: .탄거확인, trayNumber: buttonKey)
            }
        case .탄거확인:
            if selectedIngredients == .손 {
                currentTrayState[buttonKey] = .비어있음
                updateTrayImgae(state: .비어있음, trayNumber: buttonKey)
            }
        default:
            return
        }
    }
    
    // 붕어빵 틀 이미지 업데이트하는 함수
    func updateTrayImgae(state: TrayState, trayNumber: String) {
        switch trayNumber {
        case "1":
            image1.image = UIImage(named: state.rawValue)
        case "2":
            image2.image = UIImage(named: state.rawValue)
        case "3":
            image3.image = UIImage(named: state.rawValue)
        case "4":
            image4.image = UIImage(named: state.rawValue)
        case "5":
            image5.image = UIImage(named: state.rawValue)
        case "6":
            image6.image = UIImage(named: state.rawValue)
        default:
            return
        }
    }

    
    // 재료 선택 버튼
    @objc func didTouchedIngredientsButton(_ sender: UIButton) {
        imageBorderCancel()
        switch sender {
        case FishDoughButton:
            selectedIngredients = .반죽
            addBorderToImage(FishDough)
        case redBeanButton:
            selectedIngredients = .팥
            addBorderToImage(redBean)
        default:
            selectedIngredients = .손
            addBorderToImage(hand)
        }
    }
    
    // borderWidth 초기화
    func imageBorderCancel() {
        FishDoughButton.layer.borderWidth = 0
        redBeanButton.layer.borderWidth = 0
        handButton.layer.borderWidth = 0
    }
    // 이미지뷰에 borderWidth 2 설정하는 함수
    func addBorderToImage(_ to: UIImageView) {
        to.layer.borderWidth = 2
    }
    
    // 완성된 붕어빵 개수 Label 업데이트 함수
    func updateNumberOfBread() {
        finishedBreadLabel.text = "X \(finishedBreadCount)"
    }
    
    // 점수 업데이트 함수
    func updateScore() {
        scoreLabel.text = String(score)
    }

}
