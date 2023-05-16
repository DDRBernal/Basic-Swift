//
//  ActivityViewController.swift
//  login_test
//
//  Created by david on 16/05/2023.
//
import UIKit
import SwiftUI

struct ActivityViewController: UIViewControllerRepresentable {
    
    var activityItems: [Any]
    var applicationActivities: [UIActivity]? = nil
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<ActivityViewController>) -> UIActivityViewController {
        let controller = UIActivityViewController(activityItems: activityItems, applicationActivities: applicationActivities)
        
        // Customize the activities included in the UIActivityViewController
        let excludedActivities: [UIActivity.ActivityType] = [
            .addToReadingList,
            .assignToContact,
            .openInIBooks,
            .postToFacebook,
            .postToTwitter,
            .postToVimeo,
            .postToFlickr,
            .postToTencentWeibo,
            .postToWeibo,
            .saveToCameraRoll
        ]
        
        controller.excludedActivityTypes = excludedActivities
        
        return controller
    }
    
    func updateUIViewController(_ uiViewController: UIActivityViewController, context: UIViewControllerRepresentableContext<ActivityViewController>) {}
}
