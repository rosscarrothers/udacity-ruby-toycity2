require 'json'
require 'date'

# Get path to products.json, read the file into a string,
# transform the string into a usable hash, and create an empty report file
def setup_files
  path = File.join(File.dirname(__FILE__), '../data/products.json')
  file = File.read(path)
  
  # Dollar sign marks the variables as global so they can be used elsewhere
  $products_hash = JSON.parse(file)
  $report_file = File.new("report.txt", "w+")
end

def print_heading
  # Print "Sales Report" in ascii art
  $report_file.puts "  ______             __                            _______                                             __     "    
  $report_file.puts " /      \           /  |                          /       \                                           /  |    "   
  $report_file.puts "/$$$$$$  |  ______  $$ |  ______    _______       $$$$$$$  |  ______    ______    ______    ______   _$$ |_   "  
  $report_file.puts "$$ \__$$/  /      \ $$ | /      \  /       |      $$ |__$$ | /      \  /      \  /      \  /      \ / $$   |  " 
  $report_file.puts "$$      \  $$$$$$  |$$ |/$$$$$$  |/$$$$$$$/       $$    $$< /$$$$$$  |/$$$$$$  |/$$$$$$  |/$$$$$$  |$$$$$$/   "
  $report_file.puts " $$$$$$  | /    $$ |$$ |$$    $$ |$$      \       $$$$$$$  |$$    $$ |$$ |  $$ |$$ |  $$ |$$ |  $$/   $$ | __ "
  $report_file.puts "/  \__$$ |/$$$$$$$ |$$ |$$$$$$$$/  $$$$$$  |      $$ |  $$ |$$$$$$$$/ $$ |__$$ |$$ \__$$ |$$ |        $$ |/  |"
  $report_file.puts "$$    $$/ $$    $$ |$$ |$$       |/     $$/       $$ |  $$ |$$       |$$    $$/ $$    $$/ $$ |        $$  $$/ "
  $report_file.puts " $$$$$$/   $$$$$$$/ $$/  $$$$$$$/ $$$$$$$/        $$/   $$/  $$$$$$$/ $$$$$$$/   $$$$$$/  $$/          $$$$/  "
  $report_file.puts "                                                                      $$ |                                    "
  $report_file.puts "                                                                      $$ |                                    "
  $report_file.puts "                                                                      $$/                                     "

  # Print today's date
  $report_file.puts "Date: #{Date.today}\n"
end

def print_products_header
  # Print "Products" in ascii art
  $report_file.puts "                     _            _       "
  $report_file.puts "                    | |          | |      "
  $report_file.puts " _ __  _ __ ___   __| |_   _  ___| |_ ___ "
  $report_file.puts "| '_ \\| '__/ _ \\ / _` | | | |/ __| __/ __|"
  $report_file.puts "| |_) | | | (_) | (_| | |_| | (__| |_\\__ \\"
  $report_file.puts "| .__/|_|  \\___/ \\__,_|\\__,_|\\___|\\__|___/"
  $report_file.puts "| |                                       "
  $report_file.puts "|_|                                       \n\n"                                                                          
end

def print_product_data
  # For each product in the data set:
  $products_hash["items"].each do | item |
    # Print the name of the toy
    $report_file.puts item["title"]

    # Print the retail price of the toy
    full_price = item["full-price"]
    $report_file.puts "Full price: $#{full_price}"

    # Calculate and print the total number of purchases
    number_of_purchases = item["purchases"].length 
    $report_file.puts "Number of purchases: #{number_of_purchases}"

    # Calculate and print the total amount of sales
    total_sales = 0
    item["purchases"].each do | sale |
      total_sales += sale["price"]
    end 
    $report_file.puts "Total sales: $#{total_sales}"

    # Calculate and print the average price the toy sold for
    average_price = total_sales / number_of_purchases
    $report_file.puts "Average price: $#{average_price}"

    # Calculate and print the average discount (% or $) based off the average sales price
    average_discount = full_price.to_f - average_price
    $report_file.puts "Average discount: $#{format("%.2f", average_discount)}\n\n"
  end
end

def make_products_section
  # Print a header
  print_products_header
 
  # Print out the product sales data
  print_product_data
end

def print_brands_header
  # Print "Brands" in ascii art
  $report_file.puts " _                         _     "
  $report_file.puts "| |                       | |    "
  $report_file.puts "| |__  _ __ __ _ _ __   __| |___ "
  $report_file.puts "| '_ \\| '__/ _` | '_ \\ / _` / __|"
  $report_file.puts "| |_) | | | (_| | | | | (_| \\__ \\"
  $report_file.puts "|_.__/|_|  \\__,_|_| |_|\\__,_|___/"
  $report_file.puts                                                            
end

def print_brands_data
  # Keep track of brand data as we go
  brands = { }

  # For each product in the data set:
  $products_hash["items"].each do | item |

    # Calculate the total amount of sales
    total_sales = 0
    item["purchases"].each do | sale |
      total_sales += sale["price"]
    end 

    # If this is the first time we've seen this brand, add it to the hash with some default values
    if brands[item["brand"]] == nil
      brands[item["brand"]] = {
        number_of_toys: 0,
        total_toy_price: 0.0,
        total_sales_revenue: 0.0
      }
    end

    # We can safely assume here that the brand already has an entry in the hash, let's update its data
    item_brand = brands[item["brand"]]
    item_brand[:number_of_toys] += 1
    item_brand[:total_toy_price] += item["full-price"].to_f
    item_brand[:total_sales_revenue] += total_sales
  end

  # Now output the brand data
  # For each brand in the data set:
  brands.each do | brand_name, data |
    # Print the name of the brand
    $report_file.puts "Brand: #{brand_name}"

    # Count and print the number of the brand's toys we stock
    $report_file.puts "Number of toys: #{data[:number_of_toys]}"

    # Calculate and print the average price of the brand's toys
    average_toy_price = data[:total_toy_price] / data[:number_of_toys]
    $report_file.puts "Average toy price: $#{format("%.2f", average_toy_price)}"

    # Calculate and print the total revenue of all the brand's toy sales combined
    $report_file.puts "Total sales revenue: $#{format("%.2f", data[:total_sales_revenue])}\n\n"
  end
end

def make_brands_section
  # Print a header
  print_brands_header

  # Print out brand sales data
  print_brands_data
end

def print_data
  # Print product sales data
  make_products_section

  # Print brand sales data
  make_brands_section
end

def create_report
  print_heading
  print_data
end

def start 
  setup_files # load, read, parse, and create the files
  create_report # create the report!
  $report_file.close
end

# Run the program
start