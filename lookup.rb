def get_command_line_argument
   if ARGV.empty?
     puts "Usage: ruby lookup.rb <domain>"
     exit
   end
   ARGV.first
 end
 
domain = get_command_line_argument
dns_raw = File.readlines("zone");

def parse_dns(dns_raw)
  hash={}
  x=1
  dns_raw.each do |line|
    if(line[0]=="#" or line[0]=="\n")
      dns_raw.delete(line)
    end
  end
  dns_raw.each do |line|
    line=(line.strip).split(", ")
    hash[x.to_s]=line
    x=x+1
  end
  return hash
end


def resolve(dns_records, lookup_chain, domain)
  arr=[]
  dns_records.each do |key,value|
    if value[0] ==="A" && value[1] == domain 
      return lookup_chain << value[2]
    elsif value[0]=== "CNAME" && value[1] == domain
      lookup_chain<<value[2]
      return resove(dns_records, lookup_chain, value[2] )
    end
  end
  if(arr.include?(domain) ===false)
    return lookup_chain<<"Error: record not found for #{domain}"
  end
  return lookup_chain
end

dns_records = parse_dns(dns_raw)
lookup_chain = [domain]
lookup_chain = resolve(dns_records, lookup_chain, domain)
puts lookup_chain.join(" => ")