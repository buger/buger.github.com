---
layout: post
title: "Open letter to Airbrake.io"
date: 2012-11-20 13:26
comments: false
categories: bugtracking, airbrake
---

{% blockquote %}
TL;DR

If you provide solution for such critical development parts as error tracking, you should work all the time.
{% endblockquote %}


Imagine that your site is down, you get lot of error, your business loses money. What can make you more angry? Oh, i say: when debug tool you rely on says that you reach limit of errors per minute, and just shows nothing, except this message. When you have multiple servers with multiple apps, digging through logs for errors without tool above becomes real pain. 

Our load only about 30r/s, let's imagine that something bad happened and  20 of this requests throwing errors. It will immediately reach your limits even on most expensive plan ( 1200 errors/minute - $999), so **upgrading account will not help**. And when you reach this limit, even if you fixed it in 15 minutes, you will get paralyzed for full day. I really want to give you my money, just give me reason.


### Suggestion for Airbrake team:

* use soft limits, allow bursting. Just stopping working until user will upgrade plan (it will not help, ha ha), is not solution.

* even if limit reached, you should allow view at least 1 error of each type, you can just disable some of functionality like similar errors.


It's a great product, i can see amazing insights, and it helps a lot during development. But it just did't work when it is most needed.

**When shit happens we loosing more value than you provide.**

### Lessons learned

Do not trust such important parts as debugging to external solution, always have plan B.


-----
You can discuss this post at [Hacker News](http://news.ycombinator.com/item?id=4808539)






