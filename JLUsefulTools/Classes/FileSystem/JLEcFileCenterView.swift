//
//  JLEcFileCenterView.swift
//  JLUsefulTools
//
//  Created by EzioChan on 2025/8/22.

import UIKit
import SnapKit
import RxSwift
import RxCocoa
import FileBrowser
import GCDWebServer
import MobileCoreServices
import UniformTypeIdentifiers

open class JLEcFileCenterView: UIView {
    
    private let disposeBag = DisposeBag()
    
    // 对外暴露文件选择/导入事件
    public let fileImported = PublishSubject<URL>()
    
    public let webServerStarted = PublishSubject<URL>()
    
    private var webServer: GCDWebServer?
    
    /// 主按钮
    private lazy var actionButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("文件中心", for: .normal)
        btn.titleLabel?.font = .systemFont(ofSize: 18, weight: .medium)
        return btn
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        bindActions()
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        addSubview(actionButton)
        actionButton.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
    
    private func bindActions() {
        actionButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.showActionSheet()
            })
            .disposed(by: disposeBag)
    }
    
    /// 弹出操作菜单
    private func showActionSheet() {
        guard let vc = UIApplication.shared.keyWindow?.rootViewController else { return }
        
        let sheet = UIAlertController(title: "文件中心", message: "请选择操作", preferredStyle: .actionSheet)
        
        sheet.addAction(UIAlertAction(title: "从文件导入", style: .default, handler: { [weak self] _ in
            self?.presentDocumentPicker(from: vc)
        }))
        
        sheet.addAction(UIAlertAction(title: "浏览文件", style: .default, handler: { [weak self] _ in
            let browser = FileBrowser()
            vc.present(browser, animated: true)
        }))
        
        sheet.addAction(UIAlertAction(title: "开启 WiFi 传输", style: .default, handler: { [weak self] _ in
            self?.startWebServer()
        }))
        
        sheet.addAction(UIAlertAction(title: "取消", style: .cancel, handler: nil))
        
        vc.present(sheet, animated: true)
    }
    
    /// 文件选择器
    private func presentDocumentPicker(from vc: UIViewController) {
        let picker: UIDocumentPickerViewController
        if #available(iOS 14.0, *) {
            picker = UIDocumentPickerViewController(forOpeningContentTypes: [UTType.item])
        } else {
            picker = UIDocumentPickerViewController(documentTypes: [kUTTypeItem as String], in: .import)
        }
        picker.allowsMultipleSelection = false
        picker.delegate = self
        vc.present(picker, animated: true)
    }
    
    /// 开启 WiFi 文件传输
    private func startWebServer() {
        webServer = GCDWebServer()
        
        // 简单 HTML 页面
        let html = """
        <!DOCTYPE html>
        <html lang="zh-CN">
        <head>
        <meta charset="UTF-8">
        <title>文件上传</title>
        <style>
            body {
                font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, Helvetica, Arial, sans-serif;
                background-color: #f4f4f9;
                display: flex;
                flex-direction: column;
                align-items: center;
                justify-content: center;
                height: 100vh;
                margin: 0;
            }
            h1 {
                color: #333;
                margin-bottom: 24px;
            }
            form {
                background: #fff;
                padding: 24px;
                border-radius: 12px;
                box-shadow: 0 4px 12px rgba(0,0,0,0.1);
                display: flex;
                flex-direction: column;
                align-items: center;
            }
            input[type="file"] {
                margin-bottom: 16px;
            }
            input[type="submit"] {
                padding: 10px 20px;
                border: none;
                border-radius: 8px;
                background-color: #007AFF;
                color: #fff;
                font-size: 16px;
                cursor: pointer;
            }
            input[type="submit"]:hover {
                background-color: #005BBB;
            }
        </style>
        </head>
        <body>
        <h1>上传文件到设备</h1>
        <form action="/upload" method="POST" enctype="multipart/form-data">
            <input type="file" name="file" />
            <input type="submit" value="上传" />
        </form>
        </body>
        </html>

        """
        
        webServer?.addHandler(forMethod: "GET", path: "/", request: GCDWebServerRequest.self) { _ in
            return GCDWebServerDataResponse(html: html)
        }
        
        webServer?.addHandler(forMethod: "POST", path: "/upload", request: GCDWebServerMultiPartFormRequest.self) { [weak self] request, completion in
            guard let multipartRequest = request as? GCDWebServerMultiPartFormRequest,
                  let filePart = multipartRequest.firstFile(forControlName: "file") else {
                completion(GCDWebServerResponse(statusCode: 400))
                return
            }
            
            let tempURL = URL(fileURLWithPath: filePart.temporaryPath)
            let destURL = FileManager.default.temporaryDirectory.appendingPathComponent(filePart.fileName)
            try? FileManager.default.moveItem(at: tempURL, to: destURL)
            
            self?.fileImported.onNext(destURL)
            completion(GCDWebServerDataResponse(text: "上传成功"))
        }
        
        try? webServer?.start(options: [
            GCDWebServerOption_Port: 8080,
            GCDWebServerOption_AutomaticallySuspendInBackground: false
        ])
        
        print("访问地址: \(webServer?.serverURL?.absoluteString ?? "")")
        
        webServerStarted.onNext(webServer?.serverURL ?? URL(string: "http://localhost:8080")!)
    }
}

extension JLEcFileCenterView: UIDocumentPickerDelegate {
    public func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        if let url = urls.first {
            fileImported.onNext(url)
        }
    }
}

