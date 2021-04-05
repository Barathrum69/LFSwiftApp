//
//  TempUserModel.swift
//  ymsports
//
//  Created by wood on 4/3/21.
//

import Foundation
import HandyJSON

/**
 测试模型
 {
   "code": 0,
   "msg": "success",
   "data": {
       "name": "wood",
       "age": 12,
       "list": [
           {"name": "wood", "age": 12},
           {"name": "tom", "age": 20}
       ]
   }
 }
 */
struct TempUserModel: HandyJSON {
    var name: String = ""
    var age: Int = 0

    mutating func mapping(mapper: HelpingMapper) {
        mapper <<<
            name <-- "name"
        mapper <<<
            age <-- "age"
    }
}
