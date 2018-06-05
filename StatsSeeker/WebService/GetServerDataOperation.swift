//
//  GetServerDataOperation.swift
//  StatsSeeker
//
//  Created by Сергей Никитин on 05.06.2018.
//  Copyright © 2018 Sergey Nikitin. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class GetServerDataOperation: AsyncOperation {
    
    override func cancel() {
        request.cancel()
        super.cancel()
    }
    
    private var request: DataRequest
    private var url: String
    private var parameters: Parameters?
    var data: Data?
    
    override func main() {
        request.responseData(queue: DispatchQueue.global()) { [weak self] response in
            self?.data = response.data
            self?.state = .finished
        }
    }
    
    init(url: String, parameters: Parameters?) {
        self.url = appConfig.shared.apiURL2 + appConfig.shared.apiVersion + url
        self.parameters = parameters
        request = Alamofire.request(self.url, method: .get, parameters: self.parameters)
        
    }
}
