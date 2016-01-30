#!/usr/bin/env ruby

### neighborhood options ###
## using ##
# downtown: battery-park-city, chelsea, east-village, financial-district, flatiron,
# gramercy-park, greenwich-village, les, soho, tribeca, west-village
# midtown: midtown, kips-bay*, murray-hill, sutton-place, turtlebay, midtown-south,
# midtown-west, central-park-south*

# * -> below 50 entries (for listed)

## excluded ##
# downtown: chinatown, civic-center, little-italy, nolita, stuyvesant-town

require 'open-uri'
require 'json'
require 'optparse'

# could be combined to 1 function.......
def get_pages(neighborhood, base_opts)
	url = "http://streeteasy.com/for-sale/" + neighborhood + base_opts
	f = open(url)
	query = 'dataLayer'
	matches = f.select { |x| x[/#{query}/i] }
	myjson = matches[0]
	myjson = myjson[15...-3]
	parsed = JSON.parse(myjson)
	pages = (parsed['searchResults']/12).ceil
	f.close
	return pages
end

def create_json(neighborhood, search_opts)
	url = "http://streeteasy.com/for-sale/" + neighborhood + search_opts
	f = open(url)
	query = 'dataLayer'
	matches = f.select { |x| x[/#{query}/i] }
	myjson = matches[0]
	myjson = myjson[15...-3]
	parsed = JSON.parse(myjson)
	results = parsed["searchResultsListings"]
	# puts JSON.pretty_generate(results)
	f.close
	return results
end

def write_data(file, data, prewar)
	samples = Array.new

	data.drop(2).each do |a|
		# duplicated 'featured' listings at top of each page
		a.each do |res|
			if res['addr_zip'] != nil
				title = res['title']
				price = res['price']
				zip = res['addr_zip']
				sqft = res['size_sqft']
				bed = res['bedrooms']
				bath = res['bathrooms']
				retval = [title,zip,sqft,bed,bath,prewar,price].join(',')
				samples.push(retval)
			end
		end
	end

	samples.each do |sample|
		# puts sample
		file.write(sample)
		file.write("\n")
	end
end

def parse_listings(file, neighborhood, opts, prewar)
	pages = get_pages(neighborhood, opts)
	puts "number of pages to read: #{pages}"

	for i in 1..pages
		puts "reading page #{i}"
		search_opts = opts + "?page=#{i}"
		results = create_json(neighborhood, search_opts)
		write_data(file, results, prewar)
	end
end

options = {:neighborhood => "soho", :sold => 0}

optsparser = OptionParser.new do |opts|
	opts.on("-n", "--neighborhood neighborhood", String) do |input|
		options[:neighborhood] = input
	end

	opts.on("-s", "--sold sold", Integer) do |input|
		options[:sold] = input
	end
end
optsparser.parse!

neighborhood = options[:neighborhood]
sold = options[:sold]
puts "parsing listings for #{neighborhood}"
base_opts = '/status:'
if(sold.zero?)
	base_opts << 'listed'
else
	base_opts << 'sold'
end
base_opts << '%7Cppsf:100-5000' # price per sqft option so that only those with known sqft are shown
prewar_opts = base_opts + '%7Cbuilding_year:1900-1939'
postwar_opts = base_opts + '%7Cbuilding_year:1940-2015' # building year

target = 'data/' + neighborhood + '.csv'
file = File.open(target, 'a')
if File.zero?(file)
	file.write("title,addr_zip,size_sqft,bedrooms,bathrooms,prewar,price\n")
end

puts 'parsing prewar listings'
parse_listings(file, neighborhood, prewar_opts, 1)
puts 'parsing postwar listings'
parse_listings(file, neighborhood, postwar_opts, 0)

file.close
file = File.open(target, 'r')
puts "number of entries in #{target}: #{file.readlines.size - 1}"
file.close
