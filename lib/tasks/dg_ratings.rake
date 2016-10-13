require "csv"

namespace :dg_ratings do
  desc "Import DiningGrades Ratings"
  task :import_csv => :environment do
    header = []
    csv_file = 'dg_ratings_20150901.csv'
    #csv_file = 'dg_ratings_test.csv'
    add_num = 0
    update_num = 0
    error_num = 0

    import = DgImport.create(file_name: csv_file,
                        import_type: 'OR')

    File.foreach("lib/tasks/data/#{csv_file}").with_index do |csv_line, idx|

      row = CSV.parse(csv_line.gsub('\"', '""')).first

      if header.empty?
        header = row.map(&:to_sym)
        next
      end
      
      row = Hash[header.zip(row)]

      begin
        lon = row[:lon].nil? ? 0 : "%0.6f" % row[:lon].to_d
        lat = row[:lat].nil? ? 0 : "%0.6f" % row[:lat].to_d

        rating = DgRating.new(bill: row[:bill],
                                    dateOfDine: row[:dateOfDine],
                                    comments: row[:comments],
                                    response: row[:response],
                                    ip_addr: row[:ip_addr],
                                    source: row[:source],
                                    timestamp: row[:timestamp],
                                    cleanliness_rating: row[:cleanliness_rating].to_i / 20.0,
                                    satisfaction_rating: row[:satisfaction_rating].to_i / 20.0,
                                    recommendation_rating: row[:recommendation_rating].to_i / 20.0,
                                    restaurant_name: row[:restaurant_name],
                                    email: row[:email],
                                    store_number: row[:store_number],
                                    telephone: row[:telephone],
                                    address: row[:address],
                                    city: row[:city],
                                    state: row[:state],
                                    zip: row[:zip],
                                    lat: lat,
                                    lon: lon,
                                    dg_import_id: import.id)
        rating.save!
        add_num += 1
        puts "line #{idx + 2} inserted"
      rescue Exception => e
        error_num += 1
        puts "line #{idx + 2} error"
      end
    end

    import.update_attributes(total: add_num + update_num + error_num,
                            insert_cnt: add_num,
                            update_cnt: update_num,
                            error_cnt: error_num)

    puts "Inserted #{add_num} rows, and had #{error_num} errors"
  end

  desc "Calculate the restaurant rating with imported csv, health department, and user feedback"
  task :recalculate_restaurant_rating => :environment do
    restaurants = Restaurant.all
    restaurants.each do |r|
      puts "Update #{r.name}"
      user_rating_size = r.find_votes_for(:vote_scope => 'satisfaction').size.to_f
      user_satisfaction_total = r.find_votes_for(:vote_scope => 'satisfaction').sum(:vote_weight)
      user_recommendation_total = r.find_votes_for(:vote_scope => 'recommendation').sum(:vote_weight)

      tel = ''
      if r.tel
        tel = r.tel.gsub /[()\-\s+]/, ''
      end
      dg_ratings = DgRating.where("restaurant_id = ? OR (telephone <> '' AND telephone = ?) OR (lat = ? AND lon = ?) OR (restaurant_name = ? AND city = ? AND state = ?)", 
                                r.id,
                                tel, 
                                r.latitude, 
                                r.longitude,
                                r.name,
                                r.locality,
                                r.region)
      import_satisfaction_total = 0
      import_recommendation_total = 0
      import_rating_size = 0
      if dg_ratings.present?
        import_satisfaction_total = dg_ratings.sum(:satisfaction_rating)
        import_recommendation_total = dg_ratings.sum(:recommendation_rating)
        import_rating_size = dg_ratings.count

        dg_ratings.update_all(:restaurant_id => r.id)
      end

      total_s = user_satisfaction_total + import_satisfaction_total
      total_r = user_satisfaction_total + import_recommendation_total
      total_cnt = user_rating_size + import_rating_size
      if total_cnt > 0
        r.update_attributes(total_satisfaction: total_s,
                                    total_recommendation: total_r,
                                    rating_count: total_cnt,
                                    satisfaction: total_s / total_cnt.to_d,
                                    recommendation: total_r / total_cnt.to_d)
      else
        r.update_attributes(total_satisfaction: 0,
                                    total_recommendation: 0,
                                    rating_count: 0,
                                    satisfaction: 0,
                                    recommendation: 0)
      end
    end
  end
end