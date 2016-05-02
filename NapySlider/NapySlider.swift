//
//  NapySlider.swift
//  NapySlider
//
//  Created by Jonas Schoch on 12.12.15.
//  Copyright © 2015 naptics. All rights reserved.
//

import UIKit

@IBDesignable
public class NapySlider: UIControl {
    
    // internal variables, our views
    internal var backgroundView: UIView!
    internal var titleBackgroundView: UIView!
    internal var sliderView: UIView!
    internal var sliderBackgroundView: UIView!
    internal var sliderFillView: UIView!
    internal var handleView: UIView!
    internal var currentPosTriangle: TriangleView!
    
    internal var titleLabel: UILabel!
    internal var handleLabel: UILabel!
    internal var currentPosLabel: UILabel!
    internal var maxLabel: UILabel!
    internal var minLabel: UILabel!

    internal var isFloatingPoint: Bool {
        get { return step % 1 != 0 ? true : false }
    }

    // public variables
    var titleHeight: CGFloat = 30
    var sliderWidth: CGFloat = 20
    var handleHeight: CGFloat = 20
    var handleWidth: CGFloat = 50
    
    // public inspectable variables
    @IBInspectable var title: String = "Hello" {
        didSet {
            titleLabel.text = title
        }
    }
    
    @IBInspectable var min: Double = 0 {
        didSet {
            minLabel.text = textForPosition(min)
        }
    }
    
    @IBInspectable var max: Double = 10 {
        didSet {
            maxLabel.text = textForPosition(max)
        }
    }
    
    @IBInspectable var step: Double = 1
    
    // colors
    @IBInspectable var handleColor: UIColor = UIColor.grayColor()
    @IBInspectable var mainBackgroundColor: UIColor = UIColor.groupTableViewBackgroundColor()
    @IBInspectable var titleBackgroundColor: UIColor = UIColor.lightGrayColor()
    @IBInspectable var sliderUnselectedColor: UIColor = UIColor.lightGrayColor()
    
    /**
     the position of the handle. The handle moves animated when setting the variable
    */
    var handlePosition:Double {
        set (newHandlePosition) {
            moveHandleToPosition(newHandlePosition, animated: true)
        }
        get {
            let currentY = handleView.frame.origin.y + handleHeight/2
            let positionFromMin = -(Double(currentY) - minPosition - stepheight/2) / stepheight
            
            // add an offset if slider should go to a negative value
            var stepOffset:Double = 0
            if min < 0 {
            let zeroPosition = (0 - min)/Double(step) + 0.5
                if positionFromMin < zeroPosition {
                    stepOffset = 0 - step
                }
            }
            
//            let position = Int((positionFromMin * step + min + stepOffset) / step) * Int(step)
            let position = Double(Int((positionFromMin * step + min + stepOffset) / step)) * step
            return Double(position)
        }
    }
    
    var disabled:Bool = false {
        didSet {
            sliderBackgroundView.alpha = disabled ? 0.4 : 1.0
            self.userInteractionEnabled = !disabled
        }
    }
    
    
    private var steps: Int {
        get {
            if (min == max || step == 0) {
                return 1
            } else {
                return Int(round((max - min) / step)) + 1
            }
        }
    }
    
    private var maxPosition:Double {
        get {
            return 0
        }
    }
    
    private var minPosition:Double {
        get {
            return Double(sliderView.frame.height)
        }
    }
    
    
    private var stepheight:Double {
        get {
            return (minPosition - maxPosition) / Double(steps - 1)
        }
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.setup()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.setup()
    }
    
    private func setup() {
        backgroundView = UIView()
        backgroundView.userInteractionEnabled = false
        addSubview(backgroundView)
        
        titleBackgroundView = UIView()
        addSubview(titleBackgroundView)
        
        titleLabel = UILabel()
        titleBackgroundView.addSubview(titleLabel)
        
        sliderBackgroundView = UIView()
        sliderBackgroundView.userInteractionEnabled = false
        backgroundView.addSubview(sliderBackgroundView)
        
        sliderFillView = UIView()
        sliderFillView.userInteractionEnabled = false
        sliderBackgroundView.addSubview(sliderFillView)
        
        sliderView = UIView()
        sliderView.userInteractionEnabled = false
        sliderBackgroundView.addSubview(sliderView)
        
        handleView = UIView()
        handleView.userInteractionEnabled = false
        sliderView.addSubview(handleView)
        
        handleLabel = UILabel()
        handleView.addSubview(handleLabel)
        
        minLabel = UILabel()
        backgroundView.addSubview(minLabel)
        
        maxLabel = UILabel()
        backgroundView.addSubview(maxLabel)
        
        currentPosLabel = UILabel()
        sliderBackgroundView.addSubview(currentPosLabel)
        
        currentPosTriangle = TriangleView()
        currentPosLabel.addSubview(currentPosTriangle)
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        
        let sliderPaddingTop:CGFloat = 25
        let sliderPaddingBottom:CGFloat = 20
        
        backgroundView.frame = CGRectMake(0, titleHeight, frame.size.width, frame.size.height - titleHeight)
        backgroundView.backgroundColor = mainBackgroundColor
        
        titleBackgroundView.frame = CGRectMake(0, 0, frame.size.width, titleHeight)
        titleBackgroundView.backgroundColor = titleBackgroundColor
        
        titleLabel.frame = CGRectMake(0, 0, titleBackgroundView.frame.width, titleBackgroundView.frame.height)
        titleLabel.text = title
        titleLabel.textColor = handleColor
        titleLabel.font = UIFont.systemFontOfSize(14, weight: UIFontWeightSemibold)
        titleLabel.textAlignment = NSTextAlignment.Center
        
        sliderBackgroundView.frame = CGRectMake(backgroundView.frame.width/2 - sliderWidth/2, sliderPaddingTop, sliderWidth, backgroundView.frame.height - (sliderPaddingTop + sliderPaddingBottom))
        sliderBackgroundView.backgroundColor = sliderUnselectedColor
        
        sliderView.frame = CGRectMake(0, sliderWidth/2, sliderBackgroundView.frame.width, sliderBackgroundView.frame.height - sliderWidth)
        sliderView.backgroundColor = UIColor.clearColor()
        
        handleView.frame = CGRectMake(-(handleWidth-sliderWidth)/2, sliderView.frame.height/2 - handleHeight/2, handleWidth, handleHeight)
        handleView.backgroundColor = handleColor
        
        sliderFillView.frame = CGRectMake(0, handleView.frame.origin.y + handleHeight, sliderBackgroundView.frame.width, sliderBackgroundView.frame.height-handleView.frame.origin.y - handleHeight)
        sliderFillView.backgroundColor = tintColor
        
        handleLabel.frame = CGRectMake(0, 0, handleWidth, handleHeight)
        handleLabel.text = ""
        handleLabel.textAlignment = NSTextAlignment.Center
        handleLabel.textColor = UIColor.whiteColor()
        handleLabel.font = UIFont.systemFontOfSize(11, weight: UIFontWeightBold)
        handleLabel.backgroundColor = UIColor.clearColor()
        
        minLabel.frame = CGRectMake(0, backgroundView.frame.height-20, backgroundView.frame.width, 20)
        minLabel.text = textForPosition(min)
        minLabel.textAlignment = NSTextAlignment.Center
        minLabel.font = UIFont.systemFontOfSize(11, weight: UIFontWeightRegular)
        minLabel.textColor = handleColor
        
        maxLabel.frame = CGRectMake(0, 5, backgroundView.frame.width, 20)
        maxLabel.text = textForPosition(max)
        maxLabel.textAlignment = NSTextAlignment.Center
        maxLabel.font = UIFont.systemFontOfSize(11, weight: UIFontWeightRegular)
        maxLabel.textColor = handleColor
        
        currentPosLabel.frame = CGRectMake(handleView.frame.width, handleView.frame.origin.y + handleHeight*0.5/2, handleWidth, handleHeight * 1.5)
        currentPosLabel.text = ""
        currentPosLabel.textAlignment = NSTextAlignment.Center
        currentPosLabel.textColor = UIColor.whiteColor()
        handleLabel.font = UIFont.systemFontOfSize(13, weight: UIFontWeightBold)
        currentPosLabel.backgroundColor = tintColor
        currentPosLabel.alpha = 0.0
        
        currentPosTriangle.frame = CGRectMake(-10, 10, currentPosLabel.frame.height-20, currentPosLabel.frame.height-20)
        currentPosTriangle.tintColor = tintColor
        currentPosTriangle.backgroundColor = UIColor.clearColor()
    }

    public override func beginTrackingWithTouch(touch: UITouch, withEvent event: UIEvent?) -> Bool {
        super.beginTrackingWithTouch(touch, withEvent: event)
        
        UIView.animateWithDuration(0.3, animations: {
            self.currentPosLabel.alpha = 1.0
        })
        return true
    }

    public override func continueTrackingWithTouch(touch: UITouch, withEvent event: UIEvent?) -> Bool {
        super.continueTrackingWithTouch(touch, withEvent: event)
        let _ = handlePosition
        let point = touch.locationInView(sliderView)
        moveHandleToPoint(point)

        return true
    }

    public override func endTrackingWithTouch(touch: UITouch?, withEvent event: UIEvent?) {
        super.endTrackingWithTouch(touch, withEvent: event)
        
        let endPosition = handlePosition
        handlePosition = endPosition
        handleLabel.text = textForPosition(handlePosition)

        UIView.animateWithDuration(0.3, animations: {
            self.currentPosLabel.alpha = 0.0
        })
    }

    public override func cancelTrackingWithEvent(event: UIEvent?) {
        super.cancelTrackingWithEvent(event)
    }
    
    
    private func moveHandleToPoint(point:CGPoint) {
        var newY:CGFloat
        
        newY = point.y - CGFloat(handleView.frame.height/2)
        
        if newY < -handleHeight/2 {
            newY = -handleHeight/2
        } else if newY > sliderView.frame.height - handleHeight/2 {
            newY = sliderView.frame.height - handleHeight/2
        }
        
        handleView.frame.origin.y = CGFloat(newY)
        sliderFillView.frame = CGRectMake(0 , CGFloat(newY) + handleHeight, sliderBackgroundView.frame.width, sliderBackgroundView.frame.height-handleView.frame.origin.y - handleHeight)
        
        currentPosLabel.frame = CGRectMake(handleView.frame.width, handleView.frame.origin.y + handleHeight*0.5/2, currentPosLabel.frame.width, currentPosLabel.frame.height)
        
        let newText = textForPosition(handlePosition)
        if handleLabel.text != newText {
            handleLabel.text = newText
            currentPosLabel.text = newText
        }
    }
    
    private func moveHandleToPosition(position:Double, animated:Bool = false) {
        if step == 0 { return }

        var goPosition = position
        
        if position >= max { goPosition = max }
        if position <= min { goPosition = min }
        
        let positionFromMin = (goPosition - min) / step
        
        let newY = CGFloat(minPosition - positionFromMin * stepheight)
        
        if animated {
            UIView.animateWithDuration(0.3, animations: {
                self.handleView.frame.origin.y = newY - self.handleHeight/2
                self.sliderFillView.frame = CGRectMake(0 , CGFloat(newY) + self.handleHeight/2, self.sliderBackgroundView.frame.width, self.sliderBackgroundView.frame.height - self.handleView.frame.origin.y - self.handleHeight)
                self.currentPosLabel.frame = CGRectMake(self.handleView.frame.width, self.handleView.frame.origin.y + self.handleHeight*0.5/2, self.currentPosLabel.frame.width, self.currentPosLabel.frame.height)
            })
        } else {
            self.handleView.frame.origin.y = newY - self.handleHeight/2
            self.sliderFillView.frame.origin.y = CGFloat(newY) + self.handleHeight
            currentPosLabel.frame = CGRectMake(handleView.frame.width, handleView.frame.origin.y + handleHeight*0.5/2, currentPosLabel.frame.width, currentPosLabel.frame.height)
        }
        
        let newText = textForPosition(position)
        if handleLabel.text != newText {
            handleLabel.text = newText
            currentPosLabel.text = newText
        }
    }
    
    private func textForPosition(position:Double) -> String {
        if isFloatingPoint { return String(format: "%0.1f", arguments: [position]) }
        else { return String(format: "%0.0f", arguments: [position]) }
    }
}


class TriangleView : UIView {
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    override func drawRect(rect: CGRect) {
        
        let ctx : CGContextRef = UIGraphicsGetCurrentContext()!
        
        CGContextBeginPath(ctx)
        CGContextMoveToPoint(ctx, CGRectGetMinX(rect), CGRectGetMaxY(rect)/2.0)
        CGContextAddLineToPoint(ctx, CGRectGetMaxX(rect), CGRectGetMinY(rect))
        CGContextAddLineToPoint(ctx, CGRectGetMaxX(rect), CGRectGetMaxY(rect))
        CGContextClosePath(ctx)
        
        CGContextSetFillColorWithColor(ctx, tintColor.CGColor)
        CGContextFillPath(ctx)
    }
}
