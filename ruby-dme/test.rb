
require 'dnsmadeeasy-rest-api'
api = DnsMadeEasy.new(ENV['PERSONAL_DME_AKEY'], ENV['PERSONAL_DME_SKEY'])
domain = 'johncheng.com'


rrs = api.records_for(domain)
  rrs.each{ |rr| 
  puts rr
}

#api.create_record(domain, 'wefweftest', 'CNAME', 'bus', { 'ttl' => '60' })
#record_id = api.find_record_id(domain, 'wefweftest', 'CNAME')
#puts record_id
#api.delete_record(domain, 27479598)