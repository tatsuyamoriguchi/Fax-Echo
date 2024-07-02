//
//  Fax.swift
//  Fax Echo
//
//  Created by Tatsuya Moriguchi on 5/23/24.
//
import Foundation

class Fax: ObservableObject, Decodable, Identifiable, Hashable {
        // Conforming to Hashable
        static func == (lhs: Fax, rhs: Fax) -> Bool {
            return lhs.fax_id == rhs.fax_id &&
                   lhs.size == rhs.size &&
                   lhs.duration == rhs.duration &&
                   lhs.pages == rhs.pages &&
                   lhs.image_downloaded == rhs.image_downloaded &&
                   lhs.fax_status == rhs.fax_status &&
                   lhs.completed_timestamp == rhs.completed_timestamp &&
                   lhs.direction == rhs.direction &&
                   lhs.destination_fax_number == rhs.destination_fax_number &&
                   lhs.originating_fax_number == rhs.originating_fax_number &&
                   lhs.originating_fax_tsid == rhs.originating_fax_tsid &&
                   lhs.destination_fax_csid == rhs.destination_fax_csid &&
                   lhs.routing_data == rhs.routing_data &&
                   lhs.transmission_data == rhs.transmission_data &&
                   lhs.client_tracking_data == rhs.client_tracking_data
        }
        
        func hash(into hasher: inout Hasher) {
            hasher.combine(fax_id)
            hasher.combine(size)
            hasher.combine(duration)
            hasher.combine(pages)
            hasher.combine(image_downloaded)
            hasher.combine(fax_status)
            hasher.combine(completed_timestamp)
            hasher.combine(direction)
            hasher.combine(destination_fax_number)
            hasher.combine(originating_fax_number)
            hasher.combine(originating_fax_tsid)
            hasher.combine(destination_fax_csid)
            hasher.combine(routing_data)
            hasher.combine(transmission_data)
            hasher.combine(client_tracking_data)
        }
    
    
    var id: String {
        return fax_id
    }
    
    @Published var fax_id: String
    @Published var size: Int
    @Published var duration: Int
    @Published var pages: Int
    @Published var image_downloaded: Bool
    @Published var fax_status: String
    @Published var completed_timestamp: String
    @Published var direction: String?
    @Published var destination_fax_number: String
    @Published var originating_fax_number: String
    @Published var originating_fax_tsid: String
    @Published var destination_fax_csid: String?
    @Published var routing_data: [Routing_Data]?
    @Published var transmission_data: [Transmission_Data]?
    @Published var client_tracking_data: [Client_Tracking_Data]?

    // Custom initializer
    init(fax_id: String, size: Int, duration: Int, pages: Int, image_downloaded: Bool, fax_status: String, completed_timestamp: String, direction: String?, destination_fax_number: String, originating_fax_number: String, originating_fax_tsid: String, destination_fax_csid: String?, routing_data: [Routing_Data]?, transmission_data: [Transmission_Data]?, client_tracking_data: [Client_Tracking_Data]?) {
        self.fax_id = fax_id
        self.size = size
        self.duration = duration
        self.pages = pages
        self.image_downloaded = image_downloaded
        self.fax_status = fax_status
        self.completed_timestamp = completed_timestamp
        self.direction = direction
        self.destination_fax_number = destination_fax_number
        self.originating_fax_number = originating_fax_number
        self.originating_fax_tsid = originating_fax_tsid
        self.destination_fax_csid = destination_fax_csid
        self.routing_data = routing_data
        self.transmission_data = transmission_data
        self.client_tracking_data = client_tracking_data
    }

    // Required for Decodable
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.fax_id = try container.decode(String.self, forKey: .fax_id)
        self.size = try container.decode(Int.self, forKey: .size)
        self.duration = try container.decode(Int.self, forKey: .duration)
        self.pages = try container.decode(Int.self, forKey: .pages)
        self.image_downloaded = try container.decode(Bool.self, forKey: .image_downloaded)
        self.fax_status = try container.decode(String.self, forKey: .fax_status)
        self.completed_timestamp = try container.decode(String.self, forKey: .completed_timestamp)
        self.direction = try container.decodeIfPresent(String.self, forKey: .direction)
        self.destination_fax_number = try container.decode(String.self, forKey: .destination_fax_number)
        self.originating_fax_number = try container.decode(String.self, forKey: .originating_fax_number)
        self.originating_fax_tsid = try container.decode(String.self, forKey: .originating_fax_tsid)
        self.destination_fax_csid = try container.decodeIfPresent(String.self, forKey: .destination_fax_csid)
        self.routing_data = try container.decodeIfPresent([Routing_Data].self, forKey: .routing_data)
        self.transmission_data = try container.decodeIfPresent([Transmission_Data].self, forKey: .transmission_data)
        self.client_tracking_data = try container.decodeIfPresent([Client_Tracking_Data].self, forKey: .client_tracking_data)
    }
    
    enum CodingKeys: String, CodingKey {
        case fax_id
        case size
        case duration
        case pages
        case image_downloaded
        case fax_status
        case completed_timestamp
        case direction
        case destination_fax_number
        case originating_fax_number
        case originating_fax_tsid
        case destination_fax_csid
        case routing_data
        case transmission_data
        case client_tracking_data
    }
}


struct Routing_Data: Decodable, Equatable, Hashable {
    let to_name: String?
    let to_company: String?
    let subject: String?
    let from_name: String?
}

struct Transmission_Data: Decodable, Equatable, Hashable {
    let transmission_status: String?
    let billable_retries: Int?
    let error_code: String?
    let error_message: String?
    
}

struct Client_Tracking_Data: Decodable, Equatable, Hashable {
    let client_code: String?
    let client_id: String?
    let client_name: String?
    let client_reference_id: String?
    let billing_code: String?
    
}

struct MultipleReceivedFaxesResponse: Decodable {
    let faxes: [Fax]
}
