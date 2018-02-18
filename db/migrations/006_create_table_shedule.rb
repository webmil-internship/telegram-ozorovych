Sequel.migration do
  change do
    create_table(:schedule) do
      primary_key :id
      String :tag, null: false
      Date :date, null: false
    end
  end
end
