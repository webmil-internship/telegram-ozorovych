Sequel.migration do
  change do
    create_table(:ratings) do
      primary_key :id
      String :user_id, null: false
      String :task_id, null: false
      String :propability, null: false
    end
  end
end
