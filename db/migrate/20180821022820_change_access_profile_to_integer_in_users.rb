class ChangeAccessProfileToIntegerInUsers < ActiveRecord::Migration[5.2]
  def up
    execute 'ALTER TABLE users ALTER COLUMN access_profile TYPE integer USING (access_profile::integer)'
  end

  def down
    execute 'ALTER TABLE users ALTER COLUMN access_profile TYPE text USING (access_profile::text)'
  end
end
