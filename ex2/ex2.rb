require "csv"
require "active_record"
require "activerecord-import"
require "benchmark"

# users =["Dang Hoang Phong",
#     "phongpro123@gmail.com", 
#     "0987654321", 
#     "Ho Chi Minh", 
#     "2001/01/01", 
#     "Like TV 100\", Some special charactor: \ / ' $ ~ & @ # ( ; \""
# ]

filename = 'profiles.csv'

ActiveRecord::Base.establish_connection(
    adapter:"postgresql",
    host: "localhost",
    username:"pill",
    password:"19522009",
    database:"postgres"
)

class User < ActiveRecord::Base
end

# CSV.open(filename, "w+") do |csv|
#     for i in 1..500000 do
#         csv << ["Dang Hoang Phong","phongpro123@gmail.com", "0987654321", "Ho Chi Minh", "2001/01/01","Like TV 100\", Some special charactor: \\ / ' $ ~ & @ # ( ; "]
#     end
# end

#================================================================
# start = Time.now
# CSV.read(filename)
# finish = Time.now
# puts "Read time #{finish-start}"
#================================================================


# File.open(Rails.root.join('profiles.csv'), 'r') do |file|
#     Post.connection.raw_connection.copy_data %{copy post_imports from stdin with csv delimiter ',' quote '"'} do
#       while line = file.gets do
#         Post.connection.raw_connection.put_copy_data line
#       end
#     end
# end


def execute_statement(sql)
    results = ActiveRecord::Base.connection.execute(sql)
    if results.present?
      return results
    else
      return nil
    end
end


start = Time.now
CSV.foreach("profiles.csv") do |row|

    execute_statement("insert into users values ('#{row[0]}', '#{row[1]}', '#{row[2]}','#{row[3]}', '#{row[4]}','#{row[5]}')")
    break
end

finish = Time.now
puts "Write time #{finish-start}"
# A có vài góp ý nhỏ:
# 1. Hàm kết nối Postgres e nên viết ra 1 file or 1 hàm khác để dễ quản lý
# 2. A đang thấy e đọc từng dòng và insert từng dòng vào db -> đóng mở kết nối nhiều lần, sẽ take time
# 3. Dòng 64: break, theo lý thuyết là đâu cần break chổ này đâu e nhỉ?
# 4. Em đã khai báo filename ở trên rồ
