import Foundation
import CoreLocation

package struct RouteStep {
    let order: Order
    let type: RouteStepType
    let location: Location
    
    enum RouteStepType {
        case pickup
        case dropoff
        
    }
}
    
package class RouteService {
    
    private var locationManager = LocationManager()
    
    func closerStep(a: RouteStep, b: RouteStep, from: CLLocationCoordinate2D) -> Bool {
        
        let locationA = CLLocation(latitude: a.location.latitude, longitude: a.location.longitude)
        let locationB = CLLocation(latitude: b.location.latitude, longitude: b.location.longitude)
        
        let distanceA = locationA.distance(from:
                                            CLLocation(latitude: from.latitude, longitude: from.longitude))
        let distanceB = locationB.distance(from:
                                            CLLocation(latitude: from.latitude, longitude: from.longitude))
        
        return distanceA > distanceB
    }
    
    func naiveRoute(orders: [Order]) -> [RouteStep] {
        
        var allSteps: [RouteStep] = []
        for order in orders {
            allSteps.append(
                RouteStep(order: order, type: .pickup, location: order.to)
            )
            allSteps.append(
                RouteStep(order: order, type: .dropoff, location: order.from))
        }
        
        if !(allSteps.count > 0) {
            return []
        }
        
        var route: [RouteStep] = []
        var from = locationManager.location ??
        CLLocationCoordinate2D(latitude: allSteps[0].location.latitude, longitude: allSteps[0].location.longitude)
        
        var pickedUpOrders: Set<String> = []
        
        for _ in allSteps {
            var validNext = allSteps.filter() { (step: RouteStep) in
                (step.type == .pickup
                 || pickedUpOrders.contains(step.order.id))
                
                && !route.contains {s in s.order.orderId == step.order.orderId && s.type == step.type }
            }
            
            route.append(
                validNext.max(
                    by: { closerStep(a: $0, b: $1, from: from) } )!)
        }
        
        return route
    }
    
    func validateRoute(orders: [Order], route: [RouteStep]) -> Bool {
        var pickupsCompleted: Set<String> = []
        for step in route {
            if step.type == .dropoff {
                if (!pickupsCompleted.contains(step.order.orderId)) {
                    return false
                }
            }
            else {
                pickupsCompleted.insert(step.order.orderId)
            }
        }
        return true
    }
    
}

