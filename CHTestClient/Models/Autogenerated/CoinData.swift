/* 
Copyright (c) 2018 Swift Models Generated from JSON powered by http://www.json4swift.com

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

For support, please feel free to contact me at https://www.linkedin.com/in/syedabsar

*/

import Foundation
class CoinData : Codable {
	let id : Int?
	let name : String?
	let symbol : String?
	let logo : String?
	let rank : Int?
	let price_usd : String?
	let price_btc : String?
	let lastDayVoulume : Int?
	let market_cap_usd : Int?
	let available_supply : Int?
	let total_supply : Int?
	let percent_change_1h : String?
	let percent_change_24h : String?
	let percent_change_7d : String?
	let created_at : String?
	let updated_at : String?

	enum CodingKeys: String, CodingKey {

		case id = "id"
		case name = "name"
		case symbol = "symbol"
		case logo = "logo"
		case rank = "rank"
		case price_usd = "price_usd"
		case price_btc = "price_btc"
		case lastDayVoulume = "24h_volume_usd"
		case market_cap_usd = "market_cap_usd"
		case available_supply = "available_supply"
		case total_supply = "total_supply"
		case percent_change_1h = "percent_change_1h"
		case percent_change_24h = "percent_change_24h"
		case percent_change_7d = "percent_change_7d"
		case created_at = "created_at"
		case updated_at = "updated_at"
	}

	required init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		id = try values.decodeIfPresent(Int.self, forKey: .id)
		name = try values.decodeIfPresent(String.self, forKey: .name)
		symbol = try values.decodeIfPresent(String.self, forKey: .symbol)
		logo = try values.decodeIfPresent(String.self, forKey: .logo)
		rank = try values.decodeIfPresent(Int.self, forKey: .rank)
		price_usd = try values.decodeIfPresent(String.self, forKey: .price_usd)
		price_btc = try values.decodeIfPresent(String.self, forKey: .price_btc)
		lastDayVoulume = try values.decodeIfPresent(Int.self, forKey: .lastDayVoulume)
		market_cap_usd = try values.decodeIfPresent(Int.self, forKey: .market_cap_usd)
		available_supply = try values.decodeIfPresent(Int.self, forKey: .available_supply)
		total_supply = try values.decodeIfPresent(Int.self, forKey: .total_supply)
		percent_change_1h = try values.decodeIfPresent(String.self, forKey: .percent_change_1h)
		percent_change_24h = try values.decodeIfPresent(String.self, forKey: .percent_change_24h)
		percent_change_7d = try values.decodeIfPresent(String.self, forKey: .percent_change_7d)
		created_at = try values.decodeIfPresent(String.self, forKey: .created_at)
		updated_at = try values.decodeIfPresent(String.self, forKey: .updated_at)
	}

}
