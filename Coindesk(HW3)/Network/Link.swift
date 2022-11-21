//
//  Link.swift
//  Coindesk(HW3)
//
//  Created by Иса on 21.11.2022.
//

let urlCoindesk = "https://api.coindesk.com/v1/bpi/currentprice.json"

struct Coindesk: Decodable {
    let time: Time
    let disclaimer: String
    let chartName: String
    let bpi: BPI
}

struct Time: Decodable {
    let updated: String
    let updatedISO: String
    let updateduk: String
}

struct BPI: Decodable {
    let USD: Currency
    let GBP: Currency
    let EUR: Currency
}

struct Currency: Decodable {
    let code: String
    let symbol: String
    let rate: String
    let description: String
    let rate_float: Float
}
