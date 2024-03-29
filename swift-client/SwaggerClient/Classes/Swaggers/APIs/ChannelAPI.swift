//
// ChannelAPI.swift
//
// Generated by swagger-codegen
// https://github.com/swagger-api/swagger-codegen
//

import Alamofire
import RealmSwift

public class ChannelAPI: APIBase {
    /**
     频道列表
     
     - parameter s: (query) 否(默认 1) 上线状态，0 或 1 (optional, default to 1)
     - parameter completion: completion handler to receive the data and the error objects
     */
    public class func nsChsGet(s s: String? = nil, completion: ((data: AnyObject?, error: ErrorType?) -> Void)? = nil) {
        nsChsGetWithRequestBuilder(s: s).execute { (response, error) -> Void in
            completion?(data: response?.body, error: error);
            self.AnalysisChannelObject(response?.body)
        }
    }
    
    
    /**
     频道列表
     - GET /ns/chs
     - 从服务器获取 频道的列表
     - examples: [{contentType=application/json, example="{}"}]
     
     - parameter s: (query) 否(默认 1) 上线状态，0 或 1 (optional, default to 1)
     
     - returns: RequestBuilder<AnyObject>
     */
    public class func nsChsGetWithRequestBuilder(s s: String? = nil) -> RequestBuilder<AnyObject> {
        let path = "/ns/chs"
        let URLString = SwaggerClientAPI.basePath + path
        
        let nillableParameters: [String:AnyObject?] = [
            "s": s
        ]
        
        let parameters = APIHelper.rejectNil(nillableParameters)
        
        let convertedParameters = APIHelper.convertBoolToString(parameters)
        
        let requestBuilder: RequestBuilder<AnyObject>.Type = SwaggerClientAPI.requestBuilderFactory.getBuilder()
        
        return requestBuilder.init(method: "GET", URLString: URLString, parameters: convertedParameters, isBody: false)
    }
    
}



private extension ChannelAPI{
    
    /**
     处理频道获取的数据 
     - 处理 respones 数据中的 data 集合
     － 完善数据库的数据注入
     － 以及后续数据的基本处理，
     － 科技 外媒 点集 的排序
     － 美文 趣图 等频道的默认 不展示处理
     －以及对于 #美女# 频道的躲避审核期的删除
     */
    class func AnalysisChannelObject(data:AnyObject?){
        
        let realm = try! Realm()
        
        if let code = data?.objectForKey("code") as? Int where code == 2000,let datas = data?.objectForKey("data") as? NSArray{
            
            let incount = realm.objects(Channel).count <= 0 // 如果数据库中没有任何数据 那么需要做一些初始化的操作
            
            try! realm.write({
                for channel in datas {
                    realm.create(Channel.self, value: channel, update: true)
                }
            })
            
            try! realm.write({
                realm.objects(Channel).filter("cname = '奇点'").setValue(0, forKey: "orderindex")
                
                if incount {
                    realm.objects(Channel).filter("cname = '科技'").setValue(1, forKey: "orderindex")
                    realm.objects(Channel).filter("cname = '外媒'").setValue(2, forKey: "orderindex")
                    realm.objects(Channel).filter("cname = '点集'").setValue(3, forKey: "orderindex")
                    realm.create(Channel.self, value: ["id":1994,"cname":"关注","state":0,"orderindex":4,"isdelete":0], update: true)
                    
                    realm.objects(Channel).filter("cname = '美文'").setValue(1, forKey: "isdelete")
                    realm.objects(Channel).filter("cname = '趣图'").setValue(1, forKey: "isdelete")
                    realm.objects(Channel).filter("cname = '奇闻'").setValue(1, forKey: "isdelete")
                    realm.objects(Channel).filter("cname = '萌宠'").setValue(1, forKey: "isdelete")
                    realm.objects(Channel).filter("cname = '自媒体'").setValue(1, forKey: "isdelete")
                    realm.objects(Channel).filter("cname = '科学'").setValue(1, forKey: "isdelete")
                    realm.objects(Channel).filter("cname = '养生'").setValue(1, forKey: "isdelete")
                    realm.objects(Channel).filter("cname = '股票'").setValue(1, forKey: "isdelete")
                }
                
                if let del = realm.objects(Channel).filter("cname = '美女'").first {
                    
                    realm.delete(del)
                }
            })
        }
    }
}