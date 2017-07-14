//
//  ViewController.swift
//  SecureTest
//
//  Created by Alexander v. Below on 13.07.17.
//  Copyright © 2017 Alexander von Below. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var inputField: UITextField!
    @IBOutlet weak var keyField: UITextField!
    @IBOutlet weak var resultField: UITextField!
    
    @IBAction func calculateHash(_ sender: Any) {
        let signature = UnsafeMutablePointer<CUnsignedChar>.allocate(capacity: Int(CC_SHA256_DIGEST_LENGTH))
        defer { signature.deallocate(capacity: Int(CC_SHA256_DIGEST_LENGTH)) }
        
        let input = inputField.text ?? ""
        let keyInput = keyField.text ?? ""
        
        let data = input.data(using: .utf8)!
        let key = keyInput.data(using: .utf8)!
        data.withUnsafeBytes { dataBytes in
            key.withUnsafeBytes { keyBytes in
                CCHmac(CCHmacAlgorithm(kCCHmacAlgSHA256), keyBytes, key.count, dataBytes, data.count, signature)
            }
        }
        
        let result = Data(bytes: signature, count: Int(CC_SHA256_DIGEST_LENGTH))
        
        var resultString = ""
        for x in result {
            resultString = resultString.appendingFormat("%02X", x)
        }
        resultField.text = resultString
    }
}

