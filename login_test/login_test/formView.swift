//
//  formView.swift
//  login_test
//
//  Created by david on 15/05/2023.
//
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
            }
        }.onChange(of: name, perform: { _ in
            validateForm() // Call the validation function whenever the name changes
        })
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
