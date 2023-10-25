//
//  BasicViewController.swift
//  IPCLink
//
//  Created by EzioChan on 2023/4/10.
//  Copyright © 2023 Zhuhai Jieli Technology Co.,Ltd. All rights reserved.
//

import UIKit
import RxSwift

@objcMembers open class BasicViewController: UIViewController {

    open var navigationView = NaviView()
    open var disposeBag = DisposeBag()
    open var canNotPushBack:Bool = false
    open var bgColor = UIColor.eHex("#FFFFFF")
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(navigationView)
        view.backgroundColor = bgColor
        let window = UIApplication.shared.keyWindow
        navigationView.snp.makeConstraints { make in
            make.top.equalTo(self.view.snp.top).inset(0)
            make.height.equalTo(44+(window?.safeAreaInsets.top ?? 0)+20)
            make.left.right.equalTo(view).inset(0)
        }
        
        initData()
        initUI()
      
    }
    
    open override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(
          self,
          selector: #selector(willEnterForeground(_:)),
          name: UIApplication.willEnterForegroundNotification,
          object: nil)
        NotificationCenter.default.addObserver(
          self,
          selector: #selector(didBecomeActive(_:)),
          name: UIApplication.didBecomeActiveNotification,
          object: nil)
        NotificationCenter.default.addObserver(
          self,
          selector: #selector(willEnterForeground(_:)),
          name: UIApplication.willResignActiveNotification,
          object: nil)
        NotificationCenter.default.addObserver(
          self,
          selector: #selector(willEnterForeground(_:)),
          name: UIApplication.willTerminateNotification,
          object: nil)
        NotificationCenter.default.addObserver(
          self,
          selector: #selector(willEnterForeground(_:)),
          name: UIApplication.didEnterBackgroundNotification,
          object: nil)
        
    }
    
    open override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: UIApplication.willEnterForegroundNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIApplication.didBecomeActiveNotification, object: nil)
        if canNotPushBack{
            self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        }
    }
    
    open override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if canNotPushBack{
            self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        }
    }
    
  
    
    public func initUI(){
    
    }
    
    public func initData(){
        
    }
    
    
    @objc public func didBecomeActive(_ noti:Notification){
        
    }
    @objc  public func willEnterForeground(_ noti:Notification){
        
    }


}


final class DeviceOrientation {
    
    static let shared: DeviceOrientation = DeviceOrientation()
    
    // MARK: - Private methods
    
    @available(iOS 13.0, *)
    private var windowScene: UIWindowScene? {
        return UIApplication.shared.connectedScenes.first as? UIWindowScene
    }
    
    // MARK: - Public methods
    
    func set(orientation: UIInterfaceOrientationMask) {
        if #available(iOS 16.0, *) {
            windowScene?.requestGeometryUpdate(.iOS(interfaceOrientations: orientation))
        } else {
            UIDevice.current.setValue(orientation.toUIInterfaceOrientation.rawValue, forKey: "orientation")
        }
    }
    
    var isLandscape: Bool {
        if #available(iOS 16.0, *) {
            return windowScene?.interfaceOrientation.isLandscape ?? false
        }
        return UIDevice.current.orientation.isLandscape
    }
    
    var isPortrait: Bool {
        if #available(iOS 16.0, *) {
            return windowScene?.interfaceOrientation.isPortrait ?? false
        }
        return UIDevice.current.orientation.isPortrait
    }
    
    var isFlat: Bool {
        if #available(iOS 16.0, *) {
            return false
        }
        return UIDevice.current.orientation.isFlat
    }
}

extension UIInterfaceOrientationMask {
    var toUIInterfaceOrientation: UIInterfaceOrientation {
        switch self {
        case .portrait:
            return UIInterfaceOrientation.portrait
        case .portraitUpsideDown:
            return UIInterfaceOrientation.portraitUpsideDown
        case .landscapeRight:
            return UIInterfaceOrientation.landscapeRight
        case .landscapeLeft:
            return UIInterfaceOrientation.landscapeLeft
        default:
            return UIInterfaceOrientation.unknown
        }
    }
}
