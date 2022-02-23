//
//  routeManager.swift
//  How Do I Get There?
//
//  Created by Maciej Sałuda on 29/01/2022.
//


import CoreLocation
import UIKit

protocol RouteManagerDelegate {
    func didUpdateRoute(routeModel: RouteModel)
    func didFailWithError (error:Error)
}

struct RouteManager {
    
    var delegate : RouteManagerDelegate?
    var routeModel: RouteModel?
    
    func fetchRoute(userLocation: CLLocation, destinationLocation: CLLocation) {
        let urlString = "https://transit.router.hereapi.com/v8/routes?apiKey=VHGYW32OP9XPhBJ2172ZKzZf0HiXNG2pZ4oZM0sq9Z0&origin=\(userLocation.coordinate.latitude),\(userLocation.coordinate.longitude)&destination=\(destinationLocation.coordinate.latitude),\(destinationLocation.coordinate.longitude)"
        print(urlString)
        
        performRequest(with: urlString)
    }
    
    func performRequest(with urlString : String) {
        if let url = URL(string : urlString) {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    self.delegate?.didFailWithError(error:error!)
                    return
                }
                if let safeData = data {
                    if let route = self.parseJSON(safeData) {
                        delegate?.didUpdateRoute(routeModel: route)
                    }
                }
            }
            task.resume()
        }
    }
    
    func parseJSON(_  routeData: Data) -> RouteModel? {
       let decoder = JSONDecoder()
        do {
            
            let decodedData = try decoder.decode(RouteData.self, from: routeData)
            let bus = decodedData.routes[0].sections[1].transport.shortName ?? ""
            let oriTime = decodedData.routes[0].sections[0].departure.time ?? ""
            let oriPlace = decodedData.routes[0].sections[0].arrival.place.name ?? ""
            var destPlace = ""
            if let destination = decodedData.routes[0].sections[1].arrival.place.name, !destination.isEmpty {
                destPlace = destination
            } else {
                let lat = decodedData.routes.first?.sections.first?.departure.place.location.lat
                let lon = decodedData.routes.first?.sections.first?.departure.place.location.lng
                
                if let lat = lat, let lon =  lon {
                    destPlace = "\(lat)" + ", " + "\(lon)"
                }
            }
            let route = RouteModel(originTime: oriTime, originPlace: oriPlace, destinationPlace: destPlace, busNumb: bus)
           
            return route
        }
        catch {
            delegate?.didFailWithError(error: error)
        }
        return nil
    }
}



