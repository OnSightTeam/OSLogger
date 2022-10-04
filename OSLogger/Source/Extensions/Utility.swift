//
//  Utility.swift
//  OSLogger
//
//  Created by OnSightTeam on 04.10.2022.
//

import Foundation
import UIKit

extension UIDevice {
    
    /// Notification name used for handle shake notificaiton event
    static let deviceDidShakeNotification = Notification.Name(rawValue: "deviceDidShakeNotification")
}

extension UIWindow {
    
    /// Method overrides motion event method for handle shake notification in logger framework.
    ///
    /// - Parameters:
    ///   - motion: motion event type
    ///   - event: triggered event object
     open override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        if motion == .motionShake {
            /// Post shake notification
            NotificationCenter.default.post(name: UIDevice.deviceDidShakeNotification, object: nil)
        }
     }
    
    /// Property loads key window.
    /// On iOS 13 because of using scenes it has custom implementation
    static var key: UIWindow? {
        if #available(iOS 13, *) {
            return UIApplication.shared.connectedScenes
                .filter( { $0.activationState == .foregroundActive } )
                .compactMap( {$0 as? UIWindowScene} )
                .first?.windows
                .filter( {$0.isKeyWindow} ).first
        } else {
            return UIApplication.shared.keyWindow
        }
    }
}

extension UIViewController {
    
    /// The method find most top view controller on screen.
    /// Method used in cases when no able cases for finding presenter screen
    /// - Returns: The view controller object
    func topMostViewController() -> UIViewController {
        if self.presentedViewController == nil {
            return self
        }
        if let navigation = self.presentedViewController as? UINavigationController {
            return navigation.visibleViewController!.topMostViewController()
        }
        if let tab = self.presentedViewController as? UITabBarController {
            if let selectedTab = tab.selectedViewController {
                return selectedTab.topMostViewController()
            }
            return tab.topMostViewController()
        }
        return self.presentedViewController!.topMostViewController()
    }
}

extension UIApplication {
    
    /// The method used category method of ``UIWindow`` and ``UIViewController`` for finding most top controller
    /// - Returns: The view controller object.
    func topMostViewController() -> UIViewController? {
        return UIWindow.key!.rootViewController?.topMostViewController()
    }
}

extension FileManager {
    
    /// The property used for build app document directory URL
    static var documentDirectoryURL: URL {
        `default`.urls(for: .documentDirectory, in: .userDomainMask)[0]
    }
    
    /// The property used for build app cache directory URL in Library folder
    static var cacheDirectoryURL: URL {
        `default`.urls(for: .cachesDirectory, in: .userDomainMask)[0]
    }
}

extension Date {
    
    /// The method converts date instance to the string by custom format.
    ///
    /// By default used format `yyyy-MM-dd [hh:mm:ss]`
    ///
    /// ```swift
    /// let currentDate = Date()
    /// let dateString = currentDate.toString()
    /// ```
    ///
    /// For using custom format:
    ///
    /// ```swift
    /// let currentDate = Date()
    /// let dateString = currentDate.toString(format: "dd-MM-yyy")
    /// ```
    /// - Parameter format: The custom date format string.
    /// - Returns: The string interpolation of the date object.
    func toString(format: String = "yyyy-MM-dd [hh:mm:ss]") -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.dateFormat = format
        return formatter.string(from: self)
    }
}
