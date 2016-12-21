<?php
$data = [
'secret'	=>	'105bda02afe2a6eff3b39572a7f6f948',
'token'		=>	'6ab74ffcce2ca56c9aab53d69e92b998',
'key'		=>	'alarm',
'title'		=>	'告警消息测试',
'content'	=>	'10.221.44.198 磁盘分区0使用90%, 剩余0.7G.',
'remark'	=>	'请尽快处理（您可以点击这里参考告警类型说明及处理建议）.',
'time'		=>	time()
];

$url = 'http://u.ifeige.cn/api/send_message' ;

$ch = curl_init();

curl_setopt($ch, CURLOPT_URL, $url);
curl_setopt($ch, CURLOPT_RETURNTRANSFER, 1);
curl_setopt($ch, CURLOPT_POST, 1);
curl_setopt($ch, CURLOPT_POSTFIELDS, $data);
$result = curl_exec($ch);
curl_close($ch);

var_dump(json_decode($result,true));
// 返回数据为json格式
//{"code":200,"msg":"Request Ok","data":{"count":2}}
//code :
//    200     成功
  //  10001   缺少secret 或 token
    //10002   缺少消息标题或内容
   // 10003   消息模板KEY错误
    //10004   secret 或 token 错误
   // 10005   余额不足
 ?>