//
// UserAPI.swift
//
// Generated by swagger-codegen
// https://github.com/swagger-api/swagger-codegen
//

import Alamofire



public class UserAPI: APIBase {
    /**
     游客登录
     
     - parameter userLoginInfo: (body) 用户注册信息 
     - parameter completion: completion handler to receive the data and the error objects
     */
    public class func auLinGPost(userLoginInfo userLoginInfo: VisitorsLogin, completion: ((data: AnyObject?, error: ErrorType?) -> Void)) {
        auLinGPostWithRequestBuilder(userLoginInfo: userLoginInfo).execute { (response, error) -> Void in
            completion(data: response?.body, error: error);
        }
    }


    /**
     游客登录
     - POST /au/lin/g
     - 向服务器登陆一个游客
     - examples: [{contentType=application/json, example="{}"}]
     
     - parameter userLoginInfo: (body) 用户注册信息 

     - returns: RequestBuilder<AnyObject> 
     */
    public class func auLinGPostWithRequestBuilder(userLoginInfo userLoginInfo: VisitorsLogin) -> RequestBuilder<AnyObject> {
        let path = "/au/lin/g"
        let URLString = SwaggerClientAPI.basePath + path
        let parameters = userLoginInfo.encodeToJSON() as? [String:AnyObject]
 
        let convertedParameters = APIHelper.convertBoolToString(parameters)
 
        let requestBuilder: RequestBuilder<AnyObject>.Type = SwaggerClientAPI.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "POST", URLString: URLString, parameters: convertedParameters, isBody: true)
    }

    /**
     游客注册
     
     - parameter userRegisterInfo: (body) 用户注册信息 
     - parameter completion: completion handler to receive the data and the error objects
     */
    public class func auSinGPost(userRegisterInfo userRegisterInfo: VisitorsRegister, completion: ((data: AnyObject?, error: ErrorType?) -> Void)) {
        auSinGPostWithRequestBuilder(userRegisterInfo: userRegisterInfo).execute { (response, error) -> Void in
            completion(data: response?.body, error: error);
        }
    }


    /**
     游客注册
     - POST /au/sin/g
     - 想服务器注册一个用于基本浏览的游客用户
     - examples: [{contentType=application/json, example="{}"}]
     
     - parameter userRegisterInfo: (body) 用户注册信息 

     - returns: RequestBuilder<AnyObject> 
     */
    public class func auSinGPostWithRequestBuilder(userRegisterInfo userRegisterInfo: VisitorsRegister) -> RequestBuilder<AnyObject> {
        let path = "/au/sin/g"
        let URLString = SwaggerClientAPI.basePath + path
        let parameters = userRegisterInfo.encodeToJSON() as? [String:AnyObject]
 
        let convertedParameters = APIHelper.convertBoolToString(parameters)
 
        let requestBuilder: RequestBuilder<AnyObject>.Type = SwaggerClientAPI.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "POST", URLString: URLString, parameters: convertedParameters, isBody: true)
    }

    /**
     第三方用户注册
     
     - parameter userRegisterInfo: (body) 用户注册信息 
     - parameter completion: completion handler to receive the data and the error objects
     */
    public class func auSinSPost(userRegisterInfo userRegisterInfo: UserRegister, completion: ((data: AnyObject?, error: ErrorType?) -> Void)) {
        auSinSPostWithRequestBuilder(userRegisterInfo: userRegisterInfo).execute { (response, error) -> Void in
            completion(data: response?.body, error: error);
        }
    }


    /**
     第三方用户注册
     - POST /au/sin/s
     - 向服务器注册第三方用户
     - examples: [{contentType=application/json, example="{}"}]
     
     - parameter userRegisterInfo: (body) 用户注册信息 

     - returns: RequestBuilder<AnyObject> 
     */
    public class func auSinSPostWithRequestBuilder(userRegisterInfo userRegisterInfo: UserRegister) -> RequestBuilder<AnyObject> {
        let path = "/au/sin/s"
        let URLString = SwaggerClientAPI.basePath + path
        let parameters = userRegisterInfo.encodeToJSON() as? [String:AnyObject]
 
        let convertedParameters = APIHelper.convertBoolToString(parameters)
 
        let requestBuilder: RequestBuilder<AnyObject>.Type = SwaggerClientAPI.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "POST", URLString: URLString, parameters: convertedParameters, isBody: true)
    }

}