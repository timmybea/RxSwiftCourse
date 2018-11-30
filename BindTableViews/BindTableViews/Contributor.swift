//
//  Contributor.swift
//  BindTableViews
//
//  Created by Tim Beals on 2018-10-09.
//  Copyright © 2018 Roobi Creative. All rights reserved.
//

import Foundation

struct Contributor {
    let name: String
    let email: String
    
    static func getDatasource() -> [Contributor] {
        return [Contributor(name: "Tim Beals", email: "tim.beals@gmail.com"),
                Contributor(name: "Tara Beals", email: "tara.beals@gmail.com"),
                Contributor(name: "Holly Beals", email: "holly.beals@gmail.com"),
                Contributor(name: "Ruby Blaine Roberts", email: "roobi@roobicreative.com")]
    }
    
}
