class DgImport < ActiveRecord::Base
  has_many :dg_ratings, :dependent => :destroy

  def type_label
    if self.import_type=='HD'
      'Health Department'
    else
      'Old Rating CSV'
    end
  end
end