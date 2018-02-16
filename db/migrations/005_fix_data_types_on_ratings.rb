Sequel.migration do
  change do
    alter_table(:ratings) do
      set_column_type :user_id, :Fixnum
      set_column_type :task_id, :Fixnum
    end
  end
end
