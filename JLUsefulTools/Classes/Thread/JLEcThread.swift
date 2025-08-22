//
//  JLECThread.swift
//  JLUsefulTools
//
//  Created by EzioChan on 2021/9/1.
//

import Foundation

@objc public class JLECThread: NSObject {
    
    public typealias actions = ()->Void
    /// 异步执行
    /// - Parameter task: 内容
    /// - Returns: 执行句柄（可用于中途停止）
    @discardableResult public static func eAsync(_ task:@escaping actions)->DispatchWorkItem{
        _eAsync(task)
    }
    
    /// 异步执行
    /// - Parameters:
    ///   - task: 内容
    ///   - mainTask: 主线程内容
    /// - Returns: 执行句柄（可用于中途停止）
    @discardableResult public static func eAsync(_ task:@escaping actions,_ mainTask:@escaping actions)->DispatchWorkItem{
        _eAsync(task, mainTask)
    }
    
    
    /// 延时执行
    /// - Parameters:
    ///   - second: 时间
    ///   - block: 执行内容
    /// - Returns: 执行句柄（可用于中途停止）
    @discardableResult public static func eDelay(_ second:Double,_ block:@escaping actions)->DispatchWorkItem{
        let item = DispatchWorkItem(block: block)
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+second, execute: item)
        return item
    }
    
    //MARK:- For Objective-C
    /// 延时执行
    /// - Parameters:
    ///   - second: 时间
    ///   - block: 执行内容
    @objc public static func eDelay(_ second:Double,_ block:@escaping actions){
        let item = DispatchWorkItem(block: block)
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+second, execute: item)
    }
    /// 异步执行
    /// - Parameters:
    ///   - task: 内容
    ///   - mainTask: 主线程内容
    @objc public static func eAsync(_ task:@escaping actions,_ mainTask:@escaping actions){
       _ = _eAsync(task, mainTask)
    }
    /// 异步执行
    /// - Parameter task: 内容
    @objc public static func eAsync(_ task:@escaping actions){
        _ = _eAsync(task)
     }
    
    
    private static func _eAsync(_ task:@escaping actions,_ mainTask:actions? = nil)->DispatchWorkItem{
        let item  = DispatchWorkItem(block: task)
        DispatchQueue.global().async(execute: item)
        if let main = mainTask {
            item.notify(queue: DispatchQueue.main, execute: main)
        }
        return item
    }

}


public struct EasyStack<T> {
    var elements = [T]()
    private var working:T?
    mutating func push(_ element:T){
        elements.append(element)
    }
    mutating func pop() {
        if (elements.count > 0) {
            elements.removeFirst()
        }
    }
    mutating func top()->T?{
        working = elements.first
        return elements.first
    }
    func size()->Int{
        elements.count
    }
    func workingItem()->T?{
        working
    }
    mutating func removeAll(){
        working = nil
        elements.removeAll()
    }
}
