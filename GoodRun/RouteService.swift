import Foundation

package enum RouteStepType: String {
    case:
    
}

package struct RouteStepAction {
    let orderId: Int
    let type: RouteStepType
    
    enum RouteStepType {
        case pickup
        case dropup
        
}
    
package struct RouteStep {
    var actions: [RouteStepAction]
    let location: Location
}

package class RouteService {
    
    
    
    func naiveRoute(orders: [Order]) {
        
        
    }
    
    func validateRoute(orders: [Order], route: [Location]) {
        
        // First check that every referenced activity at each step cooresponds to the right location
        
        // Then check that pickups are done before drop-offs
        
        for location in route {
            
        }
    }
    
}
