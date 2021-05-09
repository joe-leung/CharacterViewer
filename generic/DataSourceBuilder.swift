//
//  DataSourceBuilder.swift
//  GenericViewer
//
//  Created by Joe Leung on 5/8/21.
//

import Foundation

class DataSourceBuilder {
    
    var urlString: String
    var dataSourceData: Array<Any>
    
    
    init(withURL sourceURL: String) {
        urlString = sourceURL
        dataSourceData = []
        pullData()
    }
    
    func getDataSource() -> Array<Any> {
        return self.dataSourceData
    }
    
    private func pullData() {
        
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        var urlRequest = URLRequest(url: URL(string: urlString)!)
        urlRequest.httpMethod = "GET"

        let task = session.dataTask(with: urlRequest) { [weak self] data, response, error in
            do {
                //here dataResponse received from a network request
                let jsonResponse = try JSONSerialization.jsonObject(with: data!, options: [])
                guard let dict = jsonResponse as? Dictionary<String, Any> else {
                      return
                }
                self?.dataSourceData = dict["RelatedTopics"] as! Array<Any>
                NotificationCenter.default.post(name: Notification.Name("PullDataTaskDone"), object: nil)
             } catch let parsingError {
                print("Error", parsingError)
           }
        }
        task.resume()
    }
}
