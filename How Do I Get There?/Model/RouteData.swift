//
//  RouteData.swift
//  How Do I Get There?
//
//  Created by Maciej Sałuda on 30/01/2022.



import Foundation

// MARK: - RouteData
struct RouteData: Codable {
    let routes: [Route]
}

// MARK: - Route
struct Route: Codable {
    let id: String
    let sections: [Section]
}

// MARK: - Section
struct Section: Codable {
    let id, type: String
    let departure, arrival: Arrival
    let transport: Transport
    let agency: Agency?
    let attributions: [Attribution]?
}

// MARK: - Agency
struct Agency: Codable {
    let id, name: String
    let website: String
}

// MARK: - Arrival
struct Arrival: Codable {
    let time: String?
    let place: Place
}

// MARK: - Place
struct Place: Codable {
    let name: String?
    let type: String
    let location: Location
    let id, code: String?
}

// MARK: - Location
struct Location: Codable {
    let lat, lng: Double
}

// MARK: - Attribution
struct Attribution: Codable {
    let id: String
    let href: String
    let text, type: String
}

// MARK: - Transport
struct Transport: Codable {
    let mode: String
    let name, category, color, headsign: String?
    let shortName: String?
}
