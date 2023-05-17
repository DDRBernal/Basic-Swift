//
//  KeysUIView.swift
//  login_test
//
//  Created by david on 16/05/2023.
//

import SwiftUI
import Security

struct KeysUIView: View {
    
    @State private var pairKeys : [[CFString: Any]] = []
    
    var body: some View {
            VStack {
                Text("Key Pair Attributes:")
                    .font(.headline)
                List(pairKeys.indices, id: \.self) { index in
                ForEach(Array(pairKeys[index].keys), id: \.self) { key in
                    HStack {
                        Text("\(key)")
                            .fontWeight(.bold)
                        Spacer()
                        Text("\(String(describing: pairKeys[index][key]))")
                    }
                }
            }
                
            }
            .onAppear {
                generateRSAKeyPairAndStoreInKeychain()
            }
        }

    func generateRSAKeyPairAndStoreInKeychain() {
        let privateKeyAttr: [CFString: Any] = [
            kSecAttrIsPermanent: true,
            kSecAttrApplicationTag: "com.example.privatekey",
            kSecAttrKeyType: kSecAttrKeyTypeRSA,
            kSecAttrKeySizeInBits: 2048
        ]
        
        let publicKeyAttr: [CFString: Any] = [
            kSecAttrIsPermanent: true,
            kSecAttrApplicationTag: "com.example.publickey",
            kSecAttrKeyType: kSecAttrKeyTypeRSA,
            kSecAttrKeySizeInBits: 2048
        ]
        
        let keyPairAttr: [CFString: Any] = [
            kSecAttrKeyType: kSecAttrKeyTypeRSA,
            kSecAttrKeySizeInBits: 2048,
            kSecPrivateKeyAttrs: privateKeyAttr,
            kSecPublicKeyAttrs: publicKeyAttr
        ]
        
        var publicKey: SecKey?
        var privateKey: SecKey?
        
        let status = SecKeyGeneratePair(keyPairAttr as CFDictionary, &publicKey, &privateKey)
        
        guard status == errSecSuccess, let generatedPublicKey = publicKey, let generatedPrivateKey = privateKey else {
            print("Failed to generate RSA key pair: \(status)")
            return
        }
        
        pairKeys.append(keyPairAttr)
        pairKeys.append(privateKeyAttr)
        pairKeys.append(publicKeyAttr)
        
        // Store the keys in the Keychain
        
        let publicKeyAddQuery: [CFString: Any] = [
            kSecClass: kSecClassKey,
            kSecAttrKeyType: kSecAttrKeyTypeRSA,
            kSecAttrApplicationTag: "com.example.publickey",
            kSecValueRef: generatedPublicKey,
            kSecReturnPersistentRef: true
        ]
        
        let privateKeyAddQuery: [CFString: Any] = [
            kSecClass: kSecClassKey,
            kSecAttrKeyType: kSecAttrKeyTypeRSA,
            kSecAttrApplicationTag: "com.example.privatekey",
            kSecValueRef: generatedPrivateKey,
            kSecReturnPersistentRef: true
        ]
        
        var publicKeyPersistentRef: CFTypeRef?
        var privateKeyPersistentRef: CFTypeRef?
        
        let publicKeyStatus = SecItemAdd(publicKeyAddQuery as CFDictionary, &publicKeyPersistentRef)
        let privateKeyStatus = SecItemAdd(privateKeyAddQuery as CFDictionary, &privateKeyPersistentRef)
        
        guard publicKeyStatus == errSecSuccess, privateKeyStatus == errSecSuccess else {
            print("Failed to store RSA keys in Keychain: \(publicKeyStatus), \(privateKeyStatus)")
            return
        }
        
        print("RSA keys generated and stored in Keychain successfully.")
    }

}

struct KeysUIView_Previews: PreviewProvider {
    static var previews: some View {
        KeysUIView()
    }
}
