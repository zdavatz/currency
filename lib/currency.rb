#!/usr/bin/env ruby
# Currency -- de.oddb.org -- 22.11.2011 -- mhatakeyama@ywesee.com
# Currency -- de.oddb.org -- 26.02.2007 -- hwyss@ywesee.com

require 'thread'
require 'net/http'

module Currency
  @rates = {}
  @mutex = Mutex.new
  def Currency.extract_rate(html)
    if(match = /\<span class=bld\>(\d+\.\d+) \w+\<\/span\>/.match(html))
      match[1]
    end
  end
  def Currency.get_html(origin, target)
    Net::HTTP.start('www.google.com') { |session|
      session.get("/finance/converter?a=1&from=#{origin.upcase}&to=#{target.upcase}").body
    }
  end
  def Currency.rate(origin, target)
    origin = origin.to_s.upcase[/^[A-Z]{3}/]
    target = target.to_s.upcase[/^[A-Z]{3}/]
    return 1.0 if(origin == target)
    @rates[[origin, target]] \
      || ((rate = @rates[[target, origin]]) && (1.0 / rate)) \
      || update_rate(origin, target)
  end
  def Currency.run_updater
    Thread.new { 
      loop do
        update
        sleep(24*60*60)
      end
    }
  end
  def Currency.update
    @rates.each_key { |pair| update_rate(*pair) }
  end
  def Currency.update_rate(origin, target)
    if(rate = extract_rate(get_html(origin, target)))
      @rates[[origin, target]] = rate.to_f
    end
  end
end
