#|===========================================================|
#|===== Read time using csv.read 6.812354835            =====|
#|===== Import time using pg query command: 0.944044474 =====|
#|===========================================================|
#Read time is not related to import time!

require 'pg'
require "csv"
#Write to CSV file
users =["Dang Hoang Phong",
    "phongpro123@gmail.com", 
    "0987654321", 
    "Ho Chi Minh", 
    "2001/01/01", 
    '"Like TV 100", "Some special charactor: \ / \' $ ~ & @ # ( ; "'
]

CSV.open('profiles.csv', "w") do |csv|
    for i in 1..500000 do
        csv << [users[0],users[1],users[2],users[3],users[4],users[5]]
    end
end

#read file
start = Time.now
CSV.read('profiles.csv')
finish = Time.now
puts "Read time #{finish-start}"

#Query
begin
    #Connect to database
    con = PG.connect :dbname => 'postgres', :user => 'pill', :password => '19522009'

    #con.exec "CREATE TABLE users (name text, email text, phone text, address text,day_of_birth text, profile text)"

    #Import CSV file into database
    start = Time.now
    rs = con.exec "COPY users FROM '/home/pill/Documents/Intern_Exercises/ex2/profiles.csv' DELIMITER ',' CSV HEADER"
    finish = Time.now
    puts "Import time: #{finish-start}"

rescue PG::Error => e
    puts e.message 
ensure
    con.close if con
end

# A có vài góp ý
# 1. 500k e có thể viết thành 500_000 cho dễ đọc 
# 2. Hàm connect db e có thể viết trong 1 hàm hoặc 1 file khác, và file chính của mình chỉ gọi để thực thi
# 3. Khi e chạy có thể drop table if exists trước, rồi create table để đảm bảo lần đầu hay lần n code của e đều chạy được kg cần comment
