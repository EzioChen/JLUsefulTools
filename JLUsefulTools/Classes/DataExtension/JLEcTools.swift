//
//  Tools.swift
//  JLBluetoothBasic
//
//  Created by EzioChan on 2021/8/26.
//  Copyright © 2021 Zhuhai Jieli Technology Co.，Ltd. All rights reserved.
//

import Foundation

@objc public class JLEcTimerHelper: NSObject {
    private static let shared = JLEcTimerHelper()
    private var timerDict: [String: Timer] = [:] 
    private var timerCompletions: [String: (String) -> Void] = [:] 
    private var timerRepeats: [String: Bool] = [:] 
    
    // MARK: - JLTimeOut 兼容方法
    private var countdownTimers: [String: (current: Int, max: Int, block: (JLEcTimerHelper)->Void)] = [:]
    
    @objc public func startCountdown(duration: Int, 
                                    onStart: @escaping ()->Void, 
                                    onTimeout: @escaping (JLEcTimerHelper)->Void) {
        let timerID = "countdown_\(UUID().uuidString)"
        
        countdownTimers[timerID] = (0, duration, onTimeout)
        
        let timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] timer in
            guard let self = self else {
                timer.invalidate()
                return
            }
            
            if var countdown = self.countdownTimers[timerID] {
                countdown.current += 1
                self.countdownTimers[timerID] = countdown
                
                if countdown.current >= countdown.max {
                    countdown.block(self)
                    timer.invalidate()
                    self.countdownTimers.removeValue(forKey: timerID)
                }
            }
        }
        
        timerDict[timerID] = timer
        onStart()
    }
    
    @objc public func resetCountdown() {
        for (timerID, _) in countdownTimers {
            if var countdown = countdownTimers[timerID] {
                countdown.current = 0
                countdownTimers[timerID] = countdown
            }
        }
    }
    
    @objc public func cancelCountdown() {
        for (timerID, _) in countdownTimers {
            timerDict[timerID]?.invalidate()
            timerDict.removeValue(forKey: timerID)
            countdownTimers.removeValue(forKey: timerID)
        }
    }
    
    // MARK: - JLEcTimerHelper 方法
    @discardableResult
    @objc public static func setTimeout(timeOut: Double, completion: @escaping (String) -> Void) -> String {
        let timerID = "timer_\(UUID().uuidString)"
        
        let timer = Timer.scheduledTimer(
            timeInterval: timeOut,
            target: shared,
            selector: #selector(timerAction(_:)),
            userInfo: timerID,
            repeats: false
        )
        
        shared.timerDict[timerID] = timer
        shared.timerCompletions[timerID] = completion
        shared.timerRepeats[timerID] = false
        return timerID
    }
    
    @discardableResult
    @objc public static func setInterval(interval: TimeInterval, completion: @escaping (String) -> Void) -> String {
        let timerID = "interval_\(UUID().uuidString)"
        
        let timer = Timer.scheduledTimer(
            timeInterval: interval,
            target: shared,
            selector: #selector(timerAction(_:)),
            userInfo: timerID,
            repeats: true
        )
        
        shared.timerDict[timerID] = timer
        shared.timerCompletions[timerID] = completion
        shared.timerRepeats[timerID] = true
        return timerID
    }
    
    @objc public static func clearTimeout(timerID: String) {
        stopTimer(timerID: timerID)
    }
    
    @objc public static func clearInterval(timerID: String) {
        stopTimer(timerID: timerID)
    }
    
    @objc public static func stopAllTimers() {
        for timerID in shared.timerDict.keys {
            stopTimer(timerID: timerID)
        }
        shared.cancelCountdown()
    }
    
    private static func stopTimer(timerID: String) {
        guard let timer = shared.timerDict[timerID] else { return }
        timer.invalidate()
        shared.timerDict.removeValue(forKey: timerID)
        shared.timerCompletions.removeValue(forKey: timerID)
        shared.timerRepeats.removeValue(forKey: timerID)
    }
    
    @objc private func timerAction(_ timer: Timer) {
        guard let timerID = timer.userInfo as? String else { return }
        
        if let completion = timerCompletions[timerID] {
            completion(timerID)
        }
        
        if let repeats = timerRepeats[timerID], !repeats {
            JLEcTimerHelper.stopTimer(timerID: timerID)
        }
    }
}



