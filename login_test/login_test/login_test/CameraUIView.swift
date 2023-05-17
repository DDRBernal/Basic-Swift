//
//  CameraUIView.swift
//  login_test
//
//  Created by david on 17/05/2023.
//

import SwiftUI

struct CameraUIView: View {
    
    //Image picker
    @State private var sourceType: UIImagePickerController.SourceType = .photoLibrary
    @State private var selectedImage: UIImage?
    @State private var isImagePickerDisplay = false
    
    var body: some View {
        VStack {
            if selectedImage != nil {
                Image(uiImage: selectedImage!)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .clipShape(Circle())
                    .frame(width: 300, height: 300)
            } else {
                Image(systemName: "snow")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .clipShape(Circle())
                    .frame(width: 300, height: 300)
            }
            Button("Camera") {
                self.sourceType = .camera
                self.isImagePickerDisplay.toggle()
            }.padding()
            Button("photo") {
                self.sourceType = .photoLibrary
                self.isImagePickerDisplay.toggle()
            }.padding()
        }.navigationBarTitle("Demo")
        .sheet(isPresented: self.$isImagePickerDisplay) {
            ImagePickerView(selectedImage: self.$selectedImage, sourceType: self.sourceType)
        }
    }//
    
}

struct CameraUIView_Previews: PreviewProvider {
    static var previews: some View {
        CameraUIView()
    }
}
