//
//  Created by Andrew Schools on 6/6/19.
//  Copyright © 2019 Andrew Schools. All rights reserved.
//

import Foundation

class DnsRow {
    var domain: String
    var ttl: Int
    var type: String
    var ip: String
    
    init(domain: String?, ttl: Int?, type: String?, ip: String?) {
        if let domain = domain {
            self.domain = domain
        }
        else {
            self.domain = "--"
        }
        
        if let ttl = ttl {
            self.ttl = ttl
        }
        else {
            self.ttl = -1
        }
        
        if let type = type {
            self.type = type
        }
        else {
            self.type = "--"
        }
        
        if let ip = ip {
            self.ip = ip
        }
        else {
            self.ip = "--"
        }
    }
}
