---
layout: post
title: BufferUntilCalm method for C#'s Reactive Extensions
comments: true
categories: programming csharp
---

The curiously-named [Reactive Extensions](http://msdn.microsoft.com/en-us/data/gg577609) is a .NET library that lets you work with _streams of events_ as first-class objects.

> The Reactive Extensions (Rx) is a library for composing asynchronous and event-based programs using observable sequences and LINQ-style query operators. Using Rx, developers represent asynchronous data streams with Observables, query asynchronous data streams using LINQ operators, and parameterize the concurrency in the asynchronous data streams using Schedulers. Simply put, Rx = Observables + LINQ + Schedulers.

For example, once you have an Observable, that is, a stream of events, you can query it with LINQ extension methods (these return new streams):

    stream.Where(condition)
    stream.GroupBy(selector)
    stream.Count()    

Reactive Extensions with other upcoming [parallel and asynchronous features](http://blogs.msdn.com/b/pfxteam/archive/2011/09/17/10212961.aspx) in the spuriously-versioned .NET framework 4.5. Alas, Reactive Extensions hasn't been adopted widely yet, perhaps only because it isn't understood. The official documentation explains in academic language:

> The IObservable interface is a dual of the familiar IEnumerable interface.

Regardless, it's great stuff. Here's how I've used Reactive Extensions. I have a tool that watches a folder for new files and emails me about them. It subscribes to filesystem events with a .NET FileSystemWatcher. To save my inbox, I want less than one email per new file, so I'll batch events together. How do I batch them? I could batch events until I reach a limit in number, say into groups of ten, but then it's possible I might not hear about a new file for days. Instead I'll do this - batch events until there's a half hour period of calm, and then send the email. This means the events might even be grouped logically. But I'd best add a numerical limit in case there's no respite in events.

Before Reactive Extensions I solved this with a complicated system of .NET Timers. 

With Reactive Extensions, the solution is much simpler. There isn't a function in the standard library that does what I want, but the functions `Window`, `Throttle` and `Delay` are enough to define it.

I'm sharing this because there a [few](http://stackoverflow.com/questions/7597773/does-reactive-extensions-support-rolling-buffers/9791385#9791385) [posts](http://stackoverflow.com/questions/8849810/reactive-throttle-returning-all-items-added-within-the-timespan/9791918#9791918) on Stack Overflow looking to solve the same problem. Names differ - rolling buffers, buffer with inactivity, sliding buffers. I call my method _buffer until calm_. Help yourself to it.

{% gist 2277055 %}

    public static class ObservableExtensions
    {
        /// <summary>
        /// Group observable sequence into buffers separated by periods of calm
        /// </summary>
        /// <param name="source">Observable to buffer</param>
        /// <param name="calmDuration">Duration of calm after which to close buffer</param>
        /// <param name="maxCount">Max size to buffer before returning</param>
        /// <param name="maxDuration">Max duration to buffer before returning</param>
        public static IObservable<IList<T>> BufferUntilCalm<T>(this IObservable<T> source, TimeSpan calmDuration, Int32? maxCount=null, TimeSpan? maxDuration = null)
        {
            var closes = source.Throttle(calmDuration);
            if (maxCount != null)
            {
                var overflows = source.Where((x,index) => index+1 >= maxCount);
                closes = closes.Amb(overflows);
            }
            if (maxDuration != null)
            {
                var ages = source.Delay(maxDuration.Value);
                closes = closes.Amb(ages);
            }
            return source.Window(() => closes).SelectMany(window => window.ToList());
        }
    }
    