//
// NewAPI.swift
//
// Generated by swagger-codegen
// https://github.com/swagger-api/swagger-codegen
//

import Alamofire
import RealmSwift
import AFDateHelper


// MARK: public

public extension NewAPI{

    /**
     刷新新闻方法 根据提供的cid
     根据提供的额delete create 参数 进行一些细节的 操作
     
     - parameter cid:      频道ID
     - parameter tcr:      时间参数
     - parameter delete:   是或否删除多余的新闻
     - parameter create:   创建一条标示性 新闻
     - parameter complete: 完成方法
     */
    public class func RefreshNew(cid cid: Int, tcr: String = NSDate.unixTimeString,delete:Bool = false,create:Bool = true,complete:((String,UIColor)->Void)){
    
        self.nsFedRGet(cid: "\(cid)", tcr: tcr) { (data, error) in
            
            if let code = data?.objectForKey("code") as? Int where code == 4003 { ShareLUserRequest.resetLogin() }
            
            if let code = data?.objectForKey("code") as? Int where code == 2000,let datas = data?.objectForKey("data") as? NSArray{
                
                let realm = try! Realm()
                
                let beforeCount = New.DeleteBecTooMore(delete,cid: cid, realm: realm)
                
                try! realm.write({
                    
                    for channel in datas {
                        
                        realm.create(New.self, value: channel, update: true)
                        
                        self.AnalysisPutTimeAndImageList(channel as! NSDictionary, realm: realm,ishot:(cid == 1 ? 1 : 0))
                    }
                })
                
                let afterCount = New.DeleteBecTooMore(cid: cid, realm: realm)
                
                let currenCount = afterCount - beforeCount
                
                if create && currenCount > 0 {  New.CreateIdentification(tcr, cid: cid, realm: realm) }
                
                return complete("一共刷新了\(currenCount)条数据", UIColor.greenColor())
            }
            
            complete("刷新失败", UIColor.redColor())
        }
    }
    
    /**
     读取更多新闻
     
     - parameter cid: 频道ID
     - parameter tcr: 时间参数
     */
    public class func LoadNew(cid cid: Int, tcr: String = NSDate.unixTimeString){
    
        self.nsFedLGet(cid: "\(cid)", tcr: tcr) { (data, error) in
            
            if let code = data?.objectForKey("code") as? Int where code == 4003 { return ShareLUserRequest.resetLogin() }
            
            if let code = data?.objectForKey("code") as? Int where code == 2000,let datas = data?.objectForKey("data") as? NSArray{
            
                let realm = try! Realm()
                
                try! realm.write({
                    
                    for channel in datas {
                        
                        realm.create(New.self, value: channel, update: true)
                        
                        self.AnalysisPutTimeAndImageList(channel as! NSDictionary, realm: realm,ishot:(cid == 1 ? 1 : 0))
                    }
                })
            }
        }
    }
    
    /**
     根据提供的 新闻的ID 获取新闻的详情
     
     - parameter nid:    新闻ID
     - parameter finish: 完成
     - parameter fail:   失败
     */
    public class func GetnewContent(nid:Int,finish:((newCon:NewContent)->Void)?=nil,fail:(()->Void)?=nil){
    
        NewAPI.nsConGet(nid: "\(nid)") { (data, error) in
            
            let realm = try! Realm()
            
            guard let da = data, let datas = da.objectForKey("data") as? NSDictionary else{  fail?();return}
            
            try! realm.write({
                
                realm.create(NewContent.self, value: datas, update: true)
                
                self.AnalysisNewContents(datas, realm: realm)
            })
            
            let newContengt = realm.objects(NewContent.self).filter("nid = \(nid)").first
            
            finish?(newCon: newContengt!)
        }
    }
}



public class NewAPI: APIBase {

    
    /**
     新闻列表页刷新
     
     - parameter cid: (query) 频道id
     - parameter tcr: (query) 起始时间，13位时间戳
     - parameter tmk: (query) 是(1)否(0)模拟实时发布时间(部分新闻的发布时间修改为5分钟以内) (optional, default to 1)
     - parameter p: (query) 页数 (optional, default to 1)
     - parameter c: (query) 条数 (optional, default to 20)
     - parameter completion: completion handler to receive the data and the error objects
     */
    public class func nsFedRGet(cid cid: String, tcr: String, tmk: String? = "0", p: String? = nil, c: String? = nil, completion: ((data: AnyObject?, error: ErrorType?) -> Void)) {
        ShareLUser.getSdkUserToken { (token) in
            let budlier = nsFedRGetWithRequestBuilder(cid: cid, tcr: tcr, tmk: tmk, p: p, c: c).addHeaders(["Authorization":token])
            budlier.execute { (response, error) -> Void in
                completion(data: response?.body, error: error);
            }
        }
    }
    
    /**
     新闻列表页加载
     
     - parameter cid: (query) 频道id
     - parameter tcr: (query) 起始时间，13位时间戳
     - parameter tmk: (query) 是(1)否(0)模拟实时发布时间(部分新闻的发布时间修改为5分钟以内) (optional, default to 1)
     - parameter p: (query) 页数 (optional, default to 1)
     - parameter c: (query) 条数 (optional, default to 20)
     - parameter completion: completion handler to receive the data and the error objects
     */
    public class func nsFedLGet(cid cid: String, tcr: String, tmk: String? = "0", p: String? = nil, c: String? = nil, completion: ((data: AnyObject?, error: ErrorType?) -> Void)) {
        ShareLUser.getSdkUserToken { (token) in
            let budlier = nsFedLGetWithRequestBuilder(cid: cid, tcr: tcr, tmk: tmk, p: p, c: c).addHeaders(["Authorization":token])
            budlier.execute { (response, error) -> Void in
                completion(data: response?.body, error: error);
            }
        }
    }
    
    
    /**
     新闻详情页
     
     - parameter nid: (query) 新闻ID 
     - parameter completion: completion handler to receive the data and the error objects
     */
    public class func nsConGet(nid nid: String, completion: ((data: AnyObject?, error: ErrorType?) -> Void)) {
        nsConGetWithRequestBuilder(nid: nid).execute { (response, error) -> Void in
            completion(data: response?.body, error: error);
        }
    }


    /**
     新闻详情页
     - GET /ns/con
     - 从服务器获取 新闻详情页
     - examples: [{contentType=application/json, example="{}"}]
     
     - parameter nid: (query) 新闻ID 

     - returns: RequestBuilder<AnyObject> 
     */
    public class func nsConGetWithRequestBuilder(nid nid: String) -> RequestBuilder<AnyObject> {
        let path = "/ns/con"
        let URLString = SwaggerClientAPI.basePath + path

        let nillableParameters: [String:AnyObject?] = [
            "nid": nid
        ]
 
        let parameters = APIHelper.rejectNil(nillableParameters)
 
        let convertedParameters = APIHelper.convertBoolToString(parameters)
 
        let requestBuilder: RequestBuilder<AnyObject>.Type = SwaggerClientAPI.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "GET", URLString: URLString, parameters: convertedParameters, isBody: false)
    }

    /**
     新闻列表页加载
     - GET /ns/fed/l
     - 从服务器获取 新闻-列表页加载
     - examples: [{contentType=application/json, example="{}"}]
     
     - parameter cid: (query) 频道id 
     - parameter tcr: (query) 起始时间，13位时间戳 
     - parameter tmk: (query) 是(1)否(0)模拟实时发布时间(部分新闻的发布时间修改为5分钟以内) (optional, default to 1)
     - parameter p: (query) 页数 (optional, default to 1)
     - parameter c: (query) 条数 (optional, default to 20)

     - returns: RequestBuilder<AnyObject> 
     */
    public class func nsFedLGetWithRequestBuilder(cid cid: String, tcr: String, tmk: String? = nil, p: String? = nil, c: String? = nil, uid: String? = nil) -> RequestBuilder<AnyObject> {
        let path = "/ns/fed/ln"
        let URLString = SwaggerClientAPI.basePath + path

        let nillableParameters: [String:AnyObject?] = [
            "cid": cid,
            "tcr": tcr,
            "tmk": tmk,
            "p": p,
            "c": c,
            "uid":uid
        ]
 
        let parameters = APIHelper.rejectNil(nillableParameters)
 
        let convertedParameters = APIHelper.convertBoolToString(parameters)
 
        let requestBuilder: RequestBuilder<AnyObject>.Type = SwaggerClientAPI.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "GET", URLString: URLString, parameters: convertedParameters, isBody: false)
    }

    /**
     新闻列表页刷新
     - GET /ns/fed/r
     - 从服务器获取 新闻-列表页刷新
     - examples: [{contentType=application/json, example="{}"}]
     
     - parameter cid: (query) 频道id 
     - parameter tcr: (query) 起始时间，13位时间戳 
     - parameter tmk: (query) 是(1)否(0)模拟实时发布时间(部分新闻的发布时间修改为5分钟以内) (optional, default to 1)
     - parameter p: (query) 页数 (optional, default to 1)
     - parameter c: (query) 条数 (optional, default to 20)

     - returns: RequestBuilder<AnyObject> 
     */
    public class func nsFedRGetWithRequestBuilder(cid cid: String, tcr: String, tmk: String? = nil, p: String? = nil, c: String? = nil,uid: String? = nil) -> RequestBuilder<AnyObject> {
        let path = "/ns/fed/rn"
        let URLString = SwaggerClientAPI.basePath + path

        let nillableParameters: [String:AnyObject?] = [
            "cid": cid,
            "tcr": tcr,
            "tmk": tmk,
            "p": p,
            "c": c,
            "uid":uid
        ]
 
        let parameters = APIHelper.rejectNil(nillableParameters)
 
        let convertedParameters = APIHelper.convertBoolToString(parameters)
 
        let requestBuilder: RequestBuilder<AnyObject>.Type = SwaggerClientAPI.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "GET", URLString: URLString, parameters: convertedParameters, isBody: false)
    }

}


// MARK: private
private extension NewAPI{

    // 完善新闻事件
    class func AnalysisPutTimeAndImageList(channel:NSDictionary,realm:Realm,ishot:Int=0){
        
        guard let nid = channel.objectForKey("nid") as? Int else { return }
        
        if let pubTime = channel.objectForKey("ptime") as? String {
            
            let date = NSDate(fromString: pubTime, format: DateFormat.Custom("yyyy-MM-dd HH:mm:ss"))
            
            realm.create(New.self, value: ["nid":nid,"ptimes":date], update: true)
        }
        
        if let imageList = channel.objectForKey("imgs") as? NSArray {
            
            var array = [StringObject]()
            
            imageList.enumerateObjectsUsingBlock({ (imageUrl, _, _) in
                
                let sp = StringObject()
                sp.value = imageUrl as! String
                array.append(sp)
            })
            
            realm.create(New.self, value: ["nid":nid,"imgsList":array], update: true)
        }
        
        realm.create(New.self, value: ["nid":nid,"ishotnew":ishot], update: true)
    }
    
    /**
     完善
     
     - parameter channel: <#channel description#>
     - parameter realm:   <#realm description#>
     */
    private class func AnalysisNewContents(channel:NSDictionary,realm:Realm){
        
        if let nid = channel.objectForKey("nid") as? Int {
            
            if let imageList = channel.objectForKey("tags") as? NSArray {
                
                var array = [StringObject]()
                
                imageList.enumerateObjectsUsingBlock({ (imageUrl, _, _) in
                    
                    let sp = StringObject()
                    sp.value = imageUrl as! String
                    array.append(sp)
                })
                
                realm.create(NewContent.self, value: ["nid":nid,"tags":array], update: true)
            }
        }
    }
}

private extension NSDate{
    
    /// 当前时间的 UNix 时间戳
    private class var unixTimeString:String{ return "\(Int64(NSDate().timeIntervalSince1970*1000))" }
}

private extension New{
    
    /**
     根据 提供的频道ID 删除过多的 新闻，主要用于用户刚刚进入频道视图 下拉刷新的额时候 进行的操作
     
     - parameter cid:   频道ID
     - parameter realm: 数据库操作对象
     */
    private class func DeleteBecTooMore(delete:Bool = false,cid:Int,realm:Realm) -> Int{
        
        var objects = realm.objects(New).sorted("ptimes", ascending: false)
        
        if cid == 1 {
            
            objects = objects.filter("ishotnew = 1 AND isdelete = 0")
        }else{
            
            objects = objects.filter("channel = %@ AND isdelete = 0 AND ishotnew = 0",cid)
        }
        
        if delete { realm.delete(objects[30..<objects.count]) }
        
        return objects.count
    }
    
    /**
     根据提供的 频道 ID 删除 标示 新闻对象
     
     - parameter cid:   频道ID
     - parameter realm: 数据库操作对象
     */
    private class func DeleteIdentification(cid:Int,realm:Realm){
        
        try! realm.write({
            
            if cid == 1 {
                
                realm.delete(realm.objects(New).filter("isidentification = 1 AND ishotnew = 1"))
            }else{
                
                realm.delete(realm.objects(New).filter("isidentification = 1 AND channel = %@",cid))
            }
        })
    }
    
    /**
     根据提供的频道ID 创建 标示 新闻对象
     
     - parameter tcr:   创建对比时间
     - parameter cid:   频道ID
     - parameter realm: 数据库操作对象
     */
    private class func CreateIdentification(tcr:String,cid:Int,realm:Realm){
        
        let date = NSDate(timeIntervalSince1970: ((tcr as NSString).doubleValue+1)/1000)
        
        let nid = cid == 1 ? -100 : -cid
        
        try! realm.write({
            
            realm.create(New.self, value: ["nid":nid,"channel": cid,"isidentification":1,"ishotnew":cid == 1 ? 1 : 0,"ptimes":date], update: true)
        })
    }
}