//
//  MasterViewController.swift
//  Stephen Melinyshyn
//
//  Created by Stephen Melinyshyn on 2015-04-14.
//  Copyright (c) 2015 Stevo Productions. All rights reserved.
//

import UIKit

enum cardModification {
	case needToAlter
	case needToUnalter
	case finished
}

class MasterViewController: UIViewController {
	
	
	var viewsAndRotations = [CardView : CGFloat]() // can remove cards from this
	var cardViews = [CardView]() // don't remove cards from this.
	var cardInfos = [CardInfo]() // don't remove the card data from this
	
	@IBOutlet var panGestureRecognizer: UIPanGestureRecognizer!
	var animator : UIDynamicAnimator!
	var attachmentBehavior : UIAttachmentBehavior!
	var snapBehavior : UISnapBehavior!
	var cardFrame : CGRect!
	var cardIsDropping  = false
	let cardCornerRadius = CGFloat(20)
	var didReturnFromTransition = false
	let mainQueue = dispatch_get_main_queue()
	let detailTransitionDelegate = DetailTransitionDelegate()
	let cardModel = CardData()
	let progressIndicator = UIProgressView(progressViewStyle: UIProgressViewStyle.Bar)
	var topCardImage : UIImageView!
	var firstCardMofication = cardModification.needToAlter
	var increment : Float!
	
	@IBOutlet var undoButton: UIButton!
	@IBOutlet var resetButton: UIButton!
	
	@IBAction func panDetected(sender: AnyObject) {
		if self.view.subviews.count < 5 || (self.view.subviews.last! is CardView == false) { // will change if more views are added to self.view
			return
		}
		let card = self.view.subviews.last! as! CardView
		let location = sender.locationInView(view)
		let boxLocation = sender.locationInView(card)
		if sender.state == UIGestureRecognizerState.Began {
			animator.removeBehavior(attachmentBehavior)
			let centerOffset = UIOffsetMake(boxLocation.x - CGRectGetMidX(card.bounds), boxLocation.y - CGRectGetMidY(card.bounds))
			attachmentBehavior = UIAttachmentBehavior(item: card, offsetFromCenter: centerOffset, attachedToAnchor: location)
			animator.addBehavior(attachmentBehavior)
		} else if sender.state == UIGestureRecognizerState.Changed {
			attachmentBehavior.anchorPoint = location
		} else if sender.state == UIGestureRecognizerState.Ended {
			animator.removeBehavior(attachmentBehavior)
			snapBehavior = UISnapBehavior(item: card, snapToPoint: view.center)
			animator.addBehavior(snapBehavior)
			
			let translation = sender.translationInView(view)
			if abs(translation.y) > 100 || abs(translation.x) > 100 {
				cardIsDropping = true //fixes issue of topCard on tap being the one that drops
				card.userInteractionEnabled = false
				animator.removeAllBehaviors()
				var gravity = UIGravityBehavior(items: [card])
				gravity.gravityDirection = CGVectorMake(translation.x/15, translation.y/15) //pulled in the direction of the swipe
				animator.addBehavior(gravity)
				
				UIView.animateKeyframesWithDuration(0.1, delay: 0.3, options: UIViewKeyframeAnimationOptions.allZeros, animations: { () -> Void in
					card.alpha = 0
					}, completion: { (fin) -> Void in
						card.removeFromSuperview()
						self.cardIsDropping = false
						self.animator.removeAllBehaviors()
						let newProgress = Float(1.0) / Float(self.cardViews.count) + self.progressIndicator.progress
						self.progressIndicator.setProgress(newProgress, animated: true)
						self.viewsAndRotations.removeValueForKey(card)
					
						if self.viewsAndRotations.count == 0 { //no more cards to show, so present option to restart
							var alert = UIAlertController(title: "You're all done!", message: "Go back to the start?", preferredStyle: UIAlertControllerStyle.Alert)
							let yes = UIAlertAction(title: "Yes", style: UIAlertActionStyle.Cancel, handler: { (a) -> Void in
								self.reset(self)
							})
							let no = UIAlertAction(title: "No, thanks", style: .Default, handler: nil)
							alert.addAction(yes)
							alert.addAction(no)
							self.presentViewController(alert, animated: true, completion: nil)
							return
						}
						var newTopCard = self.view.subviews.last! as! UIView
						UIView.animateWithDuration(0.3, animations: { () -> Void in
							newTopCard.center = self.view.center
							self.undoButton.alpha = 1
						})
						self.snapBehavior = UISnapBehavior(item: newTopCard, snapToPoint: self.view.center)
						self.animator.addBehavior(self.snapBehavior)
						self.view.backgroundColor = newTopCard.backgroundColor
						self.progressIndicator.tintColor = newTopCard.backgroundColor
						println("There are \(self.view.subviews.count) subviews left.")
				})
				
			}
		}
	}
	
	@IBAction func reset(sender: AnyObject) {
		for card in self.viewsAndRotations.keys {
			card.removeFromSuperview()
		}
		self.viewsAndRotations.removeAll(keepCapacity: false)
		cardViews = cards()
		progressIndicator.setProgress(0.0, animated: true)
		dropCards(cardViews) // can't use dictonary keys because they dont have order
		UIView.animateWithDuration(0.3, animations: { () -> Void in
			self.undoButton.alpha = 0
		})
	}
	
	@IBAction func undo(sender: AnyObject) {
		let pos = viewsAndRotations.count
		if pos > cardViews.count-1 { //make sure index isn't out of range
			return
		}
		var card = cardViews[pos]
		viewsAndRotations[card] = CGFloat(0)
		card.frame = CGRect(x: 50, y: 150, width: self.view.frame.width - 100, height: self.view.frame.height - 300) //restoring these two properties b/c when card is expanded, they lose them
		card.layer.cornerRadius = cardCornerRadius
		UIView.animateWithDuration(0.01, animations: { () -> Void in
			card.transform = CGAffineTransformMakeScale(1.35, 1.35)
			card.alpha = 0.8
		})
		progressIndicator.setProgress(progressIndicator.progress - self.increment, animated: true)
		self.progressIndicator.tintColor = card.backgroundColor
		dropCards([card])
		
		if self.viewsAndRotations.keys.array.count == self.cardViews.count { //at start of card deck
			UIView.animateWithDuration(0.3, animations: { () -> Void in
				self.undoButton.alpha = 0
			})
		}
	}
	override func awakeFromNib() {
		super.awakeFromNib()
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view, typically from a nib.
		self.cardFrame = CGRect(x: 50, y: 150, width: self.view.frame.width - 100, height: self.view.frame.height - 300)
		animator = UIDynamicAnimator(referenceView: view)
		progressIndicator.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: progressIndicator.frame.height + 20)
		view.insertSubview(progressIndicator, atIndex: 1)
	}
	
	override func viewDidAppear(animated: Bool) {
		if didReturnFromTransition == false {
			cardViews = cards()
			increment = Float(1.0) / Float(cardViews.count)
			dropCards(cardViews) // can't use dictonary keys because they dont have order
			UIView.animateWithDuration(0.3, animations: { () -> Void in
				self.undoButton.alpha = 0
			})
			

		} else { //just returned from the transition
			var topCard = view.subviews[view.subviews.count-2] as! CardView //since there is another uiimageview on top, get 2nd last subview
			
			// undo the detail view transition animations
			UIView.animateWithDuration(0.3, animations: { () -> Void in
				topCard.frame = self.cardFrame
				self.topCardImage.frame = CGRect(x: 0, y: 0, width: self.cardFrame.width, height: self.cardFrame.width * (2.0/3.0))
				self.topCardImage.frame.origin = self.cardFrame.origin
				topCard.layer.cornerRadius = self.cardCornerRadius
				//self.topCardImage.layer.cornerRadius = self.cardCornerRadius
				topCard.layer.shadowOpacity = 1
				}, completion: { (fin) -> Void in
					topCard.imageView.alpha = 1
					self.topCardImage.removeFromSuperview() //remove image placed before animated transition
					UIView.animateWithDuration(0.2, animations: { () -> Void in
						topCard.label.alpha = 1
					})
					
					if self.firstCardMofication == cardModification.needToUnalter { //last step in guiding the user after launch
						UIView.animateWithDuration(0.3, animations: { () -> Void in
							topCard.label.text = "Now swipe this card away!"
						})
						self.firstCardMofication = cardModification.finished
					}
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
	
	
	// MARK: - Segues
	
	override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
		
	}
	
	// MARK: - Card Methods
	func dropCards(var cards : [CardView]) {
		if let card = cards.first {
			if cards.count == 1 {
				self.viewsAndRotations[card] = CGFloat(0)
				self.view.backgroundColor = card.backgroundColor
			}
			
			self.view.addSubview(card)
			//add autolayout
			cardConstraints(card)

			//	card.layoutIfNeeded()
			UIView.animateWithDuration(0.30, delay: 0.0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.7, options: UIViewAnimationOptions.CurveEaseIn, animations: { () -> Void in
				card.alpha = 1
				card.transform = CGAffineTransformConcat(CGAffineTransformMakeRotation(self.viewsAndRotations[card]!), CGAffineTransformMakeScale(1, 1))
				}, completion: { (finished) -> Void in
					let delay = 0.2 * (1.0 - (Float(1)/Float(cards.count)))
					println("Delay is:\(delay)")
					NSThread.sleepForTimeInterval(NSTimeInterval(delay))
					cards.removeAtIndex(0)
					self.dropCards(cards)
					
					if cards.count == 0 && self.firstCardMofication == cardModification.needToAlter { // first step in guiding the user for the first time
						var c = self.view.subviews.last! as! CardView
						UIView.animateWithDuration(0.4, delay: 2.8, options: UIViewAnimationOptions.allZeros, animations: { () -> Void in
							c.label.text = c.label.text! + " Tap this card to learn more!"

						}, completion: nil)
						self.firstCardMofication = cardModification.needToUnalter
					}
			})
		}
	}
	
	
	func cards() -> [CardView] {
		var cardsArray = [CardView]()
		cardInfos = self.cardModel.allCardInfo()
		for var i = 0; i < cardInfos.count; i++ {
			let card = generateCard(cardInfos[i])
			cardsArray.append(card)
		}
		return cardsArray
	}
	
	func generateCard(cInfo : CardInfo) -> CardView {
		var card = UINib(nibName: "View", bundle: nil).instantiateWithOwner(CardView(), options: nil).first! as! CardView
		card.setup(cInfo, cornerRad: cardCornerRadius, target: self)
		viewsAndRotations[card] = randomAngle()
		return card
	}
	
	func randomAngle() -> CGFloat {
		var angle : Float = Float(arc4random_uniform(10)) // in degress
		
		if arc4random() % 2 == 1 { //50% chance of negative angle.
			angle = -angle
		}
		//convert angle into radians
		angle *= (Float(M_PI) / Float(180))
		return CGFloat(angle)
	}
	
	func cardConstraints(card: CardView) {
		let Vconstraints = NSLayoutConstraint.constraintsWithVisualFormat("V:|-offset-[card]-offset-|", options: NSLayoutFormatOptions.allZeros, metrics: ["offset": self.view.frame.height/7], views: ["card" : card])
		let Hconstraints = NSLayoutConstraint.constraintsWithVisualFormat("H:|-offset-[card]-offset-|", options: NSLayoutFormatOptions.allZeros, metrics: ["offset": self.view.frame.width/10], views: ["card" : card])
		self.view.addConstraints(Vconstraints + Hconstraints)
	}
	
	func showDetail(sender : AnyObject)  {
		
		if cardIsDropping { return }
		if let card = view.subviews.last as? CardView{
			
			let cInfo = cardInfos[self.view.subviews.count-5]
			
			// setup a uiimageview to animate instead of the one on the card
			topCardImage = UIImageView(image: UIImage(named: cInfo.imageName))
			topCardImage.frame = card.imageView.frame
			topCardImage.frame.origin = card.frame.origin
			topCardImage.layer.cornerRadius = card.imageView.layer.cornerRadius
			topCardImage.layer.masksToBounds = true
			self.view.insertSubview(topCardImage, aboveSubview: card)

			
			var detailVC  = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("DetailViewControllerID") as! DetailViewController
			
			//allows for a special version of the detail vc to come in
			if let requestedStoryboard = cInfo.specialStoryboard {
				detailVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier(requestedStoryboard) as! DetailViewController
			}
			
			self.cardFrame = card.frame //important: used to set card back to original, autolayed frame.
			
			UIView.animateWithDuration(0.05, animations: { () -> Void in
				card.label.alpha = 0
				card.imageView.alpha = 0 // just so some images won't been seen below topCardImage during scale animations
				}, completion: { (finished) -> Void in
					UIView.animateWithDuration(0.3, animations: { () -> Void in
						self.topCardImage.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.width * (2.0/3.0))
						card.frame = self.view.frame
						card.layer.shadowOpacity = 0
					}, completion: { (f) -> Void in
						UIView.animateWithDuration(0.1, animations: { () -> Void in
							card.layer.cornerRadius = 0
						}, completion: { (fin) -> Void in
							detailVC.transitioningDelegate = self.detailTransitionDelegate
							detailVC.modalPresentationStyle = UIModalPresentationStyle.Custom
							detailVC.cardInfo = cInfo
							self.presentViewController(detailVC, animated: true, completion: nil)
						})
				})
			})
		}
	}
}

