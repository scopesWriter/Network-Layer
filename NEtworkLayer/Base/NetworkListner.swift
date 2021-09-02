//
//  NetworkListner.swift
//  Banoon
//
//  Created by bishoy on 26/11/2020.
//


import UIKit
import Network

class NetworkManager {
    
    let monitor = NWPathMonitor()
    static let shared = NetworkManager()
    
    
    //MARK: used to listen to network state
    func listen(){
        
        let queue = DispatchQueue(label: "Monitor")
        monitor.start(queue: queue)
    }
    
    func configureVC(vc:UIViewController){
        
//        monitor.pathUpdateHandler = { path in
//            if path.status == .satisfied {
//                print("We're connected!")
//            } else {
//                print("No connection.")
//                DispatchQueue.main.async{
//                    vc.present(vc.create(storyboardName: "Home", viewController: "NetworkFailedVC", presentationStyle: .fullScreen), animated: true, completion: nil)
//                }
//            }
//            print(path.isExpensive)
//        }
    }
    
}

