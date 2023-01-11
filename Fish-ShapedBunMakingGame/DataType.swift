//
//  DataType.swift
//  Fish-ShapedBunMakingGame
//
//  Created by 신예진 on 2023/01/12.
//

import Foundation
// MARK: - 열거형
// 재료 종류 열거형
enum Ingredients {
    case 반죽
    case 팥
    case 손
}

// 빵틀 상태 열거형
enum TrayState: String {
    case 비어있음 = "붕어빵 빈틀.png"
    case 반죽 = "붕어빵 반죽.png"
    case 팥 = "붕어빵 팥.png"
    case 뒤집기1 = "붕어빵 뒤집1.png"
    case 뒤집기2 = "붕어빵 뒤집2.png"
    case 뒤집기3 = "붕어빵 뒤집3.png"
    case 뒤집기4 = "붕어빵 뒤집4.png"
    case 뒤집기2가능 = "2가능"
    case 뒤집기3가능 = "3가능"
    case 뒤집기4가능 = "4가능"
    case 탐 = "붕어빵 탐"
    case 탄거확인 = "붕어빵 탐.png"
}
