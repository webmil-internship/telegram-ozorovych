Sequel.migration do
  change do
    rename_table(:schedule, :schedules)
  end
end
