Sequel.migration do
  change do
    alter_table(:ratings) do
      drop_foreign_key [:user_id]
    end
  end
end
