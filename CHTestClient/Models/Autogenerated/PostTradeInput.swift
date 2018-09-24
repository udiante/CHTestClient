/*
 Copyright (c) 2018 Swift Models Generated from JSON powered by http://www.json4swift.com
 
 Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 
 For support, please feel free to contact me at https://www.linkedin.com/in/syedabsar
 
 */

import Foundation

class PostTradeInput : NSObject, NSCoding{
    
    var amount : Double?
    var coinId : Int?
    var notes : String?
    var priceUsd : Double?
    var tradedAt : String?
    
    override init(){
        super.init()
    }
    
    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        amount = dictionary["amount"] as? Double
        coinId = dictionary["coin_id"] as? Int
        notes = dictionary["notes"] as? String
        priceUsd = dictionary["price_usd"] as? Double
        tradedAt = dictionary["traded_at"] as? String
    }
    
    /**
     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> [String:Any]
    {
        var dictionary = [String:Any]()
        if amount != nil{
            dictionary["amount"] = amount
        }
        if coinId != nil{
            dictionary["coin_id"] = coinId
        }
        if notes != nil{
            dictionary["notes"] = notes
        }
        if priceUsd != nil{
            dictionary["price_usd"] = priceUsd
        }
        if tradedAt != nil{
            dictionary["traded_at"] = tradedAt
        }
        return dictionary
    }
    
    /**
     * NSCoding required initializer.
     * Fills the data from the passed decoder
     */
    @objc required init(coder aDecoder: NSCoder)
    {
        amount = aDecoder.decodeObject(forKey: "amount") as? Double
        coinId = aDecoder.decodeObject(forKey: "coin_id") as? Int
        notes = aDecoder.decodeObject(forKey: "notes") as? String
        priceUsd = aDecoder.decodeObject(forKey: "price_usd") as? Double
        tradedAt = aDecoder.decodeObject(forKey: "traded_at") as? String
    }
    
    /**
     * NSCoding required method.
     * Encodes mode properties Doubleo the decoder
     */
    @objc func encode(with aCoder: NSCoder)
    {
        if amount != nil{
            aCoder.encode(amount, forKey: "amount")
        }
        if coinId != nil{
            aCoder.encode(coinId, forKey: "coin_id")
        }
        if notes != nil{
            aCoder.encode(notes, forKey: "notes")
        }
        if priceUsd != nil{
            aCoder.encode(priceUsd, forKey: "price_usd")
        }
        if tradedAt != nil{
            aCoder.encode(tradedAt, forKey: "traded_at")
        }
    }
}
