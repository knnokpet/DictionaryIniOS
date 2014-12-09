//
//  NoResultView.swift
//  SearchIniOS
//
//  Created by Masayuki Ikeda on 2014/12/09.
//  Copyright (c) 2014年 Masayuki Ikeda. All rights reserved.
//

import Foundation
import UIKit

class NoResultView: UIView {
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.configure()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.configure()
    }
    
    func configure() {
        self.layer.cornerRadius = 16.0
        self.backgroundColor = UIColor.darkGrayColor()
        self.userInteractionEnabled = false
        
        let boundsSize: CGSize = self.bounds.size
        var resultLabel: UILabel = UILabel(frame: CGRectMake(0, boundsSize.height / 3, boundsSize.width, boundsSize.height / 3))
        resultLabel.text = "No Result"
        resultLabel.font = UIFont.boldSystemFontOfSize(boundsSize.height / 4)
        resultLabel.textColor = UIColor.whiteColor()
        resultLabel.textAlignment = NSTextAlignment.Center
        resultLabel.baselineAdjustment = UIBaselineAdjustment.AlignCenters
        self.addSubview(resultLabel)
        
    }
    
}
