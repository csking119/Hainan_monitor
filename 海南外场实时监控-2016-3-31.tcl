#��ʼ������      Device1/2:ATN Device3:CX600-M16A  Device4:950C(Ϳ��)  Device5:950C Device6:910C Device7:910C Device8:cable
set Global 1                         ;#Global ȫ�ֱ���,����ѭ��ִ��
set Tick 0                           ;#���ڼ�����ÿһ��ѭ���ۼ�һ�Σ�ÿ��ѭ��Լ30s
set Phone  18351880693               ;#������Ա�ֻ�����
set Device_list0      { Device1 Device2 Device4 Device5 Device6 Device7 Device8 } ;#��ѯע�����ֱ�����������Ҫƥ��
set Device_list1      { Device1 Device3 Device4 Device5 Device6 Device7 }     ;#Device1\3\4\5\6\7�з���
set Device_list2      { Device1 Device2 Device8 }     ;#�¶Ȳ�ѯ��ʽҪ��slot2
set Device_list3      { Device3 }  ;#��ѯע����Ҫƥ���ӿ�.
set Device_list4      { Device3 Device4 Device5 Device6 Device7 }     ;#�¶Ȳ�ѯͨ��
set Device_Type_list { Device1_Type }

set message TT    ;#����ģ�鴮����TT�����ڱ���򿪣�ʹ��ʱ����$message
set Mail    CMD   ;#�����ʼ����� 
#�豸1��ʹ��ʱ����$device1���򿪴���ͳһ����Ϊ�豸��Device1��Device2...     

#ƥ���豸��̬��0-ATN  3-M2  5-M4  9-M8 17-M16 
foreach device_type $Device_Type_list {
set $device_type 0 
}

#tsend3 $Mail -t 3000 "zj"
#*****************************************************����ģ���ʼ��************************************************************#
tsend3 $message  -t 1000  "AT\r"        ;#����Ӧ������
tsend3 $message  -t 1000  "AT\r"
tsend3 $message  -t 1000  "AT+CSQ\r"    ;#��ѯ�ź�ǿ��
tsend3 $message  -t 1000  "AT+CPIN?\r"  ;#��ѯģ���Ƿ��⵽�ֻ���
tsend3 $message  -t 1000  "AT+COPS?\r"  ;#��ѯģ���Ƿ�ע�ᵽ����
tsend3 $message  -t 1000  "AT+CNUM\r"   ;#��ѯ��������
#
tsend3 $message  -t 1000  AT+CSCS="GSM"\r;#����Ӣ���ַ���������
tsend3 $message  -t 1000  "AT+CMGF=1\r"







while { $Global } {
#��ʼ��־
#tsend3 $device   -t 1000 "start"       
#******************************************************��ѯ����״̬*************************************************************#
foreach device $Device_list1 {
tsend3  $device   -t 1000 "disp clock"
#����ִ��_device1
#��ѯ�豸1����״̬ res_dev1_fan����豸1����״̬�ַ���         
tsend3 $device -r res_dev_fan -s "\<HUAWEI\>\ \[HUAWEI\ \[Y/N\]" -t 3000 "display fan"  
after 3000
#��ƥ������Ž�num_dev_fan��1-���쳣  0-���쳣    �����쳣��ת����ʾ*
set num_dev_fan1 [regexp {[\[0-9]]\*} $res_dev_fan] 
set num_dev_fan2 [regexp {(The fan is absent)} $res_dev_fan]

#puts "FAN--$num_dev_fan"
#puts "$Device1_Type"
if {($num_dev_fan1==1)|($num_dev_fan2==1)} { 
#puts "$Device1_Type"
#tsend3 $Mail     -t 10000  "java -classpath commons-logging-1.1.1.jar;log4j-1.2.17.jar;mail.jar;MailSend.jar org.jn.util.mail.Mail"
#tsend3 $Mail  -t 10000  "mail send test command!"
after 10000

tsend3 $message   -t 1000  AT+CMGS="$Phone"\r    ;#���շ��绰����
tsend3 $message   -t 1000  "FAN  of $device is Abnormal!!!\r"
tsend3 $message   -t 1000  \x1a   ;#�������ͱ�־
after 10000
after 10000

set Global 0
return
}
}

#******************************************************��ѯ�豸״̬ͨ��************************************************************#
foreach device $Device_list0 {
tsend3  $device   -t 1000 "disp clock"
#��ѯ�豸1����״̬ res_dev_device����豸1����״̬�ַ���, res_dev_pic����豸1�ӿ�״̬�ַ���,       
#tsend3 $device -r res_dev_pic -s "\<HUAWEI\>\ \[HUAWEI\ \[Y/N\]" -t 3000 "display device pic-status" 
tsend3 $device -r res_dev_device -s "\<HUAWEI\>\ \[HUAWEI\ \[Y/N\]" -t 3000 "display device"  
after 3000
#��ƥ������Ž�num_dev_device��1-���쳣  0-���쳣    �����쳣��ת����ʾ*
set num_dev_device [regexp {(Abnormal)|(Unregistered)} $res_dev_device]
#PTN�豸û��disp dev pic����
#set num_dev_pic    [regexp {(Abnormal)|(Unregistered)} $res_dev_pic]   
if {$num_dev_device==1} {
#tsend3 $Mail     -t 10000  "java -classpath commons-logging-1.1.1.jar;log4j-1.2.17.jar;mail.jar;MailSend.jar org.jn.util.mail.Mail"
#tsend3 $Mail  -t 10000  "mail send test command!"
after 10000

tsend3 $message   -t 1000  AT+CMGS="$Phone"\r    ;#���շ��绰����
tsend3 $message   -t 1000  "Device status of $device is Abnormal!!!!!!\r"
tsend3 $message   -t 1000  \x1a   ;#�������ͱ�־
after 10000
after 10000

set Global 0
return
}
}

#******************************************************��ѯ�豸״̬CX*************************************************************#
foreach device $Device_list3 {
tsend3  $device   -t 1000 "disp clock"
#��ѯ�豸1����״̬ res_dev_device����豸1����״̬�ַ���, res_dev_pic����豸1�ӿ�״̬�ַ���,       
#tsend3 $device -r res_dev_pic -s "\<HUAWEI\>\ \[HUAWEI\ \[Y/N\]" -t 3000 "display device pic-status" 
tsend3 $device -r res_dev_device -s "\<HUAWEI\>\ \[HUAWEI\ \[Y/N\]" -t 3000 "disp dev pic"  
after 3000
#��ƥ������Ž�num_dev_device��1-���쳣  0-���쳣    �����쳣��ת����ʾ*
set num_dev_device [regexp {(Abnormal)|(Unregistered)} $res_dev_device]
#PTN�豸û��disp dev pic����
#set num_dev_pic    [regexp {(Abnormal)|(Unregistered)} $res_dev_pic]   
if {$num_dev_device==1} {
#tsend3 $Mail     -t 10000  "java -classpath commons-logging-1.1.1.jar;log4j-1.2.17.jar;mail.jar;MailSend.jar org.jn.util.mail.Mail"
#tsend3 $Mail  -t 10000  "mail send test command!"
after 10000

tsend3 $message   -t 1000  AT+CMGS="$Phone"\r    ;#���շ��绰����
tsend3 $message   -t 1000  "Device status of $device is Abnormal -- CX600_M16A!!!!!!\r"
tsend3 $message   -t 1000  \x1a   ;#�������ͱ�־
after 10000
after 10000

set Global 0
return
}
}

#******************************************************��ѯ�¶�״̬��slot2*************************************************************#
foreach device $Device_list2 {
tsend3  $device   -t 1000 "disp clock"
#��ѯ�豸�¶�״̬ res_dev_temperature����豸�¶�״̬�ַ���       
tsend3 $device -r res_dev_temperature -s "\<HUAWEI\>\ \[HUAWEI\ \[Y/N\]" -t 3000 "display temperature slot 2"  
after 3000
#��ƥ������Ž�num_dev_temperature��1-���쳣  0-���쳣    
set num_dev_temperature [regexp {(FATAL)|(MAJOR)|(MINOR)} $res_dev_temperature] 
if {$num_dev_temperature==1} {
#tsend3 $Mail     -t 10000  "java -classpath commons-logging-1.1.1.jar;log4j-1.2.17.jar;mail.jar;MailSend.jar org.jn.util.mail.Mail"
#tsend3 $Mail  -t 10000  "mail send test command!"
after 10000

tsend3 $message   -t 1000  AT+CMGS="$Phone"\r    ;#���շ��绰����
tsend3 $message   -t 1000  "Temperature of $device is Abnormal!!!\r"
tsend3 $message   -t 1000  \x1a   ;#�������ͱ�־
after 10000

set Global 0
return
}
}

#******************************************************��ѯ�¶�״̬ͨ��*************************************************************#
foreach device $Device_list4 {
tsend3  $device   -t 1000 "disp clock"
#��ѯ�豸�¶�״̬ res_dev_temperature����豸�¶�״̬�ַ���       
tsend3 $device -r res_dev_temperature -s "\<HUAWEI\>\ \[HUAWEI\ \[Y/N\]" -t 3000 "display temperature"  
after 3000
#��ƥ������Ž�num_dev_temperature��1-���쳣  0-���쳣    
set num_dev_temperature [regexp {(FATAL)|(MAJOR)|(MINOR)} $res_dev_temperature] 
if {$num_dev_temperature==1} {
#tsend3 $Mail     -t 10000  "java -classpath commons-logging-1.1.1.jar;log4j-1.2.17.jar;mail.jar;MailSend.jar org.jn.util.mail.Mail"
#tsend3 $Mail  -t 10000  "mail send test command!"
after 10000

tsend3 $message   -t 1000  AT+CMGS="$Phone"\r    ;#���շ��绰����
tsend3 $message   -t 1000  "Temperature of $device is Abnormal!!!\r"
tsend3 $message   -t 1000  \x1a   ;#�������ͱ�־
after 10000

set Global 0
return
}
}

#******************************************************��ѯ��λ״̬ATN*************************************************************#
foreach device $Device_list2 {
tsend3  $device   -t 1000 "disp clock"
tsend3  $device   -t 1000 "sy"
tsend3  $device   -t 1000 "dia"
#ƥ���豸�������ͣ����ݲ�ͬ���Ͳ�ѯ��λԭ��     
tsend3 $device -r res_dev_rst1 -s "\<HUAWEI\>\ \[HUAWEI\ \[Y/N\]" -t 3000 "display board-reset 2"  
#tsend3 $device -r res_dev_rst2 -s "\<HUAWEI\>\ \[HUAWEI\ \[Y/N\]" -t 3000 "display board-reset 17"
after 5000
tsend3  $device   -t 1000 "return"
if {([string length $res_dev_rst1]>400)} {
#tsend3 $Mail     -t 10000  "java -classpath commons-logging-1.1.1.jar;log4j-1.2.17.jar;mail.jar;MailSend.jar org.jn.util.mail.Mail"
#tsend3  $Mail -t 10000  "mail send test command!"
#puts "$Device1_Type"

tsend3 $message   -t 1000  AT+CMGS="$Phone"\r    ;#���շ��绰����
tsend3 $message   -t 1000  "reset state of $device is Abnormal!!! -- ATN\r"
tsend3 $message   -t 1000  \x1a   ;#�������ͱ�־
after 10000
set Global 0
return
}
}

#******************************************************��ѯ��λ״̬CX*************************************************************#
foreach device $Device_list3 {
tsend3  $device   -t 1000 "disp clock"
tsend3  $device   -t 1000 "sy"
tsend3  $device   -t 1000 "dia"
#ƥ���豸�������ͣ����ݲ�ͬ���Ͳ�ѯ��λԭ��     
tsend3 $device -r res_dev_rst1 -s "\<HUAWEI\>\ \[HUAWEI\ \[Y/N\]" -t 3000 "disp board-r 17 card 13"  
#tsend3 $device -r res_dev_rst2 -s "\<HUAWEI\>\ \[HUAWEI\ \[Y/N\]" -t 3000 "display board-reset 17"
after 3000
tsend3  $device   -t 1000 "return"
if {([string length $res_dev_rst1]>400)} {
#tsend3 $Mail     -t 10000  "java -classpath commons-logging-1.1.1.jar;log4j-1.2.17.jar;mail.jar;MailSend.jar org.jn.util.mail.Mail"
#tsend3  $Mail -t 10000  "mail send test command!"
#puts "$Device1_Type"

tsend3 $message   -t 1000  AT+CMGS="$Phone"\r    ;#���շ��绰����
tsend3 $message   -t 1000  "reset state of $device is Abnormal!!! -- CX600_M16A\r"
tsend3 $message   -t 1000  \x1a   ;#�������ͱ�־
after 10000
set Global 0
return
}
}
#******************************************************��ѯ�澯״̬*************************************************************#
foreach device $Device_list2 {
tsend3  $device   -t 1000 "disp clock"
#ƥ���豸�������ͣ����ݲ�ͬ���Ͳ�ѯ��λԭ��     
tsend3 $device -r res_dev_alarm -s "\<HUAWEI\>\ \[HUAWEI\ \[Y/N\]" -t 3000 "display alarm all"  
after 3000
set num_dev_alarm [regexp {NO alarm} $res_dev_alarm] 
if {$num_dev_alarm==0} {                ;#�澯�ַ�����Ĭ�ϵĸ澯�����ַ����ϲ����������û�������澯
#tsend3 $Mail     -t 10000  "java -classpath commons-logging-1.1.1.jar;log4j-1.2.17.jar;mail.jar;MailSend.jar org.jn.util.mail.Mail"
#tsend3  $Mail -t 10000  "mail send test command!"
#puts "$Device1_Type"

tsend3 $message   -t 1000  AT+CMGS="$Phone"\r    ;#���շ��绰����
tsend3 $message   -t 1000  "Hardware Alarm -- ATN!!!\r"
tsend3 $message   -t 1000  \x1a   ;#�������ͱ�־
after 10000

set Global 0
return
}
}
tsend3 $device   -t 1000 "disp clock"
#������־
#tsend3 $device   -t 1000 "end"     
#******************************************************��ѯ�澯״̬CX*************************************************************#
foreach device $Device_list3 {
tsend3  $device   -t 1000 "disp clock"
#ƥ���豸�������ͣ����ݲ�ͬ���Ͳ�ѯ��λԭ��     
tsend3 $device -r res_dev_alarm -s "\<HUAWEI\>\ \[HUAWEI\ \[Y/N\]" -t 3000 "display alarm all"  
after 3000
set num_dev_alarm [regexp {No alarm} $res_dev_alarm] 
if {$num_dev_alarm==0} {                ;#�澯�ַ�����Ĭ�ϵĸ澯�����ַ����ϲ����������û�������澯
#tsend3 $Mail     -t 10000  "java -classpath commons-logging-1.1.1.jar;log4j-1.2.17.jar;mail.jar;MailSend.jar org.jn.util.mail.Mail"
#tsend3  $Mail -t 10000  "mail send test command!"
#puts "$Device1_Type"

tsend3 $message   -t 1000  AT+CMGS="$Phone"\r    ;#���շ��绰����
tsend3 $message   -t 1000  "Hardware Alarm -- CX600_M16A!!!\r"
tsend3 $message   -t 1000  \x1a   ;#�������ͱ�־
after 10000

set Global 0
return
}
}
tsend3 $device   -t 1000 "disp clock"

#*****************************************************������һ******************************************************************#
set Tick [expr $Tick+1]
if {$Tick>500} {                                   ;#Լ��48Сʱ������һ���ʼ���֪������Ա�豸���쳣
tsend3 $Mail     -t 10000  "java -classpath commons-logging-1.1.1.jar;log4j-1.2.17.jar;mail.jar;MailSend.jar org.jn.util.mail.Mail\r"
after 10000
set Tick 0
}
puts "$Tick"
#******************************************************ѭ������*****************************************************************#
}
