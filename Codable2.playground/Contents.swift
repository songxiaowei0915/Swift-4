import Foundation

struct Episode: Codable {
    var title: String
    var createdAt: Date
    var comment: String?
    var duration: Int
    var slices: [Float]
    
    enum CodingKeys:String, CodingKey {
        case title
        case createdAt = "created_at"
        case comment
        case meta
    }
    
    enum MetaCodingKeys: String, CodingKey {
        case duration
        case slices
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let title = try container.decode(String.self, forKey: .title)
        let createdAt = try container.decode(Date.self, forKey: .createdAt)
        let comment = try container.decodeIfPresent(String.self, forKey: .comment)
        let meta = try container.nestedContainer(keyedBy: MetaCodingKeys.self, forKey: .meta)
        
        let duration = try meta.decode(Int.self, forKey: .duration)
        
        var unkeyContainer = try meta.nestedUnkeyedContainer(forKey: .slices)
        var percentages: [Float] = []
        while(!unkeyContainer.isAtEnd) {
            let sliceDuration = try unkeyContainer.decode(Float.self)
            percentages.append(sliceDuration / Float(duration))
        }
        
        self.init(title: title, createdAt: createdAt, comment: comment, duration: duration, slices: percentages)
    }
    
    init(title:String, createdAt: Date, comment: String?,
         duration: Int, slices: [Float]) {
        self.title = title
        self.createdAt = createdAt
        self.comment = comment
        self.duration = duration
        self.slices = slices
    }
}

extension Episode {
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(title, forKey: .title)
        try container.encode(createdAt, forKey: .createdAt)
        try container.encode(comment, forKey: .comment)
        var meta = container.nestedContainer(keyedBy: MetaCodingKeys.self, forKey: .meta)
        try meta.encode(duration, forKey: .duration)
        var unkeyedContainer = meta.nestedUnkeyedContainer(forKey: .slices)
        try slices.forEach {
            try unkeyedContainer.encode($0 * Float(duration))
        }
    }
}

let episode = Episode(title: "How to parse a JSON - III", createdAt: Date(),comment: nil,duration: 100, slices: [0.25, 0.5, 0.75])
let encoder = JSONEncoder()
encoder.outputFormatting = .prettyPrinted
encoder.dateEncodingStrategy = .custom {
    (date, encoder) in
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd hh:mm:ss"
    let stringDate = formatter.string(from: date)
    var container = encoder.singleValueContainer()
    try container.encode(stringDate)
}

let data = try! encoder.encode(episode)
print(String(data: data, encoding: .utf8)!)

let response = String(data: data, encoding: .utf8)!

let data2 = response.data(using: .utf8)!
let decoder2 = JSONDecoder()
decoder2.dateDecodingStrategy = .custom {
    let data = try $0.singleValueContainer().decode(String.self)
    
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd hh:mm:ss"
    let stringDate = formatter.date(from: data)!
    
    return stringDate
}
let episode2 = try decoder2.decode(Episode.self, from: data2)
dump(episode2)
