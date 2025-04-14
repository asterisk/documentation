---
search:
  boost: 0.2
title: Vendor-Specific Features
pageid: 22088009
---

Overview
========

Over the years, vendor specific features have been added to Asterisk. Many of these have caused additional maintenance effort for the project, which results in fewer resources available for features and improvements that benefit all users. In order to address this, the following guidelines, which stand in addition to the guidelines regarding the [New Feature Guidelines](/Development/Policies-and-Procedures/Historical-Policies-and-Procedures/Patch-Contribution-Process/New-Feature-Guidelines), have been established.

Will the feature be added?
--------------------------

In many cases, vendors want to add new code to Asterisk to provide compatibility with the vendors' products, to make the vendors' products more easy to use with Asterisk, or to provide some special feature, that is enabled by the product, to Asterisk. Before any vendor code is added to Asterisk, the following points are considered:

* Does the code implement a standard (RFC XYZ or ITU specification A.BCD), is it related to Asterisk's normal function, does it have specific momentum and is it already implemented by a number of other vendors?
* Is the code such that it provides a tangible improvement to Asterisk for users who aren't using the vendor's product?
* Most importantly, has the vendor demonstrated a long record of maintaining and improving Asterisk for users that do and do not buy their products?
	+ It is essential that vendors submitting features or patches for commercial purposes have a clear history of adding more value to the overall project than they extract in commercial benefit.

If the answer is **Yes** to **all** of the above questions, then the feature may be appropriate for Asterisk. A **No** to **any** of the above questions means that the feature may not be appropriate for Asterisk.

In an ideal scenario, the code implements a standard new to Asterisk (e.g. RFC XYZ, that is already implemented by a number of vendors), also provides utility for users who didn't buy the company's product, and comes from a vendor that has a long history of maintaining and improving Asterisk for their own users as well as users who didn't buy the vendor's products.

In unfavorable scenarios, the code does not implement a standard because it's specific to the vendor's product, does not provide tangible and useful utility to users of Asterisk who do not use the vendor's product, or is submitted by a vendor that does not have a long history of maintaining and improving Asterisk for their own users as well as users who didn't buy the vendor's products.

Who decides?
------------

As the primary contributor, maintainer and sponsor of Asterisk, as well as the company entrusted with ensuring the ongoing well-being of Asterisk, which includes fostering commercial companies' participation in the development of Asterisk, the final decision to include a vendor specific feature rests with Digium.
