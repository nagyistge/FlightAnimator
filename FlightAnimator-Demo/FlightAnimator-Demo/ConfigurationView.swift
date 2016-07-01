//
//  ConfigCollectionViewCell.swift
//  FlightAnimator
//
//  Created by Anton Doudarev on 2/24/16.
//  Copyright © 2016 Anton Doudarev. All rights reserved.
//

import Foundation
import UIKit
// import FlightAnimator

enum PropertyConfigType : Int {
    case Bounds
    case Position
    case Alpha
    case Transform
}


var functionTypes : [String] = ["SpringDecay", "SpringCustom",
                                "Linear", "LinearSmooth", "LinearSmoother",
                                "InSine", "OutSine", "InOutSine", "OutInSine",
                                "InAtan", "OutAtan", "InOutAtan",
                                "InQuadratic", "OutQuadratic", "InOutQuadratic", "OutInQuadratic",
                                "InCubic", "OutCubic", "InOutCubic", "OutInCubic",
                                "InQuartic",  "OutQuartic", "InOutQuartic", "OutInQuartic",
                                "InQuintic", "OutQuintic", "InOutQuintic", "OutInQuintic",
                                "InExponential", "OutExponential", "InOutExponential", "OutInExponential",
                                "InCircular", "OutCircular", "InOutCircular", "OutInCircular",
                                "InBack",  "OutBack", "InOutBack", "OutInBack",
                                "InElastic", "OutElastic", "InOutElastic", "OutInElastic",
                                "InBounce", "OutBounce", "InOutBounce", "OutInBounce"]

var functions : [FAEasing]    = [.SpringDecay(velocity : CGPointZero), .SpringCustom(velocity: CGPointZero, frequency: 21, ratio: 0.99),
                                 .Linear, .LinearSmooth, .LinearSmoother,
                                 .InSine, .OutSine, .InOutSine, .OutInSine,
                                 .InAtan, .OutAtan, .InOutAtan,
                                 .InQuadratic, .OutQuadratic, .InOutQuadratic, .OutInQuadratic,
                                 .InCubic, .OutCubic, .InOutCubic, .OutInCubic,
                                 .InQuartic, .OutQuartic, .InOutQuartic, .OutInQuartic,
                                 .InQuintic, .OutQuintic, .InOutQuintic, .OutInQuintic,
                                 .InExponential, .OutExponential, .InOutExponential, .OutInExponential,
                                 .InCircular, .OutCircular, .InOutCircular, .OutInCircular,
                                 .InBack,  .OutBack, .InOutBack, .OutInBack,
                                 .InElastic, .OutElastic, .InOutElastic,
                                 .InBounce, .OutBounce, .InOutBounce, .OutInBounce]

protocol ConfigurationViewDelegate {
    func selectedTimingPriority(priority : FAPrimaryTimingPriority)
    
    func currentPrimaryFlagValue(atIndex : Int) -> Bool
    func currentEAsingFuntion(atIndex : Int) -> FAEasing
}

class ConfigurationView : UIView {
    
    var interactionDelegate: ConfigurationViewDelegate?
    weak var cellDelegate : CurveCollectionViewCellDelegate?
   
    var selectedIndex: NSIndexPath = NSIndexPath(forRow: 0, inSection: 0)
    
    var propertyConfigType : PropertyConfigType = PropertyConfigType.Bounds {
        didSet {
            self.contentCollectionView.reloadData()
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
        registerCells()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
    
    func setup() {
        clipsToBounds = true
        backgroundColor = UIColor(rgba: "#444444")
        
        addSubview(backgroundView)
        addSubview(contentCollectionView)
        addSubview(separator)
        addSubview(titleLabel)
        addSubview(segnmentedControl)
        addSubview(secondSeparator)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        titleLabel.alignWithSize(CGSizeMake(self.bounds.width - 32, 24),
                                 toFrame: self.bounds,
                                 horizontal: HGHorizontalAlign.LeftEdge,
                                 vertical: HGVerticalAlign.Top,
                                 horizontalOffset:  16,
                                 verticalOffset: 16)
        
        segnmentedControl.sizeToFit()
        segnmentedControl.alignWithSize(CGSizeMake(self.bounds.width - 32, segnmentedControl.bounds.height),
                                 toFrame: titleLabel.frame,
                                 horizontal: HGHorizontalAlign.LeftEdge,
                                 vertical: HGVerticalAlign.Below,
                                 verticalOffset : 10)
  
        secondSeparator.alignWithSize(CGSizeMake(self.bounds.width, 1),
                                        toFrame: segnmentedControl.frame,
                                        horizontal: HGHorizontalAlign.Center,
                                        vertical: HGVerticalAlign.Below,
                                        verticalOffset :18)
        
        contentCollectionView.alignWithSize(CGSizeMake(self.bounds.width, 336),
                                      toFrame: secondSeparator.frame,
                                      horizontal: HGHorizontalAlign.Center,
                                      vertical: HGVerticalAlign.Below,
                                      verticalOffset : 0)
        
        
        separator.alignWithSize(CGSizeMake(self.bounds.width, 1),
                                      toFrame: contentCollectionView.frame,
                                      horizontal: HGHorizontalAlign.Center,
                                      vertical: HGVerticalAlign.Below,
                                      verticalOffset :0)


        
        backgroundView.frame = self.bounds
    }
    
    func registerCells() {
        contentCollectionView.registerClass(CurveSelectionCollectionViewCell.self, forCellWithReuseIdentifier: "PropertyCell0")
         contentCollectionView.registerClass(CurveSelectionCollectionViewCell.self, forCellWithReuseIdentifier: "PropertyCell1")
         contentCollectionView.registerClass(CurveSelectionCollectionViewCell.self, forCellWithReuseIdentifier: "PropertyCell2")
         contentCollectionView.registerClass(CurveSelectionCollectionViewCell.self, forCellWithReuseIdentifier: "PropertyCell3")
    }
    
    func setupAnimation() {
        if let cell = contentCollectionView.cellForItemAtIndexPath(selectedIndex) as? CurveSelectionCollectionViewCell {
            cell.startFade()
        }
    }
    
    // MARK: - Lazy Loaded Views
    
    
    lazy var segnmentedControl : UISegmentedControl = {
        let items = ["MaxTime", "MinTime", "Median", "Average"]
        
        var segmentedControl = UISegmentedControl(items: items)
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.tintColor = UIColor.whiteColor()
        segmentedControl.addTarget(self, action: #selector(ConfigurationView.changedPriority(_:)), forControlEvents: .ValueChanged)
        return segmentedControl

    }()
    
    func changedPriority(segmentedControl : UISegmentedControl) {
        self.interactionDelegate?.selectedTimingPriority(FAPrimaryTimingPriority(rawValue: segmentedControl.selectedSegmentIndex)!)
    }
    
    lazy var titleLabel: UILabel = {
        var label = UILabel()
        label.textColor = UIColor.whiteColor()
        label.text = "Primary Timing Priority"
        label.backgroundColor = UIColor.clearColor()
        label.font = UIFont(name: "Helvetica", size: 15)
        label.textAlignment = .Center
        return label
    }()
    
    lazy var backgroundView: UIView = {
        var view = UIView()
        view.backgroundColor = UIColor(rgba: "#444444")
        return view
    }()
    
    lazy var separator: UIView = {
        var view = UIView()
        view.backgroundColor = UIColor.whiteColor()
        return view
    }()
    
    lazy var secondSeparator: UIView = {
        var view = UIView()
        view.backgroundColor = UIColor.whiteColor()
        return view
    }()
    
    lazy var contentCollectionView : UICollectionView = {
        [unowned self] in
        
        var flowLayout = UICollectionViewFlowLayout()
        flowLayout.minimumInteritemSpacing = 1.0
        flowLayout.minimumLineSpacing = 1.0
        flowLayout.scrollDirection = .Vertical
        flowLayout.sectionInset = UIEdgeInsetsZero
        
        var tempCollectionView : UICollectionView = UICollectionView(frame: CGRectZero, collectionViewLayout :flowLayout)
        tempCollectionView.alpha = 1.0
        tempCollectionView.clipsToBounds = true
        tempCollectionView.backgroundColor = UIColor.whiteColor()
        tempCollectionView.delegate = self
        tempCollectionView.dataSource = self
        tempCollectionView.scrollEnabled = false
        tempCollectionView.pagingEnabled = false
        return tempCollectionView
        }()
}

extension ConfigurationView : UICollectionViewDelegate, UICollectionViewDataSource {
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView : UICollectionView,layout collectionViewLayout:UICollectionViewLayout, sizeForItemAtIndexPath indexPath:NSIndexPath) -> CGSize {
        return CGSizeMake(collectionView.bounds.size.width, 84)
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        /*
        selectedIndex = indexPath
        propertyConfigType = PropertyConfigType(rawValue:indexPath.row)!
        let title = interactionDelegate?.selectedEasingFunctionTitleFor(PropertyConfigType(rawValue : indexPath.row)!)
        pickerView.selectRow(functionTypes.indexOf(title!)!, inComponent: 0, animated: true)
         */
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        return cellAtIndex(indexPath)
    }
    
    
    func cellAtIndex(indexPath: NSIndexPath) -> UICollectionViewCell {
        if let cell = contentCollectionView.dequeueReusableCellWithReuseIdentifier("PropertyCell\(indexPath.row)" as String, forIndexPath: indexPath) as? CurveSelectionCollectionViewCell {
            cell.delegate = cellDelegate
            cell.propertyConfigType = PropertyConfigType(rawValue : indexPath.row)!
            cell.primarySwitch.on = interactionDelegate!.currentPrimaryFlagValue(indexPath.row)
            cell.pickerView.selectRow(functions.indexOf(interactionDelegate!.currentEAsingFuntion(indexPath.row))!, inComponent: 0, animated: true)
            
            return cell
        }
        
        return UICollectionViewCell()
    }
}

