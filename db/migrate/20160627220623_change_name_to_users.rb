class ChangeNameToUsers < ActiveRecord::Migration
  def change
    change_column_null :users, :fullname, false, nil
  end
end
