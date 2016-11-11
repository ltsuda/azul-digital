//
//  Constants.swift
//  Azul Digital
//
//  Created by Leonardo Tsuda on 15/09/16.
//  Copyright © 2016 Leonardo Tsuda. All rights reserved.
//

import Foundation
import Firebase

let rootFBReference = FIRDatabase.database().reference()
let defaults = UserDefaults.standard

// MARK: - Project Constants
enum Project {

    // Image Names
    enum Images {
        enum Buttons: String, ImageRepresentable {
            case buy                    = "image.buy"
            case buy_enabled            = "image.buy_enabled"
            case buy_ticket             = "image.buy_ticket"
            case buy_ticket_enabled     = "image.buy_ticket_enabled"
        }
    }
    
    // Localizable Strings
    enum Localizable {
        
        // Common
        enum Common: String, LocalizeRepresentable {
            case empty                                  = "common.empty"
            case empty_description                      = "common.empty_description"
            case fill_email_pass                        = "common.fill.email_pass"
            case try_again                              = "common.try_again"
            case invalid_email                          = "common.invalid_email"
            case invalid_email_description              = "common.invalid_email_description"
            case email_used                             = "common.email_used"
            case email_used_description                 = "common.email_used_description"
            case weak_pass                              = "common.weak_pass"
            case weak_pass_description                  = "common.weak_pass_description"
            case code                                   = "common.code"
            case ok                                     = "common.ok"
            case service_disabled                       = "common.service_disabled"
            case service_disabled_description           = "common.service_disabled_description"
            case account_disabled                       = "common.account_disabled"
            case wrong_pass                             = "common.wrong_pass"
            case wrong_pass_description                 = "common.wrong_pass_description"
            case wrong_format                           = "common.wrong_format"
            case wrong_format_description               = "common.wrong_format_description"
            case fill_fields_description                = "common.fill_fields_description"
            case car_used                               = "common.car_used"
            case car_used_description                   = "common.car_used_description"
            case plate_format_description               = "common.plate_format_description"
            case user_inexistent                        = "common.user_inexistent"
            case user_inexistent_description            = "common.user_inexistent_description"
            case empty_cash                             = "common.empty_cash"
            case empty_cash_description                 = "common.empty_cash_description"
            case data_inexistent                        = "common.data_inexistent"
            case data_inexistent_description            = "common.data_inexistent_description"
            case save_timeout_description               = "common.save_timeout_description"
            case code_1                                 = "common.code_1"
            case save_timeout                           = "common.save_timeout"
            case loading_data                           = "common.loading_data"
            case buy_ticket_description                 = "common.buy_ticket_description"
            case no_address                             = "common.no_address"
            case card                                   = "common.card"
            case card_description                       = "common.card_description"
            case car                                    = "common.car"
            case car_description                        = "common.car_description"
            case cancel                                 = "common.cancel"
            case buy                                    = "common.buy"
            case confirmation                           = "common.confirmation"
            case value                                  = "common.value"
            case time                                   = "common.time"
            case email_format                           = "common.email_format"
            case password                                   = "common.password"
            case first_name                               = "common.first_name"
            case last_name                              = "common.last_name"
            case brand                                  = "common.brand"
            case model                                  = "common.model"
            case color                                  = "common.color"
            case empty_address                          = "common.empty_address"
            case profile_title                          = "common.profile_title"
            case settings                               = "common.settings_title"
            case history                               = "common.history"
        }
    }
}


// MARK: - Representable Protocols
protocol ImageRepresentable: RawRepresentable {
    var image: String { get }
}

protocol LocalizeRepresentable: RawRepresentable {
    var localized: String { get }
}


// MARK: - Representable Protocols Extensions
extension ImageRepresentable where RawValue == String {
    var image: String {
        return NSLocalizedString(rawValue, comment: "")
    }
}

extension LocalizeRepresentable where RawValue == String {
    var localized: String {
        return NSLocalizedString(rawValue, comment: "")
    }
}
