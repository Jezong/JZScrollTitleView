//
//  JZScrollTitleView.swift
//  JZScrollTitleView
//
//  Created by jezong on 16/2/25.
//  Copyright © 2016年 jezong. All rights reserved.
//

import UIKit

public class JZScrollTitleView: UIControl, UIScrollViewDelegate {
	/// 标题的颜色
	public var titleColor: UIColor = UIColor(red: 0.05, green: 0.05, blue: 0.05, alpha: 1)
	/// 标题列表
	public var titles = [String]()
	/// 当前游标位置
	public var currentPos = 0
	/// 游标高度
	public var cursorHeight: CGFloat = 4
	/// 两个标题之间的空隙
	public var spaceBetweenTitles: CGFloat = 30
	/// 当前选定的标题
	public var currentTitle: String {
		return titles[currentPos]
	}
	
	private var containerScrollView: UIScrollView!
	private var cursorView: UIView!
	private var lineView: UIView!
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		initSubviews()
	}
	
	required public init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		initSubviews()
	}
	
	private func initSubviews() {
		cursorView          = UIView()
		lineView            = UIView()
		containerScrollView = UIScrollView()
		containerScrollView.bounces = false
		containerScrollView.delegate = self
		self.backgroundColor = .whiteColor()
		
		self.addSubview(lineView)
		self.addSubview(containerScrollView)
	}
	
	override public func drawRect(rect: CGRect) {
		for v in containerScrollView.subviews {
			v.removeFromSuperview()
		}
		//底部分割线条高度为1
		lineView.frame = CGRectMake(0, bounds.height - 1, bounds.width, 1)
		lineView.backgroundColor = tintColor
		containerScrollView.frame = CGRectMake(0, 0, bounds.width, bounds.height-1)
		
		if titles.count == 0 { return }
		
		var offset:CGFloat = 0
		var buttons = [UIButton]()
		for (i, title) in titles.enumerate() {
			let size = NSString(string: title).sizeWithAttributes([NSFontAttributeName: UIFont.systemFontOfSize(UIFont.systemFontSize() + 3)])
			let itemWidth = size.width + spaceBetweenTitles
			
			let button = UIButton(frame: CGRectMake(offset, 0, itemWidth, bounds.height-cursorHeight))
			button.setTitle(title, forState: .Normal)
			button.setTitleColor(titleColor, forState: .Normal)
			button.setTitleColor(tintColor, forState: .Selected)
			button.selected = currentPos == i
			button.tag = 100 + i
			button.addTarget(self, action: "tapTitleButton:", forControlEvents: .TouchUpInside)
			containerScrollView.addSubview(button)
			buttons.append(button)
			offset += itemWidth
		}
		
		if offset < self.bounds.width {	//如果buttons的长度小于屏幕宽度，则重新布局button的位置
			let inc = (self.bounds.width - offset) / CGFloat(buttons.count)
			offset = 0
			for button in buttons {
				button.frame = CGRectMake(offset, 0, button.bounds.width + inc, button.bounds.height)
				offset += button.bounds.width
			}
		}
		containerScrollView.contentSize = CGSizeMake(offset, containerScrollView.bounds.height)
		let button: UIButton
		if currentPos >= 0 || currentPos < buttons.count {
			button = buttons[currentPos]
		} else {
			button = buttons[0]
		}
		cursorView.frame = CGRectMake(button.frame.minX, bounds.height - cursorHeight, button.bounds.width, cursorHeight)
		cursorView.backgroundColor = tintColor
		self.addSubview(cursorView)
	}
	
	@objc private func tapTitleButton(button: UIButton) {
		setSelectedPosition(button.tag - 100, animated: true)
		//向目标发送事件消息
		for target in allTargets() {
			if let actions = actionsForTarget(target, forControlEvent: .ValueChanged) {
				for action in actions {
					target.performSelector(Selector(action), withObject: self)
				}
			}
		}
	}
	
//MARK: - Interface
	
	/**
	设置游标位置
	
	- parameter pos:      位置
	- parameter animated: 是否使用动画
	*/
	public func setSelectedPosition(pos: Int, animated: Bool) {
		if pos >= titles.count || currentPos == pos { return }
		if let currentButton = self.viewWithTag(100 + pos) as? UIButton {
			(self.viewWithTag(100 + currentPos) as? UIButton)?.selected = false
			currentButton.selected = true
			currentPos = pos
			
			let cursorX = currentButton.frame.minX - containerScrollView.contentOffset.x
			if animated {
				UIView.animateWithDuration(0.5, delay: 0, usingSpringWithDamping: 0.98, initialSpringVelocity: 0, options: .CurveLinear, animations: {
					self.cursorView.frame = CGRectMake(cursorX, self.cursorView.frame.minY, currentButton.bounds.width, self.cursorView.frame.height)
					}, completion: nil)
			} else {
				self.cursorView.frame = CGRectMake(cursorX, self.cursorView.frame.minY, currentButton.bounds.width, self.cursorView.frame.height)
			}
			scrollPointToNearCenter(currentButton.center, animated: animated)
		}
		
	}
	
	
	///居中显示
	public func scrollPointToNearCenter(point: CGPoint, animated: Bool) {
		
		let distance = containerScrollView.bounds.midX - point.x
		
		var targetPoint:CGPoint
		targetPoint = CGPointMake(containerScrollView.contentOffset.x - distance, 0)
		
		if targetPoint.x < 0 {
			targetPoint = CGPoint.zero
		} else if targetPoint.x > containerScrollView.contentSize.width - containerScrollView.bounds.width {
			targetPoint = CGPointMake(containerScrollView.contentSize.width - containerScrollView.bounds.width, 0)
		}
		containerScrollView.setContentOffset(targetPoint, animated: animated)
	}
	
	//MARK: - ScrollView delegate
	
	public func scrollViewDidScroll(scrollView: UIScrollView) {
		if let currentButton = self.viewWithTag(100 + currentPos) as? UIButton {
			
			let cursorX = currentButton.frame.minX - scrollView.contentOffset.x
			
			self.cursorView.frame = CGRectMake(cursorX, self.cursorView.frame.minY, self.cursorView.frame.width, self.cursorView.frame.height)
		}
	}

}
