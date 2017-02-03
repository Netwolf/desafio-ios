import Foundation
import Alamofire

// MARK: -  -
public protocol RestShipResource {
    var name: String { get }
}

// MARK: -  -
public enum Result<T> {
    case success(T)
    case error(String)
}

// MARK: - -
public struct RestShip {
    fileprivate static var params: [String: AnyObject]?
    fileprivate static var URLrequest: URLRequest?
    fileprivate static var encoding: ParameterEncoding = URLEncoding.default
    fileprivate static var RequestOnURL: String?
    fileprivate static var header: [String: AnyObject]?
    
    public struct Configuration {
        public init() { }
    }
}

// MARK: - -
public extension RestShip.Configuration {
    public static var BaseURL =  ""
    public static var Timeout: TimeInterval = 60
}

// MARK: - -

public extension RestShip.Configuration {
    
    fileprivate static func grounpSetString(object: String, forkey key: String) {
        let defaults = UserDefaults(suiteName: "group.com.codechallenge.ios")
        defaults!.setValue(object, forKey: key)
    }
    
    fileprivate static func defaultsStringForKey(_ key: String) -> String {
        let defaults = UserDefaults.standard
        guard let object = defaults.string(forKey: key)
            else { return "" }
        return object
    }
    
    fileprivate static func defaultsDoubleForKey(_ key: String) -> Double {
        let defaults = UserDefaults.standard
        return defaults.double(forKey: key)
    }
    
    fileprivate static func defaultsSetString(_ object: String, forkey key: String) {
        let defaults = UserDefaults.standard
        defaults.setValue(object, forKey: key)
    }
    
    fileprivate static func defaultsSetdouble(_ object: Double, forkey key: String) {
        let defaults = UserDefaults.standard
        defaults.set(object, forKey: key)
    }
}

// MARK: - -

public extension RestShip {
    
    public static func request(_ callback: @escaping (Result<String>) -> Void) {
        
        func resumeRequest(_ request: URLRequest) {
            var mutableURLRequest = try! encoding.encode(request, with: params)
            if let header = header {
                for key in header.keys {
                    let value = header[key] as! String
                    mutableURLRequest.setValue(value, forHTTPHeaderField: key)
                }
            }
            Alamofire.request(mutableURLRequest)
                .validate()
                .responseJSON { response in
                    if let httpResponse = response.response {
                        switch httpResponse.statusCode {
                        case 202:
                            callback(Result.success("Success"))
                        case 204:
                            callback(Result.success("Success"))
                        default:
                            switch response.result {
                            case .success(_):
                                if let result = response.result.value {
                                    do {
                                        let jsonData = try JSONSerialization.data(withJSONObject: result, options: .prettyPrinted)
                                        if let resp = String(bytes: jsonData, encoding: String.Encoding.utf8) {
                                            callback(Result.success(resp))
                                            
                                        } else {
                                            callback(Result.error("Internal error."))
                                            
                                        }
                                    } catch {
                                        callback(Result.error("Internal error."))
                                    }
                                    
                                } else {
                                    callback(Result.error("Internal error."))
                                }
                                break
                            case .failure(let error):
                                callback(Result.error(error.localizedDescription))
                                break
                            }
                        }
                        
                    } else {
                        callback(Result.error("Internal error."))
                    }
            }
            
            clearOldData()
        }
        
        if let request = self.URLrequest {
            resumeRequest(request)
        }
    }
    
    fileprivate static func isValidDate(_ fromDate: Date) -> Bool {
        switch Date().compare(fromDate) {
        case .orderedDescending:
            return false
        default:
            return true
        }
    }
    
    fileprivate static func clearOldData() {
        RestShip.params = nil
        RestShip.URLrequest = nil
        RestShip.encoding = URLEncoding.default
        RestShip.RequestOnURL = nil
        RestShip.header = nil
    }
    
    fileprivate static func URL() -> Foundation.URL? {
        if RestShip.RequestOnURL != nil && !RestShip.RequestOnURL!.isEmpty {
            return Foundation.URL(string: RestShip.RequestOnURL!)!
        } else if !RestShip.Configuration.BaseURL.isEmpty {
            return Foundation.URL(string: RestShip.Configuration.BaseURL)!
        }
        assertionFailure("you need set baseURL or call withURL() method")
        return nil
    }
}

// MARK: - -

public extension RestShip {
    
    public enum Encoding {
        case json
        case url
    }
    
    public static func header(header: [String: AnyObject]) -> RestShip.Type {
        self.header = header
        return self
    }
    
    
    public static func parameterEncoding(_ encoding: RestShip.Encoding) -> RestShip.Type {
        switch encoding {
        case .json:
            self.encoding = JSONEncoding.default
        default:
            self.encoding = URLEncoding.default
        }
        return self
    }
}

// MARK: - -

public extension RestShip {
    
    public enum Method: String {
        case GET, POST, PUT, PATCH, DELETE
    }
    
    public static func method(_ method: RestShip.Method) -> RestShip.Type {
        assert(URLrequest != nil, "You must call resource() before adding method")
        URLrequest?.httpMethod = method.rawValue
        return self
    }
}

// MARK: - -

public extension RestShip {
    public static func queryParams(_ params: [String: AnyObject]) -> RestShip.Type {
        self.params = params
        return self
    }
}

// MARK: - -

public extension RestShip {
    public static func resource(_ resource: RestShipResource) -> RestShip.Type {
        URLrequest = URLRequest(url: RestShip.URL()!.appendingPathComponent(resource.name))
        URLrequest?.timeoutInterval = RestShip.Configuration.Timeout
        return self
    }
}

public typealias EspecificURL = RestShip
public extension EspecificURL {
    public static func fromURL(_ path: String) -> RestShip.Type {
        RestShip.RequestOnURL = path
        return self
    }
}
