Sequel.migration do
  change do
    alter_table(:ratings) do
      add_foreign_key [:user_id], :users
      add_foreign_key [:task_id], :tasks
    end
  end
end
