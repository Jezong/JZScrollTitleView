//
//  ViewController.swift
//  JZScrollTitleView
//
//  Created by jezong on 16/2/25.
//  Copyright © 2016年 jezong. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIScrollViewDelegate {

	var scrollTitleView: JZScrollTitleView!
	var scrollImageView: UIScrollView!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		let effectView = UIVisualEffectView(frame: CGRectMake(0, 0, self.view.bounds.width, 50))
		scrollTitleView = JZScrollTitleView(frame: effectView.bounds)
		scrollImageView = UIScrollView(frame: self.view.bounds)
		
		self.view.addSubview(scrollImageView)
		self.view.addSubview(effectView)
		effectView.contentView.addSubview(scrollTitleView)
		
		//添加模糊效果
		effectView.effect = UIBlurEffect(style: .ExtraLight)
        scrollImageView.bounces       = false
        scrollImageView.pagingEnabled = true
        scrollImageView.delegate      = self
		
		let pics = ["Shanghai", "Paris", "Singapore", "Taipei", "Willemstad"]
		scrollTitleView.titles = pics
		scrollTitleView.backgroundColor = .clearColor()
		scrollTitleView.addTarget(self, action: "tapTitle", forControlEvents: .ValueChanged)
		for (index, pic) in pics.enumerate() {
			let imageView = UIImageView(frame: CGRectOffset(scrollImageView.bounds, CGFloat(index)*scrollImageView.bounds.width, 0))
			imageView.image = UIImage(named: pic)
			imageView.contentMode = .ScaleAspectFit
			scrollImageView.addSubview(imageView)
		}
		scrollImageView.contentSize = CGSizeMake(CGFloat(pics.count)*scrollImageView.bounds.width, scrollImageView.bounds.height)
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}

	func tapTitle() {
		var point = CGPointZero
		point.x = CGFloat(scrollTitleView.currentPos) * scrollImageView.bounds.width
		scrollImageView.setContentOffset(point, animated: true)
	}
	
	func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
		let pos = Int(scrollView.contentOffset.x / scrollView.bounds.width)
		scrollTitleView.setSelectedPosition(pos, animated: true)
	}

}

