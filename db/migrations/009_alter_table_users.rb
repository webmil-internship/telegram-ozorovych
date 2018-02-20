Sequel.migration do
  change do
    alter_table(:users) do
      rename_column(:user_id, :user_name)
    end
  end
end
