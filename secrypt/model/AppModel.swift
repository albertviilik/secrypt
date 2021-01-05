//
//  AppModel.swift
//  secrypt
//
//  Created by Albert Viilik on 04/01/2021.
//

import Foundation
import CryptoKit

class AppModel: ObservableObject {
    @Published var mode = true
    @Published var plaintext: String {
        didSet {
            print("Changed plaintext \(oldValue) to \(plaintext)")
            if (mode && plaintext.count > 0 && encryptionKey.count > 0) {
                self.encoded = encrypt(toEncrypt: plaintext, encryptionKey: encryptionKey)
            }
        }
    }
    @Published var encoded: String {
        didSet {
            if (!mode && encoded.count > 0 && encryptionKey.count > 0) {
                self.plaintext = decrypt(toDecrypt: encoded, encryptionKey: encryptionKey)
            }
        }
    }
    @Published var encryptionKey: String {
        didSet {
            print("Changed ecnryptionKey \(oldValue) to \(encryptionKey)")
            if (mode && plaintext.count > 0 && encryptionKey.count > 0) {
                self.encoded = encrypt(toEncrypt: plaintext, encryptionKey: encryptionKey)
            }
            if (!mode && encoded.count > 0 && encryptionKey.count > 0) {
                self.plaintext = decrypt(toDecrypt: encoded, encryptionKey: encryptionKey)
            }
        }
    }
    
    
    init() {
        self.plaintext = ""
        self.encoded = ""
        self.encryptionKey = ""
    }
    
    func encrypt(toEncrypt: String, encryptionKey: String) -> String {
        let symmetricKey: SymmetricKey = SymmetricKey(data: SHA256.hash(data: Data(encryptionKey.utf8)))
        guard let sealed = try? AES.GCM.seal(Data(toEncrypt.utf8), using: symmetricKey) else {
            return ""
        }
        guard let combinedData = sealed.combined else {
            return ""
        }
        
        return combinedData.base64EncodedString()
    }
    
    func decrypt(toDecrypt: String, encryptionKey: String) -> String {
        let symmetricKey: SymmetricKey = SymmetricKey(data: SHA256.hash(data: Data(encryptionKey.utf8)))
        guard let combinedData = Data(base64Encoded: toDecrypt) else {
            return ""
        }
        
        guard let sealed = try? AES.GCM.SealedBox(combined: combinedData) else {
            return ""
        }
        
        guard let unsealed = try? AES.GCM.open(sealed, using: symmetricKey) else {
            return ""
        }
        
        return String(decoding: unsealed, as: UTF8.self)
    }
}
