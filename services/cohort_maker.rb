require 'csv'

class CohortMaker
  attr_accessor :cohort, :primary_attribute

  def initialize(cohort, primary_attribute, path = nil)
    @cohort = cohort

    path = get_path
    verify_path(path)

    @csv_array = CSV.foreach(path)
    @primary_attribute = primary_attribute
    @primary_attribute_index = @csv_array.first.index(primary_attribute.to_s)
    @member_attributes_array = @csv_array.first

    create_memberships_from_csv
  end

  def verify_path(path)
    if !path
      raise NoPathError.new("Could not parse CSV because no file path was given.")
    end
  end

  def get_path
    if @cohort.roster_csv
      @cohort.roster_csv.path
    end
  end

  def create_memberships_from_csv
    @csv_array.each.with_index(1) do |row, index|
      member = create_or_update_user_from_csv(row)
      Membership.create(user_id: member.id, cohort_id: cohort.id)
    end
  end

  def create_or_update_user_from_csv(row)
    User.where(@primary_attribute => row[@primary_attribute_index]).first_or_initialize.tap do |user|
      @member_attributes_array.compact.each_with_index do |attribute, index|
        user.send(attribute + '=', row[index])
      end
      user.save
    end
  end

end

class NoPathError < StandardError
end
