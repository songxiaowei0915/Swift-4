import Foundation

struct EpisodeCodingOptions {
    enum Version {
        case v1
        case v2
    }
    
    let apiVersion: Version
    let dateFormatter: DateFormatter
    
    static let infoKey = CodingUserInfoKey(rawValue: "io.boxue.episode-coding-options")!
}

struct Episode: Codable {
    var createdAt: Date
    
    enum CodingKeys:String, CodingKey {
        case createdAt = "created_at"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let createdAt = try container.decode(Date.self, forKey: .createdAt)
        
        self.init(createdAt: createdAt)
    }
    
    init(createdAt: Date) {
        self.createdAt = createdAt
    }
}

extension Episode {
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        if let options = encoder.userInfo[EpisodeCodingOptions.infoKey] as? EpisodeCodingOptions {
            let date = options.dateFormatter.string(from: createdAt)
            try container.encode(date, forKey: .createdAt)
        }
        
    }
}

func encode<T>(of model: T, options: [CodingUserInfoKey: Any]!) throws where T: Codable {
    let encoder = JSONEncoder()
    encoder.outputFormatting = .prettyPrinted
    
    if options != nil {
        encoder.userInfo = options
    }
    
    let data = try encoder.encode(model)
    print(String(data: data, encoding: .utf8)!)
}

func decode<T>(reponse: String, of: T) throws -> T where T: Codable {
    let data = reponse.data(using: .utf8)!
    
    let decoder = JSONDecoder()
    do {
        let model = try decoder.decode(T.self, from: data)
        return model
    }
    catch DecodingError.typeMismatch(let type, let context) {
        dump(type)
        dump(context)
        exit(-1)
    }
    catch DecodingError.keyNotFound(let path, let context) {
        dump(path)
        dump(context)
        exit(-1)
    }
    catch (DecodingError.dataCorrupted(let context)) {
        dump(context)
        exit(-1)
    }
}


let responseOld = """
{
    "created_at" : "Oct-24-2017"
}
"""

let responseNew = """
{
    "created_at" : "2017-08-28T00:24:10+0800"
}
"""

let formatter = DateFormatter()
formatter.dateFormat = "MMM-dd-yyyy"

let options = EpisodeCodingOptions(apiVersion: .v1, dateFormatter: formatter)

let episode = Episode(createdAt: Date())
try encode(of: episode, options: [EpisodeCodingOptions.infoKey: options])

struct Episodes: Codable {
    struct EpisodeInfo: CodingKey {
        init?(stringValue: String) {
            self.stringValue = stringValue
        }
        
        init?(intValue: Int) {
            return nil
        }
        
        var stringValue: String
        var intValue: Int? { return nil }
        
        static let title = EpisodeInfo(stringValue: "title")!
    }
    
    var episodes: [Episode2] = []
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: EpisodeInfo.self)
        try episodes.forEach {
            let id = EpisodeInfo(stringValue: String($0.id))!
            var inner = container.nestedContainer(keyedBy: EpisodeInfo.self, forKey: id)
            
            try inner.encode($0.title, forKey: .title)
        }
    }
    
    enum DemoKey: String, CodingKey {
        case demo
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: EpisodeInfo.self)
        
        var v = [Episode2]()
        
        try container.allKeys.forEach {
            let inner = try container.nestedContainer(keyedBy: DemoKey.self, forKey: $0)
            let title = try inner.decode(String.self, forKey: .demo)
            
            v.append(Episode2(id: Int($0.stringValue)!, title: title))
        }
        
        self.episodes = v
    }
}

struct Episode2: Codable {
    let id: Int
    let title: String
}


let response = """
{
    "1": {
        "title": "Episode 1"
    },
    "2": {
        "title": "Episode 2"
    },
    "3": {
        "title": "Episode 3"
    }
}
"""

