What AMQP gem is
================

Simple asynchronous AMQP driver for Ruby/EventMachine
This library works with Ruby 1.8, Ruby 1.9, JRuby and Rubinius,
and is licensed under [the Ruby License](http://www.ruby-lang.org/en/LICENSE.txt).

This library was tested primarily with RabbitMQ, although it should be compatible with any
server implementing the [AMQP 0-8 spec](http://www.amqp.org/confluence/download/attachments/720900/amqp0-8.pdf).


This fork of AMQP
=================

Intention is to describe AMQP lib behavior using RSpec, with reasonable level of completeness.
Given a solid spec suite, it will be easier to expand the library going forward.

Some improvements that are currently merged in, but not yet fully specified:

 * Support for setting extended headers in MQ::Exchange#publish. Particularly useful for :reply_to for RPC.
 * Multibyte character support (Ruby 1.9) in MQ::Exchange#publish.
 * MQ::Exchange#publish raises error if no connection to broker.
 * MQ::Queue only wraps headers with new MQ::Headers if they are not nil. This allows pops to tell more easily when they've requested a message from an empty queue. See (https://github.com/tmm1/amqp/issues#issue/22)
 * Support for receiving Headers with zero-size data packets. Such contents with no body frames are totally legit if indicated header size is zero.

Some improvements that are planned:
 * Support for AMQP::Protocol::Basic::Return method. See (https://github.com/tmm1/amqp/issues#issue/1).

Getting started
===============

First things first, start with:

  $ gem install arvicco-amqp

To use examples with RabbitMQ, first [install the broker](http://www.rabbitmq.com/install.html).

Then have a look at the various bundled examples:

    ruby examples/mq/pingpong.rb   # 1-1 communication using amq.direct
    ruby examples/mq/clock.rb      # 1-N communication using amq.fanout
    ruby examples/mq/stocks.rb     # 1-subscriber communication using amq.topic

    ruby examples/mq/multiclock.rb # header based routing (new rabbitmq feature)
    ruby examples/mq/ack.rb        # using ack
    ruby examples/mq/pop.rb        # pop off messages one at a time

    ruby examples/mq/hashtable.rb  # simple async rpc layer
    ruby examples/mq/primes.rb 4   # parallelized prime number generation
    ruby examples/mq/logger.rb     # simple logging api

For high level API documentation see MQ class.
For more details into the lower level AMQP client API, run the simple client example:

    ruby examples/amqp/simple.rb   # low-level AMQP api
    ruby examples/mq/internal.rb   # low-level Queue/Exchange api

Or refer to protocol/doc.txt, which enumerates packets sent between a server and client
during a typical session, in both binary and decoded formats.

How to use AMQP gem with Ruby on Rails, Merb, Sinatra and other web frameworks
==============================================================================

To use AMQP gem from web applications, you would need to have EventMachine reactor running.
If you use [Thin](http://code.macournoyer.com/thin/), you are set: Thin uses EventMachine under
the hook.

With other web servers, you need to start EventMachine reactor in it's own thread like this:

    Thread.new { EM.run }

because otherwise EventMachine will block current thread. Then connect to AMQP broker:

    AMQP.connect(:host => "localhost", :user => "guest", :pass => "guest", :vhost => "/")

In a Ruby on Rails app, probably the best place for this code is initializer
(like config/initializers/amqp.rb). For Merb apps, it is config/init.rb. For
Sinatra and pure Rack applications, place it next to other configuration
code.

Same separate thread technique can be used to make EventMachine play nicely with other
libraries that would block current thread (like [File::Tail](http://rubygems.org/gems/file-tail)).

AMQP gem resources
==================

* [AMQP gem mailing list](http://groups.google.com/group/ruby-amqp)
* [AMQP gem at GitHub](http://github.com/tmm1/amqp)
* [AMQP gem at Rubygems](http://rubygems.org/gems/amqp)
* [This fork at GitHub](http://github.com/arvicco/amqp)
* [This fork as a gem at Rubygems](http://rubygems.org/gems/arvicco-amqp)

Running specifications suite
============================

To run the test suite make sure you have [Rspec2](http://gemcutter.org/gems/rspec) gem installed and run:

    rake spec

The lib/amqp/spec.rb file is generated automatically based on the [AMQP specification](http://www.amqp.org/confluence/display/AMQP/AMQP+Specification). To generate it:

    rake codegen

Writing your own AMQP/evented specs
===================================

Writing evented specs properly is a bit difficult due to gory details of event loop management. Libraries such as
[AMQP-Spec](http://github.com/arvicco/amqp-spec) and [Moqueue](https://github.com/danielsdeleo/moqueue) may be helpful.


Credits and more information
============================

(c) 2008—2010 [Aman Gupta](http://github.com/tmm1) (tmm1)

This project was inspired by [py-amqplib](http://barryp.org/software/py-amqplib/), [rabbitmq](http://rabbitmq.com), [qpid](http://qpid.apache.org/) and [rubbyt](http://github.com/rubbyt/rubbyt).
Special thanks to Dmitriy Samovskiy, Ben Hood and Tony Garnock-Jones.

AMQP brokers
------------

 * [RabbitMQ](http://rabbitmq.com) (Rabbit Technologies, Erlang/OTP, MPL)
 * [ZeroMQ](http://www.zeromq.org) (iMatix/FastMQ/Intel, C++, GPL3)
 * [OpenAMQ](http://openamq.org) (iMatix, C, GPL2)
 * [ActiveMQ](http://activemq.apache.org) (Apache Foundation, Java, Apache2)

AMQP resources
--------------

 * Steve Vinoski [explains AMQP](http://steve.vinoski.net/pdf/IEEE-Advanced_Message_Queuing_Protocol.pdf) in his column, Towards Integration

 * John O'Hara on [the history of AMQP](http://www.acmqueue.org/modules.php?name=Content&pa=showpage&pid=485)

 * Dmitriy's [presentation on RabbitMQ/AMQP](http://somic-org.homelinux.org/blog/2008/07/31/slides-for-my-amqprabbitmq-talk/)

 * ZeroMQ's [analysis of the messaging technology market](http://www.zeromq.org/whitepapers:market-analysis)

 * Pieter Hintjens's [background to AMQP](http://www.openamq.org/doc:amqp-background)

 * Barry Pederson's [py-amqplib](http://barryp.org/software/py-amqplib/)

 * Ben Hood on [writing an AMQP client](http://hopper.squarespace.com/blog/2008/6/21/build-your-own-amqp-client.html)

 * Dmitriy Samovskiy introduces [Ruby + QPid + RabbitMQ](http://somic-org.homelinux.org/blog/2008/06/24/ruby-amqp-rabbitmq-example/)

 * Ben Hood's [as3-amqp](http://github.com/0x6e6562/as3-amqp) ([two](http://hopper.squarespace.com/blog/2008/7/4/server-side-as3.html), [three](http://hopper.squarespace.com/blog/2008/3/24/as3-amqp-client-first-cut.html))

 * RabbitMQ's [AMQP protocol code generator](http://hg.rabbitmq.com/rabbitmq-codegen/)

 * Erlang Exchange [presentation on the implementation of RabbitMQ](http://skillsmatter.com/podcast/erlang/presenting-rabbitmq-an-erlang-based-implementatio-nof-amqp) (and on the [LShift blog](http://www.lshift.net/blog/2008/07/01/slides-from-our-erlang-exchange-talk))

 * Jonathan Conway's series on RabbitMQ and using it with Ruby and Merb: [One](http://jaikoo.com/2007/9/4/didn-t-you-get-the-memo), [Two](http://jaikoo.com/2008/2/29/friday-round-up-2008-02-29), [Three](http://jaikoo.com/2008/3/14/oh-hai-rabbitmq), [Four](http://jaikoo.com/2008/3/20/daemonize-rabbitmq)

 * Open Enterprise's series on messaging middleware and AMQP: [Part 1](http://www1.interopsystems.com/analysis/can-amqp-break-ibms-mom-monopoly-part-1.html), [Part 2](http://www1.interopsystems.com/analysis/can-amqp-break-ibms-mom-monopoly-part-2.html), [Part 3](http://www1.interopsystems.com/analysis/can-amqp-break-ibms-mom-monopoly-part-3.html)

Messaging and distributed systems resources
-------------------------------------------

 * [A Critique of the Remote Procedure Call Paradigm](http://www.cs.vu.nl/~ast/publications/euteco-1988.pdf)

 * [A Note on Distributed Computing](http://research.sun.com/techrep/1994/smli_tr-94-29.pdf)

 * [Convenience Over Correctness](http://steve.vinoski.net/pdf/IEEE-Convenience_Over_Correctness.pdf)

 * [Metaprotocol Taxonomy and Communications Patterns](http://hessian.caucho.com/doc/metaprotocol-taxonomy.xtp)

 * Joe Armstrong on [Erlang messaging vs RPC](http://armstrongonsoftware.blogspot.com/2008/05/road-we-didnt-go-down.html)

 * [SEDA: scalable internet services using message queues](http://www.eecs.harvard.edu/~mdw/papers/seda-sosp01.pdf)