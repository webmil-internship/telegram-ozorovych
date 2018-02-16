Sequel.migration do
  change do
    alter_table(:users) do
      set_column_type :user_id, :Fixnum
      set_column_type :chat_id, :Fixnum
    end
  end
end
