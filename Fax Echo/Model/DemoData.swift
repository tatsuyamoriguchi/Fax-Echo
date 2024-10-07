//
//  DemoData.swift
//  Fax Echo
//
//  Created by Tatsuya Moriguchi on 6/15/24.
//

import Foundation

struct DemoData {
    // Example data for Routing_Data, Transmission_Data, and Client_Tracking_Data for Preivew
    let fax1RoutingData: Routing_Data
    let fax1TransmissionData: Transmission_Data
    let fax1ClientTrackingData: Client_Tracking_Data
    let fax2RoutingData: Routing_Data
    let fax2TransmissionData: Transmission_Data
    let fax2ClientTrackingData: Client_Tracking_Data

    // Example data for Fax
    let demoFaxes: [Fax]
    
    init() {
        // Initialize example data
        let fax1RoutingData = Routing_Data(to_name: "John Doe",
                                           to_company: "Doe Inc.",
                                           subject: "Monthly Report",
                                           from_name: "Jane Smith")
        
        let fax1TransmissionData = Transmission_Data(transmission_status: "Success",
                                                 billable_retries: 1,
                                                 error_code: nil,
                                                 error_message: nil)
        
        let fax1ClientTrackingData = Client_Tracking_Data(client_code: "ABC123",
                                                          client_id: "001",
                                                          client_name: "John Doe",
                                                          client_reference_id: "REF2024",
                                                          billing_code: "BILL001")
        
        let fax2RoutingData = Routing_Data(to_name: "Alice Brown",
                                           to_company: "Brown Corp.",
                                           subject: "Quarterly Review",
                                           from_name: "Bob Johnson")
        
        let fax2TransmissionData = Transmission_Data(transmission_status: "Failure",
                                                     billable_retries: 2,
                                                     error_code: "E001",
                                                     error_message: "Line Busy")
        
        let fax2ClientTrackingData = Client_Tracking_Data(client_code: "XYZ789",
                                                          client_id: "002",
                                                          client_name: "Alice Brown",
                                                          client_reference_id: "REF2025",
                                                          billing_code: "BILL002")
        
        
        // Initialize demoFax with the example data
        self.demoFaxes = [
            Fax(fax_id: "FAX123456",
                size: 12345,
                duration: 500,
                pages: 10,
                image_downloaded: true,
                fax_status: "Completed",
                completed_timestamp: "2024-05-21T04:27:56.000+0000",
                direction: "inbound",
                destination_fax_number: "1234567890",
                originating_fax_number: "9876541111",
                originating_fax_tsid: "South West Clinic",
                destination_fax_csid: "CSID12345",
                routing_data: [fax1RoutingData],
                transmission_data: [fax1TransmissionData],
                client_tracking_data: [fax1ClientTrackingData]
               ),
            Fax(fax_id: "FAX123777",
                size: 123,
                duration: 300,
                pages: 2,
                image_downloaded: false,
                fax_status: "Completed",
                completed_timestamp: "2024-08-11T04:27:56.000+0000",
                direction: "inbound",
                destination_fax_number: "1234567890",
                originating_fax_number: "987654321",
                originating_fax_tsid: "California Clinic",
                destination_fax_csid: "CSID12345",
                routing_data: [fax1RoutingData],
                transmission_data: [fax1TransmissionData],
                client_tracking_data: [fax1ClientTrackingData]
               ),
            
            Fax(
                fax_id: "FAX987654",
                size: 54321,
                duration: 240,
                pages: 5,
                image_downloaded: false,
                fax_status: "Pending",
                completed_timestamp: "2024-06-01T10:15:00.000+0000",
                direction: "inbound",
                destination_fax_number: "0987654321",
                originating_fax_number: "5678901234",
                originating_fax_tsid: "North East Clinic",
                destination_fax_csid: nil,
                routing_data: [fax2RoutingData],
                transmission_data: [fax2TransmissionData],
                client_tracking_data: [fax2ClientTrackingData]
            )
        ]
        
        // Assign example data to struct properties
        self.fax1RoutingData = fax1RoutingData
        self.fax1TransmissionData = fax1TransmissionData
        self.fax1ClientTrackingData = fax1ClientTrackingData
        self.fax2RoutingData = fax2RoutingData
        self.fax2TransmissionData = fax2TransmissionData
        self.fax2ClientTrackingData = fax2ClientTrackingData

    }
    
}
