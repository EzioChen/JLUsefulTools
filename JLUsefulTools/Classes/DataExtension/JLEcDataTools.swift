//
//  DataTools.swift
//  JLUsefulTools
//
//  Created by EzioChan on 2021/9/3.
//

import Foundation

public extension Data {
    
    /// 获取UInt8值(小端序)
    var eUint8: UInt8 {
        withUnsafeBytes { $0.load(as: UInt8.self) }
    }
    
    /// 获取UInt16值(小端序)
    var eUint16: UInt16 {
        guard count >= MemoryLayout<UInt16>.size else { return 0 }
        return withUnsafeBytes { $0.load(as: UInt16.self) }
    }
    
    /// 获取Bool值
    var eBool: Bool {
        eUint8 != 0
    }
    
    /// 获取UInt32值(小端序)
    var eUint32: UInt32 {
        guard count >= MemoryLayout<UInt32>.size else { return 0 }
        return withUnsafeBytes { $0.load(as: UInt32.self) }
    }
    
    /// 获取Int8值(小端序)
    var eint_8: Int {
        Int(eUint8)
    }
    
    /// 获取Int16值(大端序)
    var eInt16BigEndian: Int {
        Int(eUint16.byteSwapped)
    }
    
    /// 获取Int16值(小端序)
    var eInt16LittleEndian: Int {
        Int(eUint16)
    }
    
    /// 获取自然数Int8值(考虑符号位)
    var eInt8Nature: Int {
        let byte = eUint8
        return byte >> 7 == 0 ? Int(byte) : -Int(0xFF - byte + 1)
    }
    
    /// 获取自然数Int16值(考虑符号位)
    var eInt16Nature: Int {
        let byte = eUint16
        return byte >> 15 == 0 ? Int(byte) : -Int(0xFFFF - byte + 1)
    }
    
    /// 获取自然数Int32值(考虑符号位)
    var eInt32Nature: Int {
        let byte = eUint32
        return byte >> 31 == 0 ? Int(byte) : -Int(0xFFFFFFFF - byte + 1)
    }
    
    /// 反转字节顺序
    var eSwapSelf: Data {
        Data([UInt8](self).reversed())
    }
    
    /// 转换为16进制字符串(大写)
    var eHex: String {
        map { String(format: "%02X", $0) }.joined()
    }
    
    /// 转换为字符串
    var eString: String {
        String(decoding: self, as: UTF8.self)
    }
    
    /// 在数据前添加一个字节
    func eNS(num: UInt8) -> Data {
        [num] + self
    }
    
    /// 获取子数据
    func eSubRange(_ location: Int, _ len: Int) -> Data? {
        guard location + len <= count, len > 0 else { return nil }
        return self[location..<location+len]
    }
    
    /// 数据分段
    func sections(_ len: Int) -> [Data] {
        stride(from: 0, to: count, by: len).map {
            eSubRange($0, Swift.min(len, count - $0)) ?? Data()
        }
    }
    
    /// 获取从指定位置开始的数据
    func ebeginOf(_ index: Int) -> Data? {
        guard index <= count else { return nil }
        return self[index...]
    }
    
    /// 获取到指定位置结束的数据
    func eEndOf(_ index: Int) -> Data? {
        guard index <= count else { return nil }
        return self[..<index]
    }

    func eAppendUInt8(_ num:UInt8) -> Data {
        self+num.eToByteData
    }
    
    /// 创建Bool类型数据
    static func eBoolData(status: Bool) -> Data {
        Data([status ? 0x01 : 0x00])
    }
}

public extension UInt8{
    var eToByteData:Data{
        Data(bytes: [self], count: 1)
    }
}

public extension UInt16{
    var eToByteData:Data {
        var int = self
        return Data(bytes: &int, count: MemoryLayout<UInt16>.size)
    }
}

public extension UInt32 {
    var data: Data {
        var int = self
        return Data(bytes: &int, count: MemoryLayout<UInt32>.size)
    }
    var beByteDate:Date {
        let s = self & 0x3F
        let m = (self>>6)&0x3F
        let h = (self>>12)&0x1F
        let day = (self>>17)&0x1f
        let mon = (self>>22)&0xf
        let year = ((self>>26)&0x3f)+2010
        let str = String(Int(year))+"-"+String(Int(mon))+"-"+String(Int(day))+" "+String(Int(h))+":"+String(Int(m))+":"+String(Int(s))
        let fm = DateFormatter()
        fm.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let dte = fm.date(from: str) ?? Date()
        return dte
    }
}


public extension Date {
    var ebeByte4Data:Data {
        let fm = DateFormatter()
        fm.dateFormat = "yyyy-MM-dd-HH-mm-ss"
        let strArr = fm.string(from: self).components(separatedBy: "-")
        var u32:UInt32 = 0x00
        let year = UInt32(Int(strArr[0])!-2010)<<26
        let month = UInt32(strArr[1])!<<22
        let day = UInt32(strArr[2])!<<17
        let HH = UInt32(strArr[3])!<<12
        let mm = UInt32(strArr[4])!<<6
        let ss = UInt32(strArr[5])!
        u32 =  u32|year|month|day|HH|mm|ss
        return u32.data
    }
}


public extension Bool {
    var eData:Data {
        if self {
            let v:[UInt8] = [0x01]
            return Data(bytes:v , count: 1)
        }else{
            let v:[UInt8] = [0x00]
            return Data(bytes:v , count: 1)
        }
    }
    var rawValue:UInt8{
        if self {
            return 0x01
        }else{
            return 0x00
        }
    }
}

open class DataTools: NSObject {
    //1bytes转Int
  public class func ez_1BytesToInt(data:Data) -> Int {
         var value : UInt8 = 0
         let data = NSData(bytes: [UInt8](data), length: data.count)
         data.getBytes(&value, length: data.count)
         value = UInt8(littleEndian: value)
         return Int(value)
     }
     
     //2bytes转Int
    public class func ec_2BytesToInt(data:Data) -> Int {
         var value : UInt16 = 0
         let data = NSData(bytes: [UInt8](data), length: data.count)
         data.getBytes(&value, length: data.count)
         value = UInt16(bigEndian: value)
         return Int(value)
     }
     
     //4bytes转Int
    public class func ec_4BytesToInt(data:Data) -> Int {
         var value : UInt32 = 0
         let data = NSData(bytes: [UInt8](data), length: data.count)
         data.getBytes(&value, length: data.count)
         value = UInt32(bigEndian: value)
         return Int(value)
     }
    
}

public extension String{
    
    /// HexString to Data
    var beData:Data{
        let bytes = self.bytes(from: self)
        return Data(bytes: bytes, count: bytes.count)
    }
    // 将16进制字符串转化为 [UInt8]
    // 使用的时候直接初始化出 Data
    // Data(bytes: Array<UInt8>)
    func bytes(from hexStr: String) -> [UInt8] {
        assert(hexStr.count % 2 == 0, "输入字符串格式不对，8位代表一个字符")
        var bytes = [UInt8]()
        var sum = 0
        // 整形的 utf8 编码范围
        let intRange = 48...57
        // 小写 a~f 的 utf8 的编码范围
        let lowercaseRange = 97...102
        // 大写 A~F 的 utf8 的编码范围
        let uppercasedRange = 65...70
        for (index, c) in hexStr.utf8CString.enumerated() {
            var intC = Int(c.byteSwapped)
            if intC == 0 {
                break
            } else if intRange.contains(intC) {
                intC -= 48
            } else if lowercaseRange.contains(intC) {
                intC -= 87
            } else if uppercasedRange.contains(intC) {
                intC -= 55
            } else {
                assertionFailure("输入字符串格式不对，每个字符都需要在0~9，a~f，A~F内")
            }
            sum = sum * 16 + intC
            // 每两个十六进制字母代表8位，即一个字节
            if index % 2 != 0 {
                bytes.append(UInt8(sum))
                sum = 0
            }
        }
        return bytes
    }
    
    
}

public extension NSObject{
    
    /// 打印所有属性的值
    @discardableResult func printfAllPropertys()->String{
        let mirro = Mirror(reflecting: self)
        var pkgStr = ""
        for item in mirro.children {
            let name = item.label ?? "unKnow"
            var str = " \(name):\(item.value)"
            if let dt = item.value as? Data {
                str = " \(name):\(dt.eHex)"
            }
            pkgStr.append(str+"\n")
        }
        return pkgStr
    }
}

public extension Array where Element == UInt8 {
    var data:Data{
        Data(bytes: self, count: self.count)
    }
}

