//
//  YJNewsTypeViewModel.swift
//  今日头条
//
//  Created by yj on 2017/1/13.
//  Copyright © 2017年 99baozi. All rights reserved.
//

import UIKit

class YJNewsTypeViewModel: NSObject {
    
    
    var newsTypeArray : [YJNewsTypeModel]? {
        
        let path = Bundle.main.path(forResource: "newsType.plist", ofType: nil)
        guard let pathTemp = path else { return nil}
        let array = NSArray(contentsOfFile: pathTemp)
        guard let arraytemp = array as? [[String : Any]] else { return nil}
        
        var modelArray = [YJNewsTypeModel]()
        for item in arraytemp {
            let operationModel = YJNewsTypeModel(dict: item)
            modelArray.append(operationModel)
        }
        
        return modelArray
    }
    
    

}
