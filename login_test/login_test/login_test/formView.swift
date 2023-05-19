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
    @State private var isShareSheetPresented = false
    
    var body: some View {
        TabView{
        Form {
            Section(header: Text("Settings camera")) {
                VStack {
                    Spacer()
                    NavigationLink(
                        destination: CameraUIView(),
                        isActive: $sendForm,
                        label: {
                            Image(systemName: "camera")
                                .renderingMode(.original)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 18, height: 18)
                                .padding()
                            Text("Camera")
                                .font(.headline)
                                .fontWeight(.bold)
                                .foregroundColor(.black)
                        }
                    ).frame(height: 1)
                    Spacer().frame(height: 50)
                    
                    NavigationLink(
                        destination: ScannerQRView(),
                        isActive: $sendForm,
                        label: {
                            Image(systemName: "camera")
                                .renderingMode(.original)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 18, height: 18)
                                .padding()
                            Text("Scanner")
                                .font(.headline)
                                .fontWeight(.bold)
                                .foregroundColor(.black)
                        }
                    ).frame(height: 1)
                    Spacer()
                }.navigationBarTitle("Home")
            }
            
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
                VStack {
                    Button("Check QR") {
                        sendFormButton()
                    }.disabled(!isFormValid) //If form is not valid disable the button
                    NavigationLink(destination: KeysUIView(),
                                   isActive: $sendForm){
                        EmptyView()
                    }
                    
                }
                VStack{
                    TextField("Here will appears the API result", text: $api_result)
                    if api_button_clicked{
                        Text("clicked").foregroundColor(.green)
                    }else{
                        Button(action:{api_call(method: "get")}){
                            Text("Get API test Json")
                        }
                    }
                }
            };
            Section(header: Text("Share Section"),
                    footer:
                        HStack {
                Spacer()
                Label("version 1.0",
                      systemImage: "iphone")
                Spacer()
            }) {
                VStack {
                    Button(action: {
                        isShareSheetPresented = true
                    }) {
                        Image(systemName: "square.and.arrow.up")
                            .imageScale(.large)
                            .foregroundColor(.blue)
                    }
                    .padding(10)
                    .background(Color.white)
                    .clipShape(Circle())
                    .shadow(radius: 2)
                    .alignmentGuide(.trailing, computeValue: { _ in
                        UIScreen.main.bounds.width - 30
                    })
                    .sheet(isPresented: $isShowingActivityView, content: {
                        ActivityViewController(activityItems: [image!])
                    })
                    Text("Share image")
                }
                
            }
            
        }//end form
        .onChange(of: name, perform: { _ in
            validateForm() // Call the validation function whenever the name changes
        })//This part will creates the tab bar below the app
            .tabItem{Label("Account Settings", systemImage: "gear")}
                //Another tab
                Text("Second Tab Content")
                .tabItem{
                    //Here is the image of the icon that appears in tab bar
                    Label("App Settings",systemImage: "square.and.pencil")
                }
                //Here below it contains the content of the tab
                VStack {
                    Button(action: {
                        isShareSheetPresented = true
                    }) {
                        Image(systemName: "square.and.arrow.up")
                            .imageScale(.large)
                            .foregroundColor(.blue)
                    }
                    .padding(10)
                    .background(Color.white)
                    .clipShape(Circle())
                    .shadow(radius: 2)
                    .alignmentGuide(.trailing, computeValue: { _ in
                        UIScreen.main.bounds.width - 30
                    })
                    .sheet(isPresented: $isShowingActivityView, content: {
                        ActivityViewController(activityItems: [image!])
                    })
                    Text("Share image")
                }//
                .tabItem{
                    Label("Share content",systemImage: "gear")
                }
                
        }
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

struct ShareSheet: UIViewControllerRepresentable {
    var activityItems: [Any]
    
    func makeUIViewController(context: Context) -> UIActivityViewController {
        let controller = UIActivityViewController(activityItems: activityItems, applicationActivities: nil)
        return controller
    }
    
    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {}
}

