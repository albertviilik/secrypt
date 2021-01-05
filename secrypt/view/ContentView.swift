//
//  ContentView.swift
//  secrypt
//
//  Created by Albert Viilik on 04/01/2021.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var appModel = AppModel()
    
    var body: some View {
        VSplitView {
            Toggle(isOn: $appModel.mode) {
                Label(appModel.mode ? "Encrypt" : "Decrypt", systemImage: appModel.mode ? "lock" : "key")
            }.frame(width: 400)
            SecureField("Secret key", text: $appModel.encryptionKey)
            Text("Decrypted")
            TextEditor(text: $appModel.plaintext)
            Text("Encrypted")
            TextEditor(text: $appModel.encoded)
        }
        .frame(width: 400, height: 600, alignment: .center)
    }
    
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
