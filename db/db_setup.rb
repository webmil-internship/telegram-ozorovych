DB = Sequel.connect(ENV.fetch('DATABASE_CONNECTION'))
Sequel::Model.raise_on_save_failure = false
