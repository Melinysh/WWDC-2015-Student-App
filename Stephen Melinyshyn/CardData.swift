//
//  CardData.swift
//  Stephen Melinyshyn
//
//  Created by Stephen Melinyshyn on 2015-04-14.
//  Copyright (c) 2015 Stevo Productions. All rights reserved.
//

import UIKit

struct CardInfo {
	var imageName : String!
	var info : String!
	var eventName : String
	var backgroundColor : UIColor!
	var textColor : UIColor!
	var id : Int!
	var specialStoryboard : String?
	var extraInfo : [String : AnyObject]!
	init(img: String, detail : String, name : String, bcC : UIColor, tC : UIColor, index : Int, storyboard : String?, extraInfoDict : [String : AnyObject]) {
		imageName = img
		info = detail
		eventName = name
		backgroundColor = bcC
		textColor = tC
		id = index
		specialStoryboard = storyboard
		extraInfo = extraInfoDict
	}
}

class CardData: NSObject {
	
	let storyboards : [String?] = [
		nil, //me
		"map", //ktown
		"animate", //jville
		nil, //queens
		"images", // python & c
		"images", // lss
		"button", //mitm
		"button2", //rez
		"button", //Sweatervest
		"images", //this app
		"images", //waterloo
		nil // Me
		
	]
	
	
	let extraStuff : [[String : AnyObject]] = [
		[String : AnyObject](), //me
		[String : AnyObject](), //ktown
		[String : AnyObject](), //jville
		[String : AnyObject](), //queens
		["images" : ["rpiLogo", "rpi"]], // python & c
		["images" : ["SteveLss", "lss-thumbnail"]], // lss
		["button1Text" : "See on Github", "url" : "https://github.com/Melinysh/mitmconfig"], //mitm
		["button1Text" : "Play Tapz", "segue": "ToTapz", "button2Text" : "See Rez Reader", "url2" : "itms-apps://itunes.apple.com/us/app/rez-reader/id918257334?ls=1&mt=8"], //rez
		["button1Text" : "See Sweatervest.club", "url" : "https://sweatervest.club"], // Sweatervest
		["images" : ["swift", "objc"]], //this app
		["images" : ["", "waterlooThumb"]], //waterloo
		[String : AnyObject]() // Me
	]
	
	
	
	let backgroundColors : [UIColor] = [
		color(64, 20, 20), //me
		color(73, 98, 115), //ktown
		color(108, 0, 61), //jville
		color(218, 0, 0), //queens
		color(1, 127, 10), // python & c
		color(217, 206, 56), // lss
		color(73, 73, 73), //mitm
		color(127, 18, 135), //rez
		color(65, 71, 70), // Sweatervest
		color(43, 88, 142), //this app
		color(244, 224, 127), //waterloo
		color(34, 43, 99) // Me
	]
	
	let textColors = [
		color(224, 224, 224), //me
		color(255, 255, 255), //ktown
		color(244, 244, 244), //jville
		color(255, 255, 255), //queens
		color(237, 237, 237), // python & c
		color(0, 0, 0), // lss
		color(30, 255, 0), //mitm
		color(255, 255, 255), //rez
		color(240, 240, 240), // Sweatervest
		color(255, 255, 255), //this app
		color(15, 15, 14), //waterloo
		color(254, 254, 254) // Me
	]
	
	let images = [ "me1", "kingston", "jville", "queensESU", "pc", "lss", "mitm", "rez", "sweatervest", "wwdc","waterloo", "me2"]
	
	let eventNames = [
		"Welcome!",
		"Kingston: Where I Was Born",
		"Joyceville: My Elementary School",
		"Queen's University: My First Programming Experience",
		"My First, Independent Programs",
		"LaSalle Secondary: My High School",
		"High School Programming: #1 MITM Configurator",
		"High School Programming: #2 Rez Reader",
		"High School Programming: #3 Sweatervest.club",
		"High School Programming: #4 This  One!",
		"What's Next: University",
		"What's Next: For Me"]
	
	let descriptions = [
		"Welcome to my WWDC App Submission! I'm an 18 year old Canadian with a passion for computer science. I have yet to have any formal education in programming, but my own curiosity and persistence has driven me to explore and experiment with code. I developed this app to inform you about what I've done, what I'm currently doing, and what I want to do in the future!",
		"I was born in 1997, in Kingston Ontario. Kingston is a small town of 123,000 people residing on the northern shore of Lake Ontario. I will have lived here for 18 years when I leave for university this fall.",
		"From Kindergarten through Grade 8 I attended Joyceville Public School. Here, I played on my school's volleyball team for three years. Upon my Grade 8 graduation, I received awards for top achievement in Math, Science, French and Leadership. I was 13 and attending Joyceville when I was first introduced to programming... To find out more about that, check out the next card!",
		"Each year, Queen's University in Kingston offers academically inclined Grade 7 and 8 students the chance to explore interesting subjects with the assistance of undergraduate students through their 'ESU' program. I took part in the 2-day robotics and programming course in 2010. I thoroughly enjoyed my time building robots and experimenting with code for the first time. This experience opened my eyes to the wider realm of computing, beyond what I had experienced with video games. It wasn't for another year and a half until I had returned to programming with a deep curiosity...",
		"My first real dive into the world of programming was, at first, overwhelming. What are all these brackets doing? What does this error mean? It took some time for me to adjust and learn the basics of C, and later Python to perform seemingly trivial, but fun tasks on my Raspberry Pi. These basic programs became the foundation of my self-teaching skills that helped me later in my education.",
		"I started at LaSalle in 2011 and will graduate in June 2015 with multiple successes I can look back on over the last four years. My greatest achievement has been my academic success. Every year I have attended LaSalle, I've received the Gold Academic Medal for the highest average of my grade. In addition, I've received awards for having the top mark of my class in every Chemistry, English and Math class I have ever taken. Also, I've completed every mathematics course at the highest academic level offered by my school. The other notable successes I've had during high school actually occurred outside of the classroom and inside of Xcode...",
		"Gaining more experience in Python and with an interest in computer security, I wrote a useful Python script that automated configuring system settings with a popular security tool called mitmproxy. My script, called \"MITM Configurator,\" configures the important settings, launches subprocesses, restores them to default when you're finished and has an elegant, colourful user interface. Oh, did I mention it works on both Mac OS X and Linux? MITM Configurator was my first major experience with Linux and python scripting. MITM Configurator is open source so you can view the source code by tapping on the button below.",
		"For about a year, I was switching between a couple of different feed reader clients from the App Store and knew that I wasn't satisfied with any of them. It dawned on me that I could build something like this! I knew it would be quite the challenge, having only made one game last year called Tapz (which you can play below), but I knew it could be very rewarding. And it was. Being able to make executive decisions and tune the app to my needs empowered me to a new level. After 5 months of work, Rez Reader launched in the App Store. Since then, I've been updating and redesigning it, most recently with version 2. Rez Reader has been downloaded by users around the world, but, most importantly, I'm proud of what I accomplished.",
		"For my end-of-the-year Chemistry project, a friend and I created a website that allowed any high school Chemistry student to get quick links to helpful Khan Academy videos, class handouts and more! The name, Sweatervest.club, is an inside joke in my Chemistry class. We received an A+ for this project and the teacher now recommends his other students to check it out. While doing this, I elevated my proficiency in HTML, CSS, and PHP. You can check out Sweatervest.club by tapping the button below.",
		"After Rez version 2, I was looking for a new challenge. The WWDC Student Scholarship program is a fantastic opportunity to exercise and learn skills. From the start, I was driven to create a simple, playful user interface. Beautiful stacked cards that dropped down in front of the user was a key idea for me. Behind the scenes, it took a considerable amount of work, dynamically generating the cards and the angles at which they fall (if you reset the card stack, you'll see the cards fall rotated differently each time). It also works on both iPad and iPhone through the use of autolayout and smart design. The app is entirely written by me, no third party code! It also borrows a few ideas I first developed in Rez Reader, but enhanced significantly. I consider this application a culmination of my best iOS programming to date.",
		"In February of this year, I was honoured and elated to receive early acceptance to the University of Waterloo for their prestigious Software Engineering program! Software Engineering at Waterloo is a 5-year program that includes 2 years of paid co-op positions. Entrance for the program is extremely competitive and requires one of the highest entrance averages of any Waterloo program. Many Waterloo Software Engineers co-op with Silicon Valley companies during their degree. I am looking forward with eager anticipation to my first formal education in Computer Science by joining the University of Waterloo's best program.",
		"Besides attending the University of Waterloo, what am I looking to do with my future? I have a vehement desire to continue exploring the vast field of computer science, tinkering with software, and discovering new technologies. Thanks for taking the time to review my app and I hope you enjoyed it as much as I enjoyed developing it!"]
	
	
	func allCardInfo() -> [CardInfo] {
		var events = [CardInfo]()
		for var i = 0; i < eventNames.count; i++ {
			events.append(CardInfo(img: images[i], detail: descriptions[i], name: eventNames[i], bcC: backgroundColors[i], tC: textColors[i], index: i, storyboard: storyboards[i], extraInfoDict: extraStuff[i]))
			
		}
		return events.reverse()
	}
	
}

func color(r : Int, g : Int, b: Int) -> UIColor {
	return UIColor(red: CGFloat(r)/255.0, green:  CGFloat(g)/255.0, blue: CGFloat(b)/255, alpha: 1.0)
}

