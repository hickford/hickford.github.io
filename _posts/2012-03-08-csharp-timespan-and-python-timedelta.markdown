---
layout: post
title: .NET's TimeSpan and Python's timedelta
comments: true
category: programming
---

# {{page.title}}

For a while I’ve been frustrated by .NET’s System.TimeSpan and its incoherent constructors. Without referring to [MSDN][1], can you tell me what these three objects describe?
 
    new TimeSpan(0,0,1)       
    new TimeSpan(0,0,1,0)       // appending a zero
    new TimeSpan(0,0,1,0,0)     // appending another zero
 
It happens the first two both describe one second but the third describes one _microsecond_!
 
Since then I found the static methods `TimeSpan.FromHours` and `TimeSpan.FromMinutes`, which are much more readable. It’s still a tad tedious to write ‘one hour and thirty five minutes’:
 
    TimeSpan.FromHours(1)+TimeSpan.FromMinutes(35)
 
I’m fond of Python’s timedelta, which lets you write:
 
    from datetime import timedelta
    timedelta(hours=1,minutes=35)
 
You can understand that without reading any [Python documentation][2].
 
Inspired, and using C# 4’s [optional parameters][3], I wrote the missing method:
 
    public static class TimeSpanExtensions
    {
        // <summary>
        // Returns a Timespan initialized to the specified number of weeks, days, hours, minutes, seconds, and milliseconds.
        // </summary>
        public static TimeSpan TimeDelta(int weeks=0, int days=0, int hours=0, int minutes=0, int seconds=0, int milliseconds=0)
        {
            // Initializes a new TimeSpan to a specified number of days, hours, minutes, seconds, and milliseconds.
            return new TimeSpan(weeks*7+days,hours,minutes,seconds,milliseconds);
        }
    }
 
Now we can write the instantly readable:
 
   TimeDelta(hours:1,minutes:30)
 
That makes me very happy.
 
[1]: http://msdn.microsoft.com/en-us/library/system.timespan.aspx
[2]: http://docs.python.org/library/datetime.html#timedelta-objects
[3]: http://msdn.microsoft.com/en-us/library/dd264739.aspx
