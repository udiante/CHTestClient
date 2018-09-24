/* 
Copyright (c) 2018 Swift Models Generated from JSON powered by http://www.json4swift.com

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

For support, please feel free to contact me at https://www.linkedin.com/in/syedabsar

*/

import Foundation
class Coins : Codable {
	let current_page : Int?
	let data : [CoinData]?
	let first_page_url : String?
	let from : Int?
	let last_page : Int?
	let last_page_url : String?
	let next_page_url : String?
	let path : String?
	let per_page : Int?
	let prev_page_url : String?
	let to : Int?
	let total : Int?

	enum CodingKeys: String, CodingKey {

		case current_page = "current_page"
		case data = "data"
		case first_page_url = "first_page_url"
		case from = "from"
		case last_page = "last_page"
		case last_page_url = "last_page_url"
		case next_page_url = "next_page_url"
		case path = "path"
		case per_page = "per_page"
		case prev_page_url = "prev_page_url"
		case to = "to"
		case total = "total"
	}

	required init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		current_page = try values.decodeIfPresent(Int.self, forKey: .current_page)
		data = try values.decodeIfPresent([CoinData].self, forKey: .data)
		first_page_url = try values.decodeIfPresent(String.self, forKey: .first_page_url)
		from = try values.decodeIfPresent(Int.self, forKey: .from)
		last_page = try values.decodeIfPresent(Int.self, forKey: .last_page)
		last_page_url = try values.decodeIfPresent(String.self, forKey: .last_page_url)
		next_page_url = try values.decodeIfPresent(String.self, forKey: .next_page_url)
		path = try values.decodeIfPresent(String.self, forKey: .path)
		per_page = try values.decodeIfPresent(Int.self, forKey: .per_page)
		prev_page_url = try values.decodeIfPresent(String.self, forKey: .prev_page_url)
		to = try values.decodeIfPresent(Int.self, forKey: .to)
		total = try values.decodeIfPresent(Int.self, forKey: .total)
	}

}
