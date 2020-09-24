// Generated by Butterfly Swift converter - this file will be overwritten.
// File: views/DjangoErrorTranslator.shared.kt
// Package: com.lightningkite.butterfly.views
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
                let key = _it.key
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
    public func parseError(code: Int, error: String?) -> ViewString? {
        var resultError: ViewString? = nil
        switch code / 100 {
            case 0:
            resultError = ViewStringResource(resource: self.connectivityErrorResource)
            break
            case 1, 2, 3:
            
            break
            case 4:
            let errorJson = error?.fromJsonStringUntyped()
            if let errorJson = errorJson {
                let builder = Box("")
                self.handleNode(builder: builder, node: errorJson)
                resultError = ViewStringRaw(string: builder.value)
            } else {
                resultError = ViewStringRaw(string: error ?? "")
            }
            break
            case 5:
            resultError = ViewStringResource(resource: self.serverErrorResource)
            break
            default:
            resultError = ViewStringResource(resource: self.otherErrorResource)
            break
        }
        
        return resultError
    }
    
    public func wrap<T>(callback: @escaping  (T?, ViewString?) -> Void) -> (Int, T?, String?) -> Void {
        return { (code, result, error) -> Void in callback(result, self.parseError(code: code, error: error)) }
    }
    
    public func wrapNoResponse(callback: @escaping  (ViewString?) -> Void) -> (Int, String?) -> Void {
        return { (code, error) -> Void in callback(self.parseError(code: code, error: error)) }
    }
    
}

