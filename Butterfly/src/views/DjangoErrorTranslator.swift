// Generated by Khrysalis Swift converter - this file will be overwritten.
// File: views/DjangoErrorTranslator.kt
// Package: com.lightningkite.butterfly.views
import RxSwift
import Foundation

public class DjangoErrorTranslator {
    public var connectivityErrorResource: StringResource
    public var serverErrorResource: StringResource
    public var otherErrorResource: StringResource
    public init(connectivityErrorResource: StringResource, serverErrorResource: StringResource, otherErrorResource: StringResource) {
        self.connectivityErrorResource = connectivityErrorResource
        self.serverErrorResource = serverErrorResource
        self.otherErrorResource = otherErrorResource
        //Necessary properties should be initialized now
    }
    
    
    public func handleNode(builder: Box<String>, node: Any?) -> Void {
        if node == nil { return }
        if let node = node as? NSDictionary {
            for _it in node{
                let value = _it.value
                
                self.handleNode(builder: builder, node: value)
                
            }
        } else if let node = node as? NSArray {
            for value in (node){
                self.handleNode(builder: builder, node: value)
            }
        } else if let node = node as? String {
            //Rough check for human-readability - sentences start with uppercase and will have spaces
            if (!node.isEmpty), node[0].isUppercase, (node.indexOf(string: " ") != -1) {
                builder.value.append(node + "\n")
            }
        }
    }
    public func parseError(code: Int, error: String?) -> ViewString {
        switch code / 100 {
            case 0:
            return ViewStringResource(resource: self.connectivityErrorResource)
            break
            case 1, 2, 3:
            
            break
            case 4:
            let errorJson = error?.fromJsonStringUntyped()
            if let errorJson = errorJson {
                let builder = Box("")
                self.handleNode(builder: builder, node: errorJson)
                return ViewStringRaw(string: builder.value)
            } else {
                return ViewStringRaw(string: error ?? "")
            }
            break
            case 5:
            return ViewStringResource(resource: self.serverErrorResource)
            break
            default:
            
            break
        }
        
        return ViewStringResource(resource: self.otherErrorResource)
    }
    
    public func wrap<T>(callback: @escaping  (T?, ViewString?) -> Void) -> (Int, T?, String?) -> Void {
        return { (code, result, error) -> Void in callback(result, self.parseError(code: code, error: error)) }
    }
    
    public func wrapNoResponse(callback: @escaping  (ViewString?) -> Void) -> (Int, String?) -> Void {
        return { (code, error) -> Void in callback(self.parseError(code: code, error: error)) }
    }
    
    public func parseException(exception: Any) -> Single<ViewString> {
        return run { () -> Single<ViewString> in 
            if let exception = exception as? HttpResponseException {
                return exception.response.readText()
                    .map({ (it) -> ViewString in self.parseError(code: exception.response.code, error: it) })
            } else if let exception = exception as? NSError, exception.code == NSURLErrorTimedOut {
                return Single.just(ViewStringResource(resource: self.connectivityErrorResource))
            } else  {
                return Single.just(ViewStringResource(resource: self.otherErrorResource))
            }
        }
    }
}


