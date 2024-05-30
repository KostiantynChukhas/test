
import Foundation

extension TestItemModel: DecodableResponse {}

class GetItemsRequest: ProjectRequest {
      typealias Response = [TestItemModel]
    
    let method: HTTPMethod = .get
    var ProjectPath: ProjectPath
    
    init() {
        self.ProjectPath = .getItems
    }
    
    deinit {
        printDeinit(self)
    }
}
