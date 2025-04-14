---
title: Protocol information
pageid: 19008145
---

### Protocol versions

31 October 2008  

UNIStim Firmware Release 3.1 for IP Phones, includes:

* 0604DCG for Phase II IP Phones (2001, 2002 и 2004),
* 0621C6H for IP Phone 2007,
* 0623C6J, 0624C6J, 0625C6J and 0627C6J for IP Phone 1110, 1120E,1140E and 1150E respectively
* 062AC6J for IP Phone 1210, 1220, and 1230

27 February 2009  

UNIStim Firmware Release 3.2 for IP Phones, including:

* 0604DCJ for Phase II IP Phones (2001, 2002 & 2004),
* 0621C6M for IP Phone 2007,
* 0623C6N, 0624C6N, 0625C6N and 0627C6N for IP Phone 1110, 1120E,1140E and 1150E respectively
* 062AC6N for IP Phone 1210, 1220, and 1230

30 June 2009  

UNIStim Firmware Release 3.3 for IP Phones:

* 0604DCL for Phase II IP Phones (2001, 2002 & 2004),
* 0621C6P for IP Phone 2007,
* 0623C6R, 0624C6R, 0625C6R and 0627C6R for IP Phone 1110, 1120E,1140E and 1150E respectively
* 062AC6R for IP Phone 1210, 1220, and 1230

27 November 2009  

UNIStim Software Release 4.0 for IP Phones, includes:

* 0621C7A for IP Phone 2007,
* 0623C7F, 0624C7F, 0625C7F and 0627C7F for IP Phone 1110, 1120E,1140E and 1150E respectively
* 062AC7F for IP Phone 1210, 1220, and 1230

28 February 2010  

UNIStim Software Release 4.1 IP Deskphone Software

* 0621C7D / 2007 IP Deskphone
* 0623C7J / 1110 IP Deskphone
* 0624C7J / 1120E IP Deskphone
* 0625C7J / 1140E IP Deskphone
* 0627C7J / 1150E IP Deskphone
* 0626C7J / 1165E IP Deskphone
* 062AC7J / 1210 IP Deskphone
* 062AC7J / 1220 IP Deskphone
* 062AC7J / 1230 IP Deskphone

29 Июня 2010  

UNIStim Software Release 4.2 IP Deskphone Software

* 0621C7G / 2007 IP Deskphone
* 0623C7M / 1110 IP Deskphone
* 0624C7M / 1120E IP Deskphone
* 0625C7M / 1140E IP Deskphone
* 0627C7M / 1150E IP Deskphone
* 0626C7M / 1165E IP Deskphone
* 062AC7M / 1210 IP Deskphone
* 062AC7M / 1220 IP Deskphone
* 062AC7M / 1230 IP Deskphone

### Protocol description

Query Audio Manager  

(16 xx 00 xx…)  

Note:  

Ensure that the handshake commands  

1A 04 01 08  

1A 07 07 01 23 45 67  

are sent to i2004 before sending the commands in column 2. (Requests  

attributes of the Audio manager)  

16 05 00 01 00  

Note: Last byte can contain any value. The message length should be 5.  

If the length is wrong it is ignored e.g. send  

16 04 00 01  

16 06 00 01 00 03  

(Requests options setting of the Audio manager)  

16 05 00 02 03  

Note: Last byte can contain any value. The message length should be 5.  

If the length is wrong it is ignored.  

(Requests Alerting selection)  

16 05 00 04 0F  

Note: Last byte can contain any value. The message length should be 5.  

If the length is wrong it is ignored.  

(Requests adjustable Rx volume information command)  

16 05 00 08 00  

Note: Last byte can contain any value. The message length should be 5.  

If the length is wrong it is ignored.  

(Requests the i2004 to send the APB's Default Rx Volume command. The  

APB Number or stream based tone is provided in the last byte of the  

command below)  

16 05 00 10 00 (none)  

16 05 00 10 01 (Audio parameter bank 1, NBHS)  

16 05 00 10 02 (Audio parameter bank 2, NBHDS)  

16 05 00 10 03 (Audio parameter bank 3, NBHF)  

16 05 00 10 04 (Audio parameter bank 4, WBHS)  

16 05 00 10 05 (Audio parameter bank 5, WBHDS)  

16 05 00 10 06 (Audio parameter bank 6, WBHF)  

16 05 00 10 07 (Audio parameter bank 7,)  

16 05 00 10 08 (Audio parameter bank 8,)  

16 05 00 10 09 (Audio parameter bank 9,)  

16 05 00 10 0A (Audio parameter bank 0xA,)  

16 05 00 10 0B (Audio parameter bank 0xB,)  

16 05 00 10 0C (Audio parameter bank 0xC,)  

16 05 00 10 0D (Audio parameter bank 0xD,)  

16 05 00 10 0E (Audio parameter bank 0xE,)  

16 05 00 10 0F (Audio parameter bank 0xF,)  

16 05 00 10 10 (Alerting tone)  

16 05 00 10 11 (Special tones)  

16 05 00 10 12 (Paging tones)  

16 05 00 10 13 (Not Defined)  

16 05 00 10 1x (Not Defined)  

 (Set the volume range in configuration message for each of the APBs  

and for alerting, paging and special tones (see below) and then send  

the following commands)  

(Requests handset status, when NBHS is 1) connected 2) disconnected)  

16 05 00 40 09  

Note: Last byte can contain any value. The message length should be 5.  

If the length is wrong it is ignored  

(Requests headset status, when HDS is  

disconnected)  

16 05 00 80 0A  

(Requests headset status, when HDS is connected)  

16 05 00 80 0A  

Note: Last byte can contain any value. The message length should be 5.  

If the length is wrong it is ignored  

(Requests handset and headset status when NBHS  

and HDS are disconnected)  

16 05 00 C0 05  

(Requests handset and headset status when NBHS  

and HDS are connected)  

16 05 00 C0 05  

(Send an invalid message)  

16 03 00  

(Send an invalid message. Is this an invalid msg??)  

16 06 00 22 22 22  

Query Supervisory headset status  

(16 03 01)  

16 03 01

Audio Manager Options  

(16 04 02 xx)  

(Maximum tone volume is one level lower than physical maximum  

Volume level adjustments are not performed locally in the i2004  

Adjustable Rx volume reports not sent to the NI when volume keys are pressed  

Single tone frequency NOT sent to HS port while call in progress.  

Single tone frequency NOT sent to HD port while call in progress.  

Automatic noise squelching disabled.  

HD key pressed command sent when i2004 receives make/break sequence.)  

16 04 02 00  

(Maximum tone volume is set to the physical maximum)  

16 04 02 01  

then requests options setting of the Audio manager by sending 16 04 00 02)  

(Volume level adjustments are performed locally in the i2004)  

16 04 02 02  

(then requests options setting of the Audio manager by sending 16 04 00 02)  

(Adjustable Rx volume reports sent to the NI when volume keys are pressed)  

16 04 02 04  

(then requests options setting of the Audio manager by sending 16 04 00 02)  

(Single tone frequency sent to HS port while call in progress)  

16 04 02 08  

(then requests options setting of the Audio manager by sending 16 04 00 02)  

(Single tone frequency sent to HD port while call in progress)  

16 04 02 10  

(then requests options setting of the Audio manager by sending 16 04 00 02)  

(Automatic noise squelching enabled.)  

16 04 02 20  

(then requests options setting of the Audio manager by sending 16 04 00 02)  

(Headset Rfeature Key Pressed command sent when i2004 receives  

make/break sequence.)  

16 04 02 40  

(then requests options setting of the Audio manager by sending 16 04 00 02)  

(In this case both bit 1 and bit 3 are set, hence Volume level  

adjustments are performed  

locally in the i2004 and Single tone frequency sent to HS port while  

call in progress.)  

16 04 02 0A

Mute/un-mute  

(16 xx 04 xx...)  

(In this case two phones are conneted. Phone 1 is given the ID  

47.129.31.35 and phone 2  

is given the ID 47.129.31.36. Commands are sent to phone 1 )  

(TX is muted on stream ID 00)  

16 05 04 01 00  

(TX is un-muted on stream ID 00)  

16 05 04 00 00  

(RX is muted on stream ID 00)  

16 05 04 03 00  

(RX is un-muted on stream ID 00)  

16 05 04 02 00  

(TX is muted on stream ID 00, Rx is un-muted on stream ID 00)  

16 07 04 01 00 02 00  

(TX is un-muted on stream ID 00, Rx is muted on stream ID 00)  

16 07 04 00 00 03 00  

(TX is un-muted on stream ID 00, Rx is un-muted on stream ID 00)  

16 07 04 00 00 02 00

Transducer Based tone on  

(16 04 10 xx)  

(Alerting on)  

16 04 10 00  

(Special tones on, played at down loaded tone volume level)  

16 04 10 01  

(paging on)  

16 04 10 02  

(not defined)  

16 04 10 03  

(Alerting on, played at two steps lower than down loaded tone volume level)  

16 04 10 08  

(Special tones on, played at two steps lower than down loaded tone volume level)  

16 04 10 09

Transducer Based tone off  

(16 04 10 xx)  

16 04 11 00 (Alerting off)  

16 04 11 01 (Special tones off)  

16 04 11 02 (paging off)  

16 04 11 03 (not defined)

Alerting tone configuration  

(16 05 12 xx xx)  

(Note: Volume range is set here for all tones. This should be noted  

when testing the volume level message)  

(HF speaker with different warbler select values, tone volume range set to max)  

16 05 12 10 00  

16 05 12 11 0F  

16 05 12 12 0F  

16 05 12 13 0F  

16 05 12 14 0F  

16 05 12 15 0F  

16 05 12 16 0F  

16 05 12 17 0F  

(HF speaker with different cadence select values, tone volume range set to max)  

16 05 12 10 0F  

16 05 12 10 1F  

16 05 12 10 2F  

16 05 12 10 3F  

16 05 12 10 4F  

16 05 12 10 5F  

16 05 12 10 6F  

16 05 12 10 7F (configure cadence with alerting tone cadence download  

message before sending this message)  

(HS speaker with different warbler select values, tone volume level set to max)  

16 05 12 00 0F  

16 05 12 01 0F  

16 05 12 02 0F  

16 05 12 03 0F  

16 05 12 04 0F  

16 05 12 05 0F  

16 05 12 06 0F  

16 05 12 07 0F  

(HS speaker with different cadence select values, tone volume range set to max)  

16 05 12 00 0F  

16 05 12 00 1F  

16 05 12 00 2F  

16 05 12 00 3F  

16 05 12 00 4F  

16 05 12 00 5F  

16 05 12 00 6F  

16 05 12 00 7F (configure cadence with alerting tone cadence download  

message before sending this message)  

(HD speaker with different warbler select values, tone volume range set to max)  

16 05 12 08 0F  

16 05 12 09 0F  

16 05 12 0A 0F  

16 05 12 0B 0F  

16 05 12 0C 0F  

16 05 12 0D 0F  

16 05 12 0E 0F  

16 05 12 0F 0F  

(HD speaker with different cadence select values, tone volume level set to max)  

16 05 12 08 0F  

16 05 12 08 1F  

16 05 12 08 2F  

16 05 12 08 3F  

16 05 12 08 4F  

16 05 12 08 5F  

16 05 12 08 6F  

16 05 12 08 7F (configure cadence with alerting tone cadence download  

message before sending this message)

Special tone configuration  

(16 06 13 xx xx)  

(Note: Volume range is set here for all tones. This should be noted  

when testing the volume level message)  

(HF speaker with different tones, tone volume range is varied)  

16 06 13 10 00 01  

16 06 13 10 01 01  

16 06 13 10 08 01  

16 06 13 10 02 07  

16 06 13 10 03 07  

16 06 13 10 04 11  

16 06 13 10 05 11  

16 06 13 10 06 18  

16 06 13 10 07 18  

16 06 13 10 08 1F  

(HF speaker with different cadences and tones; tone volume level is varied)  

16 06 13 10 00 01  

16 06 13 10 10 01  

16 06 13 10 20 07  

16 06 13 10 30 07  

16 06 13 10 40 11  

16 06 13 10 50 11  

16 06 13 10 60 18  

16 06 13 10 70 18 (configure cadence with special tone cadence  

download message before sending this message)  

(HS speaker with different tones, tone volume range is varied)  

16 06 13 00 00 01  

16 06 13 00 01 01  

16 06 13 00 02 07  

16 06 13 00 03 07  

16 06 13 00 04 11  

16 06 13 00 05 11  

16 06 13 00 06 18  

16 06 13 00 07 18  

(HS speaker with different cadences and tones; tone volume range is varied)  

16 06 13 00 00 01  

16 06 13 00 10 01  

16 06 13 00 20 07  

16 06 13 00 30 07  

16 06 13 00 40 11  

16 06 13 00 50 11  

16 06 13 00 60 18  

16 06 13 00 70 18 (configure cadence with special tone cadence  

download message before sending this message)  

(HD speaker with different tones, tone volume range is varied)  

16 06 13 08 00 01  

16 06 13 08 01 01  

16 06 13 08 02 07  

16 06 13 08 03 07  

16 06 13 08 04 11  

16 06 13 08 05 11  

16 06 13 08 06 18  

16 06 13 08 07 18  

(HD speaker with different cadences and tones; tone volume range is varied)  

16 06 13 08 00 01  

16 06 13 08 10 01  

16 06 13 08 20 07  

16 06 13 08 30 07  

16 06 13 08 40 11  

16 06 13 08 50 11  

16 06 13 08 60 18  

16 06 13 08 70 18 (configure cadence with special tone cadence  

download message before sending this message)

Paging tone configuration  

(16 05 14 xx xx)  

(Note: Volume range is set here for all tones. This should be noted  

when testing the volume level message)  

(HF speaker with different cadence select values, tone volume range set to max)  

16 05 14 10 0F  

16 05 14 10 1F  

16 05 14 10 2F  

16 05 14 10 3F  

16 05 14 10 4F  

16 05 14 10 5F  

16 05 14 10 6F  

16 05 14 10 7F (configure cadence with paging tone cadence download  

message before sending this message)  

(HS speaker with different cadence select values, tone volume range set to max)  

16 05 14 00 0F  

16 05 14 00 1F  

16 05 14 00 2F  

16 05 14 00 3F  

16 05 14 00 4F  

16 05 14 00 5F  

16 05 14 00 6F  

16 05 14 00 7F (configure cadence with paging tone cadence download  

message before sending this message)  

(HD speaker with different cadence select values, tone volume level set to max)  

16 05 14 08 0F  

16 05 14 08 1F  

16 05 14 08 2F  

16 05 14 08 3F  

16 05 14 08 4F  

16 05 14 08 5F  

16 05 14 08 6F  

16 05 14 08 7F (configure cadence with paging tone cadence download  

message before sending this message)

Alerting Tone Cadence Download  

(16 xx 15 xx xx...)  

16 08 15 00 0A 0f 14 1E  

(.5 sec on, 0.75 sec off; 1 sec on 1.5 sec off, cyclic)  

16 0C 15 01 0A 0f 14 1E 05 0A 0A 14  

(.5 sec on, 0.75 sec off; 1 sec on 1.5 sec off; 0.25sec on, 0.5sec  

off; 0.5 sec on, 1 sec off , one shot)

Special Tone Cadence Download  

(16 xx 16 xx xx...)  

16 05 16 0A 10  

(125ms on, 200 ms off)  

16 09 16 0A 10 14 1E  

(125ms on, 200 ms off; 250ms on, 375ms off )

Paging Tone Cadence Download  

(16 xx 17 xx xx...)  

16 06 17 01 0A 10  

(125ms on, 200 ms off, 250HZ)  

16 06 17 04 05 10  

(62.5ms on, 200 ms off, 500 Hz)  

16 09 17 01 0A 10 10 14 1E  

(125ms on, 200 ms off; 250ms on, 375ms off, 250 Hz, 100Hz )  

16 0C 17 01 0A 10 04 14 1E 10 0A 10  

(125ms on, 200 ms off; 250ms on, 375ms off; 125ms on, 200 ms off,  

250Hz, 1000Hz, 500 Hz )  

16 0C 17 01 1E 10 12 3c 1E 10 28 10  

(375ms on, 200 ms off; 750ms on, 375ms off; 500ms on, 200 ms off,  

250Hz, (333Hz,1000Hz), 500 Hz )

Transducer Based Tone Volume Level  

(16 04 18 xx)  

(Ensure that the volume range is set properly in the alerting, special  

and paging  

tone configuration e.g if the volume range is set to zero, this  

message will always output  

max volume) (Different volume level for alerting tone. Note: Send the  

command below  

and then send the alerting on command and alerting off commands)  

16 04 18 00  

16 04 18 10  

16 04 18 20  

16 04 18 30  

16 04 18 40  

16 04 18 50  

16 04 18 60  

16 04 18 70  

16 04 18 80  

16 04 18 90  

16 04 18 F0  

(HF:Volume range for alerting tone is changed here using these commands)  

16 05 12 10 0F  

16 05 12 10 00  

16 05 12 10 04  

(HD:Volume range for alerting tone is changed here using these commands)  

16 05 12 08 0F  

16 05 12 08 00  

16 05 12 08 04  

(Different volume level for special tone)  

16 04 18 01  

16 04 18 11  

16 04 18 21  

16 04 18 31  

16 04 18 41  

16 04 18 51  

16 04 18 61  

16 04 18 71  

16 04 18 81  

16 04 18 91  

16 04 18 A1  

16 04 18 B1  

16 04 18 C1  

16 04 18 D1  

16 04 18 E1  

16 04 18 F1  

(HF:Volume range for special tone is changed here using these commands)  

16 06 13 10 20 07  

16 06 13 10 25 07  

16 06 13 10 2F 07  

(HD:Volume range for special tone is changed here using these commands)  

16 06 13 08 20 07  

16 06 13 08 25 07  

16 06 13 08 2F 07  

(Different volume level for paging tone)  

16 04 18 02  

16 04 18 12  

16 04 18 22  

16 04 18 32  

16 04 18 42  

16 04 18 52  

16 04 18 62  

16 04 18 72  

16 04 18 82  

16 04 18 92  

16 04 18 F2  

(HF:Volume range for paging tone is changed here using these commands)  

16 05 14 10 0F  

16 06 14 10 00  

16 06 14 10 04  

(HD:Volume range for paging tone is changed here using these commands)  

16 06 14 08 0F  

16 06 14 08 00  

16 06 14 08 04

Alerting Tone Test  

(16 04 19 xx)  

(tones 667Hz, duration 50 ms and 500Hz duration 50 ms)  

16 04 19 00  

(tones 333Hz, duration 50 ms and 250Hz duration 50 ms)  

16 04 19 01  

(tones 333 Hz + 667 Hz duration 87.5 ms and 500Hz + 1000Hz duration 87.5 ms)  

16 04 19 02  

(tones 333 Hz, duration 137.5 ms; 500Hz duration 75 ms; 667Hz duration 75 ms)  

16 04 19 03  

(tones 500Hz, duration 100 ms and 667Hz duration 100 ms)  

16 04 19 04  

(tones 500Hz, duration 400 ms and 667Hz duration 400 ms)  

16 04 19 05  

(tones 250Hz, duration 100 ms and 333Hz duration 100 ms)  

16 04 19 06  

(tones 250Hz, duration 400 ms and 333 Hz, duration 400ms)  

16 04 19 07

Visual Transducer Based Tones Enable  

(16 04 1A xx)  

Visual tone enabled  

16 04 1A 01  

(Visual tone disabled)  

16 04 1A 00

Stream Based Tone On  

(16 06 1B xx xx xx)  

(Dial tone is summed with data on Rx stream 00 at volume level -3dBm0)  

16 06 1B 00 00 08  

(Dial tone replaces the voice on Rx stream 00 at volume level -6dBm0)  

16 06 1B 80 00 10  

(Dial tone is summed with voice on Tx stream 00 at volume level -3dBm0)  

16 06 1B 40 00 08  

(Dial tone replaces the voice on Tx stream 00 at volume level -3dBm0)  

16 06 1B C0 00 08

(Line busy tone is summed with data on Rx stream 00 at volume level -3dBm0)  

16 06 1B 02 00 08  

(Line busy tone replaces the voice on Rx stream 00 at volume level -6dBm0)  

16 06 1B 82 00 10  

(Line busy tone is summed with voice on Tx stream 00 at volume level -3dBm0)  

16 06 1B 42 00 08  

(Line busy tone replaces the voice on Tx stream 00 at volume level -3dBm0)  

16 06 1B C2 00 08

(ROH tone is summed with data on Rx stream 00 at volume level -3dBm0)  

16 06 1B 05 00 08  

(ROH tone replaces the voice on Rx stream 00 at volume level -6dBm0)  

16 06 1B 85 00 10  

(ROH tone is summed with voice on Tx stream 00 at volume level -3dBm0)  

16 06 1B 45 00 08  

(ROH tone replaces the voice on Tx stream 00 at volume level -3dBm0)  

16 06 1B C5 00 08  

(Recall dial tone is summed with data on Rx stream 00 at volume level -3dBm0)  

16 06 1B 01 00 08  

(Recall dial tone replaces the voice on Rx stream 00 at volume level -6dBm0)  

16 06 1B 81 00 10

(Reorder tone is summed with data on Rx stream 00 at volume level -3dBm0)  

16 06 1B 03 00 08  

(Reorder dial tone replaces the voice on Rx stream 00 at volume level -6dBm0)  

16 06 1B 83 00 10

(Audible Ringing tone is summed with data on Rx stream 00 at volume  

level -3dBm0)  

16 06 1B 04 00 08  

(Audible Ringing tone replaces the voice on Rx stream 00 at volume level -6dBm0)  

16 06 1B 84 00 10

(Stream based tone ID 06 is summed with data on Rx stream 00 at volume  

level -3dBm0;  

Tone ID 06 is downloaded using both the frequency and cadence down  

load commands)  

16 06 1B 06 00 08  

(Stream based tone ID 06 replaces the voice on Rx stream 00 at volume  

level -6dBm0)  

16 06 1B 86 00 10

(Stream based tone ID 0F is summed with data on Rx stream 00 at volume  

level -3dBm0;  

Tone ID 0x0F is downloaded using both the frequency and cadence down  

load commands)  

16 06 1B 0F 00 08  

(Stream based tone ID 0F replaces the voice on Rx stream 00 at volume  

level -6dBm0)  

16 06 1B 8F 00 10

Stream Based Tone Off  

(16 05 1C xx xx)  

(Dial tone is turned off on Rx stream 00)  

16 05 1C 00 00  

(Dial tone is turned off on Tx stream 00)  

16 05 1C 40 00  

(Line busy tone is turned off on Rx stream 00)  

16 05 1C 02 00  

(Line busy tone is turned off on Tx stream 00)  

16 05 1C 42 00  

(ROH tone is turned off on Rx stream 00)  

16 05 1C 05 00  

(ROH tone is turned off on Tx stream 00)  

16 05 1C 45 00  

(Recall dial tone is turned off on Rx stream 00)  

16 05 1C 01 00  

(Reorder tone is turned off on Rx stream 00)  

16 05 1C 03 00  

(Audible Ringing tone is turned off on Rx stream 00)  

16 05 1C 04 00  

(Stream based tone ID 06 is turned off on Rx stream 00)  

16 05 1C 06 00  

(Stream based tone ID 0F is turned off on Rx stream 00)  

16 05 1C 0F 00

Stream Based Tone Frequency Component List Download (up to 4  

frequencies can be specified)  

(16 xx 1D xx...)  

Note: Frequency component download and cadence download commands sent  

to the i2004 first.  

Then send the stream based tone ID on command to verify that tones are  

turned on.  

16 06 1D 06 2C CC  

(1400Hz )  

16 08 1D 07 2C CC 48 51  

(1400 Hz and 2250Hz)

Stream Based Tone Cadence Download (up to 4 cadences can be specified)  

(16 xx 1E xx...)  

Note: Frequency component download and cadence download commands sent  

to the i2004 first. Then  

send the stream based tone ID on command to verify that tones are turned on.  

16 06 1E 26 0A 0A  

(200 ms on and 200 ms off with tone turned off after the full sequence)  

16 08 1E 07 0A 0A 14 14  

(20 ms on and 20 ms off for first cycle, 400 ms on and 400 ms off fo  

rthe second cycle with sequence repeated)  

16 05 1E 26 0A  

(In this case tone off period is not specified hence tone is played  

until stream based  

tone off command is received.

Select Adjustable Rx Volume  

(16 04 20 xx)  

16 04 20 01  

(Audio parameter block 1)  

16 04 20 03  

(Audio parameter block 3)  

16 04 20 08  

(Alerting Rx volume)  

16 04 20 09  

(Special tone Rx volume)  

16 04 20 0a  

(Paging tone Rx volume)

Set APB's Rx Volume Levels  

(16 05 21 xx xx)  

16 05 21 01 25  

(? Rx volume level 5 steps louder than System RLR)  

16 05 21 01 05  

(? Rx volume level 5 steps quieter than System RLR)

Change Adjustable Rx Volume  

16 03 22  

(Rx volume level is one step quieter for the APB/tones selected  

through Select Adjustable Rx Volume command)  

16 03 23  

(Rx volume level is one step louder for the APB/tones selected through  

Select Adjustable Rx Volume command)

Adjust Default Rx Volume  

(16 04 24 xx)  

16 04 24 01  

(Default Rx volume level is one step quieter for the APB 1)  

16 04 25 01  

(Default Rx volume level is one step louder for the APB 1)

Adjust APB's Tx and/or STMR Volume Level  

(16 04 26 xx)  

(First ensure that the Tx and STMR volume level are set to maximum by  

repeatedly (if needed) sending the command  

16 04 26 F2 to APB2.  

Rest of the commands are sent to i2004 individually and then the query  

command below is used to verify  

if the commands are sent correctly) (Enable both Tx Vol adj. and STMR  

adj; Both Tx volume and STMR volume  

are one step louder on APB 2)  

16 04 26 F2  

(Enable both Tx Vol adj. and STMR adj; Both Tx volume and STMR volume  

are one step quieter on APB 2)  

16 04 26 A2  

(Enable Tx Vol adj. and disable STMR adj; Tx volume is one step louder  

on APB 3)  

16 04 26 C3  

(Enable Tx Vol adj. and disable STMR adj; Tx volume is one step  

quieter on APB 3)  

16 04 26 83  

(Disable both Tx Vol adj. and STMR adj on APB 1)  

16 04 26 01

Query APB's Tx and/or STMR Volume Level  

(16 04 27 XX)  

(Query Tx volume level and STMR volume level on APB 2)  

16 04 27 32  

(Query STMR volume level on APB 1)  

16 04 27 11  

(Query STMR volume level on APB 2)  

16 04 27 12  

(Query STMR volume level on APB 3)  

16 04 27 13  

(Query Tx volume level on APB 1)  

16 04 27 21  

(Query Tx volume level on APB 2)  

16 04 27 22  

(Query Tx volume level on APB 3)  

16 04 27 23

APB Download  

(16 xx-1F xx...)  

16 09 28 FF AA 88 03 00 00

Open Audio Stream  

(16 xx 30 xx...)  

(If Audio stream is already open it has to be closed before another  

open audio stream command is sent)  

16 15 30 00 00 00 00 01 00 13 89 00 00 13 89 00 00 2F 81 1F 23  

(Open G711 ulaw Audio stream to 2F.81.1F.9F)  

16 15 30 00 00 08 08 01 00 13 89 00 00 13 89 00 00 2F 81 1F 23  

(Open G711 Alaw Audio stream to 2F.81.1F.9F)  

16 15 30 00 00 12 12 01 00 13 89 00 00 13 89 00 00 2F 81 1F 23  

(Open G729 Audio stream to 2F.81.1F.9F)  

16 15 30 00 00 04 04 01 00 13 89 00 00 13 89 00 00 2F 81 1F 23  

(Open G723? ulaw Audio stream to 2F.81.1F.9F)

Close Audio Stream  

(16 05 31 xx xx)  

16 05 31 00 00

Connect Transducer  

(16 06 32 xx xx xx)  

16 06 32 C0 11 00  

(Connect the set in Handset mode with no side tone)  

16 06 32 C0 01 00  

(Connect the set in Handset mode with side tone)  

16 06 32 C1 12 00  

(Connect the set in Headset mode with no side tone)  

16 06 32 C1 02 00  

(Connect the set in Headset mode with side tone)  

16 06 32 C2 03 00  

(Connect the set in Hands free mode)

Frequency Response Specification  

(16 xx 33 xx...)  

Filter Block Download 16 xx 39 xx  

Voice Switching debug 16 04 35 11  

(Full Tx, Disable switch loss bit)  

16 04 35 12  

(Full Rx, Disable switch loss bit)  

Voice Switching Parameter Download 16 08 36 01 2D 00 00 02  

(APB 1, AGC threshold index 0, Rx virtual pad 0, Tx virtual pad 0,  

dynamic side tone enabled)  

Query RTCP Statistics 16 04 37 12  

(queries RTCP bucket 2, resets RTCP bucket info.)  

Configure Vocoder Parameters 16 0A 38 00 00 CB 00 E0 00 A0  

(For G711 ulaw 20 ms, NB)  

16 0A 38 00 08 CB 00 E0 00 A0  

(G711 Alaw 20 ms, NB)  

16 0A 38 00 00 CB 01 E0 00 A0  

(For G711 ulaw 10 ms, WB)  

16 0A 38 00 08 CB 01 E0 00 A0  

(G711 Alaw 10 ms, WB)  

16 08 38 00 12 C1 C7 C5  

(For G729 VAD On, High Pass Filter Enabled, Post Filter Enabled)  

16 09 38 00 04 C9 C5 C7 C1  

(G723 VAD On, High Pass Filter Enabled, Post Filter Enabled at 5.3 KHz)  

16 09 38 00 04 C0 C7 C5 C9  

(G723 VAD Off, High Pass Filter Enabled, Post Filter Enabled at 5.3 KHz)  

16 09 38 00 04 C1 C5 C7 C8  

(G723 VAD On, High Pass Filter Enabled, Post Filter Enabled at 6.3 KHz)  

16 09 38 00 04 C0 C7 C5 C8  

(G723 VAD Off, High Pass Filter Enabled, Post Filter Enabled at 6.3 KHz)  

Query RTCP Bucket's SDES Information (39 XX) (The first nibble in the  

last byte indicates the bucket ID)  

16 04 39 21  

16 04 39 22  

16 04 39 23  

16 04 39 24  

16 04 39 25  

16 04 39 26  

16 04 39 27

16 04 39 01  

16 04 39 12  

16 04 39 23  

16 04 39 34  

16 04 39 45  

16 04 39 56  

16 04 39 67
