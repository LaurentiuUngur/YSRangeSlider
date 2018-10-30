//
//  YSRangeSlider.swift
//  YSRangeSlider
//
//  Created by Laurentiu Ungur on 22/01/16.
//  Copyright © 2016 Yardi. All rights reserved.
//

import UIKit

@IBDesignable open class YSRangeSlider: UIControl {
    
    public enum ChangeType: Int {
        case initiate, minimum, maximum
    }
    
    // MARK: - Public Properties
    
    /// The minimum possible value to select in the range. The default value of this property is `0.0`
    @IBInspectable open var minimumValue: CGFloat = 0.0 {
        didSet { updateComponentsPosition(.minimum) }
    }
    /// The maximum possible value to select in the range. The default value of this property is `1.0`
    @IBInspectable open var maximumValue: CGFloat = 1.0 {
        didSet {
            if step > maximumValue {
                preconditionFailure("Step value must be less than or equal to maximum value")
            }
            updateComponentsPosition(.maximum)
        }
    }
    /// The preselected minimum value from range [minimumValue, maximumValue]. The default value of this property is `0.0`
    @IBInspectable open var minimumSelectedValue: CGFloat = 0.0 {
        didSet{
            if minimumSelectedValue < minimumValue || minimumSelectedValue > maximumValue {
                minimumSelectedValue = minimumValue
            }
            if step > 0 {
                minimumSelectedValue = CGFloat(roundf(Float(minimumSelectedValue / step))) * step
            }
            updateComponentsPosition(.minimum)
        }
    }
    /// The preselected maximum value from range [minimumValue, maximumValue]. The default value of this property is `1.0`
    @IBInspectable open var maximumSelectedValue: CGFloat = 1.0 {
        didSet{
            if maximumSelectedValue < minimumValue || maximumSelectedValue > maximumValue {
                maximumSelectedValue = maximumValue
            }
            if step > 0 {
                maximumSelectedValue = CGFloat(roundf(Float(maximumSelectedValue / step))) * step
            }
            updateComponentsPosition(.maximum)
        }
    }
    /** The step, or increment, value for the slider. The default value of this property is `0.0`
     
    - Note: Default value is `0.0`, which means it is disabled
    - Precondition: Must be numerically greater than `0` and less than or equal to `maximumValue`
    */
    @IBInspectable open var step: CGFloat = 0.0 {
        didSet {
            if step < 0 {
                preconditionFailure("Step value must be positive")
            } else if step > maximumValue {
                preconditionFailure("Step value must be less than or equal to maximum value")
            }
        }
    }
    /// The color of slider between left and right thumb. The default value of this property is `yellow`
    @IBInspectable open var sliderLineColorBetweenThumbs: UIColor = UIColor.yellow {
        didSet { thumbsDistanceLineLayer.backgroundColor = sliderLineColorBetweenThumbs.cgColor }
    }
    /// The height of the slider. The default value of this property is `1.0`
    @IBInspectable open var sliderLineHeight: CGFloat = 1.0 {
        didSet {
            sliderLineLayer.frame.size.height = sliderLineHeight
            thumbsDistanceLineLayer.frame.size.height = sliderLineHeight
        }
    }
    /// Padding between slider and controller sides. The default value of this property is `15.0`
    @IBInspectable open var sliderSidePadding: CGFloat = 15.0 {
        didSet { layoutSubviews() }
    }
    /// The color of the slider. The default value of this property is `black`
    @IBInspectable open var sliderLineColor: UIColor = UIColor.black {
        didSet { sliderLineLayer.backgroundColor = sliderLineColor.cgColor }
    }
    /// The corner radius of the slider. The default value of this property is `0.0`
    @IBInspectable open var sliderLineCornerRadius: CGFloat = 0.0 {
        didSet { sliderLineLayer.cornerRadius = sliderLineCornerRadius }
    }
    /// The shadow color of the slider. The default value of this property is `clear`
    @IBInspectable open var sliderLineShadowColor: UIColor = UIColor.clear {
        didSet { sliderLineLayer.shadowColor = sliderLineShadowColor.cgColor }
    }
    /// The shadow opacity of the slider. The default value of this property is `0.0`
    @IBInspectable open var sliderLineShadowOpacity: Float = 0.0 {
        didSet { sliderLineLayer.shadowOpacity = sliderLineShadowOpacity }
    }
    /// The shadow radius of the slider. The default value of this property is `3.0`
    @IBInspectable open var sliderLineShadowRadius: CGFloat = 3.0 {
        didSet { sliderLineLayer.shadowRadius = sliderLineShadowRadius }
    }
    /// The shadow offset of the slider. The default value of this property is `(0.0, -3.0)`
    @IBInspectable open var sliderLineShadowOffset: CGSize = CGSize(width: 0.0, height: -3.0) {
        didSet { sliderLineLayer.shadowOffset = sliderLineShadowOffset }
    }
    /// The color of the left thumb. The default value of this property is `black`
    @IBInspectable open var leftThumbColor: UIColor = UIColor.black {
        didSet { leftThumbLayer.backgroundColor = leftThumbColor.cgColor }
    }
    /// The corner radius of the left thumb. The default value of this property is `10.0`
    @IBInspectable open var leftThumbCornerRadius: CGFloat = 10.0 {
        didSet { leftThumbLayer.cornerRadius = leftThumbCornerRadius }
    }
    /// The shadow color of the left thumb. The default value of this property is `clear`
    @IBInspectable open var leftThumbShadowColor: UIColor = UIColor.clear {
        didSet { leftThumbLayer.shadowColor = leftThumbShadowColor.cgColor }
    }
    /// The shadow opacity of the left thumb. The default value of this property is `0.0`
    @IBInspectable open var leftThumbShadowOpacity: Float = 0.0 {
        didSet { leftThumbLayer.shadowOpacity = leftThumbShadowOpacity }
    }
    /// The shadow radius of the left thumb. The default value of this property is `3.0`
    @IBInspectable open var leftThumbShadowRadius: CGFloat = 3.0 {
        didSet { leftThumbLayer.shadowRadius = leftThumbShadowRadius }
    }
    /// The shadow offset of the left thumb. The default value of this property is `(0.0, -3.0)`
    @IBInspectable open var leftThumbShadowOffset: CGSize = CGSize(width: 0.0, height: -3.0) {
        didSet { leftThumbLayer.shadowOffset = leftThumbShadowOffset }
    }
    /// The color of the right thumb. The default value of this property is `black`
    @IBInspectable open var rightThumbColor: UIColor = UIColor.black {
        didSet { rightThumbLayer.backgroundColor = rightThumbColor.cgColor }
    }
    /// The corner radius of the right thumb. The default value of this property is `10.0`
    @IBInspectable open var rightThumbCornerRadius: CGFloat = 10.0 {
        didSet { rightThumbLayer.cornerRadius = rightThumbCornerRadius }
    }
    /// The shadow color of the right thumb. The default value of this property is `clear`
    @IBInspectable open var rightThumbShadowColor: UIColor = UIColor.clear {
        didSet { rightThumbLayer.shadowColor = rightThumbShadowColor.cgColor }
    }
    /// The shadow opacity of the right thumb. The default value of this property is `0.0`
    @IBInspectable open var rightThumbShadowOpacity: Float = 0.0 {
        didSet { rightThumbLayer.shadowOpacity = rightThumbShadowOpacity }
    }
    /// The shadow radius of the right thumb. The default value of this property is `3.0`
    @IBInspectable open var rightThumbShadowRadius: CGFloat = 3.0 {
        didSet { rightThumbLayer.shadowRadius = rightThumbShadowRadius }
    }
    /// The shadow offset of the right thumb. The default value of this property is `(0.0, -3.0)`
    @IBInspectable open var rightThumbShadowOffset: CGSize = CGSize(width: 0.0, height: -3.0) {
        didSet { rightThumbLayer.shadowOffset = rightThumbShadowOffset }
    }
    /// The size of the thumbs. The default value of this property is `20.0`
    @IBInspectable open var thumbsSize: CGFloat = 20.0 {
        didSet {
            leftThumbLayer.frame.size = CGSize(width: thumbsSize, height: thumbsSize)
            rightThumbLayer.frame.size = CGSize(width: thumbsSize, height: thumbsSize)
        }
    }
    
    /// The delegate of `YSRangeSlider`
    open weak var delegate: YSRangeSliderDelegate?
    
    public let sliderLineLayer = CALayer()
    public let leftThumbLayer = CALayer()
    public let rightThumbLayer = CALayer()
    public let thumbsDistanceLineLayer = CALayer()
    
    // MARK: - Private Properties

    private let thumbTouchAreaExpansion: CGFloat = -90.0
    private var leftThumbSelected = false
    private var rightThumbSelected = false
    
    // MARK: - Init
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        
        commonInit()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        commonInit()
    }
    
    private func commonInit() {
        sliderLineLayer.backgroundColor = sliderLineColor.cgColor
        sliderLineLayer.cornerRadius = sliderLineCornerRadius
        layer.addSublayer(sliderLineLayer)
        
        thumbsDistanceLineLayer.backgroundColor = sliderLineColorBetweenThumbs.cgColor
        layer.addSublayer(thumbsDistanceLineLayer)
        
        leftThumbLayer.backgroundColor = leftThumbColor.cgColor
        leftThumbLayer.cornerRadius = leftThumbCornerRadius
        leftThumbLayer.frame = CGRect(x: 0, y: 0, width: thumbsSize, height: thumbsSize)
        leftThumbLayer.shadowColor = leftThumbShadowColor.cgColor
        leftThumbLayer.shadowOffset = leftThumbShadowOffset
        leftThumbLayer.shadowOpacity = leftThumbShadowOpacity
        leftThumbLayer.shadowRadius = leftThumbShadowRadius
        layer.addSublayer(leftThumbLayer)
        
        rightThumbLayer.backgroundColor = rightThumbColor.cgColor
        rightThumbLayer.cornerRadius = rightThumbCornerRadius
        rightThumbLayer.frame = CGRect(x: 0, y: 0, width: thumbsSize, height: thumbsSize)
        rightThumbLayer.shadowColor = rightThumbShadowColor.cgColor
        rightThumbLayer.shadowOffset = rightThumbShadowOffset
        rightThumbLayer.shadowOpacity = rightThumbShadowOpacity
        rightThumbLayer.shadowRadius = rightThumbShadowRadius
        layer.addSublayer(rightThumbLayer)
        
        updateComponentsPosition(.initiate)
    }
    
    override open func layoutSubviews() {
        super.layoutSubviews()
        
        let frameMiddleY = frame.height / 2.0
        let lineLeftSide = CGPoint(x: sliderSidePadding, y: frameMiddleY)
        let lineRightSide = CGPoint(x: frame.width - sliderSidePadding, y: frameMiddleY)
        
        sliderLineLayer.frame = CGRect(x: lineLeftSide.x, y: lineLeftSide.y, width: lineRightSide.x - lineLeftSide.x, height: sliderLineHeight)
        
        updateThumbsPosition()
    }
    
    // MARK: - Touch Tracking
    
    override open func beginTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        let pressGestureLocation = touch.location(in: self)

        if leftThumbLayer.frame.insetBy(dx: thumbTouchAreaExpansion, dy: thumbTouchAreaExpansion).contains(pressGestureLocation) ||
           rightThumbLayer.frame.insetBy(dx: thumbTouchAreaExpansion, dy: thumbTouchAreaExpansion).contains(pressGestureLocation) {
            let distanceFromLeftThumb = distanceBetween(pressGestureLocation, leftThumbLayer.frame.center)
            let distanceFromRightThumb = distanceBetween(pressGestureLocation, rightThumbLayer.frame.center)
            
            if distanceFromLeftThumb < distanceFromRightThumb {
                leftThumbSelected = true
                animate(thumbLayer: leftThumbLayer, isSelected: true)
            } else if maximumSelectedValue == maximumValue && leftThumbLayer.frame.center.x == rightThumbLayer.frame.center.x {
                leftThumbSelected = true
                animate(thumbLayer: leftThumbLayer, isSelected: true)
            } else {
                rightThumbSelected = true
                animate(thumbLayer: rightThumbLayer, isSelected: true)
            }
            
            return true
        }
        
        return false
    }
    
    override open func continueTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        let location = touch.location(in: self)
        let percentage = (location.x - sliderLineLayer.frame.minX - thumbsSize / 2) / (sliderLineLayer.frame.maxX - sliderLineLayer.frame.minX)
        let selectedValue = percentage * (maximumValue - minimumValue) + minimumValue
        
        if leftThumbSelected {
            minimumSelectedValue = (selectedValue < maximumSelectedValue) ? selectedValue : maximumSelectedValue
        } else if rightThumbSelected {
            maximumSelectedValue = (selectedValue > minimumSelectedValue) ? selectedValue : minimumSelectedValue
        }
        
        return true
    }
    
    override open func endTracking(_ touch: UITouch?, with event: UIEvent?) {
        if leftThumbSelected {
            leftThumbSelected = false
            animate(thumbLayer: leftThumbLayer, isSelected: false)
        } else {
            rightThumbSelected = false
            animate(thumbLayer: rightThumbLayer, isSelected: false)
        }
    }
    
    // MARK: - Private Functions
    
    private func updateComponentsPosition(_ type: ChangeType) {
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        updateThumbsPosition()
        CATransaction.commit()
        
        delegate?.rangeSliderDidChange(self, minimumSelectedValue: minimumSelectedValue, maximumSelectedValue: maximumSelectedValue, changeType: type)
    }
    
    private func updateThumbsPosition() {
        let leftThumbCenter = CGPoint(x: getXPositionAlongSliderFor(value: minimumSelectedValue), y: sliderLineLayer.frame.midY)
        let rightThumbCenter = CGPoint(x: getXPositionAlongSliderFor(value: maximumSelectedValue), y: sliderLineLayer.frame.midY)
        
        leftThumbLayer.position = leftThumbCenter
        rightThumbLayer.position = rightThumbCenter
        thumbsDistanceLineLayer.frame = CGRect(x: leftThumbLayer.position.x, y: sliderLineLayer.frame.origin.y, width: rightThumbLayer.position.x - leftThumbLayer.position.x, height: sliderLineHeight)
    }
    
    private func getPercentageAlongSliderFor(value: CGFloat) -> CGFloat {
        return (minimumValue != maximumValue) ? (value - minimumValue) / (maximumValue - minimumValue) : 0
    }
    
    private func getXPositionAlongSliderFor(value: CGFloat) -> CGFloat {
        let percentage = getPercentageAlongSliderFor(value: value)
        let differenceBetweenMaxMinCoordinatePositionX = sliderLineLayer.frame.maxX - sliderLineLayer.frame.minX
        let offset = percentage * differenceBetweenMaxMinCoordinatePositionX
    
        return sliderLineLayer.frame.minX + offset
    }
    
    private func distanceBetween(_ firstPoint: CGPoint, _ secondPoint: CGPoint) -> CGFloat {
        let xDistance = secondPoint.x - firstPoint.x
        let yDistance = secondPoint.y - firstPoint.y
        
        return sqrt(pow(xDistance, 2) + pow(yDistance, 2))
    }
    
    private func animate(thumbLayer: CALayer, isSelected selected: Bool) {
        CATransaction.begin()
        CATransaction.setAnimationDuration(0.5)
        CATransaction.setAnimationTimingFunction(CAMediaTimingFunction(name: .easeInEaseOut))
        thumbLayer.transform = selected ? CATransform3DMakeScale(1.3, 1.3, 1) : CATransform3DIdentity
        CATransaction.commit()
    }
}

// MARK: - CGRect Extension

extension CGRect {
    var center: CGPoint {
        return CGPoint(x: midX, y: midY)
    }
}

// MARK: - YSRangeSliderDelegate

public protocol YSRangeSliderDelegate: class {
    /** Delegate function that is called every time minimum or maximum selected value is changed
     
    - Parameters:
        - rangeSlider: Current instance of `YSRangeSlider`
        - minimumSelectedValue: The minimum selected value
        - maximumSelectedValue: The maximum selected value
        - changeType: The change type
    */
    func rangeSliderDidChange(_ rangeSlider: YSRangeSlider, minimumSelectedValue: CGFloat, maximumSelectedValue: CGFloat, changeType: YSRangeSlider.ChangeType)
}
