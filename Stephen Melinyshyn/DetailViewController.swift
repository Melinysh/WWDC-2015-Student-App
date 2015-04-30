//
//  DetailViewController.swift
//  Stephen Melinyshyn
//
//  Created by Stephen Melinyshyn on 2015-04-14.
//  Copyright (c) 2015 Stevo Productions. All rights reserved.
//

import UIKit
import MapKit

class DetailViewController: UIViewController {
	
	@IBOutlet var imageView: UIImageView!
	@IBOutlet var textField: UITextView!
	@IBOutlet var mapView: MKMapView!
	@IBOutlet var animatedImage: UIImageView!
	@IBOutlet var extraImage1: UIImageView!
	@IBOutlet var extraImage2: UIImageView!
	@IBOutlet var extraButton: UIButton!
	@IBOutlet var extraButton2: UIButton!
	@IBOutlet var goBackButton: UIButton!
	
	var cardInfo : CardInfo!
	var webView : UIWebView?
	
	@IBAction func goBack(sender: AnyObject) {
		
		if let wV = self.webView {
			UIView.animateWithDuration(0.2, animations: { () -> Void in
				wV.alpha = 0
				}, completion: { (fin) -> Void in
					wV.removeFromSuperview()
					self.webView = nil
					
			})
			return
		}
		
		UIView.animateWithDuration(0.2, animations: { () -> Void in
			self.textField.alpha = 0
			//self.imageView.alpha = 0
			self.goBackButton.alpha = 0
			self.mapView?.alpha = 0
			self.animatedImage?.alpha = 0
			self.extraImage1?.alpha = 0
			self.extraImage2?.alpha = 0
			self.extraButton?.alpha = 0
			self.extraButton2?.alpha = 0
			}, completion: { (fin) -> Void in
				self.dismissViewControllerAnimated(true, completion: nil)
			})
	}
	
	@IBAction func extraButtonPressed(sender: AnyObject) {
		if let url = cardInfo.extraInfo["url"] as! String? {
			webView = UIWebView(frame: self.view.frame)
			webView!.loadRequest(NSURLRequest(URL: NSURL(string: url)!))
			webView!.alpha = 0
			self.view.insertSubview(webView!, belowSubview: self.goBackButton)
			UIView.animateWithDuration(0.2, animations: { () -> Void in
				self.webView!.alpha = 1
			})
		} else if let segueName = cardInfo.extraInfo["segue"] as! String? {
			self.performSegueWithIdentifier(segueName, sender: self)
		}
	}
	
	@IBAction func extraButton2Pressed(sender: AnyObject) {
		if let urlStr = cardInfo.extraInfo["url2"] as! String? {
			UIApplication.sharedApplication().openURL(NSURL(string: urlStr)!)
		}
		if let segueName = cardInfo.extraInfo["button2segue"] as! String? {
			self.performSegueWithIdentifier("segueName", sender: self)
		}
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view, typically from a nib. 
		
		self.textField.alpha = 0
		self.goBackButton.alpha = 0
		self.mapView?.alpha = 0
		self.animatedImage?.alpha = 0
		self.extraImage1?.alpha = 0
		self.extraImage2?.alpha = 0
		self.extraButton?.alpha = 0
		self.extraButton2?.alpha = 0
		
		self.becomeFirstResponder()
	}
	
	override func viewWillAppear(animated: Bool) { // do view configuring here as viewDidLoad is called upon custom init and before cardInfo is set
		self.view.backgroundColor = cardInfo.backgroundColor // need to modify view for textField to not be nil...?
		
		//setup data
		textField.selectable = false
		textField.textColor = cardInfo.textColor
		textField.text = cardInfo.info
		let bgC = CGColorGetComponents(self.view.backgroundColor!.CGColor)
		textField.backgroundColor = UIColor(red: bgC[0] * 0.8, green: bgC[1] * 0.8, blue: bgC[2] * 0.8, alpha: 1)
		textField.layer.cornerRadius = 5

		imageView.image = UIImage(named: cardInfo.imageName)
		imageView.contentMode = UIViewContentMode.ScaleAspectFit
		
		if cardInfo.specialStoryboard == "map" {
			let zoomLocation = CLLocationCoordinate2D(latitude: 44.2286091, longitude: -76.4837246)
			let viewRegion = MKCoordinateRegionMakeWithDistance(zoomLocation, 2009.344, 2009.344)
			mapView.setRegion(viewRegion, animated: true)
		} else if cardInfo.specialStoryboard == "animate" {
			var animation = CAKeyframeAnimation(keyPath: "position.x")
			animation.duration = 3.0
			animation.beginTime = CACurrentMediaTime()
			animation.repeatCount = HUGE
			let startPT = NSNumber(double: Double(animatedImage.frame.origin.x + 30.0))
			let endPT = NSNumber(double: Double(self.view.frame.width + 10 - animatedImage.frame.width/2))
			animation.values = [startPT, endPT, startPT]
			animation.removedOnCompletion = false
			animation.autoreverses = true
			animation.rotationMode = kCAAnimationLinear
			var rotation = CAKeyframeAnimation(keyPath: "transform.rotation")
			rotation.duration = 1.0
			rotation.repeatCount = HUGE
			rotation.fillMode = kCAFillModeForwards
			rotation.removedOnCompletion = false
			rotation.cumulative = true
			rotation.delegate = self
			let currentAngle =  Float(0.0)
			let a1 = currentAngle + (0.5 * Float(M_PI))
			let a2 = currentAngle + Float(M_PI)
			let angles : [NSNumber] = [
				NSNumber(float: currentAngle),
				NSNumber(float: a1),
				NSNumber(float: a2)
			]
			rotation.values = angles
			animatedImage.layer.addAnimation(rotation, forKey: "show")
			animatedImage.layer.addAnimation(animation, forKey: nil)
		} else if let imageNames = cardInfo.extraInfo["images"] as! [String]? {
			extraImage1.contentMode = UIViewContentMode.ScaleAspectFit
			extraImage2.contentMode = UIViewContentMode.ScaleAspectFit
			extraImage1.layer.cornerRadius = 8
			extraImage1.layer.masksToBounds = true
			extraImage2.layer.cornerRadius = 8
			extraImage2.layer.masksToBounds = true
			extraImage1.image = UIImage(named: imageNames[0])
			extraImage2.image = UIImage(named: imageNames[1])
		} else if let btnText = cardInfo.extraInfo["button1Text"] as! String? {
			extraButton.setTitle(btnText, forState: UIControlState.Normal)
			extraButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
			extraButton.backgroundColor = self.view.tintColor
			extraButton.layer.cornerRadius = 4.0
			extraButton.layer.masksToBounds = true
			if let btnText2 = cardInfo.extraInfo["button2Text"] as! String? {
				extraButton2.setTitle(btnText2, forState: .Normal)
				extraButton2.backgroundColor = self.view.tintColor
				extraButton2.setTitleColor(UIColor.whiteColor(), forState: .Normal)
				extraButton2.layer.cornerRadius = 4.0
				extraButton2.layer.masksToBounds = true
			}
		}
	}
	
	override func viewDidAppear(animated: Bool) {
		self.view.backgroundColor = cardInfo.backgroundColor //needed or else background is black :(
		
		self.textField.scrollRangeToVisible(NSRange(location: 0, length: 0))//for fixing textField scrolled down already bug on iphone 4S
		
		//animate
		UIView.animateWithDuration(0.05, animations: { () -> Void in
			self.textField.alpha = 0.01 // Seems for getting correct properties of textField it must be viewable.
			self.mapView?.alpha = 0.01
		}) { (fin) -> Void in
			if self.textField.contentSize.height < self.textField.frame.height {
				let change =  self.textField.frame.size.height - self.textField.contentSize.height
				self.textField.frame.size.height -= change  //if text can fit in smaller frame, make that the new frame
				self.mapView?.frame.size.height += change //for the one view, make the map scale up.
				self.mapView?.frame.origin = CGPoint(x: self.mapView.frame.origin.x, y: self.mapView.frame.origin.y - change)
			}
			UIView.animateWithDuration(0.2, animations: { () -> Void in
				self.textField.alpha = 1
				self.goBackButton.alpha = 1
				self.mapView?.alpha = 1
				self.animatedImage?.alpha = 1
				self.extraImage1?.alpha = 1
				self.extraImage2?.alpha = 1
				self.extraButton?.alpha = 1
				self.extraButton2?.alpha = 1
				
				self.imageView.layer.cornerRadius = 0
				})
		}
		
	}
	
	override func prefersStatusBarHidden() -> Bool {
		return true
	}
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
	
	override func viewDidLayoutSubviews() {
		/* Scales UITextView's height down to text height if it needs to
		UIView.animateWithDuration(0.1, animations: { () -> Void in
		var moddedTextFrame = self.textField.frame
		moddedTextFrame.size.height = self.textField.contentSize.height
		if moddedTextFrame.size.height < self.textField.frame.size.height {
		self.textField.frame.size = moddedTextFrame.size
		}
		}) */
		
	}
	
}

