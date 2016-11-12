#初始化定义      Device1/2:ATN Device3:CX600-M16A  Device4:950C(涂覆)  Device5:950C Device6:910C Device7:910C Device8:cable
set Global 1                         ;#Global 全局变量,控制循环执行
set Tick 0                           ;#用于计数，每一个循环累加一次；每个循环约30s
set Phone  18351880693               ;#接收人员手机号码
set Device_list0      { Device1 Device2 Device4 Device5 Device6 Device7 Device8 } ;#查询注册可以直接用命令，不需要匹配
set Device_list1      { Device1 Device3 Device4 Device5 Device6 Device7 }     ;#Device1\3\4\5\6\7有风扇
set Device_list2      { Device1 Device2 Device8 }     ;#温度查询方式要加slot2
set Device_list3      { Device3 }  ;#查询注册需要匹配子卡.
set Device_list4      { Device3 Device4 Device5 Device6 Device7 }     ;#温度查询通用
set Device_Type_list { Device1_Type }

set message TT    ;#短信模块串口名TT，窗口必须打开，使用时调用$message
set Mail    CMD   ;#发送邮件窗口 
#设备1，使用时调用$device1，打开窗口统一命名为设备的Device1、Device2...     

#匹配设备形态：0-ATN  3-M2  5-M4  9-M8 17-M16 
foreach device_type $Device_Type_list {
set $device_type 0 
}

#tsend3 $Mail -t 3000 "zj"
#*****************************************************短信模块初始化************************************************************#
tsend3 $message  -t 1000  "AT\r"        ;#自适应波特率
tsend3 $message  -t 1000  "AT\r"
tsend3 $message  -t 1000  "AT+CSQ\r"    ;#查询信号强度
tsend3 $message  -t 1000  "AT+CPIN?\r"  ;#查询模块是否检测到手机卡
tsend3 $message  -t 1000  "AT+COPS?\r"  ;#查询模块是否注册到网络
tsend3 $message  -t 1000  "AT+CNUM\r"   ;#查询本机号码
#
tsend3 $message  -t 1000  AT+CSCS="GSM"\r;#发送英文字符短信设置
tsend3 $message  -t 1000  "AT+CMGF=1\r"







while { $Global } {
#起始标志
#tsend3 $device   -t 1000 "start"       
#******************************************************查询风扇状态*************************************************************#
foreach device $Device_list1 {
tsend3  $device   -t 1000 "disp clock"
#命令执行_device1
#查询设备1风扇状态 res_dev1_fan存放设备1风扇状态字符串         
tsend3 $device -r res_dev_fan -s "\<HUAWEI\>\ \[HUAWEI\ \[Y/N\]" -t 3000 "display fan"  
after 3000
#将匹配结果存放进num_dev_fan，1-有异常  0-无异常    风扇异常，转速显示*
set num_dev_fan1 [regexp {[\[0-9]]\*} $res_dev_fan] 
set num_dev_fan2 [regexp {(The fan is absent)} $res_dev_fan]

#puts "FAN--$num_dev_fan"
#puts "$Device1_Type"
if {($num_dev_fan1==1)|($num_dev_fan2==1)} { 
#puts "$Device1_Type"
#tsend3 $Mail     -t 10000  "java -classpath commons-logging-1.1.1.jar;log4j-1.2.17.jar;mail.jar;MailSend.jar org.jn.util.mail.Mail"
#tsend3 $Mail  -t 10000  "mail send test command!"
after 10000

tsend3 $message   -t 1000  AT+CMGS="$Phone"\r    ;#接收方电话号码
tsend3 $message   -t 1000  "FAN  of $device is Abnormal!!!\r"
tsend3 $message   -t 1000  \x1a   ;#启动发送标志
after 10000
after 10000

set Global 0
return
}
}

#******************************************************查询设备状态通用************************************************************#
foreach device $Device_list0 {
tsend3  $device   -t 1000 "disp clock"
#查询设备1单板状态 res_dev_device存放设备1单板状态字符串, res_dev_pic存放设备1子卡状态字符串,       
#tsend3 $device -r res_dev_pic -s "\<HUAWEI\>\ \[HUAWEI\ \[Y/N\]" -t 3000 "display device pic-status" 
tsend3 $device -r res_dev_device -s "\<HUAWEI\>\ \[HUAWEI\ \[Y/N\]" -t 3000 "display device"  
after 3000
#将匹配结果存放进num_dev_device，1-有异常  0-无异常    单板异常，转速显示*
set num_dev_device [regexp {(Abnormal)|(Unregistered)} $res_dev_device]
#PTN设备没有disp dev pic命令
#set num_dev_pic    [regexp {(Abnormal)|(Unregistered)} $res_dev_pic]   
if {$num_dev_device==1} {
#tsend3 $Mail     -t 10000  "java -classpath commons-logging-1.1.1.jar;log4j-1.2.17.jar;mail.jar;MailSend.jar org.jn.util.mail.Mail"
#tsend3 $Mail  -t 10000  "mail send test command!"
after 10000

tsend3 $message   -t 1000  AT+CMGS="$Phone"\r    ;#接收方电话号码
tsend3 $message   -t 1000  "Device status of $device is Abnormal!!!!!!\r"
tsend3 $message   -t 1000  \x1a   ;#启动发送标志
after 10000
after 10000

set Global 0
return
}
}

#******************************************************查询设备状态CX*************************************************************#
foreach device $Device_list3 {
tsend3  $device   -t 1000 "disp clock"
#查询设备1单板状态 res_dev_device存放设备1单板状态字符串, res_dev_pic存放设备1子卡状态字符串,       
#tsend3 $device -r res_dev_pic -s "\<HUAWEI\>\ \[HUAWEI\ \[Y/N\]" -t 3000 "display device pic-status" 
tsend3 $device -r res_dev_device -s "\<HUAWEI\>\ \[HUAWEI\ \[Y/N\]" -t 3000 "disp dev pic"  
after 3000
#将匹配结果存放进num_dev_device，1-有异常  0-无异常    单板异常，转速显示*
set num_dev_device [regexp {(Abnormal)|(Unregistered)} $res_dev_device]
#PTN设备没有disp dev pic命令
#set num_dev_pic    [regexp {(Abnormal)|(Unregistered)} $res_dev_pic]   
if {$num_dev_device==1} {
#tsend3 $Mail     -t 10000  "java -classpath commons-logging-1.1.1.jar;log4j-1.2.17.jar;mail.jar;MailSend.jar org.jn.util.mail.Mail"
#tsend3 $Mail  -t 10000  "mail send test command!"
after 10000

tsend3 $message   -t 1000  AT+CMGS="$Phone"\r    ;#接收方电话号码
tsend3 $message   -t 1000  "Device status of $device is Abnormal -- CX600_M16A!!!!!!\r"
tsend3 $message   -t 1000  \x1a   ;#启动发送标志
after 10000
after 10000

set Global 0
return
}
}

#******************************************************查询温度状态加slot2*************************************************************#
foreach device $Device_list2 {
tsend3  $device   -t 1000 "disp clock"
#查询设备温度状态 res_dev_temperature存放设备温度状态字符串       
tsend3 $device -r res_dev_temperature -s "\<HUAWEI\>\ \[HUAWEI\ \[Y/N\]" -t 3000 "display temperature slot 2"  
after 3000
#将匹配结果存放进num_dev_temperature，1-有异常  0-无异常    
set num_dev_temperature [regexp {(FATAL)|(MAJOR)|(MINOR)} $res_dev_temperature] 
if {$num_dev_temperature==1} {
#tsend3 $Mail     -t 10000  "java -classpath commons-logging-1.1.1.jar;log4j-1.2.17.jar;mail.jar;MailSend.jar org.jn.util.mail.Mail"
#tsend3 $Mail  -t 10000  "mail send test command!"
after 10000

tsend3 $message   -t 1000  AT+CMGS="$Phone"\r    ;#接收方电话号码
tsend3 $message   -t 1000  "Temperature of $device is Abnormal!!!\r"
tsend3 $message   -t 1000  \x1a   ;#启动发送标志
after 10000

set Global 0
return
}
}

#******************************************************查询温度状态通用*************************************************************#
foreach device $Device_list4 {
tsend3  $device   -t 1000 "disp clock"
#查询设备温度状态 res_dev_temperature存放设备温度状态字符串       
tsend3 $device -r res_dev_temperature -s "\<HUAWEI\>\ \[HUAWEI\ \[Y/N\]" -t 3000 "display temperature"  
after 3000
#将匹配结果存放进num_dev_temperature，1-有异常  0-无异常    
set num_dev_temperature [regexp {(FATAL)|(MAJOR)|(MINOR)} $res_dev_temperature] 
if {$num_dev_temperature==1} {
#tsend3 $Mail     -t 10000  "java -classpath commons-logging-1.1.1.jar;log4j-1.2.17.jar;mail.jar;MailSend.jar org.jn.util.mail.Mail"
#tsend3 $Mail  -t 10000  "mail send test command!"
after 10000

tsend3 $message   -t 1000  AT+CMGS="$Phone"\r    ;#接收方电话号码
tsend3 $message   -t 1000  "Temperature of $device is Abnormal!!!\r"
tsend3 $message   -t 1000  \x1a   ;#启动发送标志
after 10000

set Global 0
return
}
}

#******************************************************查询复位状态ATN*************************************************************#
foreach device $Device_list2 {
tsend3  $device   -t 1000 "disp clock"
tsend3  $device   -t 1000 "sy"
tsend3  $device   -t 1000 "dia"
#匹配设备单板类型，根据不同类型查询复位原因     
tsend3 $device -r res_dev_rst1 -s "\<HUAWEI\>\ \[HUAWEI\ \[Y/N\]" -t 3000 "display board-reset 2"  
#tsend3 $device -r res_dev_rst2 -s "\<HUAWEI\>\ \[HUAWEI\ \[Y/N\]" -t 3000 "display board-reset 17"
after 5000
tsend3  $device   -t 1000 "return"
if {([string length $res_dev_rst1]>400)} {
#tsend3 $Mail     -t 10000  "java -classpath commons-logging-1.1.1.jar;log4j-1.2.17.jar;mail.jar;MailSend.jar org.jn.util.mail.Mail"
#tsend3  $Mail -t 10000  "mail send test command!"
#puts "$Device1_Type"

tsend3 $message   -t 1000  AT+CMGS="$Phone"\r    ;#接收方电话号码
tsend3 $message   -t 1000  "reset state of $device is Abnormal!!! -- ATN\r"
tsend3 $message   -t 1000  \x1a   ;#启动发送标志
after 10000
set Global 0
return
}
}

#******************************************************查询复位状态CX*************************************************************#
foreach device $Device_list3 {
tsend3  $device   -t 1000 "disp clock"
tsend3  $device   -t 1000 "sy"
tsend3  $device   -t 1000 "dia"
#匹配设备单板类型，根据不同类型查询复位原因     
tsend3 $device -r res_dev_rst1 -s "\<HUAWEI\>\ \[HUAWEI\ \[Y/N\]" -t 3000 "disp board-r 17 card 13"  
#tsend3 $device -r res_dev_rst2 -s "\<HUAWEI\>\ \[HUAWEI\ \[Y/N\]" -t 3000 "display board-reset 17"
after 3000
tsend3  $device   -t 1000 "return"
if {([string length $res_dev_rst1]>400)} {
#tsend3 $Mail     -t 10000  "java -classpath commons-logging-1.1.1.jar;log4j-1.2.17.jar;mail.jar;MailSend.jar org.jn.util.mail.Mail"
#tsend3  $Mail -t 10000  "mail send test command!"
#puts "$Device1_Type"

tsend3 $message   -t 1000  AT+CMGS="$Phone"\r    ;#接收方电话号码
tsend3 $message   -t 1000  "reset state of $device is Abnormal!!! -- CX600_M16A\r"
tsend3 $message   -t 1000  \x1a   ;#启动发送标志
after 10000
set Global 0
return
}
}
#******************************************************查询告警状态*************************************************************#
foreach device $Device_list2 {
tsend3  $device   -t 1000 "disp clock"
#匹配设备单板类型，根据不同类型查询复位原因     
tsend3 $device -r res_dev_alarm -s "\<HUAWEI\>\ \[HUAWEI\ \[Y/N\]" -t 3000 "display alarm all"  
after 3000
set num_dev_alarm [regexp {NO alarm} $res_dev_alarm] 
if {$num_dev_alarm==0} {                ;#告警字符数在默认的告警回显字符数上不增加则代表没有新增告警
#tsend3 $Mail     -t 10000  "java -classpath commons-logging-1.1.1.jar;log4j-1.2.17.jar;mail.jar;MailSend.jar org.jn.util.mail.Mail"
#tsend3  $Mail -t 10000  "mail send test command!"
#puts "$Device1_Type"

tsend3 $message   -t 1000  AT+CMGS="$Phone"\r    ;#接收方电话号码
tsend3 $message   -t 1000  "Hardware Alarm -- ATN!!!\r"
tsend3 $message   -t 1000  \x1a   ;#启动发送标志
after 10000

set Global 0
return
}
}
tsend3 $device   -t 1000 "disp clock"
#结束标志
#tsend3 $device   -t 1000 "end"     
#******************************************************查询告警状态CX*************************************************************#
foreach device $Device_list3 {
tsend3  $device   -t 1000 "disp clock"
#匹配设备单板类型，根据不同类型查询复位原因     
tsend3 $device -r res_dev_alarm -s "\<HUAWEI\>\ \[HUAWEI\ \[Y/N\]" -t 3000 "display alarm all"  
after 3000
set num_dev_alarm [regexp {No alarm} $res_dev_alarm] 
if {$num_dev_alarm==0} {                ;#告警字符数在默认的告警回显字符数上不增加则代表没有新增告警
#tsend3 $Mail     -t 10000  "java -classpath commons-logging-1.1.1.jar;log4j-1.2.17.jar;mail.jar;MailSend.jar org.jn.util.mail.Mail"
#tsend3  $Mail -t 10000  "mail send test command!"
#puts "$Device1_Type"

tsend3 $message   -t 1000  AT+CMGS="$Phone"\r    ;#接收方电话号码
tsend3 $message   -t 1000  "Hardware Alarm -- CX600_M16A!!!\r"
tsend3 $message   -t 1000  \x1a   ;#启动发送标志
after 10000

set Global 0
return
}
}
tsend3 $device   -t 1000 "disp clock"

#*****************************************************计数加一******************************************************************#
set Tick [expr $Tick+1]
if {$Tick>500} {                                   ;#约是48小时，发送一封邮件告知测试人员设备无异常
tsend3 $Mail     -t 10000  "java -classpath commons-logging-1.1.1.jar;log4j-1.2.17.jar;mail.jar;MailSend.jar org.jn.util.mail.Mail\r"
after 10000
set Tick 0
}
puts "$Tick"
#******************************************************循环结束*****************************************************************#
}
