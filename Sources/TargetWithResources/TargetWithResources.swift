import Foundation

public class TargetWithResources {
    public init() {}
    
    public func contents() throws -> String? {
        guard let fileURL = Bundle.module.url(forResource: "file", withExtension: "txt") else {
            return nil
        }
        return try String(contentsOf: fileURL)
    }
}
