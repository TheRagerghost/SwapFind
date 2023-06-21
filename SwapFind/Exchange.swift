import Foundation
import SwiftUI

class Exchange {
    @AppStorage("latestRates") static var latestRates: Data = Data()
    
    public static let currencyList: [Currency] = [Currency("Рубль", "RUB", "RU", "rublesign", "🇷🇺", 100.0),
                                                  Currency("Доллар", "USD", "US", "dollarsign", "🇺🇸"),
                                                  Currency("Евро", "EUR", "EU", "eurosign", "🇪🇺"),
                                                  Currency("Фунт", "GBP", "GB", "sterlingsign", "🇬🇧"),
                                                  Currency("Юань", "CNY", "CN", "yensign", "🇨🇳", 10.0),
                                                  Currency("Рупия", "INR", "IN", "indianrupeesign", "🇮🇳", 100.0),
                                                  Currency("Реал", "BRL", "BR", "brazilianrealsign", "🇧🇷", 10.0),
                                                  Currency("Вона", "KRW", "KR", "wonsign", "🇰🇷", 1000.0),
                                                  Currency("Шекель", "ILS", "IL", "shekelsign", "🇮🇱", 10.0),
                                                  Currency("Тенге", "KZT", "KZ", "tengesign", "🇰🇿", 1000.0),
                                                  Currency("Лира", "TRY", "TR", "turkishlirasign", "🇹🇷", 10.0)]
    
    public static let endpoint: String = "https://api.getgeoapi.com/v2/currency/convert"
    private static let apiKey: String = "81847dc74c45f999c333319f3b0ca1f1b499fd15"
    
    public static func getCurrencyByCode(_ code: String) -> Currency {
        return currencyList.first(where: {$0.code == code}) ?? currencyList[0]
    }
    
    public static func getLatestRates() -> LatestRatesStamp? {
        do {
            let decoded = try JSONDecoder().decode(LatestRatesStamp.self, from: latestRates)
            return decoded
        }
        catch
        {
            print(error)
            return nil
        }
    }
    
    public static func syncLatestRates() async -> LatestRatesStamp? {
        let toCurrencies = currencyList.map({$0.code}).joined(separator: ",")
        print(toCurrencies)
        
        let url = URL(string: "\(endpoint)?api_key=\(apiKey)&from=JPY&to=\(toCurrencies)&format=json")!
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("keep-alive", forHTTPHeaderField: "Connection")
        request.httpMethod = "GET"
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let str = String(decoding: data, as: UTF8.self)
            let response: Response = try JSONDecoder().decode(Response.self, from: str.data(using: .utf8)!)
            dump(response)
            
            var rates: [LatestRate] = []
            for r in response.rates.keys {
                if currencyList.contains(where: { $0.code == r }) {
                    rates.append(LatestRate(code: r, rate: response.rates[r]?.rate ?? "1.0"))
                }
            }
            print(rates)
            
            let stamp: LatestRatesStamp = LatestRatesStamp(timestamp: Date.now, rates: rates)
            latestRates = try JSONEncoder().encode(stamp)
            return stamp
        } catch {
            print(error)
            print("Failed to retrieve the data.")
            return nil
        }
    }
}

struct Currency: Hashable {
    var name: String
    var code: String
    var countryCode: String
    var symbol: String
    var flag: String
    var amount: Float
        
    init(_ name: String, _ code: String, _ countryCode: String, _ symbol: String, _ flag: String, _ amount: Float = 1.0) {
        self.name = name
        self.code = code
        self.countryCode = countryCode
        self.symbol = symbol
        self.flag = flag
        self.amount = amount
    }
}

struct LatestRatesStamp: Codable {
    var timestamp: Date
    var rates: [LatestRate]
}

struct LatestRate: Hashable, Codable {
    var code: String
    var rate: String
}

struct Response: Codable {
    var status: String
    var updated_date: String
    var base_currency_code: String
    var amount: String
    var base_currency_name: String
    var rates: [String : RateInfo]
}

struct RateInfo: Codable {
    var currency_name: String
    var rate: String
    var rate_for_amount: String
}
