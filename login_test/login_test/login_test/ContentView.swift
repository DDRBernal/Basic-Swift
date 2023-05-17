import SwiftUI

struct ContentView: View{
    @State private var username=""
    @State private var password=""
    @State private var wrongUsername = 0.0
    @State private var wrongPassword = 0.0
    @State private var showingLoginScreen = false
    
    var body: some View{
        NavigationView{
            ZStack {
                Color.blue.ignoresSafeArea()
                Circle().scale(1.7).foregroundColor(.white.opacity(0.15))
                Circle().scale(1.3).foregroundColor(.white)
                //Login text and input
                VStack{
                    Text("Login").font(.largeTitle).bold().padding()
                    TextField("Username",text:$username).padding().frame(width: 300,height: 50)
                        .background(Color.black.opacity(0.05)).cornerRadius(10)
                        .border(.red,width: wrongUsername)
                    SecureField("Password",text:$password).padding().frame(width: 300,height: 50)
                        .background(Color.black.opacity(0.05)).cornerRadius(10)
                        .border(.red,width: wrongPassword)
                    Button("Login"){
                        authenticateUser(username: username, password: password)
                    }.foregroundColor(.white).frame(width: 300,height: 50).background(Color.blue).cornerRadius(10)
                    
                    NavigationLink(destination: formView(),
                                   isActive: $showingLoginScreen){
                                   EmptyView()
                    }
                }
            }.navigationBarHidden(true)
        }
    }
    
    func authenticateUser(username: String, password: String){
        if (username.lowercased()=="admin"){
            wrongUsername = 0
            if(password.lowercased()=="admin"){
                wrongPassword = 0
                showingLoginScreen = true
            } else{ wrongPassword=2 }
        }else{
            wrongUsername=2
        }
    }
    
    
    
}



struct ContentView_Previews: PreviewProvider{
    static var previews: some View{
        ContentView()
    }
}
