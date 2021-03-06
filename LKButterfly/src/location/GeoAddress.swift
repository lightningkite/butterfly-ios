// Generated by Khrysalis Swift converter - this file will be overwritten.
// File: location/GeoAddress.kt
// Package: com.lightningkite.butterfly.location
import Foundation

public class GeoAddress : Codable, KDataClass {
    public var coordinate: GeoCoordinate?
    public var name: String?
    public var street: String?
    public var subLocality: String?
    public var locality: String?
    public var subAdminArea: String?
    public var adminArea: String?
    public var countryName: String?
    public var postalCode: String?
    public init(coordinate: GeoCoordinate? = nil, name: String? = nil, street: String? = nil, subLocality: String? = nil, locality: String? = nil, subAdminArea: String? = nil, adminArea: String? = nil, countryName: String? = nil, postalCode: String? = nil) {
        self.coordinate = coordinate
        self.name = name
        self.street = street
        self.subLocality = subLocality
        self.locality = locality
        self.subAdminArea = subAdminArea
        self.adminArea = adminArea
        self.countryName = countryName
        self.postalCode = postalCode
        //Necessary properties should be initialized now
    }
    convenience required public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        self.init(
            coordinate: values.contains(.coordinate) ? try values.decode(GeoCoordinate?.self, forKey: .coordinate) : nil,
            name: values.contains(.name) ? try values.decode(String?.self, forKey: .name) : nil,
            street: values.contains(.street) ? try values.decode(String?.self, forKey: .street) : nil,
            subLocality: values.contains(.subLocality) ? try values.decode(String?.self, forKey: .subLocality) : nil,
            locality: values.contains(.locality) ? try values.decode(String?.self, forKey: .locality) : nil,
            subAdminArea: values.contains(.subAdminArea) ? try values.decode(String?.self, forKey: .subAdminArea) : nil,
            adminArea: values.contains(.adminArea) ? try values.decode(String?.self, forKey: .adminArea) : nil,
            countryName: values.contains(.countryName) ? try values.decode(String?.self, forKey: .countryName) : nil,
            postalCode: values.contains(.postalCode) ? try values.decode(String?.self, forKey: .postalCode) : nil
        )
    }
    
    enum CodingKeys: String, CodingKey {
        case coordinate = "coordinate"
        case name = "name"
        case street = "street"
        case subLocality = "subLocality"
        case locality = "locality"
        case subAdminArea = "subAdminArea"
        case adminArea = "adminArea"
        case countryName = "countryName"
        case postalCode = "postalCode"
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(self.coordinate, forKey: .coordinate)
        try container.encodeIfPresent(self.name, forKey: .name)
        try container.encodeIfPresent(self.street, forKey: .street)
        try container.encodeIfPresent(self.subLocality, forKey: .subLocality)
        try container.encodeIfPresent(self.locality, forKey: .locality)
        try container.encodeIfPresent(self.subAdminArea, forKey: .subAdminArea)
        try container.encodeIfPresent(self.adminArea, forKey: .adminArea)
        try container.encodeIfPresent(self.countryName, forKey: .countryName)
        try container.encodeIfPresent(self.postalCode, forKey: .postalCode)
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(coordinate)
        hasher.combine(name)
        hasher.combine(street)
        hasher.combine(subLocality)
        hasher.combine(locality)
        hasher.combine(subAdminArea)
        hasher.combine(adminArea)
        hasher.combine(countryName)
        hasher.combine(postalCode)
    }
    public static func == (lhs: GeoAddress, rhs: GeoAddress) -> Bool { return lhs.coordinate == rhs.coordinate && lhs.name == rhs.name && lhs.street == rhs.street && lhs.subLocality == rhs.subLocality && lhs.locality == rhs.locality && lhs.subAdminArea == rhs.subAdminArea && lhs.adminArea == rhs.adminArea && lhs.countryName == rhs.countryName && lhs.postalCode == rhs.postalCode }
    public var description: String { return "GeoAddress(coordinate = \(self.coordinate), name = \(self.name), street = \(self.street), subLocality = \(self.subLocality), locality = \(self.locality), subAdminArea = \(self.subAdminArea), adminArea = \(self.adminArea), countryName = \(self.countryName), postalCode = \(self.postalCode))" }
    public func copy(coordinate: GeoCoordinate?? = .some(nil), name: String?? = .some(nil), street: String?? = .some(nil), subLocality: String?? = .some(nil), locality: String?? = .some(nil), subAdminArea: String?? = .some(nil), adminArea: String?? = .some(nil), countryName: String?? = .some(nil), postalCode: String?? = .some(nil)) -> GeoAddress { return GeoAddress(coordinate: invertOptional(coordinate) ?? self.coordinate, name: invertOptional(name) ?? self.name, street: invertOptional(street) ?? self.street, subLocality: invertOptional(subLocality) ?? self.subLocality, locality: invertOptional(locality) ?? self.locality, subAdminArea: invertOptional(subAdminArea) ?? self.subAdminArea, adminArea: invertOptional(adminArea) ?? self.adminArea, countryName: invertOptional(countryName) ?? self.countryName, postalCode: invertOptional(postalCode) ?? self.postalCode) }
    
    public func oneLine(withCountry: Bool = false, withZip: Bool = false) -> String {
        let builder = Box("")
        if let it = (self.street) { 
            builder.value.append(it)
        }
        if let it = (self.locality) { 
            builder.value.append(" ")
            builder.value.append(it)
        }
        if let it = (self.adminArea) { 
            builder.value.append(", ")
            builder.value.append(it)
        }
        if withCountry {
            if let it = (self.adminArea) { 
                builder.value.append(" ")
                builder.value.append(it)
            }
        }
        if withZip {
            if let it = (self.postalCode) { 
                builder.value.append(" ")
                builder.value.append(it)
            }
        }
        return builder.value.trimmingCharacters(in: .whitespacesAndNewlines)
    }
}


