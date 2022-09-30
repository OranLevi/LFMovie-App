//
//  Extension.swift
//  LFMovieApp
//
//  Created by Oran on 01/08/2022.
//

import UIKit

extension UIImageView {
    
    func getImage(path: String) async {
        guard let url = URL(string: "https://image.tmdb.org/t/p/w500\(path)") else {
            return
        }
        let request = URLRequest(url: url, cachePolicy: URLRequest.CachePolicy.returnCacheDataElseLoad, timeoutInterval: TimeInterval(10))
        
        let (data, _) = try! await URLSession.shared.data(for: request)
        if let image = UIImage(data: data) {
            self.image = image
        }
    }
}

extension UIViewController {
    func hideKeyboardOnTapOnView()
    {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(UIViewController.dismissKeyboard))

        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }

    @objc func dismissKeyboard()
    {
        view.endEditing(true)
    }
}
