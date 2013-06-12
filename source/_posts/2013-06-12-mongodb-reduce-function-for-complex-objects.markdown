---
layout: post
title: "MongoDB reduce function for complex objects"
date: 2013-06-12 14:03
comments: true
categories: 
---

[We](http://granify.com) using MongoDB map/reduce functionality for generating various near-realtime stats. 
I know almost no one likes it, but it can be very handy if used properly (analyzing only objects in working set, e.g in RAM). 

Here is useful reduce function that I'm using almost in all map/reduce calls.

[Gist](https://gist.github.com/buger/5765417)
```javascript
// Universal MongoDB reduce function for complex objects
// 
// Example:
//    
//    emit({ total_views: 3, page_type: {home: 1, product: 2}, site_id: [1] })
//    emit({ total_views: 5, page_type: {home: 1, collection: 4}, site_id: [2] })
//    
//    -> reduce
//    
//    { total_views: 8, page_type: { home: 2, product: 2, collection: 4 }, site_id: [1,2] }
// 
function(key, values){
  var result = {}
 
  var merge_obj = function(from, to){
    for (key in from) {
      if (Object.prototype.toString.call(from[key]) == "[object Object]") {
        if (!to[key])
          to[key] = {}
 
        merge_hash(from[key], to[key])
      } else if (Object.prototype.toString.call(from[key]) == "[object Array]") {
        if (!to[key])
          to[key] = []
 
        to[key].push(from[key])
      } else {
        if (!to[key])
          to[key] = 0
 
        to[key] += from[key]
      }
    }
  }
 
  values.forEach(function(value){
    merge_obj(value, result)
  })
 
  return result
}
```