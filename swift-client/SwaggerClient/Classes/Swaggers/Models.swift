// Models.swift
//
// Generated by swagger-codegen
// https://github.com/swagger-api/swagger-codegen
//

import Foundation

protocol JSONEncodable {
    func encodeToJSON() -> AnyObject
}

public class Response<T> {
    public let statusCode: Int
    public let header: [String: String]
    public let body: T

    public init(statusCode: Int, header: [String: String], body: T) {
        self.statusCode = statusCode
        self.header = header
        self.body = body
    }

    public convenience init(response: NSHTTPURLResponse, body: T) {
        let rawHeader = response.allHeaderFields
        var header = [String:String]()
        for (key, value) in rawHeader {
            header[key as! String] = value as? String
        }
        self.init(statusCode: response.statusCode, header: header, body: body)
    }
}

private var once = dispatch_once_t()
class Decoders {
    static private var decoders = Dictionary<String, ((AnyObject) -> AnyObject)>()
    
    static func addDecoder<T>(clazz clazz: T.Type, decoder: ((AnyObject) -> T)) {
        let key = "\(T.self)"
        decoders[key] = { decoder($0) as! AnyObject }
    }
    
    static func decode<T>(clazz clazz: [T].Type, source: AnyObject) -> [T] {
        let array = source as! [AnyObject]
        return array.map { Decoders.decode(clazz: T.self, source: $0) }
    }
    
    static func decode<T, Key: Hashable>(clazz clazz: [Key:T].Type, source: AnyObject) -> [Key:T] {
        let sourceDictionary = source as! [Key: AnyObject]
        var dictionary = [Key:T]()
        for (key, value) in sourceDictionary {
            dictionary[key] = Decoders.decode(clazz: T.self, source: value)
        }
        return dictionary
    }
    
    static func decode<T>(clazz clazz: T.Type, source: AnyObject) -> T {
        initialize()
        if T.self is Int32.Type && source is NSNumber {
            return source.intValue as! T;
        }
        if T.self is Int64.Type && source is NSNumber {
            return source.longLongValue as! T;
        }
        if source is T {
            return source as! T
        }
        
        let key = "\(T.self)"
        if let decoder = decoders[key] {
           return decoder(source) as! T
        } else {
            fatalError("Source \(source) is not convertible to type \(clazz): Maybe swagger file is insufficient")
        }
    }

    static func decodeOptional<T>(clazz clazz: T.Type, source: AnyObject?) -> T? {
        if source is NSNull {
            return nil
        }
        return source.map { (source: AnyObject) -> T in
            Decoders.decode(clazz: clazz, source: source)
        }
    }

    static func decodeOptional<T>(clazz clazz: [T].Type, source: AnyObject?) -> [T]? {
        if source is NSNull {
            return nil
        }
        return source.map { (someSource: AnyObject) -> [T] in
            Decoders.decode(clazz: clazz, source: someSource)
        }
    }

    static func decodeOptional<T, Key: Hashable>(clazz clazz: [Key:T].Type, source: AnyObject?) -> [Key:T]? {
        if source is NSNull {
            return nil
        }
        return source.map { (someSource: AnyObject) -> [Key:T] in
            Decoders.decode(clazz: clazz, source: someSource)
        }
    }
	
    static private func initialize() {
        dispatch_once(&once) {
            let formatters = [
                "yyyy-MM-dd",
                "yyyy-MM-dd'T'HH:mm:ssZZZZZ",
                "yyyy-MM-dd'T'HH:mm:ss.SSSZZZZZ",
                "yyyy-MM-dd'T'HH:mm:ss'Z'"
            ].map { (format: String) -> NSDateFormatter in
                let formatter = NSDateFormatter()
                formatter.dateFormat = format
                return formatter
            }
            // Decoder for NSDate
            Decoders.addDecoder(clazz: NSDate.self) { (source: AnyObject) -> NSDate in
               if let sourceString = source as? String {
                    for formatter in formatters {
                        if let date = formatter.dateFromString(sourceString) {
                            return date
                        }
                    }
                
                }
                if let sourceInt = source as? Int {
                    // treat as a java date
                    return NSDate(timeIntervalSince1970: Double(sourceInt / 1000) )
                }
                fatalError("formatter failed to parse \(source)")
            } 

            // Decoder for [Aboutnews]
            Decoders.addDecoder(clazz: [Aboutnews].self) { (source: AnyObject) -> [Aboutnews] in
                return Decoders.decode(clazz: [Aboutnews].self, source: source)
            }
            // Decoder for Aboutnews
            Decoders.addDecoder(clazz: Aboutnews.self) { (source: AnyObject) -> Aboutnews in
                let sourceDictionary = source as! [NSObject:AnyObject]
                let instance = Aboutnews()
                instance.code = Decoders.decodeOptional(clazz: Int32.self, source: sourceDictionary["code"])
                instance.data = Decoders.decodeOptional(clazz: Array.self, source: sourceDictionary["data"])
                return instance
            }


            // Decoder for [AboutnewsData]
            Decoders.addDecoder(clazz: [AboutnewsData].self) { (source: AnyObject) -> [AboutnewsData] in
                return Decoders.decode(clazz: [AboutnewsData].self, source: source)
            }
            // Decoder for AboutnewsData
            Decoders.addDecoder(clazz: AboutnewsData.self) { (source: AnyObject) -> AboutnewsData in
                let sourceDictionary = source as! [NSObject:AnyObject]
                let instance = AboutnewsData()
                instance.url = Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["url"])
                instance.title = Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["title"])
                instance.from = Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["from"])
                instance.rank = Decoders.decodeOptional(clazz: Int32.self, source: sourceDictionary["rank"])
                instance.ptime = Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["ptime"])
                instance.pname = Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["pname"])
                instance.img = Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["img"])
                instance.abs = Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["abs"])
                return instance
            }


            // Decoder for [Channels]
            Decoders.addDecoder(clazz: [Channels].self) { (source: AnyObject) -> [Channels] in
                return Decoders.decode(clazz: [Channels].self, source: source)
            }
            // Decoder for Channels
            Decoders.addDecoder(clazz: Channels.self) { (source: AnyObject) -> Channels in
                let sourceDictionary = source as! [NSObject:AnyObject]
                let instance = Channels()
                instance.code = Decoders.decodeOptional(clazz: Int32.self, source: sourceDictionary["code"])
                instance.data = Decoders.decodeOptional(clazz: ChannelsData.self, source: sourceDictionary["data"])
                return instance
            }


            // Decoder for [ChannelsData]
            Decoders.addDecoder(clazz: [ChannelsData].self) { (source: AnyObject) -> [ChannelsData] in
                return Decoders.decode(clazz: [ChannelsData].self, source: source)
            }
            // Decoder for ChannelsData
            Decoders.addDecoder(clazz: ChannelsData.self) { (source: AnyObject) -> ChannelsData in
                let sourceDictionary = source as! [NSObject:AnyObject]
                let instance = ChannelsData()
                instance.id = Decoders.decodeOptional(clazz: Int32.self, source: sourceDictionary["id"])
                instance.cname = Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["cname"])
                instance.state = Decoders.decodeOptional(clazz: Int32.self, source: sourceDictionary["state"])
                return instance
            }


            // Decoder for [CommectCreate]
            Decoders.addDecoder(clazz: [CommectCreate].self) { (source: AnyObject) -> [CommectCreate] in
                return Decoders.decode(clazz: [CommectCreate].self, source: source)
            }
            // Decoder for CommectCreate
            Decoders.addDecoder(clazz: CommectCreate.self) { (source: AnyObject) -> CommectCreate in
                let sourceDictionary = source as! [NSObject:AnyObject]
                let instance = CommectCreate()
                instance.content = Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["content"])
                instance.commend = Decoders.decodeOptional(clazz: Int32.self, source: sourceDictionary["commend"])
                instance.ctime = Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["ctime"])
                instance.uid = Decoders.decodeOptional(clazz: Int32.self, source: sourceDictionary["uid"])
                instance.uname = Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["uname"])
                instance.avatar = Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["avatar"])
                instance.docid = Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["docid"])
                return instance
            }


            // Decoder for [CommentRespone]
            Decoders.addDecoder(clazz: [CommentRespone].self) { (source: AnyObject) -> [CommentRespone] in
                return Decoders.decode(clazz: [CommentRespone].self, source: source)
            }
            // Decoder for CommentRespone
            Decoders.addDecoder(clazz: CommentRespone.self) { (source: AnyObject) -> CommentRespone in
                let sourceDictionary = source as! [NSObject:AnyObject]
                let instance = CommentRespone()
                instance.code = Decoders.decodeOptional(clazz: Int32.self, source: sourceDictionary["code"])
                instance.data = Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["data"])
                return instance
            }


            // Decoder for [Comments]
            Decoders.addDecoder(clazz: [Comments].self) { (source: AnyObject) -> [Comments] in
                return Decoders.decode(clazz: [Comments].self, source: source)
            }
            // Decoder for Comments
            Decoders.addDecoder(clazz: Comments.self) { (source: AnyObject) -> Comments in
                let sourceDictionary = source as! [NSObject:AnyObject]
                let instance = Comments()
                instance.code = Decoders.decodeOptional(clazz: Int32.self, source: sourceDictionary["code"])
                instance.data = Decoders.decodeOptional(clazz: Array.self, source: sourceDictionary["data"])
                return instance
            }


            // Decoder for [CommentsData]
            Decoders.addDecoder(clazz: [CommentsData].self) { (source: AnyObject) -> [CommentsData] in
                return Decoders.decode(clazz: [CommentsData].self, source: source)
            }
            // Decoder for CommentsData
            Decoders.addDecoder(clazz: CommentsData.self) { (source: AnyObject) -> CommentsData in
                let sourceDictionary = source as! [NSObject:AnyObject]
                let instance = CommentsData()
                instance.id = Decoders.decodeOptional(clazz: Int32.self, source: sourceDictionary["id"])
                instance.content = Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["content"])
                instance.commend = Decoders.decodeOptional(clazz: Int32.self, source: sourceDictionary["commend"])
                instance.ctime = Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["ctime"])
                instance.uid = Decoders.decodeOptional(clazz: Int32.self, source: sourceDictionary["uid"])
                instance.uname = Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["uname"])
                instance.avatar = Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["avatar"])
                instance.docid = Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["docid"])
                instance.upflag = Decoders.decodeOptional(clazz: Int32.self, source: sourceDictionary["upflag"])
                return instance
            }


            // Decoder for [Newinfo]
            Decoders.addDecoder(clazz: [Newinfo].self) { (source: AnyObject) -> [Newinfo] in
                return Decoders.decode(clazz: [Newinfo].self, source: source)
            }
            // Decoder for Newinfo
            Decoders.addDecoder(clazz: Newinfo.self) { (source: AnyObject) -> Newinfo in
                let sourceDictionary = source as! [NSObject:AnyObject]
                let instance = Newinfo()
                instance.code = Decoders.decodeOptional(clazz: Int32.self, source: sourceDictionary["code"])
                instance.data = Decoders.decodeOptional(clazz: NewinfoData.self, source: sourceDictionary["data"])
                return instance
            }


            // Decoder for [NewinfoData]
            Decoders.addDecoder(clazz: [NewinfoData].self) { (source: AnyObject) -> [NewinfoData] in
                return Decoders.decode(clazz: [NewinfoData].self, source: source)
            }
            // Decoder for NewinfoData
            Decoders.addDecoder(clazz: NewinfoData.self) { (source: AnyObject) -> NewinfoData in
                let sourceDictionary = source as! [NSObject:AnyObject]
                let instance = NewinfoData()
                instance.nid = Decoders.decodeOptional(clazz: Int64.self, source: sourceDictionary["nid"])
                instance.url = Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["url"])
                instance.docid = Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["docid"])
                instance.title = Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["title"])
                instance.ptime = Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["ptime"])
                instance.pname = Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["pname"])
                instance.purl = Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["purl"])
                instance.channel = Decoders.decodeOptional(clazz: Int32.self, source: sourceDictionary["channel"])
                instance.collect = Decoders.decodeOptional(clazz: Int32.self, source: sourceDictionary["collect"])
                instance.concern = Decoders.decodeOptional(clazz: Int32.self, source: sourceDictionary["concern"])
                instance.comment = Decoders.decodeOptional(clazz: Int32.self, source: sourceDictionary["comment"])
                instance.inum = Decoders.decodeOptional(clazz: Int32.self, source: sourceDictionary["inum"])
                instance.tags = Decoders.decodeOptional(clazz: Array.self, source: sourceDictionary["tags"])
                instance.content = Decoders.decodeOptional(clazz: Array.self, source: sourceDictionary["content"])
                return instance
            }


            // Decoder for [NewinfoDataContent]
            Decoders.addDecoder(clazz: [NewinfoDataContent].self) { (source: AnyObject) -> [NewinfoDataContent] in
                return Decoders.decode(clazz: [NewinfoDataContent].self, source: source)
            }
            // Decoder for NewinfoDataContent
            Decoders.addDecoder(clazz: NewinfoDataContent.self) { (source: AnyObject) -> NewinfoDataContent in
                let sourceDictionary = source as! [NSObject:AnyObject]
                let instance = NewinfoDataContent()
                instance.txt = Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["txt"])
                instance.img = Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["img"])
                instance.vid = Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["vid"])
                return instance
            }
            
            // Decoder for [UserRegister]
            Decoders.addDecoder(clazz: [UserRegister].self) { (source: AnyObject) -> [UserRegister] in
                return Decoders.decode(clazz: [UserRegister].self, source: source)
            }
            // Decoder for UserRegister
            Decoders.addDecoder(clazz: UserRegister.self) { (source: AnyObject) -> UserRegister in
                let sourceDictionary = source as! [NSObject:AnyObject]
                let instance = UserRegister()
                instance.muid = Decoders.decodeOptional(clazz: Int32.self, source: sourceDictionary["muid"])
                instance.msuid = Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["msuid"])
                instance.utype = Decoders.decodeOptional(clazz: Int32.self, source: sourceDictionary["utype"])
                instance.platform = Decoders.decodeOptional(clazz: Int32.self, source: sourceDictionary["platform"])
                instance.suid = Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["suid"])
                instance.stoken = Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["stoken"])
                instance.sexpires = Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["sexpires"])
                instance.uname = Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["uname"])
                instance.gender = Decoders.decodeOptional(clazz: Int32.self, source: sourceDictionary["gender"])
                instance.avatar = Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["avatar"])
                instance.averse = Decoders.decodeOptional(clazz: Array.self, source: sourceDictionary["averse"])
                instance.prefer = Decoders.decodeOptional(clazz: Array.self, source: sourceDictionary["prefer"])
                instance.province = Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["province"])
                instance.city = Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["city"])
                instance.district = Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["district"])
                return instance
            }


            // Decoder for [VisitorsLogin]
            Decoders.addDecoder(clazz: [VisitorsLogin].self) { (source: AnyObject) -> [VisitorsLogin] in
                return Decoders.decode(clazz: [VisitorsLogin].self, source: source)
            }
            // Decoder for VisitorsLogin
            Decoders.addDecoder(clazz: VisitorsLogin.self) { (source: AnyObject) -> VisitorsLogin in
                let sourceDictionary = source as! [NSObject:AnyObject]
                let instance = VisitorsLogin()
                instance.uid = Decoders.decodeOptional(clazz: Int32.self, source: sourceDictionary["uid"])
                instance.password = Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["password"])
                return instance
            }


            // Decoder for [VisitorsRegister]
            Decoders.addDecoder(clazz: [VisitorsRegister].self) { (source: AnyObject) -> [VisitorsRegister] in
                return Decoders.decode(clazz: [VisitorsRegister].self, source: source)
            }
            // Decoder for VisitorsRegister
            Decoders.addDecoder(clazz: VisitorsRegister.self) { (source: AnyObject) -> VisitorsRegister in
                let sourceDictionary = source as! [NSObject:AnyObject]
                let instance = VisitorsRegister()
                instance.utype = Decoders.decodeOptional(clazz: Int32.self, source: sourceDictionary["utype"])
                instance.platform = Decoders.decodeOptional(clazz: Int32.self, source: sourceDictionary["platform"])
                instance.province = Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["province"])
                instance.city = Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["city"])
                instance.district = Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["district"])
                return instance
            }


            // Decoder for [VisitorsUser]
            Decoders.addDecoder(clazz: [VisitorsUser].self) { (source: AnyObject) -> [VisitorsUser] in
                return Decoders.decode(clazz: [VisitorsUser].self, source: source)
            }
            // Decoder for VisitorsUser
            Decoders.addDecoder(clazz: VisitorsUser.self) { (source: AnyObject) -> VisitorsUser in
                let sourceDictionary = source as! [NSObject:AnyObject]
                let instance = VisitorsUser()
                instance.code = Decoders.decodeOptional(clazz: Int32.self, source: sourceDictionary["code"])
                instance.data = Decoders.decodeOptional(clazz: VisitorsUserData.self, source: sourceDictionary["data"])
                return instance
            }


            // Decoder for [VisitorsUserData]
            Decoders.addDecoder(clazz: [VisitorsUserData].self) { (source: AnyObject) -> [VisitorsUserData] in
                return Decoders.decode(clazz: [VisitorsUserData].self, source: source)
            }
            // Decoder for VisitorsUserData
            Decoders.addDecoder(clazz: VisitorsUserData.self) { (source: AnyObject) -> VisitorsUserData in
                let sourceDictionary = source as! [NSObject:AnyObject]
                let instance = VisitorsUserData()
                instance.utype = Decoders.decodeOptional(clazz: Int32.self, source: sourceDictionary["utype"])
                instance.uid = Decoders.decodeOptional(clazz: Int32.self, source: sourceDictionary["uid"])
                instance.password = Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["password"])
                instance.channel = Decoders.decodeOptional(clazz: Array.self, source: sourceDictionary["channel"])
                return instance
            }
        }
    }
}
