//
//  imageViewController.swift
//  Cassini
//
//  Created by Ryan on 2015/4/6.
//  Copyright (c) 2015年 Ryan. All rights reserved.
//

import UIKit

class ImageViewController: UIViewController, UIScrollViewDelegate {
  
  @IBOutlet weak var spinner: UIActivityIndicatorView!
  
  @IBOutlet weak var scrollView: UIScrollView! {
    didSet {
      scrollView.contentSize = imageView.frame.size
      // you can set delegate eather by code or in storyboard
      scrollView.delegate = self
      scrollView.minimumZoomScale = 0.03
      scrollView.maximumZoomScale = 1.0
    }
  }
  
  // model
  var imageURL: NSURL? {
    didSet {
      image = nil
      if view.window != nil {
        fetchImage()
      }
    }
  }
  
  private var imageView = UIImageView()
  
  private var image: UIImage? {
    get { return imageView.image}
    set {
      // I want do something everytime setting the image
      imageView.image = newValue
      // Change the bounds in image view
      imageView.sizeToFit()
      
      // Every time the image changeing, you need to change the content size of scroll view    
      // 有可能在設定image時 scrollView outlet還沒被設定
      scrollView?.contentSize = imageView.frame.size
      spinner?.stopAnimating()
    }
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    //view.addSubview(imageView)
    scrollView.addSubview(imageView)
    
//    if image == nil {
//      imageURL = DemoURL.Stanford
//    }
  }
  
  override func viewWillAppear(animated: Bool) {
    
    super.viewWillAppear(animated)
    
    if image == nil {
      fetchImage()
    }
  }
  
  
  private func fetchImage() {
    if let url = imageURL {
      
      spinner?.startAnimating()
      let qos = Int(QOS_CLASS_USER_INITIATED.value)
      dispatch_async(dispatch_get_global_queue(qos, 0)) { () -> Void in
        
        let imageData = NSData(contentsOfURL: url)
        
        
        // 因為沒有任何 pointer 指到此closure，因此裡面寫self沒關係
        dispatch_async(dispatch_get_main_queue()) { () -> Void in
          if url == self.imageURL {
            if imageData != nil {
              self.image = UIImage(data: imageData!)
            } else {
              self.image = nil
            }
          }
        }
      }
      

    }
  }
  
  // MARK: UIScrollView Delefate
  func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
    return imageView
  }

}
