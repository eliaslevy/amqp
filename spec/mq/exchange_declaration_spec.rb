# encoding: utf-8

require 'spec_helper'

describe MQ do

  #
  # Environment
  #

  include AMQP::Spec

  default_timeout 5

  amqp_before do
    @channel = MQ.new
  end


  #
  # Examples
  #

  describe "#direct" do
    context "when exchange name is specified" do
      it 'declares a new direct exchange with that name' do
        @channel.direct('name').name.should == 'name'
        done
      end
    end

    context "when exchange name is omitted" do
      it 'uses amq.direct' do
        @channel.direct.name.should == 'amq.direct'
        done
      end # it
    end # context

    context "when exchange name was specified as a blank string" do
      it 'returns direct exchange with server-generated name' do
        pending <<-EOF
      This has to be fixed in RabbitMQ first
      https://bugzilla.rabbitmq.com/show_bug.cgi?id=23509
    EOF
        @channel.direct("") do |exchange|
          exchange.name.should_not be_empty
          done
        end
      end
    end # context
  end # describe




  describe "#fanout" do
    context "when exchange name is specified" do
      let(:name) { "new.fanout.exchange" }

      it "declares a new fanout exchange with that name" do
        exchange = @channel.fanout(name)

        exchange.name.should == name

        done
      end
    end # context

    context "when exchange name is omitted" do
      it "uses amq.fanout" do
        exchange = @channel.fanout
        exchange.name.should == "amq.fanout"
        exchange.name.should_not == "amq.fanout2"

        done
      end
    end # context
  end # describe




  describe "#topic" do
    context "when exchange name is specified" do
      let(:name) { "a.topic.exchange" }

      it "declares a new topic exchange with that name" do
        exchange = @channel.topic(name)
        exchange.name.should == name

        done
      end
    end # context

    context "when exchange name is omitted" do
      it "uses amq.topic" do
        exchange = @channel.topic
        exchange.name.should == "amq.topic"
        exchange.name.should_not == "amq.topic2"

        done
      end
    end # context
  end # describe
end # describe MQ