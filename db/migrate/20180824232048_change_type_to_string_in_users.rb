class ChangeTypeToStringInUsers < ActiveRecord::Migration[5.2]
  def up
    execute 'ALTER TABLE users ALTER COLUMN type TYPE text USING (type::text)'
  end

  def down
    execute 'ALTER TABLE users ALTER COLUMN type TYPE integer USING (type::integer)'
  end
end
