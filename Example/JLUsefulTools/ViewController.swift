//
//  ViewController.swift
//  JLUsefulTools
//
//  Created by 16658670 on 03/13/2023.
//  Copyright (c) 2023 16658670. All rights reserved.
//

import UIKit
import JLUsefulTools
import RxSwift

class ViewController: UIViewController {
    let input = JLEcInputView()
    private let fileCenterView = JLEcFileCenterView()
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let dataArr:[UInt8] = [0x01,0x02,0x03,0x04]
        let data = Data(bytes: dataArr, count: 4)
        input.configure(title: "title", placeholder: "placeholder")
        view.addSubview(input)
        input.snp.makeConstraints { make in
            make.top.equalTo(50)
            make.left.right.equalToSuperview()
            make.height.equalTo(40)
        }
    
        ECPrintInfo("dataL\(data.eHex)", self, "\(#function)", #line)
        // 添加到视图
        view.addSubview(fileCenterView)
        fileCenterView.snp.makeConstraints { make in
            make.top.equalTo(input.snp.bottom).offset(20)
            make.left.right.equalToSuperview()
            make.height.equalTo(30)
        }
        
        // 订阅导入结果
        fileCenterView.fileImported
            .subscribe(onNext: { url in
                print("用户选择的文件: \(url.path)")
            })
            .disposed(by: disposeBag)
        fileCenterView.webServerStarted
            .subscribe(onNext: { url in
                let urlString = url.absoluteString
                let alert = UIAlertController(title: "WEB服务已启动",
                                              message: "通过访问同一局域网内的此地址进行文件传输：\n\(urlString)",
                                              preferredStyle: .alert)

                alert.addAction(UIAlertAction(title: "复制地址", style: .default, handler: { _ in
                    UIPasteboard.general.string = urlString
                }))

                alert.addAction(UIAlertAction(title: "确定", style: .cancel, handler: nil))
                self.present(alert, animated: true, completion: nil)

            }).disposed(by: disposeBag)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

