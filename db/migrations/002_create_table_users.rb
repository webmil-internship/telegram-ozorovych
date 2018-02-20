Sequel.migration do
  change do
    create_table(:users) do
      primary_key :id
      String :user_name, null: false
      String :chat_id, null: false
    end
  end
end
