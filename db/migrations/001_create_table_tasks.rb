Sequel.migration do
  change do
    create_table(:tasks) do
      primary_key :id
      String :description, null: false
      String :tag, null: false
    end
  end
end
