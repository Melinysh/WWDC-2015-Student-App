//
//  CardView.swift
//  Stephen Melinyshyn
//
//  Created by Stephen Melinyshyn on 2015-04-14.
//  Copyright (c) 2015 Stevo Productions. All rights reserved.
//

import UIKit

class CardView: UIView {
	
	/*
	// Only override drawRect: if you perform custom drawing.
	// An empty implementation adversely affects performance during animation.
	override func drawRect(rect: CGRect) {
	// Drawing code
	}*/
	
	
	
	@IBOutlet var label: UILabel!
	@IBOutlet var imageView: UIImageView!
	
	
	private var tap : UITapGestureRecognizer!
	private var text : String!
	private var imageName : String!
	private var cornerRad :CGFloat!
	private var target :AnyObject!
	
	override func awakeFromNib() {
		super.awakeFromNib()
	}
	
	func setup(data : CardInfo, cornerRad : CGFloat, target : AnyObject) {
		label.text = data.eventName
		imageView.image = UIImage(named: data.imageName)
		self.backgroundColor = data.backgroundColor
		self.label.textColor = data.textColor
		imageView.layer.cornerRadius = cornerRad
		imageView.contentMode = UIViewContentMode.ScaleAspectFill
		imageView.clipsToBounds = true
		
		self.setTranslatesAutoresizingMaskIntoConstraints(false)
		tap = UITapGestureRecognizer(target: target, action: "showDetail:")
		self.addGestureRecognizer(tap)
		self.layer.shadowColor = UIColor.blackColor().CGColor
		self.layer.shadowOpacity = 0.8
		self.layer.shadowRadius = 4
		self.layer.shadowOffset = CGSize(width: 3.0, height: 4.0)
		self.layer.drawsAsynchronously = true
		self.layer.shadowPath = UIBezierPath(roundedRect: self.bounds, cornerRadius: self.layer.cornerRadius).CGPath
		UIView.animateWithDuration(0.01, animations: { () -> Void in
			self.transform = CGAffineTransformMakeScale(1.35, 1.35)
			self.alpha = 0.7
		})
		self.layer.cornerRadius = cornerRad
		
	}
	
	
	override func layoutSubviews() {
		super.layoutSubviews()
		self.layer.shadowPath = UIBezierPath(roundedRect: self.bounds, cornerRadius: self.layer.cornerRadius).CGPath
	}
}

