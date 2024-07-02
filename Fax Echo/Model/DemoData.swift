//
//  DemoData.swift
//  Fax Echo
//
//  Created by Tatsuya Moriguchi on 6/15/24.
//

import Foundation

struct DemoData {
    // Example data for Routing_Data, Transmission_Data, and Client_Tracking_Data for Preivew
    let routingDataExample: Routing_Data
    let transmissionDataExample: Transmission_Data
    let clientTrackingDataExample: Client_Tracking_Data

    // Example data for Fax
    let demoFax: Fax

    init() {
        // Initialize example data
        self.routingDataExample = Routing_Data(to_name: "John Doe",
                                               to_company: "Doe Inc.",
                                               subject: "Monthly Report",
                                               from_name: "Jane Smith")

        self.transmissionDataExample = Transmission_Data(transmission_status: "Success",
                                                         billable_retries: 1,
                                                         error_code: nil,
                                                         error_message: nil)

        self.clientTrackingDataExample = Client_Tracking_Data(client_code: "ABC123",
                                                              client_id: "001",
                                                              client_name: "John Doe",
                                                              client_reference_id: "REF2024",
                                                              billing_code: "BILL001")

        // Initialize demoFax with the example data
        self.demoFax = Fax(fax_id: "FAX123456",
                           size: 12345,
                           duration: 300,
                           pages: 10,
                           image_downloaded: true,
                           fax_status: "Completed",
                           completed_timestamp: "2024-05-21T04:27:56.000+0000",
                           direction: "outbound",
                           destination_fax_number: "1234567890",
                           originating_fax_number: "987654321",
                           originating_fax_tsid: "South West Clinic",
                           destination_fax_csid: "CSID12345",
                           routing_data: [self.routingDataExample],
                           transmission_data: [self.transmissionDataExample],
                           client_tracking_data: [self.clientTrackingDataExample])
    }
}
