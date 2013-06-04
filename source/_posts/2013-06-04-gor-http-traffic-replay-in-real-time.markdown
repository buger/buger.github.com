---
layout: post
title: "Gor - replay HTTP traffic in real-time"
subtitle: "Use staging wisely"
date: 2013-06-04 08:10
comments: true
categories: 
---

*TL;DR The more realistic test data, the better. I wrote **[Gor](https://github.com/buger/gor/)** - automated real-time http traffic replay solution that can forward part of your production traffic to staging or anywhere you want, and rate-limit it if needed*

Here at [Granify](http://granify.com) we work with LOT of user generated data, our business build on it. So main priority is to ensure that we collecting and processing it right.

You can't imagine how weird can be user input; it can be caused by a lot of reasons: proxies, browsers you never heard of, your client side bugs, and much more. 

{% blockquote %}
No matter how many tests and fixtures you have, they just can't cover all cases. Production traffic always differs from planned. 
{% endblockquote%}

More over you can just broke everything while deploying a new version, even if tests pass. This happen constantly.

There is a whole layer of errors that just can't be easily find via automated  and manual testing. Concurrency, server environment specific bugs, some bugs can occur from requests called in a particular order, and etc. 

We can do a few thing to ease finding such bugs improve overall stability:

## Testing on staging first

[Staging](http://en.wikipedia.org/wiki/Staging_site) environment is mandatory, and it <b>should</b> be identical to production. Using tools like [Puppet](http://puppetlabs.com/) or [Chief](http://www.opscode.com/chef/) helps a lot.

You should require developers manually test all code on staging.

This helps to find most obvious bugs, but it's far from what you can get on production.


## Testing on production data

There are few technics to do this (better to use both):

1. Deploying changes only to one of production servers, so part of users will be served by the new code. This technic has some downsides. Some of your users can see errors/bugs, and maybe you have to use "stick" sessions. This is quite similar to A/B testing.

2. Replaying production traffic to staging environment.

Ilya Grigorik wrote a nice article on this: [Load Testing With Log Replay](http://www.igvita.com/2008/09/30/load-testing-with-log-replay)

In all articles i read Log replay technic mostly mentioned in the context of load testing. I want to show how use it for automated bug testing. 

Tools like [jMeter](http://jmeter.apache.org/), [httperf](https://code.google.com/p/httperf/) or [Tsung](http://tsung.erlang-projects.org/) have support for replaying logs, but it's very rudimentary or focus on load testing and not emulating real-users. Feel the difference? Real users not just list of requests, they have proper timing between requests, different http headers and etc. For load testing, it does not matter, but for bug testing matter a lot.

Plus this tools require action and complex configuration to be run.  

{% blockquote %}
Developers are lazy. If you want your developers to use your tool/service it should be automated as much as possible, better that if nobody notice it at all.
{% endblockquote %}

Thats why we invented CI, automatic server configuration tools (Puppet, Chief, Fabric), EC2, and etc. 


## Automating Log replay

I wrote a simple tool [Gor](https://github.com/buger/gor/)

Gor allows you automatically replicate traffic from production to staging (or anywhere you want) in real-time, 24 hours a day, with minimal effort. So your staging environment always gets part of production traffic. 

Gor consists of 2 parts: Listener and Replay server. You should install Listener on production web servers, and Replay server on a separate machine, that will forward traffic to given address. I just put this diagram:

![Diagram](https://a248.e.akamai.net/camo.github.com/c802ae10dfd1b0b2519c5726eedad31bac18c0f6/687474703a2f2f692e696d6775722e636f6d2f7a5a43465043592e706e67)

**Gor support rate limiting**. It is very important feature since staging environment usually use fewer servers than production, and you want to set maximum requests per second that staging can handle. 

You can find all needed info on project [Github](https://github.com/buger/gor/) page.

Since Gor written in Go, everything is statically linked, and you can just download binaries from this link [Downloads](https://drive.google.com/folderview?id=0B46uay48NwcfWFowc1E4a1BISVU&usp=sharing)

At [Granify](http://granify.com), we use it on production for some time, and very happy with results. 

Happy testing!


____

You can discuss this post at [Hacker News](https://news.ycombinator.com/item?id=5820338)