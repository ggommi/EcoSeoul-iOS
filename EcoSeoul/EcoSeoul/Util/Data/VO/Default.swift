//
//  DefaultVO.swift
//  EcoSeoul
//
//  Created by 이충신 on 2018. 9. 25..
//  Copyright © 2018년 GGOMMI. All rights reserved.
//

import Foundation

struct Default: Codable {
    let message: String
    enum CodingKeys: String, CodingKey {
        case message = "message"
    }
}
