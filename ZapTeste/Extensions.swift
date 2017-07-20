//
//  Extensions.swift
//  ZapTeste
//
//  Created by Rodrigo Kreutz on 9/3/16.
//  Copyright © 2016 Rodrigo Kreutz. All rights reserved.
//

import UIKit

extension UIImageView {
    func downloadedFrom(link: String, contentMode: UIViewContentMode?) {
        guard let url = NSURL(string: link) else { return }
        NSURLSession.sharedSession().dataTaskWithURL(url) { (data, response, error) in
            guard let data = data, let image = UIImage(data: data)
                else {
                    dispatch_async(dispatch_get_main_queue()) {
                        self.contentMode = .ScaleAspectFit
                        self.image = UIImage(named: "image")
                    }
                    return
            }
            dispatch_async(dispatch_get_main_queue()) {
                if let contentMode = contentMode {
                    self.contentMode = contentMode
                } else {
                    self.contentMode = .ScaleAspectFill
                }
                self.image = image
            }
            }.resume()
    }
}
