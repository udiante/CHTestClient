/* 
Copyright (c) 2018 Swift Models Generated from JSON powered by http://www.json4swift.com

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

For support, please feel free to contact me at https://www.linkedin.com/in/syedabsar

*/

import Foundation
class Trade : Codable {
	let coin_id : Int?
	let user_id : Int?
	let amount : Int?
	let price_usd : Int?
	let total_usd : Int?
	let notes : String?
	let traded_at : String?
	let updated_at : String?
	let created_at : String?
	let id : Int?

	enum CodingKeys: String, CodingKey {

		case coin_id = "coin_id"
		case user_id = "user_id"
		case amount = "amount"
		case price_usd = "price_usd"
		case total_usd = "total_usd"
		case notes = "notes"
		case traded_at = "traded_at"
		case updated_at = "updated_at"
		case created_at = "created_at"
		case id = "id"
	}

	required init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		coin_id = try values.decodeIfPresent(Int.self, forKey: .coin_id)
		user_id = try values.decodeIfPresent(Int.self, forKey: .user_id)
		amount = try values.decodeIfPresent(Int.self, forKey: .amount)
		price_usd = try values.decodeIfPresent(Int.self, forKey: .price_usd)
		total_usd = try values.decodeIfPresent(Int.self, forKey: .total_usd)
		notes = try values.decodeIfPresent(String.self, forKey: .notes)
		traded_at = try values.decodeIfPresent(String.self, forKey: .traded_at)
		updated_at = try values.decodeIfPresent(String.self, forKey: .updated_at)
		created_at = try values.decodeIfPresent(String.self, forKey: .created_at)
		id = try values.decodeIfPresent(Int.self, forKey: .id)
	}

}
