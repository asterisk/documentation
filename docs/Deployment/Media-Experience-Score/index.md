---
title: Media Experience Score
pageid: 46760069
---

When one thinks of measuring call quality a [Mean Opinion Score](https://en.wikipedia.org/wiki/Mean_opinion_score) (MOS) is usually the first thing that comes to mind. However, calculating a true MOS inherently involves, and relies upon human perception and judgement. Thus when it comes to determining the call quality in Asterisk only an approximation can be achieved since it can only depend upon relevant statistics. And for that reason we'll call it a "Media Experience Score" instead.

## Relevant Statistics

What are these relevant statistics? To start, and in order to keep things simple there are three obvious choices all computed by Asterisk and defined in RFC: [RTP: A Transport Protocol for Real-Time Applications](https://www.rfc-editor.org/rfc/rfc3550#section-6.4.1)

* Round Trip Time (RTT)
* Jitter
* Packets Lost

As one may note, these statistics all relate to network conditions, and connectivity. They do not give any indication as to the state of the actual media within a packet. That level of inspection, and analysis is currently outside our current scope. However, media via RTP can be greatly affected by the network state. Things like packet loss, or a delay in delivery translate to degraded media quality for the end user. In fact by combining the mentioned statistics into an appropriate calculation one can claim a confident opinion about the quality of an end user’s media experience.

## Forming an Opinion

Luckily there has already been a lot of study, and analysis done on this topic, and some of it is even standardized ([ITU-T](https://www.itu.int/en/ITU-T/)). While a large portion of that of course concerns calculating an actual MOS, it gives us a starting point. As well others have already taken such ideas and applied them to assessing the media experience based on gathered RTP statistics. Since there is no reason to reinvent the wheel here we’ll base our algorithm for calculating a user’s media experience on the aforementioned evaluations by ITU-T ([G.107](https://www.itu.int/rec/T-REC-G.107), [G.109](https://www.itu.int/rec/T-REC-G.109), [G.113](https://www.itu.int/rec/T-REC-G.113)), and from other various internet sources.

We’ll be reducing a given transmission rating factor, or ‘R’ value for short, based on the gathered relevant statistical data. That final ‘R’ value will then be fed into a standardized formula for deriving an opinion score. An ‘R’ value has a final range of 0 (worst) to 100 (best). However for our purposes we’ll be using defaults, which gives us a starting ‘R’ value of 93.2 (see [ITU-T G.107](https://www.itu.int/rec/T-REC-G.107) for more details).

Let’s start with latency. Depending on the situation the media itself may or may not be affected by late arriving packets, but the overall user experience may suffer. For example, If you’re on a VOIP call and audio is delayed by a second it makes it harder to have a conversation. As well if packets arrive out of order, and no jitter buffer is enabled that too will make for an unpleasant experience. To that end we can compute an “effective latency” (in milliseconds), and reduce the ‘R’ value accordingly:

```text
Effective Latency = Average Round Trip Time + Average Jitter \* 2 \* (Jitter Standard Deviation / 3) + Codec Delay
If Effective Latency < 160: R = 93.2 - (Effective Latency / 40)
Else: R = 93.2 - (Effective Latency - 120) / 10
```

Multiplying the jitter, and factoring in its standard deviation adds to its “weight” in the calculation as it seems the higher the standard deviation the worse the media experience. Codec Delay could be set for each codec type, otherwise a value of 10 is probably sufficient for our purposes. If the Effective Latency is less than 160ms be conservative in reducing the ‘R’ value. Otherwise, be a little more aggressive in the ‘R’ value reduction since latency over 160 causes noticeable “lag”.

Next up is packet loss. If anything is going to have a known effect on media quality it’s packet loss. Again we can further reduce the ‘R’ value according to average number of packets lost since the last report:

```text
R = R - Packets Lost \* 2.5
```

/// note
With the exception of the starting ‘R’ value of 93.2 most all the other numbers and factors can
be tweaked, if needed, based on further testing or other recommendations.
///

All that is needed to do now is convert the ‘R’ value into an “opinion score”. That can be done using a standardized formula (see [ITU-T G.107](https://www.itu.int/rec/T-REC-G.107) Annex B):

```text
If R < 0: Opinion = 1
Else if R > 100: Opinion = 4.5
Else: Opinion = 1 + (0.035 \* R) + (R \* (R - 60) \* (100 - R) \* 0.0000007);
```

## In Asterisk

An RTP instance in Asterisk keeps a running average for the round trip time, the average jitter between an endpoint (sender) and Asterisk (receiver), the standard deviation for jitter, and packet loss. For data pertaining to the link from Asterisk (sender) to the endpoint (receiver) the instance also tracks the reported (from RTCP) jitter, its standard deviation, and the reported packet loss.

Given that an RTP instance calculates and/or collects the required data for both incoming and outgoing packets means we should be able to arrive at a media experience score about each. That also means that for an actual call between Alice and Bob up to 4 scores can be derived. That is somewhat granular, so depending we may want to average those scores together to give a singular overall media experience score.

## Future Improvements

We start with an ‘R’ value of 93.2 based on the default recommendations found in [ITU-T G.107](https://www.itu.int/rec/T-REC-G.107) (Section 7.7) because we are restricted in our dataset(s). However, it’s possible that for some specific codecs along with a deep packet inspection of the actual media some ‘R’ value parameters could be adjusted. Of course the latter inspection could be quite intrusive and inefficient.

‘R’ value’s equipment impairment factor too could be further looked into. If Asterisk could determine the type of packet loss (burst vs intermittent) the final ‘R’ value could become more accurate. As well, one could factor in the codec in current use and its ability to handle packet loss. For instance, codec opus is probably better at handling packet loss than codec alaw.

Lastly, the advantage factor ‘A’ could be increased based on knowledge of the endpoint. For instance, if the endpoint is known to be a mobile phone the parameter could be bumped to between 5 to 10.
