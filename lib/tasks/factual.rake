namespace :factual do
  desc "Load restaurants from factual"
  task :read_restaurant => :environment do
    require 'factual'

    key = "TYOKElzH8YJqtAaK7Z9AWyJ6JCE1bf4VwFXszNsO"
    secret = "merc447tmFGzQ9qfrIj32tAukGOfJdWgGFn9YpLI"
    factual = Factual.new(key, secret)

    restaurants = factual.table("places-us").filters("category_ids" => {"$includes_any" => [312, 347]}).rows
  end
  
end