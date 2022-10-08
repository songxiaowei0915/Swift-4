import Foundation


struct Episode: Codable {
    var title: String
    var series: String
    var creatorBy: String
    var creatorAt: Date
    var duration: Float
    var type: EpisodeType
    var origin: Data
    var url: URL
    
    enum EpisodeType: String, Codable {
        case free
        case paid
    }


    enum CodingKeys: String, CodingKey {
        case title
        case series
        case duration
        case type
        case creatorBy = "creator_by"
        case creatorAt = "creator_at"
        case origin
        case url
    }
}

let response = """
{
    "title": "How to parse JSON in Swift 4",
    "series": "What's new in Swift 4",
    "creator_by": "Mars",
    "creator_at": "2017-08-23T01:42:42Z",
    "duration": 6.5,
    "origin": "Ym94dWVpby5jb20=",
    "url": "boxueio.com",
    "type": "free"
}
"""

var data = response.data(using: .utf8)!
let decoder = JSONDecoder()
decoder.dateDecodingStrategy = .iso8601
decoder.dataDecodingStrategy = .base64
let episode = try! decoder.decode(Episode.self, from: data)
dump(episode)
print(String(data: episode.origin, encoding: .utf8)!)

let encoder = JSONEncoder()
encoder.outputFormatting = .prettyPrinted
encoder.dateEncodingStrategy = .iso8601
encoder.dataEncodingStrategy = .base64
data = try! encoder.encode(episode)

print(String(data: data, encoding: .utf8)!)


let response1 = """
{
    "list": [
        {
            "title": "How to parse JSON in Swift 4",
            "series": "What's new in Swift 4",
            "creator_by": "Mars",
            "creator_at": "2017-08-23T01:42:42Z",
            "duration": 6.5,
            "origin": "Ym94dWVpby5jb20=",
            "url": "boxueio.com",
            "type": "free"
        }
    ]
}
"""

let response2 = """
[
    {
        "title": "How to parse JSON in Swift 4",
        "series": "What's new in Swift 4",
        "creator_by": "Mars",
        "creator_at": "2017-08-23T01:42:42Z",
        "duration": 6.5,
        "origin": "Ym94dWVpby5jb20=",
        "url": "boxueio.com",
        "type": "free"
    }
]
"""

let response3 = """
[
    {
        "episode":
        {
                "title": "How to parse JSON in Swift 4",
                "series": "What's new in Swift 4",
                "creator_by": "Mars",
                "creator_at": "2017-08-23T01:42:42Z",
                "duration": 6.5,
                "origin": "Ym94dWVpby5jb20=",
                "url": "boxueio.com",
                "type": "free"
        }
        
    }
]
"""

let response4 = """
{
    "meta": {
        "total_exp": 1000,
        "level": "beginner",
        "total_duration": 120
    },
    "list": [
        {
            "title": "How to parse JSON in Swift 4",
            "series": "What's new in Swift 4",
            "creator_by": "Mars",
            "creator_at": "2017-08-23T01:42:42Z",
            "duration": 6.5,
            "origin": "Ym94dWVpby5jb20=",
            "url": "boxueio.com",
            "type": "free"
        }
    ]
}
"""

struct EpisodeList: Codable {
    let list:[Episode]
}

var data1 = response1.data(using: .utf8)!
let list1 = try! decoder.decode(EpisodeList.self, from: data1)
dump(list1)


var data2 = response2.data(using: .utf8)!
let list2 = try! decoder.decode([Episode].self, from: data2)
dump(list2)

var data3 = response3.data(using: .utf8)!
let list3 = try! decoder.decode([Dictionary<String, Episode>].self, from: data3)
dump(list3)


struct EpisodeMeta: Codable {
    let total_exp: Int
    let level: EpisodeLevel
    let total_duration: Int
    
    enum EpisodeLevel: String, Codable {
        case beginner
        case intermediate
        case advanced
    }
}

struct EpisodePage: Codable {
    let meta: EpisodeMeta
    let list: [Episode]
}

var data4 = response4.data(using: .utf8)!
let list4 = try! decoder.decode(EpisodePage.self, from: data4)
dump(list4)
