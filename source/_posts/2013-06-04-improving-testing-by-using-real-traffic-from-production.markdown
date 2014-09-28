---
layout: post
title: "Improving testing by using real traffic from production"
subtitle: "Use staging wisely"
date: 2013-06-04 08:10
comments: true
categories: 
---

*TL;DR The more realistic your test data, the better. I wrote **[Gor](https://github.com/buger/gor/)** - an automated real-time http traffic replay solution that can forward part of your production traffic to staging or anywhere you want, and rate-limit it if needed*

Here at [Granify](http://granify.com) we work with a LOT of user generated data, our business is build on it. So our main priority is to ensure that we are collecting and processing it right.

You can't imagine how weird user input can be; oddities come from many sources---proxies, browsers you've never heard of, client side bugs, and much more.

{% blockquote %}
No matter how many tests and fixtures you have, they just can't cover all cases. Production traffic always differs from your expectations. 
{% endblockquote%}

Moreover, you can just break everything when deploying a new version, even if tests pass. This happens constantly.

There is a whole layer of errors that just can't be easily found via automated  and manual testing: concurrency, server environment specific bugs, some bugs can occur from requests called in a particular order, and etc. 

We can do a few thing to make finding such bugs easier and improve overall stability:

## Testing on staging first

[Staging](http://en.wikipedia.org/wiki/Staging_site) environment is mandatory, and it <b>should</b> be identical to production. Using tools like [Puppet](http://puppetlabs.com/) or [Chief](http://www.opscode.com/chef/) helps a lot.

You should require developers manually test all code on staging.

This helps you to find most obvious bugs, but it's far from what you can get on production.


## Testing on production data

There are a few techniques to do this (better to use both):

1. Deploying changes only to one of production servers, so part of users will be served by the new code. This technique has some downsides. Some of your users will see errors/bugs, and you may have to use "sticky" sessions. This is quite similar to A/B testing.

2. Replaying production traffic to staging environment.

Ilya Grigorik wrote a nice article on this: [Load Testing With Log Replay](http://www.igvita.com/2008/09/30/load-testing-with-log-replay)

In all articles I've read, log replay techniques are mostly mentioned in the context of load testing. I want to show you how to use log replay for daily bug testing. 

Tools like [jMeter](http://jmeter.apache.org/), [httperf](https://code.google.com/p/httperf/) or [Tsung](http://tsung.erlang-projects.org/) have support for replaying logs, but it's very rudimentary or focused on load testing and not emulating real-users. Feel the difference? Real users are not just a list of requests, they have proper timing between requests, different http headers etc. For load testing, it does not matter, but for bug testing it matters a lot.

Plus these tools require action and complex configuration to run.  

{% blockquote %}
Developers are lazy. If you want your developers to use your tool/service it should be automated as much as possible, it's best if no one notices it at all.
{% endblockquote %}

Thats why we invented CI, automatic server configuration tools (Puppet, Chief, Fabric), EC2, and etc. 


## Automating Log replay

I wrote a simple tool [Gor](https://github.com/buger/gor/)

Gor allows you to automatically replicate traffic from production to staging (or anywhere you want) in real-time, 24 hours a day, with minimal effort. So your staging environment always gets part of production traffic. 

Gor consists of 2 parts: Listener and Replay server. You should install Listener on your production web servers, and Replay server on a separate machine that will forward traffic to given address. The data flow is shown in the following diagram::

![Diagram](https://camo.githubusercontent.com/556d4aa5db32de9535d84d6c6c07f6564b43fc0b/687474703a2f2f692e696d6775722e636f6d2f396d716a32534b2e706e67)

**Gor supports rate limiting**. This is a very important feature since staging environment usually uses fewer servers than production, and you'll want to set maximum requests per second that staging can handle. 

You can find all needed info on project [Github](https://github.com/buger/gor/) page.

Since Gor is written in Go, everything is statically linked, so you can just download binaries from this link: [Downloads](https://drive.google.com/folderview?id=0B46uay48NwcfWFowc1E4a1BISVU&usp=sharing)

At [Granify](http://granify.com), we use it on production for some time, and we are very happy with the results. 

Happy testing!

____

You can discuss this post at [Hacker News](https://news.ycombinator.com/item?id=5824387)