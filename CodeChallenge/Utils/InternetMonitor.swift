import Foundation
import SystemConfiguration
import UIKit
import SVProgressHUD
import Alamofire

class InternetMonitor: NSObject {
    
    static let sharedInstance = InternetMonitor()
    fileprivate let reachabilityManager = Alamofire.NetworkReachabilityManager(host: "www.apple.com")
    fileprivate var isConnectedToNetwork: Bool = false
    
    func isConnectedToNetworkAtTheMoment() -> Bool {
        return isConnectedToNetwork
    }
    
    func startMonitoring() {
        self.reachabilityManager?.listener = { status in
            print("Network Status Changed: \(status)")
            switch status {
            case .notReachable:
                self.isConnectedToNetwork = false
                break
            case .reachable(_), .unknown:
                self.isConnectedToNetwork = true
                break
            }
            
            if !self.isConnectedToNetwork {
                SVProgressHUD.showError(withStatus: "You are Offline")
            }
            NotificationCenter.default.post(name: Notification.Name(rawValue: Constants.InternetStatus.StatusChanged), object: nil, userInfo: nil)
            
        }
        self.reachabilityManager?.startListening()
    }
}
