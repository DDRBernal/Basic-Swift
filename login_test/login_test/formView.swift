//
//  formView.swift
//  login_test
//
//  Created by david on 15/05/2023.
//

import UIKit
import SwiftUI
import CodeScanner

struct formView: View {
    
    @State var isNetworkOn: Bool = false
    @State var name: String = ""
    @State var favoriteColor: Color = Color.blue
    @State var birthday: Date = Date()
    @State var numDevices: Float = 1.0
    @State var contactMessage: String = ""
    @State var isFormValid: Bool = false
    @State var sendForm: Bool = false
    @State var api_result: String = ""
    @State var api_button_clicked: Bool = false
    @State private var isSharePresented: Bool = false
    @State private var isShowingActivityView = false
    @State private var sharingContent = "Hello, World!"
    @State private var image: UIImage? = UIImage(named: "image.jpg")
    //Image picker
    @State private var sourceType: UIImagePickerController.SourceType = .photoLibrary
    @State private var selectedImage: UIImage?
    @State private var isImagePickerDisplay = false
    
    var body: some View {
        Form {
            Section(header: Text("Settings")) {
                TextField("Device Name", text: $name)
                if (name.isEmpty && !isFormValid){
                    Text("Device name is required").foregroundColor(.red)
                }
                Toggle("Wi-Fi", isOn: $isNetworkOn)
                if (!isNetworkOn){
                    Text("Wifi must be on").foregroundColor(.red)
                }
                Button("Share") {
                            isShowingActivityView = true
                        }
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .padding()
                        .sheet(isPresented: $isShowingActivityView, content: {
                            ActivityViewController(activityItems: [image!])
                        })
            }
            
            Section(header: Text("Account")) {
                DatePicker("Birthday",
                           selection: $birthday)
                ColorPicker("Favorite Color",
                            selection: $favoriteColor)
                Stepper("Number of devices: \(Int(numDevices))",
                        value: $numDevices)
            }
            
            Section(header: Text("Contact"),
                    footer:
                        HStack {
                            Spacer()
                            Label("version 1.0",
                                  systemImage: "iphone")
                            Spacer()
            }) {
                TextEditor(text: $contactMessage)
                HStack {
                    Spacer()
                    Button("Send") {
                        sendFormButton()
                    }.disabled(!isFormValid) //If form is not valid disable the button
                    NavigationLink(destination: ScannerQRView(),
                                   isActive: $sendForm){
                        EmptyView()
                    }
                }
                VStack{
                    TextField("asd", text: $api_result)
                    if api_button_clicked{
                        Text("clicked").foregroundColor(.green)
                    }else{
                        Button(action:{api_call(method: "get")}){
                            Text("press")
                        }
                    }
                }
            }
        }.onChange(of: name, perform: { _ in
            validateForm() // Call the validation function whenever the name changes
        })
    }
    
    /*
       This function call an test web site to call an api with method GET
     */
    private func api_call(method: String) {
        //https://jsonplaceholder.typecode.com/posts/1
        if (method.lowercased()=="get"){
            guard let url = URL(string: "https://jsonplaceholder.typicode.com/posts/1") else{
                return
            }
            let task = URLSession.shared.dataTask(with: url){
                data, response, error in
                
                if let data = data, let string = String(data: data, encoding: .utf8){
                    print(string)
                    api_result+=string
                }
            }
            
            task.resume()
        }else if (method.lowercased()=="post"){
            let url = URL(string: "https://jsonplaceholder.typecode.com/posts")!
            var request = URLRequest(url: url)
            request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
            request.setValue("application/json", forHTTPHeaderField: "Accept")
            request.httpMethod = "POST"
            let parameters: [String: Any] = [
                "id": 13,
                "name": "Jack & Jill"
            ]
            /*
            request.httpBody = parameters.percentEncoded()

            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                guard
                    let data = data,
                    let response = response as? HTTPURLResponse,
                    error == nil
                else {                                                               // check for fundamental networking error
                    print("error", error ?? URLError(.badServerResponse))
                    return
                }
                
                guard (200 ... 299) ~= response.statusCode else {                    // check for http errors
                    print("statusCode should be 2xx, but is \(response.statusCode)")
                    print("response = \(response)")
                    return
                }
                
                // do whatever you want with the `data`, e.g.:
                
                do {
                    let responseObject = try JSONDecoder().decode(ResponseObject<Foo>.self, from: data)
                    print(responseObject)
                } catch {
                    print(error) // parsing error
                    
                    if let responseString = String(data: data, encoding: .utf8) {
                        print("responseString = \(responseString)")
                    } else {
                        print("unable to parse response as string")
                    }
                }
            }

            task.resume()
             */
            
            
        }
        
    }
    
    
    
    private func sendFormButton(){
        if (isFormValid){ sendForm=true;}
    }
    
    private func validateForm() {
        // Perform your validation checks here
        print(name)
        isFormValid = !name.isEmpty && isNetworkOn
    }
    
}
