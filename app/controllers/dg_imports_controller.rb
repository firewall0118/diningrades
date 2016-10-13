class DgImportsController < ApplicationController
  load_and_authorize_resource except: [:show]
  layout 'admin'

  def index
    authorize! :manage, Restaurant
    @csv_files = DgImport.all
  end

  def new
  end

  def create
    uploaded_csv = params[:csv]
    license_id = params[:license_id].to_sym
    title = params[:title].to_sym
    address = params[:address].to_sym
    city = params[:city].to_sym
    state = params[:state].to_sym
    zip = params[:zip].to_sym
    telephone = params[:telephone].to_sym
    dateOfinspection = params[:dateOfinspection].to_sym
    cleanliness_rating = params[:cleanliness_rating].to_sym
    lon = params[:lon].to_sym
    lat = params[:lat].to_sym

    notice = ''
    if uploaded_csv
      add_num = 0
      update_num = 0
      error_num = 0

      import = DgImport.create(file_name: uploaded_csv.original_filename,
                          import_type: 'HD')

      CSV.parse(uploaded_csv.read, :headers => true).each_with_index do |line, i|
        row = line.to_hash.symbolize_keys!
        
        if row[license_id].present? and row[title].present? and row[address].present?
          #res = DgRating.where(license_id: row[license_id]).last
          rating = row[cleanliness_rating].to_i / 20.0
          begin
            phone = ''
            if row[telephone].present?
              phone = row[telephone].gsub /[()\-\s+]/, ''
            end
            lon_val = row[lon].nil? ? 0 : "%0.6f" % row[lon].to_d
            lat_val = row[lat].nil? ? 0 : "%0.6f" % row[lat].to_d
            res = DgRating.new(license_id: row[license_id],
                                restaurant_name: row[title],
                                address: row[address],
                                city: row[city],
                                state: row[state],
                                zip: row[zip],
                                telephone: phone,
                                dateOfDine: row[dateOfinspection],
                                cleanliness_rating: rating,
                                satisfaction_rating: rating,
                                recommendation_rating: rating,
                                lon: lon_val,
                                lat: lat_val,
                                dg_import_id: import.id)

            res.save!
            add_num += 1
          rescue Exception => e
            error_num += 1
          end
        else
          error_num += 1
        end
      end
      notice = "Inserted #{add_num} rows, and had #{error_num} errors"

      import.update_attributes(total: add_num + update_num + error_num,
                              insert_cnt: add_num,
                              update_cnt: update_num,
                              error_cnt: error_num)
    else
      notice = 'csv file is empty'
    end

    redirect_to dg_imports_path, notice: notice
    
  end

  def destroy
    import_csv = DgImport.find(params[:id])
    import_csv.destroy

    redirect_to dg_imports_url, notice: 'Imported file was successfully destroyed.'
  end

end