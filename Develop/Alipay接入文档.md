支付宝APP充值&提现接入流程

## 一、准备条件

* APPID：支付宝开放平台（[open.alipay.com](https://open.alipay.com/)）创建应用后审核通过生成的应用唯一标识。

  ```sh
  APPID:2019121869940954
  ```

* PID：支付宝商户中心（https://mrchportalweb.alipay.com/），设置->[查看PID|KEY](https://openhome.alipay.com/platform/keyManage.htm?keyType=partner)中的合作伙伴身份。

  ```sh
  PID:2088731032089904
  ```

* 配置密钥：使用支付宝开放平台开发助手，获取CSR文件生成签名，上传公钥换取支付宝证书。

  ```sh
  #应用公钥证书
  appCertPublicKey_2019121869940954.crt
  #支付宝根证书文件
  alipayRootCert.crt
  #支付宝公钥证书文件
  alipayCertPublicKey_RSA2.crt
  ```

* 设置授权回调地址：换取应用授权令牌的回调链接。

* 能力签约：

  * [APP支付](https://opendocs.alipay.com/open/repo-0038v9)
  * [APP支付宝登录](https://opendocs.alipay.com/open/repo-0038wv)
  * [第三方应用授权](https://docs.open.alipay.com/20160728150111277227)
  * [获取会员信息](https://opendocs.alipay.com/open/repo-0038q6)
  * [转账到支付宝账户](https://opendocs.alipay.com/open/repo-0038si)

---

## 二、支付宝充值

* 接口：alipay.trade.app.pay

* 请求必填参数：

  ```json
  {
      "total_amount":"0.01",//订单总金额，单位为元，精确到小数点后两位，取值范围[0.01,100000000]
      "subject":"支付宝APP支付测试",//商品的标题/交易标题/订单标题/订单关键字等。
      "out_trade_no":"JgCYKDW4oc02cDhupqzgMew6fGqIAZZg"//商户网站唯一订单号
  }
  ```

* 响应关键参数：

  ```json
  {
      "out_trade_no":"JgCYKDW4oc02cDhupqzgMew6fGqIAZZg",//商户网站唯一订单号
      "trade_no":"2020042722001404901424905277",//该交易在支付宝系统中的交易流水号。
      "total_amount":"",//该笔订单的资金总额，单位为RMB-Yuan。取值范围为[0.01，100000000.00]，精确到小数点后两位。
      "seller_id":"2088731032089904",//收款支付宝账号对应的支付宝唯一用户号。以2088开头的纯16位数字
      "merchant_order_no":""//商户原始订单号，最大长度限制32位
  }
  ```

* 支付结果回调：

![img](https://gw.alipayobjects.com/zos/skylark-tools/public/files/c0c28dbec662e7880d06c6d0232cf030.png)

* 异步通知验签：

  * 触发通知条件：

    ```sh
    触发条件名	   	触发条件描述	触发条件默认值
    TRADE_FINISHED	交易完成	false（不触发通知）
    TRADE_SUCCESS	支付成功	true（触发通知）
    WAIT_BUYER_PAY	交易创建	false（不触发通知）
    TRADE_CLOSED	交易关闭	true（触发通知）
    ```

  * 异步通知主要参数：

    ```json
    {
        "notify_time":"2020-04-27 10:23:46",//通知时间
        "notify_type":"trade_status_sync",//通知类型
        "notify_id":"ac05099524730693a8b330c5ecf72da9786",//通知校验ID
        "app_id":"2019121869940954",//支付宝分配给开发者的应用Id	
        "charset":"utf-8",//编码格式
        "version":"1.0",//接口版本
        "sign_type":"RSA2",//签名类型
        "sign":"601510b7970e52cc63db0f44997cf70e",//签名
        "trade_no":"2013112011001004330000121536",//支付宝交易号
        "out_trade_no":"6823789339978248",//商户订单号
        "seller_id":"2088101106499364",//卖家支付宝用户号
        "seller_email":"jiuliaochat@gmail.com",//卖家支付宝账号
        "total_amount":"0.01",//订单金额
    }
    ```

  * 对主要参数进行一一校验：

    1. 商户需要验证该通知数据中的**out_trade_no**是否为商户系统中创建的订单号;
    2. 判断**total_amount**是否确实为该订单的实际金额（即商户订单创建时的金额）;
    3. 校验通知中的**seller_id**（或者seller_email) 是否为out_trade_no这笔单据的对应的操作方（有的时候，一个商户可能有多个seller_id/seller_email）;
    4. 验证**app_id**是否为该商户本身。

    上述1、2、3、4有任何一个验证不通过，则表明本次通知是异常通知，务必忽略。在上述验证通过后商户必须根据支付宝不同类型的业务通知，正确的进行不同的业务处理，并且过滤重复的通知结果数据。在支付宝的业务通知中，只有交易通知状态为TRADE_SUCCESS或TRADE_FINISHED时，支付宝才会认定为买家付款成功。

> * 状态TRADE_SUCCESS的通知触发条件是商户签约的产品支持退款功能的前提下，买家付款成功；
> * 交易状态TRADE_FINISHED的通知触发条件是商户签约的产品不支持退款功能的前提下，买家付款成功；或者，商户签约的产品支持退款功能的前提下，交易已经成功并且已经超过可退款期限。

* 系统交互流程图：

  ![img](http://img01.taobaocdn.com/top/i1/LB1uQPIPVXXXXbAXpXXXXXXXXXX)



  #### 交易查询接口：[alipay.trade.query](https://opendocs.alipay.com/apis/api_1/alipay.trade.query)

* 关键入参：

  ```json
  {
      "out_trade_no":"",//支付时传入的商户订单号，与 trade_no 必填一个
      "trade_no":"",//支付时返回的支付宝交易号，与 out_trade_no 必填一个
      ...
  }
  ```

* 关键出参：

  ```json
  {
      "trade_no":"",//支付宝28位交易号
      "out_trade_no":"",//支付时传入的商户订单号
      "trade_status":"",//交易当前状态
      ...
  }
  ```

  #### 交易退款接口：[alipay.trade.refund](https://opendocs.alipay.com/apis/api_1/alipay.trade.refund)

  * 退款流程：

    ![img](https://gw.alipayobjects.com/zos/skylark-tools/public/files/cbd15fae29dd4a157412517adb6994f6.png)

  * 关键入参：

    ```json
    {
        "out_trade_no":"",//支付时传入的商户订单号，与 trade_no 必填一个
        "trade_no":"",//支付时返回的支付宝交易号，与 out_trade_no 必填一个
        "out_request_no":"",//本次退款请求流水号，部分退款时必传
        "refund_amount":"",//本次退款金额
        ...
    }
    ```

  * 关键出参：

    ```json
    {
        "refund_fee":"",//该笔交易已退款的总金额
    }
    ```

  #### 查询对账单下载地址接口：[alipay.data.dataservice.bill.downloadurl.query](https://opendocs.alipay.com/apis/api_15/alipay.data.dataservice.bill.downloadurl.query)

  * 收款账单接入流程（须主账号签约）

    ![image](https://img.alicdn.com/top/i1/LB1zDS2KVXXXXbAapXXXXXXXXXX)

  * 关键入参：

    ```json
    {
        "bill_type":"trade",//固定传入 trade
    	"bill_date":"",//需要下载的账单日期，最晚是当期日期的前一天
        ...
    }
    ```

  * 关键出参：

    ```json
    {
        "bill_download_url":"",//账单文件下载地址，30秒有效
    }
    ```

---

---

## 三、支付宝提现

* 构造APP无线账号授权：

  ```json
  {
      "code": 200,
      "msg": "成功",
      "data": "apiname=com.alipay.account.auth&app_id=2019121869940954&app_name=mc&auth_type=AUTHACCOUNT&biz_type=openservice&method=alipay.open.auth.sdk.code.get&pid=2088731032089904&product_id=APP_FAST_LOGIN&scope=kuaijie&sign=CIyoCD%2BQgD3OAtC5YblazCE7bIqDuKeI0hsHKc01h8Jf%2Fy%2FVY0v5DAbxL1BQkebJLVd5nZO36Osr4%2FCRppuC0t9BNw5I8QPm4MRkSEz0Fg8Kcui2FBw0ZmLGLhmyPPG0jeP%2BuVfcVDSzs%2F81Oms11bRkQcEZrfw9HiP3VCRga74nkSeTgDGLE2%2FqfhkyISKQPH%2Bp17eSkcj9HN%2FF7gCxMKCl%2B1awSrGed1O0CvFwd%2B3ppNq5J%2BZsfz1SmXO2L7k6YmgXZHu7Ycskfev9Nv9JMLSNMMXzYbv3qAZ%2Bsoodf7Z3z9NWqxKrU6Zl42%2FxoxbYzijHlPjsXV5plYqLRtlyGQ%3D%3D&sign_type=RSA2&target_id=kkkkk091125"
  }
  ```

  * 手机端SDK授权：

    ![img](https://gw.alipayobjects.com/zos/skylark-tools/public/files/d59072bc8f690dd26cfa45f5d08017f4.png)

  * 授权成功：

    ```sh
    success=true&result_code=200&app_id=2019121869940954&auth_code=088cee9ee28a4438a742368de435RC90&scope=kuaijie&alipay_open_id=20880004158284235876358882619090&user_id=2088112716704900&target_id=kkkkk091125
    #将auth_code发送到服务端换取token
    ```

  #### 获取授权令牌接口：**[alipay.system.oauth.token](https://opendocs.alipay.com/apis/api_9/alipay.system.oauth.token)**

  * 关键入参：

    ```json
    {
        "grant_type":"authorization_code",//值为authorization_code时，代表用code换取；值为refresh_token时，代表用refresh_token换取
        "code":"4b203fe6c11548bcabd8da5bb087a83b",//授权码，用户对应用授权后得到。
        "refresh_token":"201208134b203fe6c11548bcabd8da5bb087a83b",//刷新令牌，上次换取访问令牌时得到。见出参的refresh_token字段
        ...
    }
    ```

  * 关键出参：

    ```json
    {
        "user_id":"2088102150477652",//支付宝用户的唯一userId
        "access_token":"20120823ac6ffaa4d2d84e7384bf983531473993",//访问令牌。通过该令牌调用需要授权类接口
        "expires_in":"3600",//访问令牌的有效时间，单位是秒。
        "refresh_token":"20120823ac6ffdsdf2d84e7384bf983531473993",//刷新令牌。通过该令牌可以刷新access_token
        "re_expires_in":"3600",//刷新令牌的有效时间，单位是秒。
        ...
    }
    ```

  #### 支付宝会员授权信息查询接口:[alipay.user.info.share](https://opendocs.alipay.com/apis/api_2/alipay.user.info.share)

  * 关键入参：

    ```json 
    {
        "auth_token":"",//用户授权得到的access_token
        "sign":"",//商户请求参数的签名串，详见签名
        ...
    }
    ```

  * 关键出参：

    ```json
    {
        "user_id":"",//支付宝用户的userId
        "avatar":"",//用户头像地址
        "province":"",//省份名称
        "city":"",//市名称。
        "gender":"",//性别（F：女性；M：男性）。
        //其他更多信息需要签约授权更高权限
        ...
    }
    ```

    

#### 单笔转账接口:[alipay.fund.trans.uni.transfer](https://opendocs.alipay.com/apis/api_28/alipay.fund.trans.uni.transfer)

* 关键入参：

  ```json
  {
      "out_biz_no":"",//商户端的唯一订单号，对于同一笔转账请求，商户需保证该订单号唯一
      "trans_amount":"",//订单总金额，单位为元，精确到小数点后两位,取值范围[0.1,100000000]
      "product_code":"TRANS_ACCOUNT_NO_PWD",//业务产品码
      "biz_scene":"DIRECT_TRANSFER",//单笔无密转账到支付宝/银行卡, B2C现金红包
      "payee_info":{	//收款方信息
          "identity":"",//参与方的唯一标识,支付宝的会员ID
          "identity_type":"ALIPAY_USER_ID",//参与方的标识类型
      }
  }
  ```

* 关键出参：

  ```json
  {
      "code":"10000",//网关返回码,详见文档(https://doc.open.alipay.com/docs/doc.htm?treeId=291&articleId=105806&docType=1)
      "msg":"Success",//网关返回码描述,详见文档(同上)
      "out_biz_no":"7HH8Sn8XC7ZmQLHd7vXk4HNbhE94ECOy",//	商户订单号
      "order_id":"20200427110070000006900048907873",//支付宝转账订单号
      "pay_fund_order_id":"20200427110070001506900049866260",//支付宝支付资金流水号	
      "status":"SUCCESS",//转账单据状态
      "trans_date":"2020-04-27 14:35:43",//订单支付时间，格式为yyyy-MM-dd HH:mm:ss
  }
  ```



#### 查询转账订单接口:[alipay.fund.trans.order.query](https://opendocs.alipay.com/apis/api_28/alipay.fund.trans.order.query)

* 关键入参：

  ```json
  {
      "product_code":"TRANS_ACCOUNT_NO_PWD",//销售产品码,单笔无密转账到支付宝账户
      "biz_scene":"DIRECT_TRANSFER",//描述特定的业务场景，B2C现金红包、单笔无密转账
      "out_biz_no":"3142321423432",//商户转账唯一订单号：发起转账来源方定义的转账单据ID。
      "order_id":"20160627110070001502260006780837",//支付宝转账单据号：和商户转账唯一订单号不能同时为空。默认使用order_id
      "pay_fund_order_id":"",//支付宝支付资金流水号：本参数和支付宝转账单据号、商户转账唯一订单号三者不能同时为空。
      ...
  }
  ```

* 关键出参：

  ```json
  {
      "code": "10000",
      "msg": "Success",
      "order_id": "20200427110070000006900048907873",//支付宝转账单据号，查询失败不返回。
      "pay_fund_order_id": "20200427110070001506900049866260",//	支付宝支付资金流水号，转账失败不返回。
      "out_biz_no": "7HH8Sn8XC7ZmQLHd7vXk4HNbhE94ECOy",//	商户订单号
      "trans_amount": "0.50",//付款金额，收银台场景下付款成功后的支付金额，订单状态为SUCCESS才返回，其他状态不返回。
      "status": "SUCCESS",	//转账单据状态。
      "pay_date": "2020-04-27 14:35:43"//支付时间，格式为yyyy-MM-dd HH:mm:ss，转账失败不返回。
  }
  ```

  

